package com.spring.app.board.service;


import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.app.board.domain.BoardVO;
import com.spring.app.board.domain.LikeVO;
import com.spring.app.board.domain.NotificationVO;
import com.spring.app.board.domain.PostFileVO;
import com.spring.app.board.domain.PostVO;
import com.spring.app.board.model.BoardDAO;
import com.spring.app.common.FileManager;


// === 서비스 선언 === //
// 트랜잭션 처리를 담당하는 곳, 업무를 처리하는 곳, 비지니스(Business)단
@Service
public class BoardService_imple implements BoardService {
	
	@Autowired
	private BoardDAO dao;
	
	@Autowired
	private FileManager FileManager;

	// 게시판 생성하기
	@Override
	public int addBoard(BoardVO boardvo) throws Exception {
		int n = dao.addBoard(boardvo);
		return n;
	}
	
	// 게시판 수정하기
	@Override
	public int updateBoard(Map<String, String> map) throws Exception {
		int n = dao.updateBoard(map);
		return n;
	}

	// 게시판삭제(비활성화)하기(status 값변경)
	@Override
	public int disableBoard(String boardNo) {
		int n = dao.disableBoard(boardNo);
		int n2 = 0;
		
		if(n>0) {
			dao.delPostOfBoard(boardNo); // 게시판 삭제 시 해당 게시판의 게시글 전부 삭제(상태변경)
			
			dao.delCommentOfBoard(boardNo); // 게시글의 댓글 전부 삭제(상태변경)
		}
		
		return n;
	}

	//게시판 생성의 공개여부 부서 설정 시 해당 부서 키워드검색(부서 검색)
	@Override
	public List<Map<String, String>> addBoardSearchDept(Map<String, String> paraMap) {
		List<Map<String, String>> wordList = dao.addBoardSearchDept(paraMap);
		return wordList;
	}

	//게시판 생성의 공개여부 부서 설정 시 부서 전체 검색(부서 검색)
	@Override
	public List<Map<String, String>> addBoardSearchAllDept() {
		List<Map<String, String>> wordList = dao.addBoardSearchAllDept();
		return wordList;
	}

	// 생성된 게시판 LeftBar에 나열하기 (출력)
	@Override
	public List<BoardVO> selectBoardList(String login_departNo) {
		List<BoardVO> boardList = dao.selectBoardList(login_departNo);
		return boardList;
	}

	// 수정할 input 요소에 기존값을 뿌려주기 위함.
	@Override
	public BoardVO getBoardDetailByNo(String boardNo) {
		BoardVO boardvo = dao.getBoardDetailByNo(boardNo);
		return boardvo;
	}

	// 글쓰기 시 글작성 할 (접근 권한있는)게시판 목록 <select> 태그에 보여주기
	@Override
	public List<Map<String, String>> getAccessibleBoardList(String employeeNo, String login_userid) throws Exception{
		List<Map<String, String>> boardList = dao.getAccessibleBoardList(employeeNo,login_userid);
		return boardList;
	}
	
	// 게시글 등록하기// 파일첨부가 있는 글쓰기 // 첨부파일이 있다면 첨부파일테이블(tbl_postFile) 테이블에 파일 정보 삽입  
	@Override
	public int addPost(PostVO postvo,PostFileVO postfilevo,List<Map<String, Object>> mapList) {
		int n = dao.addPost(postvo); // 먼저 게시글 등록
		int n2=0;
		
		if(n>0) { //게시글 등록이 성공했을 때만 첨부파일 등록
			Map<String, Object> paraMap = new HashMap<>();
			postvo = dao.getInfoPost(); // 등록되는 게시글의 번호를 알아오기 위해
			paraMap.put("postNo", postvo.getPostNo()); // postNo 추가

		    if (mapList != null) {
		    	for (Map<String, Object> filename : mapList) {
		        	Map<String, Object> fileMap = new HashMap<>(); // 개별 파일 정보 저장용
		        	fileMap.put("postNo", postvo.getPostNo());
		        	fileMap.put("newFileName", filename.get("newFileName"));
		        	fileMap.put("originalFilename", filename.get("originalFilename")); // 원본 파일명 추가
		        	fileMap.put("fileSize", ((byte[]) filename.get("bytes")).length); // 파일 크기 저장
		        	
		        	n2 = dao.addPostInsertFile(fileMap); // 첨부파일 테이블에 파일정보 삽입
		        	
		        	if(n2!=0) {
			            //System.out.println("파일이 저장 됐음! 저장된 파일명 : " + filename);
		        	}
		        }
		    }
			
			
		}
		return n;
	}

