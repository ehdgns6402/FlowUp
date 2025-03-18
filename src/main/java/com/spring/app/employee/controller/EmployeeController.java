package com.spring.app.employee.controller;

import java.io.File;
import java.net.http.HttpRequest;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.spring.app.common.FileManager;
import com.spring.app.employee.domain.AddressBookVO;
import com.spring.app.employee.domain.EmployeeVO;
import com.spring.app.employee.domain.GroupVO;
import com.spring.app.employee.service.EmployeeService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;


//=== 컨트롤러 선언 === //
@Controller
@RequestMapping(value = "/employee/*")
public class EmployeeController {

	@Autowired // Type 에 따라 알아서 Bean 을 주입해준다.
	private EmployeeService service;

	@Autowired
	private FileManager fileManager;
	
	
	// === #ljh1. 로그인 폼 페이지 요청 === //
	@GetMapping("login")
	public ModelAndView login(ModelAndView mav) {
		mav.setViewName("mycontent/employee/login");
		return mav;
	}

	/*
	 * // === #ljh2. 로그인 처리하기 === //
	 * 
	 * @PostMapping("login") public Map<String,Integer> login(HttpServletRequest
	 * request, @RequestParam Map<String,String>paraMap, HttpServletResponse
	 * response, ModelAndView mav) {
	 * 
	 * int n = 0; // 0:실패, 1:성공 Map<String,Integer>resultMap = new HashMap<>(); //
	 * 되돌려줄 값
	 * 
	 * // 클라이언트 ip 값 불러오기 String clientIp = request.getRemoteAddr();
	 * paraMap.put("clientIp", clientIp);
	 * 
	 * 
	 * n = service.login(request, paraMap, response,mav);
	 * 
	 * resultMap.put("n", n);
	 * 
	 * return resultMap; }
	 */

	// === #ljh2-1. 로그인 처리하기 === //

	@PostMapping("login")
	public ModelAndView login(HttpServletRequest request, @RequestParam Map<String, String> paraMap) {

		ModelAndView mav = new ModelAndView();

		// 클라이언트 ip 가져오기
		String clientIp = request.getHeader("X-Forwarded-For");
		if (clientIp == null || clientIp.isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
		    clientIp = request.getRemoteAddr();
		}
		paraMap.put("id", request.getParameter("id") );
		paraMap.put("clientIp", clientIp);
		// System.out.println("잘 갖고오나 확인 : " + paraMap.get("id"));
		// System.out.println("로그인 ip주소 : " + clientIp);
		
		EmployeeVO loginuser = service.login(paraMap);
		
		
		

		if (loginuser != null) { // 로그인 유저가 null 이 아닐때
 
			service.insert_tbl_loginhistory(paraMap); // tbl_loginhistory 테이블에 insert 해주기
			
			HttpSession session = request.getSession();
			session.setAttribute("loginuser", loginuser); // 로그인 유저 세션에 저장

			mav.setViewName("redirect:/index"); // 로그인이 성공했을 때 메인페이지로 이동
		}

		else {

			mav.addObject("message", "아이디 또는 비밀번호가 틀렸습니다");
			mav.addObject("loc", "javaScript:history.back()");
			mav.setViewName("msg"); // 실패 시 메시지 페이지로 이동

		}

		return mav;
	}

	// === 로그아웃 처리 === //
	@GetMapping("logout")
	public ModelAndView logout(ModelAndView mav, HttpServletRequest request) {

		mav = service.logout(mav, request);

		return mav;
	}

	// === #ljh6. 관리자 페이지 요청 === //
	@GetMapping("admin")
	public ModelAndView admin(ModelAndView mav) {
		mav.setViewName("mycontent/employee/admin_main");
		return mav;
	}

