package com.spring.app.springscheduler.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

public interface SpringschedulerDAO {

	void scheduler_endtime_update_noClick();
	
	List<Map<String, String>> scheduler_getOverTimeYN();
	
	void scheduler_endtime_update_noDraft(String employeeNo);
	
	void scheduler_endtime_update_draft(String employeeNo);
	
	List<Map<String, String>> getEmpInfo();

	int insertAnnual(Map<String, String> paraMap);

	int scheduler_yesterday_workYN();

	List<String> scheduler_getEmployeeList();

	void scheduler_absence_insert(String employeeNo) throws Exception;

	List<Map<String, String>> getEmpAnnualInfo();

	void scheduler_monthly_payment_insert(Map<String, String> empAnnaulMap) throws Exception;

	String getWorkRange(Map<String, String> empAnnaulMap) ;

	



	

	

	


	
	
	
	
}
