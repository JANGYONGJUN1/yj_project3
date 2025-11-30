package com.board.vo;

import lombok.Data;

public class ProductVO {
	
	private int productKey;
	
	private String productName;
	
	private String content;
	
	private String img1;
	
	private int views;

	public int getProductKey() {
		return productKey;
	}

	public void setProductKey(int productKey) {
		this.productKey = productKey;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getImg1() {
		return img1;
	}

	public void setImg1(String img1) {
		this.img1 = img1;
	}

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}

	@Override
	public String toString() {
		return "ProductVO [productKey=" + productKey + ", productName=" + productName + ", content=" + content
				+ ", img1=" + img1 + ", views=" + views + "]";
	}

}
