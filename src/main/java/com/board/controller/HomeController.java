package com.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.board.service.BoardService;
import com.board.service.KakaoService;
import com.board.service.MemberService;
import com.board.vo.MemberVO;
import com.board.vo.ProductVO;
import com.board.vo.SessionUserDTO;

@Controller
public class HomeController {
	
	@Value("${kakao.client_id}")
	private String clientId;
	
	@Value("${kakao.redirect_uri}")
	private String redirectUri;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	private final KakaoService kakaoService;
	private final BoardService boardService;
	private final MemberService memberService;
	
	// 생성자 주입
	@Autowired
	public HomeController(BoardService boardService, KakaoService kakaoService, MemberService memberService) {
		this.boardService = boardService; 
		this.kakaoService = kakaoService; 
		this.memberService = memberService; 
	}
	@Autowired
	private JavaMailSender mailSender;
	
	
	
	@RequestMapping(value = "/")
	public String home(Model model) {
		System.out.println(" >>>>   컨트롤러 진입 ------------------------------");
		
		ArrayList <ProductVO>  list =  boardService.productAllList(null);	// null: 전체조회, 카테고리별 조회: 1,2,3
		model.addAttribute("productList", list);
		
		return "home";
	}
	
	// AJax 요청 처리 및 json 데이터 반환을 위한 메서드
	@RequestMapping(value = "/product/list", method = RequestMethod.GET)
	@ResponseBody	// 이 어노테이션이 객체(List<ProductVO>)를 JSON으로 변환하여 반환합니다.
	public List<ProductVO> productListAjax(
		@RequestParam(value = "category", required = false) Integer categoryId,  
		@RequestParam(value = "keyword", required = false) String keyword) {
		
		logger.info(">>>>>>> AJAX 진입 - 카테고리: {}, 검색어: {}", categoryId, keyword);
		
		Integer serviceParam = (categoryId != null && categoryId == 0) ? null : categoryId;
		
		// 전체 or 카테고리별 상품 조회
		ArrayList<ProductVO> list = null;
		
		try {
			
			if(keyword != null && !keyword.trim().isEmpty()) {
				
				Map<String, Object> params = new HashMap<>();
				params.put("categoryId", serviceParam);
				params.put("keyword", keyword);
				
				list = boardService.productSearchList(params);
				
				
			} else {
				// 검색어가 없는경우 전체 목록조회 null => 전체
				list = boardService.productAllList(serviceParam);
			}
		} catch (Exception e) {
			
	        logger.error("상품 검색 중 예외 발생. 기본 목록으로 대체합니다.", e);
	        
	        list = boardService.productAllList(serviceParam);
		}
		
		return list;
		
	};
	
	// 로그인 페이지 이동
	@RequestMapping(value = "/signInPage", method = RequestMethod.GET)
	public String signInPage() {
		System.out.println(" >>>>   로그인페이지 진입");
		
		return "signInPage";
	}
	
	// 로그인
	@PostMapping(value = "/signIn")
	public String signIn(String memberId, String password, HttpSession session) {
		System.out.println("로그인 컨트롤러 진입 ");
		
		MemberVO member = memberService.signIn(memberId, password);
		
		if(member != null) {
			
			SessionUserDTO loginUser = new SessionUserDTO();
			
			//jsp에 표시할 이름
			loginUser.setLoginName(member.getName());
			loginUser.setUserId(member.getMemberId());
			loginUser.setUserIdx(member.getUserIdx());
			// 일반로그인 타입 설정
			loginUser.setLoginType("GENERAL");
			
			session.setAttribute("loginUser", loginUser);
			System.out.println("로그인 세션 진입");
			
			return "redirect:/";
		}
		
		return "signInPage";
	}
	
	//로그아웃
	@PostMapping(value= "/logout")
	public String logout(HttpSession session) {
		
		session.invalidate();
		
		return "redirect:/signInPage";
	}
	
	@RequestMapping(value = "/kakaoLogin", method = RequestMethod.GET)
	public String kakaoLogin(Locale locale) {
		System.out.println(" >>>>   카카오로그인 진입");
		
		System.out.println("DEBUG: Client ID (주입됨): " + clientId);
        System.out.println("DEBUG: Redirect URI (주입됨): " + redirectUri);
        
		String location = "https://kauth.kakao.com/oauth/authorize?response_type=code&client_id="+clientId+"&redirect_uri="+redirectUri;
        
		return "redirect:" + location;
	}
	
	
	@RequestMapping(value = "/kakaoLogout", method = RequestMethod.POST)
	public String kakaoLogout(HttpSession session) {
		System.out.println(" >>>>   카카오로그아웃 진입");
		
		// 1. 세션에서 Access Token을 가져옵니다.
		String accessToken = (String) session.getAttribute("kakaoAccessToken");
		
		if(accessToken != null) {
			try {
				// 2. 카카오 서버에 토큰 무효화 요청 (우리 서버 -> 카카오 서버)
                // 이 호출은 카카오 인증 상태를 끊어 다음 로그인 시 ID/PW 창이 나오게 합니다.
                kakaoService.kakaoLogout(accessToken); 
			} catch(Exception e) {
				System.out.println("카카오 API 로그아웃 실패 : " + e.getMessage());
			}finally {
				// 3. ⭐️ [필수] 로컬 세션 무효화 (우리 서비스의 로그인 상태 끊기) ⭐️
                // 카카오 로그아웃 성공 여부와 관계없이 우리 서비스의 세션은 끊어야 합니다.
                session.invalidate(); 
                System.out.println("로컬 세션 무효화 완료.");
                
			}
		} else {
			 System.out.println("세션에 토큰이 없음. 로컬 세션 무효화 진행.");
             session.invalidate(); 
		}
		
		String kakaoLogoutRedirect = "https://kauth.kakao.com/oauth/logout?client_id=" + clientId + "&logout_redirect_uri=http://localhost:8085/signInPage";
		return "redirect:" + kakaoLogoutRedirect; 
		
		
	}
	
	@RequestMapping(value = "/signUpPage", method = RequestMethod.GET)
	public String signUp(Locale locale, Model model) {
		System.out.println(" >>>>   회원가입 진입");
		
		model.addAttribute("msg", "Hello Spring MVC!");
		
		return "signUpPage";
	}
	
	//이메일 인증
	@RequestMapping(value="/mailCheck", method=RequestMethod.GET)
	@ResponseBody
	public String mailCheck(String email) throws Exception{
		logger.info("이메일 데이터 전송 확인");
		logger.info("인증번호: " + email);
		
		// 인증번호 난수 발생
		Random random = new Random();
		int checkNum = random.nextInt(900000) + 100000;
		logger.info("인증번호: " + checkNum);
		
		String setFrom = "dydwns5114@naver.com";
		String toMail = email;
		String title = "회원가입 인증 이메일 입니다";
		String content =
				"홈페이지를 방문해 주셔서 감사합니다" + 
				"<br><br>" +
				"인증번호는 " + checkNum + "입니다" + 
				"<br>" + 
				"해당 인증번호를 인증번호 확인란에 기입하여 주세요.";
		
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "utf-8");
			helper.setFrom(setFrom);
			helper.setTo(toMail);
			helper.setSubject(title);
			helper.setText(content, true);
			mailSender.send(message);
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		String num = Integer.toString(checkNum);
		
		return num;
	}
	
	@RequestMapping(value ="/signUp")
	public String signUp(MemberVO mVO) throws Exception {
		memberService.signUp(mVO);
		
		return "redirect:/signInPage";
	}
	
}
