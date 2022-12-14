<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>
<%
	
	//인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	
	// 현재 페이지 구하기
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 검색 값 받아오기
	String word = request.getParameter("word");
	
	
	// 2. 요청처리 후 필요하다면 모델데이터 생성
	
	// 페이지 당 게시글 수, 시작 행 구하기
	final int ROW_PER_PAGE = 10; //  final: 변수 값을 바꿀 수 없게 해줌 + 대문자로 적음(띄어쓰기는 _ 로)
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // ...LIMIT beginRow, ROW_PER_PAGE
	int cnt = 0; // 전체 행의 수
	final int PAGE_COUNT = 10; // 한 페이지 당 보여줄 페이지 목록 수
	int beginPage = (currentPage-1)/PAGE_COUNT*PAGE_COUNT+1; //페이지 목록 시작 값
	int endPage = beginPage+PAGE_COUNT-1; // 페이지 목록 끝 값
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("boardList.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// 분기 -> 1) 검색 값이 있을 때 2) 검색 값이 없을 때 3) 검색결과에서 다음페이지로 넘어갈 때
	String cntSql = null;
	String listSql = null;
	PreparedStatement cntStmt = null;
	PreparedStatement listStmt = null;
	
	// 분기에 따라 게시물 행의 수 구하기
	if(word == null || word.equals("")){ // 검색 값이 없으면 전체 목록 행 수
		cntSql = "SELECT COUNT(*) cnt FROM board;";
		cntStmt = conn.prepareStatement(cntSql);
	} else { // 검색 값이 있으면 검색 결과 행 수
		cntSql = "SELECT COUNT(*) cnt FROM board WHERE board_content LIKE ?;";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}
	
	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	// 마지막 페이지 구하기
	// 올림을 하게 되면 5.3 -> 6.0
	int lastPage = (int)(Math.ceil((double)cnt / (double)ROW_PER_PAGE));
	
	if(endPage > lastPage){ // 페이지 목록이 lastPage까지만 보이도록
		endPage = lastPage;
	}

	// 분기에 따라 페이지당 게시물과 전체 게시물 수로 게시물 불러오기
	if(word == null || word.equals("")){ // 전체 목록
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter, createdate FROM board ORDER BY board_no DESC LIMIT ?,?;";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setInt(1, beginRow);
		listStmt.setInt(2, ROW_PER_PAGE);
	} else { // 검색 결과 목록
		listSql = "SELECT board_no boardNo, board_title boardTitle, board_writer boardWriter, createdate FROM board WHERE board_content LIKE ? ORDER BY board_no DESC LIMIT ?,?;";
		listStmt = conn.prepareStatement(listSql);
		listStmt.setString(1, "%"+word+"%");
		listStmt.setInt(2, beginRow);
		listStmt.setInt(3, ROW_PER_PAGE);
	}
	
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
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/combine/npm/bootswatch@5/dist/minty/bootstrap.min.css,npm/bootswatch@5/dist/minty/bootstrap.min.css">
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
		<!-- 메뉴는 파티션jsp로 구성 -->
		<div>
			<jsp:include page="../inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
		</div>
		<div class="container">
			<!-- 본문시작 -->
			<div class="h2 mt-2" id="header"><strong>자유게시판</strong></div>
			
			<!-- 검색 폼 -->
			<div class="clearfix float-end mb-1">
				<form action="<%=request.getContextPath()%>/board/boardList.jsp" method="post">
					<label>
					<%
						// 검색 창에 null 값이 표시되지 않도록
						if(word != null){
					%>
							<input type="text" name="word" class="form-control" value="<%=word%>" placeholder="글 내용 검색">
					<%	
						} else {
					%>
							<input type="text" name="word" class="form-control" placeholder="글 내용 검색">
					<%
						}
					%>
					</label>
					<button type="submit" class="btn btn-outline-primary">Search</button>
				</form>
			</div>
			
			<!-- 3-1. 모델 데이터 어레이리스트 출력 -->
			<table class="table table-hover align-middle shadow-sm p-4 mb-4 bg-white">
				<tr class="table-primary">
					<th>게시물 번호</th>
					<th class="w-50">제목</th>
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
			<a href="<%=request.getContextPath()%>/board/insertboardForm.jsp" class="btn btn-outline-primary" >새 게시글 작성</a>
			
			<!-- 페이징 코드 -->
			<div>
			<%
				if(word == null){
			%>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1" class="page-link"><<</a>
					</li>
					<%
						if(currentPage > PAGE_COUNT){
					%>
						<li class="page-item">
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>" class="page-link"><</a>
						</li>
					<%
						}

						for(int i=beginPage; i<=endPage; i++){
							if(currentPage == i){
							%>
								<li class="page-item active">
									<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=i%>" class="page-link"><%=i%></a>
								</li>
							<%
							} else {
							%>
								<li class="page-item">
									<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=i%>" class="page-link"><%=i%></a>
								</li>
							<%
							}
						}
					
						if(currentPage < lastPage){
						%>
							<li class="page-item">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>" class="page-link">></a>
							</li>
						<%
						}
					%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>" class="page-link">>></a>
					</li>
				</ul>
			<%
				} else {
			%>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=1" class="page-link"><<</a>
					</li>
					<%
						if(currentPage > PAGE_COUNT){
					%>
						<li class="page-item">
							<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="page-link"><</a>
						</li>
					<%
						}

						for(int i=beginPage; i<=endPage; i++){
							if(currentPage == i){
							%>
								<li class="page-item active">
									<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=i%>&word=<%=word%>" class="page-link"><%=i%></a>
								</li>
							<%
							} else {
							%>
								<li class="page-item">
									<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=i%>&word=<%=word%>" class="page-link"><%=i%></a>
								</li>
							<%
							}
						}
					
						if(currentPage < lastPage){
						%>
							<li class="page-item">
								<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="page-link">></a>
							</li>
						<%
						}
					%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/board/boardList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="page-link">>></a>
					</li>
				</ul>
			<%
				}
			%>
			</div>
		</div>
	</body>
</html>