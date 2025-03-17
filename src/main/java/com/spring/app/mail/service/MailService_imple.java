package com.spring.app.mail.service;


import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

import com.spring.app.mail.domain.MailFileVO;
import com.spring.app.mail.domain.MailVO;
import com.spring.app.mail.model.MailDAO;

import jakarta.servlet.ServletContext;


// === 서비스 선언 === //
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단
@Service
public class MailService_imple implements MailService {
	
	@Autowired
	private MailDAO mailDAO;
	
	@Autowired
	private ServletContext servletContext;
	
	// 전체 메일
	@Override
	public List<MailVO> mailListAll() {

		List<MailVO> mailList = mailDAO.mailListAll();
		
		return mailList;
	}

	
	// 받은 메일 개수 조회
	@Override
	public int getTotalCount() {
		
		int totalCount = mailDAO.getTotalCount();
		
		return totalCount;
	}


	// 받은 메일 목록 조회
	@Override
	public List<MailVO> selectMailList(Map<String, String> paraMap) {
		
		List<MailVO> ReceivedMailList = mailDAO.selectMailList(paraMap);
		
		return ReceivedMailList;
		
	}

	// 안 읽은 메일 개수 조회
	@Override
	public int getUnreadCount() {
		
		int unreadCount = mailDAO.getUnreadCount();
		
		return unreadCount;
	}


	// 중요(별) 상태 변경
	@Override
	public int toggleImportant(int mailNo) {

        // 현재 importantStatus 조회
        int currentStatus = mailDAO.getImportantStatus(mailNo);
        // 1이면 0으로, 0이면 1로 토글
        int importantStatus = (currentStatus == 1) ? 0 : 1;
        
        // DB 업데이트
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("mailNo", mailNo);
        paramMap.put("importantStatus", importantStatus);
        
        mailDAO.updateImportantStatus(paramMap);

        // 변경된 상태값 반환
        return importantStatus;
	}

	
	// 중요(별) 상태 메일 조회
	@Override
	public List<MailVO> selectImportantMail(String empNo) {
        
        List<MailVO> result = mailDAO.selectImportantMail(empNo);
        
        System.out.println("service에서 반환된 중요 메일 개수: " + result.size());
        
        return result;
	}


	// 읽음 상태 변경
	@Override
	public int toggleReadMail(int mailNo) {
		
        // 현재 readtStatus 조회
        int currentStatus = mailDAO.getReadStatus(mailNo);
        // 1이면 0으로, 0이면 1로 토글
        int readStatus = (currentStatus == 1) ? 0 : 1;
        
        // DB 업데이트
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("mailNo", mailNo);
        paramMap.put("readStatus", readStatus);
        
        mailDAO.updateReadStatus(paramMap);

        // 변경된 상태값 반환
        return readStatus;
	}


	// 읽은 메일 조회
	@Override
	public List<MailVO> selectReadMail(String empNo) {

        // DAO 호출
        return mailDAO.selectReadMail(empNo);
	}

	
	// 특정 메일 1개 조회
	@Override
	public MailVO viewMail(Map<String, String> paraMap) {

		MailVO mailvo = mailDAO.viewMail(paraMap);  // 메일 1개 조회하기
		
		return mailvo;
	}


	// 한개 메일 첨부파일의 파일명, 기존파일명, 새로운파일명, 파일사이즈 얻어오기
	@Override
	public List<MailFileVO> getMailFile(Map<String, String> paraMap) {
		
		return mailDAO.getMailFile(paraMap); 
	}


	// 메일 정렬 버튼 클릭시 정렬
	@Override
	public List<MailVO> mailListSort(Map<String, String> paramMap) {
		/*
		List<MailVO> mailSort = mailDAO.mailListSort(paramMap);
		return mailSort;
		*/
		
		// 위 아래 방식은 같다
		
		return mailDAO.mailListSort(paramMap);
	}


	// 메일 내용 조회시 읽음 으로 상태 변경
    @Override
    public void updateReadStatus(int mailNo, int readStatus) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mailNo", mailNo);
        paramMap.put("readStatus", readStatus);

