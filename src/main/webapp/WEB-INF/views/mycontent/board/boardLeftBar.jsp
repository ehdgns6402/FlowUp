<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
   String ctxpath = request.getContextPath();
%>
<link href="<%=ctxpath%>/css/board/boardLeftBar.css" rel="stylesheet"> 


<script type="text/javascript">

var ctxPath = "<%= request.getContextPath() %>";

$(document).ready(function() {
	
	
   // === 글작성 할 (접근 권한있는)게시판 목록 <select> 태그에 보여주기=== //
   getAccessBoardList();
   
	$("#isNoticeElmt").hide(); // 공지사항 등록 미체크시 hide 상태
	$("#addBoard").hide();     // 로그인하지 않은 상태 또는 보안등급 10이 아닐 경우 hide
	
	
	/////////////////////////////////////////////////////////////////
	
	<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 시작 === --%>
	let file_arr = []; // 첨부된어진 파일 정보를 담아 둘 배열

       // == 파일 Drag & Drop 만들기 == //
    $("div#fileDrop").on("dragenter", function(e){ /* "dragenter" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 최초로 들어왔을 때 */ 
        e.preventDefault();
        e.stopPropagation();
        
    }).on("dragover", function(e){ /* "dragover" 이벤트는 드롭대상인 박스 안에 Drag 한 파일이 머물러 있는 중일 때. 필수이벤트이다. dragover 이벤트를 적용하지 않으면 drop 이벤트가 작동하지 않음 */ 
        e.preventDefault();
        e.stopPropagation();
        $(this).css("background-color", "#f9f9f9");
    }).on("dragleave", function(e){ /* "dragleave" 이벤트는 Drag 한 파일이 드롭대상인 박스 밖으로 벗어났을 때  */
        e.preventDefault();
        e.stopPropagation();
        $(this).css("background-color", "");
    }).on("drop", function(e){      /* "drop" 이벤트는 드롭대상인 박스 안에서 Drag 한것을 Drop(Drag 한 파일(객체)을 놓는것) 했을 때. 필수이벤트이다. */
        e.preventDefault();

        var files = e.originalEvent.dataTransfer.files;  
        
        if(files != null && files != undefined){
            let html = "";
            const f = files[0]; // 어차피 files.length 의 값이 1 이므로 위의 for문을 사용하지 않고 files[0] 을 사용하여 1개만 가져오면 된다. 
        	let fileSize = f.size/1024/1024;   /* 파일의 크기는 MB로 나타내기 위하여 /1024/1024 하였음 */
        	
        	if(fileSize >= 10) {
        		alert("10MB 이상인 파일은 업로드할 수 없습니다.!!");
        		$(this).css("background-color", "#fff");
        		return;
        	}
        	
        	else {
        		file_arr.push(f); //  드롭대상인 박스 안에 첨부파일을 드롭하면 파일들을 담아둘 배열인 file_arr 에 파일들을 저장시키도록 한다. 
	        	const fileName = f.name; // 파일명	
        	
        	    fileSize = fileSize < 1 ? fileSize.toFixed(2) : fileSize.toFixed(1);
        	    html += 
                    "<div class='fileList'>" +
                        "<span class='delete'>&times;</span> " +  // &times; 는 x 로 보여주는 것이다.  
                        "<span class='fileName'>"+fileName+"</span>" +
                        "<span class='fileSize'> ("+fileSize+"MB)</span>" +
                        "<span class='clear'></span>" +  // <span class='clear'></span> 의 용도는 CSS 에서 float:right; 를 clear: both; 하기 위한 용도이다. 
                    "</div>";
	            $(this).append(html);
        	}
        }// end of if(files != null && files != undefined)--------------------------
        
        $(this).css("background-color", "#fff");
    }); // end of }).on("drop", function(e){})--------------
	
	
    // == Drop 되어진 파일목록 제거하기 == // 
    $(document).on("click", "span.delete", function(e){
    	let idx = $("span.delete").index($(e.target));
    
    	file_arr.splice(idx,1); // 드롭대상인 박스 안에 첨부파일을 드롭하면 파일들을 담아둘 배열인 file_arr 에서 파일을 제거시키도록 한다. 
    
           $(e.target).parent().remove(); // <div class='fileList'> 태그를 삭제하도록 한다. 	    
    });

	<%-- === jQuery 를 사용하여 드래그앤드롭(DragAndDrop)을 통한 파일 업로드 끝 === --%>
	
	
	
	// === 공지로 등록 체크박스 클릭 시 === //
	 $(document).on("change", "input[name='isNotice']", function(e) {
	 	
		 if($("input[name='isNotice']").is(':checked') == true){ // 체크박스에 체크가 되었을 경우
			$("#isNoticeElmt").show();
		 }
		 else{ // 체크가 안되었을 경우
			$("#isNoticeElmt").hide();
		 }
		 
	 }); // end of $(document).on("change", "input[name='isNotice']", function(e) {}--------------

	
	
	 
	// === 게시판 목록 boardLeftBar에 나열하기 === //
    $.ajax({
        url: ctxPath + "/board/selectBoardList",
        type: "GET",
        dataType: "json",
        success: function(json) {
            let v_html = "";
            $.each(json.boardList, function(index, board) {
               v_html += `
               		
	                <li>
            	   		<a href='<%=ctxpath%>/board/selectPostBoardGroupView?boardNo=\${board.boardNo}'>`+board.boardName+`</a>  <%-- 게시판명 --%>
			            <a href='<%=ctxpath%>/board/updateBoardView?boardNo=\${board.boardNo}' class='upateBoard settingBtn'>
			                <i class="fa-solid fa-gear updateGear" style="margin-right:9px;"></i> <%-- 게시판 수정 아이콘 --%> 
		                </a>
		                
		                <i class="fa-regular fa-trash-can disableBoardIcon deleteTrash settingBtn" data-boardno="\${board.boardNo}"></i> <%-- 게시판 삭제 아이콘 --%>
	                </li>`; 
            });
            $(".board_menu_container ul li").not(":first").remove(); // 첫 번째 항목 제외하고 삭제
            $(".board_menu_container ul").append(v_html); // 새 목록 추가
            
            
            $(".settingBtn").hide();// 로그인하지 않은 상태 또는 보안등급 10이 아닐 경우 hide
            
            // login_securityLevel 값을 가져와서 사용
            var loginSecurityLevel = json.login_securityLevel;
            
            // 값이 10일 경우 #addBoard 보이기
            if (loginSecurityLevel == "10") {
                $("#addBoard").show();  
                $(".settingBtn").show();
            }
            
            var login_Name = json.login_Name;
            $("input[name='createdBy']").val(login_Name);

            var login_employeeNo = json.login_employeeNo; // '글쓰기 버튼 클릭 시'에서 로그인 여부 유효성 검사 시 필요
            
            $("#isExit").html(login_employeeNo);
        },
        error: function() {
        }
    });
    
    
    
    // === 게시판 삭제(비활성화) confirm === // 
    $(document).on("click", ".disableBoardIcon", function(e) {
    	const boardNo = $(this).data("boardno");
    	
        if (confirm("해당 게시판을 삭제하시겠습니까?")) {
        	
			let listItem = $(this).closest("li"); 
			//현재 클릭한 요소에서 가장 가까운 li 요소를 찾음.
			//자신이 li이면 그대로 반환, 아니라면 부모 요소를 찾음
			
			if (!boardNo) { // boardNo가 제대로 안 넘어올 경우 오류 방지
		        alert("삭제할 게시판 번호를 찾을 수 없습니다.");
		        return;
		    }
			
            $.ajax({
                url: ctxPath + "/board/disableBoard",
                type: "POST",
                data: { "boardNo": boardNo },
                dataType: "json",
                success: function(json) {
                    if (json.n) {
                    	window.location.href = ctxPath + "/board/";
                    } else {
                        alert("게시판 삭제 실패: " + json.message);
                    }
                },
                error: function() {alert("오류가 발생했습니다.");}
            });
        }
        
     
    }); // end of $(document).on("click", ".disableBoardIcon", function() {} --------------

    
   	
    
    
 	// ========= 글쓰기버튼 토글 ========= //

    $('#writePostBtn').click(e=>{
    	
    	if($("#isExit").text() == ""){
    		alert("로그인 후 이용하실 수 있습니다.");
    		return;
    	}

        $('#modal').fadeIn();
        $('.modal_container').css({
            'width': '70%'
        })
  
    }) // end of $('#writePostBtn').click(e=>{})-----------

    $('.modal_bg:not(.modal_container)').click(e=>{

        $('#modal').fadeOut();
        $('.modal_container').css({
            'width': '0%'
        })

    })
    // ========= 글쓰기버튼 토글 ========= //
    
    
    
    
    
    <%--  ==== 스마트 에디터 구현 시작 ==== --%>
	//전역변수
    var obj = [];
    
    //스마트에디터 프레임생성
    nhn.husky.EZCreator.createInIFrame({
        oAppRef: obj,
        elPlaceHolder: "content",
        sSkinURI: "<%= ctxpath%>/smarteditor/SmartEditor2Skin.html",
        htParams : {
            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseToolbar : true,            
            // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
            bUseVerticalResizer : true,    
            // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
            bUseModeChanger : true,
        }
    });
	<%--  ==== 스마트 에디터 구현 끝 ==== --%>
	
	
	// === datepicker 시작 === //
    $("input#datepicker").datepicker({
        dateFormat: 'yy-mm-dd'  
       ,showOtherMonths: true   
       ,showMonthAfterYear:true
       ,changeYear: true        
       ,changeMonth: true                   
       ,yearSuffix: "년"         
       ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12']
       ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
       ,dayNamesMin: ['일','월','화','수','목','금','토'] 
       ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일']       
	   });

    // 초기값을 오늘 날짜로 설정
	$('input#datepicker').datepicker('setDate', 'today');

    $(function() {
        //모든 datepicker에 대한 공통 옵션 설정
        $.datepicker.setDefaults({
             dateFormat: 'yy-mm-dd' 
            ,showOtherMonths: true 
            ,showMonthAfterYear:true 
            ,changeYear: true
            ,changeMonth: true 
            ,monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12']
            ,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] 
            ,dayNamesMin: ['일','월','화','수','목','금','토'] 
            ,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일']                  
        });
 
        // input을 datepicker로 선언
        $("input#fromDate").datepicker();                    
        $("input#toDate").datepicker();
        
        // From의 초기값을 오늘 날짜로 설정
        $('input#fromDate').datepicker('setDate', 'today'); 
        
        // To의 초기값을 3일후로 설정
        $('input#toDate').datepicker('setDate', '+3D');
     });

    ////////////////////////////////////////////////////////////////////
    
    $("input#datepicker").bind("keyup", e => {
        $(e.target).val("").next().show();
    }); // 공지사항 등록일에 키보드로 입력하는 경우 
    
 	// === datepicker 끝 === //
 	
 	
 	// 공지 종료일을 시작일보다 빠르게 한 경우 //
   	$(document).on("change", "#toDate", function() {
 		if($("#datepicker").val() > $("#toDate").val()){
 			alert("공지 종료일을 정확하게 입력해주세요.");
 			$("#toDate").val("");
 		}
     });
 	
 	// === 게시글 등록 버튼 클릭 시 === // 
	$(document).on("click", "#addPostBtn", function(){

		if($("select[name='fk_boardNo']").val() == null){
			alert("게시판을 선택해주세요.");
			return;
		}
		

		
	   <%-- === 스마트 에디터 구현 시작 === --%>
	   // id가 content인 textarea에 에디터에서 대입
       obj.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
	   <%-- === 스마트 에디터 구현 끝 === --%>
	  
	  
	  // === 글제목 유효성 검사 === //
      const subject = $("input:text[name='subject']").val().trim();	  
      if(subject == "") {
    	  alert("글제목을 입력해주세요.");
    	  $("input:text[name='subject']").val("");
    	  return; // 종료
      }	
      if ($("input[name='subject']").val().length > 60) {
	      alert("제목은 60자 이하로 작성해주세요.");
	      return;
	  }
	  
        <%-- === 내용 유효성 검사(스마트 에디터 사용 할 경우) 시작 === --%>
	    var contentval = $("textarea#content").val();
	      contentval = contentval.replace(/&nbsp;/gi, ""); // 공백을 "" 으로 변환
	      contentval = contentval.substring(contentval.indexOf("<p>")+3);
	      contentval = contentval.substring(0, contentval.indexOf("</p>"));
	          
	      if(contentval.trim().length == 0) {
		    alert("내용을 입력하세요!!");
	      return;
	    }
	    <%-- === 내용 유효성 검사(스마트 에디터 사용 할 경우) 끝 === --%>
	    
      var formData = new FormData($("form[name='addPostFrm']").get(0)); // $("form[name='addFrm']").get(0) 폼 에 작성된 모든 데이터 보내기 
      if(file_arr.length > 0) { // 파일첨부가 있을 경우 
    	  // 첨부한 파일의 총합의 크기가 10MB 이상 이라면 메일 전송을 하지 못하게 막는다.
    	  let sum_file_size = 0;
          for(let i=0; i<file_arr.length; i++) {
              sum_file_size += file_arr[i].size;
          }// end of for---------------
            
          if( sum_file_size >= 10*1024*1024 ) { // 첨부한 파일의 총합의 크기가 10MB 이상 이라면 
              alert("첨부한 파일의 총합의 크기가 10MB 이상이라서 파일을 업로드할 수 없습니다.");
        	  return; // 종료
          }
          else { // formData 속에 첨부파일 넣어주기
        	  
        	  file_arr.forEach(function(item){
                  formData.append("file_arr", item);  // 첨부파일 추가하기.  "file_arr" 이 키값이고  item 이 밸류값인데 file_arr 배열속에 저장되어진 배열요소인 파일첨부되어진 파일이 되어진다.    
                                                      // 같은 key를 가진 값을 여러 개 넣을 수 있다.(덮어씌워지지 않고 추가가 된다.)
              });
          }
      }
      
      $.ajax({
          url : ctxPath+"/board/addPost",
          type : "post",
          data : formData,
          processData:false,  // 파일 전송시 설정 
          contentType:false,  // 파일 전송시 설정 
          dataType:"json",
          success:function(json){
              // ~~~ 확인용 : {"result":1}
              if(json.result == 1) {
        	     location.href= ctxPath+"/board/selectPostBoardGroupView?boardNo=" + json.boardNo; 
              }
              else {
            	  alert("게시글 등록에 실패했습니다.");
            	  location.href= ctxPath+"/board/board"; 
              }
          },
          error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		      }
      });
	}); // end of $(document).on("click", "#addPostBtn", function(){}-----------------------
			
			
	
			
	///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////게시판 추가////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	
	let selectDepartment = []; // 선택된 부서를 저장할 배열
	
	// --- 게시판 생성하기 클릭 시  시작 --- // 
	$(document).on("click", "#addBoard", function() {
	     $('#addBoardModal').fadeIn(300); // 모달 띄우기
	});
	// ---게시판 생성하기 클릭 시 끝 --- // 
	
	// 모달 닫기 이벤트
	$('#close').click(e => {
		$('#addBoardModal').fadeOut(300);
	});

	// 모달 바깥 영역 클릭 시 닫기
	$(window).click(e => {
	    if ($(e.target).is('#addBoardModal')) {
	        $('#addBoardModal').fadeOut(300);
	    }
	});
	// --- 게시판 생성하기 모달 끝 --- // 
	
	// 처음에는 부서 선택 박스를 숨김.
	$("#isPublicDept").hide(); 
	
	// 공개 범위 라디오 버튼 변경 시
    $("input[name='isPublic']").change(function() {
        if ($(".isPublic:checked").val() == "0") {
            $("#isPublicDept").show();
            goSearchAllDept(); // 부서 전체 조회
        } else {
            $("#isPublicDept").hide();
            selectDepartment = []; // 전체 공개 시 선택된 부서 초기화
            updateSelectDepartment();
        }
    });
	
	// ========= 부서 검색 input ( 부서별 공개 라디오 버튼 선택 후 input 태그에 글자 입력 시 ) ========= //
	// 부서 검색 이벤트
    $("input[name='searchWord']").on("input", function() {
        const searchWord = $(this).val().trim();
        if (searchWord.length == 0) {
            goSearchAllDept(); // 검색어가 없으면 모든 부서 표시
        } else {
            $.ajax({
                url: ctxPath + "/board/addBoardSearchDept",
                type: "get",
                data: { "searchWord": searchWord },
                dataType: "json",
                success: function(json) {
                    if (json.length > 0) {
                        let v_html = "";
                        $.each(json, function(index, item) {
                            const deptName = item.departmentname;
                            const deptNo = item.departmentno;
                            v_html += `<span class="result" data-dept-no="\${deptNo}" data-dept-name="\${deptName}" style="cursor:pointer;">\${deptName} [\${deptNo}]</span><br>`;

                        });
                        $("#displayList").html(v_html).show();
                    } else {
                        $("#displayList").hide();
                    }
                }
            });
        }
    });
	
 	// 부서 선택 이벤트 (클릭 시 선택 목록에 추가)
    $(document).on("click", "span.result", function() {
        const deptNo = $(this).data("dept-no");
        const deptName = $(this).data("dept-name");

        // 중복 선택 방지
        if (!selectDepartment.some(dept => dept.deptNo === deptNo)) { // 선택한 부서가 selectDepartment에 있다면 true 
        	selectDepartment.push({ deptNo, deptName }); // 배열에 부서 추가 
            updateSelectDepartment();					 // 선택한 부서를 부서목록에 추가
        }

        $("#displayList").hide();
        $("input[name='searchWord']").val(""); // 검색어 초기화
        goSearchAllDept();
    });
 	
 	// 선택한 부서 목록 업데이트 (  선택한 부서목을 담고 있는 selectDepartment 배열을 통해 업데이트)
    function updateSelectDepartment() { 
        let html = "";
        let hiddenInput = "";
        
        selectDepartment.forEach((dept, index) => {
        	html += `<span class="select-dept" data-index="\${index}">
				\${dept.deptName}
    			<button type="button" class="remove-dept btnDefaultDesignNone" data-index="\${index}">
   					<i class="fa-solid fa-circle-xmark"></i>
   				</button>
				</span> `;

            hiddenInput += `<input type="hidden" name="fk_departmentNo" value="\${dept.deptNo}">`; // form에 hidden input 추가 (배열을 폼으로 전송하기위해)
        });
        $("#selectDeptList").html(html);
        $("#selectDeptHideInput").html(hiddenInput);
    }

    // 선택한 부서 삭제 이벤트
    $(document).on("click", ".remove-dept", function() {
        const index = $(this).data("index"); // 선택한 부서 목록의 index를 활용함
        selectDepartment.splice(index, 1);   // 배열에서 해당 인덱스 요소를 삭제
        updateSelectDepartment();
    });
	
	$(document).on("click", "#addBoardGroup", function(){ // 생성 버튼 클릭 이벤트
		
		if($("input[name='boardName']").val() == ""){
			alert("게시판 제목을 입력해주세요.");
			return;
		}
		
		if($("input[name='boardName']").val().length > 15){
			alert("게시판 제목을 15자 이하로 입력해주세요.")
			return;
		}
		
		if($("input[name='boardDesc']").val() == ""){
			alert("게시판 설명을 입력해주세요.")
			return;
		}
		
		if($("input[name='boardDesc']").val().length > 500){
			alert("게시판 설명을 500자 이내로 입력해주세요.")
			return;
		}
		
		if($(".isPublic:checked").val() == 0 ){
			if($("#selectDeptList").text() == ""){ // 부서 목록이 없데이트 되는 요소에 아무 값이 없다면
				alert("게시판을 공개할 대상 부서를 선택하세요.");
				return;
			}
		}
		
 		goAddBoardGroup(); // 게시판 생성하기
	});
	
    
}); // end of $(document).ready(function() {})----------------------
    
    
    
	//////////Function Declare //////////
	
	// === 글쓰기 버튼 클릭 시 글작성 할 (접근 권한있는)게시판 목록 <select> 태그에 보여주기 === //
	function getAccessBoardList(){
		
		$.ajax({
	        url: ctxPath + "/board/getAccessibleBoardList",
	        type: "GET",
	        data: { "employeeNo": "100013" }, // 로그인된 직원의 사원번호를 내가 임의로 입력해줌 추후 변경 해야함.
	        dataType: "json",
	        success: function(json) {
	            let options = `<option value="" disabled selected>게시판 선택</option>`; // 기본 옵션
	            $.each(json, function(index, board) {
	                options += `<option value='\${board.boardno}'>`+board.boardname+`</option>`;
	                
	                
	            });
	            $("select[name='fk_boardNo']").html(options);
	        },
	        error: function(xhr, status, error) {
	        }
	    });
		
	}// end of function getAccessBoardList(){}------------------
	
	
    ///////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////게시판 추가////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////
	
	// ===== 부서 전체 조회하기(부서공개라디오 클릭 시) ===== //
	function goSearchAllDept(){
	$.ajax({ //게시판 생성의 공개여부 부서 설정 시 부서 전체 검색(부서 검색)
		   url: ctxPath + "/board/addBoardSearchAllDept",
		   type:"get",
		   dataType:"json",
		   success:function(json){
			   if(json.length > 0){
				   // 검색된 데이터가 있는 경우임.
				   
				   let v_html = ``;
				   
				   $.each(json, function(index, item){
					   const departmentname = item.departmentname;
					   const departmentno = item.departmentno;
					   
					   const idx = departmentname.toLowerCase().indexOf(\$("input[name='searchWord']").val().toLowerCase());
					   
				       const len = \$("input[name='searchWord']").val().length; 
					   
				       const result = departmentname.substring(0, idx) + "<span style='color:blue;'>"+departmentname.substring(idx, idx+len)+"</span>" + departmentname.substring(idx+len); 
				       
					   v_html += `<span data-dept-no='\${departmentno}' data-dept-name='\${departmentname}' style='cursor:pointer;' class='result'>\${result}[\${departmentno}]</span><br>`;
					   
				   }); // end of $.each(json, function(index, item){})-----------
				   
				   const input_width = $("input[name='searchWord']").css("width"); // 검색어 input 태그 width 값 알아오기  
				   
				   $("div#displayList").css({"width":input_width}); // 검색결과 div 의 width 크기를 검색어 입력 input 태그의 width 와 일치시키기 
				   
				   $("div#displayList").html(v_html).show();
			   }
		   },
		   error: function(request, status, error){
			   alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
		   }    
	   });
} 

