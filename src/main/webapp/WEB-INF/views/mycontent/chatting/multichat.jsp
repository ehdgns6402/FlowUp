<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- #웹채팅관련4 --%>

<jsp:include page="../../header/header.jsp" />


<script type="text/javascript">

// === !!! WebSocket 통신 프로그래밍은 HTML5 표준으로써 자바스크립트로 작성하는 것이다. !!! === //
// WebSocket(웹소켓)은 웹 서버로 소켓을 연결한 후 데이터를 주고 받을 수 있도록 만든 HTML5 표준이다. 
// 그런데 이러한 WebSocket(웹소켓)은 HTTP 프로토콜로 소켓 연결을 하기 때문에 웹 브라우저가 이 기능을 지원하지 않으면 사용할 수 없다. 
/*
>> 소켓(Socket)이란? 
   - 어떤 통신프로그램이 네트워크상에서 데이터를 송수신할 수 있도록 연결해주는 연결점으로써 
     IP Address와 port 번호의 조합으로 이루어진다. 
     또한 어떤 하나의 통신프로그램은 하나의 소켓(Socket)만을 가지는 것이 아니라 
     동일한 프로토콜, 동일한 IP Address, 동일한 port 번호를 가지는 수십개 혹은 수만 개의 소켓(Socket)을 가질 수 있다.

   =================================================================================================  
     클라이언트  소켓(Socket)                                         서버  소켓(Socket)
     211.238.142.70:7942 ◎------------------------------------------◎  211.238.142.72:9090

     클라이언트는 서버인 211.238.142.72:9099 소켓으로 클라이언트 자신의 정보인 211.238.142.70:7942 을 
     보내어 연결을 시도하여 연결이 이루어지면 서버는 클라이언트의 소켓인 211.238.142.70:7942 으로 데이터를 보내면서 통신이 이루어진다.
   ================================================================================================== 
     
     소켓(Socket)은 데이터를 통신할 수 있도록 해주는 연결점이기 때문에 통신할 두 프로그램(Client, Server) 모두에 소켓이 생성되야 한다.

   Server는 특정 포트와 연결된 소켓(Server 소켓)을 가지고 서버 컴퓨터 상에서 동작하게 되는데, 
   이 Server는 소켓을 통해 Cilent측 소켓의 연결 요청이 있을 때까지 기다리고 있다(Listening 한다 라고도 표현함).
   Client 소켓에서 연결요청을 하면(올바른 port로 들어왔을 때) Server 소켓이 허락을 하여 통신을 할 수 있도록 연결(connection)되는 것이다.
*/
$(document).ready(function(){
   
   $("div#mycontent").css({"background-color" : "#eff4fc"});
   // div#"mycontainer" 는 header1.jsp 에 있는 div 의 style 을 수정한 것이다.
   
   const url = window.location.host;   // 웹브라우저의 주소창의 포트까지 가져옴.
//   alert("url : " + url);
   
   const pathname = window.location.pathname; // 최초 '/' 부터 오른쪽에 있는 모든 경로
//   alert("pathname : " + pathname);
   
   const appCtx = pathname.substring(0, pathname.lastIndexOf("/") );   // "전체 문자열".lastIndexOf("검사할 문자");
//   alert("appCtx : " + appCtx);
   
   const root = url + appCtx;
//   alert("root : " + root);
   
   const wsUrl = "ws://"+root+"/multichatstart";
   // 웹소켓통신을 하기위해서는 http:// 을 사용하는 것이 아니라 ws:// 을 사용해야 한다. 
//   alert("wsUrl"+ wsUrl);
   
   const websocket = new WebSocket(wsUrl);
   // 즉, const websocket = new WebSocket("ws://"+root+"/multichatstart") 이다.
   // "/chatting/multichatstart" 에 대한 것은 
   // com.spring.app.config.WebsocketEchoHandler 에서 설정해두었다.
   
   
   // >> ====== !!중요!! Javascript WebSocket 이벤트 정리 ====== << //
    /*   -------------------------------------
             이벤트 종류          설명
         -------------------------------------
               onopen         WebSocket 연결
             onmessage      메시지 수신
             onerror        전송 에러 발생
             onclose        WebSocket 연결 해제
    */  
   
    let messageObj = {};   // 자바스크립트 객체 생성
    
    // === 웹소켓에 최초로 연결이 되었을 경우에 실행되어지는 콜백함수 정의 === //
    websocket.onopen = function(){
       // alert("웹소켓 연결됨!");
       // $("div#chatStatus").text("정보: 웹소켓에 연결이 성공됨!!"); 
    /*   
       messageObj.message = "채팅방에 <span style='color: red;'>입장</span> 했습니다.";
       messgaeObj.type = "all";   // messageObj.type = "all"; 은 "1 대 다" 채팅을 뜻하는 것이고, messageObj.type = "one"; 은 "1 대 1" 채팅을 뜻하는 것으로 하겠다.
       messgaeObj.to = "all";   // messageObj.to = "all"; 은 수신자는 모두를 뜻하는 것이고, messageObj.to = "eomjh"; 이라면  eomjh 인 사람과 1대1 채팅(귓속말)을 뜻하는 것으로 하겠다.
   */
      // 또는
       messageObj = {message : "채팅방에 <span style='color: red;'>입장</span> 했습니다.",
                  type : "all",
                  to : "all"};   // 자바 스크립트에서 객체의 데이터값 초기화
       
                  
      websocket.send(JSON.stringify(messageObj));
      // JSON.stringify(자바스크립트객체) 는 자바스크립트객체를 JSON 표기법의 문자열(string)로 변환한다
        // JSON.parse(JSON 표기법의 문자열) 는 JSON 표기법의 문자열(string)을 자바스크립트객체(object)로 변환해준다.
      /*
           JSON.stringify({});                  // '{}'
           JSON.stringify(true);                // 'true'
           JSON.stringify('foo');               // '"foo"'
           JSON.stringify([1, 'false', false]); // '[1,"false",false]'
           JSON.stringify({ x: 5 });            // '{"x":5}'
      */
      
    };// end of websocket.onopen -----
    
    
    
    websocket.onclose = function(event) {
    	   console.log("웹소켓 연결이 끊어졌습니다. 재연결 시도...");
    	   setTimeout(function() {
    	      websocket = new WebSocket(wsUrl);
    	   }, 3000);  // 3초 후 재연결 시도
    	};
    
    // === 메시지 수신 시 콜백함수 정의하기 === //
    websocket.onmessage = function(event) {
       
       // event.data 는 수신되어진 메시지이다.
       // 채팅서버에 연결된 사용자를 수신된 메시지는 「 김시진 엄정화 」 이다.
      if(event.data.substr(0, 1)=="「" && event.data.substr(event.data.length-1)=="」") {
          $("div#connectingUserList").html(event.data);
      }
      else if(event.data.substr(0,1)=="⊆") { 
            $("table#tbl > tbody").html(event.data);
      }
      else{
         // event.data 는 수신받은 채팅문자
          $("div#chatMessage").append(event.data);
          $("div#chatMessage").append("<br>");
          $("div#chatMessage").scrollTop(99999999);
      }
      
    };// end of websocket.onmessage ----- 
    
    // === 웹소켓 연결해제 시 콜백함수 정의하기 === //
    websocket.onclose = function(event) {

    };// end of websocket.onclose = function(event) -----
    
    ////////////////////////////////////////////////////////////////////////////////////////
   // === 메시지 입력 후 엔터하기 === //
   $("input#message").keyup(function(key){
      if(key.keyCode == 13) {
         $("input#btnSendMessage").click(); 
      }
   });
    
   // === 메시지 보내기 === //
   let isOnlyOneDialog = false; // 귀속말 여부. true 이면 귀속말, false 이면 모두에게 공개되는 말 
    
   $("input#btnSendMessage").click(function() {
    
      if( $("input#message").val().trim() != "" ) {
          
      // ==== 자바스크립트에서 replace를 replaceAll 처럼 사용하기 ====
      // 자바스크립트에서 replaceAll 은 없다.
      // 정규식을 이용하여 대상 문자열에서 모든 부분을 수정해 줄 수 있다.
      // 수정할 부분의 앞뒤에 슬래시를 하고 뒤에 gi 를 붙이면 replaceAll 과 같은 결과를 볼 수 있다. 
         
         let messageVal = $("input#message").val();
         messageVal = messageVal.replace(/<script/gi, "&lt;script"); 
         
         // 스크립트 공격을 막으려고 한 것임.
            
            <%-- 
             messageObj = {message : messageVal
                          ,type : "all"
                          ,to : "all"}; 
            --%>
         // 또는
            messageObj = {}; // 자바스크립트 객체 생성함. 
            messageObj.message = messageVal;
            messageObj.type = "all";   // 공개대화
            messageObj.to = "all";      // 채팅방에 들어온 모든 웹소켓에게 (대상) 
          
            const to = $("input#to").val();
         if( to != "" ){
            messageObj.type = "one";   // 귓속말
            messageObj.to = to;         // 귓속말(비밀대화)를 나눌 특정 웹소켓
         }
         
         // alert(JSON.stringify(messageObj));
         
         websocket.send(JSON.stringify(messageObj));
         // JSON.stringify() 는 값을 그 값을 나타내는 JSON 표기법의 문자열로 변환한다
         
            // 위에서 자신이 보낸 메시지를 웹소켓으로 보낸 다음에 자신이 보낸 메시지 내용을 웹페이지에 보여지도록 한다. 
            
            const now = new Date();
            let ampm = "오전 ";
            let hours = now.getHours();
            
         if(hours > 12) {
            hours = hours - 12;
            ampm = "오후 ";
         }
            
         if(hours == 0) {
            hours = 12;
         }
            
         if(hours == 12) {
            ampm = "오후 ";
         }
            
         let minutes = now.getMinutes();
         if(minutes < 10) {
            minutes = "0"+minutes;
         }
          
         const currentTime = ampm + hours + ":" + minutes; 
            
         if(isOnlyOneDialog == false) { // 귀속말이 아닌 경우
            $("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>"); 
                                                                                                                                                                         /* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
         }
            
         else { // 귀속말인 경우. 글자색을 빨강색으로 함.
            $("div#chatMessage").append("<div style='background-color: #ffff80; display: inline-block; max-width: 60%; float: right; padding: 7px; border-radius: 15%; word-break: break-all; color: red;'>" + messageVal + "</div> <div style='display: inline-block; float: right; padding: 20px 5px 0 0; font-size: 7pt;'>"+currentTime+"</div> <div style='clear: both;'>&nbsp;</div>");
                                                                                                                                                                         /* word-break: break-all; 은 공백없이 영어로만 되어질 경우 해당구역을 빠져나가므로 이것을 막기위해서 사용한다. */
         }
            
         $("div#chatMessage").scrollTop(99999999);
            
         $("input#message").val("");
         $("input#message").focus();
      }
       
   });
    ////////////////////////////////
    
    // 귓속말대화 끊기 버튼은 처음에는 보이지 않도록 설정한다.
    $("button#btnAllDialog").hide();
    
    // 아래는 귓속말을 위해서 대화를 나누는 상대방의 이름을 클릭하면 상대방이름의 웹소켓id 를 알아와서 input태그인 귓속말대상웹소켓.getId()에 입력하도록 하는 것.
    $(document).on("click", "span.loginuserName", function() {
       /* 
          span.loginuserName 은 
           com.spring.chatting.websockethandler.WebsocketEchoHandler 의 
           public void handleTextMessage(WebSocketSession wsession, TextMessage message) 메소드내에
           187번 라인에 기재해두었음.
        */
       const ws_id = $(this).prev().text();
    //   alert(ws_id);
       $("input#to").val(ws_id);
       
       $("span#privateWho").text($(this).text());
       $("button#btnAllDialog").show();   // 귓속말대화끊기 버튼 보이기
       $("input#message").css({'background-color':'black', 'color':'white'});
       $("input#message").attr("placeholder", "귓속말 메시지 내용");
       
       isOnlyOneDialog = true;   // 귓속말 대화임을 지정
       
    });// end of $(document).on("click", "span.loginuserName", function() -----  
    
    $("button#btnAllDialog").click(function(){
       // 귀속말대화끊기 버튼을 클릭한 경우에는 전체대상으로 채팅하겠다는 말이다.
       $("input#to").val("");
        $("span#privateWho").text("");
        $("input#message").css({'background-color':'', 'color':''});
        $("input#message").attr("placeholder","메시지 내용");
        $(this).hide();
        
        isOnlyOneDialog = false; // 귀속말 대화가 아닌 모두에게 공개되는 대화임을 지정.
    });
          
});// end of $(document).ready(function() ----