        mailDAO.updateReadStatus(paramMap);
    }


    // 체크된 메일 deleteStatus 1로 업데이트
    @Override
    public int deleteMailStatus(List<Integer> mailNoList) {
    	
        Map<String, Object> map = new HashMap<>();
        map.put("mailNoList", mailNoList);  // mailNoList를 Map에 담아 매퍼에 전달
        return mailDAO.updateCheckDeleteStatus(mailNoList);
    }


    // deleteStatus 1 인것만 조회 (휴지통)
    @Override
    public List<MailVO> selectDeletedMail() {
    	
        return mailDAO.selectDeletedMail();
    }


    // 페이지 동적 개수 조회
	@Override
	public int getMailCount(Map<String, String> paraMap) {

		return mailDAO.getMailCount(paraMap);
	}


	// 체크된 메일 readStatus 1로 업데이트
	@Override
	public int readMailStatus(List<Integer> mailNoList) {
		
		// DAO 호출
        return mailDAO.updateCheckReadStatus(mailNoList);
	}


	// 체크박스 체크된 메일 readStatus 1로 업데이트 하고 아이콘 변경
	@Override
	public List<MailVO> getUpdatedMailStatus(List<Integer> mailNoList) {

		return mailDAO.getUpdatedMailStatus(mailNoList);
	}


    // 메일 작성 기능 구현
	@Override
	@Transactional
	public void sendMail(int mailNo, List<Map<String, Object>> referencedList, List<Map<String, Object>> fileList) {
	    // 참조자 저장
	    if (referencedList != null) {
	        for (Map<String, Object> refMap : referencedList) {
	            mailDAO.insertReferenced(refMap);
	        }
	    }

	    // 첨부파일 저장
	    if (fileList != null) {
	        for (Map<String, Object> fileMap : fileList) {
	            mailDAO.insertMailFile(fileMap);
	        }
	    }
	}

    // 메일 저장
    @Override
    @Transactional
    public void insertMail(MailVO mail) {
        mailDAO.insertMail(mail); // 메일 정보 저장 (mailNo 자동 생성)
    }

    // 참조자 정보 저장
    @Override
    public void insertReferenced(Map<String, Object> referencedMap) {
    	mailDAO.insertReferenced(referencedMap);
    }

    // 첨부파이 정보 저장
    @Override
    @Transactional
    public void insertMailFile(Map<String, Object> mailFileMap) {
        mailDAO.insertMailFile(mailFileMap);
    }


    
    // 이름으로 employeeNo 조회
	@Override
	public Integer findEmployeeNoByName(String name) {
		
	    Object result = mailDAO.findEmployeeNoByName(name);
	    if (result instanceof Number) {
	        return ((Number) result).intValue();
	    } else if (result != null) {
	        return Integer.parseInt(result.toString());
	    }
	    return null; // 또는 기본값
	}
	
	// 보낸 메일함 조회
    @Override
    public List<MailVO> selectSentMail(Map<String, String> paraMap) {
        return mailDAO.selectSentMail(paraMap);
    }

    // 보낸 메일 개수 조회
    @Override
    public int getSentMailCount(String senderNo) {
        return mailDAO.getSentMailCount(senderNo);
    }
    
    // 받은 메일 조회
    @Override
    public List<MailVO> getReceivedMailList(int loginEmployeeNo) {
        return mailDAO.selectReceivedMailList(loginEmployeeNo);
    }
    
    
    // 읽은메일, 중요메일, 임시저장 비율 구해오기
 	@Override
 	public Map<String, String> selectMail(String fk_employeeNo) {
 		Map<String, String> map = mailDAO.selectMail(fk_employeeNo);
 		return map;
 	}


 	// 해당 유저의 중요, 읽은, 임시저장함 개수 알아오기
 	@Override
 	public List<Map<String, String>> getMailCnt(String employeeno) {
 		List<Map<String, String>> map = mailDAO.getMailCnt(employeeno);
 		return map;
 	}


 	// 이메일 검색
	@Override
	public List<MailVO> searchMail(String searchWord) {
		List<MailVO> map = mailDAO.searchMail(searchWord);
		return map;
	}
    
    

}
