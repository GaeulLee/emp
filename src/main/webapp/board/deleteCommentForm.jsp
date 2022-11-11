<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String commentNo = request.getParameter("commentNo");
	
	// 안전장치
	if(request.getParameter("boardNo") == null || request.getParameter("commentNo") == null){
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	}
	
	// 2. 요청처리
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	
	String sql = "SELECT board_no boardNo, comment_no commentNo FROM comment WHERE board_no = ? AND comment_no = ?;";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setString(2, commentNo);
	ResultSet rs = stmt.executeQuery();

	// 3. 요청출력
%>
<!DOCTYPE html>
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
			table{
				text-align: center;
			}
		</style>
	</head>
	<body>
		<div class="container w-25 mx-auto">
			<!-- 본문 시작 -->
			<div class="rounded mt-4 h4 text-white" id="title">댓글 삭제</div>
			<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post">
				<table class="table table-borderless shadow-sm p-4 mb-4 bg-white align-middle">
				<%
				String msg = request.getParameter("msg");
				if(msg != null){
				%>
					<tr>
						<td colspan="2" class="text-primary"> &#10069;<%=msg%></td>
					</tr>
				<%
					}
				%>
					<tr>
						<td>
							<!-- input type에 hidden 속성을 추가해서 값을 숨기면서 넘김 -->
							<input type="hidden" value="<%=boardNo%>" name="boardNo" class="form-control">
							<input type="hidden" value="<%=commentNo%>" name="commentNo" class="form-control">
						</td>
					</tr>
					<tr>
						<th>
							정말 댓글을 삭제하시겠습니까?
						</th>
					</tr>
					<tr>
						<td>
							<input type="password" name="commentPw" class="form-control w-50 mx-auto" placeholder="비밀번호를 입력해주세요.">
						</td>
					</tr>
					<tr>
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-outline-primary float-start">BACK</a>
							<button type="submit" class="btn btn-light float-end me-2">삭제</button>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>