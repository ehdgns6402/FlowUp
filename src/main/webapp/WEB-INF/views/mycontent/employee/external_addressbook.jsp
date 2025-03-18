<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   String ctxPath = request.getContextPath();
   //     /flowUp
%> 
<jsp:include page="../../header/header.jsp" />
<%@include file="./addressbookbar.jsp" %>

<link href="<%=ctxPath%>/css/employeeCss/addressbook.css" rel="stylesheet"> 

<script type="text/javascript">

$(document).ready(function() {
	
	$("span.error").hide();
	$("div.addFrmModal").hide();
	$("div.displayCenterCss").hide();
	
	$("button#openModal").click(function(){
		
		$("div.addFrmModal").show();
		
		//$("div.addFrmModal").();
		$("input:text[name='firstName']").focus();
		
		// 이름 유효성
		$("input:text[name='firstName']").blur(function(e){
			
			const regExp= /^[가-힣a-zA-Z]{1,15}$/ // 한글&영어 1~6자리
	 		const bool = regExp.test($(e.target).val());
	 		
	 		if(!bool){
				 
				 $(e.target).next().show();
			}
	 		
	 		else{
				$(e.target).next().hide();
		    }			
			
		});// end of $("input:text[name='firstName']").blur(function(e)--------
				
		// 가운데 이름 유효성
		$("input:text[name='middleName']").blur(function(e){
			
			const regExp= /^[가-힣a-zA-Z]{1,15}$/ // 한글&영어 1~6자리
	 		const bool = regExp.test($(e.target).val());
	 		
	 		if(!bool){
				 
				 $(e.target).next().show();
				 
			}
	 		
	 		else{
				$(e.target).next().hide();
		    }			
			
		});// end of $("input:text[name='middleName']").blur(function(e)--------
				
		//  이름 유효성
		$("input:text[name='lastName']").blur(function(e){
			
			const regExp= /^[가-힣a-zA-Z]{1,15}$/ // 한글&영어 1~6자리
	 		const bool = regExp.test($(e.target).val());
	 		
	 		if(!bool){
				 $(e.target).next().show();
			}
	 		
	 		else{
				$(e.target).next().hide();
		    }			
			
		});// end of $("input:text[name='middleName']").blur(function(e)--------
				
				
				
	    $("input:text[name='company']").blur(function(e){
	    	
	    	if($(e.target).val() == ""){
		    	 $(e.target).next().show();
				
			}
		
	    	else{
				$(e.target).next().hide();
	    	}			
		
	    	
	    });//end of $("input:text[name='company']").blur(function(e){});
	    
	    $("input:text[name='department']").blur(function(e){
	    	
	    	
	    	const regExp= /^[가-힣a-zA-Z]{2,6}$/ // 한글&영어 2~6자리
		 	const bool = regExp.test($(e.target).val());
		 		
	 		if(!bool){
				 
				 $(e.target).next().show();
				
				 
			}
	 		
	 		else{
				$(e.target).next().hide();
		    }	
	    	
	    	
	    });// end of $("input:text[name='department']").blur(function(e){});input')

	    
	    $("input:text[name='rank']").blur(function(e){
	    	
	    	const regExp= /^[가-힣a-zA-Z]{2,6}$/ // 한글&영어 2~6자리
			const bool = regExp.test($(e.target).val());
			 		
	 		if(!bool){
				 
				 $(e.target).next().show();
	 
			}
	 		
	 		else{
				$(e.target).next().hide();
		    }	
		    	
	    });//end of  $("input:text[name='rank']").blur(function(e){});
	    
	    
	    $("input:text[name='email']").blur(function(e){
	    	
	    	const regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
	    	const bool = regExp.test($(e.target).val());
	    	
	    	if(!bool){
				 
				 $(e.target).next().show();
			}
	 		
	 		else{
				$(e.target).next().hide();
		    }	
	    	
	    });// end of $("input:text[name='email']").blur(function(e){});
	    
	    $("input:text[name='directCall']").blur(function(e){
	    	
	    	const regExp = /^0([0|1|6|7|8|9|4|3|1|2]{0,2}?)?([0-9]{3,4})?([0-9]{4})$/;
	    	const bool = regExp.test($(e.target).val());
	    	
	    	if(!bool){
				 
				 $(e.target).next().show();
			}
	 		
	 		else{
				$(e.target).next().hide();
		    }    
	    	
	    });// end of $("input:text[name='directCall']").blur(function(e){})
	    
	    
	    const companyAddress = $("input:text[name='companyAddress']").val();
	    if(companyAddress == ""){
	    	$("input:text[name='companyAddress']").next().show();
	    }
	    
	    else{
	    	$("input:text[name='companyAddress']").next().hide();
	    }   
	    
	    $("input:text[name='phoneNo']").blur(function(e){
	    	
	    	 const regExp = /^01([0|1|6|7|8|9]?)?([0-9]{3,4})?([0-9]{4})$/;
	 		 const bool = regExp.test( $(e.target).val() );
			 
			if(!bool){
				$(e.target).next().show();
				$(e.target).focus()
			}
			 
			 else{
				 $(e.target).next().hide();	
			 }
	    	
	    });//$("input:text[name='phoneNo']").blur(function(e){});
	    
		
		
		
	});// end of $("button.openModal").click(function(){});--------
	
	$("button.add").click(function(){
		
		const frm = document.addAdrsFrm;
		frm.action = "<%= ctxPath%>/employee/addAddressEnd";
	    frm.method = "post";
	    frm.submit();
		
	});// end of $("button.add").click(function(){});
	
	
	<%--alert($("input:text[name='fk_employeeNo']").val());--%>

	const fk_employeeNo = $("input:hidden[name='fk_employeeNo']").val();
	
	// 주소록 전체 목록
	view_address(fk_employeeNo);
		
	
const g_fk_employee = $("input:hidden[name='g_fk_employeeno']").val();
	
	$.ajax({	
		url:"<%= ctxpath%>/employee/groupNo_and_groupName_select",
		type:"get",
		data:{"g_fk_employee":g_fk_employee},
		dataType:"json",
		success:function(json){
		//	alert(JSON.stringify(json));
		   //[{groupName=우리회사, groupNo=100002}, {groupName=다른회사, groupNo=100003}]
			let v_html="";
		
			for(let i =0; i<json.length;i++){
				v_html +="<option class='groupNo' value='"+json[i].groupNo+"'>"+json[i].groupName+"</option>";
			}// end of for----------------
			
			$("select.group_select").html(v_html);
		
			
		},
	 	 error: function(request, status, error){
	 		 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	 	     }
	});// end of$.ajax({});-----------------
	
	$("button.insertGroupBtn").click(function(){
		
		$("div.displayCenterCss").show();
		
	})
	
	
	
}); //$(document).ready(function(){});-------------------


