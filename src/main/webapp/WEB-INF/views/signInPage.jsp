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
<title>Signin Template · Bootstrap v5.3</title>
<link rel="canonical" href="https://getbootstrap.com/docs/5.3/examples/sign-in/">
<script src="/docs/5.3/assets/js/color-modes.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="apple-touch-icon" href="/docs/5.3/assets/img/favicons/apple-touch-icon.png" sizes="180x180">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon-32x32.png" sizes="32x32" type="image/png">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon-16x16.png" sizes="16x16" type="image/png">
<link rel="manifest" href="/docs/5.3/assets/img/favicons/manifest.json">
<link rel="mask-icon" href="/docs/5.3/assets/img/favicons/safari-pinned-tab.svg" color="#712cf9">
<link rel="icon" href="/docs/5.3/assets/img/favicons/favicon.ico">
<meta name="theme-color" content="#712cf9">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/signIn.css"/>

</head>

<body>
	<jsp:include page="header.jsp"></jsp:include>
	
	<div class="d-flex align-items-center justify-content-center min-vh-100 bg-body-tertiary">	
		<main class="form-signin w-100 m-auto">
			<form action="${pageContext.request.contextPath}/signIn" method="post">
				<h1 class="h3 mb-3 fw-normal">Please sign in</h1>
				<div class="form-floating">
					<input type="text" class="form-control" id="floatingInput" name ="memberId" required> 
					<label for="floatingInput">아이디</label>
				</div>
				<div class="form-floating">
					<input type="password" class="form-control" id="floatingPassword" name="password" required> 
					<label for="floatingPassword">비밀번호</label>
				</div>
				<div class="form-check text-start my-3">
					<input class="form-check-input" type="checkbox" value="remember-me"> 
					<label class="form-check-label" for="checkDefault"> 아이디 저장 </label>
				</div>
				<button class="btn btn-primary w-100 py-2" type="submit">로그인</button>
				<a href ="kakaoLogin"><img class ="kakao" src="${pageContext.request.contextPath}/resources/img/kakao_login_large_narrow.png" alt="카카오 로그인 버튼"></a>
				<div style= "justify-content: space-around; display: flex;">
					<p class="mt-5 mb-3 text-body-secondary find">아이디 찾기</p>
					<p class="mt-5 mb-3 text-body-secondary find">비밀번호 찾기</p>
					<p class="mt-5 mb-3 text-body-secondary find">회원가입</p>
					
				</div>
			</form>
		</main>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>