	// === #ljh7. 관리자 회원추가 페이지 요청 === //
	@GetMapping("addEmployee")
	public ModelAndView addEmployee(ModelAndView mav, @RequestParam Map<String, String> paraMap) {

		// === 부서번호, 부서명 알아오기 === //
		List<Map<String, String>> departmentno_map_list = service.departmentno_select();
		mav.addObject("departmentno_map_list", departmentno_map_list);

		// === 직급번호, 직급명 알아오기 === //
		List<Map<String, String>> positionno_map_list = service.positionno_select();
		mav.addObject("positionno_map_list", positionno_map_list);

		mav.setViewName("mycontent/employee/addEmployee");
		return mav;
	}

	// === #ljh8.회원추가 처리 === //
	@PostMapping("addEmployeeEnd")
	public String addEmployeeEnd(EmployeeVO empvo, HttpServletRequest request) {

		int n = service.insert_employee(empvo);

		String view_path = "";

		if (n != 0) {
			System.out.println(">>>> 사원 추가 성공적 <<<<");
			
			view_path = "redirect:/employee/login"; // 기존 페이지에 간다.
		}

		else { // 회원 추가 실패
			request.setAttribute("message", "회원추가가 실패하였습니다");
			request.setAttribute("loc", "javaScript:history.back()");
			view_path = "msg";
		}

		// System.out.println("확인");
		return view_path;
	}

	// === #ljh10.마이페이지 요청 === //
	@GetMapping("mypage")
	public ModelAndView mypage(ModelAndView mav) {
		mav.setViewName("mycontent/employee/myPage");
		return mav;
	}

	// === #ljh11.내 정보 수정 페이지 요청 === //
	@GetMapping("updateMypageInfo")
	public ModelAndView updateMypageInfo(ModelAndView mav) {
		mav.setViewName("mycontent/employee/updateMypageInfo");
		return mav;
	}
	
	
	
	
	// === 내정보 수정하기 === //
	@PostMapping("updateInfoEnd")
	 public ModelAndView updateInfoEnd(ModelAndView mav, EmployeeVO empvo, MultipartHttpServletRequest mrequest) {
		
		MultipartFile attach = empvo.getAttach();
		
		
		String newFileName = ""; // 톰캣에 담겨질 파일 이름
		
		//파일 첨부가 있는 경우
		if( attach != null) {
			HttpSession session = mrequest.getSession();
			String root = session.getServletContext().getRealPath("/");
			
			String path = root+"resources"+File.separator+"files";
			// 루트 => C:\NCS\workspace_spring_boot_17\myspring\src\main\webapp\resources\file
			
			
			byte[] bytes = null; // 첨부 파일 내용물 담을 곳
			long fileSize = 0; // 업로드할 파일의 크기
			
			
			try {
				
				bytes = attach.getBytes(); // 첨부파일의 내용물을 읽어온다.
				
				String originalFileName = attach.getOriginalFilename(); // 업로드한 파일의 파일명 (ex: 강아지jpg)
				newFileName = fileManager.doFileUpload(bytes, originalFileName, path);// 첨부 되어진 파일의 업로드
				
				empvo.setProfileImg(originalFileName);// profileImg 컬럼의 파일의 원래 이름 넣기
				
				
				empvo.setFileName(newFileName); // fileName 에 톰캣에 올라가는 파일명 넣기
				
				fileSize = attach.getSize();
				empvo.setFileSize(String.valueOf(fileSize));
				
		
			}catch(Exception e) {
				e.printStackTrace();
			}
			
		}
		/*
		int n = service.updateInfoEnd(empvo);
		if(n == 1) {
			System.out.println("회원수정 성공");
			mav.setViewName("redirect:/employee/mypage");
		}
		*/
		
		int n =0;
		
		if(attach.isEmpty()) {// 파일의 업로드가 없을 때 
			n = service.updateInfoEnd(empvo);
		}
		
		else {
			n = service.upadateInfoEnd_withFile(empvo);
		}
		
		if(n==1) {
			
			HttpSession session = mrequest.getSession();
			
			EmployeeVO loginuser = (EmployeeVO)session.getAttribute("loginuser");
			
			loginuser.setEmail(empvo.getEmail());
			loginuser.setMobile(empvo.getMobile());
			loginuser.setDirectCall(empvo.getDirectCall());
			loginuser.setAddress(empvo.getAddress());
			loginuser.setMotive(empvo.getMotive());
			
			if( attach != null) {
				loginuser.setFileName(newFileName);
			}
			
			mav.setViewName("redirect:/employee/mypage");
		}
		else {
			  mav.setViewName("mycontent/employee/uploadFailse");
		}
		return mav;
	}
		
		

