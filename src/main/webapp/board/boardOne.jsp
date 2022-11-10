<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.Board" %>
<%
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));

	// 2. 요청처리
	// 디비 접속 -> 데이터 들고오기(제목, 내용, 작성자, 날짜)
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("boardOne.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	String sql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?;";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board board = null;
	if(rs.next()){
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = rs.getString("boardTitle");
		board.boardContent = rs.getString("boardContent");
		board.boardWriter = rs.getString("boardWriter");
		board.createdate = rs.getString("createdate");
	}
	
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
			<div class="rounded mt-1 h4 text-white" id="title"><%=board.boardTitle%></div>
			<table class="table table-borderless shadow-sm p-4 mb-4 bg-white align-middle">
				<tr>
					<th class="w-25">게시물 번호</th>
					<td><%=boardNo%></td>
				</tr>
				<tr class="h-50">
					<th class="w-25">내용</th>
					<td><%=board.boardContent%></td>
				</tr>
				<tr>
					<th class="w-25">작성자</th>
					<td><%=board.boardWriter%></td>
				</tr>
				<tr>
					<th class="w-25">작성일</th>
					<td><%=board.createdate%></td>
				</tr>
				<tr>
					<td colspan="2">
						<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-outline-primary float-start">BACK</a>
						<a href="<%=request.getContextPath()%>/board/deleteBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-light float-end">삭제</a>
						<a href="<%=request.getContextPath()%>/board/updateBoardForm.jsp?boardNo=<%=boardNo%>" class="btn btn-light float-end me-2">수정</a>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>