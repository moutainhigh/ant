package com.bx.ant.service.impl.state;

import com.bx.ant.service.DeliverOrderLogServiceI;
import com.bx.ant.service.DeliverOrderServiceI;
import com.bx.ant.service.DeliverOrderShopServiceI;
import com.bx.ant.service.DeliverOrderState;
import com.bx.ant.pageModel.DeliverOrder;
import com.bx.ant.pageModel.DeliverOrderShop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 门店已发货状态
 * Created by wanxp on 17-9-26.
 */
@Service("deliverOrder25StateImpl")
public class DeliverOrder25StateImpl implements DeliverOrderState {

    @Resource(name = "deliverOrder30StateImpl")
    private DeliverOrderState deliverOrderState30;

    @Autowired
    private DeliverOrderServiceI deliverOrderService;

    @Autowired
    private DeliverOrderLogServiceI deliverOrderLogService;

    @Override
    public String getStateName() {
        return "25";
    }

    @Override
    public void handle(DeliverOrder deliverOrder) {

        //修改运单状态
        DeliverOrder orderNew = new DeliverOrder();
        orderNew.setId(deliverOrder.getId());
        orderNew.setStatus(prefix + getStateName());
        orderNew.setDeliveryStatus(DeliverOrderServiceI.DELIVER_STATUS_DELIVERING);
        deliverOrderService.editAndAddLog(orderNew, DeliverOrderLogServiceI.TYPE_DELIVERING_DELIVER_ORDER, "运单发货");

        //修改门店运单状态
//        DeliverOrderShop deliverOrderShop = new DeliverOrderShop();
//        deliverOrderShop.setStatus(deliverOrderShopService.STATUS_AUDITING);
//        deliverOrderShop.setDeliverOrderId(order.getId());
//        deliverOrderShopService.editStatus(deliverOrderShop,deliverOrderShopService.STATUS_REFUSED);


    }

    @Override
    public DeliverOrderState next(DeliverOrder deliverOrder) {
        if ((prefix + "30").equals(deliverOrder.getStatus())) {
            return deliverOrderState30;
        }
        return null;
    }
}