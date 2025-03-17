<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@	taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
String ctxPath = request.getContextPath();
%>

<jsp:include page="document_main.jsp" />

<script type="text/javascript">

	$(document).ready(function(){
		
		<%-- 모달 바깥 부분을 클릭했을 때 모달이 사라지게 하는 이벤트 --%>
	    $('.modal_bg:not(.modal_container_document)').click(e=>{
	    	close_modal();
	    });
		
	    <%-- 결재 버튼 클릭 시 결재 모달이 나타나게 하는 이벤트 --%>
		$("button#approve_btn").click(e=>{
			$("h3#approve_title").text("결재하기");
			$("th.reason").text("결재의견");
			$("button#execute_btn").text("승인");
			$("button#execute_btn").addClass("approve_btn");
			$("button#execute_btn").removeClass("reject_btn");
			open_modal();
		});
		
		<%-- 결재 버튼 클릭 시 반려 모달이 나타나게 하는 이벤트 --%>
		$("button#reject_btn").click(e=>{
			$("h3#approve_title").text("반려하기");
			$("th.reason").text("반려의견");
			$("button#execute_btn").text("반려");
			$("button#execute_btn").addClass("reject_btn");
			$("button#execute_btn").removeClass("approve_btn");
			open_modal();
		});
		
		<%-- 모달 창에서 승인 또는 반려 버튼 클릭 시 이벤트 --%>
		$("button#execute_btn").click(e=>{
			
			<%-- 결재 모달 창에서 승인 버튼 클릭 시 --%>
			if($(e.target).hasClass("approve_btn")) {
				approve();
			}
			
			<%-- 결재 모달 창에서 반려 버튼 클릭 시 --%>
			else if($(e.target).hasClass("reject_btn")) {
				reject();
			}
		});
		
		<%-- 다운로드 버튼 클릭 시 이벤트 이벤트 --%>
		$("button#download_btn").click(e=>{
			
			let url = `http://localhost:9090/flowUp/document/documentView?documentNo=\${document.documentNo}&documentType=\${document.documentType}`;
			
			$.ajax({
				url:"<%= ctxPath%>/document/documentView/download",
				dataType:"json",
				data:{"url":url},
				success:function(json){
					alert("good");
				},
				error: function(request, status, error){
					alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
				}
			})
			
		});
		
		
	}); // end of $(document).ready(function(){})---------------------

	<%-- 모달을 띄우는 함수 --%>
	function open_modal() {
		$('#approve_modal_bg').fadeIn();
		$('.box_modal_container').css({
			'display':'block'
		});
	}
	
	<%-- 모달을 사라지게 하는 함수 --%>
	function close_modal() {
		$('#approve_modal_bg').fadeOut();
        $('.box_modal_container').css({
        	'display':''
		});
	}
	
	<%-- 결재 승인 처리 함수 --%>
	function approve() {
		
		$.ajax({
			url:"<%=ctxPath%>/document/documentView/approve",
			dataType:"json",
			data:{"documentNo":"${document.documentNo}"
				  ,"documentType":"${document.documentType}"},
			success:function(json){
				if(json.n == 1) {
					alert("결재 성공");
					location.href='<%=ctxPath%>/document/documentView?documentNo=${document.documentNo}&documentType=${document.documentType}';
				}
				else {
					alert("결재 실패");
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
	}
	
	<%-- 결재 반려 처리 함수 --%>
	function reject() {
		
		$.ajax({
			url:"<%=ctxPath%>/document/documentView/reject",
			dataType:"json",
			data:{"documentNo":"${document.documentNo}"},
			success:function(json){
				if(json.n == 1) {
					alert("반려 성공");
					location.href='<%=ctxPath%>/document/documentView?documentNo=${document.documentNo}&documentType=${document.documentType}';
				}
				else {
					alert("반려 실패");
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
	}
	
	<%-- 임시 저장 문서 삭제하는 함수 --%>
	function deleteTemp() {
		
		$.ajax({
			url:"<%=ctxPath%>/document/documentView/deleteTemp",
			dataType:"json",
			data:{"documentNo":"${document.documentNo}"},
			success:function(json){
				if(json.n == 1) {
					alert("삭제 성공");
					location.href='<%=ctxPath%>/document/tempList';
				}
				else {
					alert("삭제 실패");
				}
			},
			error: function(request, status, error){
				alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
			}
		});
	}
	
</script>


	<%-- 결재처리 모달 --%>
	<div id="approve_modal_bg" class="modal_bg">
		<%-- 모달창을 띄웠을때의 뒷 배경 --%>
	</div>
	<div id="approve_modal_container" class="box_modal_container">
	
		<div class="m-5">
			<h3 id="approve_title" class="mb-5"></h3>
			<table class="approve_modal_info">
				<tbody>
					<tr>
						<th>결재문서명</th>
						<td>${document.subject}</td>
					</tr>
					<tr>
						<th class="reason"><span></span></th>
						<td><textarea name="approve_reason" class="approve_modal_reason"></textarea></td>
					</tr>
				</tbody>
			</table>
			<div class="mt-5 text-right">
				<button id="execute_btn" class="btn btn-outline-primary btn-sm mr-2">승인</button>
				<button onclick="close_modal()" class="approve_btn btn btn-outline-danger btn-sm">취소</button>
			</div>
		</div>
	</div>
	<%-- 결재처리 모달 --%>
	
	

	<div>
		<div id="right_title_box">
			<h3 class="mb-3">${document.documentType}</h3>
			
			<%-- 결재해야할 문서 (결재 순서가 자기 차례인 문서)를 보는 경우 결재/반려 버튼이 보이도록 --%>
			<c:if test="${not empty requestScope.approvalList}">
			
				<%-- 결재자 리스트는 결재순서의 역순으로 가져온다 --%>
				<c:set var="isOrder" value="true" /> <%-- 나보다 결재 순서가 빠른 결재자가 있는지 확인하는 변수 --%>
				
				<c:forEach var="approval" items="${requestScope.approvalList}">
				
					<c:if test="${isOrder}">
						<c:if test="${approval.approvalStatus eq 0 && sessionScope.loginuser.employeeNo ne approval.fk_approver}">
						<%-- 나보다 결재 순서가 빠른데 아직 결재 처리를 하지 않은 사람이 있는 경우 --%>
							<c:set var="isOrder" value="false" />
						</c:if>
						<c:if test="${approval.approvalStatus eq 0 && sessionScope.loginuser.employeeNo eq approval.fk_approver && document.status ne 2 && document.temp ne 1}">
						<%-- 내 결재 차례인데 반려 처리 되지 않은 경우 --%>
							<button id="approve_btn" class="btn btn-outline-primary btn-sm">결재</button>
							<button id="reject_btn" class="btn btn-outline-danger btn-sm">반려</button>
						</c:if>
					</c:if>
					
				</c:forEach>
				
			</c:if>
			<%-- 결재해야할 문서 (결재 순서가 자기 차례인 문서)를 보는 경우 결재/반려 버튼이 보이도록 --%>
			
			
			<%-- 결재완료된 문서라면 다운로드 버튼이 보이도록 --%>
			<%--
			<c:if test="${requestScope.document.status == 1}">
				<button id="download_btn" class="doc_btn">다운로드</button>
			</c:if>
			--%>
			
			<%-- 결재완료된 문서라면 다운로드 버튼이 보이도록 --%>

			
			<!-- 임시 저장 문서라면 수정하기 및 삭제하기 버튼이 보이도록 -->
			<c:if test="${document.temp eq 1}">
			
				<!-- 임시저장 문서 수정하기 버튼 -->
				<span class="edit_temp">
	                <a onclick="location.href='<%=ctxPath%>/document/documentView/editTemp?documentNo=${document.documentNo}&documentType=${document.documentType}';">
	                    <span>수정</span>
	                    <i class="fa-solid fa-pencil"></i>
	                </a>
	            </span>
	            
	            <!-- 임시저장 문서 삭제하기 버튼 -->
				<span class="delete_temp">
	                <a href="" onclick="deleteTemp()">
	                    <span>삭제</span>
	                    <i class="fa-regular fa-trash-can"></i>
	                </a>
	            </span>
	            
			</c:if>
			
			<!-- 임시 저장 문서라면 수정하기 및 삭제하기 버튼이 보이도록 -->
			
			
		</div>
		<div class="m-3 draftForm">
			<div>
				<h3 style="text-align: center" class="mb-5">${document.documentType}</h3>
				<div style="display: flex">
					<div class="drafter_info">
						<table>
							<tbody>
								<tr>
									<th>기안자</th>
									<td>${document.name}</td>
								</tr>
								<tr>
									<th>소속</th>
									<td>${document.teamName}</td>
								</tr>
								<tr>
									<th>기안일</th>
									<td>${document.draftDate}</td>
								</tr>
								<tr>
									<th>문서번호</th>
									<td>${document.documentNo}</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div style="margin-left: auto;">
					
						<!-- 결재 라인이 들어올 곳 -->
						<div class="approval_info" id="approval_line">
							<c:if test="${not empty requestScope.approvalList}">
								<c:forEach var="approval" items="${requestScope.approvalList}">
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
											<tr>
												<th>결재상태</th>
												<td>
													<c:if test="${approval.approvalStatus == 0}"><span class="p-1 in_progress">대기중</span></c:if>
													<c:if test="${approval.approvalStatus == 1}"><span class="p-1 approved">승인</span></c:if>
													<c:if test="${approval.approvalStatus == 2}"><span class="p-1 rejected">반려</span></c:if>
												</td>
											</tr>
										</tbody>
									</table>
								</c:forEach>
							</c:if>
						</div>
						<!-- 결재 라인이 들어올 곳 -->
						
					</div>
				</div>
				<div>
				
				
					<!-- 휴가신청서 폼 -->
					<c:if test="${document.documentType == '휴가신청서'}">
						<table class="mt-5" style="width: 100%;">
							<tbody>
								<tr>
									<th>긴급</th>
									<td>
										<c:if test="${document.urgent eq 0}">
											<input class="ml-1" type="checkbox" name="check_urgent" onClick="return false;"/>
										</c:if>
										<c:if test="${document.urgent eq 1}">
											<input class="ml-1" type="checkbox" name="check_urgent" checked="checked" onClick="return false;"/>
										</c:if>
									</td>
								</tr>
								<tr>
									<th>제목</th>
									<td>${document.subject}</td>
								</tr>
								<tr>
									<th>휴가 종류</th>
									<td>
										<c:if test="${document.annualType == 1}">연차</c:if>
										<c:if test="${document.annualType == 2}">오전반차</c:if>
										<c:if test="${document.annualType == 3}">오후반차</c:if>
									</td>
								</tr>
								<tr>
									<th>사유</th>
									<td>${document.reason}</td>
								</tr>
								<tr>
									<th>기간 및 일시</th>
									<td>${document.startDate} ~ ${document.endDate}</td>
								</tr>
								<tr>
									<th>신청 연차 일수</th>
									<td>${document.useAmount} 일</td>
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
					<!-- 휴가신청서 폼 -->
					
					
					<!-- 연장근무신청서 폼 -->
					<c:if test="${document.documentType == '연장근무신청서'}">
						<table class="mt-5" style="width: 100%;">
							<tbody>
								<tr>
									<th>긴급</th>
									<td>
										<c:if test="${document.urgent eq 0}">
											<input class="ml-1" type="checkbox" name="check_urgent" onClick="return false;"/>
										</c:if>
										<c:if test="${document.urgent eq 1}">
											<input class="ml-1" type="checkbox" name="check_urgent" checked="checked" onClick="return false;"/>
										</c:if>
									</td>
								</tr>
								<tr>
									<th>제목</th>
									<td>${document.subject}</td>
								</tr>
								<tr>
									<th>사유</th>
									<td>${document.reason}</td>
								</tr>
								<tr>
									<th>연장 근무 일자</th>
									<td>${document.overtimeDate}</td>
								</tr>
								<tr>
									<th>연장 근무 시간</th>
									<td>3 시간</td>
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
					<!-- 연장근무신청서 폼 -->
					
					
					<!-- 지출품의서 폼 -->
					<c:if test="${document.documentType == '지출품의서'}">
						<table class="mt-5" style="width: 100%;">
							<tbody>
								<tr>
									<th>긴급</th>
									<td>
										<c:if test="${document.urgent eq 0}">
											<input class="ml-1" type="checkbox" name="check_urgent" onClick="return false;"/>
										</c:if>
										<c:if test="${document.urgent eq 1}">
											<input class="ml-1" type="checkbox" name="check_urgent" checked="checked" onClick="return false;"/>
										</c:if>
									</td>
								</tr>
								<tr>
									<th>총 금액</th>
									<td>${requestScope.document.totalExpenseAmount}</td>
								</tr>
								<tr>
									<th>지출사유</th>
									<td style="height: 150px; vertical-align: top;">${requestScope.document.reason}</td>
								</tr>
					
							</tbody>
						</table>
						
						<table style="width: 100%" class="mt-5">
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
								<c:if test="${not empty requestScope.expenseDetailList}">
									<c:forEach var="expenseDetail" items="${requestScope.expenseDetailList}">
										<tr>
											<td>${expenseDetail.useDate}</td>
											<td>${expenseDetail.type}</td>
											<td>${expenseDetail.amount}</td>
											<td>${expenseDetail.content}</td>
											<td>${expenseDetail.note}</td>
										</tr>
									</c:forEach>
								</c:if>
							</tbody>
						</table>
					</c:if>
					<!-- 지출품의서 폼 -->
					
					
					<!-- 업무기안 폼 -->
					<c:if test="${document.documentType eq '업무기안'}">
						<table class="mt-5" style="width: 100%;">
							<tbody>
								<tr>
									<th>긴급</th>
									<td>
										<c:if test="${document.urgent eq 0}">
											<input class="ml-1" type="checkbox" name="check_urgent" onClick="return false;"/>
										</c:if>
										<c:if test="${document.urgent eq 1}">
											<input class="ml-1" type="checkbox" name="check_urgent" checked="checked" onClick="return false;"/>
										</c:if>
									</td>
								</tr>
								<tr>
									<th>제목</th>
									<td>${document.subject}</td>
								</tr>
								<tr>
									<th>협조부서</th>
									<td>${document.coDepartment}</td>
								</tr>
								<tr>
									<th>시행 일자</th>
									<td>${document.doDate}</td>
								</tr>
								<tr>
									<th>내용</th>
									<td>${document.businessContent}</td>
								</tr>
							</tbody>
						</table>
					</c:if>
					<!-- 업무기안 폼 -->
					
					
					
				</div>
			</div>
			
			<%--
			<div id="fileList" class="my-5 p-1">
				<div><i class="fa-solid fa-paperclip mx-2"></i>첨부파일 0개 (0.0KB)</div>
			</div>
			--%>
			
			<div class="mt-5">
				<a onclick="history.back()" style="color: black; cursor: pointer">
					<i class="fa-solid fa-circle-arrow-left">&nbsp;뒤로가기</i>
				</a>
			</div>
		</div>
	</div>

</div>
<jsp:include page="../../footer/footer.jsp" />
