package com.bx.ant.service.impl.state;

import com.bx.ant.pageModel.DeliverOrderShop;
import com.bx.ant.pageModel.DriverOrderShop;
import com.bx.ant.pageModel.ShopDeliverApply;
import com.bx.ant.service.*;
import com.bx.ant.pageModel.DeliverOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 已配送完成,
 * Created by wanxp on 17-9-26.
 */
@Service("deliverOrder30StateImpl")
public class DeliverOrder30StateImpl extends AbstractDeliverOrderState {

    @Resource(name = "deliverOrder40StateImpl")
    private DeliverOrderState deliverOrderState40;

    @Autowired
    private DeliverOrderServiceI deliverOrderService;

    @Autowired
    private DeliverOrderShopServiceI deliverOrderShopService;

    @Autowired
    private DriverOrderShopServiceI driverOrderShopService;

    @Override
    public String getStateName() {
        return "30";
    }

    @Override
    public void execute(DeliverOrder deliverOrder) {

        //修改运单状态
        DeliverOrder orderEdit = new DeliverOrder();
        orderEdit.setId(deliverOrder.getId());
        orderEdit.setStatus(prefix + getStateName());
        orderEdit.setDeliveryStatus(DeliverOrderServiceI.DELIVER_STATUS_DELIVERED);
        orderEdit.setCompleteImages(deliverOrder.getCompleteImages());
        orderEdit.setCompleteRemark(deliverOrder.getCompleteRemark());
        deliverOrderService.editAndAddLog(orderEdit, deliverOrder.getDeliverOrderLogType(), "运单已被派送至目的地");

        //门店订单状态
        DeliverOrderShop deliverOrderShop = new DeliverOrderShop();
        deliverOrderShop.setStatus(DeliverOrderShopServiceI.STATUS_ACCEPTED);
        deliverOrderShop.setDeliverOrderId(deliverOrder.getId());
        DeliverOrderShop orderShopEdit = new DeliverOrderShop();
        orderShopEdit.setStatus(DeliverOrderShopServiceI.STAUS_SERVICE);
        deliverOrderShop = deliverOrderShopService.editStatus(deliverOrderShop,orderShopEdit);

        //修改骑手运单状态为已确认送达
        DeliverOrder order = deliverOrderService.get(deliverOrder.getId());
        if (ShopDeliverApplyServiceI.DELIVER_WAY_DRIVER.equals(order.getDeliveryWay())) {
            DriverOrderShop driverOrderShop = driverOrderShopService.getByDeliverOrderShopId(deliverOrderShop.getId());
            if (driverOrderShop != null) {
                driverOrderShop.setStatus(DriverOrderShopServiceI.STATUS_DELIVERED);
                driverOrderShopService.transform(driverOrderShop);
            }
        }
    }
    @Override
    public DeliverOrderState next(DeliverOrder deliverOrder) {
        if ((prefix + "40").equals(deliverOrder.getStatus())) {
            return deliverOrderState40;
        }
        return null;
    }
}
