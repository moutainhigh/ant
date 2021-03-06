<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobian.model.TmbShop" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%>  
<script type="text/javascript">
	$(function() {
	 parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/mbShopController/add',
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
					<th style="width: 50px;"><%=TmbShop.ALIAS_NAME%>
					</th>
					<td>
						<input name="name" type="text" class="easyui-validatebox span2" data-options="required:true"/>
					</td>
					<th style="width: 50px;"><%=TmbShop.ALIAS_REGION_ID%>
					</th>
					<td>
						<jb:selectGrid dataType="region" name="regionId" value="${mbShop.regionId}" required="true"></jb:selectGrid>
					</td>

				</tr>
				<tr>
					<th style="width: 50px;"><%=TmbShop.ALIAS_SHOP_TYPE%>
					</th>
					<td>
						<jb:select dataType="ST" name="shopType" mustSelect="true" required="true"></jb:select>
					</td>
					<th style="width: 50px;">选择主店
					</th>
					<td colspan="3">
						<jb:selectGrid dataType="shopId" name="parentId" params="{onlyMain:true}"></jb:selectGrid>
					</td>

				</tr>

				<tr>
					<th style="width: 50px;"><%=TmbShop.ALIAS_CONTACT_PEOPLE%>
					</th>
					<td>
						<input class="span2 easyui-validatebox" name="contactPeople" data-options="required:true" type="text"/>
					</td>
					<th style="width: 50px;"><%=TmbShop.ALIAS_CONTACT_PHONE%>
					</th>
					<td>
						<input class="span2 easyui-validatebox" name="contactPhone" data-options="required:true" type="text"/>
					</td>
				</tr>
				<tr>
					<th style="width: 50px;"><%=TmbShop.ALIAS_ADDRESS%>
					</th>
					<td colspan="3">
						<input class="span2 easyui-validatebox"  data-options="required:true" name="address" type="text" style="width: 80%"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>