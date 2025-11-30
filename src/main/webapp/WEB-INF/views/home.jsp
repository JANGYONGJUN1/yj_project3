<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false"%>

<!DOCTYPE html>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author"
	content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
<meta name="generator" content="Astro v5.13.2">
<title>Album example · Bootstrap v5.3</title>

<link href="${pageContext.request.contextPath}/resources/css/home.css?v=1" rel="stylesheet" />

<link rel="canonical"
	href="https://getbootstrap.com/docs/5.3/examples/album/">
<script src="/docs/5.3/assets/js/color-modes.js"></script>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">

<link rel="apple-touch-icon"
	href="/docs/5.3/assets/img/favicons/apple-touch-icon.png"
	sizes="180x180">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon-32x32.png"
	sizes="32x32" type="image/png">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon-16x16.png"
	sizes="16x16" type="image/png">
<link rel="manifest" href="/docs/5.3/assets/img/favicons/manifest.json">
<link rel="mask-icon"
	href="/docs/5.3/assets/img/favicons/safari-pinned-tab.svg"
	color="#712cf9">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon.ico">
<meta name="theme-color" content="#712cf9">

<style>

.bd-placeholder-img {
	font-size: 1.125rem;
	text-anchor: middle;
	-webkit-user-select: none;
	-moz-user-select: none;
	user-select: none
}

@media ( min-width : 768px) {
	.bd-placeholder-img-lg {
		font-size: 3.5rem
	}
}

.b-example-divider {
	width: 100%;
	height: 3rem;
	background-color: #0000001a;
	border: solid rgba(0, 0, 0, .15);
	border-width: 1px 0;
	box-shadow: inset 0 .5em 1.5em #0000001a, inset 0 .125em .5em #00000026
}

.b-example-vr {
	flex-shrink: 0;
	width: 1.5rem;
	height: 100vh
}

.bi {
	vertical-align: -.125em;
	fill: currentColor
}

.nav-scroller {
	position: relative;
	z-index: 2;
	height: 2.75rem;
	overflow-y: hidden
}

.nav-scroller .nav {
	display: flex;
	flex-wrap: nowrap;
	padding-bottom: 1rem;
	margin-top: -1px;
	overflow-x: auto;
	text-align: center;
	white-space: nowrap;
	-webkit-overflow-scrolling: touch
}

.btn-bd-primary { -
	-bd-violet-bg: #712cf9; -
	-bd-violet-rgb: 112.520718, 44.062154, 249.437846; -
	-bs-btn-font-weight: 600; -
	-bs-btn-color: var(- -bs-white); -
	-bs-btn-bg: var(- -bd-violet-bg); -
	-bs-btn-border-color: var(- -bd-violet-bg); -
	-bs-btn-hover-color: var(- -bs-white); -
	-bs-btn-hover-bg: #6528e0; -
	-bs-btn-hover-border-color: #6528e0; -
	-bs-btn-focus-shadow-rgb: var(- -bd-violet-rgb); -
	-bs-btn-active-color: var(- -bs-btn-hover-color); -
	-bs-btn-active-bg: #5a23c8; -
	-bs-btn-active-border-color: #5a23c8
}

.bd-mode-toggle {
	z-index: 1500
}

.bd-mode-toggle .bi {
	width: 1em;
	height: 1em
}

.bd-mode-toggle .dropdown-menu .active .bi {
	display: block !important
}

.right-tab {
	padding-right: 15px
}
.list-unstyled {
	display: flex;
}
.col {
	width: 25%;
}
.sec2 {
	width: 1320px;
	margin: 0 auto 10px; /* 중앙 정렬 */
	display: flex;
	justify-content: space-between; /* 양 끝 배치 */
	align-items: center;
}
.sec2 .search{
	max-width: 300px;
	margin-right: 40px;
}
.sec2 .category-box{
	margin-left: 15px;
}
.card-img-top {
	height: 286px;
}
.card-title{
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	font-size: 15px;
}

</style>

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
											<button type="button" class="btn btn-sm btn-outline-secondary">상세보기</button>
											<button type="button" class="btn btn-sm btn-outline-secondary">장바구니 담기</button>
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