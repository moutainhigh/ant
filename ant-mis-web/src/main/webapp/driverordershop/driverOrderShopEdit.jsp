<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bx.ant.model.TdriverOrderShop" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%> 
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/driverOrderShopController/edit',
			onSubmit : function() {
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
				});
				var isValid = $(this).form('validate');
				if (!isValid) {
					parent.$.messager.progress('close');
				}
				return isValid;
			},
			success : function(result) {
				parent.$.messager.progress('close');
				result = $.parseJSON(result);
				if (result.success) {
					parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
					parent.$.modalDialog.handler.dialog('close');
				} else {
					parent.$.messager.alert('错误', result.msg, 'error');
				}
			}
		});
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
		<form id="form" method="post">
				<input type="hidden" name="id" value = "${driverOrderShop.id}"/>
			<table class="table table-hover table-condensed">
				<tr>	
					<th><%=TdriverOrderShop.ALIAS_TENANT_ID%></th>	
					<td>
											<input class="span2" name="tenantId" type="text" value="${driverOrderShop.tenantId}"/>
					</td>							
					<th><%=TdriverOrderShop.ALIAS_ADDTIME%></th>	
					<td>
					<input class="span2" name="addtime" type="text" onclick="WdatePicker({dateFmt:'<%=TdriverOrderShop.FORMAT_ADDTIME%>'})"   maxlength="0" value="${driverOrderShop.addtime}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TdriverOrderShop.ALIAS_UPDATETIME%></th>	
					<td>
					<input class="span2" name="updatetime" type="text" onclick="WdatePicker({dateFmt:'<%=TdriverOrderShop.FORMAT_UPDATETIME%>'})"   maxlength="0" value="${driverOrderShop.updatetime}"/>
					</td>							
					<th><%=TdriverOrderShop.ALIAS_ISDELETED%></th>	
					<td>
											<input class="span2" name="isdeleted" type="text" class="easyui-validatebox span2" data-options="required:true" value="${driverOrderShop.isdeleted}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TdriverOrderShop.ALIAS_DELIVER_ORDER_SHOP_ID%></th>	
					<td>
											<input class="span2" name="deliverOrderShopId" type="text" value="${driverOrderShop.deliverOrderShopId}"/>
					</td>							
					<th><%=TdriverOrderShop.ALIAS_SHOP_ID%></th>	
					<td>
											<input class="span2" name="shopId" type="text" value="${driverOrderShop.shopId}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TdriverOrderShop.ALIAS_STATUS%></th>	
					<td>
											<jb:select dataType="DDSS" name="status" value="${driverOrderShop.status}"></jb:select>	
					</td>							
					<th><%=TdriverOrderShop.ALIAS_AMOUNT%></th>	
					<td>
											<input class="span2" name="amount" type="text" value="${driverOrderShop.amount}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TdriverOrderShop.ALIAS_PAY_STATUS%></th>	
					<td>
											<jb:select dataType="DDPS" name="payStatus" value="${driverOrderShop.payStatus}"></jb:select>	
					</td>							
					<th><%=TdriverOrderShop.ALIAS_DRIVER_ORDER_SHOP_BILL_ID%></th>	
					<td>
											<input class="span2" name="driverOrderShopBillId" type="text" value="${driverOrderShop.driverOrderShopBillId}"/>
					</td>							
			</tr>	
			</table>				
		</form>
	</div>
</div>