	// 게시판 메인 페이지에 뿌려줄 모든 게시글 조회
	@Override
	public List<PostVO> selectAllPost(Map<String, String> paraMap) {
		List<PostVO> postAllList = dao.selectAllPost(paraMap);
		
		if (paraMap.get("login_userid") != null) {
	        List<Integer> likedPosts = dao.getLikedPosts(paraMap.get("login_userid") ); // 로그인한 사원이 좋아요한 게시글 조회
	        
	        // 좋아요한 게시글 목록을 Set으로 변환
	        Set<Integer> likedPostSet = new HashSet<>(likedPosts);
	        /*
	         PostVO의 필드(setter를 통해 설정하는 값)가 아니라, 좋아요 여부를 확인하기 위해 임시로 만든 Set
	         PostVO의 liked 필드를 setLiked(true/false)로 설정할 때 사용
	         */

	        // 게시글 목록에 좋아요 상태 추가
	        for (PostVO post : postAllList) {
	            boolean isLiked = likedPostSet.contains(Integer.valueOf(post.getPostNo())); // 강제 변환 후 비교
	            post.setLiked(isLiked); //여기가 Setter 사용 부분
	        }

	    }
		
		return postAllList;
	}

	// 총 게시물 건수 (totalCount)
	@Override
	public int getTotalCount() {
		int totalCount = dao.getTotalCount();
		return totalCount;
	}

	// 게시글 하나 조회하기
	@Override
	public PostVO goViewOnePost(Map<String, String> paraMap) {
		PostVO postvo = dao.goViewOnePost(paraMap);  // 글 1개 조회하기
		
		String login_userid = paraMap.get("login_userid");
		
		if(login_userid != null &&
				postvo != null &&
		  !login_userid.equals(postvo.getFk_employeeNo() )) {
		  // 글조회수 증가는 로그인을 한 상태에서 다른 사람의 글을 읽을때만 증가.
			
		  int n = dao.increase_readCount(paraMap.get("postNo")); // 글조회수 1증가 하기 
		
		  if(n==1) {
			  postvo.setReadCount( String.valueOf(Integer.parseInt(postvo.getReadCount()) + 1) ); 
		  }
		}
		
		return postvo;
	}

	// 글 조회수 증가는 없고 단순히 글 1개만 조회를 해오는 것
	@Override
	public PostVO getView_no_increase_readCount(Map<String, String> paraMap) {

		PostVO postvo = dao.goViewOnePost(paraMap);  // 글 1개 조회하기
		
		return postvo;
	}
	
	// 실제 첨부파일을 삭제하기위해 첨부파일명을 알아오기.
	@Override
	public List<Map<String, Object>> getView_delete(String postNo) {
		List<Map<String, Object>> postListmap = dao.getView_delete(postNo);
		return postListmap;
	}

