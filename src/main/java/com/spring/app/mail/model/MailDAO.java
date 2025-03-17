package com.spring.app.mail.model;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.spring.app.mail.domain.MailFileVO;
import com.spring.app.mail.domain.MailVO;

@Mapper //@Mapper 어노테이션을 붙여서 DAO 역할의 Mapper 인터페이스 파일을 만든다. 
		//EmpDAO 인터페이스를 구현한 DAO 클래스를 생성하면 오류가 뜨므로 절대로 DAO 클래스를 생성하면 안된다.!!! 
		//@Mapper 어노테이션을 사용하면 빈으로 등록되며 Service단에서 @Autowired 하여 사용할 수 있게 된다.
public interface MailDAO {

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

	// 중요(별) 상태 조회
	int getImportantStatus(int mailNo);

	// 메일 중요 상태 업데이트
	void updateImportantStatus(Map<String, Object> paramMap);

	// 중요메일함 조회
	List<MailVO> selectImportantMail(String empNo);

	// 메일 읽음 상태 조회
	int getReadStatus(int mailNo);
	
	// 메일 읽음 상태 업데이트
	void updateReadStatus(Map<String, Object> paramMap);

	// 읽은 메일 조회
	List<MailVO> selectReadMail(String empNo);

	// 특정 메일 1개 조회
	MailVO viewMail(Map<String, String> paraMap);

	// 메일 정렬 방법 선택
	List<MailVO> mailListSort(Map<String, String> paramMap);

	// 체크된 메일 deleteStatus 1로 업데이트
	int updateCheckDeleteStatus(List<Integer> mailNoList);
	
	// deleteStatus 1 인것만 조회 (휴지통)
	List<MailVO> selectDeletedMail();

	// 체크된 메일 readStatus 1로 업데이트
	int updateCheckReadStatus(List<Integer> mailNoList);

	// 한개 메일 첨부파일의 파일명, 기존파일명, 새로운파일명, 파일사이즈 얻어오기
	List<MailFileVO> getMailFile(Map<String, String> paraMap);

	// 체크박스 체크된 메일 readStatus 1로 업데이트 하고 아이콘 변경
	List<MailVO> getUpdatedMailStatus(List<Integer> mailNoList);

	
	
	// 메일 작성
    // 메일 정보 저장
    void insertMail(MailVO mail);

    // 참조자 정보 저장
    void insertReferenced(Map<String, Object> referencedMap); // fk_adrsBNo 포함

    // 첨부 파일 정보 저장
    void insertMailFile(Map<String, Object> fileMap);

    // 메일 받은 사원 이름 조회
	Integer findEmployeeNoByName(String name);

	// 보낸 메일 조회
	List<MailVO> selectSentMail(Map<String, String> paraMap);

	// 보낸 메일 개수 조회
	int getSentMailCount(String senderNo);

	
    // 받은 메일 목록 조회
    List<MailVO> selectReceivedMailList(@Param("loginEmployeeNo") int loginEmployeeNo);

    
    
    // 읽은메일, 중요메일, 임시저장 비율 구해오기
 	Map<String, String> selectMail(String fk_employeeNo);

 	// 해당 유저의 중요, 읽은, 임시저장함 개수 알아오기
 	List<Map<String, String>> getMailCnt(String employeeno);

 	// 이메일 검색
	List<MailVO> searchMail(String searchWord);

	
}