	// === 부서번호별 팀번호 알아오기 ===
	@GetMapping("teamNo_seek_BydepartmentNo")
	@ResponseBody
	public List<Map<String, String>> teamNo_seek_BydepartmentNo(@RequestParam String departmentNo) {

		List<Map<String, String>> mapList = new ArrayList<>();

		mapList = service.teamNo_seek_BydepartmentNo(departmentNo);

		return mapList;
	}
	
	
	

	// ===== 주소록 페이지 요청 ===== //
	@GetMapping("addressBook")
	public ModelAndView addressBook(ModelAndView mav, HttpServletRequest request) {
		mav.setViewName("mycontent/employee/addressbook");	
		
		//추가한 그룹옵션 집어넣기
		List<Map<String,String>>mapList  = service.groupOptionSelect();
		mav.addObject("mapList", mapList);
		return mav;
	}
	

	//==== 주소록 추가 ==== //
	@PostMapping("addAddressEnd")
	public String addAddressEnd(AddressBookVO adrsVO,  HttpServletRequest request) {
		
		String view_page = "";
		
		int n = service.insert_addressBook(adrsVO);
		
		if( n == 1) {
			System.out.println("주소록 추가 완료");
			view_page = "redirect:/employee/addressBook";
		}
		
		else {
			request.setAttribute("message", "주소록 추가가 실패하였습니다");
			request.setAttribute("loc", "javaScript:history.back()");
			view_page = "msg";
		}
		
		
		return view_page;
	}
	

	// ==== 로그인한 사번에 전체 주소록 가져오기
	@GetMapping("all_address_data")
	@ResponseBody
	public List<Map<String,String>>all_address_data(@RequestParam String fk_employeeNo){
		
		List<Map<String, String>> mapList = new ArrayList<>();
		mapList=service.all_address_data(fk_employeeNo);
		
		
		//System.out.println(mapList);
		
		return mapList;
	}
	
	
	// 부서 주소록 페이지 요청
	@GetMapping("departmentAddressBook")
	public ModelAndView departmentAddressBook(ModelAndView mav, @RequestParam Map<String, String> paraMap) {
		mav.setViewName("mycontent/employee/department_addressbook");	
		
		// 우리 회사 주소록 부서별로 알아오기
		List<Map<String,String>>addressBook_select_department_list = service.addressBook_select_department_list();

		//System.out.println(addressBook_select_department_list);
		//[{department=경영관리부}, {department=관리부}, {department=물류부}, {department=영업부}, {department=총무부}]
		mav.addObject("addressBook_select_department_list",addressBook_select_department_list);
		
		return mav;
	}
	
	// 부서별 주소록 목록 가져오기
	@GetMapping("department_address_data")
	@ResponseBody
	public List<Map<String,String>>department_address_data(@RequestParam String fk_employeeNo){
		
		List<Map<String, String>> mapList = new ArrayList<>();
		mapList=service.department_address_data(fk_employeeNo);
		
		//System.out.println(mapList);
		
		return mapList;
	}
	
	
	// ==== 외부 주소록 페이지 요청
	@GetMapping("external_addressbook")
	public ModelAndView external_addressbook (ModelAndView mav) {
	mav.setViewName("mycontent/employee/external_addressbook");	
		
		return mav;
	}
	
	
	// ==== 외부 주소록 목록 가져오기
	@GetMapping("external_address_data")
	@ResponseBody
	public List<Map<String,String>>external_address_data(@RequestParam String fk_employeeNo){
		
		 List<Map<String,String>> mapList = new ArrayList<>();
		 mapList=service.external_address_data(fk_employeeNo);
		 
		 return mapList;
		
	}
	
	
	// 전체주소록 중 선택한 주소 삭제하기
	@PostMapping("delete_address_book")
	@ResponseBody
	public String delete_address_book(@RequestParam String addressno){
		
		JSONObject jsonObj = new JSONObject(); 
		
		int n = service.delete_address_book(addressno);
		
		if(n==1) {
		//	System.out.println("주소록 삭제 완료");
			jsonObj.put("n", 1);
		}
		
		else {
			jsonObj.put("n", 0);
		}
		
		return jsonObj.toString();
	}
	
