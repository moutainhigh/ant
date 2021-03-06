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
        function computerPrice() {
            var inPrice = parseFloat($("#inPrice").val());
            var freight = parseFloat($("#freight").val());
            var totalPrice=(inPrice*100+freight*100)/100;
            if (!isNaN(inPrice) && !isNaN(freight)) {
                $("#price").val(totalPrice);
            }
        }
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
		<form id="form" method="post">
			<input type="hidden" name="id" value="${shopItem.id}"/>
			<table class="table table-hover table-condensed">
				<tr>
					<th>商品名称
					</th>
					<td>
						<input name="name" type="text" class=" span2"  readonly value="${shopItem.name}"/>
					</td>
					<th>采购价格
					</th>
					<td>
						<input class="span2 easyui-validatebox money_input" name="priceStr" id="inPrice" value="${shopItem.inPrice}"type="text" onblur="computerPrice()" data-options="required:true"/>
						<input class="span2 "   name="inPrice"  type="hidden"  value="${shopItem.inPrice}"/>
					</td>
				</tr>
				<tr>
					<th>是否上架
					</th>
					<td>
						<select class="easyui-combobox" name="online" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
						<c:if test="${shopItem.online == false}">
							<option value="1">是</option>
							<option value="0" selected="selected">否</option>
						</c:if>
						<c:if test="${shopItem.online == true}">
							<option value="1" selected="selected">是</option>
							<option value="0">否</option>
						</c:if>
						</select>
					</td>
					<th>库存
					</th>
					<td>
						<input name="quantity" type="text" class=" span2"    value="${shopItem.quantity}"/>
					</td>
				</tr>
				<tr>
					<th>运费
					</th>
					<td>
						<input class="span2 easyui-validatebox money_input" name="priceStr" id="freight" type="text" value="${shopItem.freight}" onblur="computerPrice()" data-options="required:true"/>
						<input class="span2 " name="freight" type="hidden" value="${shopItem.freight}"/>
					</td>
					<th>价格
					</th>
					<td colspan="3">
						<input class="span2 money_input"  id="price"  name="totalPrice" readonly type="text"  value="${shopItem.price}" />
						<input class="span2 " name="price" type="hidden"  value="${shopItem.price}"/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>