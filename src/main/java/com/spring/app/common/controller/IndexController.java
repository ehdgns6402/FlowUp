package com.spring.app.common.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.board.domain.PostVO;
import com.spring.app.board.service.BoardService;
import com.spring.app.document.domain.DocumentVO;
import com.spring.app.document.service.DocumentService;
import com.spring.app.employee.domain.EmployeeVO;
import com.spring.app.mail.domain.MailVO;
import com.spring.app.employee.service.EmployeeService;
import com.spring.app.mail.service.MailService;
import com.spring.app.schedule.service.ScheduleService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping(value="/*")
public class IndexController {

	@Autowired
	private EmployeeService EmService;
	
	
	@Autowired
	private MailService MaService;
	
	
	@Autowired
	private BoardService BoService;
	
	
	@Autowired
	private DocumentService doService;
	
	
	@Autowired
	private ScheduleService ScService;
	
	
	
	@GetMapping("/")
	public String main() {
		return "redirect:/index";
	}
	
	
	@GetMapping("index")
	public String index(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO)session.getAttribute("loginuser");
		
		String employeeno = loginuser.getEmployeeNo();
		
		List<Map<String, String>> ipMap = EmService.getIpAddr(employeeno); // 해당 유저의 ip 주소 갖고오기
		request.setAttribute("ipMap", ipMap);
		
		
		List<Map<String, String>> mailMap = MaService.getMailCnt(employeeno); // 해당 유저의 중요, 읽은, 임시저장함 개수 알아오기
		request.setAttribute("mailMap", mailMap);
		
		
		Map<String, Integer> documentMap = doService.getDocCnt(employeeno); // 해당 유저의 결재대기문서, 결재예정문서, 기안문서, 임시저장문서 개수 알아오기
		request.setAttribute("documentMap", documentMap);
		
		
		return "mycontent/main/index";
	}
	
	
	
	
	@GetMapping("searchMail")
	@ResponseBody
	public List<MailVO> searchMail(@RequestParam String searchWord) {
		
		List<MailVO> searchMailList = MaService.searchMail(searchWord); // 이메일 검색

		return searchMailList;
	}
	
	
	
	
	@GetMapping("searchBoard")
	@ResponseBody
	public List<PostVO> searchBoard(@RequestParam String searchWord) {
		
		List<PostVO> searchBoardList = BoService.searchBoard(searchWord); // 게시판 검색

		return searchBoardList;
	}
	
	
	
	
	
	@GetMapping("searchDocument")
	@ResponseBody
	public List<DocumentVO> searchDocument(HttpServletRequest request, @RequestParam String searchWord) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO)session.getAttribute("loginuser");
		String employeeno = loginuser.getEmployeeNo();
		
		Map<String, String> hashMap = new HashMap<>();
		
		hashMap.put("employeeno", employeeno);
		hashMap.put("searchWord", searchWord);
		
		List<DocumentVO> searchDocumentList = doService.searchDocument(hashMap); // 전자결재 통합검색 메인

		return searchDocumentList;
	}
	
	
	
	
	@GetMapping("searchCalendar")
	@ResponseBody
	public List<Map<String, String>> searchCalendar(HttpServletRequest request, @RequestParam String searchWord) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO)session.getAttribute("loginuser");
		String employeeno = loginuser.getEmployeeNo();
		
		Map<String, String> hashMap = new HashMap<>();
		
		hashMap.put("employeeno", employeeno);
		hashMap.put("searchWord", searchWord);
		
		List<Map<String, String>> searchCalendarList = ScService.searchCalendar(hashMap); // 캘린더 검색

		return searchCalendarList;
	}
	
	
	
	
}
