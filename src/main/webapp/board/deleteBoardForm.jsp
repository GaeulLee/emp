<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	if(request.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath()+"/board/boardList.jsp");
		return;
	}
%>
<html>
	<head>
		<meta charset="UTF-8">
		<title>BoardOne</title>
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
		<div class="container w-25 mx-auto">
			<!-- 본문 시작 -->
			<div class="rounded mt-1 h4 text-white" id="title">게시물 삭제 확인</div>
			<form action="<%=request.getContextPath()%>/board/deleteBoardAction.jsp" method="post">
				<table class="table table-borderless shadow-sm p-4 mb-4 bg-white align-middle">
					<%
					String msg = request.getParameter("msg");
					if(msg != null){
					%>
						<tr>
							<th colspan="2" class="text-primary"> &#10069;<%=msg%></th>
						</tr>
					<%
						}
					%>
					<tr>
						<th>정말 게시물을 삭제하시겠습니까?</th>
					</tr>
					<tr>
						<th hidden><%=boardNo%></th>
					</tr>
					<tr>
						<td>
							<input type="text" name="boardPw" class="form-control w-50 mx-auto" placeholder="비밀번호를 입력해주세요.">
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-outline-primary float-start">BACK</a>
							<button type="submit" class="btn btn-light float-end me-2">삭제</button>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>