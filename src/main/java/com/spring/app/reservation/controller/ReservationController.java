package com.spring.app.reservation.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.app.reservation.domain.AssetReservationVO;
import com.spring.app.reservation.domain.AssetVO;
import com.spring.app.reservation.service.ReservationService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


//=== 컨트롤러 선언 === //
@Controller
@RequestMapping("/reservation/*")
public class ReservationController {

	@Autowired // Type 에 따라 알아서 Bean 을 주입해준다.
	private ReservationService service;
	
	
	
	
	
	// 자산 예약 메인페이지
	@GetMapping("")
	public ModelAndView selectLeftBar_reservation(HttpServletRequest request, 
												  ModelAndView mav) {
		
		mav.setViewName("mycontent/reservation/reservation");
		
		return mav;
	}
	
	
	
	// 자산 예약 대분류 생성
	@PostMapping("reservationAdd") 
	public ModelAndView reservationAdd(ModelAndView mav, 
									   HttpServletRequest request,
									   @RequestParam(defaultValue = "") String classification,
									   @RequestParam(defaultValue = "") String assetTitle,
									   @RequestParam(defaultValue = "") String assetInfo) {
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("classification", classification); 
		paraMap.put("assetTitle", assetTitle);
		paraMap.put("assetInfo", assetInfo);
		
		// System.out.println("확인만 해보자 assetTitle : " + assetTitle);
		
		int n = service.reservationAdd(paraMap); // 자산 대분류를 insert 해주는 메소드
		
		if(n==1) {
			mav.addObject("message", "등록이 완료되었습니다.");
			mav.addObject("loc", request.getContextPath()+"/reservation/reservation");
			mav.setViewName("msg");
		}
		
		return mav;
	}
	
	
	
	// 들어오자마자 보이는 내 대여 현황
	@GetMapping("showMyReservation")
	@ResponseBody
	public String showMyReservation(@RequestParam String employeeNo) {
		
		List<Map<String, String>> my_ReservationList = service.my_Reservation(employeeNo); // 내 예약 정보를 select 해주는 메소드
		
		// System.out.println("ajax 들어옴?????????????" + my_ReservationList.size());
		
		JSONArray jsonArr = new JSONArray();  //  []
		
		if(my_ReservationList != null) {
			
			for(Map<String,String> listMap : my_ReservationList) {
				JSONObject jsonObj = new JSONObject();  //  {}
				jsonObj.put("assetReservationNo", listMap.get("assetReservationNo"));
				jsonObj.put("fk_assetDetailNo", listMap.get("fk_assetDetailNo"));
				jsonObj.put("fk_employeeNo", listMap.get("fk_employeeNo"));
				jsonObj.put("reservationStart", listMap.get("reservationStart"));
				jsonObj.put("reservationEnd", listMap.get("reservationEnd"));
				jsonObj.put("reservationDay", listMap.get("reservationDay"));
				
				jsonArr.put(jsonObj);
			} // end of for --------------
		}
		
		return jsonArr.toString();
	}
	
	
	
	// 자산 대분류 삭제
	@PostMapping("deleteAsset")
	@ResponseBody
	public String deleteAsset(@RequestParam String assetNo) {
		
		int n = service.deleteAsset(assetNo); // 대분류를 삭제하는 메소드
		// System.out.println("삭제하러 들어옴 n : " + n);

		JSONObject jsonObj = new JSONObject();  //  {}
		
		if(n == 1) {
			jsonObj.put("result", 1);
		}
		else {
			jsonObj.put("result", 0);
		}
		
		return jsonObj.toString();
	}
	
	
	// 자산 관리자용 상세페이지
	@GetMapping("showReservationOne")
	public ModelAndView selectLeftBar_showReservationOne(HttpServletRequest request, 
														 ModelAndView mav, 
														 @RequestParam String assetNo) {

		AssetVO assetvo = service.assetOneSelect(assetNo); // 자산 하나에 해당하는 대분류 정보를 select 해주는 메소드
		List<Map<String, String>> OneDeList = service.assetOneDeSelect(assetNo); // 대분류에 딸린 자산들을 select 해주는 메소드
		
		// ==== 대분류 정보 ==== //
		mav.addObject("assetvo", assetvo);
		// ==== 대분류 정보 ==== //
		
		// ==== 소분류 정보 ==== //
		mav.addObject("OneDeList", OneDeList);
		// ==== 소분류 정보 ==== //
		
		mav.setViewName("mycontent/reservation/showReservationOne");
		
		return mav;
	}

	
	// 자산 관리자용 상세페이지에서 자산정보를 조회해주는 메소드
	@PostMapping("middleTapInfo")
	@ResponseBody
	public String middleTapInfo(@RequestParam String assetNo) {
		
		List<Map<String, String>> middleTapInfoList = service.middleTapInfo(assetNo);
		// System.out.println("ajax 들어옴?????????????" + middleTapInfoList.size());
		
		JSONArray jsonArr = new JSONArray();  //  []
		
		if(middleTapInfoList != null) {
			
			for(Map<String,String> listMap : middleTapInfoList) {
				JSONObject jsonObj = new JSONObject();  //  {}
				jsonObj.put("assetInformationNo", listMap.get("assetInformationNo"));
				jsonObj.put("fk_assetDetailNo", listMap.get("fk_assetDetailNo"));
				jsonObj.put("fk_assetNo", listMap.get("fk_assetNo"));
				jsonObj.put("InformationTitle", listMap.get("InformationTitle"));
				jsonObj.put("InformationContents", listMap.get("InformationContents"));
				
				jsonArr.put(jsonObj);
			} // end of for --------------
		}
		
		return jsonArr.toString();
	}
	
	
	
