package com.bx.ant.service.impl.state;

import com.bx.ant.service.DeliverOrderLogServiceI;
import com.bx.ant.service.DeliverOrderServiceI;
import com.bx.ant.service.DeliverOrderShopServiceI;
import com.bx.ant.service.DeliverOrderState;
import com.mobian.pageModel.DeliverOrder;
import com.mobian.pageModel.DeliverOrderShop;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 门店拒绝接单状态
 * Created by wanxp on 17-9-26.
 */
@Service("deliverOrder15StateImpl")
public class DeliverOrder15StateImpl implements DeliverOrderState {


    @Resource(name = "deliverOrder10StateImpl")
    private DeliverOrderState deliverOrderState10;

    @Autowired
    private DeliverOrderServiceI deliverOrderService;

    @Autowired
    private DeliverOrderShopServiceI deliverOrderShopService;

    @Autowired
    private DeliverOrderLogServiceI deliverOrderLogService;

    @Override
    public String getStateName() {
        return "15";
    }

    @Override
    public void handle(DeliverOrder deliverOrder) {

        //修改运单状态
        DeliverOrder orderNew = new DeliverOrder();
        orderNew.setId(deliverOrder.getId());
        orderNew.setStatus(prefix + getStateName());
        deliverOrderService.editAndAddLog(orderNew, deliverOrderLogService.TYPE_REFUSE_DELIVER_ORDER,"运单被拒绝");

        //修改运单门店状态
        DeliverOrderShop deliverOrderShop = new DeliverOrderShop();
        deliverOrderShop.setStatus(deliverOrderShopService.STATUS_AUDITING);
        deliverOrderShop.setDeliverOrderId(orderNew.getId());
        deliverOrderShopService.editStatus(deliverOrderShop,deliverOrderShopService.STATUS_REFUSED);

        //TODO 这里应该执行重新分配订单方法

    }

    @Override
    public DeliverOrderState next(DeliverOrder deliverOrder) {
        if ((prefix + "10").equals(deliverOrder.getStatus())) {
            return deliverOrderState10;
        }
        return null;
    }
}
