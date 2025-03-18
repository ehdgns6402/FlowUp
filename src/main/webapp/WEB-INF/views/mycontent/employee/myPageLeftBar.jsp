<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String ctxpath = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
#main_section {
    display: flex;
    box-sizing: border-box;
}
#left_bar {
    position: sticky;
    top: var(--size60);
    width: var(--size250);;
    height: 100vh;
    background-color: #eff4fc;
    box-sizing: border-box;
    padding: var(--size20);
    border-right: 1px solid #c8c8c8;
}

#writePostBtn {
	display: inline-block;
	text-decoration:none;
	text-align: center;
	line-height:var(--size44);
    width: 100%;
    height: var(--size44);
    font-size: var(--size18);
    transition-duration: 150ms;
    border-width: 1px;
    border-style: solid;
    border-radius: calc(var(--size2) + var(--size2));
    align-items: center;
    text-wrap: nowrap;
    background-color: #2985db;
    border-color: #056ac9;
    color: #fff;
    margin-bottom: var(--size10);
}

.board_menu_container{
    width: 100%;
    height: auto;
}

.board_menu_container > ul li {
    width: 100%;
    height: var(--size38);
    font-size: var(--size15);
    user-select: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    box-sizing: border-box;
    padding-left: var(--size10);
}

.board_menu_container > ul > li > a {
    color: #333;
    text-decoration: none;
}

.board_menu_container > ul > li:hover {
    background-color: var(--baseColor1);
}



/* 현재 페이지에 이렇게 넣어주세요! */
.board_menu_container > ul li:nth-child(1){
    background-color: #dae8f8 !important;
    color: #056ac9;
    font-weight: 600;
}

.board_menu_container > ul li:nth-child(1) > a {
    color: #056ac9;
}
/* 현재 페이지에 이렇게 넣어주세요! */
</style>
<!-- 왼쪽 사이드바 -->
  <div id="left_bar">

      <!-- === 글작성 버튼 === -->
      <a href="<%= ctxpath%>/employee/updateMypageInfo" id="writePostBtn">
          <i class="fas fa-address-book"></i>
          <span id="goWrite">내정보수정</span>
      </a>
   
      
      <!-- === 글작성 버튼 === -->

      <div class="board_menu_container">
          <ul>
          	<li>
          		  <a href="<%= ctxpath%>/employee/mypage">내정보</a>
          	  </li>
          	  <li>
          		  <a href="#">비밀번호 변경</a>
          	  </li>
          	  
           	  
           	  <c:if test="${sessionScope.loginuser.securityLevel == 10}">
			      <a href="<%= ctxpath%>/employee/admin" id="writePostBtn" style="margin-top:10px;">
			          <i class="fa-solid fa-user"></i>
			          <span id="goWrite">관리자페이지</span>
			      </a>
	      
	      		<li>
          		  <a href="<%= ctxpath%>/employee/addEmployee">사원추가</a>
          	  </li>
          	  
          	  	<li>
          		  <a href="<%= ctxpath%>/employee/updateEmployee">사원수정</a>
          	  </li>
			 
      </c:if>
       <li>
           		  <a href="<%= ctxpath%>/employee/logout">로그아웃</a>
           	  </li>
          </ul>
      </div>
  </div>
 <!-- 왼쪽 사이드바 -->