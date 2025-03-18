<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String ctxPath = request.getContextPath();
   //     /flowUp
%>  

<jsp:include page="../../header/header.jsp" />
<jsp:include page="./myPageLeftBar.jsp" />

<link href="<%=ctxPath%>/css/employeeCss/updateEmployee_by_addmin.css" rel="stylesheet"> 

<script type="text/javascript">

	$(document).ready(function(){
		
		all_employee_info_list();
		
		$(document).on("click", "input.inputemployee", function(e){
			
			$("body").find("input.inputemployee").css({border:"none", color:"", borderRadius:""});
			$("body").find("button.update").css({backgroundColor:"", color:"", borderRadius:""});
			
			const tr = $(e.target).parent().parent();
			tr.find("input.inputemployee").css({border:"solid 2px gray", color:"#b30000", borderRadius:"5px"});
			tr.find("button.update").css({backgroundColor:"#3c3c48", color:"white", borderRadius:"5px", width:"100%"});
			
		});
		
	});// end of $(document).ready(function{});------------------------
	
	
	function all_employee_info_list() {
		$.ajax({
			url:"<%=ctxPath%>/employee/all_employee_info_list",
			type:"get",
			datatype:"json",
			async: false,
			success:function(json){
				//console.log(JSON.stringify(json));
				/*
				[{"departmentname":"총무부","positionname":"전무","name":"서영학","Teamname":"총무팀","employeeno":"111111"},
				 {"departmentname":"영업부","positionname":"차장","name":"전동석","Teamname":"고객관리팀","employeeno":"100027"},
				 {"departmentname":"경영관리부","positionname":"과장","name":"배트맨","Teamname":"경영기획관리팀","employeeno":"100026"},
				 {"departmentname":"영업부","positionname":"과장","name":"홍길동","Teamname":"고객관리팀","employeeno":"100025"},
				 {"departmentname":"총무부","positionname":"사장","name":"김봉춘","Teamname":"총무팀","employeeno":"100024"},
				 {"departmentname":"영업부","positionname":"대리","name":"김태희","Teamname":"국내영업팀","employeeno":"100023"},
				 {"departmentname":"영업부","positionname":"상무","name":"아이유","Teamname":"해외영업팀","employeeno":"100022"},
				 {"departmentname":"물류부","positionname":"사원","name":"주지훈","Teamname":"자재파트","employeeno":"100021"},
				 {"departmentname":"물류부","positionname":"전무","name":"이동훈","Teamname":"경영기획관리팀","employeeno":"100020"},
				 {"departmentname":"영업부","positionname":"부장","name":"원빈 ","Teamname":"경영기획관리팀","employeeno":"100016"},
				 {"departmentname":"경영관리부","positionname":"전무","name":"슈퍼맨","Teamname":"경영기획관리팀","employeeno":"100015"},
				 {"departmentname":"총무부","positionname":"전무","name":"김성훈","Teamname":"경영기획관리팀","employeeno":"100014"},
				 {"departmentname":"영업부","positionname":"상무","name":"이상우","Teamname":"경영기획관리팀","employeeno":"100013"},
				 {"departmentname":"관리부","positionname":"전무","name":"강이훈 ","Teamname":"경영기획관리팀","employeeno":"100012"},
				 {"departmentname":"물류부","positionname":"차장","name":"이지혜","Teamname":"경영기획관리팀","employeeno":"100011"},
				 {"departmentname":"경영관리부","positionname":"사장","name":"윤영주 ","Teamname":"경영기획관리팀","employeeno":"100010"}]
				*/
				
				let v_html="";
				
				v_html += "<table>"
					+		"<thead>"
					+			"<tr>"
					+				"<th>이름</th>"
					+				"<th>사번</th>"
					+				"<th>직급</th>"
					+				"<th>부서</th>"
					+				"<th>팀</th>"
					+				"<th></th>"
					+			"</tr>"
					+		"</thead>"
					+	   "<tbody>";
				
				for(let i=0; i<json.length; i++){
					
				   v_html +="<tr>"
						  +	  	"<td class='employee_name'><input type='text' id='name' class='inputemployee' value='"+json[i].name+"'/></td>"
						  +		"<td class='employee_no'><span class='inputemployee'>"+json[i].employeeno+"</span></td>"
						  +		"<td class='employee_position'><input type='text' id='positionno' class='inputemployee' value='"+json[i].positionname+"'/></td>"
						  +		"<td class='employee_department'><input type='text' id='department' class='inputemployee' value='"+json[i].departmentname+"'/></td>"
						  +		"<td class='employee_team'><input type='text' id='teamname' class='inputemployee' value='"+json[i].Teamname+"'/></td>"
						  +		"<td>"
						  +			"<button class='update' onclick='updateEmployee($(this).parent().parent())'>수정완료</button>"
						  +		"</td>"
						  +	"</tr>"	;
					
				}//end of for-----------------------------
				v_html += "	</tbody>"
						+ "</table>";
						
						
				$("div.table_content").html(v_html);
			 },
		 	 error: function(request, status, error){
				 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			 }
		});//end of $.ajax({});------------
		
	}// end of function all_employee_info_list()--------------- 
	
	// 관리자의 사원정보 수정
	function updateEmployee(elmt){
		
	//	alert(elmt.html());
		<%--
			<td class="employee_name"><input type="text" id="name" class="inputemployee" placeholder="서영학"></td>
			<td class="employee_no"><span class="inputemployee">111111</span></td>
			<td class="employee_position"><input type="text" id="positionno" class="inputemployee" placeholder="전무"></td>
			<td class="employee_department"><input type="text" id="department" class="inputemployee" placeholder="총무부"></td>
			<td class="employee_team"><input type="text" id="teamname" class="inputemployee" placeholder="총무팀"></td>
			<td><button class="update" onclick="updateEmployee($(this).parent().parent())">수정완료</button></td>
		--%>
		
		const name = elmt.find("td.employee_name").find("input").val();
		const employeeNo = elmt.find("td.employee_no").find("span").text();
		const positionName = elmt.find("td.employee_position").find("input").val();     //  !!!!!!!!
		const departmentName = elmt.find("td.employee_department").find("input").val(); // !!!!!!!!
		const teamName = elmt.find("td.employee_team").find("input").val(); // !!!!!!! 
		
		$.ajax({
			url:"<%= ctxPath%>/employee/updateEmployee_byAdminEnd",
			data:{"name":name, "employeeNo":employeeNo, "positionName":positionName, "departmentName":departmentName, "teamName":teamName},
			dataType:"json",
			type:"post",
			async: false,
			success:function(json){
			    // alert(JSON.stringify(json));
				// {"n":1}
				
				if(json.n == 1) {
					alert("수정완료 되었습니다.");
					all_employee_info_list();	
				}
			},
			error: function(request, status, error){
			 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 	}
		});
		
	<%--	
		const frm = document.updateEmployee_by_addmin
		 frm.action = "<%= ctxPath%>/employee/updateEmployee_byAdminEnd";
	     frm.method = "post";
	     frm.submit();
	--%>     
	}

</script>


<div style="margin:0 1.5%;">
	<div class="content_title">
		<h4>관리자의 사원 정보 수정</h4>
	</div>
	<div id="content">
		<form name = "updateEmployee_by_addmin">
		
			<!-- <select class="search_type">
				<option>사번</option>
				<option>팀</option>
				<option>부서</option>
				<option>이름</option>
			</select> -->
			<!-- <input type=text/>
			<button class="search_employee">검색</button> -->
			
			<div class="table_content"></div>
		 <a href="<%= ctxPath%>/employee/mypage"id="noAddEmployee">사원등록취소</a>
		</form>
	
	</div>
</div>