package com.bx.ant.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.bx.ant.dao.DriverOrderShopDaoI;
import com.bx.ant.model.TdriverOrderShop;
import com.bx.ant.pageModel.*;
import com.bx.ant.service.*;
import com.mobian.absx.F;
import com.mobian.exception.ServiceException;
import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.MbShop;
import com.mobian.pageModel.PageHelper;
import com.mobian.service.MbShopServiceI;
import com.mobian.thirdpart.redis.Key;
import com.mobian.thirdpart.redis.Namespace;
import com.mobian.thirdpart.redis.RedisUtil;
import com.mobian.util.ConvertNameUtil;
import com.mobian.util.MyBeanUtils;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Service
public class DriverOrderShopServiceImpl extends BaseServiceImpl<DriverOrderShop> implements DriverOrderShopServiceI {

	@Autowired
	private DriverOrderShopDaoI driverOrderShopDao;

	@Resource
	private Map<String, DriverOrderShopState> driverOrderShopStateFactory ;

	@Resource
	private DeliverOrderShopServiceI deliverOrderShopService;

	@Resource
	private RedisUtil redisUtil;

	@Resource
	private MbShopServiceI mbShopService;

	@Resource
	private DriverAccountServiceI driverAccountService;

	@Autowired
	private DriverOrderPayServiceI driverOrderPayService;

	@Override
	public DataGrid dataGrid(DriverOrderShop driverOrderShop, PageHelper ph) {
		List<DriverOrderShop> ol = new ArrayList<DriverOrderShop>();
		String hql = " from TdriverOrderShop t ";
		DataGrid dg = dataGridQuery(hql, ph, driverOrderShop, driverOrderShopDao);
		@SuppressWarnings("unchecked")
		List<TdriverOrderShop> l = dg.getRows();
		if (l != null && l.size() > 0) {
			for (TdriverOrderShop t : l) {
				DriverOrderShop o = new DriverOrderShop();
				BeanUtils.copyProperties(t, o);
				ol.add(o);
			}
		}
		dg.setRows(ol);
		return dg;
	}
	

	protected String whereHql(DriverOrderShop driverOrderShop, Map<String, Object> params) {
		String whereHql = "";	
		if (driverOrderShop != null) {
			whereHql += " where t.isdeleted = 0 ";
			if (!F.empty(driverOrderShop.getTenantId())) {
				whereHql += " and t.tenantId = :tenantId";
				params.put("tenantId", driverOrderShop.getTenantId());
			}		
			if (!F.empty(driverOrderShop.getIsdeleted())) {
				whereHql += " and t.isdeleted = :isdeleted";
				params.put("isdeleted", driverOrderShop.getIsdeleted());
			}		
			if (!F.empty(driverOrderShop.getDeliverOrderShopId())) {
				whereHql += " and t.deliverOrderShopId = :deliverOrderShopId";
				params.put("deliverOrderShopId", driverOrderShop.getDeliverOrderShopId());
			}		
			if (!F.empty(driverOrderShop.getShopId())) {
				whereHql += " and t.shopId = :shopId";
				params.put("shopId", driverOrderShop.getShopId());
			}		
			if (!F.empty(driverOrderShop.getStatus())) {
				whereHql += " and t.status in (:status)";
				params.put("status", driverOrderShop.getStatus().split(","));
			}		
			if (!F.empty(driverOrderShop.getAmount())) {
				whereHql += " and t.amount = :amount";
				params.put("amount", driverOrderShop.getAmount());
			}		
			if (!F.empty(driverOrderShop.getPayStatus())) {
				whereHql += " and t.payStatus = :payStatus";
				params.put("payStatus", driverOrderShop.getPayStatus());
			}		
			if (!F.empty(driverOrderShop.getDriverOrderShopBillId())) {
				whereHql += " and t.driverOrderShopBillId = :driverOrderShopBillId";
				params.put("driverOrderShopBillId", driverOrderShop.getDriverOrderShopBillId());
			}
			if (!F.empty(driverOrderShop.getDriverAccountId())) {
				whereHql += " and t.driverAccountId = :driverAccountId";
				params.put("driverAccountId", driverOrderShop.getDriverAccountId());
			}
			if (driverOrderShop instanceof DriverOrderShopView) {
				DriverOrderShopView driverOrderShopView = (DriverOrderShopView) driverOrderShop;
				if (driverOrderShopView.getAddtimeBegin() != null) {
					whereHql += " and t.addtime >= :addtimeBegin";
					params.put("addtimeBegin", driverOrderShopView.getAddtimeBegin());
				}
				if (driverOrderShopView.getAddtimeEnd() != null) {
					whereHql += " and t.addtime <= :addtimeEnd";
					params.put("addtimeEnd", driverOrderShopView.getAddtimeEnd());
				}
				if (driverOrderShopView.getIds() != null && driverOrderShopView.getIds().length > 0) {
					whereHql += " and t.id in(:ids)";
					params.put("ids", driverOrderShopView.getIds());
				}
				if (driverOrderShopView.getNotInIds() != null && driverOrderShopView.getNotInIds().length > 0) {
					whereHql += " and t.id not in(:ids)";
					params.put("ids", driverOrderShopView.getNotInIds());
				}
			}
		}	
		return whereHql;
	}

