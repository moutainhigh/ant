package com.mobian.controller;

import com.alibaba.fastjson.JSON;
import com.mobian.absx.F;
import com.mobian.concurrent.ThreadCache;
import com.mobian.pageModel.*;
import com.mobian.service.MbItemServiceI;
import com.mobian.service.MbItemStockLogServiceI;
import com.mobian.service.MbItemStockServiceI;
import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * MbItemStockLog管理控制器
 * 
 * @author John
 * 
 */
@Controller
@RequestMapping("/mbItemStockLogController")
public class MbItemStockLogController extends BaseController {

	@Autowired
	private MbItemStockLogServiceI mbItemStockLogService;

	@Autowired
	private MbItemStockServiceI mbItemStockService;

	@Autowired
	private MbItemServiceI mbItemService;


	/**
	 * 跳转到MbItemStockLog管理页面
	 * 
	 * @return
	 */
	@RequestMapping("/manager")
	public String manager(HttpServletRequest request) {
		return "/mbitemstocklog/mbItemStockLog";
	}

	/**
	 * 获取MbItemStockLog数据表格
	 */
	@RequestMapping("/dataGrid")
	@ResponseBody
	public DataGrid dataGrid(MbItemStockLog mbItemStockLog, PageHelper ph) {
		return mbItemStockLogService.dataGrid(mbItemStockLog, ph);
	}

	/**
	 * 获取MbItemStockLog数据表格
	 */
	@RequestMapping("/dataGridReport")
	@ResponseBody
	public DataGrid dataGridReport(MbItemStockLog mbItemStockLog, PageHelper ph, Integer itemId) {
		if (!F.empty(itemId) || !F.empty(mbItemStockLog.getWarehouseId())) {
			MbItemStock request = new MbItemStock();
			request.setItemId(itemId);
			request.setWarehouseId(mbItemStockLog.getWarehouseId());
			List<MbItemStock> mbItemStockList = mbItemStockService.query(request);
			Integer[] ids = new Integer[mbItemStockList.size()];
			for (int i = 0; i < mbItemStockList.size(); i++) {
				ids[i] = mbItemStockList.get(i).getId();
			}
			mbItemStockLog.setItemStockIds(ids);
		}

		DataGrid dataGrid = mbItemStockLogService.dataGrid(mbItemStockLog, ph);
		List<MbItemStockLog> rows = dataGrid.getRows();
		List<MbItemStockLogExport> mbItemStockLogExportList = new ArrayList<MbItemStockLogExport>();
		ThreadCache mbItemStock = new ThreadCache(MbItemStock.class) {
			@Override
			protected Object handle(Object key) {
				return mbItemStockService.get((Integer) key);
			}
		};
		MbItemStockLogExport footer = new MbItemStockLogExport();
		footer.setInQuantity(0);
		footer.setOutQuantity(0);
		footer.setInAmount(0);
		footer.setOutAmount(0);
		footer.setSummary("合计");
		for (MbItemStockLog row : rows) {
			MbItemStockLogExport export = new MbItemStockLogExport();
			BeanUtils.copyProperties(row, export);
			mbItemStockLogExportList.add(export);
			//入库单；取入库价格
			if (!F.empty(row.getReason())) {
				Pattern p = Pattern.compile("([\\s\\S]*)ID[:：](\\d+)[\\s\\S]*库存[:：](\\d+)");
				Matcher m = p.matcher(row.getReason());
				String[] strs = new String[3];
				boolean isMatch = m.find();
				int i = 0, j = m.groupCount();
				while (isMatch && i < j) {
					strs[i] = m.group(i + 1);
					i++;
				}
				if (isMatch) {
					export.setRefTypeName(strs[0]);
					export.setSummary(row.getReason());
					export.setRefId(strs[1]);
					if (F.empty(export.getEndQuantity())) {
						String endQuantity = strs[2];
						if (!F.empty(endQuantity)) {
							export.setEndQuantity(Integer.parseInt(endQuantity));
						}
					}
				} else {
					export.setRefTypeName(export.getLogTypeName());
				}
			} else {
				export.setRefTypeName(export.getLogTypeName());
			}

			if (!F.empty(export.getRefTypeName()) && export.getRefTypeName().indexOf("入库") > -1) {
				export.setInQuantity(export.getQuantity());
				if(!F.empty(export.getInPrice())) {
					export.setInAmount(export.getInPrice() * export.getInQuantity());
					footer.setInAmount(footer.getInAmount() + export.getInAmount());
				}
				footer.setInQuantity(footer.getInQuantity() + export.getQuantity());

			} else {
				export.setOutPrice(export.getCostPrice());
				export.setOutQuantity(export.getQuantity());
				footer.setOutQuantity(footer.getOutQuantity()+export.getQuantity());
				if(!F.empty(export.getOutPrice())) {
					export.setOutAmount(export.getOutPrice() * export.getOutQuantity());
					footer.setOutAmount(footer.getOutAmount() + export.getOutAmount());
				}
			}
			MbItemStock mbItemStock1 = mbItemStock.getValue(export.getItemStockId());

			MbItem mbItem = mbItemService.getFromCache(mbItemStock1.getItemId());
			if(mbItem!=null)
			export.setItemName(mbItem.getName());

		}
		if (!F.empty(footer.getInQuantity()))
			footer.setInPrice(footer.getInAmount() / footer.getInQuantity());
		if (!F.empty(footer.getOutQuantity()))
			footer.setOutPrice(footer.getOutAmount() / footer.getOutQuantity());
		dataGrid.setFooter(Arrays.asList(footer));

		dataGrid.setRows(mbItemStockLogExportList);
		return dataGrid;
	}

