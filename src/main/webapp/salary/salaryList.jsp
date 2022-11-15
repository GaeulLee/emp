<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1.요청분석(페이지 값, 검색 값 받아오기)
	// 페이지 값
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){ // 페이지 값이 넘어온다면 현재 페이지 값을 받아온 값으로 바꿔주기
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 검색 값
	String word = request.getParameter("word");
	
	
	// 분기(검색 값이 있을 때와 없을 때)
	// 2. 요청처리(페이지 당 글 갯수 만큼 db에서 불러오기)
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees", "root", "java1234");
	
	// 2-1. 페이지 처리
	final int ROW_PER_PAGE = 10; // 페이지 당 행(글) 갯수
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // 출력 시작 행
	int cnt = 0; // 총 행의 갯수
	final int PAGE_COUNT = 10; // 한 페이지 당 보여줄 페이지 목록 수
	int beginPage = (currentPage-1)/PAGE_COUNT*PAGE_COUNT+1; //페이지 목록 시작 값
	int endPage = beginPage+PAGE_COUNT-1; // 페이지 목록 끝 값
	
	String cntSql = null;
	PreparedStatement cntStmt = null;
	
	// 마지막 글 번호(총 행의 갯수) 구하기
	if(word == null){
		cntSql = "SELECT COUNT(*) cnt FROM salaries";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? or e.last_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
	}
	ResultSet cntRs = cntStmt.executeQuery();
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	// 마지막 페이지 수 구하기
	int lastPage = cnt / ROW_PER_PAGE;
	if(cnt/ROW_PER_PAGE != 0){
		lastPage++;
	}
	
	if(endPage > lastPage){ // 페이지 목록이 lastPage까지만 보이도록
		endPage = lastPage;
	}
		
	/*
	SELECT s.emp_no empNo
		, s.salary salary
		, s.from_date fromDate
		, s.to_date toDate
		
		, e.first_name firstName 
		, e.last_name lastName
	FROM salaries s INNER JOIN employees e  # 테이블 두개를 합칠때 : 테이블1 JOIN 테이블2 ON 합치는 조건식 
	ON s.emp_no = e.emp_no
	LIMIT ?, ?
	*/
	// 2-2. 테이블 합치고 출력 내용 내보내기
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null){
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
	} else {
		sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, s.to_date toDate, e.first_name firstName, e.last_name lastName FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no WHERE e.first_name LIKE ? OR e.last_name LIKE ? ORDER BY s.emp_no ASC LIMIT ?,?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, ROW_PER_PAGE);
	}
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Salary> salaryList = new ArrayList<>();
	while(rs.next()) {
		Salary s = new Salary();
		s.emp = new Employee(); // ☆☆☆☆☆
		s.emp.empNo = rs.getInt("empNo");
		s.salary = rs.getInt("salary");
		s.fromDate = rs.getString("fromDate");
		s.toDate = rs.getString("toDate");
		s.emp.firstName = rs.getString("firstName");
		s.emp.lastName = rs.getString("lastName");
		salaryList.add(s);
	}
	
	// 3. 요청출력
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>salaryList</title>
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
		<!-- 메뉴는 파티션jsp로 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
		</div>
		
		<div class="container">
			<!-- 본문 시작 -->
			<div class="h2 mt-2" id="header"><strong>급여 목록</strong></div>
			
			<!-- 검색 폼 -->
			<div class="clearfix float-end mb-1">
				<form action="<%=request.getContextPath()%>/salary/salaryList.jsp" method="post">
					<label>
					<%
						if(word == null){
					%>
							<input type="text" name="word" class="form-control" placeholder="사원 검색">
					<%
						} else {
					%>
							<input type="text" name="word" value="<%=word%>" class="form-control" placeholder="사원 검색">
					<%
						}
					%>
						
					</label>
					<button type="submit" class="btn btn-outline-primary">Search</button>
				</form>
			</div>
			
			<table class="table table-hover align-middle shadow-sm p-4 mb-4 bg-white">
				<tr class="table-primary">
					<th>사원번호</th>
					<th>이름</th>
					<th>연봉($)</th>
					<th>입사일</th>
					<th>퇴사일</th>
				</tr>
				<%
					for(Salary s : salaryList){
				%>
						<tr>
							<td><%=s.emp.empNo%></td>
							<td><%=s.emp.firstName+" "+s.emp.lastName%></td>
							<td><%=s.salary%></td>
							<td><%=s.fromDate%></td>
							<td><%=s.toDate%></td>
						</tr>
				<%
					}
				%>
			</table>
			<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="btn btn-outline-primary" >사원 추가</a>
	
			<!-- 페이징 코드 -->
			<div>
			<%
				if(word == null){
			%>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1" class="page-link"><<</a>
					</li>
					<%
						if(currentPage > PAGE_COUNT){
					%>
						<li class="page-item">
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>" class="page-link"><</a>
						</li>
					<%
						}

						for(int i=beginPage; i<=endPage; i++){
							if(currentPage == i){
							%>
								<li class="page-item active">
									<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=i%>" class="page-link"><%=i%></a>
								</li>
							<%
							} else {
							%>
								<li class="page-item">
									<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=i%>" class="page-link"><%=i%></a>
								</li>
							<%
							}
						}
					
						if(currentPage < lastPage){
						%>
							<li class="page-item">
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>" class="page-link">></a>
							</li>
						<%
						}
					%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>" class="page-link">>></a>
					</li>
				</ul>
			<%
				} else {
			%>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=1" class="page-link"><<</a>
					</li>
					<%
						if(currentPage > PAGE_COUNT){
					%>
						<li class="page-item">
							<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="page-link"><</a>
						</li>
					<%
						}

						for(int i=beginPage; i<=endPage; i++){
							if(currentPage == i){
							%>
								<li class="page-item active">
									<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=i%>&word=<%=word%>" class="page-link"><%=i%></a>
								</li>
							<%
							} else {
							%>
								<li class="page-item">
									<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=i%>&word=<%=word%>" class="page-link"><%=i%></a>
								</li>
							<%
							}
						}
					
						if(currentPage < lastPage){
						%>
							<li class="page-item">
								<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="page-link">></a>
							</li>
						<%
						}
					%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/salary/salaryList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="page-link">>></a>
					</li>
				</ul>
			<%
				}
			%>
			</div>
		</div>
		</div>
	</body>
</html>