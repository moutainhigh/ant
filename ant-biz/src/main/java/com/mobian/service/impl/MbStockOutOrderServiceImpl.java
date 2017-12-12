package com.mobian.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.mobian.absx.F;
import com.mobian.dao.MbStockOutOrderDaoI;
import com.mobian.model.TmbStockOutOrder;
import com.mobian.pageModel.MbStockOutOrder;
import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.PageHelper;
import com.mobian.service.MbStockOutOrderServiceI;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.mobian.util.MyBeanUtils;

@Service
public class MbStockOutOrderServiceImpl extends BaseServiceImpl<MbStockOutOrder> implements MbStockOutOrderServiceI {

	@Autowired
	private MbStockOutOrderDaoI mbStockOutOrderDao;

	@Override
	public DataGrid dataGrid(MbStockOutOrder mbStockOutOrder, PageHelper ph) {
		List<MbStockOutOrder> ol = new ArrayList<MbStockOutOrder>();
		String hql = " from TmbStockOutOrder t ";
		DataGrid dg = dataGridQuery(hql, ph, mbStockOutOrder, mbStockOutOrderDao);
		@SuppressWarnings("unchecked")
		List<TmbStockOutOrder> l = dg.getRows();
		if (l != null && l.size() > 0) {
			for (TmbStockOutOrder t : l) {
				MbStockOutOrder o = new MbStockOutOrder();
				BeanUtils.copyProperties(t, o);
				ol.add(o);
			}
		}
		dg.setRows(ol);
		return dg;
	}
	

	protected String whereHql(MbStockOutOrder mbStockOutOrder, Map<String, Object> params) {
		String whereHql = "";	
		if (mbStockOutOrder != null) {
			whereHql += " where t.isdeleted = 0 ";
			if (!F.empty(mbStockOutOrder.getTenantId())) {
				whereHql += " and t.tenantId = :tenantId";
				params.put("tenantId", mbStockOutOrder.getTenantId());
			}		
			if (!F.empty(mbStockOutOrder.getIsdeleted())) {
				whereHql += " and t.isdeleted = :isdeleted";
				params.put("isdeleted", mbStockOutOrder.getIsdeleted());
			}		
			if (!F.empty(mbStockOutOrder.getMbStockOutId())) {
				whereHql += " and t.mbStockOutId = :mbStockOutId";
				params.put("mbStockOutId", mbStockOutOrder.getMbStockOutId());
			}		
			if (!F.empty(mbStockOutOrder.getDeliverOrderId())) {
				whereHql += " and t.deliverOrderId = :deliverOrderId";
				params.put("deliverOrderId", mbStockOutOrder.getDeliverOrderId());
			}		
			if (!F.empty(mbStockOutOrder.getStatus())) {
				whereHql += " and t.status = :status";
				params.put("status", mbStockOutOrder.getStatus());
			}		
		}	
		return whereHql;
	}

	@Override
	public void add(MbStockOutOrder mbStockOutOrder) {
		TmbStockOutOrder t = new TmbStockOutOrder();
		BeanUtils.copyProperties(mbStockOutOrder, t);
		//t.setId(jb.absx.UUID.uuid());
		t.setIsdeleted(false);
		mbStockOutOrderDao.save(t);
	}

	@Override
	public MbStockOutOrder get(Integer id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		TmbStockOutOrder t = mbStockOutOrderDao.get("from TmbStockOutOrder t  where t.id = :id", params);
		MbStockOutOrder o = new MbStockOutOrder();
		BeanUtils.copyProperties(t, o);
		return o;
	}

	@Override
	public void edit(MbStockOutOrder mbStockOutOrder) {
		TmbStockOutOrder t = mbStockOutOrderDao.get(TmbStockOutOrder.class, mbStockOutOrder.getId());
		if (t != null) {
			MyBeanUtils.copyProperties(mbStockOutOrder, t, new String[] { "id" , "addtime", "isdeleted","updatetime" },true);
		}
	}

	@Override
	public void delete(Integer id) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", id);
		mbStockOutOrderDao.executeHql("update TmbStockOutOrder t set t.isdeleted = 1 where t.id = :id",params);
		//mbStockOutOrderDao.delete(mbStockOutOrderDao.get(TmbStockOutOrder.class, id));
	}

}
