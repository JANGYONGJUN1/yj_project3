<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 상세페이지</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/productDetailPage.css"/>

</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<main>
    <div class="product-detail-container">
        <div class="product-image-gallery">
            <div class="main-image">
                <img src=${product.img1 } alt="상품 메인 이미지">
            </div>
            <div class="thumbnail-images">
                <img src=${product.img2 } alt="썸네일 1">
                </div>
        </div>

        <div class="product-info-summary">
            <h1 class="product-name">${product.productName }</h1>
            <p class="product-brand">브랜드명</p>
            <div class="product-price">
                <span class="discount-price">₩49,000</span>
                <span class="original-price">${product.price }</span>
                <span class="discount-rate">30% 할인</span>
            </div>
            <div class="product-rating">
                ⭐️⭐️⭐️⭐️ (123 리뷰)
            </div>
            <p class="product-short-desc">${product.content}</p>

            <div class="product-options">
                <div class="option-group">
                    <label for="color-select">색상:</label>
                    <select id="color-select">
                        <option value="black">블랙</option>
                        <option value="white">화이트</option>
                    </select>
                </div>
                <div class="option-group">
                    <label for="size-select">사이즈:</label>
                    <select id="size-select">
                        <option value="S">S</option>
                        <option value="M">M</option>
                    </select>
                </div>
                <div class="option-group">
                    <label for="quantity-select">수량:</label>
                    <input type="number" id="quantity-select" value="1" min="1">
                </div>
            </div>

            <div class="action-buttons">
                <button class="add-to-cart-btn">장바구니 담기</button>
                <button class="buy-now-btn">바로 구매하기</button>
                <button class="wishlist-btn">찜하기 ❤️</button>
            </div>
        </div>
    </div>
	
	<div class="product-full-description">
        <h2>상품 상세 정보</h2>
        <div class="description-tabs">
            <button class="tab-btn active">상품 설명</button>
            <button class="tab-btn">리뷰 (123)</button>
            <button class="tab-btn">Q&A (12)</button>
            <button class="tab-btn">배송/교환/반품</button>
        </div>
        
        <div class="tab-content active">
            <img src="path/to/detail_image1.jpg" alt="상세 설명 1">
            <p>이 상품은 뛰어난 착용감과 내구성을 자랑합니다. 데일리룩에 완벽하게 어울립니다.</p>
            <img src="path/to/detail_image2.jpg" alt="상세 설명 2">
            <h3>소재 및 관리법</h3>
            <ul>
                <li>소재: 면 100%</li>
                <li>세탁: 찬물 단독 손세탁</li>
            </ul>
        </div>
		<div class="related-products-section">
	        <h2>이런 상품은 어떠세요?</h2>
	        <div class="product-carousel">
	            <div class="related-product-card">
	                <img src="path/to/related_prod1.jpg" alt="관련 상품 1">
	                <h3>관련 상품 1</h3>
	                <p>₩35,000</p>
	            </div>
	            <div class="related-product-card">
	                <img src="path/to/related_prod2.jpg" alt="관련 상품 2">
	                <h3>관련 상품 2</h3>
	                <p>₩28,000</p>
	            </div>
	            </div>
	    </div>
	</div>
</main>
<jsp:include page="footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>