	// 파일첨부, 사진이미지가 들었는 경우의 글 삭제하기
	@Override
	public int postDel(Map<String, String> paraMap,List<Map<String, Object>> postListmap) {
		
		
		int deleteCount = 0; // 댓글테이블에서 삭제된 행의 개수
		Map<String, Integer> map = new HashMap<>();
		
		int n = dao.postDel(paraMap.get("postNo")); // post 테이블에서 상태를 삭제(변경)하기 
		if(n>0) {
			dao.postFileDel(paraMap.get("postNo")); // postFile 테이블에서 상태를 삭제(변경)하기 
			
			deleteCount = dao.delCommentOfPost(paraMap.get("postNo"));// 게시글 하나 삭제 시 해당 게시글 댓글의 상태를 삭제(변경)하기
			
			map.put("deleteCount", deleteCount); // 차감할 수
			map.put("postNo", Integer.parseInt(paraMap.get("postNo")));
			
			dao.updateMinusCommentCount(map); // 삭제된 행의 개수만큼 해당 게시글의 댓글개수를 차감
		}
		else{
			System.out.println("게시글 행 삭제 전 댓글/대댓글의 상태변경을 실패하였습니다.");
		}
		
		// === 첨부파일 및 사진이미지 파일 삭제하기 시작 === //
		
	    if (postListmap != null && !postListmap.isEmpty()) { // 첨부파일이 있다면 삭제하기 
	        String filepath = paraMap.get("filepath"); // 저장된 경로
	        
	        for (Map<String, Object> filename : postListmap) {
	            if (filename != null) {
	                try {
	                    FileManager.doFileDelete((String) filename.get("filename"), filepath);// 삭제해야할 첨부파일이 저장된 경로와 삭제해야할 첨부파일명
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }
	            }
	        } // end of for (Map<String, Object> filename : postListmap) {}----------------
			///////////////////////////////////////////
			
			// 글내용에 사진이미지가 들어가 있는 경우라면 사진이미지 파일도 삭제.
			String photofilename = paraMap.get("photofilename");
			
			if(photofilename != null) {
				String photo_upload_path = paraMap.get("photo_upload_path");
				
				if(photofilename.contains("/")) {
					// 사진이미지가 2개 이상인 경우
					
					String[] arr_photofilename = photofilename.split("[/]");
					
					for(int i=0; i<arr_photofilename.length; i++) {
						try {
							FileManager.doFileDelete(arr_photofilename[i], photo_upload_path);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					
				}
				else {
					// 사진이미지가 1개만 존재하는 경우
					try {
						FileManager.doFileDelete(photofilename, photo_upload_path);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			
			
			
		} // end of if (postListmap != null && !postListmap.isEmpty()) {}-------------
		// === 첨부파일 및 사진이미지 파일 삭제하기 끝 === //
		return n;
	}
	
	// 파일다운로드에 필요한 컬럼 추출하기(파일고유번호,새로운파일명,기존파일명)
	@Override
	public PostFileVO getWithFileDownload(Map<String, String> paraMap) {
		 PostFileVO postfilevo = dao.getWithFileDownload(paraMap); // 있는 메소드 사용함(게시글 번호,새로운 파일명,기존파일명을 추출함)
		return postfilevo;
	}

	// 글 하나의 첨부파일 기존파일명,새로운 파일명 추출
	@Override
	public List<PostFileVO> getFileOfOnePost(Map<String, String> paraMap) {
		List<PostFileVO> postfilevo = dao.getFileOfOnePost(paraMap); 
		return postfilevo;
	}
	
	// 게시글 수정하기// 파일첨부가 있는 글수정 // 첨부파일이 있다면 첨부파일테이블(tbl_postFile) 테이블에 파일 정보 수정 
	@Override
	public int updatePost(PostVO postvo,PostFileVO postfilevo,List<Map<String, Object>> mapList) {
		int n = dao.updatePost(postvo); // 먼저 게시글 수정
		int n2=0;
		
		if(n>0) { //게시글 수정이 성공했을 때만 첨부파일 등록
			Map<String, Object> paraMap = new HashMap<>();
			//postvo = dao.getInfoPost(); // 등록되는 게시글의 번호를 알아오기 위해
			paraMap.put("postNo", postvo.getPostNo()); // postNo 추가

			int n1 = dao.selectTblPostFile(postvo.getPostNo()); // update 문을 실행 전 해당 행이 있는지 확인하기 위함.	(하다보니 필요하지않지만 보류)
			
		    if (mapList != null) {
		    	for (Map<String, Object> filename : mapList) {
		    		
		        	Map<String, Object> fileMap = new HashMap<>(); // 개별 파일 정보 저장용
		        	
		        	fileMap.put("postNo", postvo.getPostNo());
		        	fileMap.put("newFileName", filename.get("newFileName"));
		        	fileMap.put("originalFilename", filename.get("originalFilename")); // 원본 파일명 추가
		        	fileMap.put("fileSize", ((byte[]) filename.get("bytes")).length); // 파일 크기 저장
		        	
		        	
		        	// 파일테이블에 행이 없을 경우
		        	dao.addPostInsertFile(fileMap); // 첨부파일 테이블에 파일정보 삽입
		        	
		        	if(n2!=0) {
			            //System.out.println("파일이 저장 됐음! 저장된 파일명 : " + filename);
		        	}
		        }
		    }
			
			
		}
		return n;
	}

	// 글 수정에서 첨부파일 삭제하기
	@Override
	public int FileDelOfPostUpdate(Map<String, String> paraMap) {
		int n = dao.FileDelOfPostUpdate(paraMap.get("postNo"),paraMap.get("fileNo")); // 글 수정하기에서 postFile 테이블에서 행삭제하기
		
		String filepath = paraMap.get("filepath"); // 저장된 경로
        
            if (paraMap.get("newFileName") != null) {
                try {
                    FileManager.doFileDelete((String) paraMap.get("newFileName"), filepath);// 삭제해야할 첨부파일이 저장된 경로와 삭제해야할 첨부파일명
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
		return n;
	}

	// 수정 전 이미지 목록 가져오기 (DB에서 조회)
	@Override
	public List<String> getBeforeUpdateFileNames(String postNo) {
		List<String> oldFileList = dao.getBeforeUpdateFileNames(postNo);
		return oldFileList;
	}

	// 2️ 수정 후 새로운 이미지 목록 추출 (db에서 조회)
	@Override
	public List<String> getAfterUpdateFileNames(String postNo) {
		List<String> newFileList = dao.getAfterUpdateFileNames(postNo);
		return newFileList;
	}

	// 수정하기에서 사진이미지가 들었는 경우 실제 경로의 파일 삭제하기
	@Override
	public void postImgFileDel(Map<String, String> paraMap, String fileName) {
		
		if(fileName != null) {
			String photo_upload_path = paraMap.get("photo_upload_path");
			if(fileName.contains("/")) {
				// 사진이미지가 2개 이상인 경우
				
				//String[] arr_photofilename = photofilename.split("[/]");
				
				try {
					FileManager.doFileDelete(fileName, photo_upload_path);
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
			else {
				// 사진이미지가 1개만 존재하는 경우
				try {
					FileManager.doFileDelete(fileName, photo_upload_path);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	// 게시판 별 게시글 조회 :: 게시판/게시글 테이블 조인 -> 조건 boardNo 인 것만 조회
	@Override
	public List<PostVO> selectPostBoardGroup(Map<String, String> paraMap) {
		List<PostVO> groupPostMapList =  dao.selectPostBoardGroup(paraMap);
		return groupPostMapList;
	}

	// 게시판의 정보를 추출하기 위해(게시판명, 운영자 등등)
	@Override
	public BoardVO getBoardInfo(String boardNo) {
		BoardVO boardInfoMap = dao.getBoardInfo(boardNo);
		return boardInfoMap;
	}

	//해당 게시판의 총 게시물 건수(totalCount) 구하기
	@Override
	public int getBoardGroupPostTotalCount(String boardNo) {
		int totalCount = dao.getBoardGroupPostTotalCount(boardNo);
		return totalCount;
	}

	// 좋아요를 추가 또는 삭제함
	@Override
	public Map<String,Object> toggleLike(String postNo, String login_userid,String notificationtype,String fk_employeeNo) {
		
		Map<String,Object> map = new HashMap<>();
		
		int n = 0;
		
		LikeVO likevo =  dao.getLikeInfo(postNo,login_userid); // 좋아요 테이블에서 로그인된 사원이 해당 게시글에 좋아요를 했는지 조회
		
		if(likevo != null) { // 조회가 된 경우 (좋아요를 누른 게시글)
			
			n = dao.removeLike(postNo,login_userid); // 좋아요 테이블에서 행 삭제(좋아요 삭제)
			
			if(n!=0) {
				n = dao.updatePostLikeMinusCnt(postNo); // 게시글테이블의 좋아요 수 차감
				map.put("likeStatus", 0);
			}
			
		}
		else { // 조회가 되지 않은 경우(좋아요가 안된 게시글)
			
			n = dao.addLike(postNo,login_userid); // 좋아요 테이블에서 행 추가(좋아요 추가)
			
			if(n!=0) {
				n = dao.updatePostLikeCnt(postNo); // 게시글테이블의 좋아요 수 누적
				map.put("likeStatus", 1);
				
				String replyContent= null;
				String fk_commentNo= null;
				
				if(!login_userid.equals(fk_employeeNo)) { // 로그인된 사원번호와 글 작성자가 같지 않을 시 실행 (본인이 작성한 것에 본인이 댓글 또는 좋아요 달 경우 실행 안됨)
				
					dao.insertNotificationInfo(postNo,login_userid,replyContent,fk_employeeNo,fk_commentNo,notificationtype); // 알림 테이블에 데이터 삽입
				
				}
			}
		}
		
		int likeCnt = dao.likeCnt(postNo); // 누적 또는 차감된 게시글의 좋아요 수
		map.put("likeCnt", likeCnt);
		
		return map;
	}

	//로그인 된 사원이 해당 게시글에 좋아요 여부를 검사.
	@Override
	public int checkLike(String login_userid, String postNo) {
		int likeCnt = dao.checkLike(login_userid,postNo);
		return likeCnt;
	}

	// 좋아요 누른 사람(사원) 조회
	@Override
	public List<Map<String, Object>> getLikeList(String postNo) {
		 List<Map<String,Object>> map = dao.getLikeList(postNo); // 좋아요 누른 사람(사원) 조회
		return map;
	}

	// 댓글 등록
	@Override
	public int insertComment(String postNo, String login_userid, String login_name, String commentContent,String fk_employeeNo, String fk_commentNo,String notificationtype) {
		int insertCount = dao.insertComment(postNo, login_userid, login_name,commentContent); // 댓글 등록
		
		if(insertCount>0) {
			dao.addCommentCount(postNo); // 해당 게시글의 댓글 개수 증감하기
			
			System.out.println(postNo);
			System.out.println(login_userid);
			System.out.println(commentContent);
			System.out.println(fk_employeeNo);
			System.out.println(fk_commentNo);
			System.out.println(notificationtype);
			
			if(!login_userid.equals(fk_employeeNo)) { // 로그인된 사원번호와 글 작성자가 같지 않을 시 실행 (본인이 작성한 것에 본인이 댓글 또는 좋아요 달 경우 실행 안됨)
				
				System.out.println("실행됨");
				
				dao.insertNotificationInfo(postNo,login_userid,commentContent,fk_employeeNo,fk_commentNo,notificationtype); // 알림 테이블에 데이터 삽입
				
			}
			
		}
		return insertCount;
	}

	// 해당 게시글의 댓글 조회
	@Override
	public List<Map<String, Object>> getComment(String postNo,int start,int end) {
		List<Map<String, Object>> commentList= dao.getComment(postNo,start,end); // 해당 게시글의 댓글 조회
		return commentList;
	}

	// 댓글 수정하기
	@Override
	public int updateComment(String commentNo,String content) {
		int updateCount = dao.updateComment(commentNo,content); // 댓글 수정하기
		return updateCount;
	}

	// 댓글 삭제하기
	@Override
	public int deleteComment(String commentNo,String depthNo,String postNo) {
		
		int deleteCount = 0 ;
		
		if(Integer.parseInt(depthNo) ==0) {
			deleteCount = dao.deleteComment(commentNo); // 댓글 삭제의 경우  where groupNo  = #{commentNo}
		}
		else {
			deleteCount = dao.deleteReComment(commentNo); //대댓글 삭제의 경우 where commentNo = #{commentNo}
		}
		
		Map<String,Integer> map = new HashMap<>();
		map.put("deleteCount", deleteCount);
		map.put("postNo", Integer.parseInt(postNo));
		
		if(deleteCount > 0) { // 삭제된 행이 있다면
			dao.updateMinusCommentCount(map); // 삭제된 행의 개수만큼 해당 게시글의 댓글개수를 차감
		}
		
		
		return deleteCount;
	}

	// 대댓글 등록
	@Override
	public int insertReComment(String postNo, String login_userid, String login_name, String replyContent,
	                           String fk_commentNo, String depthNo, String notificationtype, String postCreateBy) {

	    int insertCount = dao.insertReComment(postNo, login_userid, login_name, replyContent, fk_commentNo, depthNo); // 대댓글 등록

	    if (insertCount > 0) {
	        dao.addCommentCount(postNo); // 해당 게시글의 댓글 개수 증가

	        //  댓글 작성자에게 알림을 보내기 위한 사원 번호 조회 (알림받을 사원번호 추출)
	        String fk_employeeNo = dao.getNotificationReceiverEmployeeNo(fk_commentNo); // 대댓글이 달린 댓글의 작성자

	        //  댓글 작성자에게 알림 (자신이 작성한 글이 아닐 경우)
	        if (!login_userid.equals(fk_employeeNo)) { 
	            dao.insertNotificationInfo(postNo, login_userid, replyContent, fk_employeeNo, fk_commentNo, notificationtype);
	        }

	        //  게시글 작성자에게도 알림 (자신이 작성한 게시글이 아닐 경우)
	        if (!login_userid.equals(postCreateBy)) { 
	            dao.insertNotificationInfo(postNo, login_userid, replyContent, postCreateBy, fk_commentNo, notificationtype);
	        }
	    }

	    return insertCount;
	}

	// 댓글 개수 
	@Override
	public int getCommentCount(String postNo) {
		int commentCount = dao.getCommentCount(postNo);
		return commentCount;
	}

	// 부서별 공개일 경우 게시판 생성하기
	@Override
	public void addDepartmentBoard(BoardVO boardvo, List<Integer> departmentNoList) {
		for (int deptNo : departmentNoList) { // 리스트에는 부서번호 밖에 없음.
	        dao.addDepartmentBoard(boardvo, deptNo);
	    }

	}

	// 수정하는 게시판에 접근할 수 있는 부서를 알아옴
	@Override
	public List<Map<String, String>> getboardAccessList(String boardNo) {
		List<Map<String, String>> boardAccessList = dao.getboardAccessList(boardNo);
		return boardAccessList;
	}
	
	// 부서별 공개일 경우 권한이 부여된 부서 모두 삭제 
	@Override
	public void deleteDepartmentBoard(HashMap<String, String> map) {
		dao.deleteDepartmentBoard(map); 
	}

	// 부서별 공개일 경우 게시판 삭제후 insert하기
	@Override
	public void addDepartmentBoard_2(HashMap<String, String> map, List<Integer> departmentNoList) {
		for (int deptNo : departmentNoList) { // 리스트에는 부서번호 밖에 없음.
	        dao.addDepartmentBoard_2(map.get("boardNo"), deptNo);
//	        System.out.println(map.get("boardNo"));
	    }
	}
	
	// 좋아요 상위 5개 글
	@Override
	public List<Map<String, String>> getTopLikedPosts() {
		List<Map<String, String>> topLikeList = dao.getTopLikedPosts();
		return topLikeList;
	}
	
	// 조회수 상위 5개 글
	@Override
	public List<Map<String, String>> getTopReadPosts() {
		List<Map<String, String>> topReadList = dao.getTopReadPosts();
		return topReadList;
	}

	// 로그인된 사원번호로 읽지않은 해당 알림 조회
	@Override
	public List<NotificationVO> loadNotification(String login_userid) {
		List<NotificationVO> ListNotificationVO= dao.loadNotification(login_userid); 
		return ListNotificationVO;
	}

	// 클릭 된 알림을 0(안읽음)에서 1(읽음)으로 상태 변경
	@Override
	public int notificationIsRead(String notificationNo) {
		int n = dao.notificationIsRead(notificationNo);
		return n;
	}

	// 알림의 해당글 클릭 시 글조회수 1증가 하기
	@Override
	public int increase_readCount(String postNo) {
		int n = dao.increase_readCount(postNo);
		return n;
	}

	// 댓글 상위 5개 글 
	@Override
	public List<Map<String, String>> getTopCommentPosts() {
		List<Map<String, String>> topCommentList = dao.getTopCommentPosts();
		return topCommentList;
	}

	// 알림의 전체읽기 클릭 시 알림을 모두 읽음 처리
	@Override
	public int goNotificationReadAll(String login_userid) {
		int n = dao.goNotificationReadAll(login_userid);
		return n;
	}

	

	
	// 게시판 메인 페이지에 뿌려줄 모든 게시글 조회
	@Override
	public List<PostVO> selectAllPostMain(Map<String, String> paraMap) {
		List<PostVO> list = dao.selectAllPostMain(paraMap);
		return list;
	}

	// 게시판 검색
	@Override
	public List<PostVO> searchBoard(String searchWord) {
		List<PostVO> list = dao.searchBoard(searchWord);
		return list;
	}
	
	
	
	
	
	
	
	
	
	
	


	
}
