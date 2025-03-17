<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<%
   String ctxPath = request.getContextPath();
    //     /myspring
%>
<style>
tr.tbodyTr:nth-child(even){
	background-color: rgba(242, 247, 253, 0.5);
}
.onePostElmt.tbodyTr:nth-child(even){
	background-color: rgba(242, 247, 253, 0.5);
}
</style>
<jsp:include page="../../header/header.jsp" /> 

<!-- clipboard.js cdn 추가 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/2.0.10/clipboard.min.js"></script>

<!-- Highcharts.js -->
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/highcharts.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/highcharts-more.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/solid-gauge.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/exporting.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/export-data.js"></script>
<script src="<%=ctxPath%>/Highcharts-10.3.1/code/modules/accessibility.js"></script>

<link href="<%=ctxPath%>/css/main/main.css" rel="stylesheet"> 




	<%-- <div class="dashboard"> --%>
	<div id="assetModalBg" class="modal_bg"></div>
	<div class="modal_container">

		<div style="padding: var(--size24);">
			
               <div class="search-wrapper">
				    <div class="input-holder">
				        <input type="text" class="search-input" placeholder="검색어를 입력해주세요..." />
				        <button class="search-icon" onclick="searchToggle(this, event);"><span></span></button>
				    </div>
				    <span class="close" onclick="searchToggle(this, event);"></span>
				</div>
           
            
            <div style="margin-top:20%">
            	<div>
            		<ul class="topBar">
            			<li class="selectLi"><div>통합검색</div></li>
            			<li><div>메일</div></li>
            			<li><div>전자결재</div></li>
            			<li><div>캘린더</div></li>
            			<li><div>게시판</div></li>
            		</ul>
            	</div>
            	
            	
            	<div class="search_contents">
            		<div class="search_contents_inner">
            		
            		</div>
            	</div>
            	
            </div>
            
            
		</div>
		
    </div>
	
	
	
	<div class="dashboard">
		<div class="leftDiv">
		
			<!-- 타이틀, 검색창 -->
			<div class="titleSearchBox">
				<div class="dashboardTitle">Flow Up Dashboard</div>
				
				<div class="searchbox">
					<i class="fa-solid fa-magnifying-glass"></i>
				</div>
			</div>
			<!-- 타이틀, 검색창 -->
			
			
			<!-- 첫 container -->
			<div class="topContainer">
				<div class="topInnerContainer">
					<div class="topInnerTitle">
						<i class="fa-solid fa-user"></i>
						사원번호
					</div>
					
					<!-- 사원번호 복사기능 -->
					<div class="employeeNoCopyBox">
						<span id="employeeNoCopy">${sessionScope.loginuser.employeeNo}</span> 
						
						<span class="copyBtn btnBack" data-clipboard-target="#employeeNoCopy">
							<i class="fa-solid fa-paperclip"></i>
						</span>
					</div>
					<!-- 사원번호 복사기능 -->
				</div>
				
				<div class="topInnerContainer">
					<div class="topInnerTitle">
						<i class="fa-solid fa-address-card"></i>
						간편 주소록
					</div>
					
					<!-- 주소록 기능 -->
					<div class="employeeNoCopyBox">
						<span class="topInnerContentTitle addrTitle">
							강이훈 외 9건+
						</span>
						
						
						<span class="btnBack addrBtn" style="display: flex; position: relative;">
							<i style="margin:auto;" class="fa-solid fa-angle-right arrow"></i>
						</span>
							
							
					</div>
					<!-- 주소록 기능 -->
				</div>
				
				<div class="topInnerContainer">
					<div class="topInnerTitle">
						<i class="fa-solid fa-location-dot"></i>
						최근접속
					</div>
					
					<!-- ip 기능 -->
					<div class="employeeNoCopyBox">
						<span class="topInnerContentTitle">
							${requestScope.ipMap[0].clientip}
						</span>
						
						<span class="btnBack ipBtn">
							<i class="fa-solid fa-angle-right arrow"></i>
						</span>
					</div>
					<!-- ip 기능 -->
				</div>
			</div>
			<!-- 첫 container -->
			
			
			<!-- 두번째 container -->
			<div class="secContainer">
				<div class="topInnerTitle">
					<i class="fa-solid fa-chart-simple"></i>
					예약정보
				</div>
				
				<div>
				
					<jsp:include page="../../common/time_calendar.jsp" /> 
				</div>
			</div>
			<!-- 두번째 container -->
			
			
			<!-- 세번째 container -->
			<div class="treContainer">
				<div class="treInnerContainer">
					<div class="topInnerTitle" style="margin-bottom:0px;">
						<i class="fa-solid fa-money-check-dollar"></i>
						전자결재
					</div>
					
					<div style="display: flex; flex-direction: column; align-items: center; justify-content:center; height: 100%;">
						<div class="paybox">
							<div class="payBtn">
								<a href="<%= ctxPath%>/document/todoList">
									<span>결재 대기 문서</span>	
									<span class="payCnt">${documentMap.todoDocCnt}</span>
								</a>
							</div>
							<div class="payBtn">
								<a href="<%= ctxPath%>/document/upcomingList">
									<span>결재 예정 문서</span>	
									<span class="payCnt">${documentMap.upcomingDocCnt}</span>
								</a>
							</div>
							<div class="payBtn">
								<a href="<%= ctxPath%>/document/myDocumentList">
									<span>기안 문서함</span>
									<span class="payCnt">${documentMap.myDocCnt}</span>
								</a>
							</div>
							<div class="payBtn">
								<a href="<%= ctxPath%>/document/tempList">
									<span>임시 저장함</span>
									<span class="payCnt">${documentMap.tempDocCnt}</span>
								</a>
							</div>
						</div>
						<a href="<%= ctxPath%>/document/">
							<div class="moreBtn pay-button">
								<span>
								더보기
									<div class="plane"><i class="fas fa-plane"></i></div>
							        <div class="cloud" style="top: 10px; left: 50px;"></div>
							        <div class="cloud" style="top: 30px; left: 120px;"></div>
								</span>
							</div>
						</a>
					</div>
				</div>
				
				<div class="treInnerContainer">
					<div class="topInnerTitle">
						<i class="fa-solid fa-envelope"></i>
						이메일
					</div>
					
					<div style="grid-template-columns: 200px 1fr; display: grid;">
						<div style="width: 200px; height:100%;">
							
							<div class="chart_box">
							    <div id="chart_container"></div>
							    
							</div>
						</div>
						<div class="email_chart_here" style="display: flex; align-items:center;">
							<div>
								<table border="1" class="time_table_back_form">
									<thead>
										<tr>
											<th>읽은 메일</th>
											<th>중요 메일</th>
											<th>임시 저장함</th>
										</tr>
									</thead>
									<tbody>
										<tr style="height: var(--size30); text-align: center; vertical-align: middle;">
											<c:forEach var="mailMap" items="${requestScope.mailMap}">
												<td>${mailMap.MAILECNT}</td>
											</c:forEach>
										</tr>
									</tbody>
								</table>
								
								<a href="<%= ctxPath%>/mail">
									<div class="moreBtn">
										<span>더보기</span>
									</div>
								</a>
							</div>
						</div>
						
					</div>
					
				</div>
			</div>
			<!-- 세번째 container -->
			
			
			<!-- 네번째 container -->
			<div class="forContainer">
				<div class="topInnerTitle">
					<i class="fa-solid fa-comments"></i>
					게시판
					<p style="color:#999; font-size:12px;">최대 30개의 게시물을 읽을 수 있습니다.</p>
				</div>
				<jsp:include page="../board/board2.jsp" /> 
				
			</div>
			<!-- 네번째 container -->
		</div>
			
		<div class="rightDiv">
		
			<div class="stickyBox">
		
				<div class="rightTopContainer">
						
					<div style="overflow: hidden; display: flex; justify-content: center; align-items:center; width: 120px; height: 120px; border-radius: 50%; background-color: #fff;">
						<c:if test="${sessionScope.loginuser.fileName == null}">
							<i class="fa-solid fa-user" style="color:#999; font-size: 60px;"></i>
						</c:if>
						<c:if test="${sessionScope.loginuser.fileName != null}">
							<span><img class="ikon-img" style="width:120px; height:100%;" src="<%= ctxPath%>/resources/files/${sessionScope.loginuser.fileName}" /></span>
						</c:if>
					</div> <!-- 프로필 사진 -->
					<div style="font-size:14px;">
						<div>${sessionScope.loginuser.name}</div>
						<div>${sessionScope.loginuser.departmentName}</div>
						<div>${sessionScope.loginuser.email}</div>
						<div>${sessionScope.loginuser.motive}</div>
					</div>
				</div>
				
				<div class="rightSeContainer" style="margin-top:16px; height: auto;">
					<jsp:include page="../../common/commute_btn2.jsp" /> 
				</div>
			
			</div>
			
		</div>
	</div>
	<%-- <div class="dashboard"> --%>
	
	
	
	
	
	
	
	<%--
	<div style="display:none; width: 430px; height: auto; background-color: #252525; text-align: center; color: #fff">
		<jsp:include page="../../common/commute_btn2.jsp" /> 
	</div>
	--%>
