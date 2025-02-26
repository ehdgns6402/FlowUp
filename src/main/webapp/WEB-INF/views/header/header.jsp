<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
   String ctxPath = request.getContextPath();
   //     /myspring 
%>      
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FlowUp</title>
  <!-- Required meta tags -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <%-- Bootstrap CSS --%>
  <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css" >
 
  <%-- Font Awesome 6 Icons --%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

  <%-- Optional JavaScript --%>
  <script type="text/javascript" src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
  <script type="text/javascript" src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" ></script>

  <script type="text/javascript" src="<%=ctxPath%>/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script> 

  
  <%-- 스피너 및 datepicker 를 사용하기 위해 jQueryUI CSS 및 JS --%>
  <link rel="stylesheet" type="text/css" href="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.css" />
  <script type="text/javascript" src="<%=ctxPath%>/jquery-ui-1.13.1.custom/jquery-ui.min.js"></script>

  <%-- === jQuery 에서 ajax로 파일을 업로드 할때 가장 널리 사용하는 방법 : ajaxForm === --%> 
  <script type="text/javascript" src="<%=ctxPath%>/js/jquery.form.min.js"></script> 

   <!-- css -->
   <link href="<%=ctxPath%>/css/header.css" rel="stylesheet">
   <link href="<%=ctxPath%>/css/main-section.css" rel="stylesheet">

   <!-- js -->
   <!--<script src="<%=ctxPath%>/js/util.js"></script>-->
   <script src="<%=ctxPath%>/js/header.js"></script>
   <script src="<%=ctxPath%>/js/dark_mode/dark.js"></script>

   <!-- font -->
   <link rel="preconnect" href="https://fonts.googleapis.com">
   <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
   <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
