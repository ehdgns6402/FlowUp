package com.spring.app.document.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.document.domain.ApprovalVO;
import com.spring.app.document.domain.DocumentVO;
import com.spring.app.employee.domain.DepartmentVO;
import com.spring.app.employee.domain.EmployeeVO;
import com.spring.app.employee.domain.TeamVO;

@Mapper
public interface DocumentDAO {
	
	// 메인 페이지에서 보여줄 결재 대기 문서 5개 가져오기
	List<DocumentVO> mainTodoList(String employeeNo);

	// 메인 페이지에서 보여줄 기안 진행 문서 5개 가져오기
	List<DocumentVO> mainProgressList(String employeeNo);

	// 메인 페이지에서 보여줄 기안 완료 문서 5개 가져오기
	List<DocumentVO> mainCompletedList(String employeeNo);

	// 결재 대기 문서 리스트 가져오기
	List<DocumentVO> todoList(String employeeNo);
	
	// 결재 예정 문서 리스트 가져오기
	List<DocumentVO> upcomingList(String employeeNo);
	
	// 결재 대기 문서함에서 검색어를 포함한 문서 갯수 가져오기
	int todoListCount_Search(Map<String, String> paraMap);

	// 결재 대기 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	List<DocumentVO> todoList_Search_Paging(Map<String, String> paraMap);

	// 결재 예정 문서함에서 검색어를 포함한 문서 갯수 가져오기
	int upcomingListCount_Search(Map<String, String> paraMap);

	// 결재 예정 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	List<DocumentVO> upcomingList_Search_Paging(Map<String, String> paraMap);
	
	// 기안 문서함에서 검색어를 포함한 문서 갯수 가져오기
	Integer myDocumentListCount_Search(Map<String, String> paraMap);
	
	// 기안 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	List<DocumentVO> myDocumentList_Search_Paging(Map<String, String> paraMap);
	
	// 임시 저장 문서함에서 검색어를 포함한 문서 갯수 가져오기
	int tempListCount_Search(Map<String, String> paraMap);
	
	// 임시 저장 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	List<DocumentVO> tempList_Search_Paging(Map<String, String> paraMap);
	
	// 결재 문서함에서 검색어를 포함한 문서 갯수 가져오기
	int approvedtListCount_Search(Map<String, String> paraMap);

	// 결재 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	List<DocumentVO> approvedList_Search_Paging(Map<String, String> paraMap);

	// 부서 문서함에서 검색어를 포함한 문서 갯수 가져오기
	int deptDocumentListCount_Search(Map<String, String> paraMap);

	// 부서 문서함에서 검색어를 포함한 페이징 처리한 문서 리스트 가져오기
	List<DocumentVO> deptDocumentList_Search_Paging(Map<String, String> paraMap);
	
	// 문서함에서 문서 1개 보여주기
	Map<String, String> documentView(Map<String, String> paraMap);
	
	// 문서함에서 보여줄 결재자 리스트 가져오기
	List<ApprovalVO> getApprovalList(String documentNo);

	// 조직도에 뿌려주기 위한 부서 목록 가져오기
	List<DepartmentVO> getDepartmentList();
	
	// 조직도에 뿌려주기 위한 팀 목록 가져오기
	List<TeamVO> getTeamList();
	
	// 조직도에 뿌려주기 위한 사원 목록 가져오기
	List<EmployeeVO> getEmployeeList();

	// 결재 라인 승인자 추가하기
	int insertApprover(Map<String, String> paraMap);
	
	// 전자결재 문서번호 채번하기
	String getSeqDocument();
	
	// 전자결재 문서 생성
	int insertDocument(Map<String, String> paraMap);
	
	// 휴가신청서 문서 생성
	int insertAnnualDraft(Map<String, String> paraMap);
	
	// 연장근무신청서 문서 생성
	int insertOvertimeDraft(Map<String, String> paraMap);
	
	// 업무기안 문서 생성
	int insertBusinessDraft(Map<String, String> paraMap);
	
	// 지출품의서 문서 생성
	int insertExpenseDraft(Map<String, String> paraMap);

	// 결재 승인하기
	int approve(Map<String, String> map);

	// 결재자의 승인 순서 알아오기
	int getApprovalOrder(Map<String, String> map);

	// 문서의 결재 상태를 업데이트 하기
	int updateDocumentApprovalStatus(Map<String, String> map);

	// 결재 반려하기
	int reject(Map<String, String> map);

	// 결재 라인에 추가하기 위한 사원 1명 가져오기
	EmployeeVO getEmployeeOne(String employeeNo);

	// 임시저장 문서 삭제하기
	int deleteTemp(String documentNo);

	// 임시저장 문서 리스트 삭제하기
	int deleteTempList(List<String> checked_list);

	// 휴가신청서 잔여 연차 가져오기
	int getAnnual(Map<String, String> map);

	// 휴가신청서 승인 시 근태 테이블에 데이터 insert
	int insertCommuteWithAnnual(Map<String, String> paramap);

	// 휴가신청서 신청 시 겹치는지 확인
	int checkAnuualOverlap(Map<String, String> paraMap);

	// 연장근무신청서 일자가 겹치는지 확인
	int checkOvertimeOverlap(Map<String, String> paraMap);

	// 연장근무신청서 승인 시 근태 테이블에 데이터 update
	void updateCommuteWithOvertime(Map<String, String> document);

	// 연장근무신청서 승인 시 근태 테이블에 데이터 insert
	void insertCommuteWithOvertime(Map<String, String> document);

	// 해당 사원이 휴가 캘린더가 있는지 확인
	int checkVacationCalendar(String fk_employeeNo);

	// 캘린더 스몰 카테고리 채번하기
	int getSeqSmcatgono();

	// 휴가 캘린더 생성하기
	void createVacationCalendar(Map<String, String> document);

	// 휴가 스케쥴 생성하기
	void createVacationSchedule(Map<String, String> document);

	// 지출 품의 상세 insert
	void insertExpenseDetail(Map<String, String> paraMap);

	// 지출 품의 상세 가져오기
	List<Map<String, String>> expenseDetailList(Map<String, String> paraMap);

	// 전자결재 통합검색 메인
	List<DocumentVO> searchDocument(Map<String, String> hashMap);

	

	


	

	

	

	


	

	

	

	




}