function view_address(fk_employeeNo) {

	$.ajax({
		url:"<%= ctxPath%>/employee/external_address_data",
		data:{"fk_employeeNo":fk_employeeNo},
		dataType:"json",
		type: "get",
		async: false, // 동기방식 
		  	success:function(json){
		  		
		  		console.log(JSON.stringify(json))
		  		<%--
	  	  		[{"DIRECTCALL":"03109092323","PHONENO":"01023238989","ADRSBNO":"100019","name":"전동석","DEPARTMENT":"영업부","RANK":"사원","EMAIL":"jds@naver.com","COMPANY":"지나인제약"},
	  	  		{"DIRECTCALL":"0293489432","PHONENO":"01039249854","ADRSBNO":"100018","name":"김고은","DEPARTMENT":"부설연구소","RANK":"사원","EMAIL":"kimge@naver.com","COMPANY":"휴온스메디"},
	  	  		{"DIRECTCALL":"0291418743","PHONENO":"01095438912","ADRSBNO":"100017","name":"옥주현","DEPARTMENT":"총무부","RANK":"대리","EMAIL":"okju@naver.com","COMPANY":"인텔리테크"},
	  	  		{"DIRECTCALL":"0298128912","PHONENO":"0103482912","ADRSBNO":"100016","name":"박은태","DEPARTMENT":"계획관리본부","RANK":"전무","EMAIL":"parkeuntae@naver.com","COMPANY":"엔터원"},
	  	  		{"DIRECTCALL":"0298128452","PHONENO":"01098341297","ADRSBNO":"100015","name":"신성록","DEPARTMENT":"개발부","RANK":"과장","EMAIL":"sinsr@naver.com","COMPANY":"와이원"},
	  	  		{"DIRECTCALL":"0212567623","PHONENO":"01023238989","ADRSBNO":"100014","name":"엄정화","DEPARTMENT":"영업부","RANK":"차장","EMAIL":"eomjh@naver.com","COMPANY":"삼성"},
	  	  		{"DIRECTCALL":"0243181993","PHONENO":"01091994753","ADRSBNO":"100013","name":"김성훈","DEPARTMENT":"총무부","RANK":"전무","EMAIL":"power8993@naver.com","COMPANY":"flow up"},
	  	  		{"DIRECTCALL":"0287847311","PHONENO":"01087847311","ADRSBNO":"100012","name":"이동훈","DEPARTMENT":"물류부","RANK":"전무","EMAIL":"ehdgns6402@naver.com","COMPANY":"flow up"},
	  	  		{"DIRECTCALL":"0298423234","PHONENO":"01043189993","ADRSBNO":"100011","name":"이상우","DEPARTMENT":"영업부","RANK":"상무","EMAIL":"giyf1208@naver.com","COMPANY":"flow up"},
	  	  		{"DIRECTCALL":"0290291654","PHONENO":"01090291654","ADRSBNO":"100010","name":"강이훈","DEPARTMENT":"관리부","RANK":"전무","EMAIL":"dlgns1110@naver.com","COMPANY":"flow up"},
	  	  		{"DIRECTCALL":"0282487243","PHONENO":"01082487243","ADRSBNO":"100009","name":"윤영주","DEPARTMENT":"경영관리부","RANK":"사장","EMAIL":"mechanicon@naver.com","COMPANY":"flow up"},
	  	  		{"DIRECTCALL":"0289891212","PHONENO":"01020706651","ADRSBNO":"100008","name":"이지혜","DEPARTMENT":"물류부","RANK":"차장","EMAIL":"banana5092@naver.com","COMPANY":"flow up"}]
		  		--%>
		  		let v_html="";
		  		
		  		v_html += "<table class='addressbooktable table table-hover table-striped'>"
				    +	 "<thead style='color:#2985DB; font-size:14pt;'>" 
					+		 "<tr>"
					+			"<th style='width:30px;' class='thcss thcheck'><input type='checkbox'></th>"
					+			"<th class='thcss'><span class='tabletitle'>이름(표시명)</span></th>"
					+			"<th class='thcss'><span class='tabletitle'>직위</span></th>"
					+			"<th class='thcss'><span class='tabletitle'>이메일</span></th>"
					+			"<th class='thcss'><span class='tabletitle'>휴대폰</span></th>"
					+			"<th class='thcss'><span class='tabletitle'>부서</span></th>"
					+			"<th class='thcss'><span class='tabletitle'>회사</span></th>"
					+			"<th class='thcss'><span class='tabletitle'>내선번호</span></th>"
					+			"<th class='thcss'><span class='tabletitle'>그룹</span></th>"
					+			"<th class='thcss'><span class='tabletitle'></span></th>"
					+		  "</tr>"
					+		"</thead>"		
					+	"<tbody>";
		  		
		  		for(let i=0;i<json.length;i++){	
		  			
		  			v_html+="<tr>"
		  			  +		"<td class='tdcss thcheck'><input type='checkbox' name='checkSelect' class='checkSelect' value="+json[i].ADRSBNO+"></td>"
		  			  +		"<td class='tdcss'><span class='tabletitle hoverEvent' name='data_name'>"+json[i].name+"</span></td>"
		  			  +		"<td class='tdcss'><span class='tabletitle' name='data_rank'>"+json[i].RANK+"</span></td>"
		  			  +		"<td class='tdcss'><span class='tabletitle' name='data_email' id='email'>"+json[i].EMAIL+"</span></td>"
		  			  +		"<td class='tdcss'><span class='tabletitle' name='data_phone'>"+json[i].PHONENO+"</span></td>"
		  			  +		"<td class='tdcss'><span class='tabletitle' name='data_department'>"+json[i].DEPARTMENT+"</td>"
		  			  +		"<td class='tdcss'><span class='tabletitle' name='data_company'>"+json[i].COMPANY+"</span></td>"
		  			  +		"<td class='tdcss'><span class='tabletitle' name='data_directcall'>"+json[i].DIRECTCALL+"</span></td>"
		  			  +		"<td class='tdcss'><button class='insertGroupBtn' onclick='addgroup()'>+그룹추가하기</button></td>"
		  			  +		"<td class='tdcss'><span class='tabletitle' id='bookmark'><i class='fa-regular fa-bookmark'></i></span></td>"
		  			  + "</tr>";  	  			
		  		}// end of for(let i = 0; i<json.length; i++){}
		  	
		  		v_html+="</tbody>"+
		  				"</table>";
		  				
		  				$("div.addressbookcontent").html(v_html);
		  			 
		  	},
		 	 error: function(request, status, error){
		 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	     }
		
	});// end of $.ajax({});----------------------------------------------------------------
	
}// end of function view_address(fk_employeeNo)-------------------------------


