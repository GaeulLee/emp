<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>empOne</title>
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			#title{
				height: 50px;
				line-height: 50px;
				background-color: lightgrey;
				text-align: center;
			}
			th{
				text-align: center;
			}
		</style>
	</head>
	<body>
		<div class="container w-75 mx-auto">
			<!-- 메뉴는 파티션jsp로 구성 -->
			<div>
				<jsp:include page="../inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
			</div>
			<!-- 본문 시작 -->
			<div class="rounded mt-1 h4 text-white" id="title"><%=%></div>
			<table class="table table-borderless shadow-sm p-4 mb-4 bg-white align-middle">
				<tr>
					<th class="w-25">사원번호</th>
					<td><%=%></td>
				</tr>
				<tr class="h-50">
					<th class="w-25">내용</th>
					<td><%=%></td>
				</tr>
				<tr>
					<th class="w-25">작성자</th>
					<td><%=%></td>
				</tr>
				<tr>
					<th class="w-25">작성일</th>
					<td><%=%></td>
				</tr>
				<tr>
					<td colspan="2">
						<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="btn btn-outline-primary float-start">BACK</a>
						<a href="<%=request.getContextPath()%>/emp/deleteEmpForm.jsp?empNo=<%=%>" class="btn btn-light float-end">삭제</a>
						<a href="<%=request.getContextPath()%>/emp/updateEmpForm.jsp?empNo=<%=%>" class="btn btn-light float-end me-2">수정</a>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>