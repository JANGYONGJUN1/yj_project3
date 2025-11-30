<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/signUp.css"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<title>회원가입</title>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
<script type="text/javascript" src="resources/js/signUp.js"></script>
</head>

<body>
<script>
window.addEventListener('DOMContentLoaded', function () {
// HTML이 완전히 준비된 후에 아래의js코드가 실행되도록 보장.
// HTML 문서가 완전히 로드되지 않은 상태에서 js 실행시 오류 발생 방지
	
	var isEmailCheckde = false;
	
	
//	아이디 휴효성 검사 (영어 소문자, 숫자만)
	function userId(userId) {
		let lowercase = /^[a-z0-9]+$/;
		if(!lowercase.test(userId)){
			alert("아이디는 영어 소문자와 숫자만 포함할 수 있습니다.");
			return false;
		}
		return true;
	}
	
//	비밀번호 유효성 검사 함수
	function validatePassword(password) {
	    const minLength = 8;
	    const uppercaseRegExp = /[A-Z]/;
	    const lowercaseRegExp = /[a-z]/;
	    const numberRegExp = /[0-9]/;
	    const specialCharRegExp = /[!@#$%^&*(),.?":{}|<>]/;
	
	    if (password.length < minLength) {
	        alert("비밀번호는 최소 8자 이상이어야 합니다.");
	        return false;
	    }
	    if (!uppercaseRegExp.test(password)) {
	        alert("비밀번호에는 대문자가 하나 이상 포함되어야 합니다.");
	        return false;
	    }
	    if (!lowercaseRegExp.test(password)) {
	        alert("비밀번호에는 소문자가 하나 이상 포함되어야 합니다.");
	        return false;
	    }
	    if (!numberRegExp.test(password)) {
	        alert("비밀번호에는 숫자가 하나 이상 포함되어야 합니다.");
	        return false;
	    }
	    if (!specialCharRegExp.test(password)) {
	        alert("비밀번호에는 특수 문자가 하나 이상 포함되어야 합니다.");
	        return false;
	    }
	    return true;
	}

	
// 	이름 유효성 검사 (한글 두글자 이상)
	function userNmae(name) {
// 		let nameExr = /^[a-zA-Z가-힣\s]+$/;
		let nameExr = /^[가-힣\s]+$/;
		let minLength = 2;
		let maxLength = 50;
		
		if(name.length < minLength || name.length > maxLength) {
			alert("이름은 최소 2글자이상, 최대 50글자 이내여야 합니다");
			return false;
		}
		if(!nameExr.test(name)){
			alert("이름에 한글만 사용 할 수 있습니다");
			return false;
		}
		return true;
	}
	
	// ⭐️⭐️⭐️ 이메일 형식 유효성 검사 함수 추가 ⭐️⭐️⭐️
	function emailCheck(email) {
	    // 기본적인 이메일 형식 검사 정규 표현식
	    // (A-Z, a-z, 0-9, . , _, - @ 도메인 . com)
	    let emailExr = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
	    
	    if (!emailExr.test(email)) {
	        alert("올바른 이메일 주소 형식이 아닙니다.");
	        return false;
	    }
	    return true;
	}
	
	// 회원가입 유효성 검사
	function addCheck() {
	 	if (frm.id.value.length === 0) {
			alert("아이디가 입력되지 않았습니다");
			frm.id.focus();
			return false;
		} else if (!userId(frm.id.value)) {
			frm.id.focus();
			return false;
		}

		// 비밀번호 검사
		if (!validatePassword(frm.pw.value)) {
			frm.pw.focus();
			return false;
		}

		if (frm.name.value.length === 0) {
			alert("이름이 입력되지 않았습니다");
			frm.name.focus();
			return false;
		} else if (!userNmae(frm.name.value)) {
			frm.name.focus();
			return false;
		} 
		
		
		
		alert("회원가입이 완료되었습니다");
		
		return;
		
	}

	// 회원가입 폼 제출 시 유효성 검사
	/* document.forms['frm'].onsubmit = function () {
		return addCheck();
	};
	
	let id = document.getElementById("id");
	
	id.addEventListener("focusout",function(){
		let idVal = document.getElementById("id").value;
		let contextPath = '${pageContext.request.contextPath}';
		console.log("입력값:", idVal);
		if( idVal === '' || idVal.length == 0 || idVal.includes(' ')) {
			// ID가 공백, 0, 문자열 사이 공백이면 ID생성 불가.
			let label1 = document.getElementById("label1");
			label1.style.color = "red"; 
			label1.textContent = "공백은 ID로 사용할 수 없습니다.";
			
			return false;
		}
		
	  // Ajax 요청
		$.ajax({
		    url: contextPath + '/ajax/ConfirmId',
		    data: JSON.stringify({"id": idVal}),  // JSON으로 id 데이터를 전송
		    type: 'POST',
		    contentType: 'application/json; charset=UTF-8',  // JSON 형식으로 전송
		    dataType: 'json',  // 서버에서 JSON 형식의 응답을 기대
		    success: function(result) {
		        console.log("Ajax 성공, 서버에서 받아온 값: " + result); 
		        let label1 = $("#label1");
		        if (result === true) {  // 아이디 중복일 때
		            label1.css("color", "red");
		            label1.text("사용 불가능한 ID 입니다");
		            $("#id").val('');  // 불가능한 ID일 경우 ID 필드 초기화
		        } else if (result === false) {  // 사용 가능한 아이디일 때
		            label1.css("color", "black");
		            label1.text("사용 가능한 ID 입니다");
		        }
		    },
		    error: function(xhr, status, error) {
		        console.log("에러발생:", error);
		    }
		});

	}); */
	
	var code="";
	
	$(".email_checkBtn").click(function(){
		
		var email = $("#email_input").val();
		
		if(!emailCheck(email)){
			$("#email_input").focus();
			return;
			
		}
		
		var checkNumInput = $(".email_check_input");
		var checkNumInputBox = $(".email_check_input_box");
		
		alert("email : " + email);
		
 		$.ajax({
			type: "GET",
			url: "mailCheck?email=" + email,
			success: function(data){
				console.log("전받받은 데이터: "+ data);
				checkNumInput.attr("disabled", false);
				checkNumInputBox.attr("id","mail_check_input_box_true");
				code = data;
			}
		}); 
	});
	
	//인증번호 비교
	 $(".email_check_input").blur(function(){
		var inputcode = $(".email_check_input").val();			// 입력코드
		var checkResult = $("#email_check_input_box_warn");		// 비교 결과
		var signUpBtn = $(".signUp-btn");
		
		if(inputcode == code) {
			checkResult.html("인증번호가 일치합니다");
			checkResult.attr("class", "correct");
			isEmailChecked = true;
			signUpBtn.attr("disabled", false);
			
		}else {
			checkResult.html("인증번호를 다시 확인해주세요");
			checkResult.attr("class","incorrect");
			isEmailChecked = false;
			signUpBtn.attr("disabled", true);
			return;
		}
	}); 
	
	
	
}); /* function 마지막 중괄호 */
</script>
<jsp:include page="header.jsp"></jsp:include>
	<div>
		<form action="${pageContext.request.contextPath}/signUp" method="post" name="frm" onsubmit="return addCheck()" class="signUp-layout">
			<div id="signUp-box">
				<div class="content_box">
					<label for="id" id="label1"><h5>아이디</h5></label>
					<input type="text" name="memberId" id="id" placeholder="ID를 입력해주세요"/>
					<h5>비밀번호</h5>
					<input type="password" name="password" id="pw" placeholder="비밀번호를 입력해주세요"/>
					<h5>이름</h5>
					<input type="text" name="name" id="name" placeholder="이름을 입력해주세요"/>
					<h5>이메일</h5>
					<input type="email" name="email" id="email_input" placeholder="email을 입력해주세요"/>
					<div class="emailForm_Box"></div>
					<span class="emailForm"></span>
					<div class="email_check_input_box" id="mail_check_input_box_false" style="display: flex; justify-content: space-between; align-items: center;">
						<input class="email_check_input" disabled="disabled" placeholder="인증번호 입력" maxlength="6"/>
						<div class="email_checkBtn" style="cursor: pointer;"><span>인증번호 전송</span></div>
					</div>
					<div class="clearfix"></div>
					<span id="email_check_input_box_warn"></span>
					<div id="btn-box" style="margin-top: 20px;">
						<input class="signUp-btn" type="submit" value="가입하기"/>
					</div>
				</div>
			</div>
		</form>
	</div>
<jsp:include page="footer.jsp"></jsp:include>
</body>

</html>