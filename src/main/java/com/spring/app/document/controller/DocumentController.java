package com.spring.app.document.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.MyUtil;
import com.spring.app.document.domain.ApprovalVO;
import com.spring.app.document.domain.DocumentVO;
import com.spring.app.document.service.DocumentService;
import com.spring.app.employee.domain.DepartmentVO;
import com.spring.app.employee.domain.EmployeeVO;
import com.spring.app.employee.domain.TeamVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;


// === 컨트롤러 선언 === //
@Controller
@RequestMapping(value="/document/*")
public class DocumentController {
	
	@Autowired // Type 에 따라 알아서 Bean 을 주입해준다.
	private DocumentService service;
	
	// 전자결재 메인 페이지
	@GetMapping("")
	public ModelAndView document(ModelAndView mav, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		List<DocumentVO> todoList = service.mainTodoList(employeeNo);			// 결재 대기 문서 5개 가져오기
		List<DocumentVO> progressList = service.mainProgressList(employeeNo);	// 기안 진행 문서 5개 가져오기
		List<DocumentVO> completedList = service.mainCompletedList(employeeNo);	// 기안 완료 문서 5개 가져오기
		
		mav.addObject("todoList", todoList);
		mav.addObject("progressList", progressList);
		mav.addObject("completedList", completedList);
		mav.setViewName("mycontent/document/document");
		
		return mav;
	}
	
	
	// 좌측 사이드 바에 넣어줄 결제 예정 문서의 갯수와 결제 대기 문서의 갯수 가져오기
	@GetMapping("getDocCount")
	@ResponseBody
	public Map<String, Integer> getDocCount(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		Map<String, Integer> countList = new HashMap<>();
		
		int todoCount = service.todoList(employeeNo).size();			// 결재 대기 문서 수
		int upcomingCount = service.upcomingList(employeeNo).size();	// 결제 예정 문서 수
		
		countList.put("todoCount", todoCount);
		countList.put("upcomingCount", upcomingCount);
		
		return countList;
	}
	
	
	// 결재대기문서함
	@GetMapping("todoList")
	public ModelAndView todoList(ModelAndView mav, HttpServletRequest request
							   , @RequestParam(defaultValue = "10") String sizePerPage
							   , @RequestParam(defaultValue = "") String searchWord
							   , @RequestParam(defaultValue = "1") String currentShowPageNo
							   , @RequestParam(defaultValue = "") String documentType) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		searchWord = searchWord.trim(); // 검색어 공백 제거
		
		int n_currentShowPageNo = 1;	// 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함
		
		Map<String, String> paraMap = new HashMap<>();
		
		// select 에 필요한 사원번호
		paraMap.put("employeeNo", employeeNo);
		
		// === 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 === //
		paraMap.put("searchWord", searchWord);
		
		paraMap.put("documentType", documentType); // 결재양식
		
		
		// 결재 대기 문서함에서 검색어를 포함한 문서 갯수 가져오기
		int totalCount = service.todoListCount_Search(paraMap);
		
		// 한 페이지에 보여줄 문서 갯수
		int pageSize = Integer.parseInt(sizePerPage);
		
		// 총 페이지수
		int totalPage = (int)Math.ceil((double)totalCount/pageSize);
		
