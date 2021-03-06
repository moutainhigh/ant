package com.bx.ant.pageModel;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

@SuppressWarnings("serial")
public class DeliverOrder implements java.io.Serializable {

	private static final long serialVersionUID = 5454155825314635342L;

	private Long id;
	private Integer tenantId;
	private Date addtime;			
	private Date updatetime;			
	private Boolean isdeleted;
	private Integer supplierId;
	private Integer amount;
	private String status;
	private String deliveryStatus;
	private Date deliveryRequireTime;			
	private String deliveryAddress;
	private Integer deliveryRegion;
	private String payStatus;
	private String shopPayStatus;
	private String payWay;
	private String contactPhone;
	private String contactPeople;
	private BigDecimal longitude;
	private BigDecimal latitude;
	private String remark;
	private Integer shopId;
	private BigDecimal shopDistance;
	private String supplierOrderId;
	private String supplierOrderType;
	private String completeImages;
	private String completeRemark;
    private String deliverOrderLogType;
	private Integer weight;
	private Integer freight; // 运费统一配置：分/件

	private String deliveryWay;
	private String deliveryType; // 派单类型
	private Long orderShopId;
	private String  orderLogRemark;
	private DriverAccount driverAccount;

	private String originalOrderId;
	private String originalShop;
	private String originalOrderStatus;
	private String agentStatus;

	private Map<String,Object> extend;
	
	private Boolean checkAmount; // 是否检查余额不足
	private String loginId;

	public void setId(Long value) {
		this.id = value;
	}
	
	public Long getId() {
		return this.id;
	}

	
	public void setTenantId(Integer tenantId) {
		this.tenantId = tenantId;
	}
	
	public Integer getTenantId() {
		return this.tenantId;
	}
	public void setAddtime(Date addtime) {
		this.addtime = addtime;
	}
	
	public Date getAddtime() {
		return this.addtime;
	}
	public void setUpdatetime(Date updatetime) {
		this.updatetime = updatetime;
	}
	
	public Date getUpdatetime() {
		return this.updatetime;
	}
	public void setIsdeleted(Boolean isdeleted) {
		this.isdeleted = isdeleted;
	}
	
	public Boolean getIsdeleted() {
		return this.isdeleted;
	}
	public void setSupplierId(Integer supplierId) {
		this.supplierId = supplierId;
	}
	
	public Integer getSupplierId() {
		return this.supplierId;
	}
	public void setAmount(Integer amount) {
		this.amount = amount;
	}
	
	public Integer getAmount() {
		return this.amount;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}
	public void setDeliveryStatus(String deliveryStatus) {
		this.deliveryStatus = deliveryStatus;
	}
	
	public String getDeliveryStatus() {
		return this.deliveryStatus;
	}
	public void setDeliveryRequireTime(Date deliveryRequireTime) {
		this.deliveryRequireTime = deliveryRequireTime;
	}
	
