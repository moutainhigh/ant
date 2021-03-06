<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobian.model.TmbOrderCallbackItem" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');		
	});
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false">
		<table class="table table-hover table-condensed">
				<tr>	
					<th><%=TmbOrderCallbackItem.ALIAS_TENANT_ID%></th>	
					<td>
						${mbOrderCallbackItem.tenantId}							
					</td>							
					<th><%=TmbOrderCallbackItem.ALIAS_ADDTIME%></th>	
					<td>
						${mbOrderCallbackItem.addtime}							
					</td>							
				</tr>		
				<tr>	
					<th><%=TmbOrderCallbackItem.ALIAS_UPDATETIME%></th>	
					<td>
						${mbOrderCallbackItem.updatetime}							
					</td>							
					<th><%=TmbOrderCallbackItem.ALIAS_ISDELETED%></th>	
					<td>
						${mbOrderCallbackItem.isdeleted}							
					</td>							
				</tr>		
				<tr>	
					<th><%=TmbOrderCallbackItem.ALIAS_ORDER_ID%></th>	
					<td>
						${mbOrderCallbackItem.orderId}							
					</td>							
					<th><%=TmbOrderCallbackItem.ALIAS_ITEM_ID%></th>	
					<td>
						${mbOrderCallbackItem.itemId}							
					</td>							
				</tr>		
				<tr>	
					<th><%=TmbOrderCallbackItem.ALIAS_QUANTITY%></th>	
					<td>
						${mbOrderCallbackItem.quantity}							
					</td>							
				</tr>		
		</table>
	</div>
</div>