	// ==== 관리자의 사원 정보 수정 페이지 요청 ==== //
	@GetMapping("updateEmployee")
	public ModelAndView updateEmployee(ModelAndView mav, HttpServletRequest request) {
		mav.setViewName("mycontent/employee/updateEmployee");
		return mav;
	}
	
	// 관리자의 사원정보 수정의 사원정보 리스트
	@GetMapping("all_employee_info_list")
	@ResponseBody
	public List<Map<String,String>>all_employee_info_list(){
		List<Map<String,String>> mapList = new ArrayList<>();
		mapList = service.all_employee_info_list();
		return mapList;
	}
	
	// 관리자의 사원정보 수정 
	@PostMapping("updateEmployee_byAdminEnd")
	@ResponseBody
	public String updateEmployee_byAdminEnd(@RequestParam String name, 
			                                @RequestParam String employeeNo,
			                                @RequestParam String positionName,
			                                @RequestParam String departmentName,
			                                @RequestParam String teamName) {
		
		// 변경할 직급명에 대한 직급번호 알아오기
	    String positionNo = service.getPositionName(positionName);
	    
		// 변경할 부서명에 대한 부서번호 알아오기
		String departmentNo = service.getDepartmentName(departmentName);
		
		// 변경할 팀명에 대한 팀번호 알아오기
		String teamNo = service.getTeamName(teamName);
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("name", name);
		paraMap.put("employeeNo", employeeNo);
		paraMap.put("positionNo", positionNo);
		paraMap.put("departmentNo", departmentNo);
		paraMap.put("teamNo", teamNo);
		
		// 사원정보 수정하기
		int n = service.updateEmployee_byAdminEnd(paraMap);
		
		JSONObject jsonObj = new JSONObject();
		jsonObj.put("n", n);
		
		return jsonObj.toString(); 
	}
	
	
	// 그룹 옵션 추가하기
	@PostMapping("addGroupOptionEnd")
	@ResponseBody
	public String addGroupOptionEnd(GroupVO gvo, HttpServletRequest request, @RequestParam String g_fk_employee,
																			 @RequestParam String groupname) {

		int n = service.addGroupOptionEnd(gvo, g_fk_employee,groupname);
		
		  String view_page ="";
		  
		  System.out.println("n:"+n); 
		  if(n==1) { 
			  System.out.println("그룹옵션추가완료"); 
			  }
		  
		  else {
			  System.out.println("그룹옵션추가실패"); 
			  }
		 
		
		return view_page;
	}
	
	
	
	@GetMapping("groupNo_and_groupName_select")
	@ResponseBody
	public List<Map<String,String>>groupNo_and_groupName_select(@RequestParam String g_fk_employee){
		
		List<Map<String,String>> listMap = new ArrayList<>();
		listMap = service.groupNo_and_groupName_select(g_fk_employee);
		System.out.println(listMap);
		
		return listMap;
		
	}
	
	// 그룹에 추가하기
	@GetMapping("addGroup")
	@ResponseBody
	public List<Map<String, String>>addGroup(@RequestParam String fk_employeeno) {
		
		List<Map<String,String>> mapList = new ArrayList<>();
		
		mapList = service.addGroup(fk_employeeno);
		
		return mapList;
	}
	
	
}