<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobian.model.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
	<title>MbItem管理</title>
	<jsp:include page="../inc.jsp"></jsp:include>
	<c:if test="${fn:contains(sessionInfo.resourceList, '/mbSupplierContractClauseController/editPage')}">
	<script type="text/javascript">
        $.canEdit = true;
	</script>
	</c:if>
	<c:if test="${fn:contains(sessionInfo.resourceList, '/mbSupplierContractClauseController/delete')}">
	<script type="text/javascript">
        $.canDelete = true;
	</script>
	</c:if>
	<c:if test="${fn:contains(sessionInfo.resourceList, '/mbSupplierContractClauseController/view')}">
	<script type="text/javascript">
        $.canView = true;
	</script>
	</c:if>
<script type="text/javascript">
	$(function() {
		parent.$.messager.progress('close');		
	});
    var contractClauseDataGrid;
    $(function() {
        contractClauseDataGrid = $('#contractClauseDataGrid').datagrid({
            url : '${pageContext.request.contextPath}/mbSupplierContractClauseController/dataGrid?supplierContractId='+${mbSupplierContract.id},
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
            },   {
                field : 'clauseName',
                title : '<%=TmbSupplierContractClause.ALIAS_CLAUSE_CODE%>',
                width : 80
            }, {
                field : 'value',
                title : '<%=TmbSupplierContractClause.ALIAS_VALUE%>',
                width : 60
            },  {
                field : 'action',
                title : '操作',
                width : 100,
                formatter : function(value, row, index) {
                    var str = '';
                    if ($.canEdit) {
                        str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/pencil.png');
                    }
                    str += '&nbsp;';
                    if ($.canDelete) {
                        str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/cancel.png');
                    }
                    str += '&nbsp;';
                    if ($.canView) {
                        str += $.formatString('<img onclick="viewFun(\'{0}\');" src="{1}" title="查看"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/map/magnifier.png');
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
    })


   function loadmbSupitemDataGrid() {
	        return mbsupitemDataGrid= $('#mbsupitemDataGrid').datagrid({
            url : '${pageContext.request.contextPath}/mbSupplierContractItemController/dataGrid?supplierContractId='+${mbSupplierContract.id},
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
            nowrap : true,
            striped : true,
            rownumbers : true,
            singleSelect : true,
            columns : [ [ {
                field : 'id',
                title : '编号',
                width : 150,
                hidden : true
            }, {
                field : 'itemName',
                title : '<%=TmbSupplierContractItem.ALIAS_ITEM_NAME%>',
                width : 100
            }, {
                field : 'price',
                title : '<%=TmbSupplierContractItem.ALIAS_PRICE%>',
                width : 30,
                align: "right",
                formatter:function(value){
                    return $.formatMoney(value);
                }
            }] ],
            toolbar : '#supitemtoolbar',
            onLoadSuccess : function() {
                $('#mbsupitemSearchForm table').show();
                parent.$.messager.progress('close');

                $(this).datagrid('tooltip');
            }
        });
    }

    function deleteFun(id) {
        if (id == undefined) {
            var rows = contractClauseDataGrid.datagrid('getSelections');
            id = rows[0].id;
        }
        parent.$.messager.confirm('询问', '您是否要删除当前数据？', function(b) {
            if (b) {
                parent.$.messager.progress({
                    title : '提示',
                    text : '数据处理中，请稍后....'
                });
                $.post('${pageContext.request.contextPath}/mbSupplierContractClauseController/delete', {
                    id : id
                }, function(result) {
                    if (result.success) {
                        parent.$.messager.alert('提示', result.msg, 'info');
                        contractClauseDataGrid.datagrid('reload');
                    }
                    parent.$.messager.progress('close');
                }, 'JSON');
            }
        });
    }

    function editFun(id) {
        if (id == undefined) {
            var rows = contractClauseDataGrid.datagrid('getSelections');
            id = rows[0].id;
        }
        parent.$.modalDialog({
            title : '编辑数据',
            width : 780,
            height : 400,
            href : '${pageContext.request.contextPath}/mbSupplierContractClauseController/editPage?id=' + id,
            buttons : [ {
                text : '编辑',
                handler : function() {
                    parent.$.modalDialog.openner_dataGrid = contractClauseDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            } ]
        });
    }

    function viewFun(id) {
        if (id == undefined) {
            var rows = contractClauseDataGrid.datagrid('getSelections');
            id = rows[0].id;
        }
        parent.$.modalDialog({
            title : '查看数据',
            width : 780,
            height : 400,
            href : '${pageContext.request.contextPath}/mbSupplierContractClauseController/view?id=' + id
        });
    }

    function addFun() {
        parent.$.modalDialog({
            title : '添加数据',
            width : 780,
            height : 400,
            href : '${pageContext.request.contextPath}/mbSupplierContractClauseController/addPage?supplierContractId='+	${mbSupplierContract.id},
            buttons : [ {
                text : '添加',
                handler : function() {
                    parent.$.modalDialog.openner_dataGrid = contractClauseDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                    var f = parent.$.modalDialog.handler.find('#form');
                    f.submit();
                }
            } ]
        });
    }
    function downloadTable(){
        var options = contractClauseDataGrid.datagrid("options");
        var $colums = [];
        $.merge($colums, options.columns);
        $.merge($colums, options.frozenColumns);
        var columsStr = JSON.stringify($colums);
        $('#downloadTable').form('submit', {
            url:'${pageContext.request.contextPath}/mbSupplierContractClauseController/download',
            onSubmit: function(param){
                $.extend(param, $.serializeObject($('#searchForm')));
                param.downloadFields = columsStr;
                param.page = options.pageNumber;
                param.rows = options.pageSize;

            }
        });
    }
    var gridMap = {};
    $(function() {
        gridMap = {
            handle:function(obj,clallback){
                if (obj.grid == null) {
                    obj.grid = clallback();
                } else {
                    obj.grid.datagrid('reload');
                }
            }, 1: {
                invoke: function () {
                    gridMap.handle(this,loadmbSupitemDataGrid());
                }, grid: null
            },
        };
        $('#supplier_contract_view_tabs').tabs({
            onSelect: function (title, index) {
                gridMap[index].invoke();
            }
        });
    });
</script>
</head>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',title:'基本信息',border:false" style="height: 130px; overflow: hidden;">
		<table class="table table-hover table-condensed">
				<tr>	
					<th><%=TmbSupplierContract.ALIAS_CODE%></th>	
					<td>
						${mbSupplierContract.code}							
					</td>
					<th><%=TmbSupplierContract.ALIAS_NAME%></th>
					<td>
						${mbSupplierContract.name}
					</td>
					<th><%=TmbSupplierContract.ALIAS_SUPPLIER_NAME%></th>
					<td>
						${mbSupplierContract.supplierName}
					</td>
					<th><%=TmbSupplierContract.ALIAS_EXPIRY_DATE_START%></th>
					<td>
						${mbSupplierContract.expiryDateStart}
					</td>
				</tr>
				<tr>
					<th><%=TmbSupplierContract.ALIAS_EXPIRY_DATE_END%></th>
					<td>
						${mbSupplierContract.expiryDateEnd}
					</td>
					<th><%=TmbSupplierContract.ALIAS_VALID%></th>	
					<td>
						${mbSupplierContract.valid ==true? "是":"否"}
					</td>
					<th><%=TmbSupplierContract.ALIAS_RATE%>
					</th>
					<td>
						<c:if test="${mbSupplierContract.rate!=null}">
							${mbSupplierContract.rate}%
						</c:if>
					</td>
					<th><%=TmbSupplierContract.ALIAS_PAYMENT_DAYS%>
					</th>
					<td>
						<c:if test="${mbSupplierContract.paymentDays!=null}">
							${mbSupplierContract.paymentDays}天
						</c:if>
					</td>
				</tr>
				<tr>
					<th><%=TmbSupplierContract.ALIAS_ATTACHMENT%></th>
					<td colspan="7">
						${mbSupplierContract.attachment}
					</td>
				</tr>
		</table>
	</div>
	  <div data-options="region:'center',border:false">
		<div id="supplier_contract_view_tabs" class="easyui-tabs" data-options="fit : true,border:false">
			<div title="合同条款">
				<table id="contractClauseDataGrid"></table>
			</div>
			<div title="合同商品信息">
				<table id="mbsupitemDataGrid"></table>
			</div>
		</div>
	  </div>
  </div>
	<div id="toolbar" style="display: none;">
		<c:if test="${fn:contains(sessionInfo.resourceList, '/mbSupplierContractClauseController/addPage')}">
			<a onclick="addFun();" href="javascript:void(0);"  class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">添加</a>
		</c:if>
		<c:if test="${fn:contains(sessionInfo.resourceList, '/mbSupplierContractClauseController/download')}">
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'server_go',plain:true" onclick="downloadTable();">导出</a>
			<form id="downloadTable" target="downloadIframe" method="post" style="display: none;">
			</form>
			<iframe id="downloadIframe" name="downloadIframe" style="display: none;"></iframe>
		</c:if>
	</div>
</div>
</body>
</html>