	@Override
	public void add(DriverOrderShop driverOrderShop) {
		TdriverOrderShop t = new TdriverOrderShop();
		BeanUtils.copyProperties(driverOrderShop, t);
		//t.setId(jb.absx.UUID.uuid());
		t.setIsdeleted(false);
		driverOrderShopDao.save(t);
		driverOrderShop.setId(t.getId());
	}

	@Override
	public DriverOrderShop get(Long id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		TdriverOrderShop t = driverOrderShopDao.get("from TdriverOrderShop t  where t.id = :id", params);
		DriverOrderShop o = new DriverOrderShop();
		BeanUtils.copyProperties(t, o);
		return o;
	}

	@Override
	public void edit(DriverOrderShop driverOrderShop) {
		TdriverOrderShop t = driverOrderShopDao.get(TdriverOrderShop.class, driverOrderShop.getId());
		if (t != null) {
			MyBeanUtils.copyProperties(driverOrderShop, t, new String[] { "id" , "addtime", "isdeleted","updatetime" },true);
			driverOrderShop.setDeliverOrderShopId(t.getDeliverOrderShopId());
		}
	}

	@Override
	public DriverOrderShop update(DriverOrderShop driverOrderShop) {
		if (!F.empty(driverOrderShop.getId())) {
			edit(driverOrderShop);
		}else {
			add(driverOrderShop);

		}
		return driverOrderShop;
	}

	@Override
	public void delete(Long id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		driverOrderShopDao.executeHql("update TdriverOrderShop t set t.isdeleted = 1 where t.id = :id",params);
		//driverOrderShopDao.delete(driverOrderShopDao.get(TdriverOrderShop.class, id));
	}

	@Override
	public DriverOrderShopView getView(Long id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		TdriverOrderShop t = driverOrderShopDao.get("from TdriverOrderShop t  where t.id = :id", params);
		if (t == null) throw new ServiceException("数据库中不存在该订单");
		DriverOrderShop o = new DriverOrderShop();
		BeanUtils.copyProperties(t, o);
		DriverOrderShopView driverOrderShopView = new DriverOrderShopView();
		if (o != null) {
			BeanUtils.copyProperties(o, driverOrderShopView);
			fillDeliverOrderShopInfo(driverOrderShopView);
			fillShopInfo(driverOrderShopView);
		}
		return driverOrderShopView;
	}