	@PostMapping("addFixtures")
	@ResponseBody
	public String addFixtures(@RequestParam String str_InformationTitle
	                         ,@RequestParam String fk_assetNo
	                         ,@RequestParam String totalAssetDetailNo
	                         ,@RequestParam String totalInformationContents
	                         ,HttpServletRequest request) {

	    Map<String, Object> paraMap = new HashMap<>();
	    
	    // 받은 값들 출력 확인
	    System.out.println("확인용 str_InformationTitle : " + str_InformationTitle); 
	    System.out.println("확인용 totalAssetDetailNo : " + totalAssetDetailNo);
	    System.out.println("확인용 totalInformationContents : " + totalInformationContents);

	    // 받은 값을 배열로 변환
	    String[] arr_InformationTitle = str_InformationTitle.split(",");
	    String[] arr_InformationContents = totalInformationContents.split(",");
	    String[] arr_AssetDetailNo = totalAssetDetailNo.split(","); // AssetDetailNo를 배열로 분리

	    // System.out.println(arr_AssetDetailNo[0]);
	    
	    // 파라미터 맵에 추가
	    paraMap.put("fk_assetNo", fk_assetNo);
	    paraMap.put("arr_InformationTitle", arr_InformationTitle);
	    paraMap.put("arr_InformationContents", arr_InformationContents);
	    paraMap.put("arr_AssetDetailNo", arr_AssetDetailNo);

	    System.out.println("확인용 arr_AssetDetailNo : " + Arrays.toString(arr_AssetDetailNo));
	    
	    // 서비스 호출
	    int result = service.addFixtures(paraMap); // 서비스 메소드 실행

	    JSONObject jsonObj = new JSONObject();
	    if (result == 1) {
	        jsonObj.put("result", 1);
	    } else {
	        jsonObj.put("result", 0);
	    }

	    return jsonObj.toString();
	}
	
	
	
	
	@PostMapping("addAsset")
	@ResponseBody
	public String addAsset(@RequestParam String assetName,
						   @RequestParam String fk_assetNo) {
		
		Map<String, String> paraMap = new HashMap<>();
		
		paraMap.put("assetName", assetName);
		paraMap.put("fk_assetNo", fk_assetNo);
		
	    int result = service.addAsset(paraMap); // 자산추가를 해주는 메소드

	    JSONObject jsonObj = new JSONObject();
	    if (result == 1) {
	        jsonObj.put("result", 1);
	    } else {
	        jsonObj.put("result", 0);
	    }
		
		return jsonObj.toString();
	}

	
	
	
	@PostMapping("selectAssetDe")
	@ResponseBody
	public String selectAssetDe(@RequestParam String fk_assetNo) {
		
		
		List<Map<String, String>> assetOneDeSelectList = service.assetOneDeSelect(fk_assetNo); // 자산상세를 select 해주는 메소드
		
		JSONArray jsonArr = new JSONArray();  //  []
		
		if(assetOneDeSelectList != null) {
			
			for(Map<String,String> listMap : assetOneDeSelectList) {
				JSONObject jsonObj = new JSONObject();  //  {}
				jsonObj.put("assetDetailNo", listMap.get("assetDetailNo"));
				jsonObj.put("fk_assetNo", listMap.get("fk_assetNo"));
				jsonObj.put("assetName", listMap.get("assetName"));
				jsonObj.put("assetDetailRegisterday", listMap.get("assetDetailRegisterday"));
				jsonObj.put("assetDetailChangeday", listMap.get("assetDetailChangeday"));
				
				jsonArr.put(jsonObj);
			} // end of for --------------
		}
		
		return jsonArr.toString();
	}
	
		
	
	
	
	
	
	
	
	
	
	
	
	
	
	////////////////////////////////////////////////////////////// 자산상세 페이지
	@GetMapping("showReservationDeOne")
	public ModelAndView selectLeftBar_showReservationDeOne(HttpServletRequest request, 
													       ModelAndView mav,
													       @RequestParam String assetName,
													       @RequestParam String assetDetailNo) {
	
	mav.addObject("assetName", assetName);
	mav.addObject("assetDetailNo", assetDetailNo);
		
	mav.setViewName("mycontent/reservation/showReservationDeOne");
	
	return mav;
	}
	
	
	
	// 해당 페이지 내의 일자 구간 예약정보 불러오기
	@PostMapping("selectassetReservationThis")
	@ResponseBody
	public List<AssetReservationVO> selectassetReservationThis(AssetReservationVO assetreservationvo) {
		
		System.out.println("assetreservationvo 확인 : "+ assetreservationvo.getReservationStart());
		
		List<AssetReservationVO> reservationvoList = service.selectassetReservationThis(assetreservationvo);
		
		System.out.println("reservationvoList 해당 일자 구간 예약 개수 : " + reservationvoList.size());
		
		return reservationvoList;
	}
	
	
}