function delete_address(){
	
	if($("input.checkSelect:checked").length == 0) {
		alert("주소록을 선택해주세요");
	}
	
	else{
		
		const addressno = $("input:checkbox[name='checkSelect']:checked").val();
		
		 if (confirm("정말로 삭제하시겠습니까?")) {
			// console.log(addressno);	// 체크박스로 선택한 값을 알아옴.	
			
			$.ajax({
				url:"<%= ctxpath%>/employee/delete_address_book",
				type: "post",
				dataType: "json",
				data : {"addressno":addressno},
				success:function(json){
				 //	console.log(JSON.stringify(json));
				 // {"n":1}
					if(json.n == 1) {
						alert("삭제가 성공적으로 완료되었습니다.");
						view_address($("input:hidden[name='fk_employeeNo']").val());		
					}
				},
		  	 	 error: function(request, status, error){
		 		 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 	     }
			}); // end of $.ajax({});
			
		 }
		else{
			alert("삭제가 취소되었습니다");
		}
	}
	
};// end of function delete_address(){};--------------------

<%--
function addGroupOption(){
	
	//alert("그룹옵션 추가할게요~~");
	
	//alert("그룹옵션 추가할게요~~");
	
	//alert($("input#fk_employeeno").val());
	
	const g_fk_employee = $("input#fk_employeeno").val();
	const groupname = $("input:text[name='groupname']").val();
	
	//alert(groupname)
		
	$.ajax({
		
		url:"<%= ctxpath%>/employee/addGroupOptionEnd",
		type:"post",
		data:{"g_fk_employee":g_fk_employee,"groupname":groupname},
		dataType:"json",
		success:function(json){
			
			if(json.n==1){
				alert("옵션이 추가 되었습니다.");
			}
			else{
				alert("옵션 추가가 실패되었습니다");
			}
			
		},
	 	 error: function(request, status, error){
	 		 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
	 	     }
		
	});// end of $.ajax({});--------------------------------------

}