// ===== 게시판 생성하기 ===== //
function goAddBoardGroup(){
	const frm = document.addBoardGroup;
    frm.method = "POST";
    frm.action = ctxPath + "/board/addBoard";
    frm.submit();  
}
      
      
</script>

<!-- 글작성 폼 -->
    <div id="modal" class="modal_bg" >
    </div>
    <div class="modal_container" style="overflow-y: auto;">
	    <div>
	        <!-- 여기에 글작성 폼을 만들어주세요!! -->
			<span id="modal_title">글쓰기</span>
			
			<div id="modal_content_page">
				<form name="addPostFrm" enctype="multipart/form-data">
					<span id="selectBoardGroup">To.
						<select name="fk_boardNo">
						</select>
					</span>
					<div style="padding:var(--size22);">
						<table style="width: 100%;">
							<tr>
								<td style="width: 95px;">제목</td>
								<td ><input type="text" name="subject" autocomplete="off" style="width: 100%; "></td>
							</tr>
							<tr>
								<td>파일첨부</td>
								<td>
									<div id="fileDrop" class="fileDrop"><%-- class= border border-secondary --%>
										<p style="text-align: center;">이 곳에 파일을 드래그 하세요.</p>
									</div>
								</td>
							</tr>
							<tr>
							     <td>내 용</td>
							     <td>
							 	    <textarea name="content" id="content" rows="10" cols="100" style="width: 100%;height:450px;"></textarea>
							     </td>
						  	</tr>
						  	<tr>
						  		<td>댓글작성</td>
						  		<td>
						  			<input type="radio" id="allowYes" name="allowComments" value="1" checked>
									<label for="allowYes" style="margin:0;" >허용</label>
									
									<input type="radio" id="allowNo" name="allowComments" value="0">
									<label for="allowNo" style="margin:0;">허용하지 않음</label>
						  		</td>
						  	</tr>
						  	<tr>
						  		<td>공지 유무</td>
						  		<td>
						  			<input type="checkbox" id="isnotice" name="isNotice" value=1>
									<label for="isnotice" style="margin:0;">클릭 시 선택</label>
									<span id="addPostBtnElmt">
										<button type="button" id="addPostBtn" class="btnDefaultDesignNone"><i class="fa-solid fa-pencil"></i> 등록</button>
									</span>
									<div id="isNoticeElmt"> <!-- 미체크시 hide 상태임 -->
										<input type="text" name="startNotice" id="datepicker" maxlength="10" autocomplete='off' size="4"/> 
										-
										<input type="text" name="noticeEndDate" id="toDate" maxlength="10" autocomplete='off' size="4"/>
									</div> 
									
									
						  		</td>
						  	</tr>
						</table>
					</div>
					
				</form>
			</div>
		</div>
    </div> <!-- end of <div class="modal_container"> -->
    <!-- 글작성 폼 -->
    
    <!-- 게시판 생성하기 모달 -->
	<div id="addBoardModal" class="addBoardModal">
	    <div class="modal-content" id="modal-content">
	        <span id="createBoard_Modal_title">게시판 생성</span>
            
            
            <div id="addBoardGroupFrmTag" >
		    <form name="addBoardGroup">
				<table id = "addBoardGroupTbl">
					<tr>
						<td class="columnTitle">
							제목
						</td>
						<td style="width: 100%;">
							<input type="text" name="boardName"  class="w_max" autocomplete="off"/>
						</td>
					</tr>
					<tr>
						<td class="columnTitle">
							설명
						</td>
						<td>
							<input type="text" name="boardDesc" class="w_max" autocomplete="off"/>
						</td>
					</tr>
					<tr>
					    <td class="columnTitle">공개 설정</td>
					    <td>
					        <div class="radio-container">
					            <label>
					                <input type="radio" name="isPublic" value="0" class="isPublic" /> 부서별
					            </label>
					            <label>
					                <input type="radio" name="isPublic" value="1" class="isPublic"  checked/> 전체
					            </label>
					        </div>
					    </td>
					</tr>
					<tr>
						<td class="columnTitle">
							운영자
						</td>
						<td>
							<input type="text" name="createdBy" value=""  class="w_max" autocomplete="off" readonly/>
						</td>
					</tr>
				</table>
				
				<div id="isPublicDept">
						<p style="font-weight: bold;margin: 0px;">공개 부서 선택하기</p>
						<div id="selectDeptList"></div>
						<input type="text" name="searchWord" size="50" autocomplete="off" placeholder="부서를 검색하세요."  style="width: 100%;"/>
						<input type="text" style="display: none;"/> <%-- form 태그내에 input 태그가 오로지 1개 뿐일경우에는 엔터를 했을 경우 검색이 되어지므로 이것을 방지하고자 만든것이다. --%>	  
					<div id="displayList"  style="border:solid 1px gray; border-top:0px; height:100px; margin-top:-1px; margin-bottom:30px; overflow:auto;"></div>
				</div>     
			
    			<div id="selectDeptHideInput"> <%--  여기에 선택된 부서들의 hidden input이 추가됨 --%> </div> 
			</form>
			
			 			
		</div>
			<div style="display: flex; margin-left: auto; ">
				<button type="button" id="addBoardGroup" class="btnDefaultDesignNone">생성</button>
	        	<span id="close">닫기</span>
        	</div>
	    </div>
	</div> <!-- end of <div id="addBoardModal" class="addBoardModal"> -->
	<!-- 게시판 생성하기 모달-->
    
    
<!-- 왼쪽 사이드바 -->
  <div id="left_bar">

      <!-- === 글작성 버튼 === -->
      <button id="writePostBtn">
          <i class="fa-solid fa-plus"></i>
          <span id="goWrite">글쓰기</span>
      </button>
      <!-- === 글작성 버튼 === -->

      <div class="board_menu_container">
          <ul>
              <li>
                  <a href="<%=ctxpath%>/board/">전체게시판</a>
              </li>
          </ul>
          
      </div>
      <div id="addBoardContainer"><span id="addBoard">게시판 생성하기+</span></div>
      <div id="isExit" style="display: none;"></div> <%-- 로그인 여부 판별을 위함 --%>
  </div>
 <!-- 왼쪽 사이드바 -->