	@Override
	public DriverOrderShop getByPayId(Long driverOrderPayId) {
		DriverOrderPay driverOrderPay = driverOrderPayService.get(driverOrderPayId);
		if (driverOrderPay != null) {
			return getView(driverOrderPay.getDriverOrderShopId());
		}
		return null;
	}

	@Override
	public DataGrid dataGridView(DriverOrderShop driverOrderShop, PageHelper pageHelper) {
		DataGrid dataGrid = dataGrid(driverOrderShop, pageHelper);
		List<DriverOrderShop> driverOrderShops = dataGrid.getRows();
		List<DriverOrderShopView> ol = new ArrayList<DriverOrderShopView>();
		if (CollectionUtils.isNotEmpty(driverOrderShops)) {
			for (DriverOrderShop d : driverOrderShops){
				DriverOrderShopView o = new DriverOrderShopView();
				BeanUtils.copyProperties(d, o);
				fillDeliverOrderShopInfo(o);
				fillShopInfo(o);
				fillDriverAccountInfo(o);
				ol.add(o);
			}
			dataGrid.setRows(ol);
		}
		return dataGrid;
	}

	protected void fillShopInfo(DriverOrderShopView view){
		if (!F.empty(view.getShopId())) {
			MbShop shop = mbShopService.getFromCache(view.getShopId());
			view.setShop(shop);
			view.setShopName(shop.getName());
		}
	}

	protected void fillUserInfo(DriverOrderShopView driverAccountView) {

	}

	protected void fillDeliverOrderShopInfo(DriverOrderShopView driverOrderShopView) {
		if (!F.empty(driverOrderShopView.getDeliverOrderShopId())) {
			DeliverOrderShopView deliverOrderShopView = deliverOrderShopService.getView(driverOrderShopView.getDeliverOrderShopId());
			if (deliverOrderShopView != null) {
				driverOrderShopView.setDeliverOrderShop(deliverOrderShopView);
			}
		}
	}

	@Override
	public DriverOrderShopState getCurrentState(Long driverOrderShopId) {
		DriverOrderShop currentDriverOrderShop = get(driverOrderShopId);
		DriverOrderShopState.driverOrderShop.set(currentDriverOrderShop);
		String driverOrderShopStatus = currentDriverOrderShop.getStatus();
		DriverOrderShopState driverOrderShopState = driverOrderShopStateFactory.get("driverOrderShop" + currentDriverOrderShop.getStatus().substring(4) + "StateImpl");
		return driverOrderShopState;
	}
	@Override
	public void transform(DriverOrderShop driverOrderShop) {
		DriverOrderShopState driverOrderShopState;
		if (F.empty(driverOrderShop.getId())) {
			driverOrderShopState = driverOrderShopStateFactory.get("driverOrderShop01StateImpl");
			driverOrderShopState.handle(driverOrderShop);
		}else {
			driverOrderShopState = getCurrentState(driverOrderShop.getId());
			if (driverOrderShopState.next(driverOrderShop) == null) {
				throw new ServiceException("订单状态异常或已变更,请刷新页面重试 !");
			}
			driverOrderShopState.next(driverOrderShop).handle(driverOrderShop);
		}
	}
	protected Integer updateAllocationOrderRedis(Integer accountId, Integer quantity){
		int count = 0;
		String key = Key.build(Namespace.DRIVER_ORDER_SHOP_NEW_ASSIGNMENT_COUNT, accountId + "");
		String value = (String) redisUtil.getString(key);
		if (!F.empty(value)) {
			count =  Integer.parseInt(value);
			switch (quantity) {
				case 0:
					redisUtil.delete(key);
					return count;
				case -1:
					if ((count += quantity) <= 0) {
						redisUtil.delete(key);
						return 0;
					}
					break;
				case 1:
					count += quantity;
					break;
				default:
					break;
			}
		} else {
			count += quantity;
		}
		if (count  > 0){
			redisUtil.set(key, JSONObject.toJSONString(count),24, TimeUnit.HOURS);
		}
		return count;
	}

