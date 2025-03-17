<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
   String ctxPath = request.getContextPath();

	Date date = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd(E)");
	String today = sdf.format(date);
	
%>

<jsp:include page="document_main.jsp" />

<!-- ikon -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" />

<!-- jsTree -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />

<!-- jsTree boot jQ cdn -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<script type="text/javascript">
	
	$(document).ready(function(){
	
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		<%-- jsTree 에 들어갈 객체 배열 --%>
		let jsonData = [];
		
		<%-- jsTree 조직도에 들어갈 부서 목록 가져오기 --%>
		$.ajax({
			url:"<%= ctxPath%>/document/getDepartmentList",
			dataType:"json",
			async:false,
			success: function(json){
				$.each(json, function(index, item){
					// id 구분을 위해 부서에는 D 를 붙여준다.
					let data = { "id" : "D-" + item.departmentNo, "parent" : "#", "text" : item.departmentName, "icon" : "fa-solid fa-building" }
					jsonData.push(data);
				}); // end of $.each--------------
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of $.ajax-------------------
  
		<%-- jsTree 조직도에 들어갈 팀 목록 가져오기 --%>
		$.ajax({
			url:"<%= ctxPath%>/document/getTeamList",
			dataType:"json",
			async:false,
			success: function(json){
				$.each(json, function(index, item){
					// id 구분을 위해 팀에는 T 를 붙여준다.
					let data = { "id" : "T-" + item.teamNo, "parent" : "D-" + item.fk_departmentNo , "text" : item.teamName, "icon" : "fa-solid fa-users-between-lines" }
					jsonData.push(data);
				}); // end of $.each--------------
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of $.ajax-------------------
		
		<%-- jsTree 조직도에 들어갈 사원 목록 가져오기 --%>
		$.ajax({
			url:"<%= ctxPath%>/document/getEmployeeList",
			dataType:"json",
			async:false,
			success: function(json){
				$.each(json, function(index, item){
					let data = { "id" : item.employeeNo, "parent" : "T-" + item.fk_teamNo , "text" : item.name, "icon" : "fa-solid fa-user" }
					jsonData.push(data);
				}); // end of $.each--------------
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		}); // end of $.ajax-------------------
		
		<%-- jsTree 띄우는 이벤트 --%>
		$('#jstree').jstree({
			'plugins': ["search", "html"], // 플러그인 배열 합침
			'core' : {
				"check_callback": true,
				'data' : jsonData,
 				'state': {
 					'opened': true
 				},
			},
			"search": {
		        "case_sensitive": false,	// 대소문자 구분하지 않음
		        "show_only_matches": true,  // 일치하는 노드만 검색
		        "search_leaves_only": true  // 리프노드만 검색
		    }
		});
		
		<%-- 사원명 검색시 해당 노드만 펼쳐지는 이벤트 --%>
		$("input:text[name='member_name']").on("keyup", function(e){
			
			const member_name = $(e.target).val();
			$('#jstree').jstree(true).search(member_name);
		});
		
		<%-- show 버튼을 누르면 모든 노드를 펼치는 이벤트 --%>
		$("button#btnShow").click(function() {
			$('#jstree').jstree("open_all");
		});

		<%-- hide 버튼을 누르면 모든 노드를 접는 이벤트 --%>
		$("button#btnHide").click(function() {
			$('#jstree').jstree("close_all");
		});
		
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		<%-- 모달에서 취소 버튼을 클릭했을 때 모달이 사라지게 하기 --%>
		$("button#cancel_approval_line").click(e=>{
			close_modal();
		});
		
		<%-- 모달 바깥 부분을 클릭했을 때 모달이 사라지게 하기 --%>
	    $('.modal_bg:not(.modal_container_document)').click(e=>{
	    	close_modal();
	    });
		
		<%-- 결재 정보 버튼을 눌렀을 때 모달이 보이게 하는 이벤트 --%>
		$('#approval_line_btn').click(e=>{
			
	        $('#approval_line_bg').fadeIn();
			$('#approval_line_container').css({
				'display':'block'
			});
	    });
		
		//////////////////////////////////////////////////////////////////////////////////////////////////

		
		<%-- 조직도에서 사원을 선택하지 않으면 	사원추가를 할 수 없게 하는 이벤트 --%>
		$("#add_approval_btn").css({"pointer-events":"none"}); // 추가 버튼 비활성화
		
		$("div#jstree").on("click", "a.jstree-anchor", function(e){
			
			let id = $(e.target).attr("id") + ""; // 선택한 태그의 id 값
			
			if(!isNaN(id.substr(0,1))) {
				// id 의 첫글자가 숫자라면 (사원이라면)
				
				$("#add_approval_btn").css({"pointer-events":""}); // 추가 버튼 활성화
			}
			else {
				// id 의 첫글자가 숫자가아니라면 (부서 또는 팀이라면)
				
				$("#add_approval_btn").css({"pointer-events":"none"}); // 추가 버튼 비활성화
			}
		});
		
		<%-- 조직도에서 >> 버튼을 눌러 사원을 결재 라인으로 추가하는 이벤트 --%>
		$("button#add_approval_btn").on('click', function(e) {
			
			// jstree 에서 선택한 사원의 사원번호
			let employeeNo = $('#jstree').jstree('get_selected',true)[0].id;
			
			if($("tbody#added_approval_line").children().length > 2) { // 사원은 3명까지만 추가 가능
				alert("더 이상 추가할 수 없습니다.");
			}
			else {
				
				let isExist = false; // 이미 추가된 사원인지 확인하는 변수
				
				// 이미 추가된 사원인지 확인하는 for 문
				$("tbody#added_approval_line").find("td.selected_employee_no").each(function(){
					if(employeeNo == $(this).html()) {
						// for 문 안에서 선택된 사원번호와 추가된 사원번호가 같은지 확인
						
						alert("이미 추가된 사원입니다.");
						isExist = true;
						return;
					}
				});
				
				// 추가되지 않은 사원이라면
				if(!isExist) {
					
					$.ajax({
						url:"<%= ctxPath%>/document/getEmployeeOne",
						dataType:"json",
						data:{"employeeNo":employeeNo},
						success:function(json){
							// ajax 로 사원 정보를 가져온 후 결재 라인으로 추가한다.
							let v_html=`<tr>
											<td class='selected_employee_no' style='display: none'>\${json.employeeNo}</td>
											<td class='selected_security_level' style='display: none'>\${json.securityLevel}</td>
											<td class='selected_employee_teamName'>\${json.teamName}</td>
											<td class='selected_employee_name'>\${json.name}</td>
											<td class='selected_employee_positionName'>\${json.positionName}</td>
											<td class='delete_approver'><a class='delete_approver' style="cursor: pointer; color: black;"><i class="fa-solid fa-trash-can"></i></a></td>
										</tr>`;
										
							$("tbody#added_approval_line").append(v_html);
							
							$('#jstree').jstree("deselect_all"); // jstree 노드 전체 선택 해제
							$("button#add_approval_btn").css({"pointer-events":"none"});	// 결재 라인 추가 버튼 비활성화
						},
						error: function(request, status, error){
							alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
						}
						
					})
				}
			}
			
		}); 
		
		<%-- 모달에서 결재 라인에서 삭제 버튼 클릭 시 추가된 사원을 삭제하는 이벤트 --%>
		$("tbody#added_approval_line").on('click', "a.delete_approver", function(e) {
			$(e.target).parent().parent().parent().remove();
		});

	    <%-- 모달에서 확인 버튼을 클릭했을 때 추가된 결재 라인이 메인 페이지에 보이게 하는 이벤트 --%>
	    $("button#submit_approval_line").click(e=>{
	    	if($("tbody#added_approval_line").children().length < 1) {
	    		// 결재 라인에 한명도 추가하지 않았을 경우
	    		alert("결재 라인을 추가해주세요");
			}
	    	else {
	    		const approval_line_arr = []; // 결재 라인을 담아줄 배열
	    		
	    		$("tbody#added_approval_line").children().each(function(item, index){
	    			let approver = {selected_employee_no:$(this).find("td.selected_employee_no").html(),
	    							selected_security_level:$(this).find("td.selected_security_level").html(),
	    							selected_employee_teamName:$(this).find("td.selected_employee_teamName").html(),
	    							selected_employee_name:$(this).find("td.selected_employee_name").html(),
	    							selected_employee_positionName:$(this).find("td.selected_employee_positionName").html()}
	    			
	    			approval_line_arr.push(approver);
	    		});
	    		
	    		approval_line_arr.sort((a, b) => Number(a.selected_security_level) - Number(b.selected_security_level));
	    		// 결재 라인을 security_level 순으로 정렬
	    		
	    		v_html = ``;
	    		
	    		// 모달에서 추가된 결재 라인을 메인 페이지에 넣어주기
	    		$.each(approval_line_arr, function(index, element){
		    		v_html += `<table class="ml-2" style="display: inline-block;">
		    						<thead>
		    							<tr>
		    								<th colspan='2'>결재자</th>
		    							</tr>
		    						</thead>
									<tbody>
										<tr>
											<th>부서</th>
											<td>\${element.selected_employee_teamName}</td>
										</tr>
										<tr>
											<th>이름</th>
											<td>\${element.selected_employee_name}</td>
										</tr>
										<tr>
											<th>직급</th>
											<td>\${element.selected_employee_positionName}</td>
										</tr>
									</tbody>
								</table>
								<input class='selected_security_level' type='hidden' value='\${element.selected_security_level}'>
		    					<input name='added_employee_no\${index}' type='hidden' value='\${element.selected_employee_no}'>`;
	    			
	    		});
	    		
	    		// 추가된 결재자가 총 몇 명인지 저장
	    		$("input[name='added_approval_count']").val($("tbody#added_approval_line").children().length);
	    		
	    		$("div#approval_line").html(v_html);
	    		
	    		close_modal();
	    	}
	    });
	    
	    
	    <%-- 휴가 신청서 잔여 연차를 가져오는 이벤트 --%>
	    $.ajax({
	    	url:"<%= ctxPath%>/document/annual/getAnnual",
	    	dataType:"json",
	    	success:function(json){
	    		$("input[name='totalAmount']").val(json.totalAmount);
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
	    })
	    
	    
		//////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		let file_arr = []; // 첨부되어진 파일 정보를 담아둘 배열 
 		
 		// == 파일 Drag & Drop 만들기 == //
 		$("div#fileDrop").on("dragenter", function(e) { /* "dragenter" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 최초로 들어왔을 때 */
 			e.preventDefault();
			<%--
				브라우저에 어떤 파일을 drop 하면 브라우저 기본 동작이 실행된다. 
				이미지를 drop 하면 바로 이미지가 보여지게되고, 만약에 pdf 파일을 drop 하게될 경우도 각 브라우저의 pdf viewer 로 브라우저 내에서 pdf 문서를 열어 보여준다. 
				이것을 방지하기 위해 preventDefault() 를 호출한다. 
				즉, e.preventDefault(); 는 해당 이벤트 이외에 별도로 브라우저에서 발생하는 행동을 막기 위해 사용하는 것이다.
			--%>
				
			e.stopPropagation();
			<%--
				propagation 의 사전적의미는 전파, 확산이다.
				stopPropagation 은 부모태그로의 이벤트 전파를 stop 중지하라는 의미이다.
				즉, 이벤트 버블링을 막기위해서 사용하는 것이다. 
				사용예제 사이트 https://devjhs.tistory.com/142 을 보면 이해가 될 것이다. 
			--%>
 		}).on("dragover", function(e) { /* "dragover" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 머물러 있는 중일 때. 필수이벤트이다. dragover 이벤트를 적용하지 않으면 drop 이벤트가 작동하지 않음 */ 
 			e.preventDefault();
 			e.stopPropagation();
 			$(this).css("background-color", "#ffd8d8");
 		}).on("dragleave", function(e){ /* "dragleave" 이벤트는 Drag 한 파일이 드롭대상인 박스 밖으로 벗어났을 때  */
			e.preventDefault();
			e.stopPropagation();
			$(this).css("background-color", "#fff");
		}).on("drop", function(e){      /* "drop" 이벤트는 드롭대상인 박스 안에서 Drag 한것을 Drop(Drag 한 파일(객체)을 놓는것) 했을 때. 필수이벤트이다. */
			e.preventDefault();
		
			var files = e.originalEvent.dataTransfer.files;  
			<%--
				jQuery 에서 이벤트를 처리할 때는 W3C 표준에 맞게 정규화한 새로운 객체를 생성하여 전달한다.
				이 전달된 객체는 jQuery.Event 객체 이다. 이렇게 정규화된 이벤트 객체 덕분에, 
				웹브라우저별로 차이가 있는 이벤트에 대해 동일한 방법으로 사용할 수 있습니다. (크로스 브라우징 지원)
				순수한 dom 이벤트 객체는 실제 웹브라우저에서 발생한 이벤트 객체로, 네이티브 객체 또는 브라우저 내장 객체 라고 부른다.
			--%>
			/*  
				Drag & Drop 동작에서 파일 정보는 DataTransfer 라는 객체를 통해 얻어올 수 있다. 
				jQuery를 이용하는 경우에는 event가 순수한 DOM 이벤트(각기 다른 웹브라우저에서 해당 웹브라우저의 객체에서 발생되는 이벤트)가 아니기 때문에,
				event.originalEvent를 사용해서 순수한 원래의 DOM 이벤트 객체를 가져온다.
				Drop 된 파일은 드롭이벤트가 발생한 객체(여기서는 $("div#fileDrop")임)의 dataTransfer 객체에 담겨오고, 
				담겨진 dataTransfer 객체에서 files 로 접근하면 드롭된 파일의 정보를 가져오는데 그 타입은 FileList 가 되어진다. 
				그러므로 for문을 사용하든지 또는 [0]을 사용하여 파일의 정보를 알아온다. 
			*/
			
			if(files != null && files != undefined) {
				
				for(let i = 0; i < files.length; i++) {
					
					let html = "";
					const f = files[0]; // 어차피 files.length 의 값이 1 이므로 위의 for문을 사용하지 않고 files[0] 을 사용하여 1개만 가져오면 된다.
					let fileSize = f.size/1024/1024; /* 파일의 크기는 MB로 나타내기 위하여 /1024/1024 하였음 */
					
					if( !(f.type == 'image/jpeg' || f.type == 'image/png') ) {
						alert("jpg 또는 png 파일만 가능합니다.");
						$(this).css("background-color", "#fff");
						return;
					}
					else if( fileSize >= 10 ) {
						alert("10MB 이상인 파일은 업로드할 수 없습니다.");
						$(this).css("background-color", "#fff");
						return;
					}
					else {
						file_arr.push(f);
						const fileName = f.name; // 파일명
						fileSize = fileSize < 1 ? fileSize.toFixed(3) : fileSize.toFixed(1);
						// fileSize 가 1MB 보다 작으면 소수부는 반올림하여 소수점 3자리까지 나타내며, 
						// fileSize 가 1MB 이상이면 소수부는 반올림하여 소수점 1자리까지 나타낸다. 만약에 소수부가 없으면 소수점은 0 으로 표시한다.
						/* 
							numObj.toFixed([digits]) 의 toFixed() 메서드는 숫자를 고정 소수점 표기법(fixed-point notation)으로 표시하여 나타난 수를 문자열로 반환해준다. 
											파라미터인 digits 는 소수점 뒤에 나타날 자릿수 로써, 0 이상 20 이하의 값을 사용할 수 있으며, 구현체에 따라 더 넓은 범위의 값을 지원할 수도 있다. 
	
							digits 값을 지정하지 않으면 0 을 사용한다.
	
							var numObj = 12345.6789;
							
							numObj.toFixed();       // 결과값 '12346'   : 반올림하며, 소수 부분을 남기지 않는다.
							numObj.toFixed(1);      // 결과값 '12345.7' : 반올림한다.
							numObj.toFixed(6);      // 결과값 '12345.678900': 빈 공간을 0 으로 채운다.
							
						*/
						
						html +=
							"<div class='fileList'>" +
								"<span class='delete_file'>&times;</span>" +
								"<span class='fileName'>  "+fileName+"</span>" +
								"<span class='fileSize'>  "+fileSize+" MB</span>" +
								"<span class='clear'></span>" +
							"</div>";
						$("div#fileList").append(html);
						
					}
				}
				
			} // end of if(files != null && files != undefined)----------------------------------------
			
			$(this).css("background-color", "#fff");
			
		});
	    
		$("div#fileList").on('click','span.delete_file', function(e){
			let idx = $("span.delete").index($(e.target));
 			
 			file_arr.splice(idx, 1);
			$(e.target).parent().remove();
		});
		
	}); // end of $(document).ready(funtion(){})-----------------------------------

	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	<%-- 공통 함수 --%>
	
	
	<%-- 모달창을 사라지게 하기 --%>
	function close_modal() {
		$('#approval_line_bg').fadeOut();
        $('#approval_line_container').css({
        	'display':''
		});
	}
	
	
	<%-- 결재 요청하기 --%>
	function draft(){
		
		if($("input[name='check_urgent']").is(":checked")) { 
			// 긴급 체크되어 있는 경우
			$("input[name='urgent']").val("1");
		}
		
		const queryString = $("form[name='draftForm']").serialize();
		
		$.ajax({
			url:"<%= ctxPath%>/document/draft",
			data:queryString,
			type:"post",
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				if(json.n == "1"){ // 결재 요청이 성공했을 경우
					
					if($("td#documentNo").text().trim() != "") {
						// 임시저장 문서를 수정해서 결재 요청하는 경우
						deleteTemp($("td#documentNo").text().trim()); // 해당 임시 저장 문서 삭제
					}
					
					alert("결재 요청이 완료되었습니다.");
					location.href=`<%= ctxPath%>/document/documentView?documentNo=\${json.documentNo}&documentType=\${json.documentType}`;
				}
				else if(json.n == "-1"){
					alert("중복되는 휴가 일자입니다.");
				}
				else if(json.n == "-2"){
					alert("중복되는 연장 근무 일자입니다.");
				}
				else if(json.n == "-3"){
					alert("당일 6시 이후에는 연장 근무 신청이 불가능합니다.");
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
	} // end of function draft(){}-----------------------------------------------------
	
	
	<%-- 임시 저장 함수 --%>
	function saveTemp(){
		
		if($("input[name='check_urgent']").is(":checked")) { 
			// 긴급 체크되어 있는 경우
			$("input[name='urgent']").val("1");
		}
		
		const queryString = $("form[name='draftForm']").serialize();
		console.log(queryString);
			
		$.ajax({
			url:"<%= ctxPath%>/document/saveTemp",
			data:queryString,
			type:"post",
			dataType:"json",
			success:function(json){
				console.log(JSON.stringify(json));
				if(json.n == "1"){
					alert("임시 저장이 완료되었습니다.");
					location.href=`<%= ctxPath%>/document/documentView?documentNo=\${json.documentNo}&documentType=\${json.documentType}`;
				}
				else {
					alert("임시 저장이 실패되었습니다.");
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
	} // end of function saveTemp(){}---------------------------------------------
	
	
	<%-- 임시 저장 문서 삭제하는 함수 --%>
	function deleteTemp(documentNo){
		$.ajax({
			url:"<%=ctxPath%>/document/documentView/deleteTemp",
			dataType:"json",
			async:false,
			data:{"documentNo":documentNo},
			success:function(json){
				if(json.n == 1) {
					alert("임시 저장 문서 삭제 성공");
				}
				else {
					alert("임시 저장 문서 삭제 실패");
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
	} // end of function deleteTemp(documentNo){}-----------------------------------------
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	<%-- 휴가 신청서 함수 --%>
	
	
	<%-- 사용연차 개수 계산하는 함수 --%>
	function calAnnualAmount(){
		
		// 오늘 날짜를 'yyyy-mm-dd' 까지 자르기
		let today = new Date().toISOString().substring(0,10);

		// 휴가 신청 날짜
		let startDate = $("input[name='startDate']").val();
		let endDate = $("input[name='endDate']").val();
		
		// 입력한 날짜의 요일 가져오기
		let startDay = new Date(startDate).getDay();
		let endDay = new Date(endDate).getDay();
		
		if(startDate <= today) {
			// 오늘 날짜보다 이전 날짜를 선택하면
			alert("오늘보다 이전 날짜에는 휴가 신청이 불가능합니다.");
			$("input[name='startDate']").val("");
			return;
		}
		
		// 0이면 일요일, 6이면 토요일
		if(startDay == 0 || startDay == 6) {
			alert("주말에는 휴가 신청이 불가능합니다.");
			$("input[name='startDate']").val("");
			return;
		}
		
		// 0이면 일요일, 6이면 토요일
		if(endDay == 0 || endDay == 6) {
			alert("주말에는 휴가 신청이 불가능합니다.");
			$("input[name='endDate']").val("");
			return;
		}
		
		if($("select[name='annualType']").val() != "1") {
			// 반차일 경우
			
			$("input[name='endDate']").val($("input[name='startDate']").val());
			$("input[name='endDate']").hide(); // 종료일 선택을 숨기기
			
			if($("input[name='startDate']").val() != ""){
				$("input[name='useAmount']").val(0.5);	// 신청 연차에 값 넣어주기
			}
		}
		else {
			// 연차일 경우
			$("input[name='endDate']").show();	// 종료일 선택 다시 보여주기
			
			if(startDate != "" && endDate != "") {
				// 시작일과 종료일 둘 다 선택했을 경우
				
				if(startDate <= endDate) {
					// 종료일이 시작일 이후인 경우
					let diffDays = Math.ceil( ( (new Date(endDate)).getTime() - (new Date(startDate)).getTime() ) / (1000 * 3600 * 24) );
					
					let weekends = 0; // 주말 수
					
					for (let i = 0; i <= diffDays; i++) {
						let currentDate = new Date((new Date(startDate)).getTime() + i * (1000 * 3600 * 24));
						if (currentDate.getDay() === 0 || currentDate.getDay() === 6) {
							weekends++;
						}
					}
					
					let useAmount = diffDays - weekends + 1;

					if($("input[name='totalAmount']").val() < useAmount) {
						alert("잔여 연차보다 초과해서 사용할 수 없습니다!");
						$("input[name='endDate']").val("");
						$("input[name='useAmount']").val("0");
					}
					else {
						$("input[name='useAmount']").val(useAmount);
					}
				}
				else {
					// 종료일이 시작일 이전인 경우
					alert("종료일은 시작일보다 이후여야 합니다.");
					
					$("input[name='endDate']").val("");		// 값 초기화
				}
			}
		}
	} // end of function calAnnualAmount(){}------------------------
	
	
	<%-- 휴가신청서 결재요청하는 함수 --%>
	function annualDraft(){
		
		if($("input[name='subject']").val().trim() == "") {	// 제목을 입력하지 않았을 경우
			alert("제목을 입력하세요!")
			return;
		}
		if($("input[name='reason']").val().trim() == "") {	// 휴가사유를 입력하지 않았을 경우
			alert("휴가사유를 입력하세요!");
			return;
		}
		if($("input[name='startDate']").val() == "" || $("input[name='startDate']").val() == "0000-00-00") {// 연차 시작일을 입력하지 않았을 경우
			alert("연차 시작일을 입력하세요!");
			return;
		}
		if($("input[name='endDate']").val() == "" || $("input[name='endDate']").val() == "0000-00-00") {	// 연차 종료일을 입력하지 않았을 경우
			alert("연차 종료일을 입력하세요!");
			return;
		}
		if($("div#approval_line").children().length == 0) {
			alert("결재 라인을 추가해주세요!");
			return;
		}
		
		draft(); // 결재 요청하기
		
	} // end of function annualDraft(){}---------------------------------------------
	
	
	//////////////////////////////////////////////////////////////////////////////////////////////////
	<%-- 연장근무신청서 함수 --%>
	
	
	<%-- 신청하는 날이 주말 또는 오늘 이전 날짜인지 확인하는 함수 --%>
	function check_weekend(obj) {
		
		// 오늘 날짜를 'yyyy-mm-dd' 까지 자르기
		let today = new Date().toISOString().substring(0,10);

		// 연장근무 신청 날짜
		let checkDate = $(obj).val();
		
		if(checkDate < today) {
			// 오늘 날짜보다 이전 날짜를 선택하면
			$("span#check_weekend").text("오늘보다 이전 날짜는 선택이 불가능합니다.");
			return;
		}
		else {
			$("span#check_weekend").empty();
		}
		
		// 입력한 날짜의 요일 가져오기
		let checkDay = new Date(checkDate).getDay();
		
		// 0이면 일요일, 6이면 토요일
		if(checkDay == 0 || checkDay == 6) {
			$("span#check_weekend").text("주말은 선택이 불가능합니다.");
			return;
		}
		else {
			$("span#check_weekend").empty();
		}
		
		
	} // end of function check_weeken(){}------------------------
	
	
	<%-- 연장근무신청서 결재요청하는 함수 --%>
	function overtimeDraft(){
		
		if($("input[name='subject']").val().trim() == "") {	// 제목을 입력하지 않았을 경우
			alert("제목을 입력하세요!")
			return;
		}
		if($("input[name='reason']").val().trim() == "") {	// 연장 근무 사유를 입력하지 않았을 경우
			alert("연장 근무 사유를 입력하세요!");
			return;
		}
		if($("input[name='overtimeDate']").val() == "") {	// 연장 근무 일자를 입력하지 않았을 경우
			alert("연장 근무 일자를 입력하세요!");
			return;
		}
		if($("span#check_weekend").text() != "") {			// 연장 근무 일자를 주말로 입력했을 경우
			alert("올바르지 않은 날짜입니다!");
			return;
		}
		if($("div#approval_line").children().length == 0) {	// 결재자를 한명도 추가하지 않았을 경우
			alert("결재 라인을 추가해주세요!");
			return;
		}
		
		let no = $("tbody.expense_detail tr").length/2;
		$("input[name='expense_detail_count']").val(no);
		
		draft(); // 결재 요청하기
		
	} // end of function overtimeDraft(){}---------------------------------------------
	
	
	<%-- 업무기안 결재요청하는 함수 --%>
	function businessDraft() {
		
		if($("input[name='subject']").val().trim() == "") {	// 제목을 입력하지 않았을 경우
			alert("제목을 입력하세요!")
			return;
		}
		if($("input[name='doDate']").val() == "") {			// 시행 일자를 입력하지 않았을 경우
			alert("시행 일자를 입력하세요!");
			return;
		}
		if($("textarea[name='businessContent']").val().trim() == "") {		// 내용을 입력하지 않았을 경우
			alert("내용을 입력하세요!");
			return;
		}
		if($("span#check_weekend").text() != "") {			// 시행 일자를 주말로 입력했을 경우
			alert("올바르지 않은 날짜입니다!");
			return;
		}
		if($("div#approval_line").children().length == 0) {	// 결재자를 한명도 추가하지 않았을 경우
			alert("결재 라인을 추가해주세요!");
			return;
		}
		
		draft(); // 결재 요청하기
		
	}
	
	
	////////////////////////////////////////////////////////////////////////////
	<%-- 지출품의서 함수 --%>
	
	<%-- 지출 내역 추가하기 --%>
	function add_expense_detail() {
		let no = $("tbody.expense_detail tr").length;
		if(no < 3) {
			let html = `<tr>
							<td><input type="date" class="useDate"	name="useDate\${no}" onkeydown="return false" style="width: 100%;"/></td>
							<td><input type="text" class="type"		name="type\${no}" style="width: 100%;"/></td>
							<td><input type="number" class="amount" name="amount\${no}" onchange="check_amount(this)" onkeyup="check_amount(this)" style="width: 100%;"/></td>
							<td><input type="text" class="content" name="content\${no}" style="width: 100%;"/></td>
							<td><input type="text" class="note"	 name="note\${no}" style="width: 100%;"/></td>
						</tr>`;
			
			$("tbody.expense_detail").append(html);
		}
		else {
			alert("더 이상 추가할 수 없습니다.");
		}
	}
	
	<%-- 지출 내역 삭제하기 --%>
	function delete_expense_detail() {
		if($("tbody.expense_detail").children().length > 1) {
			$("tbody.expense_detail tr:last-child").remove();
		}
		else {
			alert("더 이상 삭제할 수 없습니다.");
		}
	}
	
	
	<%-- 지출품의서 금액을 검사하는 함수 --%>
	function check_amount(obj) {
		
		if(!Number.isInteger(Number($(obj).val()))) {
			alert("정수만 입력 가능합니다.");
			$(obj).val(Math.round(Number($(obj).val())));
		}
		
		if($(obj).val() < 0) {
			alert("음수는 입력이 불가능합니다.");
			$(obj).val(0);
		}
		
		let totalAmount = 0;
		
		$("input.amount").each(function(index, item){
			totalAmount += Number($(item).val());
		});
		
		$("input[name='totalExpenseAmount']").val(totalAmount);
	}
	
	
	<%-- 지출품의서 결재요청하는 함수 --%>
	function expenseDraft() {
		
		if($("input[name='subject']").val().trim() == "") {	// 제목을 입력하지 않았을 경우
			alert("제목을 입력하세요!")
			return;
		}
		if($("input[name='totalExpenseAmount']").val() == 0) {			// 금액을 입력하지 않았을 경우
			alert("금액을 입력하세요!");
			return;
		}
		if($("textarea[name='reason']").val().trim() == "") {		// 지출사유를 입력하지 않았을 경우
			alert("지출사유를 입력하세요!");
			return;
		}
		
		let check = true;
		
		$("input.useDate").each(function(index, item){
			if($(item).val().trim() == "") {
				check = false;
			}
		});
		
		if(!check) {
			alert("사용일자를 입력하세요!");
			return;
		}
		
		$("input.type").each(function(index, item){
			if($(item).val().trim() == "") {
				check = false;
			}
		});
		
		if(!check) {
			alert("분류를 입력하세요!");
			return;
		}
		
		$("input.amount").each(function(index, item){
			if($(item).val() == 0) {
				check = false;
			}
		});
		
		if(!check) {
			alert("금액을 입력하세요!");
			return;
		}
		
		$("input.content").each(function(index, item){
			if($(item).val().trim() == "") {
				check = false;
			}
		});
		
		if(!check) {
			alert("사용내역을 입력하세요!");
			return;
		}
		
		if($("div#approval_line").children().length == 0) {	// 결재자를 한명도 추가하지 않았을 경우
			alert("결재 라인을 추가해주세요!");
			return;
		}
		
		draft(); // 결재 요청하기
		
	}
	
	////////////////////////////////////////////////////////////////////////////
	
	
	
</script>
	
	
	
	<!-- 결재라인 모달 -->
	<div id="approval_line_bg" class="modal_bg">
		<!-- 모달창을 띄웠을때의 뒷 배경 -->
	</div>
	<div id="approval_line_container" class="box_modal_container p-3">
		<div class="mt-3 mb-3">
			<h3>결재 정보</h3>
		</div>
		<div style="display: flex;">
			<div style="width: 40%;" >
				<div id="approval_line_content" class="approval_line_modal_content">
					<div>
						<button type="button" id="btnShow" class="btn btn-secondary btn-sm">열기</button>
						<button type="button" id="btnHide" class="btn btn-secondary btn-sm">닫기</button>
						<input type="text" name='member_name' placeholder="사원 검색" class="my-1"/>
						<div id="jstree" style="overflow: scroll; max-height: 250px; border: solid 1px #333;"></div>
					</div>
				</div>
			</div>
			<div style="display: flex;" class="mx-1">
				<button id="add_approval_btn" class="doc_btn" style="margin: auto; border: none;"><i class="fa-solid fa-forward" style="font-size: 30px;"></i></button>
			</div>
			<div style="border: solid 1px gray; width: 50%; margin-right: 0;">
				<div>
					<table class="table">
						<thead class="doc_box_thead">
							<tr>
								<th>부서</th>
								<th>이름</th>
								<th>직급</th>
								<th>삭제</th>
							</tr>
						</thead>
						<tbody id="added_approval_line">
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="mt-1">
			<button id="submit_approval_line" class="btn btn-secondary btn-sm">확인</button>
			<button id="cancel_approval_line" class="btn btn-secondary btn-sm">취소</button>
		</div>
	</div>
		

    <%-- 결재 폼 공통 --%>
	<div class="m-3">
		<c:if test="${requestScope.documentType == '휴가신청서'}">
			<h3 class="mb-3">휴가신청서</h3>
			<button class="btn btn-secondary btn-sm" onclick="annualDraft()">결재요청</button>
		</c:if>
		<c:if test="${requestScope.documentType == '연장근무신청서'}">
			<h3 class="mb-3">연장근무신청서</h3>
			<button class="btn btn-secondary btn-sm" onclick="overtimeDraft()">결재요청</button>
		</c:if>
		<c:if test="${requestScope.documentType == '지출품의서'}">
			<h3 class="mb-3">지출품의서</h3>
			<button class="btn btn-secondary btn-sm" onclick="expenseDraft()">결재요청</button>
		</c:if>
		<c:if test="${requestScope.documentType == '업무기안'}">
			<h3 class="mb-3">업무기안</h3>
			<button class="btn btn-secondary btn-sm" onclick="businessDraft()">결재요청</button>
		</c:if>
		<button class="btn btn-secondary btn-sm" onclick="saveTemp()">임시저장</button>
		<!-- <button class="doc_btn mr-3">미리보기</button> -->
		<button class="btn btn-secondary btn-sm" id="approval_line_btn">결재 정보</button>
	</div>
	<div class="m-3 draftForm">
		<form name="draftForm">
		
			<input type="hidden" name="temp" value="0" />
			
			<c:if test="${requestScope.documentType == '휴가신청서'}">
				<h3 style="text-align: center" class="mb-5">연차신청서</h3>
			</c:if>
			<c:if test="${requestScope.documentType == '연장근무신청서'}">
				<h3 style="text-align: center" class="mb-5">연장근무신청서</h3>
			</c:if>
			<c:if test="${requestScope.documentType == '지출품의서'}">
				<h3 style="text-align: center" class="mb-5">지출품의서</h3>
			</c:if>
			<c:if test="${requestScope.documentType == '업무기안'}">
				<h3 style="text-align: center" class="mb-5">업무기안</h3>
			</c:if>
			
			<div style="display: flex">
				<div class="drafter_info" style="display: inline-block;">
					<table>
						<tbody>
							<tr>
								<th>기안자</th>
								<td>
									<c:if test="${empty requestScope.document}">
										${sessionScope.loginuser.name}
									</c:if>
									<c:if test="${not empty requestScope.document}">
										${requestScope.document.name}
									</c:if>
								</td>
							</tr>
							<tr>
								<th>소속</th>
								<td>
									<c:if test="${empty requestScope.document}">
										${sessionScope.loginuser.teamName}
									</c:if>
									<c:if test="${not empty requestScope.document}">
										${requestScope.document.teamName}
									</c:if>
								</td>
							</tr>
							<tr>
								<th>기안일</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<%= today%>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										${requestScope.document.draftDate}
									</c:if>
								</td>
							</tr>
							<tr>
								<th>문서번호</th>
								<td id="documentNo">
									<c:if test="${not empty requestScope.document}">
										${requestScope.document.documentNo}
									</c:if>
								</td>
							</tr>
							
						</tbody>
					</table>
				</div>
				<div style="margin-left: auto;">
				
					<%-- 결재 라인이 들어올 곳 --%>
					<div class="approval_info" id="approval_line" style="text-align: right; display: inline-block; width: 100%">
						<c:if test="${not empty requestScope.approvalList}">
							<c:forEach var="approval" items="${requestScope.approvalList}" varStatus="status">
								<table class="ml-2" style="display: inline-block;">
									<thead>
		    							<tr>
		    								<th colspan='2'>결재자</th>
		    							</tr>
		    						</thead>
									<tbody>
										<tr>
											<th>부서</th>
											<td>${approval.teamName}</td>
										</tr>
										<tr>
											<th>이름</th>
											<td>${approval.name}</td>
										</tr>
										<tr>
											<th>직급</th>
											<td>${approval.positionName}</td>
										</tr>
									</tbody>
								</table>
		    					<input name='added_employee_no${status.index}' type='hidden' value='${approval.fk_approver}'>
							</c:forEach>
						</c:if>
					</div>
					<%-- 결재 라인이 들어올 곳 --%>
					
					
					<%-- 결재자 몇 명인지 저장 --%>
					<c:if test="${empty requestScope.approvalList}">
						<input name='added_approval_count' type='hidden' value='0'/>
					</c:if>
					<c:if test="${not empty requestScope.approvalList}">
						<input name='added_approval_count' type='hidden' value='${fn:length(requestScope.approvalList)}'/>
					</c:if>
				</div>
			</div>
			<%-- 결재 폼 공통 --%>
			
			
			<div class="document_info">
			
				<%-- 휴가신청서 폼 --%>
				<c:if test="${requestScope.documentType == '휴가신청서'}">
					<input type="hidden" name="documentType" value="휴가신청서" />
					<table class="mt-5" style="width: 100%">
						<tbody>
							<tr>
								<th>긴급</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input class="ml-1" type="checkbox" name="check_urgent"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input class="ml-1" type="checkbox" name="check_urgent" checked="checked"/>
									</c:if>
									<input type="hidden" name="urgent" value="0"/>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="text" name="subject" value=" " style="width: 100%;"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="text" name="subject" value="${requestScope.document.subject}" style="width: 100%;"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>휴가 종류</th>
								<td>
									<select name="annualType" onchange="calAnnualAmount()">
										<c:if test="${empty requestScope.document}">
											<option value="1">연차</option>
											<option value="2">오전반차</option>
											<option value="3">오후반차</option>
										</c:if>
										<c:if test="${not empty requestScope.document}">
											<c:if test="${requestScope.document.annualType == 1}">
												<option value="1" selected>연차</option>
												<option value="2">오전반차</option>
												<option value="3">오후반차</option>
											</c:if>
											<c:if test="${requestScope.document.annualType == 2}">
												<option value="1">연차</option>
												<option value="2" selected>오전반차</option>
												<option value="3">오후반차</option>
											</c:if>
											<c:if test="${requestScope.document.annualType == 3}">
												<option value="1">연차</option>
												<option value="2">오전반차</option>
												<option value="3" selected>오후반차</option>
											</c:if>
										</c:if>
									</select>
								</td>
							</tr>
							<tr>
								<th>사유</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="text" name="reason" value=" " style="width: 100%;"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="text" name="reason" value="${requestScope.document.reason}" style="width: 100%;"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>기간 및 일시</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="date" name="startDate" onchange="calAnnualAmount()" onkeydown="return false" />
										<input type="date" name="endDate"   onchange="calAnnualAmount()" onkeydown="return false" />
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<c:if test="${requestScope.document.startDate eq '-'}">
											<input type="date" name="startDate" onchange="calAnnualAmount()" onkeydown="return false" />
										</c:if>
										<c:if test="${requestScope.document.startDate ne '-'}">
											<input type="date" name="startDate" onchange="calAnnualAmount()" value="${requestScope.document.startDate}" onkeydown="return false" />
										</c:if>
										<c:if test="${requestScope.document.annualType eq 1}">
											<c:if test="${requestScope.document.endDate eq '-'}">
												<input type="date" name="endDate" onchange="calAnnualAmount()" onkeydown="return false" />
											</c:if>
											<c:if test="${requestScope.document.endDate ne '-'}">
												<input type="date" name="endDate" onchange="calAnnualAmount()" value="${requestScope.document.endDate}" onkeydown="return false" />
											</c:if>
										</c:if>
										<c:if test="${requestScope.document.annualType eq 2 || requestScope.document.annualType eq 3}">
											<c:if test="${requestScope.document.endDate eq '-'}">
												<input type="date" name="endDate" onchange="calAnnualAmount()" onkeydown="return false" style="display: none;" />
											</c:if>
											<c:if test="${requestScope.document.endDate ne '-'}">
												<input type="date" name="endDate" onchange="calAnnualAmount()" value="${requestScope.document.endDate}" onkeydown="return false" style="display: none;" />
											</c:if>
										</c:if>
									</c:if>
									<span id="check_weekend" class="alert"></span>
								</td>
							</tr>
							<tr>
								<th>연차 일수</th>
								<td>
									잔여 연차 : <input type="text" name="totalAmount" readonly />
									<c:if test="${empty requestScope.document}">
										신청 연차 : <input type="text" name="useAmount" value="0" readonly />
									</c:if>
									<c:if test="${not empty requestScope.document}">
										신청 연차 : <input type="text" name="useAmount" value="${requestScope.document.useAmount}" readonly />
									</c:if>
									</td>
							</tr>
							<tr>
								<th class="pl-4" colspan="2" style="text-align: left;">
									1. 연차의 사용은 근로기준법에 따라 전년도에 발생한 개인별 잔여 연차에 한하여 사용함을 원칙으로 한다.
									<br>단, 최초 입사시에는 근로 기준법에 따라 발생 예정된 연차를 차용하여 월 1회 사용 할 수 있다.
									<br>2. 경조사 휴가는 행사일을 증명할 수 있는 가족 관계 증명서 또는 등본, 청첩장 등 제출
									<br>3. 공가(예비군/민방위)는 사전에 통지서를, 사후에 참석증을 반드시 제출
								</th>
							</tr>
						</tbody>
					</table>
				</c:if>
				<%-- 휴가신청서 폼 --%>
				
				
				<%-- 연장근무신청서 폼 --%>
				<c:if test="${requestScope.documentType == '연장근무신청서'}">
					<input type="hidden" name="documentType" value="연장근무신청서" />
					<table class="mt-5" style="width: 100%">
						<tbody>
							<tr>
								<th>긴급</th>
								<td>
									<c:if test="${empty requestScope.document || requestScope.document.urgent eq 0}">
										<input class="ml-1" type="checkbox" name="check_urgent"/>
									</c:if>
									<c:if test="${requestScope.document.urgent eq 1}">
										<input class="ml-1" type="checkbox" name="check_urgent" checked="checked"/>
									</c:if>
									<input type="hidden" name="urgent" value="0"/>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="text" name="subject" value=" " style="width: 100%;"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="text" name="subject" value="${requestScope.document.subject}" style="width: 100%;"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>사유</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="text" name="reason" value=" " style="width: 100%;"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="text" name="reason" value="${requestScope.document.reason}" style="width: 100%;"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>연장 근무 일자</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="date" name="overtimeDate" onchange="check_weekend(this)" onkeydown="return false" />
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<c:if test="${requestScope.document.overtimeDate eq '-'}">
											<input type="date" name="overtimeDate" onchange="check_weekend(this)" onkeydown="return false" />
										</c:if>
										<c:if test="${requestScope.document.overtimeDate ne '-'}">
											<input type="date" name="overtimeDate" onchange="check_weekend(this)" value="${requestScope.document.overtimeDate}" onkeydown="return false" />
										</c:if>
									</c:if>
									<span id="check_weekend" class="alert"></span>
								</td>
							</tr>
							<tr>
								<th>연장 근무 시간</th>
								<td>
									<input type="text" value="3시간" style="width: 100%;" readonly />
								</td>
							</tr>
							<tr>
								<th class="pl-4" colspan="2" style="text-align: left;">
									1. 연장 근무는 3시간을 규정으로 한다.
									<br>2. 연장 근무 신청은 반드시 퇴근 시간 이전에 이루어져야 한다. 
								</th>
							</tr>
						</tbody>
					</table>
				</c:if>
				<%-- 연장근무신청서 폼 --%>
				
				
				<%-- 지출품의서 폼 --%>
				<c:if test="${requestScope.documentType == '지출품의서'}">
					<input type="hidden" name="documentType" value="지출품의서" />
					<input name='expense_detail_count' type='hidden' value='1'/>
					<table class="mt-5" style="width: 100%">
						<tbody>
							<tr>
								<th>긴급</th>
								<td>
									<c:if test="${empty requestScope.document || requestScope.document.urgent eq 0}">
										<input class="ml-1" type="checkbox" name="check_urgent"/>
									</c:if>
									<c:if test="${requestScope.document.urgent eq 1}">
										<input class="ml-1" type="checkbox" name="check_urgent" checked="checked"/>
									</c:if>
									<input type="hidden" name="urgent" value="0"/>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="text" name="subject" value=" " style="width: 100%;"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="text" name="subject" value="${requestScope.document.subject}" style="width: 100%;"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>총 금액</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="number" name="totalExpenseAmount" value="0" style="width: 100%;" readonly="readonly"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="number" name="totalExpenseAmount" value="${requestScope.document.totalExpenseAmount}" style="width: 100%;" readonly="readonly"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>지출사유</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<textarea name="reason" style="width: 100%; height: 150px; overflow: auto;"></textarea>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<textarea name="reason" style="width: 100%; height: 150px; overflow: auto;">${requestScope.document.reason}</textarea>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>
					
					<div class="mt-5 mb-1">
						<a onclick="add_expense_detail()" style="cursor: pointer;"><i style="font-size: 20pt;" class="fa-solid fa-plus mr-2"></i></a>
						<a onclick="delete_expense_detail()" style="cursor: pointer;"><i style="font-size: 20pt;" class="fa-solid fa-trash-can"></i></a>
					</div>
					
					<table style="width: 100%">
						<thead>
							<tr>
								<th>사용일자</th>
								<th>분류</th>
								<th>금액</th>
								<th>사용내역</th>
								<th>비고</th>
							</tr>
						</thead>
						<tbody class="expense_detail">
							<c:if test="${empty requestScope.expenseDetailList}">
								<tr>
									<td><input type="date" class="useDate" name="useDate0" onkeydown="return false" style="width: 100%;"/></td>
									<td><input type="text" class="type" name="type0" style="width: 100%;"/></td>
									<td><input type="number" class="amount" name="amount0" onchange="check_amount(this)" onkeyup="check_amount(this)" style="width: 100%;"/></td>
									<td><input type="text" class="content" name="content0" style="width: 100%;"/></td>
									<td><input type="text" class="note" name="note0" style="width: 100%;"/></td>
								</tr>
							</c:if>
							<c:if test="${not empty requestScope.expenseDetailList}">
								<c:forEach var="expenseDetail" items="${requestScope.expenseDetailList}">
									<tr>
										<td><input type="date" class="useDate" name="useDate0" 	value="${expenseDetail.useDate}" onkeydown="return false" style="width: 100%;"/></td>
										<td><input type="text" class="type" name="type0" 		value="${expenseDetail.type}" style="width: 100%;"/></td>
										<td><input type="number" class="amount" name="amount0" 	value="${expenseDetail.amount}" onchange="check_amount(this)" onkeyup="check_amount(this)" style="width: 100%;"/></td>
										<td><input type="text" class="content" name="content0" 	value="${expenseDetail.content}" style="width: 100%;"/></td>
										<td><input type="text" class="note" name="note0" 		value="${expenseDetail.note}" style="width: 100%;"/></td>
									</tr>
								</c:forEach>
							</c:if>
						</tbody>
					</table>
				</c:if>
				<%-- 지출품의서 폼 --%>
				
				
				<%-- 업무기안 폼 --%>
				<c:if test="${requestScope.documentType eq '업무기안'}">
					<input type="hidden" name="documentType" value="업무기안" />
					<table class="mt-5" style="width: 100%">
						<tbody>
							<tr>
								<th>긴급</th>
								<td>
									<c:if test="${empty requestScope.document || requestScope.document.urgent eq 0}">
										<input class="ml-1" type="checkbox" name="check_urgent"/>
									</c:if>
									<c:if test="${requestScope.document.urgent eq 1}">
										<input class="ml-1" type="checkbox" name="check_urgent" checked="checked"/>
									</c:if>
									<input type="hidden" name="urgent" value="0"/>
								</td>
							</tr>
							<tr>
								<th>제목</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="text" name="subject" value=" " style="width: 100%;"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="text" name="subject" value="${requestScope.document.subject}" style="width: 100%;"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>협조부서</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="text" name="coDepartment" style="width: 100%;"/>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<input type="text" name="coDepartment" value="${requestScope.document.coDepartment}" style="width: 100%;"/>
									</c:if>
								</td>
							</tr>
							<tr>
								<th>시행 일자</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<input type="date" name="doDate" onchange="check_weekend(this)" onkeydown="return false" />
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<c:if test="${requestScope.document.doDate eq '-'}">
											<input type="date" name="doDate" onchange="check_weekend(this)" onkeydown="return false" />
										</c:if>
										<c:if test="${requestScope.document.doDate ne '-'}">
											<input type="date" name="doDate" onchange="check_weekend(this)" value="${requestScope.document.doDate}" onkeydown="return false" />
										</c:if>
									</c:if>
									<span id="check_weekend" class="alert"></span>
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td>
									<c:if test="${empty requestScope.document}">
										<textarea name="businessContent" style="width: 100%; height: 150px; overflow: auto;"></textarea>
									</c:if>
									<c:if test="${not empty requestScope.document}">
										<textarea name="businessContent" style="width: 100%; height: 150px; overflow: auto;">${requestScope.document.businessContent}</textarea>
									</c:if>
								</td>
							</tr>
						</tbody>
					</table>
				</c:if>
				<%-- 업무기안 폼 --%>
				
			</div>
			
			<%-- 파일 첨부 --%>
		<%--	<div class="mt-4" style="display: flex">
				<span class="mr-5" style="width: 10%; margin-top:auto; margin-bottom:auto;">파일첨부</span>
				<div id="fileDrop" class="fileDrop border border-secondary"></div>
			</div>
			<div id="fileList" class="mt-1"></div> --%>
			
			<div class="mt-5">
				<a onclick="history.back()" style="color: black; cursor: pointer">
					<i class="fa-solid fa-circle-arrow-left">&nbsp;뒤로가기</i>
				</a>
			</div>
			
		</form>
		
		
	</div>
</div>
<jsp:include page="../../footer/footer.jsp" /> 