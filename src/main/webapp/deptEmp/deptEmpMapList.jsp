<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.*"%>
<%
	// 1. 요청분석(페이지 값, 검색 값)
	//paging
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색 값 받아오기
	String word = request.getParameter("word");
	
	System.out.println("currentPage - "+currentPage+", word - "+word);
	
	// 2. 요청처리 -> dept_emp 테이블에서 외래키(dept_no과 emp_no을 참조하여 데이터 가져오기) 
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println(conn + "<-- db접속 완료");
	
	// 분기 (검색 값 유무)
	// 2-1. 분기에 따라 총 결과 행 수 구하기
	final int ROW_PER_PAGE = 20; // 한 페이지 당 보여줄 행 갯수 값
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // 페이지 당 행 시작 값
	int cnt = 0; // 총 결과 행 담을 변수
	String cntSql = null;
	PreparedStatement cntStmt = null;
	if(word == null){
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no";
		cntStmt = conn.prepareStatement(cntSql);
	} else {
		cntSql = "SELECT COUNT(*) cnt FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.last_name LIKE ? OR e.first_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
		cntStmt.setString(2, "%"+word+"%");
	}
	ResultSet cntRs = cntStmt.executeQuery();
	
	if(cntRs.next()){ // 쿼리 실행 후 cnt에 값 넣기
		cnt = cntRs.getInt("cnt");
	}
	System.out.println("cnt: "+cnt);
	
	// 페이징 위한 마지막 페이지(총 페이지 수) 구하기
	int lastPage = cnt / ROW_PER_PAGE;
	if(cnt / ROW_PER_PAGE != 0){
		lastPage++;
	}
	System.out.println("lastPage: "+lastPage);
	
	
	// 2-2. 분기에 따라 데이터 가져오기
	/*
		SELECT de.emp_no empNo,
				d.dept_name deptName
				de.from_date fromDate,
				de.to_date toDate,
				CONCAT(e.first_name, ' ',e.last_name) empName
		FROM dept_emp de INNER JOIN employees e
		ON de.emp_no = e.emp_no
			INNER JOIN departments d
			ON de.dept_no = d.dept_no
		LIMIT 0,20;
	*/
	String sql = null;
	PreparedStatement stmt = null;
	if(word == null){
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) empName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
	} else {
		sql = "SELECT de.emp_no empNo, d.dept_name deptName, de.from_date fromDate, de.to_date toDate, CONCAT(e.first_name, ' ', e.last_name) empName FROM dept_emp de INNER JOIN employees e ON de.emp_no = e.emp_no INNER JOIN departments d ON de.dept_no = d.dept_no WHERE e.last_name LIKE ? OR e.first_name LIKE ? LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+word+"%");
		stmt.setString(2, "%"+word+"%");
		stmt.setInt(3, beginRow);
		stmt.setInt(4, ROW_PER_PAGE);
	}
	ResultSet rs = stmt.executeQuery();

	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>(); // push와 get 이용
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo", rs.getInt("empNo"));
		m.put("empName", rs.getString("empName"));
		m.put("deptName", rs.getString("deptName"));
		m.put("fromDate", rs.getString("fromDate"));
		m.put("toDate", rs.getString("toDate"));
		list.add(m);
	}

	// 3. 요청출력
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deptEmpList</title>
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
			<!-- 헤더 -->
			<div class="h2 mt-2" id="header"><strong>부서별 사원 목록</strong></div>
			<!-- 검색 폼 -->
			<div class="clearfix float-end mb-1">
				<form action="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp" method="post">
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
			<!-- 본문 시작 -->
			<table class="table table-hover align-middle shadow-sm p-4 mb-4 bg-white">
				<tr class="table-primary">
					<th>사원번호</th>
					<th>이름</th>
					<th>부서</th>
					<th>입사일</th>
					<th>퇴사일</th>
				</tr>
				<%
					for(HashMap<String, Object> m : list){
				%>
						<tr>
							<td><%=m.get("empNo")%></td>
							<td><%=m.get("empName")%></td>
							<td><%=m.get("deptName")%></td>
							<td><%=m.get("fromDate")%></td>
							<td><%=m.get("toDate")%></td>
						</tr>
				<%
					}
				%>
			</table>
	
			<!-- 페이징 코드 -->
			<div>
			<%
				if(word == null){
			%>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1" class="page-link"><<</a>
					</li>
					<%
						if(currentPage > 1){
					%>
						<li class="page-item">
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>" class="page-link"><</a>
						</li>
					<%
						}
					%>
						<li class="page-item">
							<a class="page-link"><%=currentPage%></a>
						</li>
					<%
						if(currentPage < lastPage){
					%>
							<li class="page-item">
								<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>" class="page-link">></a>
							</li>
					<%
						}
					%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>" class="page-link">>></a>
					</li>
				</ul>
			<%
				} else {
			%>
				<ul class="pagination justify-content-center">
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=1&word=<%=word%>" class="page-link"><<</a>
					</li>
					<%
						if(currentPage > 1){
					%>
						<li class="page-item">
							<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="page-link"><</a>
						</li>
					<%
						}
					%>
						<li class="page-item">
							<a class="page-link"><%=currentPage%></a>
						</li>
					<%
						if(currentPage < lastPage){
					%>
							<li class="page-item">
								<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="page-link">></a>
							</li>
					<%
						}
					%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/deptEmp/deptEmpList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="page-link">>></a>
					</li>
				</ul>
			<%
				}
			%>
			</div>
		</div>
	</body>
</html>