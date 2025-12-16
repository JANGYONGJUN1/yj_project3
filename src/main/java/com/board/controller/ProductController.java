package com.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.board.service.BoardService;
import com.board.vo.ProductCartListVO;
import com.board.vo.ProductVO;
import com.board.vo.ReviewsVO;


@Controller
public class ProductController {
	
	private static final Logger logger = LoggerFactory.getLogger(ProductController.class);
	private final BoardService productService;
	// 생성자 주입
	@Autowired
	public ProductController(BoardService productService) {this.productService = productService;}
	
	@RequestMapping(value="/productDetail")
	public String detail(Model model,
			@RequestParam("productIdx") int productIdx, 
			@RequestParam(value = "sort", defaultValue ="latest") String sortType) {
		
		System.out.println("상품 디테일 컨트롤러 진입 ------------------");
		
		ProductVO product = productService.productDetail(productIdx);
		ArrayList<ReviewsVO> review = productService.getReview(productIdx, sortType);
		int getCountReview = productService.getCountReview(productIdx);
		
		model.addAttribute("product", product);
		model.addAttribute("reviewList", review);
		model.addAttribute("countReview", getCountReview);
		model.addAttribute("sortType", sortType);
		
		System.out.println(">>>>>>>> reviewList: " + review);
		
		System.out.println("상품 상세 조회 ID: " + productIdx);
		
		return "productDetailPage";
	}
	
	// 조건별 리뷰 정렬
	@GetMapping(value="/review/list")
	@ResponseBody
	public List<ReviewsVO> getReview (
			@RequestParam("productIdx") int productIdx,
			@RequestParam(value="sort", defaultValue="latest") String sortType){
		
		System.out.println("리뷰 컨트롤러 입성 ");
		return productService.getReview(productIdx, sortType);
	}
	
	@GetMapping(value="/product/cartList") 
	public String getCartList (Model model, HttpSession session) {
		System.out.println("장바구니 리스트 진입 ");
		
		Object sessionObject = session.getAttribute("loginUser");
		
		Integer userIdx = null;
		
		if(sessionObject instanceof com.board.vo.SessionUserDTO) {
			com.board.vo.SessionUserDTO sessionUser = (com.board.vo.SessionUserDTO) sessionObject;
			userIdx = sessionUser.getUserIdx();
			System.out.println("cart리스트 컨트롤러 userIdx: " + userIdx);
		}
		
		if(userIdx == null) {
			return "redirect:/signIn";
		}
		
		ArrayList<ProductCartListVO> cartList = productService.productCartList(userIdx);
		model.addAttribute("cartList", cartList);
		
		return "productCartListPage";
	}
	
	@PostMapping(value="/product/saveCart")
	@ResponseBody
	public Map<String, String>  saveCart(@RequestParam("productIdx") int productIdx,
							@RequestParam("quantity") int quantity, HttpSession session) {
			
		System.out.println("장바구니인설트 컨트롤러 진입 ");
		
		Object sessionObject = session.getAttribute("loginUser");
		Integer userIdx = null;

		
		System.out.println("--- saveCart 진입 ---");
	    System.out.println("ProductIdx: " + productIdx + ", Quantity: " + quantity);
	    System.out.println("Session ID: " + session.getId());
	    System.out.println("Session loginUser Object: " + sessionObject); 
		
		
		if(sessionObject instanceof com.board.vo.SessionUserDTO) {
			com.board.vo.SessionUserDTO sessionUser = (com.board.vo.SessionUserDTO) sessionObject;
			userIdx = sessionUser.getUserIdx();
		}
		
		Map<String, String> response = new HashMap<>();

		System.out.println("세션 userIdx 값: " + userIdx); 
		
		if(userIdx == null) {
			System.out.println("장바구니 saveCart: 로그인 loginUser이 유효하지 않음."); 
			
			response.put("status", "required_login");
			response.put("redirectUrl", session.getServletContext().getContextPath() + "/signIn");
	        return response; // 클라이언트에게 JSON 반환
		}
		try {
			productService.saveCart(userIdx, productIdx, quantity);
			System.out.println("장바구니 저장 성공");
			response.put("status", "success");
	        response.put("redirectUrl", session.getServletContext().getContextPath() + "/product/cartList");
		} catch(Exception e) {
			e.printStackTrace();
			System.out.println("catch????? (장바구니 저장 실패)");
			response.put("status", "error");
	        response.put("message", "장바구니 저장 중 오류 발생");
	        response.put("redirectUrl", session.getServletContext().getContextPath() + "/product/detail?productIdx=" + productIdx);
		}
		
		return response;
	}
	
	@PostMapping(value="/product/cartDelete")
	@ResponseBody
	public  Map<String, String> deleteCartItem(@RequestParam("cartIdx") int cartIdx,
								  HttpSession session) {
		
		Map<String, String> response = new HashMap<>();
		Object sessionObject = session.getAttribute("loginUser");
		Integer userIdx = null;
		
		
		if(sessionObject instanceof com.board.vo.SessionUserDTO) {
			com.board.vo.SessionUserDTO sessionUser = (com.board.vo.SessionUserDTO) sessionObject;
			userIdx = sessionUser.getUserIdx();
		}
		
		if(userIdx == null) {
			// 로그인 필요
			response.put("status", "required_login");
			response.put("redirectUrl", session.getServletContext().getContextPath() + "/signIn");
	        return response;
		}
		
		try {
	        System.out.println("개별 삭제 컨트롤러 실행! cartIdx: " + cartIdx + ", userIdx : " + userIdx);
	        productService.deleteCartItem(cartIdx, userIdx);
	        
	        response.put("status", "success");
	        response.put("message", "상품이 장바구니에서 삭제되었습니다.");
	        // 삭제 성공 후 리스트 페이지로 이동하도록 URL 반환
	        response.put("redirectUrl", session.getServletContext().getContextPath() + "/product/cartList"); 
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "장바구니 삭제 중 오류 발생");
	    }
	    
	    return response; // 💡 JSON 반환
		
	}
	
	@PostMapping(value="/product/cartSelectedDelete")
	@ResponseBody
	public  Map<String, String> cartSelectedDelete(@RequestParam("cartIdxList") List<Integer> cartIdxList,
								  HttpSession session) {
		
		Map<String, String> response = new HashMap<>();
		Object sessionObject = session.getAttribute("loginUser");
		Integer userIdx = null;
		
		
		if(sessionObject instanceof com.board.vo.SessionUserDTO) {
			com.board.vo.SessionUserDTO sessionUser = (com.board.vo.SessionUserDTO) sessionObject;
			userIdx = sessionUser.getUserIdx();
		}
		
		if(userIdx == null) {
			// 로그인 필요
			response.put("status", "required_login");
			response.put("redirectUrl", session.getServletContext().getContextPath() + "/signIn");
	        return response;
		}
		
		try {
	        System.out.println("장바구니 선택 삭제 컨트롤러 실행! cartIdx: " + cartIdxList + ", userIdx : " + userIdx);
	        productService.deleteSelectedCartItem(userIdx, cartIdxList);
	        
	        response.put("status", "success");
	        response.put("message", "선택 상품이 장바구니에서 삭제되었습니다.");
	        // 삭제 성공 후 리스트 페이지로 이동하도록 URL 반환
	        response.put("redirectUrl", session.getServletContext().getContextPath() + "/product/cartList"); 
	        
	    } catch(Exception e) {
	        e.printStackTrace();
	        response.put("status", "error");
	        response.put("message", "장바구니 삭제 중 오류 발생");
	    }
	    
	    return response; // 💡 JSON 반환
		
	}
	
	
}
