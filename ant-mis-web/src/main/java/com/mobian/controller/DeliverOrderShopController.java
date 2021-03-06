package com.mobian.controller;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mobian.pageModel.Colum;
import com.bx.ant.pageModel.DeliverOrderShop;
import com.mobian.pageModel.DataGrid;
import com.mobian.pageModel.Json;
import com.mobian.pageModel.PageHelper;
import com.bx.ant.service.DeliverOrderShopServiceI;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;

/**
 * DeliverOrderShop管理控制器
 * 
 * @author John
 * 
 */
@Controller
@RequestMapping("/deliverOrderShopController")
public class DeliverOrderShopController extends BaseController {

	@Resource
	private DeliverOrderShopServiceI deliverOrderShopService;


	/**
	 * 跳转到DeliverOrderShop管理页面
	 * 
	 * @return
	 */
	@RequestMapping("/manager")
	public String manager(HttpServletRequest request) {
		return "/deliverordershop/deliverOrderShop";
	}

	/**
	 * 获取DeliverOrderShop数据表格
	 * 
	 * @param
	 * @return
	 */
	@RequestMapping("/dataGrid")
	@ResponseBody
	public DataGrid dataGrid(DeliverOrderShop deliverOrderShop, PageHelper ph) {
		return deliverOrderShopService.dataGridWithName(deliverOrderShop, ph);
	}
	/**
	 * 获取DeliverOrderShop数据表格excel
	 * 
	 * @param
	 * @return
	 * @throws NoSuchMethodException 
	 * @throws SecurityException 
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 * @throws IllegalArgumentException 
	 * @throws IOException 
	 */
	@RequestMapping("/download")
	public void download(DeliverOrderShop deliverOrderShop, PageHelper ph,String downloadFields,HttpServletResponse response) throws SecurityException, NoSuchMethodException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, IOException{
		DataGrid dg = dataGrid(deliverOrderShop,ph);		
		downloadFields = downloadFields.replace("&quot;", "\"");
		downloadFields = downloadFields.substring(1,downloadFields.length()-1);
		List<Colum> colums = JSON.parseArray(downloadFields, Colum.class);
		downloadTable(colums, dg, response);
	}
	/**
	 * 跳转到添加DeliverOrderShop页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/addPage")
	public String addPage(HttpServletRequest request) {
		DeliverOrderShop deliverOrderShop = new DeliverOrderShop();
		return "/deliverordershop/deliverOrderShopAdd";
	}

	/**
	 * 添加DeliverOrderShop
	 * 
	 * @return
	 */
	@RequestMapping("/add")
	@ResponseBody
	public Json add(DeliverOrderShop deliverOrderShop) {
		Json j = new Json();		
		deliverOrderShopService.add(deliverOrderShop);
		j.setSuccess(true);
		j.setMsg("添加成功！");		
		return j;
	}

	/**
	 * 跳转到DeliverOrderShop查看页面
	 * 
	 * @return
	 */
	@RequestMapping("/view")
	public String view(HttpServletRequest request, Long id) {
		DeliverOrderShop deliverOrderShop = deliverOrderShopService.get(id);
		request.setAttribute("deliverOrderShop", deliverOrderShop);
		return "/deliverordershop/deliverOrderShopView";
	}

	/**
	 * 跳转到DeliverOrderShop修改页面
	 * 
	 * @return
	 */
	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Long id) {
		DeliverOrderShop deliverOrderShop = deliverOrderShopService.get(id);
		request.setAttribute("deliverOrderShop", deliverOrderShop);
		return "/deliverordershop/deliverOrderShopEdit";
	}

	/**
	 * 修改DeliverOrderShop
	 * 
	 * @param deliverOrderShop
	 * @return
	 */
	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(DeliverOrderShop deliverOrderShop) {
		Json j = new Json();		
		deliverOrderShopService.edit(deliverOrderShop);
		j.setSuccess(true);
		j.setMsg("编辑成功！");		
		return j;
	}

	/**
	 * 删除DeliverOrderShop
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping("/delete")
	@ResponseBody
	public Json delete(Integer id) {
		Json j = new Json();
		deliverOrderShopService.delete(id);
		j.setMsg("删除成功！");
		j.setSuccess(true);
		return j;
	}

}