</script>

<table id="tbl" class="table table-bordered table-dark">
   <tbody></tbody>
</table>

<div class="container-fluid" style="background: silver;">
   <div class="row" style="min-height: 85vh; margin-top: auto;"> 
      <div class="col-md-10 offset-md-1">
         <div id="chatStatus"></div>
         <div class="my-3">
         <!-- - 상대방의 대화내용이 검정색으로 보이면 채팅에 참여한 모두에게 보여지는 것입니다.<br>
         - 상대방의 대화내용이 <span style="color: red;">붉은색</span>으로 보이면 나에게만 보여지는 1:1 귓속말 입니다.<br>
         - 1:1 채팅(귓속말)을 하시려면 예를 들어, 채팅시 보이는 [이순신]대화내용 에서 이순신을 클릭하시면 됩니다. -->
         </div>
         <input type="hidden" id="to" placeholder="귓속말대상웹소켓.getId()"/>
         <br/>
         귓속말대상 : <span id="privateWho" style="font-weight: bold; color: red;"></span>
         <br>
         <button type="button" id="btnAllDialog" class="btn btn-secondary btn-sm">귓속말대화끊기</button>
         <br><br>
         현재 접속자:<br/>
         <div id="connectingUserList" style=" max-height: 100px; overFlow: auto;"></div>
         
         <div id="chatMessage" style="max-height: 500px; overFlow: auto; margin: 20px 0;"></div>
      
		<div class="input-group" style="position: relative;">
		
		    <input type="text" id="message" class="form-control"
		           style="padding-right: 100px; border-radius: 25px;">
		    <div class="input-group-append" style="position: absolute; right: 5px; top: 50%; transform: translateY(-50%); z-index: 5;">
		        <input type="button" id="btnSendMessage" class="btn btn-success btn-sm" 
		               value="보내기" style="border-radius: 20px; height: 38px;">
		    </div>
		</div>
         
         <button type="button" 
		        class="btn btn-danger btn-sm my-3 mx-3" 
		        onclick="javascript:location.href='<%=request.getContextPath() %>/index'"
		        style="position: absolute; top: 10px; right: 10px; z-index: 1000; padding: 8px 12px;"
		        aria-label="채팅방 나가기">
		    <i class="fa-solid fa-arrow-right-from-bracket fa-lg"></i>
		</button>
      
      </div>
   </div>
</div> 






<style>
/* 모든 스크롤바 완전 숨김 */
#chatMessage::-webkit-scrollbar,
#connectingUserList::-webkit-scrollbar {
    display: none; /* 웹킷 기반 브라우저 */
}

#chatMessage,
#connectingUserList {
    -ms-overflow-style: none;  /* IE/Edge */
    scrollbar-width: none;  /* Firefox */
    overflow: -moz-scrollbars-none; /* 구형 Firefox */
}

/* 스크롤 기능은 유지 */
#chatMessage {
    overflow-y: scroll !important;
    scroll-behavior: smooth;
}

/* 채팅 메시지 영역 추가 효과 */
#chatMessage {
    scroll-behavior: smooth;
    overscroll-behavior: contain;
}

#chatMessage {
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 15px;
    background-color: white;
}

.input-group {
    margin-top: 20px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.form-control {
    border: 2px solid #4CAF50 !important;
}

.btn-success {
    background-color: #4CAF50 !important;
    border-color: #45a049 !important;
    transition: all 0.3s;
}

.btn-success:hover {
    background-color: #45a049 !important;
    transform: scale(1.05);
}
</style>

<jsp:include page="../../footer/footer.jsp" /> 