--%>


<%--
 function addGroupFinal(){
	 	const fk_employeeno = $("input#fk_employeeno").val();
		const groupNo = $("select.group_select").val();
		//alert(fk_employeeno);
		//alert(groupNo);
		const addressno = $("tr").find("input:checkbox[name='checkSelect']").val();
		//alert(addressno);
		
		alert("addressno:"+addressno+", fk_employeeno:"+fk_employeeno+", groupNo:"+groupNo);
	
		
		$.ajax({
			url:"<%= ctxpath%>/employee/addGroup",
			type:"post",
			data:{"fk_employeeno":fk_employeeno,"groupNo":groupNo,"addressno":addressno},
			dataType:"json",
			success:function(json){
				
				//alert(JSON.stringify(json));
				//[{"groupName":"우리회사","groupNo":"100002"}]
				
				let v_html = "";
				
				
				for(let i = 0; i<json.length; i++){
					
					v_html +="<button class='insertGroupBtn' onclick='addgroup()'>+"+json[i].groupName+"</button>"
					
				}//end of for(let i = 0; i<json.length; i++){}-------------------------------
				
				$("td.tdcss").html(v_html);
				
			},
	 	 	 error: function(request, status, error){
		 		 	alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		 	     }
	    });
	   
 }// end of function addGroupFinal(){}-------------------------
--%>
 
 <%--
$("span#bookmark").click(function(e){
	//alert("클릭");
	
	// 주소록 번호 찾기
	 const tr = $(e.target).parent().parent().parent();
	// alert(tr);
	//alert(tr.find("td.thcheck").html());
	 const td = tr.find("td.thcheck"); // 
	 //alert(td.find("input").val());
	 
	 const fk_employeeno_addr = td.find("input").val(); 
	 
	 if(confirm("북마크 하시겠습니까?")){
		// alert("북마크 완료");
		
		
	 }
	 
	 else{
		 alert("북마크를 취소합니다")
	 }
}); // end of $("span#bookmark").click(function(e){});

--%>



</script>






<!-- --------------------------------------- -->



<div id="right-bar">
	<div id="right_title_box">
		<span id="right_title">주소록</span><span class="sidetitle">in 공용주소록(<span class="addresscount">10</span>건)</span>
	</div>


<div id="toolbar">
	 <div>
	 	<button class=" toolbtn" id="openModal">빠른 등록</button>
		<button class="toolbtn" onclick="delete_address()">삭제</button>
		<button class="toolbtn">메일발송</button>
	 </div>
</div>

