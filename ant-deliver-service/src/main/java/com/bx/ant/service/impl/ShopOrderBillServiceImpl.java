package com.bx.ant.service.impl;

import com.bx.ant.dao.ShopOrderBillDaoI;
import com.bx.ant.model.TshopOrderBill;
import com.bx.ant.pageModel.*;
import com.bx.ant.service.DeliverOrderServiceI;
import com.bx.ant.service.DeliverOrderShopPayServiceI;
import com.bx.ant.service.ShopOrderBillServiceI;
import com.mobian.absx.F;
import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.MbShop;
import com.mobian.pageModel.PageHelper;
import com.mobian.pageModel.User;
import com.mobian.service.MbShopServiceI;
import com.mobian.service.UserServiceI;
import com.mobian.util.MyBeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class ShopOrderBillServiceImpl extends BaseServiceImpl<ShopOrderBill> implements ShopOrderBillServiceI {

	 @Autowired
	 private ShopOrderBillDaoI shopOrderBillDao;
	 @Resource
	 private MbShopServiceI mbShopService;
	 @Autowired
	 private DeliverOrderServiceI deliverOrderService;
	 @Autowired
	 private DeliverOrderShopPayServiceI deliverOrderShopPayService;
	 @Resource
	 private UserServiceI userService;


	@Override
	public DataGrid dataGrid(ShopOrderBill shopOrderBill, PageHelper ph) {
		List<ShopOrderBill> ol = new ArrayList<ShopOrderBill>();
		String hql = " from TshopOrderBill t ";
		DataGrid dg = dataGridQuery(hql, ph, shopOrderBill, shopOrderBillDao);
		@SuppressWarnings("unchecked")
		List<TshopOrderBill> l = dg.getRows();
		if (l != null && l.size() > 0) {
			for (TshopOrderBill t : l) {
				ShopOrderBill o = new ShopOrderBill();
				BeanUtils.copyProperties(t, o);
				ol.add(o);
			}
		}
		dg.setRows(ol);
		return dg;
	}
	

	protected String whereHql(ShopOrderBill shopOrderBill, Map<String, Object> params) {
		String whereHql = "";	
		if (shopOrderBill != null) {
			whereHql += " where t.isdeleted = 0 ";
			if (!F.empty(shopOrderBill.getTenantId())) {
				whereHql += " and t.tenantId = :tenantId";
				params.put("tenantId", shopOrderBill.getTenantId());
			}		
			if (!F.empty(shopOrderBill.getIsdeleted())) {
				whereHql += " and t.isdeleted = :isdeleted";
				params.put("isdeleted", shopOrderBill.getIsdeleted());
			}		
			if (!F.empty(shopOrderBill.getShopId())) {
				whereHql += " and t.shopId = :shopId";
				params.put("shopId", shopOrderBill.getShopId());
			}		
			if (!F.empty(shopOrderBill.getStatus())) {
				whereHql += " and t.status = :status";
				params.put("status", shopOrderBill.getStatus());
			}		
			if (!F.empty(shopOrderBill.getRemark())) {
				whereHql += " and t.remark = :remark";
				params.put("remark", shopOrderBill.getRemark());
			}		
			if (!F.empty(shopOrderBill.getAmount())) {
				whereHql += " and t.amount = :amount";
				params.put("amount", shopOrderBill.getAmount());
			}		
			if (!F.empty(shopOrderBill.getPayWay())) {
				whereHql += " and t.payWay = :payWay";
				params.put("payWay", shopOrderBill.getPayWay());
			}
			if (shopOrderBill.getStartDate() != null) {
				whereHql += " and t.addtime >= :startDate ";
				params.put("startDate", shopOrderBill.getStartDate());
			}
			if (shopOrderBill.getEndDate() != null) {
				whereHql += " and t.addtime <= :endDate ";
				params.put("endDate", shopOrderBill.getEndDate());

			}

		}	
		return whereHql;
	}

	@Override
	public Long add(ShopOrderBill shopOrderBill) {
		TshopOrderBill t = new TshopOrderBill();
		BeanUtils.copyProperties(shopOrderBill, t);
		//t.setId(jb.absx.UUID.uuid());
		t.setIsdeleted(false);
		shopOrderBillDao.save(t);
		return t.getId();
	}

	@Override
	public ShopOrderBill get(Long id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		TshopOrderBill t = shopOrderBillDao.get("from TshopOrderBill t  where t.id = :id", params);
		ShopOrderBill o = new ShopOrderBill();
		BeanUtils.copyProperties(t, o);
		return o;
	}

	@Override
	public void edit(ShopOrderBill shopOrderBill) {
		TshopOrderBill t = shopOrderBillDao.get(TshopOrderBill.class, shopOrderBill.getId());
		if (t != null) {
			MyBeanUtils.copyProperties(shopOrderBill, t, new String[] { "id" , "addtime", "isdeleted","updatetime" },true);
		}
	}

	@Override
	public void delete(Integer id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		shopOrderBillDao.executeHql("update TshopOrderBill t set t.isdeleted = 1 where t.id = :id",params);
		//shopOrderBillDao.delete(shopOrderBillDao.get(TshopOrderBill.class, id));
	}

	@Override
	public DataGrid dataGridWithName(ShopOrderBill shopOrderBill, PageHelper ph) {
		DataGrid dataGrid = dataGrid(shopOrderBill, ph);
		List<ShopOrderBill> shopOrderBills = dataGrid.getRows();
		if (CollectionUtils.isNotEmpty(shopOrderBills)) {
			List<ShopOrderBillQuery> shopOrderBillQueries = new ArrayList<ShopOrderBillQuery>();
			for (ShopOrderBill shopOrderBill1 : shopOrderBills) {
				ShopOrderBillQuery shopOrderBillQuery = new ShopOrderBillQuery();
				BeanUtils.copyProperties(shopOrderBill1, shopOrderBillQuery);
				MbShop mbShop = mbShopService.getFromCache(shopOrderBill1.getShopId());
				if (mbShop != null) {
					shopOrderBillQuery.setShopName(mbShop.getName());
				}
				shopOrderBillQuery.setStatusName(shopOrderBill1.getStatus());
				shopOrderBillQueries.add(shopOrderBillQuery);
			}
			DataGrid dg = new DataGrid();
			dg.setRows(shopOrderBillQueries);
			dg.setTotal(dataGrid.getTotal());
			return dg;
		}
		return dataGrid;
	}

	@Override
	public void addShopOrderBillAndShopPay(ShopOrderBill shopOrderBill) {
		shopOrderBill.setStatus("BAS01");
		Long shopOrderBillId=add(shopOrderBill);
		DeliverOrderQuery deliverOrderQuery = new DeliverOrderQuery();
		deliverOrderQuery.setStartDate(shopOrderBill.getStartDate());
		deliverOrderQuery.setEndDate(shopOrderBill.getEndDate());
		deliverOrderQuery.setShopId(shopOrderBill.getShopId());
		deliverOrderQuery.setStatus("DOS30");
		List<DeliverOrder> deliverOrders = deliverOrderService.query(deliverOrderQuery);
		if (CollectionUtils.isNotEmpty(deliverOrders)) {
			for (DeliverOrder deliverOrder : deliverOrders) {
				DeliverOrderShopPay orderShopPay = new DeliverOrderShopPay();
				orderShopPay.setShopId(shopOrderBill.getShopId());
				orderShopPay.setDeliverOrderId(deliverOrder.getId());
				orderShopPay.setStatus("SPS02");
				orderShopPay.setShopOrderBillId(shopOrderBillId);
				deliverOrderShopPayService.add(orderShopPay);
			}
		}
	}

	@Override
	public ShopOrderBillQuery getViewShopOrderBill(Long id) {
		ShopOrderBill shopOrderBill = get(id);
		if (shopOrderBill != null) {
			ShopOrderBillQuery shopOrderBillQuery = new ShopOrderBillQuery();
			BeanUtils.copyProperties(shopOrderBill, shopOrderBillQuery);
			User user = userService.get(shopOrderBill.getReviewerId());
			if (user != null) {
				shopOrderBillQuery.setReviewerName(user.getName());
			}
			return shopOrderBillQuery;
		}
		return null;
	}

	@Override
	public void editBillStatusAndPayStatus(ShopOrderBill shopOrderBill) {
		edit(shopOrderBill);
		DeliverOrderShopPay deliverOrderShopPay = new DeliverOrderShopPay();
		deliverOrderShopPay.setShopOrderBillId(shopOrderBill.getId());
		List<DeliverOrderShopPay> deliverOrderShopPays = deliverOrderShopPayService.query(deliverOrderShopPay);
		if(CollectionUtils.isNotEmpty(deliverOrderShopPays)) {
			for (DeliverOrderShopPay orderShopPay : deliverOrderShopPays) {
				if("BAS02".equals(shopOrderBill.getStatus())){
					orderShopPay.setStatus("SPS01");
				}else {
					orderShopPay.setStatus("SPS03");
				}
				deliverOrderShopPayService.edit(orderShopPay);
			}
		}

	}

}