	/**
	 * 获取MbItemStockLog数据表格excel
	 */
	@RequestMapping("/download")
	public void download(MbItemStockLog mbItemStockLog, PageHelper ph,String downloadFields,HttpServletResponse response,Integer itemId) throws SecurityException, NoSuchMethodException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, IOException{
		DataGrid dg = dataGridReport(mbItemStockLog,ph,itemId);
		List<MbItemStockLogExport> mbItemStockLogExportList = dg.getRows();
		if (CollectionUtils.isNotEmpty(mbItemStockLogExportList)) {
			for (MbItemStockLogExport mbItemStockLogExport : mbItemStockLogExportList) {
				if (!F.empty(mbItemStockLogExport.getInitPrice())) {
					mbItemStockLogExport.setInitPriceElement(mbItemStockLogExport.getInitPrice() / 100.0);
				}
				if (!F.empty(mbItemStockLogExport.getInitAmount())){
					mbItemStockLogExport.setInitAmountElement(mbItemStockLogExport.getInitAmount() / 100.0);
				}
				if (!F.empty(mbItemStockLogExport.getInPrice())) {
					mbItemStockLogExport.setInPriceElement(mbItemStockLogExport.getInPrice() / 100.0);
				}
				if (!F.empty(mbItemStockLogExport.getInAmount())) {
					mbItemStockLogExport.setInAmountElement(mbItemStockLogExport.getInAmount() / 100.0);
				}
				if (!F.empty(mbItemStockLogExport.getOutPrice())) {
					mbItemStockLogExport.setOutPriceElement(mbItemStockLogExport.getOutPrice() / 100.0);
				}
				if (!F.empty(mbItemStockLogExport.getOutAmount())) {
					mbItemStockLogExport.setOutAmountElement(mbItemStockLogExport.getOutAmount() / 100.0);
				}
				if (!F.empty(mbItemStockLogExport.getCostPrice())) {
					mbItemStockLogExport.setCostPriceElement(mbItemStockLogExport.getCostPrice() / 100.0);
				}
				if (!F.empty(mbItemStockLogExport.getEndQuantity())&&!F.empty(mbItemStockLogExport.getCostPrice())) {
					mbItemStockLogExport.setCostAmountElement((mbItemStockLogExport.getEndQuantity()*mbItemStockLogExport.getCostPrice())/ 100.0);
				}
			}

			MbItemStockLogExport footer = (MbItemStockLogExport)dg.getFooter().get(0);
			footer.setInPriceElement(footer.getInPrice() / 100.0);
			footer.setInAmountElement(footer.getInAmount() / 100.0);
			footer.setOutPriceElement(footer.getOutPrice() / 100.0);
			footer.setOutAmountElement(footer.getOutAmount() / 100.0);
		}
		downloadFields = downloadFields.replace("&quot;", "\"");
		downloadFields = downloadFields.substring(1,downloadFields.length()-1);
		downloadFields =downloadFields.replace("{\"colspan\":3,\"title\":\"期初结存\"},{\"colspan\":3,\"title\":\"本期进货\"},{\"colspan\":3,\"title\":\"本期出货\"},{\"colspan\":3,\"title\":\"期末结存\"}],[","");
		List<Colum> colums = JSON.parseArray(downloadFields, Colum.class);
		if (CollectionUtils.isNotEmpty(colums)) {
			for (Colum colum : colums) {
				switch (colum.getField()) {
					case "initQuantity":
						colum.setTitle("(期初)数量");
						break;
					case "initPrice":
						colum.setTitle("(期初)进价");
						colum.setField("initPriceElement");
						break;
					case "initAmount":
						colum.setTitle("(期初)金额");
						colum.setField("initAmountElement");
						break;
					case "inQuantity":
						colum.setTitle("(进货)数量");
						break;
					case "inPrice":
						colum.setTitle("(进货)进价");
						colum.setField("inPriceElement");
						break;
					case "inAmount":
						colum.setTitle("(进货)金额");
						colum.setField("inAmountElement");
						break;
					case "outQuantity":
						colum.setTitle("(出货)数量");
						break;
					case "outPrice":
						colum.setTitle("(出货)进价");
						colum.setField("outPriceElement");
						break;
					case "outAmount":
						colum.setTitle("(出货)金额");
						colum.setField("outAmountElement");
						break;
					case "endQuantity":
						colum.setTitle("(期末)数量");
						break;
					case "costPrice":
						colum.setTitle("(期末)进价");
						colum.setField("costPriceElement");
						break;
					case "costAmount":
						colum.setTitle("(期末)金额");
						colum.setField("costAmountElement");
						break;
				}
			}
		}
		downloadTable(colums, dg, response);
	}
	/**
	 * 跳转到添加MbItemStockLog页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/addPage")
	public String addPage(HttpServletRequest request) {
		MbItemStockLog mbItemStockLog = new MbItemStockLog();
		return "/mbitemstocklog/mbItemStockLogAdd";
	}



	/**
	 * 添加MbItemStockLog
	 * 
	 * @return
	 */
	@RequestMapping("/add")
	@ResponseBody
	public Json add(MbItemStockLog mbItemStockLog) {
		Json j = new Json();		
		mbItemStockLogService.add(mbItemStockLog);
		j.setSuccess(true);
		j.setMsg("添加成功！");		
		return j;
	}

