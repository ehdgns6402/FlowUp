package com.spring.app.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestParam;

import com.spring.app.board.domain.BoardVO;
import com.spring.app.board.domain.NotificationVO;
import com.spring.app.board.domain.PostFileVO;
import com.spring.app.board.domain.PostVO;

public interface BoardService {
	
	// 게시판 생성하기
	int addBoard(BoardVO boardvo) throws Exception;

	// 게시판 수정하기
	int updateBoard(Map<String, String> map) throws Exception;

	// 게시판삭제(비활성화)하기(status 값변경)
	int disableBoard(String boardNo);
	
	//게시판 생성의 공개여부 부서 설정 시 부서 워드 검색(부서 검색)
	List<Map<String, String>> addBoardSearchDept(Map<String, String> paraMap);

	//게시판 생성의 공개여부 부서 설정 시 부서 전체 검색(부서 검색)
	List<Map<String, String>> addBoardSearchAllDept();

	// 생성된 게시판 LeftBar에 나열하기 (출력)
	List<BoardVO> selectBoardList(String login_departNo);
	
	// 수정할 input 요소에 기존값을 뿌려주기 위함.
	BoardVO getBoardDetailByNo(String boardNo);

	// 글쓰기 시 글작성 할 (접근 권한있는)게시판 목록 <select> 태그에 보여주기
	List<Map<String, String>> getAccessibleBoardList(String employeeNo, String login_userid) throws Exception;

	// 게시글 등록하기
	int addPost(PostVO postvo,PostFileVO postfilevo,List<Map<String, Object>> mapList);

	// 게시판 메인 페이지에 뿌려줄 모든 게시글 조회
	List<PostVO> selectAllPost(Map<String, String> paraMap);

	// 총 게시물 건수 (totalCount)
	int getTotalCount();

	// 게시글 하나 조회하기
	PostVO goViewOnePost(Map<String, String> paraMap);

	// 글 하나의 첨부파일 기존파일명,새로운 파일명 추출
	List<PostFileVO> getFileOfOnePost(Map<String, String> paraMap);

	// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
	PostVO getView_no_increase_readCount(Map<String, String> paraMap);

	// 실제 첨부파일을 삭제하기위해 첨부파일명을 알아오기.
	List<Map<String, Object>> getView_delete(String postNo);

	 // 파일첨부, 사진이미지가 들었는 경우의 글 삭제하기
	int postDel(Map<String, String> paraMap,List<Map<String, Object>> postListmap);

	// 파일다운로드에 필요한 컬럼 추출하기(파일고유번호,새로운파일명,기존파일명)
	PostFileVO getWithFileDownload(Map<String, String> paraMap);

	// === 글수정하기, 일단 게시글 update 이후 첨부파일의 여부는 service단에서 함  === //
	int updatePost(PostVO postvo, PostFileVO postfilevo, List<Map<String, Object>> mapList);

	// 글 수정에서 첨부파일 삭제하기
	int FileDelOfPostUpdate(Map<String, String> paraMap);

	// 수정 전 이미지 목록 가져오기 (DB에서 조회)
	List<String> getBeforeUpdateFileNames(String postNo);

	// 수정 후 새로운 이미지 목록 추출 (db에서 조회)
	List<String> getAfterUpdateFileNames(String postNo);

	// 수정하기에서 사진이미지가 들었는 경우 실제 경로의 파일 삭제하기
	void postImgFileDel(Map<String, String> paraMap, String fileName);

	// 게시판 별 게시글 조회 :: 게시판/게시글 테이블 조인 -> 조건 boardNo 인 것만 조회
	List<PostVO> selectPostBoardGroup(Map<String, String> paraMap);

	// 게시판의 정보를 추출하기 위해(게시판명, 운영자 등등)
	BoardVO getBoardInfo(String boardNo);
	
	//해당 게시판의 총 게시물 건수(totalCount) 구하기
	int getBoardGroupPostTotalCount(String boardNo);

	// 좋아요를 추가 또는 삭제함
	Map<String, Object> toggleLike(String postNo, String login_userid,String notificationtype,String fk_employeeNo);

	// 로그인 된 사원이 해당 게시글에 좋아요 여부를 검사.
	int checkLike(String login_userid, String postNo);

	// 좋아요 누른 사람(사원) 조회
	List<Map<String, Object>> getLikeList(String postNo);

	// 댓글 등록
	int insertComment(String postNo, String login_userid, String login_name, String commentContent,String fk_employeeNo, String fk_commentNo,String notificationtype);

	// 해당 게시글의 댓글 조회
	List<Map<String, Object>> getComment(String postNo,int start,int end);

	// 댓글 수정하기
	int updateComment(String commentNo,String content);

	// 댓글 삭제하기 ( 대댓글 개발 시  대댓글까지 삭제(status 값 변경) 추가해야 함.)
	int deleteComment(String commentNo,String depthNo,String postNo);

	// 대댓글 등록
	int insertReComment(String postNo, String login_userid, String login_name, String replyContent, String fk_commentNo,String depthNo,String notificationtype,String postCreateBy);

	// 댓글 개수 
	int getCommentCount(String postNo);

	// 부서별 공개일 경우 게시판 생성하기
	void addDepartmentBoard(BoardVO boardvo, List<Integer> departmentNoList);

	// 수정하는 게시판에 접근할 수 있는 부서를 알아옴
	List<Map<String, String>> getboardAccessList(String boardNo);

	// 부서별 공개일 경우 권한이 부여된 부서 모두 삭제 
	void deleteDepartmentBoard(HashMap<String, String> map);

	// 부서별 공개일 경우 게시판 삭제후 insert하기
	void addDepartmentBoard_2(HashMap<String, String> map, List<Integer> departmentNoList);

	// 좋아요 상위 5개 글
	List<Map<String, String>> getTopLikedPosts();

	// 조회수 상위 5개 글
	List<Map<String, String>> getTopReadPosts();

	// 로그인된 사원번호로 읽지않은 해당 알림 조회
	List<NotificationVO> loadNotification(String login_userid);

	// 클릭 된 알림을 0(안읽음)에서 1(읽음)으로 상태 변경
	int notificationIsRead(String notificationNo);

	// 알림의 해당글 클릭 시 글조회수 1증가 하기
	int increase_readCount(String postNo);

	//댓글 상위 5개 글 
	List<Map<String, String>> getTopCommentPosts();

	// 알림의 전체읽기 클릭 시 알림을 모두 읽음 처리
	int goNotificationReadAll(String login_userid);


	// 게시판 메인 페이지에 뿌려줄 모든 게시글 조회 
	List<PostVO> selectAllPostMain(Map<String, String> paraMap);

	// 게시판 검색
	List<PostVO> searchBoard(String searchWord);
	

	
	
	
}
