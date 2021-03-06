package com.bx.ant.service.allocation;

import com.bx.ant.pageModel.*;
import com.bx.ant.service.*;
import com.bx.ant.service.qimen.QimenRequestService;
import com.bx.ant.service.session.TokenServiceI;
import com.mobian.absx.F;
import com.mobian.exception.ServiceException;
import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.MbShop;
import com.mobian.pageModel.PageHelper;
import com.mobian.thirdpart.mns.MNSTemplate;
import com.mobian.thirdpart.mns.MNSUtil;
import com.mobian.util.ConvertNameUtil;
import com.mobian.util.GeoUtil;
import net.sf.json.JSONArray;
import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate4.HibernateTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.*;

/**
 * Created by john on 17/10/11.
 */
@Service
public class DeliverOrderAllocationServiceImpl implements DeliverOrderAllocationServiceI {

    private Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private DeliverOrderServiceI deliverOrderService;

    @Autowired
    private ShopDeliverApplyServiceI shopDeliverApplyService;

    @Autowired
    private DeliverOrderShopServiceI deliverOrderShopService;

    @Autowired
    private HibernateTransactionManager transactionManager;

    @Resource
    private TokenServiceI tokenService;

    @Autowired
    private QimenRequestService qimenRequestService;

    @Override
    public void orderAllocation() {

        //1、获取待分配的订单
        DeliverOrderExt request = new DeliverOrderExt();
        PageHelper ph = new PageHelper();
        ph.setHiddenTotal(true);
        request.setStatusList(new String[]{DeliverOrderServiceI.STATUS_NOT_ALLOCATION, DeliverOrderServiceI.STATUS_SHOP_REFUSE});
        DataGrid dataGrid = deliverOrderService.dataGrid(request, ph);
        List<DeliverOrder> deliverOrderList = dataGrid.getRows();

        // 1.1、获取万里牛未处理订单
        request = new DeliverOrderExt();
        request.setIsdeleted(true);
        request.setOriginalOrderStatus(DeliverOrderServiceI.ORIGINAL_ORDER_STATUS_OTS01);
        dataGrid = deliverOrderService.dataGrid(request, ph);
        if(CollectionUtils.isNotEmpty(dataGrid.getRows())) {
            deliverOrderList.addAll(dataGrid.getRows());
        }

        for (DeliverOrder deliverOrder : deliverOrderList) {
            try{
                allocationOrderOwnerShopId(deliverOrder);
            }catch(Exception e){
                logger.error("分单失败", e);

            }
        }
    }
    //PROPAGATION_REQUIRES_NEW
    public void allocationOrderOwnerShopId(DeliverOrder deliverOrder) {
        //2、查开通了派单功能，且状态开启配送的门店List
        List<ShopDeliverApply> shopDeliverApplyList = shopDeliverApplyService.getAvailableAndWorkShop();

        //3、计算待分配订单的数字地址
        if ((deliverOrder.getLongitude() == null || deliverOrder.getLatitude() == null)
                && !F.empty(deliverOrder.getDeliveryAddress())) {
            BigDecimal[] point = GeoUtil.getPosition(deliverOrder.getDeliveryAddress());
            if(point != null) {
                deliverOrder.setLongitude(point[0]);
                deliverOrder.setLatitude(point[1]);

                // 保存经纬度，防止重复获取,不影响分单逻辑
                try{
                    deliverOrderService.edit(deliverOrder);
                }catch(Exception e){
                    logger.error("保存经纬度失败", e);
                }
            }
        }
        //4、计算最近距离点
//        MbShop minMbShop = null;
//        double minDistance = 0, maxDistance;
        //拒接的状态下，查询拒接过的门店
        List<Integer> excludeShop = new ArrayList<Integer>();
        if (DeliverOrderServiceI.STATUS_SHOP_REFUSE.equals(deliverOrder.getStatus())) {
            DeliverOrderShop deliverOrderShop = new DeliverOrderShop();
            deliverOrderShop.setStatus(DeliverOrderShopServiceI.STATUS_REFUSED);
            List<DeliverOrderShop> deliverOrderShopList = deliverOrderShopService.query(deliverOrderShop);
            for (DeliverOrderShop orderShop : deliverOrderShopList) {
                excludeShop.add(orderShop.getShopId());
            }
        }
        //  查询门店最大配送距离
        double maxDistance = Double.valueOf(ConvertNameUtil.getString("DSV200", "5000"));

        List<ShopDeliverApply> includeShop = new ArrayList<ShopDeliverApply>();
        // 过滤满足距离的门店
        for (ShopDeliverApply shopDeliverApply : shopDeliverApplyList) {
            MbShop mbShop = shopDeliverApply.getMbShop();
            if (excludeShop.contains(mbShop.getId())) continue;

            if(shopDeliverApply.getMaxDeliveryDistance() != null) {
                maxDistance = shopDeliverApply.getMaxDeliveryDistance().doubleValue();
            }

            if(deliverOrder.getLongitude() != null && deliverOrder.getLatitude() != null
                    && deliverOrder.getLongitude().doubleValue() != -1 && deliverOrder.getLatitude().doubleValue() != -1) {
                double distance = GeoUtil.getDistance(deliverOrder.getLongitude().doubleValue(), deliverOrder.getLatitude().doubleValue(), mbShop.getLongitude().doubleValue(), mbShop.getLatitude().doubleValue());

                if (!F.empty(shopDeliverApply.getDistributeRange())) {
                    DistributeRangeMap distributeRangeMap = new DistributeRangeMap();
                    distributeRangeMap.setLng(deliverOrder.getLongitude().doubleValue());
                    distributeRangeMap.setLat(deliverOrder.getLatitude().doubleValue());
                    JSONArray json = JSONArray.fromObject(shopDeliverApply.getDistributeRange());
                    //把json字符串转换成对象
                    List<DistributeRangeMap> distributeRangeMaps = (List<DistributeRangeMap>) JSONArray.toCollection(json, DistributeRangeMap.class);
                    if(!shopDeliverApplyService.chechPointInPolygon(distributeRangeMap, distributeRangeMaps)) continue;
                } else {
                    // maxDistance=-1距离不限
                    if(maxDistance != -1 && distance > maxDistance) continue;
                }

                shopDeliverApply.setDistance(BigDecimal.valueOf(distance));
                includeShop.add(shopDeliverApply);
            } else {
                if(maxDistance == -1) includeShop.add(shopDeliverApply);
            }
        }

        if(CollectionUtils.isNotEmpty(includeShop)) {
            // 排序距离优先
            Collections.sort(includeShop, new Comparator<ShopDeliverApply>() {
                public int compare(ShopDeliverApply arg0, ShopDeliverApply arg1) {
                    return arg0.getDistance().compareTo(arg1.getDistance());
                }
            });

            //5、计算分单价格
            boolean allocationSuccess = false;
            for(ShopDeliverApply shopDeliverApply : includeShop) {
                MbShop mbShop = shopDeliverApply.getMbShop();
                DefaultTransactionDefinition def = new DefaultTransactionDefinition();

                def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);// 事物隔离级别，开启新事务

                TransactionStatus status = transactionManager.getTransaction(def); // 获得事务状态

                try{
                    // 排除代送、强制接单
                    if(!ShopDeliverApplyServiceI.DELIVER_WAY_AGENT.equals(shopDeliverApply.getDeliveryWay())) {
                        if(!DeliverOrderServiceI.DELIVER_TYPE_FORCE.equals(shopDeliverApply.getDeliveryType())
                                && tokenService.getTokenByShopId(mbShop.getId()) == null) throw new ServiceException("门店不在线，token已失效");
                        if(!DeliverOrderServiceI.DELIVER_TYPE_FORCE.equals(shopDeliverApply.getDeliveryType())
                                && (shopDeliverApply.getOnline() == null || !shopDeliverApply.getOnline())) throw new ServiceException("门店停止营业");
                    }
                    String deliverWay = F.empty(deliverOrder.getDeliveryWay()) ? shopDeliverApply.getDeliveryWay() : deliverOrder.getDeliveryWay();
                    if(ShopDeliverApplyServiceI.DELIVER_WAY_CUSTOMER.equals(deliverWay) && ShopDeliverApplyServiceI.DELIVER_WAY_AGENT.equals(shopDeliverApply.getDeliveryWay()))
                        deliverWay = ShopDeliverApplyServiceI.DELIVER_WAY_CUSTOMER_AGENT;

                    deliverOrder.setDeliveryType(shopDeliverApply.getDeliveryType());
                    deliverOrder.setDeliveryWay(deliverWay);
                    deliverOrder.setFreight(shopDeliverApply.getFreight());
                    deliverOrder.setShopId(mbShop.getId());
                    deliverOrder.setShopDistance(shopDeliverApply.getDistance());
                    deliverOrder.setStatus(DeliverOrderServiceI.STATUS_SHOP_ALLOCATION);

                    // 分配万里牛平台订单
                    if(deliverOrder.getIsdeleted()) {
                        deliverOrder.setIsdeleted(false);
                        deliverOrder.setOriginalOrderStatus(DeliverOrderServiceI.ORIGINAL_ORDER_STATUS_OTS02);
                    }

                    deliverOrderService.transform(deliverOrder);

                    // 自动接单||强制接单||代送
                    if(DeliverOrderServiceI.DELIVER_TYPE_AUTO.equals(shopDeliverApply.getDeliveryType()) ||
                            DeliverOrderServiceI.DELIVER_TYPE_FORCE.equals(shopDeliverApply.getDeliveryType()) ||
                            ShopDeliverApplyServiceI.DELIVER_WAY_AGENT.equals(deliverOrder.getDeliveryWay()) ||
                            ShopDeliverApplyServiceI.DELIVER_WAY_CUSTOMER_AGENT.equals(deliverOrder.getDeliveryWay())) {
                        deliverOrder.setStatus(DeliverOrderServiceI.STATUS_SHOP_ACCEPT);
                        deliverOrderService.transform(deliverOrder);
                    }
                    transactionManager.commit(status);

                    // 发送短信通知
                    boolean smsRemind = Integer.valueOf(ConvertNameUtil.getString("DSV101", "0")) == 1 ? true : false;
                    if(shopDeliverApply.getSmsRemind() != null) {
                        smsRemind = shopDeliverApply.getSmsRemind();
                    }
                    if(!F.empty(mbShop.getContactPhone()) && smsRemind) {
                        MNSTemplate template = new MNSTemplate();
                        Map<String, String> params = new HashMap<String, String>();
                        params.put("orderId", "(" + deliverOrder.getId() + ")");
                        params.put("address", deliverOrder.getDeliveryAddress());
                        if(ShopDeliverApplyServiceI.DELIVER_WAY_AGENT.equals(deliverOrder.getDeliveryWay())) {
                            template.setTemplateCode("SMS_117150037");
                        } else {
                            if(DeliverOrderServiceI.DELIVER_TYPE_AUTO.equals(shopDeliverApply.getDeliveryType())) {
                                template.setTemplateCode("SMS_109405064");
                            } else {
                                template.setTemplateCode("SMS_105685061");
                                params.put("time", ConvertNameUtil.getString("DSV100", "10") + "分钟");
                            }
                        }


                        template.setParams(params);
                        MNSUtil.sendMns(mbShop.getContactPhone(), template);
                    }

                    // 给用户发送自提短信通知(注：自提+代送为门店签收时发送短信)
                    if(ShopDeliverApplyServiceI.DELIVER_WAY_CUSTOMER.equals(deliverWay) && !F.empty(deliverOrder.getContactPhone())) {
                        MNSTemplate template = new MNSTemplate();
                        Map<String, String> params = new HashMap<String, String>();
                        template.setTemplateCode("SMS_117170055");
                        params.put("originalOrderId", deliverOrder.getOriginalOrderId());
                        params.put("address", mbShop.getAddress());
                        params.put("contactPeople", mbShop.getContactPeople());
                        params.put("contactPhone", mbShop.getContactPhone());
                        template.setParams(params);
                        MNSUtil.sendMns(deliverOrder.getContactPhone(), template);
                    }
                    allocationSuccess = true;
                    break;
                }catch(Exception e){
                    transactionManager.rollback(status);
                    logger.error("分单失败", e);


                    continue;
                }

            }
            if(!allocationSuccess){
                // 万里牛订单不满足处理
                if(deliverOrder.getIsdeleted()) {
                    deliverOrder.setOriginalOrderStatus(DeliverOrderServiceI.ORIGINAL_ORDER_STATUS_OTS03);
                    deliverOrderService.edit(deliverOrder);
                    qimenRequestService.updateOrderProcessReportRequest(DeliverOrderState.REJECT,deliverOrder);
                }
            }
        }
    }
}
