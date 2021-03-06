package com.bx.ant.service;

import com.bx.ant.pageModel.*;

import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.PageHelper;

import javax.persistence.criteria.CriteriaBuilder;
import java.util.Date;
import java.util.List;

/**
 *
 * @author John
 *
 */
public interface DeliverOrderServiceI {

	//供应商/门店支付状态
	String PAY_STATUS_NOT_PAY = "DPS01"; //待支付
	String PAY_STATUS_AUDIT = "DPS02"; //待审核
	String PAY_STATUS_REFUSE = "DPS03"; //审核拒绝
	String PAY_STATUS_SUCCESS = "DPS04"; //支付成功

	//门店结算状态
	String SHOP_PAY_STATUS_NOT_PAY = "SPS01"; //待支付
	String SHOP_PAY_STATUS_AUDIT = "SPS02"; //待审核
	String SHOP_PAY_STATUS_REFUSE = "SPS03"; //审核拒绝
	String SHOP_PAY_STATUS_SUCCESS = "SPS04"; //支付成功

	//订单状态
	String STATUS_NOT_ALLOCATION = "DOS01"; //待分配
	String STATUS_SHOP_ALLOCATION= "DOS10"; //已分配，待门店接
	String STATUS_SHOP_REFUSE = "DOS15"; //门店拒绝接单
	String STATUS_SHOP_ACCEPT = "DOS20"; //门店已接单
    String STATUS_CHECK_DRIVER_TAKE ="DOS21"; //骑手已接单,等待骑手取货
	String STATUS_DRIVER_TOKEN = "DOS22"; //骑手已取货
	String STATUS_DELIVERING = "DOS25"; //已发货
	String STATUS_DELIVERY_COMPLETE = "DOS30"; //已配送完成
	String STATUS_CLOSED = "DOS40"; //订单完成
	String STATUS_DRIVER_DELIVERING = "DOS50"; // 骑手已配送，等待门店确认
	String STATUS_FAILURE_CLOSED = "DOS60"; // 关闭订单

	//配送状态
	String DELIVER_STATUS_STANDBY = "DDS01"; //待处理
	String DELIVER_STATUS_HANDLEING = "DDS05"; //chuhuozhong
	String DELIVER_STATUS_DELIVERING = "DDS02"; //配送中
//	String DELIVER_STATUS_USER_CHECK = "DDS03"; //用户确认
	String DELIVER_STATUS_DELIVERED = "DDS04"; //已配送

	//支付方式
	String PAY_WAY_BALANCE = "DPW01"; //余额
	String PAY_WAY_WECHAT = "DPW02"; //微信
	String PAY_WAY_TRANSFER = "DPW03"; //汇款

	// 派单类型
	String DELIVER_TYPE_HAND = "DAT01"; // 手动接单
	String DELIVER_TYPE_AUTO = "DAT02"; // 自动接单
	String DELIVER_TYPE_FORCE = "DAT03"; // 强制接单

	String ORIGINAL_ORDER_STATUS_OTS01 = "OTS01"; // 待处理
	String ORIGINAL_ORDER_STATUS_OTS02 = "OTS02"; // 平台接单
	String ORIGINAL_ORDER_STATUS_OTS03 = "OTS03"; // 平台不接单

	String AGENT_STATUS_DTS01 = "DTS01"; // 未打单
	String AGENT_STATUS_DTS02 = "DTS02"; // 已打单
	String AGENT_STATUS_DTS03 = "DTS03"; // 已发货
	String AGENT_STATUS_DTS04 = "DTS04"; // 已签收

	//派单结算时间差
	Long TIME_DIF_SHOP_PAY_SETTLED = new Long(1 * 1 * 1 * 60 * 1000) ;

    void transformByShopIdAndStatus(Long id, Integer shopId, String status);
    void transformByShopIdAndStatus(DeliverOrder deliverOrder);

    /**
	 * 获取当前状态
	 * @return
	 */
	DeliverOrderState getCurrentState(Long id);
	/**
	 * 获取DeliverOrder数据表格
	 *
	 * @param deliverOrder
	 *            参数
	 * @param ph
	 *            分页帮助类
	 * @return
	 */
	DataGrid dataGrid(DeliverOrder deliverOrder, PageHelper ph);
	DataGrid unPayOrderDataGrid(DeliverOrder deliverOrder,PageHelper ph);


	/**
	 * 添加DeliverOrder
	 *
	 * @param deliverOrder
	 */
	void add(DeliverOrder deliverOrder);

	/**
	 * 获得DeliverOrder对象
	 *
	 * @param id
	 * @return
	 */
	DeliverOrder get(Long id);

	/**
	 * 修改DeliverOrder
	 *
	 * @param deliverOrder
	 */
	void edit(DeliverOrder deliverOrder);

	/**
	 * 删除DeliverOrder
	 *
	 * @param id
	 */
	void delete(Long id);

	/**
	 * 填充信息
	 * @param deliverOrderExt
	 */
//    void fillInfo(DeliverOrderExt deliverOrderExt);

	/**
	 * 填充商品信息
	 * @param deliverOrderExt
	 */
//	void fillDeliverOrderItemInfo(DeliverOrderExt deliverOrderExt);

	/**
	 *
	 * @param deliverOrderExt
	 */
//    void fillDeliverOrderShopItemInfo(DeliverOrderExt deliverOrderExt);

    /**
	 * 配送订单状态转换
	 * @param deliverOrder
	 */
	void transform(DeliverOrder deliverOrder);

