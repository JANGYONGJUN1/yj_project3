<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/productCartListPage.css"/>

<script>
window.addEventListener('DOMContentLoaded', function(){

    // 1. 초기 카운트 설정 (JSTL 변수를 사용하여 초기화)
    const totalCountElement = document.getElementById('totalCount');
    const checkedCountElement = document.getElementById('checkedCount');
    const cartListLength = ${fn:length(cartList)};

    if (totalCountElement) totalCountElement.textContent = cartListLength;
    if (checkedCountElement) checkedCountElement.textContent = cartListLength;

    // 2. 수량 변경 버튼 (btn-update-quantity) 클릭 이벤트
    document.querySelectorAll('.btn-update-quantity').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const productIdx = this.dataset.productIdx;
            const quantityInput = document.querySelector(`.item-quantity[data-product-idx="${productIdx}"]`);
            const newQuantity = quantityInput.value;
            
            // TODO: '/cart/update' 엔드포인트로 AJAX 요청을 보내 DB 수량 업데이트
            alert(`상품 ${productIdx}의 수량을 ${newQuantity}로 업데이트 요청.`);
            // 성공 시, 화면의 총 금액 영역을 갱신하는 로직을 추가해야 합니다.
        });
    });

    // 3. 선택 삭제 버튼 (btn-delete-selected) 클릭 이벤트
    const deleteSelectedBtn = document.querySelector('.btn-delete-selected');
    if (deleteSelectedBtn) {
        deleteSelectedBtn.addEventListener('click', function(event) {
            alert("선택상품삭제 클릭 !!");
            
            event.preventDefault(); // 버튼의 기본 동작(폼 제출 등) 방지
            event.stopPropagation(); // 이벤트가 부모 요소로 전파되는 것 방지 (가장 유력한 문제 해결책)

            const selectedCheckboxes = document.querySelectorAll('input[name="selectedProduct"]:checked');            
            
            alert("선택 삭제 카트IDX = " + selectedCheckboxes);
            
            if(selectedCheckboxes.length == 0){
            	alert("삭제할 상품을 선택해주세요.");
                return;
            }
                
           const formData = new URLSearchParams();
           
        // 💡 반복문을 돌려 체크된 상품의 cartIdx를 배열에 담기
           const cartIdxList = [];
           selectedCheckboxes.forEach(checkbox => {
               // 체크박스가 속한 가장 가까운 .cart-item 행을 찾아서 그 안의 삭제 버튼에 있는 data-cart-idx를 가져옴
               const cartItem = checkbox.closest('.cart-item');
               const cartIdx = cartItem.querySelector('.btn-delete-item').getAttribute('data-cart-idx');
               cartIdxList.push(cartIdx);
           });

           if (confirm("선택한 " + cartIdxList.length + "개의 상품을 삭제하시겠습니까?")) {
               
               // 💡 서버로 보낼 때: 리스트 형태를 전송하기 위해 URLSearchParams에 반복 추가
               const formData = new URLSearchParams();
               cartIdxList.forEach(id => {
                   formData.append('cartIdxList', id); // 동일한 key로 여러 번 append
               });

               fetch("${pageContext.request.contextPath}/product/cartSelectedDelete", {
                   method: 'POST',
                   body: formData
               })
               .then(response => response.json())
               .then(data => {
                   if (data.status === 'success') {
                       alert("선택하신 상품이 삭제되었습니다.");
                       window.location.reload(); 
                   } else {
                       alert("삭제 실패: " + data.message);
                   }
               })
               .catch(error => console.error('Error:', error));
           }
            
        });
    }

    // 4. 개별 삭제 버튼 (btn-delete-item) 클릭 이벤트 (핵심 수정 부분)
    // 요소를 다시 한 번 명확하게 가져옵니다.
    const deleteItems = document.querySelectorAll('.btn-delete-item');
    
    deleteItems.forEach(deleteItem => {
        deleteItem.addEventListener('click', function(event){
            
            event.preventDefault(); // 버튼의 기본 동작(폼 제출 등) 방지
            event.stopPropagation(); // 이벤트가 부모 요소로 전파되는 것 방지 (가장 유력한 문제 해결책)

            var cartIdx = this.getAttribute('data-cart-idx');
            alert("개별삭제 카트IDX = " + cartIdx);
            
            if(cartIdx){
                alert("카트 idx: " + cartIdx)
                
                const formData = new URLSearchParams();
                formData.append('cartIdx', cartIdx);
                
                fetch("${pageContext.request.contextPath}/product/cartDelete",{
                    method: 'POST',
                    body: formData
                })
                // 💡 1. 응답을 JSON으로 파싱합니다.
                .then(response => {
                    if(!response.ok) {
                        // 서버에서 200 응답을 받지 못한 경우
                        throw new Error ("네트워크 오류 또는 서버 응답 실패: " + response.status);
                    }
                    return response.json();
                })
                // 💡 2. 서버에서 보낸 JSON 데이터를 처리합니다.
                .then(data => {
                    if (data.status === 'success') {
                        alert("개별상품을 삭제했습니다.");
                    } else if (data.status === 'required_login') {
                        alert("로그인이 필요합니다.");
                    } else {
                        // status: error 인 경우
                        alert("개별상품 삭제 실패: " + data.message);
                    }
                    
                    // 💡 3. JSON에 담긴 URL로 페이지 이동
                    if (data.redirectUrl) {
                        window.location.href = data.redirectUrl; 
                    } else {
                        // 성공적으로 삭제했으나 리다이렉트 URL이 없으면 현재 페이지를 새로고침하여 목록 갱신
                        window.location.reload(); 
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    alert("개별상품 삭제 중 통신 오류 또는 실패.");
                });
                
            } else {
                alert("cart_idx를 찾을 수 없습니다.");
            }
        });
    });
    
    // TODO: checkAll, 개별 체크박스 변경 시 총 금액을 재계산하는 calculateTotal() 함수 구현
    // function calculateTotal() { /* ... */ }
});
</script>

