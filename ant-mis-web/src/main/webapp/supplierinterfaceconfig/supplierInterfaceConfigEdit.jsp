<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%> 
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');
		$('#form').form({
			url : '${pageContext.request.contextPath}/supplierInterfaceConfigController/edit',
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
				<input type="hidden" name="id" value = "${supplierInterfaceConfig.id}"/>
			<table class="table table-hover table-condensed">
				<tr>
					<th>接口类型</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="interfaceType" type="text" value="${supplierInterfaceConfig.interfaceTypeName}"/>
					</td>
					<th>appkey</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="appKey" type="text" value="${supplierInterfaceConfig.appKey}"/>
					</td>
				</tr>
				<tr>
					<th>appSecret</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="appSecret" type="text" value="${supplierInterfaceConfig.appSecret}"/>
					</td>
					<th>serviceUrl</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="serviceUrl" type="text" value="${supplierInterfaceConfig.serviceUrl}"/>
					</td>
				</tr>
				<tr>
					<th>版本</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="version" type="text" value="${supplierInterfaceConfig.version}"/>
					</td>
					<th>仓库代码</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="warehouseCode" type="text" value="${supplierInterfaceConfig.warehouseCode}"/>
					</td>
				</tr>
				<tr>
					<th>物流公司代码</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="logisticsCode" type="text" value="${supplierInterfaceConfig.logisticsCode}"/>
					</td>
					<th>状态映射</th>
					<td>
						<input class="easyui-validatebox span2"  required="true" name="statusMap" type="text" value="${supplierInterfaceConfig.statusMap}"/>
					</td>
				</tr>
				<tr>
					<th>客户ID</th>
					<td>
						<input class="easyui-validatebox span2" required="true" value="${supplierInterfaceConfig.customerId}" name="customerId" type="text"/>
					</td>
					<th>是否上线</th>
					<td colspan="3">
						<select class="easyui-combobox" name="online" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
							<c:if test="${supplierInterfaceConfig.online == false}">
								<option value="1">是</option>
								<option value="0" selected="selected">否</option>
							</c:if>
							<c:if test="${supplierInterfaceConfig.online == true}">
								<option value="1" selected="selected">是</option>
								<option value="0">否</option>
							</c:if>
						</select>
					</td>
				</tr>
				<tr>
					<th>备注</th>
					<td colspan="3">
						<textarea name="remark" style="width: 97%" rows="3"    class="easyui-validatebox">${supplierInterfaceConfig.remark}</textarea>
					</td>
				</tr>
			</table>				
		</form>
	</div>
</div>