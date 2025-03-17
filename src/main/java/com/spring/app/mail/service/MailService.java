package com.spring.app.mail.service;

import java.util.List;
import java.util.Map;

import com.spring.app.mail.domain.MailFileVO;
import com.spring.app.mail.domain.MailVO;

public interface MailService {

	// 전체 메일
	List<MailVO> mailListAll();

	// 받은 메일 개수 조회
	int getTotalCount();

	// 받은 메일 목록 조회
	List<MailVO> selectMailList(Map<String, String> paraMap);
	
	// 페이지 동적 개수 조회
    int getMailCount(Map<String,String> paraMap);
    
	// 안 읽은 메일 개수 조회
	int getUnreadCount();

	// 중요(별) 상태 변경
	int toggleImportant(int mailNo);

	// 중요메일함 조회
	List<MailVO> selectImportantMail(String empNo);

	// 읽음 상태 변경
	int toggleReadMail(int mailNo);

	// 읽은 메일 조회
	List<MailVO> selectReadMail(String empNo);

	// 특정 메일 1개 조회
	MailVO viewMail(Map<String, String> paraMap);

	// 한개 메일 첨부파일의 파일명, 기존파일명, 새로운파일명, 파일사이즈 얻어오기
	List<MailFileVO> getMailFile(Map<String, String> paraMap);

	// 메일 정렬 방법 선택
	List<MailVO> mailListSort(Map<String, String> paramMap);

	// 메일 내용 조회시 읽음 으로 상태 변경
	void updateReadStatus(int mailNo, int i);

	// 체크된 메일 deleteStatus 1로 업데이트
	int deleteMailStatus(List<Integer> mailNoList);

	// deleteStatus 1 인것만 조회 (휴지통)
	List<MailVO> selectDeletedMail();

	// 체크된 메일 readStatus 1로 업데이트
	int readMailStatus(List<Integer> mailNoList);

	// 체크박스 체크된 메일 readStatus 1로 업데이트 하고 아이콘 변경
	List<MailVO> getUpdatedMailStatus(List<Integer> mailNoList);

    // 메일 작성 기능
    void sendMail(int mailNo, List<Map<String, Object>> referencedList, List<Map<String, Object>> fileList);

    // 메일 정보 저장 후 mailNo 반환
	void insertMail(MailVO mail);

	// 참조자 정보 저장
	void insertReferenced(Map<String, Object> ccMap);
	
	// 첨부 파일 정보 저장
	void insertMailFile(Map<String, Object> mailFileMap);

	// 이름으로 employeeNo 조회
	Integer findEmployeeNoByName(String name);

    // 보낸 메일 조회
	List<MailVO> selectSentMail(Map<String, String> paraMap);

	// 보낸 메일 개수 조회
	int getSentMailCount(String senderNo);



    // 받은 메일 목록 조회
    List<MailVO> getReceivedMailList(int loginEmployeeNo);

	
    
    // 읽은메일, 중요메일, 임시저장 비율 구해오기
 	Map<String, String> selectMail(String fk_employeeNo);

 	// 해당 유저의 중요, 읽은, 임시저장함 개수 알아오기
 	List<Map<String, String>> getMailCnt(String employeeno);

 	// 이메일 검색
	List<MailVO> searchMail(String searchWord);

}