</head>
<body>
	<div id = "wrap">
		<jsp:include page="header.jsp"></jsp:include>
		
		<main id="content">
			<%-- 장바구니 페이지 제목 --%>
			<div class="cart-header" style="text-align: center; padding: 40px 0;">
			    <h2>장바구니</h2>
			</div>
			
			<%-- 장바구니 본문 영역 --%>
			<div class="cart-container" style="max-width: 1000px; margin: 0 auto; padding: 20px;">
			    
			    <form id="cartForm" action="/product/cart" method="post">
			        
			        <%-- 전체 선택/해제 및 상단 정보 --%>
			        <div class="cart-summary" style="border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
			            <label>
			                <input type="checkbox" id="checkAll" checked> 전체 선택 (<span id="checkedCount">0</span>/<span id="totalCount">0</span>)
			            </label>
			            <button type="button"  class="btn-delete-selected" style="background: none; border: 1px solid #ccc; padding: 5px 10px; cursor: pointer;">선택 상품 삭제</button>
			        </div>
			
			        <%-- 상품 목록이 들어갈 영역 --%>
			        <div id="cartListArea">
			            <%-- 
			                여기에 JavaScript 또는 JSTL을 사용하여 
			                Mapper에서 가져온 CartDisplayVO 목록을 반복 출력합니다. 
			            --%>
			
			            <%-- 상품 목록 반복 예시 (JSTL 기준) --%>
			            <c:forEach var="item" items="${cartList}" varStatus="status">
			                <div class="cart-item" data-product-idx="${item.productIdx}"  style="display: flex; border-bottom: 1px solid #eee; padding: 15px 0; align-items: center;">
			                    
			                    <%-- 체크박스 --%>
			                    <div style="width: 5%; text-align: center;">
			                        <input type="checkbox" name="selectedProduct" value="${item.productIdx}" checked>
			                    </div>
			                    
			                    <%-- 상품 이미지 및 정보 --%>
			                    <div style="width: 60%; display: flex; align-items: center;">
			                        <img src="${item.img1}" alt="${item.productName}" style="width: 80px; height: 80px; object-fit: cover; margin-right: 15px;">
			                        <div>
			                            <p style="font-weight: bold; margin: 0;">${item.productName}</p>
			                            <a href="/productDetail?productIdx=${item.productIdx}" style="color: #666; font-size: 12px;">상세보기</a>
			                        </div>
			                    </div>
			                    
			                    <%-- 수량 변경 --%>
			                    <div style="width: 15%; text-align: center;">
			                        <input type="number" 
			                               name="quantity_${item.productIdx}" 
			                               value="${item.quantity}" 
			                               min="1" 
			                               class="item-quantity"
			                               data-product-idx="${item.productIdx}"
			                               style="width: 50px; text-align: center; padding: 5px;">
			                        <p style="font-size: 12px; margin-top: 5px;"><a href="#" class="btn-update-quantity" data-product-idx="${item.productIdx}">변경</a></p>
			                    </div>
			                    
			                    <%-- 가격 및 삭제 버튼 --%>
			                    <div style="width: 20%; text-align: right;">
			                        <p style="font-size: 16px; font-weight: bold;">
			                            <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,###원"/>
			                        </p>
			                        <button type="button" class="btn-delete-item" data-product-idx="${item.productIdx}" data-cart-idx ="${item.cartIdx}" style="background: none; border: none; color: #999; cursor: pointer; font-size: 12px; position: relative; z-index: 10;">X 삭제</button>
			                    </div>
			                </div>
			            </c:forEach>
			            
			            <%-- 장바구니가 비어있을 때 --%>
			            <c:if test="${empty cartList}">
			                <div style="text-align: center; padding: 50px; border: 1px dashed #ccc;">
			                    장바구니에 담긴 상품이 없습니다.
			                </div>
			            </c:if>
			            
			        </div>
			        
			        <%-- 총 주문 금액 요약 --%>
			        <div class="cart-total-box" style="margin-top: 40px; padding: 20px; border: 1px solid #ddd; background-color: #f9f9f9; text-align: right;">
			            <p style="font-size: 18px;">
			                총 상품 금액: <span id="totalProductPrice">100,000원</span> + 배송비: <span id="shippingFee">3,000원</span> = 
			                <span style="color: #d9534f; font-weight: bold; font-size: 24px;" id="finalTotalPrice">103,000원</span>
			            </p>
			        </div>
			
			        <%-- 주문하기 버튼 --%>
			        <div class="cart-action-final" style="text-align: center; margin-top: 30px;">
			            <button type="submit" class="btn-order" style="padding: 15px 40px; font-size: 18px; background-color: #333; color: white; border: none; cursor: pointer;">
			                선택 상품 주문하기
			            </button>
			        </div>
			    </form>
			</div>
		</main>
		<jsp:include page="footer.jsp"></jsp:include>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>