/**
 * Created by snow on 17/5/5.
 */
var time = 59, editable = GetRequest('editable') || 0;
$(function () {
    if(editable == 1) {
        document.title = '修改手机号';
        $('.editable').addClass('ui-row-flex').show();
        $('.header-name').html('修改手机号');
    } else {

    }
    $.hideLoadMore();
    $('#vcode-btn').bind('click', getValidateCode);
    $('#bindPhone-btn').bind('click', bindPhone);
});

function getValidateCode() {
    var phone = $("#phone").val();
    if(!Util.checkPhone(phone)) {
        $.toptip('请输入正确的手机号码', 'error');
        return;
    }
    $('#vcode-btn').html("重发（<span id=\"time\">"+time+"</span>）").unbind('click');
    time--;
    var interval = setInterval(function(){
        $("#time").html(time);
        if(time == 0) {
            clearInterval(interval);
            $("#vcode-btn").html("获取验证码").bind("click", getValidateCode);
            time = 59;
        } else {
            time -- ;
        }
    }, 1000);

    ajaxPost('api/apiUserController/getValidateCode', {phone : phone}, function(data){
        if(data.success) {
            $.toptip('验证码已发送至手机', 'success');
        } else {
            $.toptip(data.msg, 'error');
            clearInterval(interval);
            $("#vcode-btn").html("获取验证码").bind("click", getValidateCode);
            time = 59;
        }
    });
}

function bindPhone() {
    var phone = $("#phone").val();
    if(!Util.checkPhone(phone)) {
        $.toptip('请输入正确的手机号码', 'error');
        return;
    }
    var vcode = $("#vcode").val();
    if(Util.checkEmpty(vcode)) {
        $.toptip('请输入验证码', 'error');
        return;
    }
    ajaxPost('api/apiUserController/edit', {phone : phone, validateCode : vcode}, function(data){
        if (data.success) {
           window.location.replace('../home/index.html');
        } else {
            $.toptip(data.msg, 'error');
        }
    }, function(){
        $.loading.load({type:2, msg:'绑定中...'});
    }, -1);
}