<div class="navtab_spelling">
	<button class="spelling listall list">전체</button>
	<button class="spelling list" id="a">ㄱ</button>
	<button class="spelling list" id="b">ㄴ</button>
	<button class="spelling list" id="c">ㄷ</button>
	<button class="spelling list" id="d">ㄹ</button>
	<button class="spelling list" id="e">ㅁ</button>
	<button class="spelling list" id="f">ㅂ</button>
	<button class="spelling list" id="g">ㅅ</button>
	<button class="spelling list" id="h">ㅇ</button>
	<button class="spelling list" id="i">ㅈ</button>
	<button class="spelling list" id="j">ㅊ</button>
	<button class="spelling list" id="k">ㅋ</button>
	<button class="spelling list" id="l">ㅌ</button>
	<button class="spelling list" id="m">ㅍ</button>
	<button class="spelling list" id="o">ㅎ</button>
	<button class="spelling list" id="alphabet">A~Z</button>
	<button class="spelling list" id="number">1~9</button>
</div>

<!-- ajax로 주소록 넣음 -->
<div class="addressbookcontent">
	<span class="ADRSBNO"></span>
</div>


<!-- 주소록 추가 모달창 -->
<div class="addFrmModal">
		<div class="maodal_background"></div><%-- 모달창 백그라운드 --%>
		<div class="modal_content"><%-- 모달창 메인 내용 --%>
			<form name="addAdrsFrm" class="addAdrsFrm">
			<div class="frmTitle">
			<div class="close_btn_div">
				<button class="closeModal">X</button><%-- 모달창 닫기 --%>
			</div>
			<h4>주소록 추가</h4>
			</div>
				<ul>
					<li class="input_li">
						<label class="modal_input_title">성</label>
						<input type="text" name="firstName" class="modal_input"/>
						<span class = "error">한글 또는 영어로 입력해주세요</span>					
					</li>
					<li class="input_li">
						<label class="modal_input_title">중간이름</label>
						<input type="text" name="middleName" class="modal_input"/>
						<span class = "error">한글 또는 영어로 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">이름</label>
						<input type="text" name="lastName" class="modal_input"/>
						<span class = "error">한글 또는 영어로 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">회사</label>
						<input type="text" name="company" class="modal_input"/>
						<span class = "error">한글 또는 영어로 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">부서</label>
						<input type="text" name="department" class="modal_input"/>
						<span class = "error">한글 또는 영어로 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">직위</label>
						<input type="text" name="rank" class="modal_input"/>
						<span class = "error">한글 또는 영어로 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">이메일</label>
						<input type="text" name="email" class="modal_input" placeholder="ex)hongildong123@naver.com"/>
						<span class = "error">이메일 형식에 맞게 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">전화번호</label>
						<input type="text" name="phoneNo" class="modal_input" placeholder="ex)01012341234"/>
						<span class = "error">'-'를 빼고 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">내선번호</label>
						<input type="text" name="directCall" class="modal_input" placeholder="ex)03112129090"/>
						<span class = "error">'-'를 빼고 입력해주세요</span>	
					</li>
					<li class="input_li">
						<label class="modal_input_title">회사주소</label>
						<input type="text" name="companyAddress" class="modal_input"/>
					</li>
					
					<li class="input_li">
						<input type="hidden" name="fk_employeeNo" class="modal_input" value="${sessionScope.loginuser.employeeNo}"/>
					</li>
					
					<li class="input_li">
						<button type="button" class="add">주소록 등록</button>
						<button type="reset" class="no_add">등록 취소</button>
					</li>
				</ul>
					
			</form>
		</div>
	</div>
	
	
	<div class="displayCenterCss">
	<div class="groupModalBackground"></div>
		<div class="addgroup_modal">
		
			<div class="GroupModaltitle">
			<h3>그룹추가</h3>
			</div>
		
			<form>
			<button class="groupaddclose">x</button>	
				<ul>
					<li class="groupList">
						<select class="group_select">
							<!-- ajax 로 option 넣기 -->
						</select>
					</li>
					<li class="groupList">	
						<label id="inputlabel">새로우 그룹 추가</label>
						
						<input type="text" class="groupname" name="groupname"/>
						<input name="g_fk_employeeno" type="hidden" id="fk_employeeno" value="${sessionScope.loginuser.employeeNo}"/>
						<button class="addGroup" onclick="addGroupOption()">추가</button>
						
					</li>	
					<li>
						<button type="button" class="addGroupBtn" onclick="addGroupFinal()">추가하기</button>
					</li>
				</ul>
			</form>	
		</div>
	</div>
	
	<!--  페이징 처리 하는 곳 -->
	<div class="pagediv"></div>
</div>