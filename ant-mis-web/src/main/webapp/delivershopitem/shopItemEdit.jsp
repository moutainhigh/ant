<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%>
<script type="text/javascript">
		$(function() {
        parent.$.messager.progress('close');
        $('#form').form({
            url : '${pageContext.request.contextPath}/shopItemController/editPrice',
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
            $('.money_input').blur(function () {
                var source = $(this);
                var target = source.next();
                if (!/^([1-9]\d*|0)(\.\d{2})?$/.test(source.val())) {
                    source.val("").focus();
                }
                var val = source.val().trim();
                if (val.indexOf('.') > -1) {
                    val = val.replace('.', "");
                } else if (val != '') {
                    val += "00";
                }
                target.val(val);
            });

            $('.money_input').each(function(){
                $(this).val($.formatMoney($(this).val().trim()));
            });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
		<form id="form" method="post">
			<input type="hidden" name="id" value="${shopItem.id}"/>
			<table class="table table-hover table-condensed">
				<tr>
					<th> 门店ID
					</th>
					<td>
						<input class="span2" name="tenantId" readonly type="text" value="${shopItem.shopId}"/>
					</td>
					<th>状态
					</th>
					<td>
						<input class="span2 " name="statusName" readonly value="${shopItem.statusName}"type="text" />
						<input class="span2 " name="status"  type="hidden" value="${shopItem.status}"/>
					</td>
				</tr>
				<tr>
					<th>商品ID
					</th>
					<td>
						<input name="itemId" type="text" class=" span2"  readonly  value="${shopItem.itemId}"/>
					</td>
					<th>商品名称
					</th>
					<td>
						<input name="name" type="text" class=" span2"  readonly value="${shopItem.name}"/>
					</td>
				</tr>
				<tr>
					<th>采购价格
					</th>
					<td>
						<input class="span2 easyui-validatebox money_input" name="priceStr"  value="${shopItem.inPrice}"type="text" data-options="required:true"/>
						<input class="span2 "  name="inPrice"  type="hidden"  value="${shopItem.inPrice}"/>
					</td>
					<th>价格
					</th>
					<td>
						<input class="span2 easyui-validatebox money_input" name="priceStr"  type="text"  value="${shopItem.price}" data-options="required:true"/>
						<input class="span2 " name="price"   type="hidden" value="${shopItem.price}"/>
					</td>
				</tr>
				<tr>
					<th>运费
					</th>
					<td colspan="3">
						<input class="span2 easyui-validatebox money_input" name="priceStr" type="text" value="${shopItem.freight}" data-options="required:true"/>
						<input class="span2 " name="freight"  type="hidden" value="${shopItem.freight}"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>