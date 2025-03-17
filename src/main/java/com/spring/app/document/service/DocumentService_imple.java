package com.spring.app.document.service;


import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.spring.app.document.domain.ApprovalVO;
import com.spring.app.document.domain.DocumentVO;
import com.spring.app.document.model.DocumentDAO;
import com.spring.app.employee.domain.DepartmentVO;
import com.spring.app.employee.domain.EmployeeVO;
import com.spring.app.employee.domain.TeamVO;


// === 서비스 선언 === //
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단
@Service
public class DocumentService_imple implements DocumentService {
	
	@Autowired
	private DocumentDAO mapper_dao; // mapper 인터페이스
	

	// 메인 페이지에서 보여줄 결재 대기 문서 5개 가져오기
	@Override
	public List<DocumentVO> mainTodoList(String employeeNo) {
		
		List<DocumentVO> todoList = mapper_dao.mainTodoList(employeeNo);
		return todoList;
	}


	// 메인 페이지에서 보여줄 기안 진행 문서 5개 가져오기
	@Override
	public List<DocumentVO> mainProgressList(String employeeNo) {

		List<DocumentVO> todoList = mapper_dao.mainProgressList(employeeNo);
		return todoList;
	}


	// 메인 페이지에서 보여줄 기안 완료 문서 5개 가져오기
	@Override
	public List<DocumentVO> mainCompletedList(String employeeNo) {

		List<DocumentVO> todoList = mapper_dao.mainCompletedList(employeeNo);
		return todoList;
	}
	
	
	// 결재 대기 문서 리스트 가져오기
	@Override
	public List<DocumentVO> todoList(String employeeNo) {

		List<DocumentVO> todoList = mapper_dao.todoList(employeeNo);
		return todoList;
	}
	
	
	// 결재 예정 문서 리스트 가져오기
	@Override
	public List<DocumentVO> upcomingList(String employeeNo) {
		
		List<DocumentVO> upcomingList = mapper_dao.upcomingList(employeeNo);
		return upcomingList;
	}
	
	
	// 결재 대기 문서함에서 검색어를 포함한 문서 갯수 가져오기
	@Override
	public int todoListCount_Search(Map<String, String> paraMap) {

		int totalCount = mapper_dao.todoListCount_Search(paraMap);
		return totalCount;
	}


	// 결재 대기 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	@Override
	public List<DocumentVO> todoList_Search_Paging(Map<String, String> paraMap) {

		List<DocumentVO> todoList = mapper_dao.todoList_Search_Paging(paraMap);
		return todoList;
	}


	// 결재 예정 문서함에서 검색어를 포함한 문서 갯수 가져오기
	@Override
	public int upcomingListCount_Search(Map<String, String> paraMap) {

		int totalCount = mapper_dao.upcomingListCount_Search(paraMap);
		return totalCount;
	}


	// 결재 예정 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	@Override
	public List<DocumentVO> upcomingList_Search_Paging(Map<String, String> paraMap) {

		List<DocumentVO> upcomingList = mapper_dao.upcomingList_Search_Paging(paraMap);
		return upcomingList;
	}
	
	
	// 기안 문서함에서 검색어를 포함한 문서 갯수 가져오기
	@Override
	public int myDocumentListCount_Search(Map<String, String> paraMap) {
		
		int totalCount = mapper_dao.myDocumentListCount_Search(paraMap);
		return totalCount;
	}

	
	// 기안 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	@Override
	public List<DocumentVO> myDocumentList_Search_Paging(Map<String, String> paraMap) {
		
		List<DocumentVO> myDocumentList = mapper_dao.myDocumentList_Search_Paging(paraMap);
		return myDocumentList;
	}
	
	
	// 임시 저장 문서함에서 검색어를 포함한 문서 갯수 가져오기
	@Override
	public int tempListCount_Search(Map<String, String> paraMap) {

		int totalCount = mapper_dao.tempListCount_Search(paraMap);
		return totalCount;
	}


	// 임시 저장 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	@Override
	public List<DocumentVO> tempList_Search_Paging(Map<String, String> paraMap) {

		List<DocumentVO> tempList = mapper_dao.tempList_Search_Paging(paraMap);
		return tempList;
	}


	// 결재 문서함에서 검색어를 포함한 문서 갯수 가져오기
	@Override
	public int approvedtListCount_Search(Map<String, String> paraMap) {

		int totalCount = mapper_dao.approvedtListCount_Search(paraMap);
		return totalCount;
	}
	