	/**
	 * 跳转到MbItemStockLog查看页面
	 * 
	 * @return
	 */
	@RequestMapping("/view")
	public String view(HttpServletRequest request, Integer id) {
		request.setAttribute("itemStockId", id);
		return "/mbitemstocklog/mbItemStockLogView";
	}

	/**
	 * 跳转到MbItemStockLog修改页面
	 * 
	 * @return
	 */
	@RequestMapping("/editPage")
	public String editPage(HttpServletRequest request, Integer id) {
		MbItemStockLog mbItemStockLog = mbItemStockLogService.get(id);
		request.setAttribute("mbItemStockLog", mbItemStockLog);
		return "/mbitemstocklog/mbItemStockLogEdit";
	}

	/**
	 * 修改MbItemStockLog
	 * 
	 * @param mbItemStockLog
	 * @return
	 */
	@RequestMapping("/edit")
	@ResponseBody
	public Json edit(MbItemStockLog mbItemStockLog) {
		Json j = new Json();		
		mbItemStockLogService.edit(mbItemStockLog);
		j.setSuccess(true);
		j.setMsg("编辑成功！");		
		return j;
	}

	/**
	 * 删除MbItemStockLog
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping("/delete")
	@ResponseBody
	public Json delete(Integer id) {
		Json j = new Json();
		mbItemStockLogService.delete(id);
		j.setMsg("删除成功！");
		j.setSuccess(true);
		return j;
	}

	/**
	 * 跳转到MbItemStockLog变更管理页面
	 *
	 * @return
	 */
	@RequestMapping("/managerChange")
	public String managerChange(HttpServletRequest request) {
		return "/mbitemstocklog/mbItemStockLogChange";
	}

	/**
	 * 获取MbItemStockLog变更数据表格
	 */
	@RequestMapping("/dataGridChange")
	@ResponseBody
	public DataGrid dataGridChange(MbItemStockLog mbItemStockLog, PageHelper ph) {
		if (mbItemStockLog.getStockLogStartTime() == null || mbItemStockLog.getStockLogEndTime() == null) {
			return new DataGrid();
		}
		mbItemStockLog.setLogType("SL04");
		mbItemStockLog.setQuantity(0);
		return mbItemStockLogService.dataGridStockInLog(mbItemStockLog, ph);
	}

	/**
	 * 获取MbItemStockLog数据表格excel
	 */
	@RequestMapping("/downloadChange")
	public void downloadChange(MbItemStockLog mbItemStockLog, PageHelper ph, String downloadFields, HttpServletResponse response) throws SecurityException, NoSuchMethodException, IllegalArgumentException, IllegalAccessException, InvocationTargetException, IOException {
		mbItemStockLog.setLogType("SL04");
		mbItemStockLog.setQuantity(0);
		DataGrid dg = mbItemStockLogService.dataGridStockInLog(mbItemStockLog, ph);
		downloadFields = downloadFields.replace("&quot;", "\"");
		downloadFields = downloadFields.substring(1, downloadFields.length() - 1);
		List<Colum> colums = JSON.parseArray(downloadFields, Colum.class);
		downloadTable(colums, dg, response);
	}

}
