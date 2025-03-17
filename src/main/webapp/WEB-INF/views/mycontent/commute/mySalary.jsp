<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String ctxPath = request.getContextPath();
//     /myspring

%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="../../header/header.jsp" />

<style>
* {
	font-family: "Noto Sans KR", sans-serif;
	font-optical-sizing: auto;
	margin: 0px;
	padding: 0px;
}

*::after {
	margin: 0px;
	padding: 0px;
}

*::before {
	margin: 0px;
	padding: 0px;
}

:root {
	--size2: clamp(2px, 0.1042vw, 200px);
	--size8: clamp(6px, 0.4167vw, 200px);
	--size12: clamp(10px, 0.6250vw, 200px);
	--size14: clamp(12px, 0.7292vw, 200px);
	--size15: clamp(14px, 0.7813vw, 200px);
	--size16: clamp(16px, 0.8333vw, 200px);
	--size18: clamp(17px, 0.9375vw, 200px);
	--size20: clamp(18px, 1.0417vw, 200px);
	--size24: clamp(24px, 1.2500vw, 200px);
	--size30: clamp(28px, 1.5625vw, 200px);
	--size32: clamp(30px, 1.6667vw, 200px);
	--size40: clamp(36px, 2.0833vw, 200px);
	--size52: clamp(48px, 2.7083vw, 200px);
	--size60: clamp(50px, 3.1250vw, 200px);
	--size65: clamp(60px, 3.3854vw, 200px);
	--size98: clamp(80px, 5.1042vw, 2000px);
	--size100: clamp(80px, 5.2083vw, 2000px);
	--size120: clamp(100px, 6.2500vw, 2000px);
	--size200: clamp(200px, 10.4167vw, 2000px);
	--size300: clamp(300px, 15.6250vw, 2000px);
	--size400: clamp(380px, 20.8333vw, 2000px);
	--size500: clamp(500px, 26.0417vw, 2000px);
	--size670: clamp(650px, 34.8958vw, 2000px);
	--size700: clamp(680px, 36.4583vw, 3000px);
	--size930: clamp(900px, 48.4375vw, 10000px);
	--whiteColor: #fff;
	--baseColor1: #F9FAFB;
	--baseColor2: #f1f2f3;
	--pointColor: #2985DB;
	--keyColor: #21255b;
	--darkBgColor: #0C1929;
	--darkBaseColor: #141C30;
}

.dateController {
	width: 100%;
	margin: auto;
}

.dateTopBar {
	display: flex;
	gap: var(--size16);
	align-items: center;
	justify-content: space-between;
	padding: 0px var(--size24);
	margin-bottom: var(--size30);
}

.dateTopBtn {
	display: flex;
	gap: var(--size16);
	align-items: center;
	justify-content: center;
}

#today {
	font-size: var(--size24);
	font-weight: 500;
}

#now {
	box-sizing: border-box;
	padding: calc(var(--size2)+ var(--size2)) calc(var(--size2)+ var(--size2));
	margin-top: calc(var(--size2)+ var(--size2));
	font-size: var(--size12);
}

#now:hover {
	background-color: #eee;
}

.calendar_container {
	position: relative;
}

table {
	border-collapse: collapse;
	font-size: var(--size14);
	border: 1px solid #ddd;
	width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
	border-spacing: 0;
}

table tr th, .info {
	height: var(--size30);
	font-weight: normal;
	text-align: center;
}

.info {
	vertical-align: middle;
	overflow: hidden;
	text-align: center;
	border-left: 0;
}

.info span {
	display: block;
	color: #333;
	text-align: left;
	margin: 2px 5px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	max-width: 100%;
	cursor: pointer;
	font-size: 13px;
}

table td {
	position: relative;
	z-index: 1;
}

div.hoverDiv:hover {
	cursor: pointer;
}

/*   table td:hover {
    	background-color: yellow;
    	cursor: pointer;
    } */
.openDiv {
	display: block;
}

.closeDiv {
	display: none;
}





</style>

