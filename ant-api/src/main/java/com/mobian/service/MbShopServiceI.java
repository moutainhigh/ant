package com.mobian.service;

import com.mobian.pageModel.*;

import java.util.List;

/**
 * 
 * @author John
 * 
 */
public interface MbShopServiceI {

	/**
	 * 加盟
	 */
	String ST01 = "ST01";

	/**
	 * 获取MbShop数据表格
	 *
	 * @param mbShop 参数
	 * @param ph     分页帮助类
	 * @return
	 */
	DataGrid dataGrid(MbShop mbShop, PageHelper ph);

	DataGrid dataGridKeyword(MbShop mbShop);


	/**
	 * 添加MbShop
	 *
	 * @param mbShop
	 */
	void add(MbShop mbShop);

	/**
	 * 获得MbShop对象
	 *
	 * @param id
	 * @return
	 */
	MbShop get(Integer id);

	MbShop getFromCache(Integer id);

	/**
	 * 修改MbShop
	 *
	 * @param mbShop
	 */
	void edit(MbShop mbShop);

	/**
	 * 门店审核
	 *
	 * @param mbShop
	 */
	void editAudit(MbShop mbShop);

	/**
	 * 删除MbShop
	 *
	 * @param id
	 */
	void delete(Integer id);

	List<MbShop> getByPhone(String phone);

	void addOrUpdate(MbShop mbShop);

	/**
	 * 将userID置为空
	 */
	void editUserIdToNull(MbShop mbShop);

	/**
	 * 解除用户绑定
	 * @param mbShop
	 * @param mbUser
	 */
	void unboundUser(MbShop mbShop, MbUser mbUser);

	/**
	 * 绑定用户
	 * @param mbShop
	 * @param mbUser
	 */
	void boundUser(MbShop mbShop, MbUser mbUser);


	void editMainShop(MbShop mbShop, int balanceAmount, int cashBalanceAmount);

	/**
	 * 根据shopId查询主店分店列表
	 * @param shopId
	 * @return
	 */
	List<MbShop> queryListById(Integer shopId);

	/**
	 * 统计有余额欠款的门店细信息
	 * @param mbShop
	 * @param ph
	 * @return
	 */
	DataGrid dataGridShopArrears(MbShop mbShop, PageHelper ph);

	/**
	 * 统计有欠桶账的门店信息
	 * @param mbShop
	 * @param ph
	 * @return
	 */
	DataGrid dataGridShopBarrel(MbShop mbShop, PageHelper ph);

	/**
	 * 获取显示门店信息列表并设置余额和桶账值
	 * @param mbShop,mbBalances
	 * @param ph
	 * @return
	 */
	DataGrid dataGridShopBarrelAndArrears(MbShop mbShop, List<MbBalance> mbBalances, PageHelper ph);

	List<MbShop> query(MbShop mbShop);
	/**
	 * 设置门店数字地址
	 */
	void setShopLocation(MbShop mbShop);

}