	@Override
	public Integer addAllocationOrderRedis(Integer accountId) {
		return updateAllocationOrderRedis(accountId, 1);
	}

	@Override
	public Integer reduseAllocationOrderRedis(Integer accountId) {
		return updateAllocationOrderRedis(accountId, -1);
	}

	@Override
	public Integer clearAllocationOrderRedis(Integer accountId) {
		return updateAllocationOrderRedis(accountId, 0);
	}

	@Override
	public List<DriverOrderShop> query(DriverOrderShop driverOrderShop) {
			List<DriverOrderShop> ol = new ArrayList<DriverOrderShop>();
			String hql = " from TdriverOrderShop t ";
			Map<String, Object> params = new HashMap<String, Object>();
			String where = whereHql(driverOrderShop, params);
			List<TdriverOrderShop> l = driverOrderShopDao.find(hql + where, params);
			if (CollectionUtils.isNotEmpty(l)) {
				for (TdriverOrderShop t : l) {
					DriverOrderShop o = new DriverOrderShop();
					BeanUtils.copyProperties(t, o);
					ol.add(o);
				}
			}
			return ol;
	}

	@Override
	public void editStatusByHql(Long id,String handleStatus ) {
		Map<String,Object> params =new HashMap<String,Object>();
		params.put("id",id);
		params.put("status",STATUS_DELIVERED);
		params.put("payStatus",PAY_STATUS_NOT_PAY);
		int result=0;
		if("DHS02".equals(handleStatus)) {
			params.put("newsStatus",STATUS_SETTLEED);
			params.put("newsPayStatus",PAY_STATUS_PAID);
			//审核通过，则将运单状态变成已结算且支付状态变成已支付
			result = driverOrderShopDao.executeHql("update TdriverOrderShop t set t.status = :newsStatus , t.payStatus = :newsPayStatus " +
					"where t.status = :status and t.payStatus = :payStatus and t.id = :id", params);
		}
		if (result <= 0) {
			throw new ServiceException("修改门店订单状态失败");
		}
	}

	@Override
	public void fillDriverAccountInfo(DriverOrderShopView driverOrderShopView) {
		if (!F.empty(driverOrderShopView.getDriverAccountId())) {
			//TODO  账户加入到缓存
			DriverAccount driverAccount = driverAccountService.getFromCache(driverOrderShopView.getDriverAccountId());
			if (driverAccount != null) {
				driverOrderShopView.setUserName(driverAccount.getUserName());
			}
		}
	}



	@Override
	public void refuseOrder(DriverOrderShop driverOrderShop) {
	    String key = driverAccountService.buildAllocationOrderKey(driverOrderShop.getDriverAccountId());
	    String refuseKey = driverAccountService.buildRefuseOrderKey(driverOrderShop.getDriverAccountId());
	    //拒绝订单清除该记录
		redisUtil.removeSet(key, driverOrderShop.getId().toString());
		reduseAllocationOrderRedis(driverOrderShop.getDriverAccountId());

		//添加redis拒绝订单记录
		redisUtil.addSet(refuseKey, driverOrderShop.getId().toString());
		redisUtil.expire(refuseKey, Integer.parseInt(ConvertNameUtil.getString("DDSV104", "48")), TimeUnit.HOURS);
	}