	// 결재 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	@Override
	public List<DocumentVO> approvedList_Search_Paging(Map<String, String> paraMap) {

		List<DocumentVO> approvedList = mapper_dao.approvedList_Search_Paging(paraMap);
		return approvedList;
	}
	
	
	// 부서 문서함에서 검색어를 포함한 문서 갯수 가져오기
	@Override
	public int deptDocumentListCount_Search(Map<String, String> paraMap) {

		int totalCount = mapper_dao.deptDocumentListCount_Search(paraMap);
		return totalCount;
	}


	// 부서 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	@Override
	public List<DocumentVO> deptDocumentList_Search_Paging(Map<String, String> paraMap) {

		List<DocumentVO> deptDocumentList = mapper_dao.deptDocumentList_Search_Paging(paraMap);
		return deptDocumentList;
	}

	
	// 문서함에서 문서 1개 보여주기
	@Override
	public Map<String, String> documentView(Map<String, String> paraMap) {
		
		Map<String, String> document = mapper_dao.documentView(paraMap);
		return document;
	}
	
	
	// 문서함에서 보여줄 결재자 리스트 가져오기
	@Override
	public List<ApprovalVO> getApprovalList(String documentNo) {
		
		List<ApprovalVO> approvalList = mapper_dao.getApprovalList(documentNo);
		return approvalList;
	}

	
	// 조직도에 뿌려주기 위한 부서 목록 가져오기
	@Override
	public List<DepartmentVO> getDepartmentList() {

		List<DepartmentVO> departmentList = mapper_dao.getDepartmentList();
		return departmentList;
	}
	
	
	// 조직도에 뿌려주기 위한 팀 목록 가져오기
	@Override
	public List<TeamVO> getTeamList() {

		List<TeamVO> teamList = mapper_dao.getTeamList();
		return teamList;
	}

	
	// 조직도에 뿌려주기 위한 사원 목록 가져오기
	@Override
	public List<EmployeeVO> getEmployeeList() {
		
		List<EmployeeVO> employeeList = mapper_dao.getEmployeeList();
		return employeeList;
	}


