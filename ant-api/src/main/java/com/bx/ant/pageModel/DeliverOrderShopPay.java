package com.bx.ant.pageModel;

import java.util.Date;

@SuppressWarnings("serial")
public class DeliverOrderShopPay implements java.io.Serializable {

	private static final long serialVersionUID = 5454155825314635342L;

	private Long id;
	private Integer tenantId;
	private Date addtime;			
	private Date updatetime;			
	private Boolean isdeleted;
	private Long deliverOrderShopId;
	private Long deliverOrderId;
	private Long shopOrderBillId;
	private Integer shopId;
	private String status;
	private Integer amount;
	private String payWay;

	

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
	public void setDeliverOrderShopId(Long deliverOrderShopId) {
		this.deliverOrderShopId = deliverOrderShopId;
	}
	
	public Long getDeliverOrderShopId() {
		return this.deliverOrderShopId;
	}
	public void setDeliverOrderId(Long deliverOrderId) {
		this.deliverOrderId = deliverOrderId;
	}
	
	public Long getDeliverOrderId() {
		return this.deliverOrderId;
	}
	public void setShopId(Integer shopId) {
		this.shopId = shopId;
	}
	
	public Integer getShopId() {
		return this.shopId;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getStatus() {
		return this.status;
	}
	public void setAmount(Integer amount) {
		this.amount = amount;
	}
	
	public Integer getAmount() {
		return this.amount;
	}
	public void setPayWay(String payWay) {
		this.payWay = payWay;
	}
	
	public String getPayWay() {
		return this.payWay;
	}

	public Long getShopOrderBillId() {
		return shopOrderBillId;
	}

	public void setShopOrderBillId(Long shopOrderBillId) {
		this.shopOrderBillId = shopOrderBillId;
	}
}
