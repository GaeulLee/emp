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
	
	// 2. 처리
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("deptList.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// lastpage 처리
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	
	int rowPerPage = 10;
	int count = 0;
	
	if(countRs.next()){
		count = countRs.getInt("COUNT(*)");
	}
	
	int lastPage = count / rowPerPage;
	if(count % rowPerPage != 0){
		lastPage++;
	}
	
	// 한 페이지 당 출력할 emp목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?,?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1));
	empStmt.setInt(2, rowPerPage);
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
	</head>
	<body>
	<div class="container">
		<!-- 메뉴는 파티션jsp로 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> <!-- jsp액션코드 -->
		</div>
		<!-- 본문 시작 -->
		<div class="tab-content">
			<div id="empList" class="container tab-pane active">
				<h1>사원목록</h1>
			
				<div>현재 페이지: <%=currentPage%></div>
				<table>
					<tr>
						<th>사원번호</th>
						<th>퍼스트네임</th>
						<th>라스트네임</th>
					</tr>
					<%
						for(Employee e : empList){
					%>
							<tr>
								<th><%=e.empNo%></th>
								<th><%=e.firstName%></th>
								<th><%=e.lastName%></th>
							</tr>
					<%
						}
					%>
				</table>
				<!-- 페이징 코드 -->
				<div>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1">처음</a>
					<%
						if(currentPage > 1){
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-1%>">이전</a>
					<%
						}
						
						if(currentPage < lastPage){
					%>
							<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+1%>">다음</a>
					<%
						}
					%>
					
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>">마지막</a>
				</div>
			</div>
		</div>
	</div>		
	</body>
</html>