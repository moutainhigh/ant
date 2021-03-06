<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobian.model.TmbOrder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%> 
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/mbOrderController/edit',
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
				<input type="hidden" name="id" value = "${mbOrder.id}"/>
			<table class="table table-hover table-condensed">
				<tr>	
					<th><%=TmbOrder.ALIAS_TENANT_ID%></th>	
					<td>
											<input class="span2" name="tenantId" type="text" value="${mbOrder.tenantId}"/>
					</td>							
					<th><%=TmbOrder.ALIAS_ADDTIME%></th>	
					<td>
					<input class="span2" name="addtime" type="text" onclick="WdatePicker({dateFmt:'<%=TmbOrder.FORMAT_ADDTIME%>'})"   maxlength="0" value="${mbOrder.addtime}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_UPDATETIME%></th>	
					<td>
					<input class="span2" name="updatetime" type="text" onclick="WdatePicker({dateFmt:'<%=TmbOrder.FORMAT_UPDATETIME%>'})"   maxlength="0" value="${mbOrder.updatetime}"/>
					</td>							
					<th><%=TmbOrder.ALIAS_ISDELETED%></th>	
					<td>
											<input class="span2" name="isdeleted" type="text" class="easyui-validatebox span2" data-options="required:true" value="${mbOrder.isdeleted}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_USER_ID%></th>	
					<td>
											<input class="span2" name="userId" type="text" value="${mbOrder.userId}"/>
					</td>							
					<th><%=TmbOrder.ALIAS_TOTAL_PRICE%></th>	
					<td>
											<input class="span2" name="totalPrice" type="text" value="${mbOrder.totalPrice}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_STATUS%></th>	
					<td>
											<jb:select dataType="OD" name="status" value="${mbOrder.status}"></jb:select>	
					</td>							
					<th><%=TmbOrder.ALIAS_DELIVERY_WAY%></th>	
					<td>
											<jb:select dataType="DW" name="deliveryWay" value="${mbOrder.deliveryWay}"></jb:select>	
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_DELIVERY_STATUS%></th>	
					<td>
											<jb:select dataType="DS" name="deliveryStatus" value="${mbOrder.deliveryStatus}"></jb:select>	
					</td>							
					<th><%=TmbOrder.ALIAS_DELIVERY_REQUIRE_TIME%></th>	
					<td>
					<input class="span2" name="deliveryRequireTime" type="text" onclick="WdatePicker({dateFmt:'<%=TmbOrder.FORMAT_DELIVERY_REQUIRE_TIME%>'})"   maxlength="0" value="${mbOrder.deliveryRequireTime}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_DELIVERY_ADDRESS%></th>	
					<td>
											<input class="span2" name="deliveryAddress" type="text" value="${mbOrder.deliveryAddress}"/>
					</td>							
					<th><%=TmbOrder.ALIAS_DELIVERY_REGION%></th>	
					<td>
											<input class="span2" name="deliveryRegion" type="text" value="${mbOrder.deliveryRegion}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_PAY_STATUS%></th>	
					<td>
											<jb:select dataType="PS" name="payStatus" value="${mbOrder.payStatus}"></jb:select>	
					</td>							
					<th><%=TmbOrder.ALIAS_PAY_WAY%></th>	
					<td>
											<jb:select dataType="PW" name="payWay" value="${mbOrder.payWay}"></jb:select>	
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_PAY_TIME%></th>	
					<td>
					<input class="span2" name="payTime" type="text" onclick="WdatePicker({dateFmt:'<%=TmbOrder.FORMAT_PAY_TIME%>'})"   maxlength="0" value="${mbOrder.payTime}"/>
					</td>							
					<th><%=TmbOrder.ALIAS_INVOICE_WAY%></th>	
					<td>
											<jb:select dataType="IW" name="invoiceWay" value="${mbOrder.invoiceWay}"></jb:select>	
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_CONTACT_PHONE%></th>	
					<td>
											<input class="span2" name="contactPhone" type="text" value="${mbOrder.contactPhone}"/>
					</td>							
					<th><%=TmbOrder.ALIAS_CONTACT_PEOPLE%></th>	
					<td>
											<input class="span2" name="contactPeople" type="text" value="${mbOrder.contactPeople}"/>
					</td>							
			</tr>	
				<tr>	
					<th><%=TmbOrder.ALIAS_USER_REMARK%></th>	
					<td>
											<input class="span2" name="userRemark" type="text" value="${mbOrder.userRemark}"/>
					</td>							
			</tr>	
			</table>				
		</form>
	</div>
</div>