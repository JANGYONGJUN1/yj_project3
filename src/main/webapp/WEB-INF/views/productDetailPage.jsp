<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 상세페이지</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/productDetailPage.css"/>
<script>
	function changeSort(sortValue, productIdx){
		// 현재 페이지 url로 정렬 파라미터(sort) 를 추가하여 이동
		//window.location.href = '/productDetail?productIdx=' + productIdx + '&sort=' + sortValue;
		alert("클릭!!!!");
		const url = '/review/list';
		const params = {
				productIdx: productIdx,
				sort: sortValue
		};
	
		const urlParams = `\${url}?\${new URLSearchParams(params)}`;
		
		// 1.요청 보내기
		fetch(urlParams)
			.then(response => {
				if(!response.ok) {
					//HTTP 오류 상태일 경우, 에러발생
					throw new Error('HTTP 상태 코드 오류 :' + response.status);
				}
				return response.json();  //3. json으로 데이터 반환
			})
			.then(data => {
				// 4.데이터도 화면 업데이트
				console.log("받은 리뷰 데이터 : ",  data)
				updateReviewList(data);
				document.getElementById('sortSelect').value = sortValue;
			})
			.catch(error => {
				// 5. 네트워크 오류 처리 (예: 연결끊김)
				console.error('Fetch Error: ' + error);
				alert("리뷰를 불러오는중 문제가 발생하였습니다.");
			});
	}
	
	function updateReviewList(reviewList) {
		const reviewContainer = document.querySelector('.product-reviews');
		console.log("1. 컨테이너 찾음:", reviewContainer); // 1번
		
		let htmlContent = '';
		
		if(reviewList.length === 0) {
			htmlContent = '<div style="text-align: center; padding: 30px;">아직 작성된 리뷰가 없습니다.</div>';
		} else {
			reviewList.forEach(review => {
				let formattedDate = '';
				let dateObj;
				
				if(review.regdate) {
	                dateObj = new Date(review.regdate); // let으로 선언했으므로 재할당
	                
	                if (dateObj && !isNaN(dateObj.getTime())) { // 안전성 검사
	                    const year = dateObj.getFullYear();
	                    const month = String(dateObj.getMonth() + 1).padStart(2, '0');
	                    const day = String(dateObj.getDate()).padStart(2,'0');
	                    formattedDate = `\${year}-\${month}-\${day}`;
	                    
	                    console.log("year: " + year + ", month: " + month + ", day: " + day)  
	                    console.log("최종 날짜: " + formattedDate);  
	                } else {
	                    // 변환 실패 시 처리
	                    formattedDate = String(review.regdate).substring(0, 10);
	                }
	            }
				htmlContent += `
					<div class="review-layout">
					<div class="review-item" style="padding-top: 20px;">
						<span>${'${'}review.userId}</span> <br/>
						★ <span>${'${'}review.score}.0</span>
						| <span>${'${'}formattedDate}</span> </div>
					<div class="review-box">
						<span>${'${'}review.content}</span>
					</div>
				</div>
				`;
			});
			console.log("2. 생성된 HTML 길이:", htmlContent.length); // 2번
		}
		reviewContainer.innerHTML = htmlContent;
		console.log("3. innerHTML 갱신 완료"); // 4번
	}
	
	//장바구니 이동
	function addBtn(buttonElement) {
		const productIdx = buttonElement.dataset.productIdx;
		
		alert("장바구니 이동 !!	:" + productIdx);
		
	}
	
</script>
</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<main>
    <div class="product-detail-container">
        <div class="product-image-gallery">
            <div class="main-image">
                <img src="${product.img1 }" alt="상품 메인 이미지">
            </div>
            <div class="thumbnail-images">
                <img src= "${product.img2 }" alt="썸네일 1">
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
                ⭐️⭐️⭐️⭐️ (${countReview} 리뷰)
            </div>
            <p class="product-short-desc">${product.content}</p>

            <div class="product-options">
              <!--   <div class="option-group">
                    <label for="color-select">색상:</label>
                    <select id="color-select">
                        <option value="black">블랙</option>
                        <option value="white">화이트</option>
                    </select>
                </div> -->
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
                <button class="add-to-cart-btn" onclick="addBtn(this)" data-product-idx= '${product.productIdx}'>장바구니 담기</button>
                <button class="buy-now-btn">바로 구매하기</button>
                <button class="wishlist-btn">찜하기 ❤️</button>
            </div>
        </div>
    </div>
		<div class="product-full-description">
			<h2>상품 상세 정보</h2>
			<div class="description-tabs">
				<button class="tab-btn active">상품 설명</button>
				<button class="tab-btn">리뷰 (${countReview} )</button>
				<button class="tab-btn">배송/교환/반품</button>
			</div>
			<div class="tab-content active">
				<h4>이 상품은 뛰어난 착용감과 내구성을 자랑합니다. 데일리룩에 완벽하게 어울립니다.</h4>
				<img src= "${product.img3 }" style="width:40%;" alt="상품 상세정보 이미지1">
				<h3>소재 및 관리법</h3>
				<img src= "${product.detailImg }"  style="width:80%;" alt="상품 상세정보 이미지2">
			</div>
			<div class="products-section">
				<h3>리뷰</h3>
				<div class="product-carousel">
					<div class="related-product-card">
						<select id="sortSelect" onchange="changeSort(this.value, '${product.productIdx}')">
							<option value="latest" ${sortType == "latest" ? 'selected' : '' }>최신순</option>
							<option value="score" ${sortType == "score" ? 'selected' : '' }>평점 높은순</option>
							<option value="low_score" ${sortType == "low_score" ? 'selected' : '' }>평점 낮은순</option>
						</select>
					</div>
				</div>
			</div>
			<div class="product-reviews">
				<c:forEach var="review" items="${reviewList}">
				<div class="review-layout">
					<div class="review-item" style="padding-top: 20px;">
						<span>${review.userId }</span> <br/>
						★ <span>${review.score }.0</span>
						| <span><fmt:formatDate value="${review.regdate}" pattern="yyyy-MM-dd"/></span>
					</div>
					<div class="review-box">
						<span>${review.content }</span>
					</div>
				</div>
				</c:forEach>
			</div>
		</div>
	</main>
	<jsp:include page="footer.jsp"></jsp:include>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>