</head>
<body>
    <div id="container">
        <div id="header_container">
            <header>
                <div class="side_btn">
					<i class="fa-solid fa-angle-right"></i>
				</div>
                <div id="logo_box">
                    <span>
                        <img id="logo_img" src="<%=ctxPath%>/images/logo/logo1.png" /> 
                    </span>
                    <span class="bell">
                        <i class="fa-regular fa-bell far"></i>
                        <div class="alarm-cnt"></div> <!-- js를 통해 자동적으로 개수가 카운트 됩니다. -->
                        <div class="alarm">
                            <div class="alarm-title">최근 알림</div>
                            <ul>
                                <!-- DB에서 각 알림 별 시간순 정렬 뒤 유니온을 이용해 for문을 돌려주세요 -->
                                <li>
                                    <a href="#">
                                        <div>
                                            <div class="profile"></div> <!-- 알림을 보낸사람의 프로필 사진이 들어갈 자리입니다. -->
                                            <div class="alarm-contants">
                                                <span><b>[알림]</b></span> <!-- 알림의 정보가 뜰 자리입니다. ex) 커뮤니티, 알림, 공지,,, -->
                                                알람1 의 내용이 들어가는 자리 입니다. 3줄 이상이 되면 자동적으로 점 처리가 되게 css 처리를 해뒀습니다. 
                                                그러니 DB로 따로 처리할 필요는 없습니다.
                                            </div> <!-- 알림의 내용이 들어갈 자리입니다. -->
                                        </div>
                                        <div class="alarm-info">
                                            <span class="hour-before">7시간 전</span> <!-- 알림이 고지된 후의 시간을 나타낸 정보입니다. -->
                                            <span class="alarm-member">이상우 대표이사</span> <!-- 알림을 보낸 사람의 정보입니다. -->
                                        </div> 
                                    </a>
                                </li>
                                <!-- DB에서 각 알림 별 시간순 정렬 뒤 유니온을 이용해 for문을 돌려주세요 -->


                                <li>
                                    <a href="#">
                                        <div>
                                            <div class="profile"></div> <!-- 알림을 보낸사람의 프로필 사진이 들어갈 자리입니다. -->
                                            <div class="alarm-contants">
                                                <span><b>[알림]</b></span> <!-- 알림의 정보가 뜰 자리입니다. ex) 커뮤니티, 알림, 공지,,, -->
                                                알람2 의 내용이 들어가는 자리 입니다. 3줄 이상이 되면 자동적으로 점 처리가 되게 css 처리를 해뒀습니다. 
                                                그러니 DB로 따로 처리할 필요는 없습니다.
                                            </div> <!-- 알림의 내용이 들어갈 자리입니다. -->
                                        </div>
                                        <div class="alarm-info">
                                            <span class="hour-before">7시간 전</span> <!-- 알림이 고지된 후의 시간을 나타낸 정보입니다. -->
                                            <span class="alarm-member">이상우 대표이사</span> <!-- 알림을 보낸 사람의 정보입니다. -->
                                        </div> 
                                    </a>
                                </li>

                                <li>
                                    <a href="#">
                                        <div>
                                            <div class="profile"></div> <!-- 알림을 보낸사람의 프로필 사진이 들어갈 자리입니다. -->
                                            <div class="alarm-contants">
                                                <span><b>[알림]</b></span> <!-- 알림의 정보가 뜰 자리입니다. ex) 커뮤니티, 알림, 공지,,, -->
                                                알람3 의 내용이 들어가는 자리 입니다. 3줄 이상이 되면 자동적으로 점 처리가 되게 css 처리를 해뒀습니다. 
                                                그러니 DB로 따로 처리할 필요는 없습니다.
                                            </div> <!-- 알림의 내용이 들어갈 자리입니다. -->
                                        </div>
                                        <div class="alarm-info">
                                            <span class="hour-before">7시간 전</span> <!-- 알림이 고지된 후의 시간을 나타낸 정보입니다. -->
                                            <span class="alarm-member">이상우 대표이사</span> <!-- 알림을 보낸 사람의 정보입니다. -->
                                        </div> 
                                    </a>
                                </li>


                            </ul>
                        </div>
                    </span>
                </div>

                <div id="header_ikon_container">
                    <ul id="header_ikon_box">
                          <li>
                              <a href="<%= ctxPath%>/index"><i class="fa-solid fa-house"></i><span>홈</span></a>
                          </li>
                          <li>
                              <a href="<%= ctxPath%>/mail/"><i class="fa-regular fa-envelope"></i><span>메일</span></a>
                          </li>
                          <li>
                              <a href="<%= ctxPath%>/reservation/"><i class="fa-solid fa-file-contract"></i><span>예약</span></a>
                          </li>
                          <li>
                              <a href="#"><i class="fa-regular fa-file"></i><span>자료실</span></a>
                          </li>
                          <li>
                              <a href="<%= ctxPath%>/document/"><i class="fa-solid fa-file-invoice-dollar"></i><span>전자결제</span></a>
                          </li>
                          <li>
                              <a href="<%= ctxPath%>/commute/"><i class="fa-regular fa-credit-card"></i><span>근태관리</span></a>
                          </li>
                          <li>
                              <a href="<%= ctxPath%>/board/"><i class="fa-regular fa-comments"></i><span>게시판</span></a>
                          </li>
                          <li>
                              <a href="<%= ctxPath%>/calendar/"><i class="fa-regular fa-calendar-days"></i><span>캘린더</span></a>
                          </li>
                          <li>
                              <a href="<%= ctxPath%>/organization/"><i class="fa-regular fa-folder"></i><span>조직도</span></a>
                          </li>
                          
                      </ul>
                </div>

            </header>
        </div>

        <div id="section_Container">
            <!-- top header -->
            <div id="top_header_container">
                <div class="top_header_l top_header">
                    <div class="top_ikon">
                        
                    </div>
                </div>
                <div class="top_header_c top_header">
                    <div class="dark_btn">
                        <div class="dark_circle"></div>
                    </div>
                </div>
                <div class="top_header_r top_header">
                    <div class="top_ikon">
                        
                    </div>
                    <div class="top_ikon">
                        
                    </div>
                    <div class="top_ikon">
                        
                    </div>
                </div>
            </div>
            <!-- top header -->

            <section id="main_section">
                

    