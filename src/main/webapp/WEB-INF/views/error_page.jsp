<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="resources/css/error_page.css" rel="stylesheet" type="text/css">
<title>Error Page</title>
</head>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	
	<div class="error-container">
        <img src="https://img.icons8.com/ios/452/error.png" alt="Error Icon" class="error-image">
        <h1>404</h1>
        <h2>Oops! Page Not Found</h2>
        <p>Sorry, the page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
        <a href="${pageContext.request.contextPath}/soomtoon_daily">Go to Homepage</a>
    </div>
    
    <jsp:include page="footer.jsp"></jsp:include>
</body>
</html>