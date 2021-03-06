<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.mobian.model.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <jsp:include page="../inc.jsp"></jsp:include>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopInvoiceController/editPage')}">
        <script type="text/javascript">
            $.canEdit = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopInvoiceController/delete')}">
        <script type="text/javascript">
            $.canDelete = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/shopItemController/delete')}">
        <script type="text/javascript">
            $.canDeleteShopItem = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopInvoiceController/view')}">
        <script type="text/javascript">
            $.canView = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopInvoiceController/setInvoiceDefault')}">
        <script type="text/javascript">
            $.canSetInvoiceDefault = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbOrderInvoiceController/view')}">
        <script type="text/javascript">
            $.viewOrderInvoice = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsController/add')}">
        <script type="text/javascript">
            $.addShopCoupons = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsController/shopCouponsDelete')}">
        <script type="text/javascript">
            $.deleteShopCoupons = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsController/edit')}">
        <script type="text/javascript">
            $.editShopCoupons = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsController/view')}">
        <script type="text/javascript">
            $.viewShopCoupons = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbItemStockController/editStock')}">
        <script type="text/javascript">
            $.editShopStock = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/shopItemController/examinePage')}">
        <script type="text/javascript">
            $.examineShopItem = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/shopItemController/editPricePage')}">
        <script type="text/javascript">
            $.editShopItemPrice = true;
        </script>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbItemStockLogController/view')}">
        <script type="text/javascript">
            $.viewBucketHistory = true;
        </script>
    </c:if>
    <script type="text/javascript">
        var gridMap = {};
        $(function () {
            gridMap = {
                handle: function (obj, clallback) {
                    if (obj.grid == null) {
                        obj.grid = clallback();
                    } else {
                        obj.grid.datagrid('reload');
                    }
                },
                0: {
                    invoke: function () {
                        gridMap.handle(this, dataGrid);
                    }, grid: null
                },
                1: {
                    invoke: function () {
                        gridMap.handle(this, loadInvoiceDataGrid);
                    }, grid: null
                },
                2: {
                    invoke: function () {
                        gridMap.handle(this, loadShopCouponsDataGrid);
                    }, grid: null
                },
                3: {
                    invoke: function () {
                        gridMap.handle(this, loadBranchShopDataGrid);
                    }, grid: null
                },
                4: {
                    invoke: function () {
                        gridMap.handle(this, loadEmptyBucketDataGrid);
                    }, grid: null
                },
                5: {
                    invoke: function () {
                        gridMap.handle(this, loadDeliverShopItemDataGrid);
                    }, grid: null
                }

            };
            $('#shop_view_tabs').tabs({
                onSelect: function (title, index) {
                    gridMap[index].invoke();
                }
            });
            gridMap[0].invoke();

            $('.money_input').each(function(){
                $(this).text($.formatMoney($(this).text().trim()));
            });
        });
        var dataGrid;
        function dataGrid() {
            return dataGrid = $('#dataGrid').datagrid({
                url: '${pageContext.request.contextPath}/mbShopInvoiceController/dataGrid?shopId=' +${mbShopExt.id},
                fit: true,
                fitColumns: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'id',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                columns: [[{
                    field: 'id',
                    title: '编号',
                    width: 150,
                    hidden: true
                },
                    {
                        field: 'companyName',
                        title: '<%=TmbShopInvoice.ALIAS_COMPANY_NAME%>',
                        width: 80
                    }, {
                        field: 'companyTfn',
                        title: '<%=TmbShopInvoice.ALIAS_COMPANY_TFN%>',
                        width: 50
                    }, {
                        field: 'registerAddress',
                        title: '<%=TmbShopInvoice.ALIAS_REGISTER_ADDRESS%>',
                        width: 130
                    }, {
                        field: 'registerPhone',
                        title: '<%=TmbShopInvoice.ALIAS_REGISTER_PHONE%>',
                        width: 80
                    }, {
                        field: 'bankNames',
                        title: '<%=TmbShopInvoice.ALIAS_BANK_NAME%>',
                        width: 80
                    }, {
                        field: 'bankNumber',
                        title: '<%=TmbShopInvoice.ALIAS_BANK_NUMBER%>',
                        width: 100
                    }, {
                        field: 'invoiceUseName',
                        title: '<%=TmbShopInvoice.ALIAS_INVOICE_USE%>',
                        width: 50
                    }, {
                        field: 'invoiceTypeName',
                        title: '<%=TmbShopInvoice.ALIAS_INVOICE_TYPE%>',
                        width: 50
                    }, {
                        field: 'action',
                        title: '操作',
                        width: 60,
                        formatter: function (value, row, index) {
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
                            str += '&nbsp;';
                            if ($.canSetInvoiceDefault && row.invoiceDefault == '0') {
                                str += $.formatString('<img onclick="setDefaultInvoice(\'{0}\');" src="{1}" title="设置默认模板"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/wrench.png');
                            }
                            return str;1
                        }
                    }]],
                toolbar: "#toolbar"
            });
        };
        var loadInvoiceDataGrid;
        function loadInvoiceDataGrid() {
            return loadInvoiceDataGrid = $('#invoiceDataGrid').datagrid({
                url: '${pageContext.request.contextPath}/mbOrderInvoiceController/dataGrid?shopId=${mbShopExt.id}',
                fitColumns: true,
                fit: true,
                border: false,
                pagination: true,
                idField: 'id',
                pageSize: 10,
                pageList: [10, 20, 30, 40, 50],
                sortName: 'id',
                sortOrder: 'desc',
                checkOnSelect: false,
                selectOnCheck: false,
                nowrap: false,
                striped: true,
                rownumbers: true,
                singleSelect: true,
                columns: [[{
                    field: 'id',
                    title: '编号',
                    width: 150,
                    hidden: true
                },  {
                    field: 'orderId',
                    title: '<%=TmbOrderInvoice.ALIAS_ORDER_ID%>',
                    width: 70
                }, {
                    field: 'addtime',
                    title: '<%=TmbOrderInvoice.ALIAS_ADDTIME%>',
                    width: 140
                },  {
                    field: 'companyName',
                    title: '<%=TmbOrderInvoice.ALIAS_COMPANY_NAME%>',
                    width: 100
                }, {
                    field: 'companyTfn',
                    title: '<%=TmbOrderInvoice.ALIAS_COMPANY_TFN%>',
                    width: 100
                }, {
                    field: 'registerAddress',
                    title: '<%=TmbOrderInvoice.ALIAS_REGISTER_ADDRESS%>',
                    width: 200
                }, {
                    field: 'registerPhone',
                    title: '<%=TmbOrderInvoice.ALIAS_REGISTER_PHONE%>',
                    width: 100
                }, {
                    field: 'bankName',
                    title: '<%=TmbOrderInvoice.ALIAS_BANK_NAME%>',
                    width: 100
                }, {
                    field: 'bankNumber',
                    title: '<%=TmbOrderInvoice.ALIAS_BANK_NUMBER%>',
                    width: 100
                }, {
                    field: 'invoiceUseName',
                    title: '<%=TmbOrderInvoice.ALIAS_INVOICE_USE%>',
                    width: 70
                }, {
                    field: 'invoiceStatusName',
                    title: '<%=TmbOrderInvoice.ALIAS_INVOICE_STATUS%>',
                    width: 70
                }, {
                    field: 'loginName',
                    title: '<%=TmbOrderInvoice.ALIAS_LOGIN_ID%>',
                    width:50
                },{
                    field: 'action',
                    title: '操作',
                    width: 50,
                    formatter: function (value, row, index) {
                        var str = '';
                        str += '&nbsp;';
                        if ($.viewOrderInvoice) {
                            str += $.formatString('<img onclick="viewOrderInvoice(\'{0}\');" src="{1}" title="查看"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/map/magnifier.png');
                        }
                        return str;
                    }
                }
                ]]
            });
        }
        var loadShopCouponsDataGrid;
        function loadShopCouponsDataGrid() {
            return loadShopCouponsDataGrid = $('#shopCouponsDataGrid').datagrid({
                url : '${pageContext.request.contextPath}/mbShopCouponsController/dataGrid?shopId=' + ${mbShopExt.id},
                queryParams:{'status':'NS001'},
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
                    field : 'isDelete',
                    title : '<%=TmbShopCoupons.ALIAS_ISDELETED%>',
                    width : 50,
                    hidden : true
                },{
                    field : 'addtime',
                    title : '<%=TmbShopCoupons.ALIAS_ADDTIME%>',
                    width : 50
                },
                    {
                        field : 'couponsName',
                        title : '<%=TmbCoupons.ALIAS_NAME%>',
                        width : 50,
                        formatter: function (value, row, index) {
                            var str = '';
                            str += '&nbsp;';
                            if ($.viewShopCoupons) {
                                str += $.formatString('<a href="javascript:void(0);" onclick="viewCoupons(\'{0}\');" class="easyui-linkbutton">{1}</a>', row.couponsId, value);
                            }
                            return str;
                        }
                    },{
                        field : 'quantityUsed',
                        title : '<%=TmbShopCoupons.ALIAS_QUANTITY_USED%>',
                        width : 45,
                        align : 'right',
                        formatter : function (value) {
                            return value==null ? 0 : value ;
                        }
                    }, {
                        field : 'quantityTotal',
                        title : '<%=TmbShopCoupons.ALIAS_QUANTITY_TOTAL%>',
                        width : 40,
                        align : 'right',
                        formatter : function (value) {
                            return value==null ? 0 : value ;
                        }
                    }, {
                        field : 'statusName',
                        title : '<%=TmbShopCoupons.ALIAS_STATUS%>',
                        width : 40
                    }, {
                        field : 'timeStart',
                        title : '<%=TmbShopCoupons.ALIAS_TIME_START%>',
                        width : 50
                    }, {
                        field : 'timeEnd',
                        title : '<%=TmbShopCoupons.ALIAS_TIME_END%>',
                        width : 50
                    }, {
                        field : 'remark',
                        title : '<%=TmbShopCoupons.ALIAS_REMARK%>',
                        width : 50
                    },{
                        field: 'action',
                        title: '操作',
                        width: 30,
                        formatter: function (value, row, index) {
                            var str = '';
                            str += '&nbsp;';
                            if ($.viewShopCoupons) {
                                str += $.formatString('<img onclick="viewShopCoupons(\'{0}\');" src="{1}" title="查看"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/map/magnifier.png');
                            }
                            str += '&nbsp;';
                            if ($.editShopCoupons && row.status != 'NS010') {
                                str += $.formatString('<img onclick="editShopCoupons(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/pencil.png');
                            }
                            str += '&nbsp;';
                            if ($.deleteShopCoupons && row.status != 'NS010') {
                                str += $.formatString('<img onclick="deleteShopCoupons(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/cancel.png');
                            }
                            return str;
                        }
                    }
                ]],
                toolbar: '#shopCouponsToolbar'
            });
        }

        function loadBranchShopDataGrid() {
            return $('#branchShopDataGrid').datagrid({
                url : '${pageContext.request.contextPath}/mbShopController/dataGrid?onlyBranch=true&parentId=' + ${mbShopExt.id},
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
                columns : [ [
                    {
                        field: 'id',
                        title: '门店ID',
                        width: 20
                    }, {
                        field: 'name',
                        title: '<%=TmbShop.ALIAS_NAME%>',
                        width: 50
                    }, {
                        field: 'regionPath',
                        title: '<%=TmbShop.ALIAS_REGION_ID%>',
                        width: 70
                    }, {
                        field: 'address',
                        title: '<%=TmbShop.ALIAS_ADDRESS%>',
                        width: 100
                    }, {
                        field: 'contactPhone',
                        title: '<%=TmbShop.ALIAS_CONTACT_PHONE%>',
                        width: 50
                    }, {
                        field: 'contactPeople',
                        title: '<%=TmbShop.ALIAS_CONTACT_PEOPLE%>',
                        width: 40
                    }, {
                        field: 'shopTypeName',
                        title: '<%=TmbShop.ALIAS_SHOP_TYPE%>',
                        width: 30
                    }, {
                        field: 'auditStatusName',
                        title: '审核状态',
                        width: 30
                    }
                ]]
            });
        }
        var emptyBucketDataGrid;
        function loadEmptyBucketDataGrid() {
            return  emptyBucketDataGrid=$('#emptyBucketDataGrid').datagrid({
                url : '${pageContext.request.contextPath}/mbItemStockController/emptyBucketDataGrid?warehouseId='+'${mbShopExt.warehouseId}',
                fit : true,
                fitColumns : true,
                border : false,
                pagination : true,
                idField : 'id',
                pageSize : 10,
                pageList : [ 10, 20, 30, 40, 50,500 ],
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
                    field : 'warehouseCode',
                    title : '<%=TmbItemStock.ALIAS_WAREHOUSE_CODE%>',
                    width : 20,
                    formatter : function (value, row, index) {
                        if ($.viewBucketHistory){
                            return '<a onclick="viewBucketHistory(' + row.id + ')">' + row.warehouseCode + '</a>';
                        }else {
                            return row.warehouseCode;
                        }
                    }
                }, {
                    field : 'warehouseName',
                    title : '<%=TmbItemStock.ALIAS_WAREHOUSE_NAME%>',
                    width : 50
                }, {
                    field : 'itemCode',
                    title : '商品编码',
                    width : 50
                }, {
                    field : 'itemName',
                    title : '<%=TmbItemStock.ALIAS_ITEM_NAME%>',
                    width : 50
                },{
                    field : 'averagePrice',
                    title : '<%=TmbItemStock.ALIAS_AVERAGE_PRICE%>',
                    width : 25,
                    align:"right",
                    formatter:function(value){
                        return $.formatMoney(value);
                    }
                },{
                    field : 'quantity',
                    title : '<%=TmbItemStock.ALIAS_QUANTITY%>',
                    width : 25,
                    formatter: function (value, row) {
                        if (value && row.safeQuantity) {
                            if (value <= row.safeQuantity) {
                                return '<font color="red">'+value+'<font>';
                            }
                        }
                        return value;
                    }
                },{
                    field : 'orderQuantity',
                    title : '<%=TmbItemStock.ALIAS_ORDER_QUANTITY%>',
                    width : 25
                },{
                    field : 'od15Quantity',
                    title : '捡货中',
                    width : 20
                }, {
                    field : 'safeQuantity',
                    title : '<%=TmbItemStock.ALIAS_SAFE_QUANTITY%>',
                    width : 15
                }, {
                    field : 'action',
                    title : '操作',
                    width : 30,
                    formatter : function(value, row, index) {
                        var str = '';
                        if ($.editShopStock) {
                            str += $.formatString('<img onclick="editStock(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/pencil.png');
                        }
                        return str;
                    }
                } ] ],
            });
        }

        var deliverShopItemDataGrid;
        function loadDeliverShopItemDataGrid() {
            return  deliverShopItemDataGrid=$('#deliverShopItemDataGrid').datagrid({
                url : '${pageContext.request.contextPath}/shopItemController/dataGrid?shopId='+${mbShopExt.id},
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
                toolbar:'#shopItemToolbar',
                columns : [ [{
                    field : 'id',
                    title : '编号',
                    width : 150,
                    hidden : true
                }, {
                    field : 'ck',
                    checkbox:true,
                    width : 150
                }, {
                    field : 'itemId',
                    title : '商品ID',
                    width : 20,
                    hidden : true
                },{
                    field : 'name',
                    title : '商品名称',
                    width : 60
                }, {
                    field : 'shopName',
                    title : '门店名称',
                    width : 20
                }, {
                    field : 'price',
                    title : '价格',
                    width : 20,
                    align:"right",
                    formatter:function(value){
                        if (value != null)
                            return $.formatMoney(value);
                        return "";
                    }
                }, {
                    field : 'inPrice',
                    title : '采购价',
                    width : 20,
                    align:"right",
                    formatter: function (value) {
                        if (value != null)
                            return $.formatMoney(value);
                        return "";
                    }
                },{
                    field : 'freight',
                    title : '运费',
                    width : 20,
                    align:"right",
                    formatter:function(value){
                        if (value != null)
                            return $.formatMoney(value);
                        return "";
                    }
                },{
                    field : 'quantity',
                    title : '数量',
                    width : 10
                },{
                    field : 'online',
                    title : '是否上架',
                    width : 20,
                    formatter:function(value){
                        if (value == true)
                            return "是";
                        return "否";
                    }
                },{
                    field : 'statusName',
                    title : '状态',
                    width : 20
                }, {
                    field : 'action',
                    title : '操作',
                    width : 30,
                    formatter : function(value, row, index) {
                        var str = '';
                        if ($.editShopItemPrice) {
                            str += $.formatString('<img onclick="editShopItemPrice(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/pencil.png');
                        }
                        str += '&nbsp;';
                        if ($.examineShopItem && row.status == "SIS01" && row.online == false) {
                            str += $.formatString('<img onclick="examineFun(\'{0}\');" src="{1}" title="审核"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/joystick.png');
                        }str += '&nbsp;';
                        if ($.canDeleteShopItem) {
                            str += $.formatString('<img onclick="deleteShopItemFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/cancel.png');
                        }
                        return str;
                    }
                } ] ],
            });
        }
        //批量修改运费
        function editFreightPrice() {
            var rows = $('#deliverShopItemDataGrid').datagrid('getChecked');
            if(rows.length > 0) {
            parent.$.modalDialog({
                title : '批量修改运费',
                width : 780,
                height : 150,
                href : '${pageContext.request.contextPath}/shopItemController/editFreightBatchPage',
                buttons : [ {
                    text : '编辑',
                    handler : function() {
                        parent.$.modalDialog.openner_dataGrid = deliverShopItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var rows =$('#deliverShopItemDataGrid').datagrid('getChecked');
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.find("input[name= shopItemList]").val(JSON.stringify(rows));
                        f.submit();
                    }
                } ]
            });
            } else {
                parent.$.messager.alert("提示", "请选择要修改运费的商品！")
            }
        }
        function auditBatch() {
            var rows = $('#deliverShopItemDataGrid').datagrid('getChecked');
            if(rows.length > 0) {
            parent.$.modalDialog({
                title : '商品审核',
                width : 780,
                height : 200,
                href : '${pageContext.request.contextPath}/shopItemController/auditBatchPage',
                buttons: [{
                    text: '通过',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid =  deliverShopItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var rows =$('#deliverShopItemDataGrid').datagrid('getChecked')
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.find("input[name= shopItemList]").val(JSON.stringify(rows));
                        f.find("input[name=status]").val("SIS02");
                        f.submit();
                    }
                },
                    {
                        text: '拒绝',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid =  deliverShopItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var rows =$('#deliverShopItemDataGrid').datagrid('getChecked')
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.find("input[name= shopItemList]").val(JSON.stringify(rows));
                            f.find("input[name=status]").val("SIS03");
                            f.submit();
                        }
                    }
                ]
            });
            }else{
                parent.$.messager.alert("提示","请选择要审核的商品！")
            }
        }
        $(function () {
            parent.$.messager.progress('close');

        });

        function examineFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title : '商品审核',
                width : 780,
                height : 300,
                href : '${pageContext.request.contextPath}/shopItemController/examinePage?id=' + id,
                buttons: [{
                    text: '通过',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid =  deliverShopItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.find("input[name=status]").val("SIS02");
                        f.submit();
                    }
                },
                    {
                        text: '拒绝',
                        handler: function () {
                            parent.$.modalDialog.openner_dataGrid =  deliverShopItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#form');
                            f.find("input[name=status]").val("SIS03");
                            f.submit();
                        }
                    }
                ]
            });
        }

        function editShopItemPrice(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title: '商品价格修改',
                width: 780,
                height: 230,
                href: '${pageContext.request.contextPath}/shopItemController/editPricePage?id=' + id,
                buttons: [{
                    text: '编辑',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = deliverShopItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }
        function editStock(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title: '编辑数据',
                width: 780,
                height: 500,
                href: '${pageContext.request.contextPath}/mbItemStockController/editStockPage?id=' + id + "&shopId=" +  ${mbShopExt.id},
                buttons: [{
                    text: '编辑',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = emptyBucketDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }

        function  viewOrderInvoice(id) {

            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title : '查看数据',
                width : 780,
                height : 500,
                href : '${pageContext.request.contextPath}/mbOrderInvoiceController/view?id=' + id
            });
        }

        function viewCoupons(couponsId) {
            if (couponsId == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                couponsId = rows[0].couponsId;
            }
            parent.$.modalDialog({
                title: '券信息',
                width: 780,
                height : 500,
                href: '${pageContext.request.contextPath}/mbCouponsController/view?id=' + couponsId
            });
        }
        function viewShopCoupons(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title: '门店券信息',
                width: 780,
                height : 500,
                href: '${pageContext.request.contextPath}/mbShopCouponsController/view?id=' + id
            });
        }
        function deleteShopCoupons(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title: '删除门店券票',
                width: 780,
                height: 200,
                href: '${pageContext.request.contextPath}/mbShopCouponsController/shopCouponsDeletePage?id=' + id,
                buttons: [{
                    text: '确认删除',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = gridMap[2].grid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }
        function editShopCoupons(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title: '编辑数据',
                width: 780,
                height: 500,
                href: '${pageContext.request.contextPath}/mbShopCouponsController/editPage?id=' + id,
                buttons: [{
                    text: '编辑',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = gridMap[2].grid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }
        function addFun(id) {
            parent.$.modalDialog({
                title: '添加数据',
                width: 780,
                height: 500,
                href: '${pageContext.request.contextPath}/mbShopInvoiceController/addPage?shopId=' + id,
                buttons: [{
                    text: '添加',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }

        function addShopItemFun(id) {
            parent.$.modalDialog({
                title: '添加数据',
                width: 780,
                height: 500,
                href: '${pageContext.request.contextPath}/shopItemController/addPage?shopId=' + id,
                buttons: [{
                    text: '添加',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = deliverShopItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }
        function addShopCouponsFun(shopId) {
            parent.$.modalDialog({
                title: '添加券',
                width: 780,
                height: 400,
                href: '${pageContext.request.contextPath}/mbShopCouponsController/addPage?shopId=' + shopId,
                buttons: [{
                    text: '添加',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = gridMap[2].grid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }
        var showAllShopCouponsMark = false;
        function viewAllShopCouponsFun(shopId) {
            if (showAllShopCouponsMark == false) {
                loadShopCouponsDataGrid.datagrid('load', {'id':shopId,'isdeleted':'true'});
                showAllShopCouponsMark = true;
                $('#showAllShopCouponsButton').html('显示可用券票');
                $('#showAllShopCouponsButton').attr('data-options',"plain:true,iconCls:'find'");
            }else {
                loadShopCouponsDataGrid.datagrid('load',{'id':shopId,'status':'NS001'});
                showAllShopCouponsMark = false;
                $('#showAllShopCouponsButton').html('显示所有券票');
                $('#showAllShopCouponsButton').attr('data-options',"plain:true,iconCls:'find'");
            }
        }

        function deleteShopItemFun(id){
            parent.$.messager.confirm('询问', '您是否要删除当前数据？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '提示',
                        text: '数据处理中，请稍后....'
                    });
                    $.post('${pageContext.request.contextPath}/shopItemController/delete', {
                        id: id
                    }, function (result) {
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                            deliverShopItemDataGrid.datagrid('reload');
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        }
        function deleteFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.messager.confirm('询问', '您是否要删除当前数据？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '提示',
                        text: '数据处理中，请稍后....'
                    });
                    $.post('${pageContext.request.contextPath}/mbShopInvoiceController/delete', {
                        id: id
                    }, function (result) {
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                            dataGrid.datagrid('reload');
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        }
        function viewShop(id) {
            var href = '${pageContext.request.contextPath}/mbShopController/view?id=' + id;
            parent.$("#index_tabs").tabs('add', {
                title: '门店详情-' + id,
                content: '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:98%;"></iframe>',
                closable: true
            });
        }
        function editFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title: '编辑数据',
                width: 780,
                height: 500,
                href: '${pageContext.request.contextPath}/mbShopInvoiceController/editPage?id=' + id,
                buttons: [{
                    text: '编辑',
                    handler: function () {
                        parent.$.modalDialog.openner_dataGrid = dataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();
                    }
                }]
            });
        }
        function viewFun(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title: '查看数据',
                width: 780,
                height: 500,
                href: '${pageContext.request.contextPath}/mbShopInvoiceController/view?id=' + id
            });
        }
        function setDefaultInvoice(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.messager.confirm('询问', '您是否要把当前模板设为默认值？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '提示',
                        text: '数据处理中，请稍后....'
                    });
                    $.post('${pageContext.request.contextPath}/mbShopInvoiceController/setInvoiceDefault?shopId=' +${mbShopExt.id}, {
                        id: id
                    }, function (result) {
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                            dataGrid.datagrid('reload');
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        }
        function viewShop(id) {
            var href = '${pageContext.request.contextPath}/mbShopController/view?id=' + id;
            parent.$("#index_tabs").tabs('add', {
                title: '门店详情-' + id,
                content: '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:98%;"></iframe>',
                closable: true
            });
        }
        //余额
        function viewBalance(id) {
            var href = '${pageContext.request.contextPath}/mbUserController/viewBalance?shopId=' + id;
            parent.$("#index_tabs").tabs('add', {
                title: '余额-' + id,
                content: '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:98%;"></iframe>',
                closable: true
            });
        }
        //历史流水
        function viewRealBalance(id) {
            var href = '${pageContext.request.contextPath}/mbUserController/viewBalance?realShopId=' + id;
            parent.$("#index_tabs").tabs('add', {
                title: '余额-' + id,
                content: '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:98%;"></iframe>',
                closable: true
            });
        }

        function viewOrderUnfinish(id) {
            var href = '${pageContext.request.contextPath}/mbOrderController/manager?payStatus=PS01&shopId=' + id;
            parent.$("#index_tabs").tabs('add', {
                title: '未支付订单-' + id,
                content: '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:98%;"></iframe>',
                closable: true
            });
        }


        //桶余额
        function viewCashBalance(balanceId,shopId) {
            var href = '${pageContext.request.contextPath}/mbBalanceController/viewCash?id=' + balanceId+"&shopId="+shopId;
            parent.$("#index_tabs").tabs('add', {
                title: '桶余额-' + shopId,
                content: '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:98%;"></iframe>',
                closable: true
            });
        }
        function addShopDeliverApply(id) {
            parent.$.modalDialog({
                title: '开通派单',
                width: 650,
                height: 360,
                href: '${pageContext.request.contextPath}/shopDeliverApplyController/addPage?shopId='+ id,
                buttons: [{
                    text: '开通',
                    handler: function () {
                        parent.$.modalDialog.opener_url = window.location;//先把当前页面定义好，开通成功后刷新当前页面
                        var f = parent.$.modalDialog.handler.find('#form');
                        f.submit();

                    }
                }]
            });

        }

        function viewAccount(id) {
            var href = '${pageContext.request.contextPath}/shopDeliverAccountController/view?id=' + id
            parent.$("#index_tabs").tabs('add', {
                title : '账号详情-' + id,
                content : '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:100%;"></iframe>',
                closable : true
            });
        }
        //派单钱包
        function viewDeliverMoney(shopId) {
            var href = '${pageContext.request.contextPath}/mbBalanceController/viewDeliverCash?shopId='+shopId ;
            parent.$("#index_tabs").tabs('add', {
                title: '派单钱包-' + shopId,
                content: '<iframe src="' + href + '" frameborder="0" scrolling="auto" style="width:100%;height:98%;"></iframe>',
                closable: true
            });

        }
        //空桶变更历史
        function viewBucketHistory(id) {
            if (id == undefined) {
                var rows = dataGrid.datagrid('getSelections');
                id = rows[0].id;
            }
            parent.$.modalDialog({
                title : '库存变更日志',
                width : 780,
                height : 500,
                href : '${pageContext.request.contextPath}/mbItemStockLogController/view?id=' + id
            });
        }
        function addShopItemFromContract(id) {
            parent.$.messager.confirm('询问', '您是否要同步合同商品？', function (b) {
                if (b) {
                    parent.$.messager.progress({
                        title: '提示',
                        text: '数据处理中，请稍后....'
                    });
                    $.post('${pageContext.request.contextPath}/shopItemController/addShopItemFromContract', {
                        shopId:   ${mbShopExt.id}
                    }, function (result) {
                        if (result.success) {
                            parent.$.messager.alert('提示', result.msg, 'info');
                            deliverShopItemDataGrid.datagrid('reload');
                        }
                        parent.$.messager.progress('close');
                    }, 'JSON');
                }
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 150px; overflow: hidden;">
        <table class="table table-hover table-condensed">
            <tr>

                <th><%=TmbShop.ALIAS_ADDTIME%>
                </th>
                <td>
                    ${mbShopExt.addtime}
                </td>

                <th><%=TmbShop.ALIAS_UPDATETIME%>
                </th>
                <td>
                    ${mbShopExt.updatetime}
                </td>

                <th><%=TmbShop.ALIAS_NAME%>
                </th>
                <td>
                    ${mbShopExt.name}
                </td>
                <th><%=TmbShop.ALIAS_REGION_ID%>
                </th>
                <td>
                    ${mbShopExt.regionPath}
                </td>
            </tr>
            <tr>
                <th><%=TmbShop.ALIAS_CONTACT_PEOPLE%>
                </th>
                <td>
                    ${mbShopExt.contactPeople}
                </td>
                <th><%=TmbShop.ALIAS_CONTACT_PHONE%>
                </th>
                <td>
                    ${mbShopExt.contactPhone}
                </td>
                <th><%=TmbShop.ALIAS_SHOP_TYPE%>
                </th>
                <td>
                    ${mbShopExt.shopTypeName}
                </td>
                <th>
                    经纬度
                </th>
                <td>
                    ${mbShopExt.longitude},${mbShopExt.latitude}
                </td>

            </tr>
            <tr>
                <th>余额
                </th>
                <td>
                    <a href="javascript:void(0);" onclick="viewBalance('${mbShopExt.id}')" class="money_input">${mbShopExt.balanceAmount}</a>
                    <c:if test="${(mbShopExt.parentId != null and mbShopExt.parentId != -1)and mbShopExt.auditStatus == 'AS02' }">
                        &nbsp;&nbsp;<a href="javascript:void(0);" onclick="viewRealBalance('${mbShopExt.id}')">历史账单</a>
                    </c:if>
                </td>
                <th>欠款订单金额
                </th>
                <td>
                    <c:choose>
                        <c:when test="${debt>0}">
                            <a href="javascript:void(0);" onclick="viewOrderUnfinish('${mbShopExt.id}')" class="money_input" style="color: red">${debt}</a>
                        </c:when>
                        <c:otherwise>
                            ${debt/100.0}
                        </c:otherwise>
                    </c:choose>
                </td>
                <th>实际余额
                </th>
                <td>

                    <c:choose>
                        <c:when test="${(mbShopExt.balanceAmount-debt)>0}">
                            <font color="green" class="money_input">${mbShopExt.balanceAmount-debt}</font>
                        </c:when>
                        <c:otherwise>
                            <font color="red" class="money_input">${mbShopExt.balanceAmount-debt}</font>
                        </c:otherwise>
                    </c:choose>
                </td>
                <th>桶余额
                </th>
                <td>
                    <a href="javascript:void(0);" onclick="viewCashBalance('${mbShopExt.cashBalanceId}','${mbShopExt.id}')" class="money_input">${mbShopExt.cashBalanceAmount}</a>
                </td>
            </tr>
            <tr>
                <th><%=TmbShop.ALIAS_ADDRESS%>
                </th>
                <td>
                    ${mbShopExt.address}
                </td>
                <th>派单</th>
                <c:if test="${fn:contains(sessionInfo.resourceList, '/shopDeliverApplyController/addPage') and mbShopExt.deliver == 0}">
                <td colspan="3">
                    未开通&nbsp;&nbsp;&nbsp;<a href="javascript:void(0);" onclick="addShopDeliverApply(${mbShopExt.id});"class="easyui-linkbutton">开通</a>
                    </c:if>
                    <c:if test="${mbShopExt.deliver == 1}">
                <td>
                    已开通
                    </c:if>
                </td>
                <th>账号ID</th>
                <td>
                    <a href="javascript:void(0);" onclick="viewAccount(${accountId})">${accountId}</a>
                </td>
                <c:if test="${mbShopExt.deliver == 1}">
                    <th>派单钱包</th>
                    <td>
                        <a href="javascript:void(0);" onclick="viewDeliverMoney(${mbShopExt.id})" class="money_input">${money}</a>
                    </td>
                </c:if>
            </tr>
            <tr>
                <th>销售人员</th>
                <td colspan="8">
                    ${mbShopExt.salesLoginName}
                </td>
            </tr>
        </table>
    </div>
    <div data-options="region:'center',border:false">
        <div id="shop_view_tabs" class="easyui-tabs" data-options="fit : true,border:false">
            <div title="发票模板">
                <table id="dataGrid"></table>
            </div>
            <div title="发票明细">
                <table id="invoiceDataGrid"></table>
            </div>
            <div title="券票明细">
                <table id="shopCouponsDataGrid"></table>
            </div>
            <div title="分店列表">
                <table id="branchShopDataGrid"></table>
            </div>
            <div title="空桶列表">
                <table id="emptyBucketDataGrid"></table>
            </div>
            <div title="门店商品">
                <table id="deliverShopItemDataGrid"></table>
            </div>
        </div>

    </div>
</div>
<div id="deleteTextDialog">
    <form id="deleteText">
        <th>删除备注</th>
        <textarea name="remark" id="" cols="30" rows="10"></textarea>
    </form>
</div>
<div id="showAllShopCouponsDiv">
    <form id="showAllShopCouponsForm">
        <input type="hidden" name="isdeleted"/>
    </form>
</div>
<div id="shopCouponsToolbar">
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsController/addPage') and (mbShopExt.parentId == null or mbShopExt.parentId == -1) and mbShopExt.auditStatus == 'AS02' }">
        <a onclick="addShopCouponsFun(' + ${mbShopExt.id}+ ');" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'pencil_add'">添加</a>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsController/addPage') and (mbShopExt.parentId != null and mbShopExt.parentId != -1)and mbShopExt.auditStatus == 'AS02' }">
        <a  onclick="viewShop( ${mbShopExt.parentId} )" href="javascript:void(0);" class="easyui-linkbutton"
            data-options="plain:true,iconCls:'pencil_add'">转至主门店 - 添加</a>
    </c:if>
    &nbsp;&nbsp;&nbsp;
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopCouponsController/view')}">
        <a id="showAllShopCouponsButton" onclick="viewAllShopCouponsFun();" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'find'">显示所有券票</a>
    </c:if>
</div>
<%--<div id="shopCouponsWindow" class="easyui-window" title="Basic Window" data-options="iconCls:'icon-save'" style="width:500px;height:200px;padding:10px;">--%>
<%--该门店不是主店,无法添加券票,请前往主店进行券票添加操作.该门店主门店ID为--%>
<%--<a href="javascript:void(0)" onclick="viewShop(${mbShop.parentID})" >${mbShop.parentId}</a>--%>
<%--</div>--%>
<div id="toolbar">
    <c:if test="${fn:contains(sessionInfo.resourceList, '/mbShopInvoiceController/addPage')}">
        <a onclick="addFun(' + ${mbShopExt.id}+ ');" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'pencil_add'">添加</a>
    </c:if>
</div>
<div id="shopItemToolbar">
    <c:if test="${fn:contains(sessionInfo.resourceList, '/shopItemController/addPage')}">
        <a onclick="addShopItemFun(' + ${mbShopExt.id}+ ');" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'pencil_add'">添加</a>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/shopItemController/editFreightBatch')}">
        <a onclick="editFreightPrice() ;" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'pencil_add'">批量修改运费</a>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/shopItemController/auditBatch')}">
        <a onclick="auditBatch();" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'pencil_add'">批量审核</a>
    </c:if>
    <c:if test="${fn:contains(sessionInfo.resourceList, '/shopItemController/addShopItemFromContract')}">
        <a onclick="addShopItemFromContract();" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'pencil_add'">同步合同商品</a>
    </c:if>
</div>
</body>
</html>