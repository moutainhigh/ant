package com.bx.ant.service.impl.state;

import com.bx.ant.pageModel.DeliverOrderShop;
import com.bx.ant.service.*;
import com.bx.ant.pageModel.DeliverOrder;
import com.bx.ant.pageModel.DeliverOrderLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 订单已产生,待支付状态
 * 该状态已废弃
 * Created by wanxp on 17-9-26.
 */
@Service("deliverOrder01StateImpl")
public class DeliverOrder01StateImpl implements DeliverOrderState {

    @Resource(name = "deliverOrder10StateImpl")
    private DeliverOrderState deliverOrderState10;

    @Autowired
    private DeliverOrderServiceI deliverOrderService;

    @Autowired
    private DeliverOrderLogServiceI deliverOrderLogService;

    @Override
    public String getStateName() {
        return "01";
    }

    @Override
    public void handle(DeliverOrder deliverOrder) {
        deliverOrder.setStatus(prefix + getStateName());
        deliverOrder.setPayStatus(DeliverOrderServiceI.PAY_STATUS_NOT_PAY);
        deliverOrder.setShopPayStatus(DeliverOrderServiceI.SHOP_PAY_STATUS_NOT_PAY);
        deliverOrder.setDeliveryStatus(DeliverOrderServiceI.DELIVER_STATUS_STANDBY);

        deliverOrderService.add(deliverOrder);

        DeliverOrderLog log = new DeliverOrderLog();
        log.setDeliverOrderId(deliverOrder.getId());
        log.setLogType(DeliverOrderLogServiceI.TYPE_ADD_DELIVER_ORDER);
        log.setContent("添加订单等待分配");
        deliverOrderLogService.add(log);
    }

    @Override
    public DeliverOrderState next(DeliverOrder deliverOrder) {
        if ((prefix + "10").equals(deliverOrder.getStatus())) {
            return deliverOrderState10;
        }
        return null;
    }
}