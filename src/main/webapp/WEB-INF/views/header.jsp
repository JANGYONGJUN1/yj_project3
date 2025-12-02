<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script> const ctx = "${pageContext.request.contextPath}"</script>
<script type="text/javascript">
	function home() {
		window.location.href = "${pageContext.request.contextPath}/"
	}
	function signIn() {
		window.location.href = "${pageContext.request.contextPath}/signInPage" 
	}
	function signUp() {
		window.location.href = "${pageContext.request.contextPath}/signUpPage"
	}
</script>

</head>
<body>
	<header data-bs-theme="dark">
		<div class="collapse text-bg-dark" id="navbarHeader">
			<div class="container">
				<div class="row">
					<div class="col-sm-8 col-md-7 py-4" >
						<h4>About</h4>
						<p class="text-body-secondary">
							옷 다있소ver.1
						</p>
					</div>
					<div class="col-sm-4 offset-md-1 py-4">
						<h4>JOIN</h4>
						<ul class="list-unstyled">
							<c:choose>
								<%-- 로그인 안된 상태 --%>
								<c:when test="${empty sessionScope.loginUser}">
									<li class="right-tab"><a href="#" class="text-white" onclick="signIn()">로그인</a></li>
									<li class="right-tab"><a href="#" class="text-white" onclick="signUp()">회원가입</a></li>
								</c:when>
								
								<%-- 로그인 상태  SessionUserDTO 사용 --%>
								<c:otherwise>
									<li class ="right-tab text-white" >
										${sessionScope.loginUser.loginName}님 환영합니다.
									</li>
									<li class ="right-tab">
										<c:choose>
											<%-- 카카오 로그인 상태 --%>
											<c:when test="${sessionScope.loginUser.loginType eq 'KAKAO'}">
												<form action="/kakaoLogout" method="POST" >
												    <button type="submit" style="display:inline; background:none;">카카오 로그아웃</button>
												</form>
											</c:when>
											<%-- 일반 로그인 상태 --%>
											<c:otherwise>
													<form action="/logout" method="POST" >
													    <button type="submit" style="display:inline; background:none;">로그아웃</button>
													</form>
											</c:otherwise>
										</c:choose>
									</li>
								</c:otherwise>
							</c:choose>
						</ul>
					</div>
				</div>
			</div>
		</div>
		<div class="navbar navbar-dark bg-dark shadow-sm">
			<div class="container">
				<a href="#" class="navbar-brand d-flex align-items-center" onclick="home()"> 
					<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" aria-hidden="true" class="me-2" viewBox="0 0 24 24">
						<path d="M23 19a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h4l2-3h6l2 3h4a2 2 0 0 1 2 2z"></path>
						<circle cx="12" cy="13" r="4"></circle>
					</svg> 
					<strong>옷 다있소</strong>
				</a>
				<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarHeader" aria-controls="navbarHeader" aria-expanded="false" aria-label="Toggle navigation">
					<span class="navbar-toggler-icon"></span>
				</button>
			</div>
		</div>
	</header>
</body>
</html>