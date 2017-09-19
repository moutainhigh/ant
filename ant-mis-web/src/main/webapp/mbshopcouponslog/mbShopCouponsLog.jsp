﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobian.model.TmbShopCouponsLog" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%> 
<!DOCTYPE html>
<html>
<head>
<title>MbShopCouponsLog管理</title>
<jsp:include page="../inc.jsp"></jsp:include>
<c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsLogController/editPage')}">
	<script type="text/javascript">
		$.canEdit = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsLogController/delete')}">
	<script type="text/javascript">
		$.canDelete = true;
	</script>
</c:if>
<c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsLogController/view')}">
	<script type="text/javascript">
		$.canView = true;
	</script>
</c:if>
<script type="text/javascript">
	var dataGrid;
	$(function() {
		dataGrid = $('#dataGrid').datagrid({
			url : '${pageContext.request.contextPath}/mbShopCouponsLogController/dataGrid',
			fit : true,
			fitColumns : true,
			border : false,
			pagination : true,
			idField : 'id',
			pageSize : 10,
			pageList : [ 10, 20, 30, 40, 50 ],
			sortName : 'id',
			sortOrder : 'desc',
			checkOnSelect : false,
			selectOnCheck : false,
			nowrap : false,
			striped : true,
			rownumbers : true,
			singleSelect : true,
			columns : [ [ {
				field : 'id',
				title : '编号',
				width : 150,
				hidden : true
				}, {
				field : 'updatetime',
				title : '<%=TmbShopCouponsLog.ALIAS_UPDATETIME%>',
				width : 50		
				}, {
				field : 'shopCouponsId',
				title : '<%=TmbShopCouponsLog.ALIAS_SHOP_COUPONS_ID%>',
				width : 50		
				}, {
				field : 'quantityUsed',
				title : '<%=TmbShopCouponsLog.ALIAS_QUANTITY_USED%>',
				width : 50
				}, {
                field : 'quantityTotal',
                title : '<%=TmbShopCouponsLog.ALIAS_QUANTITY_TOTAL%>',
                width : 50
            	}, {
				field : 'loginId',
				title : '<%=TmbShopCouponsLog.ALIAS_LOGIN_ID%>',
				width : 50		
				}, {
				field : 'refId',
				title : '<%=TmbShopCouponsLog.ALIAS_REF_ID%>',
				width : 50		
				}, {
				field : 'refType',
				title : '<%=TmbShopCouponsLog.ALIAS_REF_TYPE%>',
				width : 50		
				}, {
				field : 'reason',
				title : '<%=TmbShopCouponsLog.ALIAS_REASON%>',
				width : 50		
				}, {
				field : 'remark',
				title : '<%=TmbShopCouponsLog.ALIAS_REMARK%>',
				width : 50		
				}, {
				field : 'action',
				title : '操作',
				width : 100,
				formatter : function(value, row, index) {
					var str = '';
					if ($.canEdit) {
						str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_edit.png');
					}
					str += '&nbsp;';
					if ($.canDelete) {
						str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_delete.png');
					}
					str += '&nbsp;';
					if ($.canView) {
						str += $.formatString('<img onclick="viewFun(\'{0}\');" src="{1}" title="查看"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/bug/bug_link.png');
					}
					return str;
				}
			} ] ],
			toolbar : '#toolbar',
			onLoadSuccess : function() {
				$('#searchForm table').show();
				parent.$.messager.progress('close');

				$(this).datagrid('tooltip');
			}
		});
	});

	function deleteFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.messager.confirm('询问', '您是否要删除当前数据？', function(b) {
			if (b) {
				parent.$.messager.progress({
					title : '提示',
					text : '数据处理中，请稍后....'
				});
				$.post('${pageContext.request.contextPath}/mbShopCouponsLogController/delete', {
					id : id
				}, function(result) {
					if (result.success) {
						parent.$.messager.alert('提示', result.msg, 'info');
						dataGrid.datagrid('reload');
					}
					parent.$.messager.progress('close');
				}, 'JSON');
			}
		});
	}

	function editFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '编辑数据',
			width : 780,
			height : 500,
			href : '${pageContext.request.contextPath}/mbShopCouponsLogController/editPage?id=' + id,
			buttons : [ {
				text : '编辑',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}

	function viewFun(id) {
		if (id == undefined) {
			var rows = dataGrid.datagrid('getSelections');
			id = rows[0].id;
		}
		parent.$.modalDialog({
			title : '查看数据',
			width : 780,
			height : 500,
			href : '${pageContext.request.contextPath}/mbShopCouponsLogController/view?id=' + id
		});
	}

	function addFun() {
		parent.$.modalDialog({
			title : '添加数据',
			width : 780,
			height : 500,
			href : '${pageContext.request.contextPath}/mbShopCouponsLogController/addPage',
			buttons : [ {
				text : '添加',
				handler : function() {
					parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
					var f = parent.$.modalDialog.handler.find('#form');
					f.submit();
				}
			} ]
		});
	}
	function downloadTable(){
		var options = dataGrid.datagrid("options");
		var $colums = [];		
		$.merge($colums, options.columns); 
		$.merge($colums, options.frozenColumns);
		var columsStr = JSON.stringify($colums);
	    $('#downloadTable').form('submit', {
	        url:'${pageContext.request.contextPath}/mbShopCouponsLogController/download',
	        onSubmit: function(param){
	        	$.extend(param, $.serializeObject($('#searchForm')));
	        	param.downloadFields = columsStr;
	        	param.page = options.pageNumber;
	        	param.rows = options.pageSize;
	        	
       	 }
        }); 
	}
	function searchFun() {
		dataGrid.datagrid('load', $.serializeObject($('#searchForm')));
	}
	function cleanFun() {
		$('#searchForm input').val('');
		dataGrid.datagrid('load', {});
	}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit : true,border : false">
		<div data-options="region:'north',title:'查询条件',border:false" style="height: 160px; overflow: hidden;">
			<form id="searchForm">
				<table class="table table-hover table-condensed" style="display: none;">
						<tr>	
							<th><%=TmbShopCouponsLog.ALIAS_TENANT_ID%></th>	
							<td>
											<input type="text" name="tenantId" maxlength="10" class="span2"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_ADDTIME%></th>	
							<td>
								<input type="text" class="span2" onclick="WdatePicker({dateFmt:'<%=TmbShopCouponsLog.FORMAT_ADDTIME%>'})" id="addtimeBegin" name="addtimeBegin"/>
								<input type="text" class="span2" onclick="WdatePicker({dateFmt:'<%=TmbShopCouponsLog.FORMAT_ADDTIME%>'})" id="addtimeEnd" name="addtimeEnd"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_UPDATETIME%></th>	
							<td>
								<input type="text" class="span2" onclick="WdatePicker({dateFmt:'<%=TmbShopCouponsLog.FORMAT_UPDATETIME%>'})" id="updatetimeBegin" name="updatetimeBegin"/>
								<input type="text" class="span2" onclick="WdatePicker({dateFmt:'<%=TmbShopCouponsLog.FORMAT_UPDATETIME%>'})" id="updatetimeEnd" name="updatetimeEnd"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_ISDELETED%></th>	
							<td>
											<input type="text" name="isdeleted" maxlength="0" class="span2"/>
							</td>
						</tr>	
						<tr>	
							<th><%=TmbShopCouponsLog.ALIAS_SHOP_COUPONS_ID%></th>	
							<td>
											<input type="text" name="shopCouponsId" maxlength="10" class="span2"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_QUANTITY_USED%></th>
							<td>
											<input type="text" name="quantityUsed" maxlength="10" class="span2"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_QUANTITY_TOTAL%></th>
							<td>
								<input type="text" name="quantityTotal" maxlength="10" class="span2"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_LOGIN_ID%></th>	
							<td>
											<input type="text" name="loginId" maxlength="64" class="span2"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_REF_ID%></th>	
							<td>
											<input type="text" name="refId" maxlength="64" class="span2"/>
							</td>
						</tr>	
						<tr>	
							<th><%=TmbShopCouponsLog.ALIAS_REF_TYPE%></th>	
							<td>
											<input type="text" name="refType" maxlength="10" class="span2"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_REASON%></th>	
							<td>
											<input type="text" name="reason" maxlength="512" class="span2"/>
							</td>
							<th><%=TmbShopCouponsLog.ALIAS_REMARK%></th>	
							<td>
											<input type="text" name="remark" maxlength="512" class="span2"/>
							</td>
						</tr>	
				</table>
			</form>
		</div>
		<div data-options="region:'center',border:false">
			<table id="dataGrid"></table>
		</div>
	</div>
	<div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsLogController/addPage')}">
			<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'bug_add'">添加</a>
		</c:if>
		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_add',plain:true" onclick="searchFun();">过滤条件</a><a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'brick_delete',plain:true" onclick="cleanFun();">清空条件</a>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsLogController/download')}">
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'server_go',plain:true" onclick="downloadTable();">导出</a>		
			<form id="downloadTable" target="downloadIframe" method="post" style="display: none;">
			</form>
			<iframe id="downloadIframe" name="downloadIframe" style="display: none;"></iframe>
		</c:if>
	</div>	
</body>
</html>