<script>
    $(document).ready(() => {
    	
    	let currentShowPageNo = ${requestScope.currentShowPageNo};
    	
        // ====================== 날짜 리모컨 기능 생성 ====================== //
        const currentDate = new Date(); 
        let year = currentDate.getFullYear();
        
        let today = new Date();
        
        
        // 이전 버튼 클릭 시
        $('#prev').click(() => {
        	year = year - 1;
            week_div(year, currentShowPageNo);
            
        });

        // 다음 버튼 클릭 시
        $('#next').click(() => {
        	year = year + 1;
            week_div(year, currentShowPageNo);
        });

        // 오늘 버튼 클릭 시
        $('#now').click(() => {
        	year = currentDate.getFullYear();
            week_div(year, currentShowPageNo);
        });

       
        // 페이지 로드 시 현재 날짜 및 테이표시
        week_div(year, currentShowPageNo);
        // ====================== 날짜 리모컨 기능 생성 ====================== //
 
        $('div.oneday').hide();
        
		$("select#sizePerPage").change(e=>{
			
			spread_tbody(currentShowPageNo);
        });
		
		
    }); // end of $(document).ready(() => {})-------------

    function week_div(year, currentShowPageNo) {
    	
        $('div#today').text(year);
    	
        spread_tbody(currentShowPageNo);
        
    } //// week_div(today) 
    
    	
   	function spread_tbody(currentShowPageNo) {
    	
   		const year = $("div#today").text();
    	
   		const sizePerPage = $("select#sizePerPage").val();
   
   	    const currentDate = new Date(); 
        const currentDate_year = currentDate.getFullYear();
   		
   		console.log("sizePerPage : " + sizePerPage);
   		console.log("year : " + year);
   		console.log("currentShowPageNo : " + currentShowPageNo);
    	
   		$.ajax({
    		url:"<%=ctxPath%>/commute/getMySalaryInfo",
			type:"get",
			data:{"employeeNo":"${sessionScope.loginuser.employeeNo}"
				 ,"year":year
				 ,"sizePerPage":sizePerPage
				 ,"currentShowPageNo":currentShowPageNo},
			dataType:"json",
			success:function(json) {
				
				console.log(JSON.stringify(json));
				
				$("input#year").val(json.paraMap.year);
				$("input#currentShowPageNo").val(json.paraMap.currentShowPageNo);
				
				let html = ``;
				
				if(json.mapList.length > 0 ) {
					
					$.each(json.mapList, (index,item)=>{
						
						const totalPay = Number(item.monthSalary) + Number(item.overtimePay) + Number(item.incentive);
						
						html += `<tr>
									<td style="text-align: center; vertical-align:middle">\${item.workRange}</td>
									<td style="text-align: center; vertical-align:middle">\${Number(item.monthSalary).toLocaleString('en')} 원</td>
									<td style="text-align: center; vertical-align:middle">\${item.total_overtime}</td>
									<td style="text-align: center; vertical-align:middle">\${Number(item.overtimePay).toLocaleString('en')} 원</td>
									<td style="text-align: center; vertical-align:middle">\${item.incentiveReason}</td>
									<td style="text-align: center; vertical-align:middle">\${Number(item.incentive).toLocaleString('en')} 원</td>
									<td style="text-align: center; vertical-align:middle">\${totalPay.toLocaleString('en')} 원</td>
									<td style="text-align: center; vertical-align:middle">\${item.bank}</td> 
									<td style="text-align: center; vertical-align:middle">\${item.account}</td>
									<td style="text-align: center; vertical-align:middle">\${item.paymentDate}</td>
								  </tr>`;
					
					});
					
					
					$("div#pageBar").html(json.pageBar);
					
				}
				else {
					html += `<tr><td colspan="10" style="text-align: center; vertical-align:middle; font-size:12pt;">데이터가 없습니다.</td></tr>`;
					
					$("div#pageBar").html("");
				}
				
				$("tbody#tbody").html(html);
				
				
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		    		
		});
    	
   		
    } // end of spread_tbody(year) 
    	
    
	function secToHour(total_sec) {

		const hour = Math.floor( total_sec / 60 / 60 ) ;
		const s_hour = String(hour).padStart(2, '0');
		
		const min = Math.floor( ( total_sec / 60 / 60 - hour ) * 60);
		const s_min = String(min).padStart(2, '0');
		
		const sec = Math.floor( ( ( ( total_sec / 60 / 60 ) - hour ) * 60 - min ) * 60 );
		const s_sec = String(sec).padStart(2, '0');	
			
		
		const worktime = s_hour + "h " + s_min + "m " + s_sec +"s";
		
		return worktime;
	}
    
    function hourToSec(hour, min, sec) {
    	
    	return Number(hour) * 60 * 60 + Number(min) * 60 + Number(sec);
    }
    
    
    
    
    
    
</script>

<div style="display: flex;">

	<div style="width: var(--size250);; height: 100vh; border-right: solid 1px #000;">

		<jsp:include page="../../common/commute_btn.jsp" />

	</div>

	<div style="width: 100%; padding: 20px;">
	
		<div class="ml-1 mr-1 mb-5">
			
			<div style="font-size:14pt;">내 급여내역</div>
			
		</div>
	
		<div class="dateController">
			<div class="dateTopBar">

				<div class="dateTopBtn" style="width: 200px; margin: 0 auto;">
					<span id="prev" style="cursor: pointer;">&#60;</span>
					<!-- 이전날짜 버튼 -->
					<div id="today" style="text-align: center;">year</div>
					<!-- 날짜 표기 -->
					<span id="next" style="cursor: pointer;">&#62;</span>
					<!-- 다음날짜 버튼 -->

					<span id="now" style="cursor: pointer;">올해</span>
				</div>

			</div>

		</div>
		
	

		<div>
		
			<div class="mb-1" style="display:flex" >
				
				<div style="margin:0 auto 0 0; display:flex; gap:8px;">
				
				</div>
					
				<div style="margin:0 0 0 auto;display:flex; gap:8px;">
				
					<%-- <button type="button" id="btn_search" onclick="" class="btn btn-sm btn-outline-secondary" style="width:100px; height:30px; line-height:15px;">엑셀 다운로드</button> --%>
					<select id="sizePerPage" name="sizePerPage" style="width:70px;">
						<option value="3">3</option>
						<option value="5">5</option>
						<option value="10">10</option>	
					</select>				
				</div>
				
			</div>
		
			
			<table class="table table-striped table-hover">
					
				<thead class="thead text-center" style="font-size:14pt; color:#2985DB; font-weight: bold;">
				
					<tr>
						<th>근무기간</th>
						<th>기본급</th>
						<th>초과근무 시간</th>
						<th>초과근무 수당</th>
						<th>인센티브 사유</th>
						<th>인센티브 수당</th>
						<th>지급 총액</th>
						<th>지급 은행</th>
						<th>지급 계좌번호</th>
						<th>지급일자</th>
					</tr>
				
				</thead>
						
				<tbody id="tbody"></tbody>
					
			</table>
					
			<div id="pageBar" style="width:100%; text-align:center;"></div>

		</div>




	</div>

</div>
<input type="hidden" id="year" value="">
<input type="hidden" id="currentShowPageNo" value="">

<jsp:include page="../../footer/footer.jsp" />
