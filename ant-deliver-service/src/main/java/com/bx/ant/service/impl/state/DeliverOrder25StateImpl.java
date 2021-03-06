package com.bx.ant.service.impl.state;

import com.bx.ant.service.*;
import com.bx.ant.pageModel.DeliverOrder;
import com.bx.ant.service.qimen.QimenRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;

/**
 * 门店已发货状态,
 * Created by wanxp on 17-9-26.
 */
@Service("deliverOrder25StateImpl")
public class DeliverOrder25StateImpl extends AbstractDeliverOrderState {

    @Resource(name = "deliverOrder30StateImpl")
    private DeliverOrderState deliverOrderState30;

    @Resource(name = "deliverOrder50StateImpl")
    private DeliverOrderState deliverOrderState50;

    @Autowired
    private DeliverOrderServiceI deliverOrderService;

    @Autowired
    private QimenRequestService qimenRequestService;


    @Override
    public String getStateName() {
        return "25";
    }

    @Override
    public void execute(DeliverOrder deliverOrder) {

        //修改运单状态
        DeliverOrder orderNew = new DeliverOrder();
        orderNew.setId(deliverOrder.getId());
        orderNew.setStatus(prefix + getStateName());
        orderNew.setDeliveryStatus(DeliverOrderServiceI.DELIVER_STATUS_DELIVERING);
        deliverOrderService.editAndAddLog(orderNew, DeliverOrderLogServiceI.TYPE_DELIVERING_DELIVER_ORDER, "运单发货");



    }

    protected void afterCompletion(DeliverOrder deliverOrder) {
        DeliverOrder deliverOrderOld = DeliverOrderState.deliverOrder.get();
        //代送业务此处不用确认
        if (!ShopDeliverApplyServiceI.DELIVER_WAY_AGENT.equals(deliverOrderOld.getDeliveryWay()) && !ShopDeliverApplyServiceI.DELIVER_WAY_CUSTOMER_AGENT.equals(deliverOrderOld.getDeliveryWay())) {
            qimenRequestService.updateDeliveryOrderConfirm(deliverOrderOld);
        }
    }

    @Override
    public DeliverOrderState next(DeliverOrder deliverOrder) {
        if ((prefix + "30").equals(deliverOrder.getStatus())) {
            return deliverOrderState30;
        } else if((prefix + "50").equals(deliverOrder.getStatus())) {
            return deliverOrderState50;
        }
        return null;
    }
}