	public Date getDeliveryRequireTime() {
		return this.deliveryRequireTime;
	}
	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}
	
	public String getDeliveryAddress() {
		return this.deliveryAddress;
	}
	public void setDeliveryRegion(Integer deliveryRegion) {
		this.deliveryRegion = deliveryRegion;
	}
	
	public Integer getDeliveryRegion() {
		return this.deliveryRegion;
	}
	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}
	
	public String getPayStatus() {
		return this.payStatus;
	}
	public void setShopPayStatus(String shopPayStatus) {
		this.shopPayStatus = shopPayStatus;
	}
	
	public String getShopPayStatus() {
		return this.shopPayStatus;
	}
	public void setPayWay(String payWay) {
		this.payWay = payWay;
	}
	
	public String getPayWay() {
		return this.payWay;
	}
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
	
	public String getContactPhone() {
		return this.contactPhone;
	}
	public void setContactPeople(String contactPeople) {
		this.contactPeople = contactPeople;
	}
	
	public String getContactPeople() {
		return this.contactPeople;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	public String getRemark() {
		return this.remark;
	}

	public Integer getShopId() {
		return shopId;
	}

	public void setShopId(Integer shopId) {
		this.shopId = shopId;
	}

	public BigDecimal getLongitude() {
		return longitude;
	}

	public void setLongitude(BigDecimal longitude) {
		this.longitude = longitude;
	}

	public BigDecimal getLatitude() {
		return latitude;
	}

	public void setLatitude(BigDecimal latitude) {
		this.latitude = latitude;
	}

	public BigDecimal getShopDistance() {
		return shopDistance;
	}

	public void setShopDistance(BigDecimal shopDistance) {
		this.shopDistance = shopDistance;
	}

	public String getSupplierOrderId() {
		return supplierOrderId;
	}

	public void setSupplierOrderId(String supplierOrderId) {
		this.supplierOrderId = supplierOrderId;
	}

	public String getSupplierOrderType() {
		return supplierOrderType;
	}

	public void setSupplierOrderType(String supplierOrderType) {
		this.supplierOrderType = supplierOrderType;
	}

	public String getCompleteImages() {
		return completeImages;
	}

	public void setCompleteImages(String completeImages) {
		this.completeImages = completeImages;
	}

	public String getCompleteRemark() {
		return completeRemark;
	}

	public void setCompleteRemark(String completeRemark) {
		this.completeRemark = completeRemark;
	}

	public String getDeliverOrderLogType() {
		return deliverOrderLogType;
	}

	public void setDeliverOrderLogType(String deliverOrderLogType) {
		this.deliverOrderLogType = deliverOrderLogType;
	}

	public String getDeliveryType() {
		return deliveryType;
	}

	public void setDeliveryType(String deliveryType) {
		this.deliveryType = deliveryType;
	}

	public Integer getWeight() {
		return weight;
	}

	public void setWeight(Integer weight) {
		this.weight = weight;
	}

	public Long getOrderShopId() {
		return orderShopId;
	}

	public void setOrderShopId(Long orderShopId) {
		this.orderShopId = orderShopId;
	}

	public String getOrderLogRemark() {
		return orderLogRemark;
	}

	public void setOrderLogRemark(String orderLogRemark) {
		this.orderLogRemark = orderLogRemark;
	}

	public String getDeliveryWay() {
		return deliveryWay;
	}

	public void setDeliveryWay(String deliveryWay) {
		this.deliveryWay = deliveryWay;
	}

	public DriverAccount getDriverAccount() {
		return driverAccount;
	}

	public void setDriverAccount(DriverAccount driverAccount) {
		this.driverAccount = driverAccount;
	}

	public String getOriginalOrderId() {
		return originalOrderId;
	}

	public void setOriginalOrderId(String originalOrderId) {
		this.originalOrderId = originalOrderId;
	}

	public String getOriginalShop() {
		return originalShop;
	}

	public void setOriginalShop(String originalShop) {
		this.originalShop = originalShop;
	}

	public String getOriginalOrderStatus() {
		return originalOrderStatus;
	}

	public void setOriginalOrderStatus(String originalOrderStatus) {
		this.originalOrderStatus = originalOrderStatus;
	}

	public Integer getFreight() {
		return freight;
	}

	public void setFreight(Integer freight) {
		this.freight = freight;
	}

	public String getAgentStatus() {
		return agentStatus;
	}

	public void setAgentStatus(String agentStatus) {
		this.agentStatus = agentStatus;
	}

	public Map<String, Object> getExtend() {
		return extend;
	}

	public void setExtend(Map<String, Object> extend) {
		this.extend = extend;
	}

	public Boolean getCheckAmount() {
		return checkAmount;
	}

	public void setCheckAmount(Boolean checkAmount) {
		this.checkAmount = checkAmount;
	}

	public String getLoginId() {
		return loginId;
	}

	public void setLoginId(String loginId) {
		this.loginId = loginId;
	}
}
