package com.spring.app.document.service;


import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
	
	
	// 임시저장 문서 리스트 가져오기
	@Override
	public List<DocumentVO> tempList(String employeeNo) {
		
		List<DocumentVO> tempList = mapper_dao.tempList(employeeNo);
		return tempList;
	}


	// 결재 처리한 문서 리스트 가져오기
	@Override
	public List<DocumentVO> approvedList(String employeeNo) {
		
		List<DocumentVO> approvedList = mapper_dao.approvedList(employeeNo);
		return approvedList;
	}

	
	// 부서 문서 리스트 가져오기
	@Override
	public List<DocumentVO> deptDocumentList(String employeeNo) {
		
		List<DocumentVO> deptDocumentList = mapper_dao.deptDocumentList(employeeNo);
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
	public Map<String, String> draft(Map<String, String> paraMap) {
		
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
		}
		
		int approval_count = Integer.parseInt(paraMap.get("added_approval_count"));
		
		int a = 1;
		
		for(int i=0; i<approval_count; i++) {
			paraMap.put("fk_approver", paraMap.get("added_employee_no" + i));
			paraMap.put("approvalorder", String.valueOf(approval_count-i));
			a *= mapper_dao.insertApprover(paraMap);
		}
		
		Map<String, String> map = new HashMap<>();
		map.put("n", String.valueOf(n*m*a));	// 결과 넣어주기
		map.put("documentNo", documentNo);		// 문서번호 넣어주기
		
		return map;
	}
	

	// 결재 승인하기
	@Override
	public int approve(Map<String, String> map) {
		
		// 결재 승인하기
		int n = mapper_dao.approve(map);
		
		// 결재자의 승인 순서 알아오기
		int approvalOrder = mapper_dao.getApprovalOrder(map);
		
		int m = 1;
		
		// 결재 상태 1(승인)
		map.put("status", "1");
		
		if(approvalOrder == 1) {
			// 문서의 결재 상태를 업데이트 하기
			m = mapper_dao.updateDocumentApprovalStatus(map);
		}
		
		return n*m;
	}


	// 결재 반려하기
	@Override
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


	

	


	


	


	

	

	

	
}