	@Override
	public DataGrid listTodayOrderByAccountId(Integer driverAccountId){
		Calendar today = Calendar.getInstance();
		DriverOrderShopView driverOrderShopView = new DriverOrderShopView();
		today.set(Calendar.HOUR_OF_DAY, 0);
		today.set(Calendar.MINUTE, 0);
		today.set(Calendar.SECOND, 0);
		today.set(Calendar.MILLISECOND,0);
		driverOrderShopView.setAddtimeBegin(today.getTime());
		Calendar endDay = Calendar.getInstance();
		endDay.set(Calendar.HOUR_OF_DAY, 23);
		endDay.set(Calendar.MINUTE, 59);
		endDay.set(Calendar.SECOND, 59);
		driverOrderShopView.setAddtimeEnd(endDay.getTime());

		PageHelper ph = new  PageHelper();
//		ph.setOrder("desc");
//		ph.setSort("updatetime");

		driverOrderShopView.setDriverAccountId(driverAccountId);
		driverOrderShopView.setStatus(DriverOrderShopServiceI.STATUS_ACCEPTED + ","
				+ 	DriverOrderShopServiceI.STATUS_DELVIERING + ","
				+ DriverOrderShopServiceI.STATUS_DELIVERED + ","
				+ DriverOrderShopServiceI.STATUS_ITEM_TAKEN +","
				+ DriverOrderShopServiceI.STATUS_DELIVERED_AUDIT +","
				+ DriverOrderShopServiceI.STATUS_SETTLEED );
		DataGrid dataGrid = dataGridView(driverOrderShopView, ph);
		return dataGrid;
	}

	@Override
	public Boolean editOrderAccept(DriverOrderShop driverOrderShop) {
		Boolean b = false;
		//检测是否已经被接单
		DriverAccount driverAccount = driverAccountService.getFromCache(driverOrderShop.getDriverAccountId());
		Set<String> orderSet = redisUtil.getAllSet(driverAccountService.buildAllocationOrderKey(driverOrderShop.getDriverAccountId()));

		DriverOrderShop orderShop = new DriverOrderShop();
		orderShop.setStatus(DriverOrderShopServiceI.STATUS_ACCEPTED + ","
		+ DriverOrderShopServiceI.STATUS_ITEM_TAKEN + ","
		+ DriverOrderShopServiceI.STATUS_DELVIERING + ","
		+ DriverOrderShopServiceI.STATUS_DELIVERED_AUDIT);
		orderShop.setDriverAccountId(driverOrderShop.getDriverAccountId());

		List<DriverOrderShop> driverOrderShops = query(orderShop);

		if (orderSet.contains(driverOrderShop.getId().toString())
				&& (CollectionUtils.isEmpty(driverOrderShops)
				|| driverOrderShops.size()
				< (driverAccount.getOrderQuantity() == null ? 0 : driverAccount.getOrderQuantity()))){
			driverOrderShop.setStatus(DriverOrderShopServiceI.STATUS_ACCEPTED);
			transform(driverOrderShop);
			b = true;
		}
		return b;
	}

	@Override
	public DriverOrderShop getByDeliverOrderShopId(Long deliverOrderShopId) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("deliverOrderShopId", deliverOrderShopId);
		TdriverOrderShop t = driverOrderShopDao.get("from TdriverOrderShop t  where t.deliverOrderShopId = :deliverOrderShopId", params);
		DriverOrderShop o = null;
		if(t != null) {
			o = new DriverOrderShop();
			BeanUtils.copyProperties(t, o);

		}

		return o;
	}

	@Override
	public DataGrid queryUnPayForCount(DriverOrderShop driverOrderShop) {
		PageHelper ph = new PageHelper();
		ph.setHiddenTotal(true);
		ph.setRows(100000);
		driverOrderShop.setStatus("DDSS20");
		driverOrderShop.setPayStatus("DDPS01");
		List<DriverOrderShop> ol = dataGrid(driverOrderShop, ph).getRows();
		Map<Integer, DriverOrderShop> map = new HashMap<Integer, DriverOrderShop>();
		for (DriverOrderShop order : ol) {
			DriverOrderShop dOrder = map.get(order.getDriverAccountId());
			if (dOrder == null) {
				map.put(order.getDriverAccountId(), order);
			} else {
				dOrder.setAmount(dOrder.getAmount() + order.getAmount());
			}
		}
		DataGrid dg = new DataGrid();
		dg.setRows(Arrays.asList(map.values().toArray()));
		return dg;
	}

}





