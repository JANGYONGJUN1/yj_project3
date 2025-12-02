<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true"%>

<!DOCTYPE html>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
<meta name="generator" content="Astro v5.13.2">
<title>Album example · Bootstrap v5.3</title>

<link rel="canonical" href="https://getbootstrap.com/docs/5.3/examples/album/">
<script src="/docs/5.3/assets/js/color-modes.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="apple-touch-icon" href="/docs/5.3/assets/img/favicons/apple-touch-icon.png" sizes="180x180">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon-32x32.png" sizes="32x32" type="image/png">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon-16x16.png" sizes="16x16" type="image/png">
<link rel="manifest" href="/docs/5.3/assets/img/favicons/manifest.json">
<link rel="mask-icon" href="/docs/5.3/assets/img/favicons/safari-pinned-tab.svg" color="#712cf9">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon.ico">
<meta name="theme-color" content="#712cf9">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css"/>

<script>
window.addEventListener('DOMContentLoaded', function(){
	var detailBtn = document.querySelectorAll('.detail-btn');
	
	detailBtn.forEach(detailBtn => {
		detailBtn.addEventListener('click', function(event){
			var productIdx = this.getAttribute('data-product-id');
			
			if(productIdx){
				alert("상품 idx: " + productIdx)
				location.href = "${pageContext.request.contextPath}/productDetail?productIdx=" + productIdx;
			}else {
				alert("상품 ID를 찾을 수 없습니다");
			}
		});
	});
	
}); // windows.addEventListener의 닫는 중괄호
</script>
</head>

<body>
	<jsp:include page="header.jsp"></jsp:include>
	<main>
		<section class="py-5 text-center container">
			<div class="row py-lg-5">
				<div class="col-lg-6 col-md-8 mx-auto">
					<h1 class="fw-light">옷 다있소</h1>
					<p class="lead text-body-secondary">옷 다있소 입니다. 많은 관심 부탁드립니다.</p>
				</div>
			</div>
		</section>
		
		<div class="album py-5 bg-body-tertiary">
			<div class ="sec2">
			<div class="category-box category-btn">
				<a class="btn btn-primary my-2" id="btnAll" data-category="0">전체</a> 
				<a class="btn btn-secondary my-2" id="btnTop" data-category="1">상의</a>
				<a class="btn btn-secondary my-2" id="btnBottom" data-category="2">하의</a>
				<a class="btn btn-secondary my-2" id="btnAny" data-category="3">신발</a>
			</div>
				<form class="d-flex search" role="search">
					<input id="search" class="form-control me-2" type="search" placeholder="Search" aria-label="Search" value =""/>
					<button id="searchBtn" class="btn btn-outline-success" type="submit">Search</button>
				</form>
			</div>
			
			<div class="container">
				<div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-3">
				
					<c:forEach var="item" items="${productList}">
					
						<div class="col">
							<div class="card" style="width: 18rem;">
								<img src=${item.img1 } class="card-img-top" alt="...">
								<div class="card-body">
									<h5 class="card-title"> ${item.productName} </h5>
									<p class="card-text"> ${item.content} </p>
									<div class="d-flex justify-content-between align-items-center">
										<div class="btn-group">
											<button type="button" class="btn btn-sm btn-outline-secondary detail-btn"  data-product-id="${item.productIdx}">상세보기</button>
											<c:choose>
												<c:when  test="${not empty sessionScope.loginUser }">
												<button type="button" class="btn btn-sm btn-outline-secondary">장바구니 담기</button>
												</c:when>
											</c:choose>
										</div>
										<small class="text-body-secondary"> ${item.views } </small>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
					
				</div>
			</div>
		</div>
	</main>
	
	<jsp:include page="footer.jsp"></jsp:include>
	
	<script src="${pageContext.request.contextPath}/resources/js/home.js?v=1"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>

</html>