package com.spring.app.employee.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.spring.app.employee.domain.AddressBookVO;
import com.spring.app.employee.domain.EmployeeVO;


@Mapper
public interface EmployeeDAO {

//	List<Map<String, String>> test();

	//로그인 처리
	EmployeeVO getLoginEmployee(Map<String, String> paraMap);

	//회원 추가
	int insert_employee(EmployeeVO empvo);

	// === 부서번호, 부서명 알아오기 === //
	List<Map<String, String>> departmentno_select();

	// === 직급번호, 직급명 알아오기 === // 
	List<Map<String, String>> positionno_select();

	// === 팀 번호, 팀명 알아오기 === //
	List<Map<String, String>> teamno_select();

	// === 부서번호별 팀번호 알아오기 ===
	List<Map<String, String>> teamNo_seek_BydepartmentNo(String departmentNo);

	//회원가입시 해당 연도에 연차 insert 해주기
	int insert_annual(String employeeNo);
	
	// === 내 정보 수정하기 === //
	int updateInfoEnd(EmployeeVO empvo);

	
	// === 주소록 추가 === //
	int insert_addressBook(AddressBookVO adrsVO);

	// ===== 전체 주소록 보여주기 ======
	List<Map<String, String>> all_address_data_list(String fk_employeeNo);
	
	// ==== 부서별 주소록 목록 가져오기 ====
	List<Map<String, String>> department_address_data(String fk_employeeNo);

	// ==== 외부 주소록 목록 가져오기 ====
	List<Map<String, String>> external_address_data(String fk_employeeNo);

	
}