		try {
			// 비정상적 접근 시
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				n_currentShowPageNo = 1;
			}
			
		} catch (NumberFormatException e) {
			// get 방식이므로 currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하거나
			// int 범위를 초과한 경우
			n_currentShowPageNo = 1;
		}
		
		
		// === 가져올 게시글의 범위 구하기 === //
		int startRno = ((n_currentShowPageNo - 1) * pageSize) + 1; // 시작 행 번호
		int endRno = startRno + pageSize - 1;  // 끝 행 번호
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		
		// 결재 대기 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
		List<DocumentVO> todoList = service.todoList_Search_Paging(paraMap);
		
		
		// === 페이지바 만들기 === //
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "todoList";
		
		// === [맨처음][이전] 만들기 === //
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=1&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i style='transform: scaleX(-1)' class='fa-solid fa-forward-step'></i></a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + (pageNo-1) + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-left'></i></a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == n_currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>" + pageNo + "</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} // end of while-----------------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-right'></i></a></li>";
		}
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + totalPage + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-forward-step'></i></a></li>";
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("searchWord", searchWord);				// 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 하기 위한 것
		mav.addObject("totalCount", totalCount);				// 페이징 처리시 총 문서 갯수
		mav.addObject("documentType", documentType);			// 페이징 처리시 결재 양식
		mav.addObject("currentShowPageNo", currentShowPageNo);	// 페이징 처리시 현재 페이지 번호
		mav.addObject("sizePerPage", sizePerPage);				// 페이징 처리시 한 페이지에 보여줄 문서 갯수
		
		mav.addObject("todoList", todoList);
		mav.setViewName("mycontent/document/todoList");
		
		return mav;
	}
	
	
	// 결재예정문서함
	@GetMapping("upcomingList")
	public ModelAndView upcomingList(ModelAndView mav, HttpServletRequest request
							   	   , @RequestParam(defaultValue = "10") String sizePerPage
							   	   , @RequestParam(defaultValue = "") String searchWord
							   	   , @RequestParam(defaultValue = "1") String currentShowPageNo
							   	   , @RequestParam(defaultValue = "") String documentType) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		searchWord = searchWord.trim(); // 검색어 공백 제거
		
		int n_currentShowPageNo = 1;	// 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함
		
		Map<String, String> paraMap = new HashMap<>();
		
		// select 에 필요한 사원번호
		paraMap.put("employeeNo", employeeNo);
		
		// === 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 === //
		paraMap.put("searchWord", searchWord);
		
		paraMap.put("documentType", documentType); // 결재양식
		
		
		// 결재 예정 문서함에서 검색어를 포함한 문서 갯수 가져오기
		int totalCount = service.upcomingListCount_Search(paraMap);
		
		// 한 페이지에 보여줄 문서 갯수
		int pageSize = Integer.parseInt(sizePerPage);
		
		// 총 페이지수
		int totalPage = (int)Math.ceil((double)totalCount/pageSize);
		
		try {
			// 비정상적 접근 시
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				n_currentShowPageNo = 1;
			}
			
		} catch (NumberFormatException e) {
			// get 방식이므로 currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하거나
			// int 범위를 초과한 경우
			n_currentShowPageNo = 1;
		}
		
		
		// === 가져올 게시글의 범위 구하기 === //
		int startRno = ((n_currentShowPageNo - 1) * pageSize) + 1; // 시작 행 번호
		int endRno = startRno + pageSize - 1;  // 끝 행 번호
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		
		// 결재 예정 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
		List<DocumentVO> upcomingList = service.upcomingList_Search_Paging(paraMap);
		
		
		// === 페이지바 만들기 === //
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "upcomingList";
		
		// === [맨처음][이전] 만들기 === //
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=1&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i style='transform: scaleX(-1)' class='fa-solid fa-forward-step'></i></a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + (pageNo-1) + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-left'></i></a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == n_currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>" + pageNo + "</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} // end of while-----------------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-right'></i></a></li>";
		}
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + totalPage + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-forward-step'></i></a></li>";
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("searchWord", searchWord);				// 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 하기 위한 것
		mav.addObject("totalCount", totalCount);				// 페이징 처리시 총 문서 갯수
		mav.addObject("documentType", documentType);			// 페이징 처리시 결재 양식
		mav.addObject("currentShowPageNo", currentShowPageNo);	// 페이징 처리시 현재 페이지 번호
		mav.addObject("sizePerPage", sizePerPage);				// 페이징 처리시 한 페이지에 보여줄 문서 갯수
		
		mav.addObject("upcomingList", upcomingList);
		mav.setViewName("mycontent/document/upcomingList");
		
		return mav;
	}
		
	
	// 기안 문서함
	@GetMapping("myDocumentList")
	public ModelAndView myDocumentList(ModelAndView mav, HttpServletRequest request
									 , @RequestParam(defaultValue = "10") String sizePerPage
									 , @RequestParam(defaultValue = "") String searchWord
									 , @RequestParam(defaultValue = "1") String currentShowPageNo
									 , @RequestParam(defaultValue = "") String approvalStatus
									 , @RequestParam(defaultValue = "") String documentType) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		searchWord = searchWord.trim(); // 검색어 공백 제거
		
		int n_currentShowPageNo = 1;	// 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함
		
		Map<String, String> paraMap = new HashMap<>();
		
		// select 에 필요한 사원번호
		paraMap.put("employeeNo", employeeNo);
		
		// === 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 === //
		paraMap.put("searchWord", searchWord);
		
		paraMap.put("status", approvalStatus); // 결재상태
		paraMap.put("documentType", documentType); // 결재양식
		
		
		// 기안 문서함에서 검색어를 포함한 문서 갯수 가져오기
		int totalCount = service.myDocumentListCount_Search(paraMap);
		
		// 한 페이지에 보여줄 문서 갯수
		int pageSize = Integer.parseInt(sizePerPage);
		
		// 총 페이지수
		int totalPage = (int)Math.ceil((double)totalCount/pageSize);
		
		try {
			// 비정상적 접근 시
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				n_currentShowPageNo = 1;
			}
			
		} catch (NumberFormatException e) {
			// get 방식이므로 currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하거나
			// int 범위를 초과한 경우
			n_currentShowPageNo = 1;
		}
		
		
		// === 가져올 게시글의 범위 구하기 === //
		int startRno = ((n_currentShowPageNo - 1) * pageSize) + 1; // 시작 행 번호
		int endRno = startRno + pageSize - 1;  // 끝 행 번호
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		
		// 기안 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
		List<DocumentVO> myDocumentList = service.myDocumentList_Search_Paging(paraMap);
		
		
		// === 페이지바 만들기 === //
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "myDocumentList";
		
		// === [맨처음][이전] 만들기 === //
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=1&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i style='transform: scaleX(-1)' class='fa-solid fa-forward-step'></i></a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + (pageNo-1) + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-left'></i></a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == n_currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>" + pageNo + "</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} // end of while-----------------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-right'></i></a></li>";
		}
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + totalPage + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-forward-step'></i></a></li>";
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("searchWord", searchWord);				// 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 하기 위한 것
		mav.addObject("totalCount", totalCount);				// 페이징 처리시 총 문서 갯수
		mav.addObject("status", approvalStatus);				// 페이징 처리시 결재 상태
		mav.addObject("documentType", documentType);			// 페이징 처리시 결재 양식
		mav.addObject("currentShowPageNo", currentShowPageNo);	// 페이징 처리시 현재 페이지 번호
		mav.addObject("sizePerPage", sizePerPage);				// 페이징 처리시 한 페이지에 보여줄 문서 갯수
		
		mav.addObject("myDocumentList", myDocumentList);
		mav.setViewName("mycontent/document/myDocumentList");
		
		return mav;
	}
	
	
	// 임시저장함
	@GetMapping("tempList")
	public ModelAndView tempList(ModelAndView mav, HttpServletRequest request
							   , @RequestParam(defaultValue = "10") String sizePerPage
							   , @RequestParam(defaultValue = "") String searchWord
							   , @RequestParam(defaultValue = "1") String currentShowPageNo
							   , @RequestParam(defaultValue = "") String documentType) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		searchWord = searchWord.trim(); // 검색어 공백 제거
		
		int n_currentShowPageNo = 1;	// 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함
		
		Map<String, String> paraMap = new HashMap<>();
		
		// select 에 필요한 사원번호
		paraMap.put("employeeNo", employeeNo);
		
		// === 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 === //
		paraMap.put("searchWord", searchWord);
		
		paraMap.put("documentType", documentType); // 결재양식
		
		
		// 임시 저장 문서함에서 검색어를 포함한 문서 갯수 가져오기
		int totalCount = service.tempListCount_Search(paraMap);
		
		// 한 페이지에 보여줄 문서 갯수
		int pageSize = Integer.parseInt(sizePerPage);
		
		// 총 페이지수
		int totalPage = (int)Math.ceil((double)totalCount/pageSize);
		
		try {
			// 비정상적 접근 시
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				n_currentShowPageNo = 1;
			}
			
		} catch (NumberFormatException e) {
			// get 방식이므로 currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하거나
			// int 범위를 초과한 경우
			n_currentShowPageNo = 1;
		}
		
		
		// === 가져올 게시글의 범위 구하기 === //
		int startRno = ((n_currentShowPageNo - 1) * pageSize) + 1; // 시작 행 번호
		int endRno = startRno + pageSize - 1;  // 끝 행 번호
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		
		// 임시 저장 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
		List<DocumentVO> tempList = service.tempList_Search_Paging(paraMap);
		
		
		// === 페이지바 만들기 === //
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "tempList";
		
		// === [맨처음][이전] 만들기 === //
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=1&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i style='transform: scaleX(-1)' class='fa-solid fa-forward-step'></i></a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + (pageNo-1) + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-left'></i></a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == n_currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>" + pageNo + "</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} // end of while-----------------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-right'></i></a></li>";
		}
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + totalPage + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&documentType=" + documentType + "'><i class='fa-solid fa-forward-step'></i></a></li>";
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("searchWord", searchWord);				// 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 하기 위한 것
		mav.addObject("totalCount", totalCount);				// 페이징 처리시 총 문서 갯수
		mav.addObject("documentType", documentType);			// 페이징 처리시 결재 양식
		mav.addObject("currentShowPageNo", currentShowPageNo);	// 페이징 처리시 현재 페이지 번호
		mav.addObject("sizePerPage", sizePerPage);				// 페이징 처리시 한 페이지에 보여줄 문서 갯수
		
		mav.addObject("tempList", tempList);
		mav.setViewName("mycontent/document/tempList");
		
		return mav;
	}
	
	
	// 결재 문서함
	@GetMapping("approvedList")
	public ModelAndView approvedList(ModelAndView mav, HttpServletRequest request
									 , @RequestParam(defaultValue = "10") String sizePerPage
									 , @RequestParam(defaultValue = "") String searchWord
									 , @RequestParam(defaultValue = "1") String currentShowPageNo
									 , @RequestParam(defaultValue = "") String approvalStatus
									 , @RequestParam(defaultValue = "") String documentType) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		searchWord = searchWord.trim(); // 검색어 공백 제거
		
		int n_currentShowPageNo = 1;	// 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함
		
		Map<String, String> paraMap = new HashMap<>();
		
		// select 에 필요한 사원번호
		paraMap.put("employeeNo", employeeNo);
		
		// === 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 === //
		paraMap.put("searchWord", searchWord);
		
		paraMap.put("status", approvalStatus); // 결재상태
		paraMap.put("documentType", documentType); // 결재양식
		
		
		// 결재 문서함에서 검색어를 포함한 문서 갯수 가져오기
		int totalCount = service.approvedtListCount_Search(paraMap);
		
		// 한 페이지에 보여줄 문서 갯수
		int pageSize = Integer.parseInt(sizePerPage);
		
		// 총 페이지수
		int totalPage = (int)Math.ceil((double)totalCount/pageSize);
		
		try {
			// 비정상적 접근 시
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				n_currentShowPageNo = 1;
			}
			
		} catch (NumberFormatException e) {
			// get 방식이므로 currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하거나
			// int 범위를 초과한 경우
			n_currentShowPageNo = 1;
		}
		
		
		// === 가져올 게시글의 범위 구하기 === //
		int startRno = ((n_currentShowPageNo - 1) * pageSize) + 1; // 시작 행 번호
		int endRno = startRno + pageSize - 1;  // 끝 행 번호
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		
		// 결재 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
		List<DocumentVO> approvedList = service.approvedList_Search_Paging(paraMap);
		
		
		// === 페이지바 만들기 === //
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "approvedList";
		
		// === [맨처음][이전] 만들기 === //
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=1&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i style='transform: scaleX(-1)' class='fa-solid fa-forward-step'></i></a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + (pageNo-1) + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-left'></i></a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == n_currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>" + pageNo + "</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} // end of while-----------------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-right'></i></a></li>";
		}
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + totalPage + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-forward-step'></i></a></li>";
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("searchWord", searchWord);				// 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 하기 위한 것
		mav.addObject("totalCount", totalCount);				// 페이징 처리시 총 문서 갯수
		mav.addObject("status", approvalStatus);				// 페이징 처리시 결재 상태
		mav.addObject("documentType", documentType);			// 페이징 처리시 결재 양식
		mav.addObject("currentShowPageNo", currentShowPageNo);	// 페이징 처리시 현재 페이지 번호
		mav.addObject("sizePerPage", sizePerPage);				// 페이징 처리시 한 페이지에 보여줄 문서 갯수
		
		mav.addObject("approvedList", approvedList);
		mav.setViewName("mycontent/document/approvedList");
		
		return mav;
	}	
	
	
	// 부서 문서함
	@GetMapping("deptDocumentList")
	public ModelAndView deptDocumentList(ModelAndView mav, HttpServletRequest request
									   , @RequestParam(defaultValue = "10") String sizePerPage
									   , @RequestParam(defaultValue = "") String searchWord
									   , @RequestParam(defaultValue = "1") String currentShowPageNo
									   , @RequestParam(defaultValue = "") String approvalStatus
									   , @RequestParam(defaultValue = "") String documentType) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		searchWord = searchWord.trim(); // 검색어 공백 제거
		
		int n_currentShowPageNo = 1;	// 현재 보여주는 페이지 번호로서, 초기치로는 1페이지로 설정함
		
		Map<String, String> paraMap = new HashMap<>();
		
		// select 에 필요한 사원번호
		paraMap.put("employeeNo", employeeNo);
		
		// === 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 === //
		paraMap.put("searchWord", searchWord);
		
		paraMap.put("status", approvalStatus); // 결재상태
		paraMap.put("documentType", documentType); // 결재양식
		
		
		// 부서 문서함에서 검색어를 포함한 문서 갯수 가져오기
		int totalCount = service.deptDocumentListCount_Search(paraMap);
		
		// 한 페이지에 보여줄 문서 갯수
		int pageSize = Integer.parseInt(sizePerPage);
		
		// 총 페이지수
		int totalPage = (int)Math.ceil((double)totalCount/pageSize);
		
		try {
			// 비정상적 접근 시
			n_currentShowPageNo = Integer.parseInt(currentShowPageNo);
			
			if(n_currentShowPageNo < 1 || n_currentShowPageNo > totalPage) {
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 0 또는 음수를 입력하여 장난친 경우 
				// get 방식이므로 사용자가 currentShowPageNo 에 입력한 값이 실제 데이터베이스에 존재하는 페이지수 보다 더 큰값을 입력하여 장난친 경우
				n_currentShowPageNo = 1;
			}
			
		} catch (NumberFormatException e) {
			// get 방식이므로 currentShowPageNo 에 입력한 값이 숫자가 아닌 문자를 입력하거나
			// int 범위를 초과한 경우
			n_currentShowPageNo = 1;
		}
		
		
		// === 가져올 게시글의 범위 구하기 === //
		int startRno = ((n_currentShowPageNo - 1) * pageSize) + 1; // 시작 행 번호
		int endRno = startRno + pageSize - 1;  // 끝 행 번호
		
		paraMap.put("startRno", String.valueOf(startRno));
		paraMap.put("endRno", String.valueOf(endRno));
		
		
		// 부서 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
		List<DocumentVO> deptDocumentList = service.deptDocumentList_Search_Paging(paraMap);
		
		
		// === 페이지바 만들기 === //
		int blockSize = 10; // 1개 블럭(토막)당 보여지는 페이지번호의 개수이다.
		
		int loop = 1; // 1부터 증가하여 1개 블럭을 이루는 페이지번호의 개수[ 지금은 10개(== blockSize) ] 까지만 증가하는 용도이다.
		
		int pageNo = ((n_currentShowPageNo - 1)/blockSize) * blockSize + 1;
		
		String pageBar = "<ul style='list-style:none;'>";
		String url = "deptDocumentList";
		
		// === [맨처음][이전] 만들기 === //
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=1&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i style='transform: scaleX(-1)' class='fa-solid fa-forward-step'></i></a></li>";
		
		if(pageNo != 1) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + (pageNo-1) + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-left'></i></a></li>";
		}
		
		while( !(loop > blockSize || pageNo > totalPage) ) {
			
			if(pageNo == n_currentShowPageNo) {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt; border:solid 1px gray; color:red; padding:2px 4px;'>" + pageNo + "</li>";
			}
			else {
				pageBar += "<li style='display:inline-block; width:30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'>" + pageNo + "</a></li>";
			}
			
			loop++;
			pageNo++;
			
		} // end of while-----------------------------------
		
		// === [다음][마지막] 만들기 === //
		if(pageNo <= totalPage) {
			pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + pageNo + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-chevron-right'></i></a></li>";
		}
		pageBar += "<li style='display:inline-block; width: 30px; font-size:12pt;'><a href='" + url + "?currentShowPageNo=" + totalPage + "&sizePerPage=" + sizePerPage + "&searchWord=" + searchWord + "&approvalStatus=" + approvalStatus + "&documentType=" + documentType + "'><i class='fa-solid fa-forward-step'></i></a></li>";
		
		pageBar += "</ul>";
		
		mav.addObject("pageBar", pageBar);
		
		mav.addObject("searchWord", searchWord);				// 페이지를 이동하거나 sizePerPage 를 변경하더라도 검색어가 남아있도록 하기 위한 것
		mav.addObject("totalCount", totalCount);				// 페이징 처리시 총 문서 갯수
		mav.addObject("status", approvalStatus);				// 페이징 처리시 결재 상태
		mav.addObject("documentType", documentType);			// 페이징 처리시 결재 양식
		mav.addObject("currentShowPageNo", currentShowPageNo);	// 페이징 처리시 현재 페이지 번호
		mav.addObject("sizePerPage", sizePerPage);				// 페이징 처리시 한 페이지에 보여줄 문서 갯수
		
		mav.addObject("deptDocumentList", deptDocumentList);
		mav.setViewName("mycontent/document/deptDocumentList");
		
		return mav;
	}
	
	
	// 휴가신청서 페이지
	@GetMapping("annual")
	public ModelAndView annual(ModelAndView mav) {
		
		mav.addObject("documentType", "휴가신청서");
		mav.setViewName("mycontent/document/draftForm");
		
		return mav;
	}
	
	
	// 휴가신청서 잔여 연차 가져오기
	@GetMapping("annual/getAnnual") 
	@ResponseBody
	public String getAnnual(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		int totalAmount = service.getAnnual(employeeNo);
		
		JSONObject json = new JSONObject();
		json.put("totalAmount", totalAmount);
		
		return json.toString();
	}
	
	
	// 연장근무신청서 페이지
	@GetMapping("overtime")
	public ModelAndView overtime(ModelAndView mav) {
		
		mav.addObject("documentType", "연장근무신청서");
		mav.setViewName("mycontent/document/draftForm");
		
		return mav;
	}
	
	
	// 지출품의서 페이지
	@GetMapping("expense")
	public ModelAndView expense(ModelAndView mav) {
		
		mav.addObject("documentType", "지출품의서");
		mav.setViewName("mycontent/document/draftForm");
		
		return mav;
	}
	
	
	// 업무기안 페이지
	@GetMapping("business")
	public ModelAndView business(ModelAndView mav) {
		
		mav.addObject("documentType", "업무기안");
		mav.setViewName("mycontent/document/draftForm");
		
		return mav;
	}
	
	
	// 조직도에 뿌려주기 위한 부서 목록 가져오기
	@GetMapping("getDepartmentList")
	@ResponseBody
	public List<DepartmentVO> getDepartmentList(){
		
		List<DepartmentVO> departmentList = service.getDepartmentList();
		return departmentList;
		
	}
	
	
	// 조직도에 뿌려주기 위한 팀 목록 가져오기
	@GetMapping("getTeamList")
	@ResponseBody
	public List<TeamVO> getTeamList(){
		
		List<TeamVO> teamList = service.getTeamList();
		return teamList;
		
	}
	
	
	// 조직도에 뿌려주기 위한 사원 목록 가져오기
	@GetMapping("getEmployeeList")
	@ResponseBody
	public List<EmployeeVO> getEmployeeList(){
		
		List<EmployeeVO> employeeList = service.getEmployeeList();
		return employeeList;
		
	}
	
	
	// 결재 라인에 추가하기 위한 사원 1명 가져오기
	@GetMapping("getEmployeeOne")
	@ResponseBody
	public EmployeeVO getEmployeeOne(@RequestParam String employeeNo) {
		
		EmployeeVO employee = service.getEmployeeOne(employeeNo);
		return employee;
	}
	
	
	// 결재 요청
	@PostMapping("draft")
	@ResponseBody
	public Map<String, String> annualDraft(@RequestParam Map<String, String> paraMap, HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		if(loginuser != null) {
			paraMap.put("fk_employeeNo", loginuser.getEmployeeNo());
		}
		
		Map<String, String> map = service.draft(paraMap); // 결재 요청
		map.put("documentType", paraMap.get("documentType")); // 문서양식넣어주기
		
		return map;
	}
	
	
	// 임시저장하기
	@PostMapping("saveTemp")
	@ResponseBody
	public Map<String, String> saveTemp(@RequestParam Map<String, String> paraMap, HttpServletRequest request){
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		if(loginuser != null) {
			paraMap.put("fk_employeeNo", loginuser.getEmployeeNo());
		}
		
		paraMap.put("temp", "1"); // 임시 저장 문서임을 나타냄
		
		int n = 0;
		
		if("휴가신청서".equals(paraMap.get("documentType"))) {
			
			if("".equals(paraMap.get("startDate"))) {
				paraMap.put("startDate", "1111-11-11");
			}
			if("".equals(paraMap.get("endDate"))) {
				paraMap.put("endDate", "1111-11-11");
			}
			
		}
		else if("연장근무신청서".equals(paraMap.get("documentType"))) {
			
			if("".equals(paraMap.get("overtimeDate"))) {
				paraMap.put("overtimeDate", "1111-11-11");
			}
			
		}
		else if("업무기안".equals(paraMap.get("documentType"))) {
			
			if("".equals(paraMap.get("doDate"))) {
				paraMap.put("doDate", "1111-11-11");
			}
			if("".equals(paraMap.get("businessContent"))) {
				paraMap.put("businessContent", " ");
			}
		}
		
		Map<String, String> map = service.draft(paraMap); // 결재요청
		map.put("documentType", paraMap.get("documentType")); // 문서양식넣어주기
		
		return map;
	}
	
	
	// 문서함에서 문서 1개 보기
	@GetMapping("documentView")
	public ModelAndView documentView(HttpServletRequest request, ModelAndView mav, @RequestParam Map<String, String> paraMap) {
		
		String referer = request.getHeader("referer"); // 이전 페이지 URL
		
		if(referer == null) { // 직접 URL을 치고 들어온 경우
			mav.addObject("message", "비정상적인 접근입니다.");
			mav.addObject("loc", request.getContextPath()+"/document/");
			mav.setViewName("msg");
			return mav;
		}
		
		Map<String, String> document = service.documentView(paraMap);
		// 문서함에서 문서 1개 보여주기
		List<ApprovalVO> approvalList = service.getApprovalList(paraMap.get("documentNo"));
		// 문서함에서 보여줄 결재자 리스트 가져오기
		
		if("지출품의서".equals(paraMap.get("documentType"))) {
			List<Map<String, String>> expenseDetailList = service.expenseDetailList(paraMap);
			mav.addObject("expenseDetailList", expenseDetailList);
		}
		
		mav.addObject("document", document);
		mav.addObject("approvalList", approvalList);
		mav.setViewName("mycontent/document/documentView");
		
		return mav;
	}
	
	
	// 결재 승인하기
	@GetMapping("documentView/approve")
	@ResponseBody
	public String approve(HttpServletRequest request, @RequestParam String documentNo, @RequestParam String documentType) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		Map<String, String> map = new HashMap<>();
		
		map.put("documentNo", documentNo);
		map.put("documentType", documentType);
		map.put("employeeNo", employeeNo);
		
		int n = service.approve(map);
		
		JSONObject json = new JSONObject();
		
		json.put("n", n);
		
		return json.toString();
	}
	
	
	// 결재 반려하기
	@GetMapping("documentView/reject")
	@ResponseBody
	public String reject(HttpServletRequest request, @RequestParam String documentNo) {
		
		HttpSession session = request.getSession();
		EmployeeVO loginuser = (EmployeeVO) session.getAttribute("loginuser");
		
		String employeeNo = null;
		
		if(loginuser != null) {
			employeeNo = loginuser.getEmployeeNo();
		}
		
		Map<String, String> map = new HashMap<>();
		
		map.put("documentNo", documentNo);
		map.put("employeeNo", employeeNo);
		
		int n = service.reject(map);
		
		JSONObject json = new JSONObject();
		
		json.put("n", n);
		
		return json.toString();
	}
	
	
	// 임시저장 문서 수정하기
	@GetMapping("documentView/editTemp")
	public ModelAndView editTemp(HttpServletRequest request, ModelAndView mav, @RequestParam String documentNo, @RequestParam String documentType) {
		
		String referer = request.getHeader("referer"); // 이전 페이지 URL
		
		if(referer == null) { // 직접 URL을 치고 들어온 경우
			mav.addObject("message", "비정상적인 접근입니다.");
			mav.addObject("loc", request.getContextPath()+"/document/");
			mav.setViewName("msg");
			return mav;
		}
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("documentNo", documentNo);
		paraMap.put("documentType", documentType);
		
		Map<String, String> document = service.documentView(paraMap);
		// 문서함에서 문서 1개 보여주기
		List<ApprovalVO> approvalList = service.getApprovalList(paraMap.get("documentNo"));
		// 문서함에서 보여줄 결재자 리스트 가져오기
		
		if("지출품의서".equals(documentType)) {
			List<Map<String, String>> expenseDetailList = service.expenseDetailList(paraMap);
			mav.addObject("expenseDetailList", expenseDetailList);
		}
		
		mav.addObject("documentType", document.get("documentType"));
		mav.addObject("document", document);
		mav.addObject("approvalList", approvalList);
		
		mav.setViewName("mycontent/document/draftForm");
		
		return mav;
	}
	
	
	// 임시저장 문서 삭제하기
	@GetMapping("documentView/deleteTemp")
	@ResponseBody
	public String deleteTemp(@RequestParam String documentNo) {
		
		int n = service.deleteTemp(documentNo);
		
		JSONObject json = new JSONObject();
		json.put("n", n);
		
		return json.toString();
	}
	
	
	// 임시저장 문서 리스트 삭제하기
	@GetMapping("deleteTempList")
	@ResponseBody
	public String deleteTempList(@RequestParam("checked_arr") List<String> checked_list) {
		
		int n = service.deleteTempList(checked_list);
		
		JSONObject json = new JSONObject();
		json.put("n", n);
		
		return json.toString();
	}
	
	
	// html 파일 다운로드하기
	@GetMapping("documentView/download")
	@ResponseBody
	public String download(@RequestParam String para_url) {
		
		ArrayList<String> lines = new ArrayList<String>();
		
		URL url = null;
		BufferedReader input = null;
		String address = para_url;
		String line = "";
		
		try {
			url = new URL(address);
			input = new BufferedReader(new InputStreamReader(url.openStream()));
			
			while((line=input.readLine()) != null) {
				System.out.println(line);
				if(line.trim().length() > 0) {
					lines.add(line);
				}
			}
			input.close();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		
		JSONObject json = new JSONObject();
		
		return json.toString();
	}
	
	
	// 조직도 불러오기
	@GetMapping("getOrganization")
	public ModelAndView getOrganization(ModelAndView mav) {
		
		mav.setViewName("mycontent/document/organization");
		
		return mav;
	}
}
