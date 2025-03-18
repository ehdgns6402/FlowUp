<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
   String ctxPath = request.getContextPath();
   //     /flowUp
%>  


<jsp:include page="../../header/header.jsp" />
<jsp:include page="./myPageLeftBar.jsp" />

<link href="<%=ctxPath%>/css/employeeCss/addEmployee.css" rel="stylesheet"> 
 
<style type="text/css">
   span.error {
   	  color: red;
   }
</style>

<script type="text/javascript">

$(document).ready(function(){
	
	$("input:text[name='employeeNo']").focus(); // 페이지가 시작 할 때 사번 입력 칸에 focus를 주기
	$("span.error").hide();	// 에러 메세지 숨기기
	
	<%-- ============ 샘 시작 ============ --%>
	
	<%-- 사번 유효성 검사 --%>
	$("input:text[name='employeeNo']").keyup(function(e){
		
		 const regExp = /^[0-9]+$/;
			
		 const bool = regExp.test($(e.target).val());
		 
		 if(!bool) { // 입력한 글자가 숫자가 아닌 경우
			 $(e.target).next().show(); 
		 
			 const current_val = $(e.target).val();
		     const str_only_number = current_val.substring(0, current_val.length-1);
		     $(e.target).val(str_only_number);
		 }
		 else if( $(e.target).val().substring(0, 1) === '0' ){ // 처음 시작하는 숫자가 '0' 일 경우
			 $(e.target).next().show(); 
			 
			 const current_val = $(e.target).val();
		     const str_only_number = current_val.substring(0, current_val.length-1);
		     $(e.target).val(str_only_number);
		 }
		 else if($(e.target).val().length < 6 ) { // 입력한 글자가 모두 숫자이지만 글자수가 6글자 미만인 경우 
			 $(e.target).next().show();
		 }
		 else if($(e.target).val().length > 6 ) { // 입력한 글자가 모두 숫자이지만 글자수가 6글자를 초과한 경우 
			 $(e.target).next().show();
		 
			 const current_val = $(e.target).val();
		     const str_only_number = current_val.substring(0, current_val.length-1);
			       
			 $(e.target).val(str_only_number);
		 }
		 else { // 모두가 숫자 6자리로만 채워진 경우
			 $(e.target).next().hide();
		 }
		
	});// end of $("input:text[name='employeeNo']").keyup(function(e){});------------------
	
	$("input:text[name='employeeNo']").blur(function(e){ // 사번 숫자입력 확인
		
		const regExp = /^[0-9]+$/;
		 
		 const bool = regExp.test($(e.target).val());
		 
		 if(bool && $(e.target).val().length == 6) { // 모두가 숫자 6자리로만 채워진 경우
			 $(e.target).next().hide(); 
		 }
		 else { // 모두가 숫자 6자리로만 채워것이 아닌 경우
			 $(e.target).next().show();
			 $(e.target).focus();
		 }
		
	}); //end of $("input:text[name='employeeNo']").blur(function(e){});------------------
	
	<%-- ============ 샘 끝  ============ --%>
	
	///////////////////////////////////////////////////
	
	
	<%-- ============ 지혜 시작 ============ --%>
	
	
	
	<%-- ============ 비밀번호 유효성 시작 ============ --%>
	
 	$("input:password[name='passwd']").blur(function(e) {
 		
 		 const regExp =  /^.*(?=^.{8,15}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[^a-zA-Z0-9]).*$/g;
		 const bool = regExp.test($(e.target).val());
		 
		 if(!bool){
			 $(e.target).next().show(); 
			 $(e.target).focus();
		 }
		 
		 else{
			 $(e.target).next().hide();  
		 }
 		
 	});// end of $("input:text[name='passwd']").blur(function(e) {})------------------
	
	$("input:password[name='passwd']").keyup(function(e){
 		
 		if($(e.target).val().length < 8){
			$(e.target).next().show(); 
			$(e.target).focus();
		}
 		
 		
 		else if($(e.target).val().length > 15){
			$(e.target).next().show(); 
			
			const current_val = $(e.target).val();
			const str_passwd = current_val.substring(0, current_val.length-1);
			
			$(e.target).val(str_passwd);
		}
 		
 		else{
			$(e.target).next().hide
		}
 		
 		
 		
 	});// end of $("input:text[name='passwd']").keyup(function(e){});--------------------------
 	
 	<%-- ============ 비밀번호 유효성 끝 ============ --%>
 	
 	
 	
 	<%-- ============ 이름 유효성 시작 ============ --%>
 	
 	$("input:text[name='name']").blur(function(e){
 		
 		const regExp= /^[가-힣]{2,6}$/ // 한글이 2~6자리
 		const bool = regExp.test($(e.target).val());
 		
 		if(!bool){
			 
			 $(e.target).next().show();
			 $(e.target).focus();
			 
		}
 		
 		else{
			$(e.target).next().hide();
	    }
 		
 	}); // end of $("input:text[name='name']").blur(function(e){});----------------------- 	
 	
 	
 	<%-- ============ 이름 유효성 끝 ============ --%>
 	
 	
 	
 	
 	
 	<%-- ============ 부서 유효성 시작 ============ --%>
 	
 	$("select#department_select").bind("change", function(e){
 		
 		const departmentNo = $(e.target).val();
 		
 		$.ajax({
	    	  url:"<%= ctxPath%>/employee/teamNo_seek_BydepartmentNo",
	    	  data:{"departmentNo":departmentNo},
	    	  dataType:"json",
	    	  type:"get",
	    	  async:false,
	    	  success:function(json){
	    		//  alert(JSON.stringify(json));
	            /*
	    		  [{"teamName":"해외영업팀","teamNo":"100002"},{"teamName":"국내영업팀","teamNo":"100003"},{"teamName":"고객관리팀","teamNo":"100004"}]
	    	    */
	    	      let v_html = "";
	            
	              for(let i=0; i<json.length; i++){
	            	  v_html += "<option value="+ json[i].teamNo +">"+ json[i].teamName +"</option>";
	              }// end of for------------------
	            
	    		  $("select#team_select").html(v_html);
	    	  },
	    	  error: function(request, status, error){
  			alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
  	      }
	      });
 		
 	}); // end of $("select#department_select").bind("change", function(e){});----------------
 	
 	<%-- ============ 부서 유효성  끝 ============ --%>
 	
 	
 	
 	
 	<%-- ============ 이메일 유효성 시작 ============ --%>
 	
 	$("input:text[name='email']").blur(function(e){
 		
 		
 		 const regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i; 
		 const bool = regExp.test($(e.target).val());
		 
		 if(!bool){
			 $(e.target).next().show();
			 $(e.target).focus();
		 }
		 
		 else{
				$(e.target).next().hide();
		 }
		 
		 
 	}); // end of $("input:text[name='email']").blur(function(e){});----------------------------------
 	
 	<%-- ============ 이메일 유효성 끝 ============ --%>
 	
 	
 	
 	
 	
 	<%-- ============ 계좌 유효성 시작 ============ --%>
 	
 	$("input:text[name='account']").blur(function(e){
 		
 		const regExp = /^[0-9]+$/;
		const bool = regExp.test($(e.target).val());
		
		if(!bool){
			$(e.target).focus();
			$(e.target).next().show();
			$(e.target).val('');
		}
		
		else{
			$(e.target).next().hide()
		}
 		
 	}); // end of $("input:text[name='account']").blur(function(e){});
 	
 	<%-- ============ 계좌 유효성  끝 ============ --%>
 	
 	
 	
 	
 	
 	<%-- ============ 전화번호 유효성 시작 ============ --%>
 	 $("input:text[name='mobile']").keyup(function(e){
 		 
 		 const regExp = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;
 		 const bool = regExp.test( $(e.target).val() );
		 
		if(!bool){
			$(e.target).next().show();
			$(e.target).focus()
		}
		 
		 else{
			 $(e.target).next().hide();	
		 }
	 
 		 
 	 });// end of $("input:text[name='mobile']").keyup(function(e){});----------------------------------

 	<%-- ============ 전화번호 유효성  끝 ============ --%>
 	 
 	 
 	 
 	 
 	 
 	<%-- ============ 입사일 유효성 시작 ============ --%>
 	
 	$("input:text[name='registerDate']").on('keyup',function(e){
 		
let current_val = $(e.target).val().replace(/[^0-9]/g,"");//숫자만 입력
		
		if(current_val.length > 8 ){
			current_val = current_val.substring(0,8);
		}
		
		// 2020 09 12
		
		let formattedDate = current_val;
		if(current_val.length > 4){
			formattedDate = current_val.substring(0,4)+"-"+current_val.substring(4);
		}
		
		if(current_val.length > 6){
			formattedDate = current_val.substring(0,4)+"-"+current_val.substring(4,6)+"-"+current_val.substring(6);
		}
		
		$(e.target).val(formattedDate);
		
		if(current_val.length > 0 && current_val.length < 8){
			$(e.target).next().show();
		}
		
		else{
			$(e.target).next().hide();	
		}
 		
 	}); // end of $("input:text[name='registerDate']").on('keyup',function(e){});--------------------------------------------
 	
 	$("input:text[name='registerDate']").blur(function(e){
 		
 		if($(e.target).val().length < 8){ // 입사일에 입력한 데이터의 길이가 8보다 작은 값일 때
 			$(e.target).focus();
 			$(e.target).next().show();
 		}
 		
 		else if($(e.target).val().length > 10){// 입사일에 입력한 데이터의 길이가 10보다 큰 값일 때
 			$(e.target).focus();
 			$(e.target).next().show();
 		}
 		
 		else{
 			$(e.target).next().hide();
 		}
 	
 		
 	}); // end of $("input:text[name='registerDate']").blur(function(e){});---------------------------------------------
 	
 	
 	<%-- ============ 입사일 유효성  끝  ============ --%>
 	
 	
 	
 	
 	
 	<%-- ============ 주소 유효성  시작  ============ --%>
 	
 	$("input:text[name='address']").blur(function(e){
 		
 		const address = $("input:text[name='address']").val();
		 
		 if(address == ""){
			 $("input:text[name='address']").next().show();
			 $("input:text[name='address']").focus();
		 }
		 else{
			 $("input:text[name='address']").next().hide(); 
		 }
 		
 	}); //end of $("input:text[name='address']").blur(function(e){});------------------------------------------------------
 	
 	<%-- ============ 주소 유효성  끝    ============ --%>
 	
 	
 	
 	
 	
 	<%-- ============ 생일 유효성 시작 ============ --%>
 	
 	$("input:text[name='birth']").on('keyup',function(e){
 		
 		 let current_val = $(e.target).val().replace(/[^0-9]/g,"");//숫자만 입력
		
		 if(current_val.length > 8 ){
			current_val = current_val.substring(0,8);
		 }
		
		 let formattedDate = current_val;
		 if(current_val.length > 4){
			formattedDate = current_val.substring(0,4)+"-"+current_val.substring(4);
		 }
		
		 if(current_val.length > 6){
			formattedDate = current_val.substring(0,4)+"-"+current_val.substring(4,6)+"-"+current_val.substring(6);
		 }
		
		 $(e.target).val(formattedDate);
		
		 if(current_val.length > 0 && current_val.length < 8){
			$(e.target).next().show();
		 }
		
		 else{
			$(e.target).next().hide();	
		 }
 		
 	}); // end of $("input:text[name='birth']").on('keyup',function(e){});-------------------------------------------------
 	
	$("input:text[name='birth']").blur(function(e){
 		
 		if($(e.target).val().length < 8){ // 입사일에 입력한 데이터의 길이가 8보다 작은 값일 때
 			$(e.target).focus();
 			$(e.target).next().show();
 		}
 		
 		else if($(e.target).val().length > 10){// 입사일에 입력한 데이터의 길이가 8보다 큰 값일 때
 			$(e.target).focus();
 			$(e.target).next().show();
 			
 		}
 		
 		else{
 			$(e.target).next().hide();
 		}
 		
 	}); // end of $("input:text[name='birth']").blur(function(e){});---------------------------------------------
 	
 	<%-- ============ 생일 유효성  끝 ============ --%>
 	
 	
 	
 	
 	
 	<%-- ============ 보안등급 유효성 시작 ============ --%>
 	
 	$("input:text[name='securityLevel']").on('keyup',function(e){
 		
 		 const regExp = /^[0-9]+$/;
		 
		 const bool = regExp.test($(e.target).val());
		 
		 if(!bool){
			 $(e.target).next().show(); 
			 
			 const current_val = $(e.target).val();
		     const str_only_number = current_val.substring(0, current_val.length-1);
		     $(e.target).val(str_only_number);
		 }
		 
		 else if($(e.target).val() < 1 || $(e.target).val() > 10){
			 $(e.target).val('');
			 $(e.target).val().focus();
			 $(e.target).next().show(); 
		 }
		 
		 else{
			 $(e.target).next().hide();
		 }
 		
 	});// end of $("input:text[name='securityLevel']").on('keyup',function(e){});--------------------------------------------------
 	
 	<%-- ============ 보안등급 유효성  끝 ============ --%>
 	
 	
 	<%-- ============= 사원 추가 하기 =============--%>
 	
 	$("button#addEmployee").click(function(){
 		
 		const frm = document.addEmployeeFrm;
 		 frm.action = "<%= ctxPath%>/employee/addEmployeeEnd";
 	     frm.method = "post";
 	     frm.submit();
 		
 	});
 	
	
	<%-- ============ 지혜  끝 ============ --%>
});// end of $(document).ready(function(){});

