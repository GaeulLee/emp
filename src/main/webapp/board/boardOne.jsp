<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.Board" %>
<%@ page import="vo.Comment" %>
<%@ page import="java.util.*" %>
<%
	// 1. 요청분석
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	// 댓글 페이징 위한 현재 페이지 값
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){// 새로운 페이지 값이 넘어온다면 바뀔 수 있도록
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}

	// 2-1. 게시글
	// 디비 접속 -> 데이터 들고오기(제목, 내용, 작성자, 날짜)
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("boardOne.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	String boardSql = "SELECT board_title boardTitle, board_content boardContent, board_writer boardWriter, createdate FROM board WHERE board_no = ?;";
	PreparedStatement boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	ResultSet boardRs = boardStmt.executeQuery();
	
	Board board = null;
	if(boardRs.next()){
		board = new Board();
		board.boardNo = boardNo;
		board.boardTitle = boardRs.getString("boardTitle");
		board.boardContent = boardRs.getString("boardContent");
		board.boardWriter = boardRs.getString("boardWriter");
		board.createdate = boardRs.getString("createdate");
	}
	
	//  댓글 페이징
	final int ROW_PER_PAGE = 5; // 한 페이지 당 댓글 개수 고정
	int beginRow = (currentPage-1)*ROW_PER_PAGE;
	
	String cntSql = "SELECT COUNT(*) cnt FROM comment WHERE board_no = ?;";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	cntStmt.setInt(1, boardNo);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 해당 게시물 당 댓글의 수
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	
	// 댓글 갯수 만큼 맞는 페이지 수 구하기
	// cnt 가 6이고, ROW_PER_PAGE 가 5 일때 -> 1.* -> 올림 -> 2
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	
	// 2-2. 댓글 목록 출력 처리
	String commentSql = "SELECT comment_no commentNo, comment_writer commentWriter, comment_content commentContent FROM comment WHERE board_no = ? ORDER BY comment_no DESC LIMIT ?,?";
	PreparedStatement commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, boardNo);
	commentStmt.setInt(2, beginRow);
	commentStmt.setInt(3, ROW_PER_PAGE);
	
	ResultSet commentRs = commentStmt.executeQuery();
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentRs.next()){
		Comment c = new Comment();
		c.commentNo = commentRs.getInt("commentNo");
		c.commentWriter = commentRs.getString("commentWriter");
		c.commentContent = commentRs.getString("commentContent");
		commentList.add(c);
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
		<!-- 메뉴는 파티션jsp로 구성 -->
		<div>
			<jsp:include page="../inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
		</div>
		<div class="container w-75 mx-auto">
			<!-- 본문 시작 -->
			<div class="rounded mt-1 h4 text-white" id="title"><%=board.boardTitle%></div>
			<table class="table table-borderless shadow-sm p-4 mb-4 bg-white align-middle">
				<tr>
					<th class="w-25">게시물 번호</th>
					<td><%=boardNo%></td>
				</tr>
				<tr class="h-50">
					<th class="w-25">내용</th>
					<td height="550px" class="align-top"><%=board.boardContent%></td>
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
			
			<!-- 댓글 입력 -->
			<div>
				<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post" class="mt-0">
					<input type="hidden" value="<%=boardNo%>" name="boardNo">
					<table class="table table-borderless shadow-sm p-4 mb-0 bg-white align-middle table-light">
						<%
							String msg = request.getParameter("msg");
							if(msg != null){
							%>
								<tr>
									<td colspan="3" class="text-primary"> &#10069;<%=msg%></td>
								</tr>
							<%
								}
						%>
						<tr>
							<th>댓글적기</th>
							<td colspan="2">
								<textarea rows="3" name="commentContent" class="form-control"></textarea>
							</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td colspan="2">
								<input type="text" name="commentWriter" class="w-25 form-control">
							</td>
						</tr>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" name="commentPw" class="w-25 form-control">
							</td>
							<td>
								<button type="submit" class="btn btn-outline-primary float-end">댓글입력</button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			
			<!-- 댓글 리스트 -->
			<div>
				<table class="table shadow-sm p-4 mt-1 bg-white align-middle table-light">
					<tr>
						<th>댓글번호</th>
						<th>작성자</th>
						<th class="w-75">&nbsp;</th>
						<th style="width:30px;">&nbsp;</th>
					</tr>
				<%
					for(Comment c : commentList){
				%>
						<tr>
							<td style="text-align:center;"><%=c.commentNo%></td>
							<td><%=c.commentWriter%></td>
							<td><%=c.commentContent%></td>
							<td>
								<a href="<%=request.getContextPath()%>/board/deleteCommentForm.jsp?commentNo=<%=c.commentNo%>&boardNo=<%=boardNo%>" class="btn-close">
								</a>
							</td>
						</tr>
				<%
					}
				%>
					<!-- 페이징 -->
					<tr>
						<td colspan="4">
							<ul class="pagination justify-content-center mb-0">
								<li class="page-item">
									<%
										if(currentPage > 1) {
									%>
											<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>" class="page-link">
												이전
											</a>
									<%		
										}
									%>
								</li>
								<li class="page-item">
									<%				
										// 다음 <-- 마지막페이지 <-- 전체행의 수 
										if(currentPage < lastPage) {
									%>
											<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>" class="page-link">
												다음
											</a>
									<%	
										}
									%>
								</li>
							</ul>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</body>
</html>