<%-- =========== 주소록 모달창 =========== --%>
<div class="addrModal">
	<div style="padding: 16px;">
	
		<div style="margin-bottom: 12px;">
			<div>${sessionScope.loginuser.name} 님의 주소록입니다.</div>
			<div style="color:#999; font-size:12px;">클릭시 해당 정보가 복사됩니다.</div>
		</div>
		
		<table border="1" class="time_table_back_form">
			<thead>
				<tr>
					<th>이름</th>
					<th>이메일</th>
					<th>전화번호</th>
					
				</tr>
			</thead>
			
			<tbody class="addrHere">
				
			</tbody>
			
		</table>
		<div class="bottom_btn_box">
			<div class="okBtn">
				<span>
					<a href="<%= ctxPath%>/employee/addressBook">전체보기</a>
				</span>
			</div>
			<div class="resetBtn" id="closeAddr">
				<span>
					닫기
				</span>
			</div>
		</div>
	</div>
</div>
<%-- =========== 주소록 모달창 =========== --%>



<%-- =========== ip주소 모달창 =========== --%>
<div class="ipModal">
	<div style="padding: 16px;">
	
		<div style="margin-bottom: 12px;">
			<div>${sessionScope.loginuser.name} 님의 접속기록입니다.</div>
			<div style="color:#999; font-size:12px;">최근 10개의 접속기록만 표시됩니다.</div>
		</div>
		
		<table border="1" class="time_table_back_form">
			<thead>
				<tr>
					<th>접속ip</th>
					<th>날짜</th>
				</tr>
			</thead>
			
			<tbody class="ipHere">
				<c:if test="${empty requestScope.ipMap}">
					<tr><td colspan="2" style="text-align: center; vertical-align:middle; height: 200px; color:#999;">최근 접속기록이 없습니다.</td></tr>
				</c:if>
				<c:if test="${not empty requestScope.ipMap}">
				    <c:forEach var="map" items="${requestScope.ipMap}" varStatus="status">
				        <c:if test="${status.index < 10}">
				            <tr class="tbodyTr">
				                <td>${map.clientip}</td>
				                <td>${map.logindate}</td>
				            </tr>
				        </c:if>
				    </c:forEach>
				</c:if>
			</tbody>
			
		</table>
		<div class="bottom_btn_box">
			<div class="resetBtn" id="closeIp">
				<span>
					닫기
				</span>
			</div>
		</div>
	</div>