	// 결재 요청
	@Override
	@Transactional(value = "transactionManager_mymvc_user", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public Map<String, String> draft(Map<String, String> paraMap) {
		
		Map<String, String> map = new HashMap<>();
		
		// 휴가신청서 휴가 일자가 겹치는지 확인
		if("휴가신청서".equals(paraMap.get("documentType")) && !"1111-11-11".equals(paraMap.get("startDate")) && !"1111-11-11".equals(paraMap.get("endDate"))) {
			int n = mapper_dao.checkAnuualOverlap(paraMap);
			if(n > 0) {
				map.put("n", "-1");
				return map;
			}
		}
		
		// 연장근무신청서 일자가 겹치는지 확인
		else if("연장근무신청서".equals(paraMap.get("documentType")) && !"1111-11-11".equals(paraMap.get("overtimeDate"))) {
			int n = mapper_dao.checkOvertimeOverlap(paraMap);
			if(n > 0) {
				map.put("n", "-2");
				return map;
			}
			// 당일 6시 이후에는 연장근무 신청 못하게 막기
			LocalDate localDate = LocalDate.now(); // 현재 날짜
			LocalTime localTime = LocalTime.now(); // 현재 시간
			DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
			
			String today = localDate.format(dateTimeFormatter);
			
			if(today.equals(paraMap.get("overtimeDate")) && localTime.getHour() >= 18) {
				// 연장 근무 신청일자가 오늘이고 6시를 넘은 경우
				map.put("n", "-3");
				return map;
			}
			
		}
		
		
		// 채번하기
		String seq_document = mapper_dao.getSeqDocument();
		
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-");
		
		String documentNo = sdf.format(date) + seq_document; // 문서번호
		
		paraMap.put("documentNo", documentNo); // 문서번호 넣어주기
		
		int n = mapper_dao.insertDocument(paraMap);
		int m = 0;
		if(n==1) {
			if("휴가신청서".equals(paraMap.get("documentType"))) {
				m = mapper_dao.insertAnnualDraft(paraMap);
			}
			else if("연장근무신청서".equals(paraMap.get("documentType"))) {
				m = mapper_dao.insertOvertimeDraft(paraMap);
			}
			else if("업무기안".equals(paraMap.get("documentType"))) {
				m = mapper_dao.insertBusinessDraft(paraMap);
			}
			else if("지출품의서".equals(paraMap.get("documentType"))) {
				m = mapper_dao.insertExpenseDraft(paraMap);
				System.out.println("m 은" + m);
				int expense_detail_count = Integer.parseInt(paraMap.get("expense_detail_count"));
				for(int i = 0; i < expense_detail_count; i++) {
					paraMap.put("amount", paraMap.get("amount" + i));
					paraMap.put("type", paraMap.get("type" + i));
					paraMap.put("useDate", paraMap.get("useDate" + i));
					paraMap.put("content", paraMap.get("content" + i));
					paraMap.put("note", paraMap.get("note" + i));
					
					mapper_dao.insertExpenseDetail(paraMap);
				}
			}
		}
		
		int approval_count = Integer.parseInt(paraMap.get("added_approval_count"));
		
		int a = 1;
		
		for(int i = 0; i < approval_count; i++) {
			paraMap.put("fk_approver", paraMap.get("added_employee_no" + i));
			paraMap.put("approvalorder", String.valueOf(approval_count-i));
			a *= mapper_dao.insertApprover(paraMap);
		}
		
		
		map.put("n", String.valueOf(n*m*a));	// 결과 넣어주기
		map.put("documentNo", documentNo);		// 문서번호 넣어주기
		
		return map;
	}
	

	// 결재 승인하기
	@Override
	@Transactional(value = "transactionManager_mymvc_user", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int approve(Map<String, String> map) {
		
		// 결재 승인하기
		int n = mapper_dao.approve(map);
		
		// 결재자의 승인 순서 알아오기
		int approvalOrder = mapper_dao.getApprovalOrder(map);
		
		int m = 0;
		
		// 결재 상태 1(승인)
		map.put("status", "1");
		
		if(approvalOrder == 1) {
			// 문서의 결재 상태를 업데이트 하기
			m = mapper_dao.updateDocumentApprovalStatus(map);
			
			Map<String, String> document = mapper_dao.documentView(map); // 승인 처리된 문서 정보 가져오기
			
			if(m == 1 && "휴가신청서".equals(map.get("documentType"))) {
				// 휴가신청서가 승인 처리 된 경우
				
				// 휴가신청서가 승인이 되면 근태 테이블에 휴가 데이터 넣어주기
				String start_str = document.get("startDate");
				String end_str = document.get("endDate");
				
				LocalDate startDate = LocalDate.parse(start_str, DateTimeFormatter.ofPattern("yyyy-MM-dd")); // 휴가 시작 날짜
				LocalDate endDate = LocalDate.parse(end_str, DateTimeFormatter.ofPattern("yyyy-MM-dd"));	 // 휴가 종료 날짜
				
				long daysBetween = ChronoUnit.DAYS.between(startDate, endDate) + 1;	// 휴가 일수 (종료 날짜와 시작 날짜의 차이)
				
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				
				for(int i = 0; i < daysBetween; i++) {
					// 휴가 일 수 만큼 for 문
					LocalDate Date = startDate.plusDays(i); // 휴가 시작 날짜부터 하루씩 더해가기
					int day = Date.getDayOfWeek().getValue();
					if(!(day == 6 || day == 7)) {
						// 주말이 아니라면
						document.put("startDate", Date.format(formatter));
						System.out.println(Date.format(formatter));
						mapper_dao.insertCommuteWithAnnual(document); // 근태 테이블에 추가
					}
				}
				
				// 휴가신청서가 승인이 되면 캘린더 테이블에 휴가 데이터 넣어주기
				document.put("startDate", start_str);
				int smcatgono = mapper_dao.checkVacationCalendar(document.get("fk_employeeNo")); // 해당 사원이 휴가 캘린더가 있는지 확인
				document.put("smcatgono", String.valueOf(smcatgono)); // 카테고리 번호 넣어주기
				
				if(smcatgono == 0) {
					// 해당 사원이 휴가 캘린더가 없는 경우
					smcatgono = mapper_dao.getSeqSmcatgono(); // 카테고리 번호 채번
					document.put("smcatgono", String.valueOf(smcatgono)); // 카테고리 번호 채번한 번호로 변경
					
					mapper_dao.createVacationCalendar(document); // 휴가 카테고리 생성
					
					
				}
				
				if("1".equals(document.get("annualType"))) {
					document.put("startDate", document.get("startDate") + " 00:00" );
					document.put("endDate", document.get("endDate") + " 23:30" );
				}
				else if("2".equals(document.get("annualType"))) {
					document.put("startDate", document.get("startDate") + " 09:00" );
					document.put("endDate", document.get("endDate") + " 13:00" );
				}
				else if("3".equals(document.get("annualType"))) {
					document.put("startDate", document.get("startDate") + " 14:00" );
					document.put("endDate", document.get("endDate") + " 18:00" );
				}
				
				mapper_dao.createVacationSchedule(document);
				
			} // end of if(m == 1 && "휴가신청서".equals(map.get("documentType")))--------------------------
			
			
			else if(m == 1 && "연장근무신청서".equals(map.get("documentType"))) {
				LocalDate localDate = LocalDate.now(); // 현재 날짜
				DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String today = localDate.format(dateTimeFormatter);
				
				if(today.equals(document.get("overtimeDate"))) {
					// 연장 근무 신청 일자가 오늘이라면
					mapper_dao.updateCommuteWithOvertime(document);
				}
				else {
					// 연장 근무 신청 일자가 오늘이 아니라면
					mapper_dao.insertCommuteWithOvertime(document);
				}
			}
		}
		
		return n*m;
	}


	// 결재 반려하기
	@Override
	@Transactional(value = "transactionManager_mymvc_user", propagation=Propagation.REQUIRED, isolation=Isolation.READ_COMMITTED, rollbackFor= {Throwable.class})
	public int reject(Map<String, String> map) {
		
		// 결재 반려하기
		int n = mapper_dao.reject(map);
		
		// 결재 상태 2(반려)
		map.put("status", "2");
		
		// 문서의 결재 상태를 업데이트 하기
		int m = mapper_dao.updateDocumentApprovalStatus(map);
		
		return n*m;
	}


	// 결재 라인에 추가하기 위한 사원 1명 가져오기
	@Override
	public EmployeeVO getEmployeeOne(String employeeNo) {
		
		EmployeeVO employee = mapper_dao.getEmployeeOne(employeeNo);
		return employee;
	}


	// 임시저장 문서 삭제하기
	@Override
	public int deleteTemp(String documentNo) {
		
		int n = mapper_dao.deleteTemp(documentNo);
		return n;
	}


	// 임시저장 문서 리스트 삭제하기
	@Override
	public int deleteTempList(List<String> checked_list) {
		
		int n = mapper_dao.deleteTempList(checked_list);
		return n;
	}


	// 휴가신청서 잔여 연차 가져오기
	@Override
	public int getAnnual(String employeeNo) {
		
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
		String year = sdf.format(date);
		
		Map<String, String> map = new HashMap<>();
		map.put("employeeNo", employeeNo);
		map.put("year", year);
		
		int totalAmount = mapper_dao.getAnnual(map);
		
		return totalAmount;
	}


	// 메인페이지에 보여줄 유저의 결재대기문서, 결재예정문서, 기안문서, 임시저장문서 개수 알아오기
	@Override
	public Map<String, Integer> getDocCnt(String employeeno) {
		
		Map<String, String> paraMap = new HashMap<>();
		paraMap.put("employeeNo", employeeno);
		paraMap.put("searchWord", "");
		paraMap.put("documentType", "");
		paraMap.put("status", "");
		
		Map<String, Integer> documentMap = new HashMap<>();
		
		int todoDocCnt		= mapper_dao.todoListCount_Search(paraMap);
		int upcomingDocCnt	= mapper_dao.upcomingListCount_Search(paraMap);
		int myDocCnt		= mapper_dao.myDocumentListCount_Search(paraMap);
		int tempDocCnt		= mapper_dao.tempListCount_Search(paraMap);
		documentMap.put("todoDocCnt", todoDocCnt);
		documentMap.put("upcomingDocCnt", upcomingDocCnt);
		documentMap.put("myDocCnt", myDocCnt);
		documentMap.put("tempDocCnt", tempDocCnt);
		
		return documentMap;
	}


	// 지출 품의 상세 가져오기
	@Override
	public List<Map<String, String>> expenseDetailList(Map<String, String> paraMap) {
		
		List<Map<String, String>> expenseDetailList = mapper_dao.expenseDetailList(paraMap);
		return expenseDetailList;
	}


	// 전자결재 통합검색 메인
	@Override
	public List<DocumentVO> searchDocument(Map<String, String> hashMap) {
		List<DocumentVO> list = mapper_dao.searchDocument(hashMap);
		return list;
	}


	


	


	


	




	


	

	


	


	


	

	

	

	
}
