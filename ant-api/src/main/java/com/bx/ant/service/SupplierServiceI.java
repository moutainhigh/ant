package com.bx.ant.service;

import com.bx.ant.pageModel.Supplier;
import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.PageHelper;

import java.util.List;
import java.util.Map;

/**
 * 
 * @author John
 * 
 */
public interface SupplierServiceI {

	/**
	 * 获取Supplier数据表格
	 * 
	 * @param supplier
	 *            参数
	 * @param ph
	 *            分页帮助类
	 * @return
	 */
	public DataGrid dataGrid(Supplier supplier, PageHelper ph);

	/**
	 * 添加Supplier
	 * 
	 * @param supplier
	 */
	public void add(Supplier supplier);

	/**
	 * 获得Supplier对象
	 * 
	 * @param id
	 * @return
	 */
	public Supplier get(Integer id);

	/**
	 * 修改Supplier
	 * 
	 * @param supplier
	 */
	public void edit(Supplier supplier);

	/**
	 * 删除Supplier
	 * 
	 * @param id
	 */
	public void delete(Integer id);

	/**
	 * 查询供应商对象信息
	 * @param supplier
	 * @return
	 */
	public List<Supplier> query(Supplier supplier);

	List<Map> getSelectMapList(String sql, Map<String, Object> params);

	/**
	 * 获取供应商信息通过门店名称
	 * @param name
	 * @return
	 */
	List<Supplier> getSupplierListByName(String name);
}