</div>
<%-- =========== ip주소 모달창 =========== --%>



<!-- 라이브러리 실행 -->
<link rel="stylesheet" href="<%=ctxPath%>/js-snackbar-master/dist/js-snackbar.css">
<script src="<%=ctxPath%>/js-snackbar-master/dist/js-snackbar.js"></script>
<script>
	
	// =========== 사번복사 =========== //
    var clipboard = new ClipboardJS('.copyBtn');
  
    clipboard.on('success', function(e) {
    	demoContainer();
    });
  
    clipboard.on('error', function(e) {
        console.log(e);
    });
    
    
    var clipaddr = new ClipboardJS('.tbodyTd', {
        target: function(trigger) {
            return trigger;
        }
    });

    clipaddr.on('success', function(e) {
        demoContainer();
    });

    clipaddr.on('error', function(e) {
        console.log(e);
    });
 	// =========== 사번복사 =========== //
 	
 	
 	
 	// =========== 토스트 라이브러리 =========== //
    var demoContainer = function () {
	    SnackBar({
	    	message: "복사가 완료되었습니다.",
		    status: "success"
	    })
	}
 	// =========== 토스트 라이브러리 =========== //
 	
 	
 	
 	// =========== 주소록 모달 =========== //
    $('.addrBtn').click(e=>{
    	$('.addrModal').fadeIn();
    	$('#assetModalBg').fadeIn();
    });
    
    
    $('#closeAddr').click(e=>{
    	$('.addrModal').fadeOut();
    	$('#assetModalBg').fadeOut();
    })
    // =========== 주소록 모달 =========== //
    
    
    // =========== ip 모달 =========== //
    $('.ipBtn').click(e=>{
    	$('.ipModal').fadeIn();
    	$('#assetModalBg').fadeIn();
    });
    
    
    $('#closeIp').click(e=>{
    	$('.ipModal').fadeOut();
    	$('#assetModalBg').fadeOut();
    });
 	// =========== ip 모달 =========== //
    
    
 	// =========== 검색창 모달 =========== //
    $('.searchbox').click(e=>{

        $('.modal_bg').fadeIn();
        $('.modal_container').css({
            'width': '50%'
        })
  
    })

    $('.modal_bg:not(.modal_container)').click(e=>{

        $('.modal_bg').fadeOut();
        $('.addrModal').fadeOut();
        $('.ipModal').fadeOut();
        
        
        $('.modal_container').css({
            'width': '0%'
        })

    })
    // =========== 검색창 모달 =========== //
    
    
    
    
    // =========== 검색 아이콘 =========== //
    function searchToggle(obj, evt){
    var container = $(obj).closest('.search-wrapper');
        if(!container.hasClass('active')){
            container.addClass('active');
            evt.preventDefault();
            
        }
        else if(container.hasClass('active') && $(obj).closest('.input-holder').length == 0){
            container.removeClass('active');
            // clear input
            container.find('.search-input').val('');
        }
        else if(container.hasClass('active')){
        	// alert('active 있음')
        	
        	if($('input.search-input').val() == ''){
        		alert('검색어를 입력해주세요.')
        	}
        	else {
        		$('.search-wrapper').css({
        			'top':'12%'
        		})
        		$('.topBar').css({
        			'width':'100%'
        		})
        		
        		
        		setInterval((e) => 
        		$('.search_contents').css({
        			'display':'block'
        		}), 1000);
        		
        		setInterval((e) => 
        		$('.search_contents').css({
        			'height':'600px'
        		}), 1500);
        		
        		
        		searchMail(); // ajax 시작!
        		searchBoard();		// 게시판
        		searchDocument();	// 전자결재
        		searchCalendar();	// 캘린더
        	}
        	
        }
	}	
 	
 	
 	
 	// =========== 검색 아이콘 =========== //
    
    
    // ========================= 본격적인 메인페이지 ajax 함수들 시작 ========================= //
    let importantStatusPercentage;
    let readStatusPercentage;
    let saveStatusPercentage;
    
    addrModal();
    selectMail();
    
    function addrModal(){
	    $.ajax({
	    	url:"<%=ctxPath%>/employee/all_address_data",
	    	data: {"fk_employeeNo": ${sessionScope.loginuser.employeeNo} },
	    	type:"get",
	    	dataType:"json",
	    	success:function(json){
	    		console.log(JSON.stringify(json));
	    		// [{"DIRECTCALL":"0211115555","PHONENO":"01010102020","ADRSBNO":"100061","name":"이순신","DEPARTMENT":"IT","RANK":"대리","EMAIL":"lee2@naver.com","COMPANY":"삼성"}]
	    		
	    		let v_html = ``;
	    		
	    		//////////////////////////
	    		if(json.length > 0) {
	    			
	    			$.each(json, function(index, item){
	    				v_html += `<tr class="tbodyTr">
			    						<td class="tbodyTd" id="copyTarget_${index}" data-clipboard-target="#copyTarget_${index}">\${item.name}</td>
			    	                    <td class="tbodyTd" id="copyTarget_email_${index}" data-clipboard-target="#copyTarget_email_${index}">\${item.EMAIL}</td>
			    	                    <td class="tbodyTd" id="copyTarget_phone_${index}" data-clipboard-target="#copyTarget_phone_${index}">\${item.PHONENO}</td>
			 					   <tr>`;
			 			
			 					   
			 			if(json.length == 1) {
			 				$('.addrTitle').text(`\${item.name}`);
			 			}
			 			else{
	    					$('.addrTitle').text(`\${item.name} 님 외 \${json.length - 1}건`);
			 			}
	    			}) // end of for ------------
	    		}
	    		else{
	    			v_html += `<tr><td colspan="3" style="text-align: center; vertical-align:middle; height: 200px; color:#999;">등록된 주소록이 없습니다.</td></tr>`;
	    			$('.addrTitle').text(`등록된 주소록이 없습니다.`);
	    		}
				//////////////////////////
				
	    		$('.addrHere').append(v_html);
	    		
	    	},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
	    	
	    })
    } // end of function addrModal(){})---------------
    
    
    let = v_html = ``;
    
 	// === 메일 검색 === //
    function searchMail() {
    	$.ajax({
	    	url:"<%=ctxPath%>/searchMail",
	    	data: {"searchWord": $('input.search-input').val() },
	    	type:"get",
	    	dataType:"json",
	    	success:function(json){
	    		console.log("메일 검색 확인 : "+JSON.stringify(json))
	    		
	    		
	    		
	    		
	    		
	    	},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	})
    }
 	// === 메일 검색 === //
 	
 	
 	
 	
 	// === 게시판 검색 === //
    function searchBoard() {
    	$.ajax({
	    	url:"<%=ctxPath%>/searchBoard",
	    	data: {"searchWord": $('input.search-input').val() },
	    	type:"get",
	    	dataType:"json",
	    	success:function(json){
	    		console.log("게시판 검색 확인 : "+JSON.stringify(json))
	    		
	    	},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	})
    }
 	// === 게시판 검색 === //
 	
 	
 	
 	
 	// === 전자결재 검색 === //
    function searchDocument() {
    	$.ajax({
	    	url:"<%=ctxPath%>/searchDocument",
	    	data: {"searchWord": $('input.search-input').val() },
	    	type:"get",
	    	dataType:"json",
	    	success:function(json){
	    		console.log("전자결재 검색 확인 : "+JSON.stringify(json))
	    		
	    	},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	})
    }
 	// === 전자결재 검색 === //
 	
 	
 	
 	
 	// === 캘린더 검색 === //
    function searchCalendar() {
    	$.ajax({
	    	url:"<%=ctxPath%>/searchCalendar",
	    	data: {"searchWord": $('input.search-input').val() },
	    	type:"get",
	    	dataType:"json",
	    	success:function(json){
	    		console.log("캘린더 검색 확인 : "+JSON.stringify(json))
	    		
	    	},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
    	})
    }
 	// === 캘린더 검색 === //
 	
 	
    
    
    
 	
 	
 	
 	
 	
    function selectMail(){
	    $.ajax({
	    	url:"<%=ctxPath%>/mail/selectMail",
	    	data: {"fk_employeeNo": ${sessionScope.loginuser.employeeNo} },
	    	type:"get",
	    	dataType:"json",
	    	success:function(json){
	    		console.log(JSON.stringify(json));
	    		// {"importantStatusPercentage":"0","readStatusPercentage":"0","saveStatusPercentage":"0"}

	    		importantStatusPercentage = parseInt(json.importantStatusPercentage);
	    		readStatusPercentage = parseInt(json.readStatusPercentage);
	    		saveStatusPercentage = parseInt(json.saveStatusPercentage);
	    		
	    		console.log("importantStatusPercentage : " + importantStatusPercentage)
	    		console.log("readStatusPercentage : " + parseInt(readStatusPercentage))
	    		console.log("saveStatusPercentage : " + saveStatusPercentage)
	    		chart();
	    	},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
	    })
    }
 	
 	
 	
 	
 	
 	
 	
 	
 	
    
    // ======== 비행기 버튼 모션 ======== //
    $(document).ready(function() {
        $('.pay-button').on('click', function(e) {
            let ripple = $('<span class="ripple"></span>');
            let x = e.pageX - $(this).offset().left;
            let y = e.pageY - $(this).offset().top;
            ripple.css({
                width: '100px',
                height: '100px',
                top: y - 50 + 'px',
                left: x - 50 + 'px'
            });
            $(this).append(ripple);
            setTimeout(() => ripple.remove(), 600);
        });
    });
 	// ======== 비행기 버튼 모션 ======== //
    
    
    
    
    // ============================= chart 그리기 ============================= //
    // Uncomment to style it like Apple Watch
	/*
	if (!Highcharts.theme) {
	    Highcharts.setOptions({
	        chart: {
	            backgroundColor: 'black'
	        },
	        colors: ['#F62366', '#9DFF02', '#0CCDD6'],
	        title: {
	            style: {
	                color: 'silver'
	            }
	        },
	        tooltip: {
	            style: {
	                color: 'silver'
	            }
	        }
	    });
	}
	// */
	
	/**
	 * In the chart render event, add icons on top of the circular shapes
	 */
	function renderIcons() {
	
		
		// ======================= 각 아이콘 만들기 ======================= //
	    // Move icon
	    if (!this.series[0].icon) {
	        this.series[0].icon = this.renderer.path(['M', -4, 0, 'L', 4, 0, 'M', 0, -4, 'L', 4, 0, 0, 4])
	            .attr({
	                stroke: '#303030',
	                'stroke-linecap': 'round',
	                'stroke-linejoin': 'round',
	                'stroke-width': 1,
	                zIndex: 10
	            })
	            .add(this.series[2].group);
	    }
	    this.series[0].icon.translate(
	        this.chartWidth / 2 - 10,
	        this.plotHeight / 2 - this.series[0].points[0].shapeArgs.innerR -
	            (this.series[0].points[0].shapeArgs.r - this.series[0].points[0].shapeArgs.innerR) / 2
	    );
	
	    // Exercise icon
	    if (!this.series[1].icon) {
	        this.series[1].icon = this.renderer.path(
	            ['M', -4, 0, 'L', 4, 0, 'M', 0, -4, 'L', 4, 0, 0, 4,
	                'M', 4, -4, 'L', 8, 0, 4, 4]
	        )
	            .attr({
	                stroke: '#ffffff',
	                'stroke-linecap': 'round',
	                'stroke-linejoin': 'round',
	                'stroke-width': 1,
	                zIndex: 10
	            })
	            .add(this.series[2].group);
	    }
	    this.series[1].icon.translate(
	        this.chartWidth / 2 - 10,
	        this.plotHeight / 2 - this.series[1].points[0].shapeArgs.innerR -
	            (this.series[1].points[0].shapeArgs.r - this.series[1].points[0].shapeArgs.innerR) / 2
	    );
	
	    // Stand icon
	    if (!this.series[2].icon) {
	        this.series[2].icon = this.renderer.path(['M', 0, 4, 'L', 0, -4, 'M', -4, 0, 'L', 0, -4, 4, 0])
	            .attr({
	                stroke: '#303030',
	                'stroke-linecap': 'round',
	                'stroke-linejoin': 'round',
	                'stroke-width': 1,
	                zIndex: 10
	            })
	            .add(this.series[2].group);
	    }
	
	    this.series[2].icon.translate(
	        this.chartWidth / 2 - 10,
	        this.plotHeight / 2 - this.series[2].points[0].shapeArgs.innerR -
	            (this.series[2].points[0].shapeArgs.r - this.series[2].points[0].shapeArgs.innerR) / 2
	    );
	}
	// ======================= 각 아이콘 만들기 ======================= //
	
	
	// ======================= 차트생성 ======================= //
	function chart(){
	Highcharts.chart('chart_container', {
	
	    chart: {
	        type: 'solidgauge',
	        height: '110%',
	        events: {
	            render: renderIcons
	        }
	    },
	
	    title: {	// title
	        text: 'email 사용도',
	        style: {
	            fontSize: '12px'
	        }
	    },
	
	    tooltip: {	// 호버시 나오는 글자
	        borderWidth: 0,
	        backgroundColor: 'none',
	        shadow: false,
	        style: {
	            fontSize: '12px'
	        },
	        valueSuffix: '%',
	        pointFormat: '{series.name}<br><span style="font-size:2em; color: {point.color}; font-weight: bold">{point.y}</span>',
	        positioner: function (labelWidth) {
	            return {
	                x: (this.chart.chartWidth - labelWidth) / 2,
	                y: (this.chart.plotHeight / 2) + 15
	            };
	        }
	    },
	
	 	// ======================= 각 원형 영역 생성 ======================= //
	    pane: {
	        startAngle: 0,
	        endAngle: 360,
	        background: [{ // Track for Move
	            outerRadius: '112%',
	            innerRadius: '88%',
	            backgroundColor: Highcharts.color(Highcharts.getOptions().colors[0])
	                .setOpacity(0.3)
	                .get(),
	            borderWidth: 0
	        }, { // Track for Exercise
	            outerRadius: '87%',
	            innerRadius: '63%',
	            backgroundColor: Highcharts.color(Highcharts.getOptions().colors[1])
	                .setOpacity(0.3)
	                .get(),
	            borderWidth: 0
	        }, { // Track for Stand
	            outerRadius: '62%',
	            innerRadius: '38%',
	            backgroundColor: Highcharts.color(Highcharts.getOptions().colors[2])
	                .setOpacity(0.3)
	                .get(),
	            borderWidth: 0
	        }]
	    },
	 	// ======================= 각 원형 영역 생성 ======================= //
	    
	    yAxis: {
	        min: 0,
	        max: 100,
	        lineWidth: 0,
	        tickPositions: []
	    },
	
	    plotOptions: {
	        solidgauge: {
	            dataLabels: {
	                enabled: false
	            },
	            linecap: 'round',
	            stickyTracking: false,
	            rounded: true
	        }
	    },
	
	    series: [{
	        name: '읽은 메일',
	        data: [{
	            color: Highcharts.getOptions().colors[0],
	            radius: '112%',
	            innerRadius: '88%',
	            y: readStatusPercentage
	        }]
	    }, {
	        name: '중요 메일',
	        data: [{
	            color: Highcharts.getOptions().colors[1],
	            radius: '87%',
	            innerRadius: '63%',
	            y: importantStatusPercentage
	        }]
	    }, {
	        name: '임시 저장함',
	        data: [{
	            color: Highcharts.getOptions().colors[2],
	            radius: '62%',
	            innerRadius: '38%',
	            y: saveStatusPercentage
	        }]
	    }]
	});
	}
    
    
</script>

<jsp:include page="../../footer/footer.jsp" /> 