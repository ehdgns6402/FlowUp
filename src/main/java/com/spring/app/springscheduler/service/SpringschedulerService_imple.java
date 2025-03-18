package com.spring.app.springscheduler.service;


import java.sql.SQLException;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.spring.app.common.AES256;
import com.spring.app.common.GoogleMail;
import com.spring.app.springscheduler.model.SpringschedulerDAO;

@Service
public class SpringschedulerService_imple implements SpringschedulerService {

	@Autowired
	public SpringschedulerDAO dao;
	
	@Autowired
	public GoogleMail mail;
	
	@Autowired
	private AES256 aes;

	@Scheduled(cron = "00 59 23 * * *")
	@Override
	public void scheduler_endtime_update() { // 자동 퇴근 찍기
		
		// 퇴근 안찍고 퇴근 한놈들 퇴근시간 18:00시로 변경
		dao.scheduler_endtime_update_noClick();
		
		// 
		List<Map<String, String>> mapList = dao.scheduler_getOverTimeYN();
		
		for(Map<String, String> map: mapList) {
			
			if( map.get("overTimeYN") == "0") { // 연장근무 x
				
				dao.scheduler_endtime_update_noDraft(map.get("FK_employeeNo")); // + 연장근무 신청 안하고 퇴근 늦게 찍은놈들 퇴근시간 18:00시로 변경
			}
			else {								// 연장근무 승인 o
		
				dao.scheduler_endtime_update_draft(map.get("FK_employeeNo")); // 연장근무 승인했지만 21시 이후로 찍은사람들 21시로 변경
				
			}
			
		}
		
	}// end of scheduler_endtime_update()
	
//	@Scheduled(cron = "0 * * * * *")// 테스트용
	@Scheduled(cron = "00 00 01 * * *")
	@Override
	public void scheduler_absenceCnt_insert() { // 무단결근 insert
		
			// 어제 누군가 출근 했다면 평일 이라고 가정
			int n = dao.scheduler_yesterday_workYN();
			
			System.out.println("n : " + n);
			
			
			if(n > 0) {
				
				// 재직중인 모든 직원 리스트
				List<String> employeeList = dao.scheduler_getEmployeeList();
				
				for(String employeeNo : employeeList) {
					
					System.out.println("employeeNo : " + employeeNo );
					
					try {
					// 어제자 결근 insert 
					dao.scheduler_absence_insert(employeeNo); // 어제자 전직원 insert (사번+날짜 복합UQ로 인해 출근한 사람은 insert되지않는다.)
					}
					catch (Exception e) {
						System.out.println( "insert가 UQ 중복으로 안됌" );
					}
					
				}
			}

		
	}// end of scheduler_endtime_update()
	
//	@Scheduled(cron = "0 * * * * *") 테스트용
	@Scheduled(cron = "00 00 00 31 12 *")
	@Override
	public void scheduler_newYear_annual_insert() {
		
		LocalDate current_date = LocalDate.now();
		int current_Year = current_date.getYear();
		int next_Year = current_Year+1;
		String nextYear = next_Year+"";
		
		// 모든 직원 정보를 불러오는 메소드
		List<Map<String, String>> empList = dao.getEmpInfo();
		
		String failList = "";
		int cnt = 0;
		for(Map<String, String> empMap : empList) {
			
			String employeeNo = empMap.get("employeeNo");
			String regYear = empMap.get("regYear");
			String totalAnnual = empMap.get("totalAnnual");
			String usedAnnual = empMap.get("usedAnnual");
			String remainingAnnual = empMap.get("remainingAnnual");
			String name = empMap.get("name");
			
			int n_regYear = Integer.parseInt(regYear);
			int occurAnnual = 15 + (int)( ( current_Year - n_regYear - 1 ) / 2 );

			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("employeeNo", employeeNo);
			paraMap.put("occurAnnual", occurAnnual+"");
			paraMap.put("overAnnual", remainingAnnual);
			
			
			int n =	dao.insertAnnual(paraMap);
			
			if(n==0) {
				System.out.println("※ 사번 : " + employeeNo + " 이름 : " + name + " 님의 "+ nextYear +"년 연차정보 insert 에 실패 했습니다 ! ! !");
				
				if(cnt==0) {
					failList += employeeNo;
				}
				else {
					failList += ","+employeeNo;
				}
				cnt++;
			}
			
		}	// for
		System.out.println("insert 실패 사번 리스트 : " + failList);
		
	} // end of newYear_annual_insert()
	
	
	
//	@Scheduled(cron = "0 * * * * *")// 테스트용
	@Scheduled(cron = "00 00 00 10 * *")
	@Override
	public void scheduler_monthly_payment_insert() {
	
		// 모든 회원의 지난달 근무 정보 가져오기
		List<Map<String, String>> empAnnaulList = dao.getEmpAnnualInfo();
	
		for(Map<String, String> empAnnaulMap : empAnnaulList) {
			
			int overtimePay = (int)(Double.parseDouble(empAnnaulMap.get("salary")) / 360 / 24 * 1.5 * (Double.parseDouble(empAnnaulMap.get("total_overtime_seconds")) / 3600 ) );
			int monthSalary = (int) (Double.parseDouble(empAnnaulMap.get("salary")) / 12 );
			
			String str_overtimePay = overtimePay+"";
			String str_monthSalary = monthSalary+"";
			
			empAnnaulMap.put("overtimePay", str_overtimePay);
			empAnnaulMap.put("monthSalary", str_monthSalary);
			
			/*
			 * System.out.println("employeeNo : "+empAnnaulMap.get("employeeNo"));
			 * System.out.println("name : "+empAnnaulMap.get("name"));
			 * System.out.println("departmentName : "+empAnnaulMap.get("departmentName"));
			 * System.out.println("positionName : "+empAnnaulMap.get("positionName"));
			 * System.out.println("salary : "+empAnnaulMap.get("salary"));
			 * System.out.println("monthSalary : "+empAnnaulMap.get("monthSalary"));
			 * System.out.println("overtimePay : "+overtimePay);
			 */
			
			String workRange = dao.getWorkRange(empAnnaulMap);
			empAnnaulMap.put("workRange", workRange);
			
			try {
				dao.scheduler_monthly_payment_insert(empAnnaulMap);
			} catch (Exception e) {}
				
			
			
		}
		
	}
		
	
	
			
}
		
		
		
		
	

