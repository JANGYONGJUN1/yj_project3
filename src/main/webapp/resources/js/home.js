	document.addEventListener('DOMContentLoaded', function() {
	
	    const parentBtn = document.querySelector('.category-btn');
	    const allButton = document.querySelectorAll(".category-btn .btn");
		
		//카테고리 버튼 클릭시
	    parentBtn.addEventListener('click', function(event){
	
	        event.preventDefault();
	
	        if (event.target.tagName !== 'A') return;
	
	        allButton.forEach(btn => {
	            btn.classList.remove('btn-primary');
	            btn.classList.add('btn-secondary');
	        });
	
	        event.target.classList.remove('btn-secondary');
	        event.target.classList.add('btn-primary');
	
	        const categoryId = event.target.dataset.category;
	        
	        console.log('선택된 카테고리 ID : ' + categoryId);
	
	        fetchProductByCategory(categoryId);
	    });
	    
	    
	    //searchBtn 클릭시
	    const searchBtn = document.getElementById("searchBtn");
	    const searchInput = document.getElementById("search");
	    
	    searchBtn.addEventListener('click', function(e){  
	    	e.preventDefault();
	    
	    	// e.preventDefault(), (e) console.log 확인하기 위함 제출(submit)로 인한 페이지 새로고침 막음
		    const searchValue = searchInput.value;
	    	
	    	alert(searchValue);	
	    	
	    	fetchKeyword(searchValue);
	    	
	    	searchInput.value = "";
	    	searchInput.focus();
	    	
	    });
	    
	});


	function fetchProductByCategory(categoryId){
	
		//header.jsp에 ctx선언
		
		const url = ctx + "/product/list?category=" + categoryId;
		
		fetch(url)
	        .then(response => {
	            if(!response.ok) {
	                throw new Error('네트워크 응답 오류: ' + response.statusText);
	            }
	            return response.json();
	        })
	        .then(data => {
	            console.log("서버에서 받은 상품 데이터:", data);
	            updateProductList(data);
	        })
	        .catch(error => {
	            console.error('상품 목록 Ajax 요청 중 오류 발생: ', error);
	        });
	}

    
	//상품 검색 ajax
	function fetchKeyword(keyword){
	
		//header.jsp에 ctx선언
		
		const url = ctx + "/product/list?keyword=" + keyword;
		
	    fetch(url)
	        .then(response => {
	            if(!response.ok) {
	                throw new Error('네트워크 응답 오류: ' + response.statusText);
	            }
	            return response.json();
	        })
	        .then(data => {
	            console.log("서버에서 받은 상품 데이터:", data);
	            updateProductList(data);
	        })
	        .catch(error => {
	            console.error('검색상품 목록 Ajax 요청 중 오류 발생: ', error);
	        });
	}

	// 검색 및 카테고리에 해당되는 상품 list를 출력
	function updateProductList(products) {
		console.log(">>>>>>" + products);
		
	    const productContainer = document.querySelector('.row.row-cols-1.row-cols-sm-2.row-cols-md-4');
	
	    productContainer.innerHTML = ''; 
	
	    products.forEach(item => {
	
	        const html = `
	            <div class="col">
	                <div class="card" style="width: 18rem;">
	                    <img src="${item.img1}" class="card-img-top" alt="상품이미지">
	                    <div class="card-body">
	                        <h5 class="card-title">${item.productName}</h5>
	                        <p class="card-text">${item.content}</p>
	                        <div class="d-flex justify-content-between align-items-center">
	                            <div class="btn-group">
	                                <button type="button" class="btn btn-sm btn-outline-secondary">상세보기</button>
	                                <button type="button" class="btn btn-sm btn-outline-secondary">장바구니 담기</button>
	                            </div>
	                            <small class="text-body-secondary">${item.views}</small>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        `;
	
	        productContainer.insertAdjacentHTML('beforeend', html);
    });
}
