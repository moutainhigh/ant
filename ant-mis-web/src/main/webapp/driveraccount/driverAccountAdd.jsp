<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%>  
<script type="text/javascript">
	$(function() {
	 parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/driverAccountController/add',
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
					<th>是否上线</th>
					<td>
						<select class="easyui-combobox" name="online" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
							<c:if test="${driverAccount.online == false}">
								<option value="1">是</option>
								<option value="0" selected="selected">否</option>
							</c:if>
							<c:if test="${driverAccount.online  == true}">
								<option value="1" selected="selected">是</option>
								<option value="0">否</option>
							</c:if>
						</select>
					</td>
					<th>类型</th>
					<td>
						<jb:select dataType="DATP" name="type" value="${driverAccount.typeName}"></jb:select>
					</td>
				</tr>	
			</table>		
		</form>
	</div>
</div>