<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobian.model.TmbItemStock" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%>  
<script type="text/javascript">
	$(function() {
	 parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/mbItemStockController/add',
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
				<input type="hidden" name="id"/>
			<table class="table table-hover table-condensed">
				<tr>
					<th><%=TmbItemStock.ALIAS_WAREHOUSE_NAME%></th>
					<td>
						<jb:selectGrid dataType="warehouseId" name="warehouseId" required="true"></jb:selectGrid>
					</td>
					<th><%=TmbItemStock.ALIAS_ITEM_NAME%></th>
					<td>
						<jb:selectGrid dataType="itemId" name="itemId" required="true"></jb:selectGrid>
					</td>
				</tr>	
				<tr>
					<th>盘点类型</th>
					<td>
						<jb:select dataType="SL" name="logType" required="true"></jb:select>
					</td>
					<th><%=TmbItemStock.ALIAS_QUANTITY%></th>	
					<td>
						<input class="span2 easyui-validatebox" name="quantity" type="number" data-options="required:true"/>
					</td>							
				</tr>
				<tr>
					<th>原因</th>
					<td colspan="3">
						<textarea class ="easyui-validatebox" data-options="required:true" name="remark" style="width: 90%" placeholder="请录入原因"></textarea>
					</td>
				</tr>
			</table>		
		</form>
	</div>
</div>