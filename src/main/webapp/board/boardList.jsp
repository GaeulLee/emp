<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청분석
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 2. 요청처리 후 필요하다면 모델데이터 생성
	final int ROW_PER_PAGE = 10; //  final: 변수 값을 바꿀 수 없게 해줌 + 대문자로 적음(띄어쓰기는 _ 로)
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...LIMIT beginRow, ROW_PER_PAGE
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("boardList.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// 전체 게시물 행 구하기
	String cntSql = "SELECT COUNT(*) cnt FROM board;";
	PreparedStatement cntStmt = conn.prepareStatement(cntSql);
	ResultSet cntRs = cntStmt.executeQuery();
	int cnt = 0; // 전체 행의 수
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	
	// 마지막 페이지 구하기
	// 올림을 하게 되면 5.3 -> 6.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	
	// 페이지당 게시물과 전체 게시물 수로 게시물 불러오기
	String listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter, createdate FROM board ORDER BY board_no DESC LIMIT ?,?;";
	PreparedStatement listStmt = conn.prepareStatement(listSql);
	
	listStmt.setInt(1, beginRow);
	listStmt.setInt(2, ROW_PER_PAGE);
	
	ResultSet listRs = listStmt.executeQuery(); // 모델의 source data
	
	ArrayList<Board> boardList = new ArrayList<Board>(); // 모델의 new data
	
	while(listRs.next()){
		Board b = new Board();
		b.boardNo = listRs.getInt("boardNo");
		b.boardTitle = listRs.getString("boardTitle");
		b.boardWriter = listRs.getString("boardWriter");
		b.createdate = listRs.getString("createdate");
		boardList.add(b);
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>boardList</title>
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			table {
				text-align: center;
			}
			#header {
				height: 70px;
				line-height: 60px;
				text-align: center;
			}
		</style>
	</head>
	<body>
	<div class="container">
		<!-- 메뉴는 파티션jsp로 구성 -->
		<div>
			<jsp:include page="../inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
		</div>
		<!-- 본문시작 -->
		<div class="h1 mt-2" id="header">자유게시판</div>
		<!-- 3-1. 모델 데이터 어레이리스트 출력 -->	
		<table class="table table-hover align-middle shadow-sm p-4 mb-4 bg-white">
			<tr class="table-primary">
				<th>게시물 번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
			</tr>
				<%
					for(Board b : boardList){
				%>
					<tr>
						<td><%=b.boardNo%></td>
						<!-- 제목 클릭 시 상세보기로 이동 -->
						<td style="text-align:left;">
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.boardNo%>" class="text-muted"><%=b.boardTitle%></a>
						</td>
						<td><%=b.boardWriter%></td>
						<td><%=b.createdate%></td>
					<tr>
				<%
					}
				%>
		</table>
		<a href="<%=request.getContextPath()%>/board/insertboardForm.jsp" class="btn btn-outline-primary float-end" >새 게시글 작성</a>
		
		<!-- 3-2. 페이징 -->
		<ul class="pagination justify-content-center">
			<li class="page-item">
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1" class="page-link"><<</a>
			</li>
			<li class="page-item">
			<%
				if(currentPage > 1){
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>" class="page-link"><</a>
			<%
				}
			%>
			</li>
			<li class="page-item">
				<a class="page-link"><%=currentPage%></a>
			</li>
			<li class="page-item">
			<%
				if(currentPage < lastPage){
			%>
					<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>" class="page-link">></a>
			<%
				}
			%>
			</li>
			<li class="page-item">
				<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" class="page-link">>></a>
			</li>
		</ul>
	</div>
	</body>
</html>