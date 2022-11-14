<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%@ page import="java.util.ArrayList"%>
<%
	// 1. 분석
	// 페이지 알고리즘
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 검색 값 받아오기
	String word = request.getParameter("word");
	
	// 2. 처리
	// 분기 1) 검색 값이 있을 때, 2) 검색 값이 없을 때
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("empList.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// 전체 행 갯수 구하기
	String cntSql = null;
	PreparedStatement cntStmt = null;
	String empSql = null;
	PreparedStatement empStmt = null;
	int rowPerPage = 10;
	int cnt = 0;
	
	if(word == null){ // 검색 값이 없다면 전체 행 구하기
		cntSql = "SELECT COUNT(*) cnt FROM employees";
		cntStmt = conn.prepareStatement(cntSql);
	} else { // 검색 값이 있다면 해당 행 갯수만 구하기
		cntSql = "SELECT COUNT(*) cnt FROM employees WHERE first_name LIKE ?";
		cntStmt = conn.prepareStatement(cntSql);
		cntStmt.setString(1, "%"+word+"%");
	}
	ResultSet cntRs = cntStmt.executeQuery();
	
	// cnt에 쿼리문 결과값 넣기
	if(cntRs.next()){
		cnt = cntRs.getInt("cnt");
	}
	// 페이지 개수 계산
	int lastPage = cnt / rowPerPage; // 300,024
	if(cnt % rowPerPage != 0){
		lastPage++;
	}
	
	// 한 페이지 당 출력할 emp목록
	if(word == null){ // 검색 값 없으면
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?,?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setInt(1, rowPerPage * (currentPage - 1)); // ex) 10 * (1 - 1)
		empStmt.setInt(2, rowPerPage);
	} else { // 검색 값 있으면
		empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees WHERE first_name LIKE ? ORDER BY emp_no ASC LIMIT ?,?";
		empStmt = conn.prepareStatement(empSql);
		empStmt.setString(1, "%"+word+"%");
		empStmt.setInt(2, rowPerPage * (currentPage - 1)); // ex) 10 * (1 - 1)
		empStmt.setInt(3, rowPerPage);
	}
	ResultSet empRs = empStmt.executeQuery();

	ArrayList<Employee> empList = new ArrayList<Employee>();
	while(empRs.next()){
	    Employee e = new Employee();
	    e.empNo = empRs.getInt("empNo");
	    e.firstName = empRs.getString("firstName");
	    e.lastName = empRs.getString("lastName");
	    empList.add(e);
	 }
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>empList</title>
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
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
		</div>
		
		<!-- 본문 시작 -->
		<div class="h2 mt-2" id="header"><strong>사원 목록</strong></div>
		
		<!-- 검색 폼 -->
		<div class="clearfix float-end mb-1">
			<form action="<%=request.getContextPath()%>/emp/empList.jsp" method="post">
				<label>
				<%
					if(word == null){
				%>
						<input type="text" name="word" class="form-control" placeholder="사원 검색 (first name)">
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
				<th class="w-25">사원번호</th>
				<th>이름</th>
			</tr>
			<%
				for(Employee e : empList){
			%>
					<tr>
						<td><%=e.empNo%></td>
						<!-- 이름을 누르면 상세정보 나오게 -->
						<td><a href="<%=request.getContextPath()%>/emp/empOne.jsp?empNo=<%=e.empNo%>" class="text-muted"><%=e.firstName+" "+e.lastName%></a></td>
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
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1" class="page-link"><<</a>
				</li>
				<%
					if(currentPage > 1){
				%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>" class="page-link"><</a>
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
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>" class="page-link">></a>
						</li>
				<%
					}
				%>
				<li class="page-item">
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>" class="page-link">>></a>
				</li>
			</ul>
		<%
			} else {
		%>
			<ul class="pagination justify-content-center">
				<li class="page-item">
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1&word=<%=word%>" class="page-link"><<</a>
				</li>
				<%
					if(currentPage > 1){
				%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>&word=<%=word%>" class="page-link"><</a>
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
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>&word=<%=word%>" class="page-link">></a>
						</li>
				<%
					}
				%>
				<li class="page-item">
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>&word=<%=word%>" class="page-link">>></a>
				</li>
			</ul>
		<%
			}
		%>
		</div>
	</div>
	</body>
</html>