</script>


<div class="container">

	<div class="addtitle">
		<h3>사원추가</h3>
	</div>
	<div class="frmdiv">
		
		<form name="addEmployeeFrm" id="addemployee">
		<ul>
	
			<li class="inputList">
				<span class="inputTitle">사번</span>
				<input type="text" class="frmInput employeeNoInfo" name="employeeNo" placeholder="6자리 숫자 조합"/>
				<span class="error">사번은 숫자 6자리 입력하세요</span>
			</li>
			
			<li class="inputList">
				<span class="inputTitle">비밀번호</span>
				<input type="password" class="frmInput passwdInfo" name="passwd" placeholder="8~15자의 영어, 숫자 조합"/>
				<span class="error">비밀번호는 8~15자의 영어와 숫자, 특수문자가 포함되어야합니다</span>
			</li>
			
			<li class="inputList">
				<span class="inputTitle">이름</span>
				<input type="text" class="frmInput nameInfo" name="name" />
				<span class="error">이름을 입력하세요</span>
			</li>
			
			<li class="inputList">
				<span class="inputTitle">부서번호</span>
	<!-- 		<input type="text" class="frmInput deptNoInfo" name="FK_departmentNo" placeholder="6자리 숫자 조합" maxlength="6"/> -->
				<select name="FK_departmentNo" class="select_option" id="department_select">
					<option value="">부서번호를 선택하세요</option>
					<c:if test="${not empty requestScope.departmentno_map_list}">
						<c:forEach var="map" items="${requestScope.departmentno_map_list}">
						   <option value="${map.departmentNo}">${map.departmentNo}(${map.departmentname})</option>
						</c:forEach>
					</c:if>
				</select>
				<span class="error">부서번호를 선택해주세요</span>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">직급번호</span>
			<select name="FK_positionNo" class="select_option" id="position_select" >
				<option value="defaultselect" disabled="disabled" >직급을 선택하세요</option>
				<c:if test="${not empty requestScope.positionno_map_list}">
						<c:forEach var="map" items="${requestScope.positionno_map_list}">
						   <option value="${map.positionno}">${map.positionname}</option>
						</c:forEach>
				</c:if>
			</select>
			<span class="error">직급을 선택해주세요</span>
			</li>
			<li class="inputList">
			<span class="inputTitle">팀번호</span>
			<select name="FK_teamNo" class="select_option" id="team_select">
				<option value="">팀을 선택하세요</option>
			</select>
			<span class="error">팀을 선택해주세요</span>
			</li>
			
			<%--내선번호는 사원이 쓸 수 있게 하기 not null 제약으로 임의값 넣음.--%>
			<li class="inputList">
			<input type="hidden" class="frmInput directCallInfo" name="directCall" placeholder="'-'없이 숫자로만 입력하세요" value="100000"/>
			</li>
			
			
			<li class="inputList">
			<span class="inputTitle">보안등급</span>
			<input type="text" class="frmInput securityInfo" name="securityLevel" placeholder="1~10 중 골라주세요."/> 
			<span class="error">1~10 중 선택해주세요</span>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">이메일</span>
			<input type="text" class="frmInput emailInfo" name="email" placeholder="예) honggildong@naver.com"/>
			<span class="error">이메일의 형식에 맞춰서 입력하세요</span>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">전화번호</span>
			<input type="text" class="frmInput mobileInfo" name="mobile" placeholder="'-'없이 숫자로만 입력하세요"/>
			<span class="error">'-'없이 숫자로 입력하세요</span>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">은행</span>
			<select name="bank" class="select_option">
				<option class="select_default_bank">은행을 선택하세요.</option>
				<option class="bankn" value="농협은행">농협은행</option>
				<option class="bankn" value="신한은행">신한은행</option>
				<option class="bankn" value="KB국민은행">KB국민은행</option>
				<option class="bankn" value="우리은행">우리은행</option>
				<option class="bankn" value="한국은행">한국은행</option>
				<option class="bankn" value="하나은행">하나은행</option>
				<option class="bankn" value="SC제일은행">SC제일은행</option>
			</select>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">계좌</span>
			<input type="text" class="frmInput accountInfo" name="account" maxlength="14"/>
			<span class="error">계좌번호를 입력하세요</span>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">입사일</span>
			<input type="date" class="frmInput registerInfo" name="registerDate" onkeydown="return false" />
			<span class="error">'-'없이 숫자로 입력하세요</span>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">주소</span>
			<input type="text" class="frmInput addressInfo" name="address"/>
			<span class="error">주소를 입력하세요</span>
			</li>
			
			<li class="inputList">
			<span class="inputTitle">생년월일</span>
			<input type="date" class="frmInput birthInfo"  name="birth" onkeydown="return false" />
			<span class="error">'-'없이 숫자로 입력하세요</span>
			</li>
			
			<!-- status 기본적으로 상태 1로 맞춘다. -->
			<li>
			<input type="hidden" class="frmInput status" name="status" value="1"/>
			</li>
			
			
		</ul>
		<hr>
			
		 <button type="button" id="addEmployee"> 사원등록 </button>	<!-- 누르면 사원이 추가됨 -->
		 <!-- <button type="reset" id="noAddEmployee"> 사원등록취소 </button> -->	<!-- 누르면 사원 추가가 취소 되고 관리자 페이지로 돌아감.  -->
		 <a href="<%= ctxPath%>/employee/mypage"id="noAddEmployee">사원등록취소</a>
	
		</form>
		
	</div>

</div>