package com.spring.app.chatting.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.spring.app.chatting.domain.MessageVO;
import com.spring.app.chatting.domain.Mongo_messageVO;
import com.spring.app.chatting.service.ChattingMongoOperations;
import com.spring.app.chatting.service.ChattingService;
import com.spring.app.employee.domain.EmployeeVO;

// === (#웹채팅관련6) ===

@Component
public class WebsocketEchoHandler extends TextWebSocketHandler {
	
    @Autowired
    private ChattingService chattingService;
	
	private final Map<String, List<WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
	
	// === 웹소켓서버에 연결한 클라이언트 사용자들을 저장하는 리스트 ===
	private List<WebSocketSession> connectedUsers = new ArrayList<>();
	
	// === 웹소켓 서버에 접속시 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위해 채팅에 접속한 MemberVO 를 저장하는 List   
	private List<EmployeeVO> employeevo_list = new ArrayList<>();
	
	// ========== 몽고DB 시작 ========== //
	// === (#웹채팅관련8) === //
	@Autowired
	private ChattingMongoOperations chattingMongo;
	
	@Autowired
	private Mongo_messageVO dto;
	
	// ========== 몽고DB 끝 ========== //
	
	// init-method
	public void init() throws Exception {}
	
	
	// === 클라이언트가 웹소켓서버에 연결했을때의 작업 처리하기 ===
	/*
		afterConnectionEstablished(WebSocketSession wsession) 메소드는 
				클라이언트가 웹소켓서버에 연결이 되어지면 자동으로 실행되는 메소드로서
		WebSocket 연결이 열리고 사용이 준비될 때 호출되어지는(실행되어지는) 메소드이다.
	*/
	
