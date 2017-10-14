package com.bx.ant.service;

import com.bx.ant.pageModel.Supplier;
import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.PageHelper;

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

}
