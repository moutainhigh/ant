/**
 * Created by snow on 17/5/3.
 */
var shoppingIds = GetRequest('shoppingIds');
var itemId = GetRequest('itemId');
var shopId = $.cookie('cur_shop_id');
$(function () {
    CAMEL_ORDER_CONFIRM.init();
});

var CAMEL_ORDER_CONFIRM = {
    init : function() {

        $('.order-mess li:not(:first)').hide();
        this._bindEvent();
        this._getItemList();
        this._initDeliveryWay();
        this._initInvoiceWay();
        //this._initAddress();
        this._initShops();
    },
    _bindEvent : function() {
        /*$('#switchInvoice').click(function(){
            if($(this).is(':checked')) {
                $('.order-mess li:not(:first)').addClass('ui-row-flex').show();
                $('#invoiceWayPopup').popup();
            } else {
                $('.order-mess li:not(:first)').removeClass('ui-row-flex').hide();
                $('#invoiceWay').val('IW01');
            }
        });*/

        $('.openDeliveryWay').click(function(){
            $('#deliveryWayPopup').popup();
        });

        /*$('#address').click(function() {
            try {
                JWEIXIN.openAddress(function (data) {
                    var params = {};
                    params.userName = data.userName;
                    params.postalCode = data.postalCode;
                    params.provinceName = data.provinceName;
                    params.cityName = data.cityName;
                    params.countyName = data.countryName;
                    params.detailInfo = data.detailInfo.replace(/[\r\n]/g, "");
                    params.telNumber = data.telNumber;

                    var telNumber = data.telNumber.substr(0, 3) + '****' + data.telNumber.substr(data.telNumber.length - 4);
                    $('#address .info').empty().append('<h3><b>'+data.userName+'</b><span>'+telNumber+'</span></h3>');
                    $('#address .info').append('<p>'+data.provinceName+' '+data.cityName+' '+data.countryName+' '+data.detailInfo+'</p>');

                    $('#contactPhone').val(data.telNumber);
                    $('#contactPeople').val(data.userName);
                    $('#deliveryAddress').val(data.provinceName+' '+data.cityName+' '+data.countryName+' '+data.detailInfo);

                    ajaxPost('api/apiUserAddressController/add', params, function(data){
                        if(data.success) {
                            // 不做任何操作
                        }
                    });
                });
            } catch (e) {
                console.log(e);
            }
        });*/

        $('#placeOrder').bind('click', CAMEL_ORDER_CONFIRM._placeOrder);
    },
    _getItemList : function() {
        $('.confirm-list').empty();
        if(itemId) {
            var params = {id : itemId};
            if(shopId) params.shopId = shopId;
            ajaxPost('api/apiItemController/get', params, function(data){
                if(data.success) {
                    var item = data.obj;
                    item.quantitys = item.quantity;
                    item.quantity = 1;
                    CAMEL_ORDER_CONFIRM._buildItem(item);
                }
                CAMEL_ORDER_CONFIRM._totalPrice();
                $.hideLoadMore();
            });
        } else if(shoppingIds) {
            var params = {page:1, rows:40, sort:'addtime', order:'desc'};
            if(shopId) params.shopId = shopId;
            ajaxPost('api/apiShoppingController/dataGrid', params, function(data){
                if(data.success) {
                    var result = data.obj;
                    for (var i in result.rows) {
                        var shopping = result.rows[i];
                        if(Util.arrayContains(shoppingIds.split(','), shopping.id)) {
                            shopping.mbItem.quantity = shopping.quantity;
                            CAMEL_ORDER_CONFIRM._buildItem(shopping.mbItem);
                        }
                    }
                    CAMEL_ORDER_CONFIRM._totalPrice();
                }
                $.hideLoadMore();
            });
        }

    },
    _buildItem : function(mbItem) {
        var viewData = Util.cloneJson(mbItem);
        viewData.marketPrice = '￥' + Util.fenToYuan(mbItem.marketPrice);
        viewData.contractPrice = '￥' + Util.fenToYuan(mbItem.contractPrice);
        var dom = Util.cloneDom("order_item_template", mbItem, viewData);

        dom.attr({"data-id" : mbItem.id});
        dom.find('i.ui-img-cover').css('background-image', 'url('+mbItem.url+')');
        dom.addClass('ui-row-flex');
        if(!mbItem.contractPrice) {
            dom.find('.bot').html('<p><span name="contractPrice">'+viewData.marketPrice+'</span></p>');
        }

        $(".confirm-list").append(dom);

        if(itemId) {
            dom.find('.quantity').val(mbItem.quantity);
            $('.ui-num').removeClass('ui-row-flex').hide();
            $('.ui-btn').show();
            dom.find('.quantity').blur(mbItem.quantitys, function(event){
                var $li = $(this).closest('li'), num = $(this).val();
                if(!num || num == 0) {
                    $.toast("<font size='3pt;'>数量超出范围~</font>", "text");
                    $(this).val(1);
                }
                if(num > event.data) {
                    $.toast("<font size='3pt;'>数量超出范围~</font>", "text");
                    $(this).val(event.data);
                }
                CAMEL_ORDER_CONFIRM._totalPrice();
            });
            dom.find('.sub').click(function(){
                var $li = $(this).closest('li'), num = parseInt($li.find('.ui-btn .quantity').val());
                if(num <= 1) return;
                $.showLoading('正在加载');
                $li.find('.ui-btn .quantity').val(num - 1);
                CAMEL_ORDER_CONFIRM._totalPrice();
                setTimeout(function(){
                    $.hideLoading();
                }, 200);
            });
            dom.find('.add').click(mbItem.quantitys, function(event){
                var $li = $(this).closest('li'), num = parseInt($li.find('.ui-btn .quantity').val());
                if(num == event.data) {
                    $.toast("<font size='3pt;'>亲，不能购买更多哦</font>", "text");
                    return;
                }
                $.showLoading('正在加载');
                $li.find('.ui-btn .quantity').val(num + 1);
                CAMEL_ORDER_CONFIRM._totalPrice();
                setTimeout(function(){
                    $.hideLoading();
                }, 200);
            });

        } else if(shoppingIds) {
            $('.ui-btn').removeClass('ui-row-flex').hide();
            $('.ui-num').show();
        }

        return dom;
    },
    _totalPrice : function() {
        var totalPrice = $('.confirm-list li').map(function(){
            var num;
            if(itemId) {
                num = $(this).find('.ui-btn .quantity').val();
            } else if(shoppingIds) {
                num = $(this).find('.ui-num span[name=quantity]').text();
            }
            return $(this).find('[name=contractPrice]').text().substr(1)*1000/10*num;
        }).get().join('+');

        var deliveryFee = parseInt($('#deliveryFee').val());
        totalPrice = eval(totalPrice) || 0;
        totalPrice = totalPrice + deliveryFee;
        $('.totalPrice').html('￥' + Util.fenToYuan(totalPrice));
        $('#totalPrice').val(totalPrice);
    },
    _initDeliveryWay : function() {
        ajaxPost('api/apiBaseDataController/basedata', {dataType:'DW'}, function(data){
            if(data.success) {
                var result = data.obj;
                for (var i in result) {
                    if(result[i].id == 'DW03') continue;
                    CAMEL_ORDER_CONFIRM._buildDeliveryWay(result[i]);
                }
            }
        });
    },
    _initInvoiceWay : function() {
        /*setTimeout(function(){
            var result = [{"id":"IW02","name":"普票"},{"id":"IW03","name":"专票"}];
            for (var i in result) {
                var invoiceWay = result[i];
                console.log(invoiceWay);
                var viewData = Util.cloneJson(invoiceWay);
                var dom = Util.cloneDom("iw_template", invoiceWay, viewData);
                console.log($('#iw_template').html());
                $("#iw").append(dom);
                dom.click(invoiceWay, function(event){
                    $('#invoiceWay').val(event.data.id);
                    if(event.data.id == 'IW02'){
                        $('.zhuanpiao').removeClass('ui-row-flex').hide();
                        $('.taitou').text('发票抬头');
                    }else{
                        $('.zhuanpiao').addClass('ui-row-flex').show();
                        $('.taitou').text('公司名称');
                    }
                    $.closePopup();
                });
                //if(invoiceWay.id == 'IW02') dom.click();
            }
        },100);*/
    },
    _buildDeliveryWay : function(deliveryWay) {
        console.log(deliveryWay);
        var viewData = Util.cloneJson(deliveryWay);
        if(deliveryWay.description)
            viewData.name = deliveryWay.name + " - " + '￥' + Util.fenToYuan(deliveryWay.description*1000/10);
        var dom = Util.cloneDom("dw_template", deliveryWay, viewData);
        $("#dw").append(dom);

        dom.click(deliveryWay, function(event){
            $('.deliveryWay').html(event.data.name);
            $('#deliveryWay').val(event.data.id);
            if(event.data.id == 'DW02' && event.data.description) {
                var deliveryFee = deliveryWay.description*1000/10;
                $('#deliveryFee').val(deliveryFee);
                $('.fee').html('￥' + Util.fenToYuan(deliveryFee));
            } else {
                $('#deliveryFee').val(0);
                $('.fee').empty();
            }
            CAMEL_ORDER_CONFIRM._totalPrice();
            $.closePopup();

        });
        if(deliveryWay.id == 'DW02') dom.click();
        return dom;
    },
    _initAddress : function() {
        ajaxPost('api/apiUserAddressController/getDefaultAddress', {}, function(data){
            if(data.success && data.obj) {
                var address = data.obj;
                var telNumber = address.telNumber.substr(0, 3) + '****' + address.telNumber.substr(address.telNumber.length - 4);
                $('#address .info').empty().append('<h3><b>'+address.userName+'</b><span>'+telNumber+'</span></h3>');
                $('#address .info').append('<p>'+address.provinceName+' '+address.cityName+' '+address.countyName+' '+address.detailInfo+'</p>');

                $('#contactPhone').val(address.telNumber);
                $('#contactPeople').val(address.userName);
                $('#deliveryAddress').val(address.provinceName+' '+address.cityName+' '+address.countyName+' '+address.detailInfo);
            } else {
                $('#address .info').html('<font color="#FE9900;">请选择您的收货地址</font>');
            }
        });
    },
    _initShops : function() {
        ajaxPost('api/apiUserController/getShops', {}, function(data){
            if(data.success && data.obj) {
                var shops = data.obj, items = [], shopMap = {}, initShop;
                for(var i in shops) {
                    var main = shops[i].parentId == -1 ? ' --主店' : '';
                    var item = {
                        title : shops[i].name+'-'+shops[i].address + main,
                        value : shops[i].id
                    };
                    items.push(item);
                    shopMap[shops[i].id] = shops[i];
                    if(i == 0)
                        initShop = shops[i];
                }

                if(shopId) initShop = shopMap[shopId];

                $('#address .info').empty().append('<h3><b>'+initShop.contactPeople+'</b><span>'+initShop.contactPhone+'</span></h3>');
                $('#address .info').append('<p>'+initShop.regionPath.replace(/[-]/g, ' ') + " " + initShop.address+'</p>');

                $('#shopId').val(initShop.id);
                $('#contactPhone').val(initShop.contactPhone);
                $('#contactPeople').val(initShop.contactPeople);
                $('#deliveryAddress').val(initShop.regionPath.replace(/[-]/g, ' ') + " " + initShop.address);

                $('#address').select({
                    title: "选择门店",
                    items: items,
                    onChange:function(obj){
                        shopId = obj.values;
                        CAMEL_ORDER_CONFIRM._getItemList();

                        var selectShop = shopMap[obj.values];
                        console.log(selectShop);
                        $('#address .info').empty().append('<h3><b>'+selectShop.contactPeople+'</b><span>'+selectShop.contactPhone+'</span></h3>');
                        $('#address .info').append('<p>'+selectShop.regionPath.replace(/[-]/g, ' ') + " " + selectShop.address+'</p>');

                        $('#shopId').val(selectShop.id);
                        $('#contactPhone').val(selectShop.contactPhone);
                        $('#contactPeople').val(selectShop.contactPeople);
                        $('#deliveryAddress').val(selectShop.regionPath.replace(/[-]/g, ' ') + " " + selectShop.address);
                    }
                });
            } else {
                $('#address .info').html('<font color="#FE9900;">请选择您的门店信息</font>');
                $('#address').bind('click', function(){
                    $.modal({
                        title: "系统提示！",
                        text: "门店未认证或认证失败",
                        buttons: [
                            { text: "取消", className: "default" },
                            { text: "去认证", onClick: function(){
                                window.location.href = '../ucenter/authentication.html';
                            } }
                        ]
                    });
                });
            }
        });
    },
    _placeOrder : function() {
        /*var shop = null, flag = true;
        ajaxPostSync('api/apiUserController/get', {}, function(data){
            if(data.success) {
                var user = data.obj;
                if(user.mbShop) {
                    shop = user.mbShop;
                }
            } else {
                $.toast("<font size='3pt;'>"+data.msg+"</font>", "text");
                flag = false;
            }
        });
        if(!flag) return;
        if(!shop || shop.auditStatus == 'AS03') {
            $.modal({
                title: "系统提示！",
                text: "门店未认证或认证失败",
                buttons: [
                    { text: "取消", className: "default" },
                    { text: "去认证", onClick: function(){
                        window.location.href = '../ucenter/authentication.html';
                    } }
                ]
            });
            return;
        } else if(shop.auditStatus == 'AS01'){
            $.alert("门店正在认证中", "系统提示");
            return;
        }*/

        var contactPhone = $('#contactPhone').val(), contactPeople = $('#contactPeople').val(),
            deliveryAddress = $('#deliveryAddress').val();
        if(Util.checkEmpty(contactPhone) || Util.checkEmpty(contactPeople) || Util.checkEmpty(deliveryAddress)) {
            $.alert("请选择您的门店信息！", "系统提示");
            return;
        }
        var orderParam = {
            shopId : $('#shopId').val(),
            totalPrice : $('#totalPrice').val(),
            deliveryPrice : $('#deliveryFee').val(),
            deliveryWay : $('#deliveryWay').val(),
            contactPhone : contactPhone,
            contactPeople : contactPeople,
            deliveryAddress : deliveryAddress,
            invoiceWay : $('#invoiceWay').val(),
            userRemark : $('#userRemark').val(),
            mbOrderItemList : []
        };

        // 发票信息
        if($('#invoiceWay').val() != 'IW01') {
            var flag = true;
            $('.order-mess input.required').each(function(){
                if(!$(this).is(":hidden")&&Util.checkEmpty($(this).val())) {
                    flag = false;
                    var msg = $(this).parent().prev().text();
                    $.toast("<font size='3pt;'>请输入" + msg + "</font>", "text");
                    return false;
                }
            });
            if(!flag) return;

            orderParam.mbOrderInvoice = {
                companyName : $('#companyName').val(),
                companyTfn : $('#companyTfn').val(),
                bankName : $('#bankName').val(),
                bankNumber : $('#bankNumber').val(),
                invoiceUse : $('#invoiceUse').val()
            }
        }

        // 商品信息
        $('.confirm-list li').each(function(){
            var item_id = $(this).attr('data-id'),
                buyPrice = $(this).find('[name=contractPrice]').text().substr(1)*1000/10,
                marketPrice = buyPrice;
            if($(this).find('[name=marketPrice]').length != 0) {
                marketPrice = $(this).find('[name=marketPrice]').text().substr(1)*1000/10;
            }
            var quantity;
            if(itemId) {
                quantity = $(this).find('.ui-btn .quantity').val();
            } else if(shoppingIds) {
                quantity = $(this).find('.ui-num span[name=quantity]').text();
            }
            var item = {
                itemId : item_id,
                marketPrice : marketPrice,
                buyPrice : buyPrice,
                quantity : quantity
            };
            orderParam.mbOrderItemList.push(item);
        });

        ajaxPost('api/apiOrderController/add', {orderParam : JSON.stringify(orderParam)}, function(data) {
            console.log(data);
            if (data.success) {
                // 删除购物车
                CAMEL_ORDER_CONFIRM._deleteShopping();
                window.location.replace('../pay/pay.html?orderId=' + data.obj + '&amount=' + $('#totalPrice').val());
            } else {
                $.loading.close();
                $.alert(data.msg, "系统提示");
            }
        }, function(){
            $.loading.load({type:3, msg:'正在提交...'});
        }, -1);
    },
    _deleteShopping : function(){
        ajaxPostSync('api/apiShoppingController/batchDelete', {ids : shoppingIds}, function(data) {
            if (data.success) {
                // 不做任何操作
            }
        });
    }
};