	@Override
	public void afterConnectionEstablished(WebSocketSession wsession) throws Exception {

	    String roomId = getRoomIdFromSession(wsession);
	    roomSessions.computeIfAbsent(roomId, k -> new CopyOnWriteArrayList<>()).add(wsession);
		
		connectedUsers.add(wsession);

		String connectingUserName = "「"; // 「 은 자음 ㄴ 을 하면 나온다. 
		
		for(WebSocketSession webSocketSession : connectedUsers) {
			Map<String, Object> map = webSocketSession.getAttributes();
			
			
			EmployeeVO loginuser = (EmployeeVO) map.get("loginuser");
			
			connectingUserName += loginuser.getName()+" ";
			
			// === 웹소켓 서버에 접속시 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 시작 === //
			if(employeevo_list.size() > 0) {
				boolean isExists = false;
				for(EmployeeVO employeevo : employeevo_list) {
					if(employeevo.getEmployeeNo().equals(loginuser.getEmployeeNo())) {
						isExists = true;
						break;
					}
				} // end of for---------------------------------------
				
				if(!isExists) {
					employeevo_list.add(loginuser);
				}
			}
			else {
				employeevo_list.add(loginuser);
			}
			
			// === 웹소켓 서버에 접속시 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 끝 === //
					
		} // end of for--------------
		
		connectingUserName += "」";
		
		System.out.println("~~ 확인용 connectingUserName : " + connectingUserName);
		
		for(WebSocketSession webSocketSession : connectedUsers) {
			webSocketSession.sendMessage(new TextMessage(connectingUserName));
		} // end of for--------------------------------
		
		// === 웹소켓 서버에 접속시 접속자 명단을 알려주기 위한 것 끝 === //
		
		
		// === 웹소켓 서버에 접속시 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 시작 === //
	      
		String v_html = "⊆";  // 'ㄷ'에 있는 것임
        if(employeevo_list.size() > 0) {
           for(EmployeeVO employeevo : employeevo_list) {
              v_html += "<tr>"
                    + "<td>"+employeevo.getEmployeeNo()+"</td>"
                    + "<td>"+employeevo.getName()+"</td>"
                    + "<td>"+employeevo.getEmail()+"</td>"
                    + "</tr>";
//           }
	           for(WebSocketSession webSocketSession : connectedUsers) {
	               webSocketSession.sendMessage(new TextMessage(v_html));
	           }// end of for------------------------
           }
        }
		// === 웹소켓 서버에 접속시 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 끝 === //
        
        // ========== 몽고DB 시작 ==========
        List<Mongo_messageVO> list = chattingMongo.listChatting();	// 몽고DB에 저장된 채팅내용(지난대화)을 읽어온다.
        
        SimpleDateFormat sdfrmt = new SimpleDateFormat("yyyy년 MM월 dd일 E요일", Locale.KOREAN);
        
        if(list != null && list.size() > 0) { // 이전에 나누었던 대화내용이 있더라면
        	for(int i=0; i<list.size(); i++) {
        		
        		System.out.println("확인용" + list.get(i).getCreated());
        		String str_created = sdfrmt.format(list.get(i).getCreated()); // 대화내용을 나누었던 날짜를 
        		
        		
        		System.out.println(list.get(i).getUserid() + "\n"
        						 + list.get(i).getName() + "\n"
        						 + list.get(i).getCurrentTime() + "\n"
        						 + list.get(i).getMessage() + "\n"
        						 + list.get(i).getCreated() + "\n"
        						 + str_created + "\n");
        		
        		
        		// ========================================================//
        		
        		boolean is_newDay = true;	// 대화내용의 날짜가 같은 날짜인지 새로운 날짜인지 알기위한 용도임.
        		
        		if(i>0 && str_created.equals(sdfrmt.format(list.get(i-1).getCreated())) ) { // 다음번 내용물에 있는 대화를 했던 날짜가 이전 내용물에 있는 대화를 했던 날짜와 같다라면
        			is_newDay = false; // 이 대화내용은 새로운 날짜의 대화가 아님을 표시한다.
        		}
        		
        		if(is_newDay) {
        			wsession.sendMessage(
        				new TextMessage("<div style='text-align: center; background-color: #ccc;'>" + str_created + "</div>")  
		            ); // 대화를 나누었던 날짜를 배경색을 회색으로 하여 보여주도록 한다.
        		}
        		
        		Map<String, Object> map = wsession.getAttributes();
                /*
                   wsession.getAttributes(); 은 
                   HttpSession에 setAttribute("키",오브젝트); 되어 저장되어진 값들을 읽어오는 것으로써,
                         리턴값은  "키",오브젝트로 이루어진 Map<String, Object> 으로 받아온다.
                */ 
        		
        		EmployeeVO loginuser = (EmployeeVO)map.get("loginuser");  
                // "loginuser" 은 HttpSession에 저장된 키 값으로 로그인 되어진 사용자이다.

        		
        		if(loginuser.getEmployeeNo().equals(list.get(i).getUserid())) {
        			// 본인이 작성한 채팅메시지일 경우라면.. 작성자명 없이 노랑배경색에 오른쪽 정렬로 보이게 한다.
                    
	                wsession.sendMessage(
	                	new TextMessage("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all;'>" + list.get(i).getMessage() + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+list.get(i).getCurrentTime()+"</div> <div style='clear: both;'>&nbsp;</div>")  
	                ); 
                       
                }
                else { // 다른 사람이 작성한 채팅메시지일 경우라면.. 작성자명이 나오고 흰배경색으로 보이게 한다.
                     
                    wsession.sendMessage(
                    	new TextMessage("[<span style='font-weight:bold; cursor:pointer;' class='loginuserName'>" +list.get(i).getName()+ "</span>]<br><div style='background-color: white; display: inline-block; max-width: 60%; padding: 7px; border-radius: 15%; word-break: break-all;'>"+ list.get(i).getMessage() +"</div> <div style='display: inline-block; padding: 20px 0 0 5px; font-size: 7pt;'>"+list.get(i).getCurrentTime()+"</div> <div>&nbsp;</div>") 
                    );
                     
                }// end of if(loginuser.getUserid().equals(list.get(i).getUserid())) --------------------------
        		
        	}// end of for ----------------------
        }
        
        // ========== 몽고DB 시작 ==========
		
		
	} // end of public void afterConnectionEstablished(WebSocketSession wsession) throws Exception-------------------------
	
	
	// === 클라이언트가 웹소켓 서버로 메시지를 보냈을때의 Send 이벤트를 처리하기 ===
    /*
		handleTextMessage(WebSocketSession wsession, TextMessage message) 메소드는 
		클라이언트가 웹소켓서버로 메시지를 전송했을 때 자동으로 호출되는(실행되는) 메소드이다.
		첫번째 파라미터  WebSocketSession 은  메시지를 보낸 클라이언트임.
		두번째 파라미터  TextMessage 은  메시지의 내용임.
	*/
	@Override
	public void handleTextMessage(WebSocketSession wsession, TextMessage message) throws Exception {
		
		// >>> 파라미터 WebSocketSession wsession은  웹소켓서버에 접속한 클라이언트임. <<<
		// >>> 파라미터 TextMessage message 은  클라이언트 사용자가 웹소켓서버로 보낸 웹소켓 메시지임. <<<

		// Spring에서 WebSocket 사용시 먼저 HttpSession에 저장된 값들을 읽어와서 사용하기
		/*
			com.spring.app.config.WebSocketConfiguration 클래스 파일에서
			
			@Override
			public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) 메소드내에
			addInterceptors(new HttpSessionHandshakeInterceptor()); 를 추가해주면 WebsocketEchoHandler 클래스를 사용하기 전에 
			먼저 HttpSession에 저장되어진 값들을 읽어 들여, WebsocketEchoHandler 클래스에서 사용할 수 있도록 처리해준다.
		*/
		
		Map<String, Object> map = wsession.getAttributes();
		/*
			webSocketSession.getAttributes(); 은 
			HttpSession에 setAttribute("키",오브젝트); 되어 저장되어진 값들을 읽어오는 것으로써,
			리턴값은  "키",오브젝트로 이루어진 Map<String, Object> 으로 받아온다.
		*/
		
		EmployeeVO loginuser = (EmployeeVO) map.get("loginuser");
		// "loginuser" 은 HttpSession에 저장된 키 값으로 로그인 되어진 사용자이다.
		
	//	System.out.println("==> 웹채팅확인용 : 로그인ID => " + loginuser.getUserid());
		// ==> 웹채팅확인용 : 로그인ID => kimsh
		
		MessageVO messageVO = MessageVO.convertMessage(message.getPayload());
		/* 
			파라미터 message 는  클라이언트 사용자가 웹소켓서버로 보낸 웹소켓 메시지임
			message.getPayload() 은  클라이언트 사용자가 보낸 웹소켓 메시지를 String 타입으로 바꾸어주는 것이다.
			/myspring/src/main/webapp/WEB-INF/views/mycontent1/chatting/multichat.jsp 파일에서 
			클라이언트가 보내준 메시지는 JSON 형태를 뛴 문자열(String) 이므로 이 문자열을 Gson을 사용하여 MessageVO 형태의 객체로 변환시켜서 가져온다.
		*/
		
		System.out.println("messageVO.getMessage(): "+messageVO.getMessage());
		
	//	System.out.println("~~~ 확인용 messageVO.getMessage() => " + messageVO.getMessage());
		// ~~~ 확인용 messageVO.getMessage() => 채팅방에 <span style='color: red;'>입장</span> 했습니다.
		
	//	System.out.println("~~~ 확인용 messageVO.getType() => " + messageVO.getType());
		// ~~~ 확인용 messageVO.getType() => all
		
	//	System.out.println("~~~ 확인용 messageVO.getTo() => " + messageVO.getTo());
		// ~~~ 확인용 messageVO.getTo() => all
		
		Date now = new Date(); // 현재시각
		String currentTime = String.format("%tp %tl:%tM", now, now, now);
		// %tp 오전, 오후를 출력
		// %tl 시간을 1~12 으로 출력
		// %tM 분을 00~59 으로 출력
		
		for(WebSocketSession webSocketSession : connectedUsers) {
			
			if("all".equals(messageVO.getType())) {
				// 채팅할 대상이 "전체" 인 공개대화인 경우
				// 메시지를 자기자신을 뺀 나머지 모든 사용자들에게 메시지를 보냄.
				
				if( !wsession.getId().equals(webSocketSession.getId()) ) {
					// wsession 은 메시지를 보낸 클라이언트임.
					// webSocketSession 은 웹소켓서버에 연결된 모든 클라이언트중 하나임.
					// wsession.getId() 와  webSocketSession.getId() 는 자동증가되는 고유한 값으로 나옴
					// System.out.println("=== 안녕? 하세요?");
					webSocketSession.sendMessage(
							new TextMessage("<span style='display:inline'>" + wsession.getId() + "</span>&nbsp;[<span style='font-weight:bold; cursor:pointer;' class='loginuserName'>" + loginuser.getName() + "</span>]<br><div style='background-color: white; display: inline-block; max-width: 60%; padding: 7px; border-radius: 15%; word-break: break-all;'>" + messageVO.getMessage() +"</div> <div style='display: inline-block; padding: 20px 0 0 5px; font-size: 7pt;'>"+currentTime+"</div> <div>&nbsp;</div>" ) );
																																																																																		/* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
				}
			}
			else { // 채팅할 대상이 "전체"가 아닌 특정대상(귀속말대상웹소켓.getId()임) 일 경우
				String ws_id = webSocketSession.getId();
				            // webSocketSession 은 웹소켓서버에 연결한 모든 클라이언트중 하나이며, 그 클라이언트의 웹소켓의 고유한 id 값을 알아오는 것임.
				if(messageVO.getTo().equals(ws_id)) {
				// messageVO.getTo() 는 클라이언트가 보내온 귓속말대상웹소켓.getId() 임.
					webSocketSession.sendMessage(
							new TextMessage("<span style='display:inline'>" + wsession.getId() + "</span>&nbsp;[<span style='font-weight:bold; cursor:pointer;' class='loginuserName'>" + loginuser.getName() + "</span>]<br><div style='background-color: white; display: inline-block; max-width: 60%; padding: 7px; border-radius: 15%; word-break: break-all; color: red;'>" + messageVO.getMessage() +"</div> <div style='display: inline-block; padding: 20px 0 0 5px; font-size: 7pt;'>"+currentTime+"</div> <div>&nbsp;</div>" ) );
																																																																																		/* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
					break; // 지금의 특정대상(지금은 귓속말대상 웹소켓id)은 1개이므로 
                    	   // 특정대상(지금은 귓속말대상 웹소켓id 임)에게만 메시지를 보내고  break;를 한다.
				}
			}
			
		} // end of for -------------------------------
		
		
		// ==================== 몽고DB 시작 ====================
		
//		chattingMongo.insertMessage(dto);
		
		// === 상대방에게 대화한 내용을 위에서 보여준 후, 채팅할 대상이 "전체" 인 공개대화에 대해서만 몽고DB에 저장하도록 한다. 귓속말은 몽고DB에 저장하지 않도록 한다. === // 
        if("all".equals(messageVO.getType())) {
           String _id = String.format("%1$tY%1$tm%1$td%1$tH%1$tM%1$tS", Calendar.getInstance()); 
          _id += System.nanoTime();
          dto.set_id(_id);
          dto.setMessage(messageVO.getMessage());
          dto.setTo(messageVO.getTo());
          dto.setType(messageVO.getType());
          
          dto.setUserid(loginuser.getEmployeeNo());
          dto.setName(loginuser.getName());
          dto.setCurrentTime(currentTime);
          dto.setCreated(new Date());
          
          chattingMongo.insertMessage(dto);
        }
		
		// ==================== 몽고DB 시작 ====================
		
		
	} // end of public void handleTextMessage(WebSocketSession wsession, TextMessage message) throws Exception-----------------
	
	
	// === 클라이언트가 웹소켓서버와의 연결을 끊을때 작업 처리하기 ===
	/*
  		afterConnectionClosed(WebSocketSession session, CloseStatus status) 메소드는 
     	클라이언트가 연결을 끊었을 때 
     	즉, WebSocket 연결이 닫혔을 때(채팅페이지가 닫히거나 채팅페이지에서 다른 페이지로 이동되는 경우) 자동으로 호출되어지는(실행되어지는) 메소드이다.
	 */
	@Override
    public void afterConnectionClosed(WebSocketSession wsession, CloseStatus status) throws Exception {
		// 파라미터 WebSocketSession wsession 은 연결을 끊은 웹소켓 클라이언트임.
		// 파라미터 CloseStatus 은 웹소켓 클라이언트의 연결 상태.
		
		Map<String, Object> map = wsession.getAttributes(); 
		EmployeeVO loginuser = (EmployeeVO)map.get("loginuser");
		
		for (WebSocketSession webSocketSession : connectedUsers) {
	           
	           // 퇴장했다라는 메시지를 자기자신을 뺀 나머지 모든 사용자들에게 메시지를 보내도록 한다.
	           if (!wsession.getId().equals(webSocketSession.getId())) { 
	                webSocketSession.sendMessage(
	                   new TextMessage("[<span style='font-weight:bold;'>" +loginuser.getName()+ "</span>]님이 <span style='color: red;'>퇴장</span>했습니다.")
	                ); 
	           }
    	}// end of for------------------------------------------
		
	// System.out.println("====> 웹채팅확인용 : 웹세션ID " + wsession.getId() + "이 퇴장했습니다.");
		
		connectedUsers.remove(wsession);
		// 웹소켓 서버에 연결되어진 클라이언트 목록에서 연결은 끊은 클라이언트는 삭제시킨다.
		
		// ===== 접속을 끊을시 현재 남아있는 접속자명단을 알려주기 위한 것 시작 =====
		
		String connectiongUserName = "「 ";   // 「 은 자음 ㄴ 을 하면 온다.
	      
	      for(WebSocketSession webSocketSession : connectedUsers) {
	         Map<String, Object> map2 = webSocketSession.getAttributes();
	         EmployeeVO loginuser2 = (EmployeeVO) map2.get("loginuser");
	         // "loginuser2" 은 HttpSession에 저장된 키 값으로 로그인 되어진 사용자이다.
	         
	         connectiongUserName += loginuser2.getName() + " ";
	         
	         // === 웹소켓 서버에 접속시 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 시작 === //
	         if(employeevo_list.size() > 0) {
	            boolean isExists = false;
	            for(EmployeeVO membervo : employeevo_list) {
	               if(membervo.getEmployeeNo().equals(loginuser.getEmployeeNo())) {
	                  isExists = true;
	                  break;
	               }
	            }// end of for() -----
	            
	            if(!isExists) {
	            	employeevo_list.add(loginuser2);
	            }
	         }
	         else {
	        	 employeevo_list.add(loginuser2);
	         }
	         // === 웹소켓 서버에 접속시 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 끝 === //
	         
	      }// end of for() ------
	      
	      connectiongUserName += "」";   // 」은 자음 ㄴ 을 하면 나온다. 
	      
	      for(WebSocketSession webSocketSession : connectedUsers) {
	    	  webSocketSession.sendMessage(new TextMessage(connectiongUserName));
	      }// end of for() -----
	      // ===== 접속을 끊을시 현재 남아있는 접속자명단을 알려주기 위한 것 끝 =====
	      
	      
	      // === 접속을 끊을시 현재 남아있는 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 시작 === //
	      
	      if(employeevo_list.size() > 0) {
	           for(EmployeeVO membervo : employeevo_list) {
	              if(membervo.getEmployeeNo().equals(loginuser.getEmployeeNo())) {
	            	  employeevo_list.remove(membervo);
	                 break;
	              }
	           }
	           
	           String v_html = "⊆";  // 'ㄷ'에 있는 것임
	            if(employeevo_list.size() > 0) {
	               for(EmployeeVO membervo : employeevo_list) {
	                  v_html += "<tr>"
	                        + "<td>"+membervo.getEmployeeNo()+"</td>"
	                        + "<td>"+membervo.getName()+"</td>"
	                        + "<td>"+membervo.getEmail()+"</td>"
	                        + "</tr>";
	               }
	               for(WebSocketSession webSocketSession : connectedUsers) {
	                   webSocketSession.sendMessage(new TextMessage(v_html));
	                }// end of for------------------------
	            }
	        }
	      
	      // === 접속을 끊을시 현재 남아있는 채팅에 접속한 사용자ID, 성명, 이메일 정보를 보여주기 위한 것 시작 === //
	      
		
	}// end of public void afterConnectionClosed(WebSocketSession wsession, CloseStatus status) throws Exception ----------------------------

	private String getRoomIdFromSession(WebSocketSession session) {
	    String path = session.getUri().getPath();
	    return path.substring(path.lastIndexOf('/') + 1);
	}
	
	
}
