 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mobian.model.TmbShop" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="jb" uri="http://www.jb.cn/jbtag"%>
 <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=CEADSBSqQi7DC6a5YxqPY6FvgV3Kamc4"></script>
 <script type="text/javascript">
     parent.$.messager.progress('close');
     var mapData = '${mbShopListData}';
    // var mapData= eval("(" + mbShopListData + ")");
     alert(mapData.length)
     var mapArray = new Array(mapData.length);
     for (var k = 0; k < mapArray.length; k++) {
         alert(mapData[k].address)
         mapArray[k] = new Array(3);
     }
     for (var i = 0; i < mapArray.length; i++) {
         for (var j = 0; j < mapArray[i].length; j++) {
             if (j == 0) {
                 mapArray[i][j] = mapData[i].longitude;
             } else if (j == 1) {
                 mapArray[i][j] = mapData[i].latitude
             } else if (j == 2) {
                 mapArray[i][j] = mapData[i].address
             }
         }
     }
     // 百度地图API功能
     map = new BMap.Map("allmap");
     map.centerAndZoom(new BMap.Point(116.417854,39.921988), 15);
     map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放
     /*var data_info = [[116.417854,39.921988,"地址：北京市东城区王府井大街88号乐天银泰百货八层"],
         [116.406605,39.921585,"地址：北京市东城区东华门大街"],
         [116.412222,39.912345,"地址：北京市东城区正义路甲5号"]
     ];*/
     var opts = {
         width : 250,     // 信息窗口宽度
         height: 80,     // 信息窗口高度
         title : "信息窗口" , // 信息窗口标题
         enableMessage:true//设置允许信息窗发送短息
     };
     for(var i=0;i<mapArray.length;i++){
         var marker = new BMap.Marker(new BMap.Point(mapArray[i][0],mapArray[i][1]));  // 创建标注
         var content = mapArray[i][2];
         map.addOverlay(marker);               // 将标注添加到地图中
         addClickHandler(content,marker);
     }
     function addClickHandler(content,marker){
         marker.addEventListener("click",function(e){
             openInfo(content,e)}
         );
     }
     function openInfo(content,e){
         var p = e.target;
         var point = new BMap.Point(p.getPosition().lng, p.getPosition().lat);
         var infoWindow = new BMap.InfoWindow(content,opts);  // 创建信息窗口对象
         map.openInfoWindow(infoWindow,point); //开启信息窗口
     }

 </script>
 <div class="easyui-layout" data-options="fit:true,border:false">
     <div data-options="region:'center',border:false" title="" style="overflow: hidden;">
         <div id="allmap" style="height: 800px;"></div>
     </div>
 </div>