	/**
	 * 列出门店的运单
	 * @param shopId
	 * @return
	 */
	List<DeliverOrder> listOrderByOrderShopIdAndShopStatus(Integer shopId, String deliverOrderShopStatus);

	/**
	 * 通过门店ID和订单状态获取订单列表
	 * @param shopId
	 * @param orderStatus
	 * @return
	 */
	List<DeliverOrder> listOrderByShopIdAndOrderStatus(Integer shopId, String orderStatus);

	/**
	 * 获取到含明细的运单
	 * @param deliverOrderShop
	 * @return
	 */
	DeliverOrder getDeliverOrderExt(DeliverOrderShop deliverOrderShop);

	/**
	 * 获取包含DeliverOrderShopItemList的order
	 * @param deliverOrder
	 * @param ph
	 * @return
	 */
	DataGrid dataGridExt(DeliverOrder deliverOrder, PageHelper ph);

	/**
	 * 编辑deliverOrder并添加记录
	 * @param deliverOrder
	 * @param logType
	 * @param content
	 * @param loginId
	 */
    void editAndAddLog(DeliverOrder deliverOrder, String logType, String content, String loginId);

	/**
	 * 编辑deliverOrder并添加记录
	 * @param deliverOrder
	 * @param logType
	 * @param content
	 */
    void editAndAddLog(DeliverOrder deliverOrder, String logType, String content);

	/**
	 * 获取运单管理列表数据
	 * @param deliverOrder
	 * @param ph
	 * @return
	 */
	DataGrid dataGridWithName(DeliverOrder deliverOrder,PageHelper ph);

	/**
	 * 根据运单ID，查询运单详细
	 * @param id
	 * @return
	 */
	DeliverOrderQuery getDeliverOrderView(Long id );


    void addAndItems(DeliverOrder deliverOrder, String itemListStr);

    void addAndItems(DeliverOrder deliverOrder, List<SupplierItemRelationView> items);


	/**
	 * 查询DeliverOrder集合列表
	 * @param deliverOrder
	 * @return
	 */
	List<DeliverOrder> query(DeliverOrder deliverOrder);

	/**
	 * 创建账单
	 * @param list
	 * @param supplierId
	 */
	List<DeliverOrderPay> addOrderBill(List<DeliverOrder> list, Integer supplierId, Date startTime, Date endTime);

	/**
	 * 更新r门店新订单计数
	 * @param shopId
	 * @param quantity
	 * @return
	 */
    Integer updateAllocationOrderRedis(Integer shopId, Integer quantity);

	/**
	 * 累加新订单计数
	 * @param shopId
	 * @return
	 */
	Integer addAllocationOrderRedis(Integer shopId);

	/**
	 * 减少r超时订单计数
	 * @param shopId
	 * @return
	 */
    Integer reduceAllocationOrderRedis(Integer shopId);

	/**
	 * 清除新订单计数
	 * @param shopId
	 * @return
	 */
	Integer clearAllocationOrderRedis(Integer shopId);

	DeliverOrder getBySupplierOrderId(String supplierOrderId);

	/**
	 * 根据外部ID获取
	 * @param supplierId
	 * @param supplierOrderId
	 * @return
	 */
	DeliverOrder getBySupplierOrderIdAndSupplierId(Integer supplierId,String supplierOrderId);

	/**
	 * 通过excel获取到的list生成订单
	 * lo[0]订单号
	 * lo[1]商品ID
	 * lo[2]订购的数量
	 * 	lo[3]客户姓名
	 * 	lo[4]客户地址
	 * 	lo[5]联系电话
	 * 	lo[6]备注(可选)
	 * @param lo
	 * @param supplierId
	 */
    void addByTableList(List<List<Object>> lo, Integer supplierId, String loginId);

	/**
	 * 处理指派后的订单
	 * @param deliverOrder
	 */
	Boolean handleAssignDeliverOrder(DeliverOrder deliverOrder);

	/**
	 * 获取超时的未处理的订单
	 * @param deliverOrderQuery
	 * @param ph
	 * @return
	 */
	DataGrid dataGridOutTimeDeliverOrder(DeliverOrderQuery deliverOrderQuery,PageHelper ph);

	Integer editOrderStatus(DeliverOrder deliverorder);

	/**
	 * 获取超时未配送的订单
	 * @param deliverOrderQuery
	 * @param ph
	 * @return
	 */
	DataGrid dataGridNotDriverDeliverOrder(DeliverOrderQuery deliverOrderQuery,PageHelper ph);

	/**
	 * 小程序获取账单详情信息
	 * @param deliverOrderShop
	 * @return
	 */
	DeliverOrderExt getBalanceLogDetail(DeliverOrderShop deliverOrderShop);

    DeliverOrderExt getDetail(Long id);

	/**
	 * 通过门店id获取今日营业额订单列表
	 * @param shopId
	 * @return
	 */
	List<DeliverOrder> queryTodayProfitOrdersByShopId(Integer shopId);
	/**
	 * 通过有赞的订单id 查找本地的订单
	 */
	DeliverOrder getOrderByYouZanTid(String tid);

	/**
	 * 批量修改运单状态为已打单
	 * @param deliverOrderIds
	 */
	void updateBatchOrderSan(String deliverOrderIds,String sessionInfoId);

	/**
	 * 打印小票
	 * @param id
	 */
	Boolean printOrder(Long id, String machineCode);


	/**
	 * 未结算运单汇总
	 * @param deliverOrder
	 * @return
	 */
	DataGrid queryUnPayForCount(DeliverOrder deliverOrder);

}
