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
	System.out.println("empList.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// lastpage 처리
	String countSql = "SELECT COUNT(*) FROM employees";
	PreparedStatement countStmt = conn.prepareStatement(countSql);
	ResultSet countRs = countStmt.executeQuery();
	// 페이지 당 목록 갯수와 count 변수 생성
	int rowPerPage = 10;
	int count = 0;
	// count에 쿼리문 결과값 넣기
	if(countRs.next()){
		count = countRs.getInt("COUNT(*)");
	}
	// 페이지 개수 계산
	int lastPage = count / rowPerPage; // 300,024
	if(count % rowPerPage != 0){
		lastPage++;
	}
	
	// 한 페이지 당 출력할 emp목록
	String empSql = "SELECT emp_no empNo, first_name firstName, last_name lastName FROM employees ORDER BY emp_no ASC LIMIT ?,?";
	PreparedStatement empStmt = conn.prepareStatement(empSql);
	empStmt.setInt(1, rowPerPage * (currentPage - 1)); // ex) 10 * (1 - 1)
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
		<div class="h1 clearfix mt-2" id="header">사원 목록</div>
		<table class="table table-hover align-middle shadow-sm p-4 mb-4 bg-white">
			<tr class="table-primary">
				<th>사원번호</th>
				<th>이름</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			<%
				for(Employee e : empList){
			%>
					<tr>
						<td><%=e.empNo%></td>
						<!-- 이름을 누르면 상세정보 나오게 -->
						<td><a href=""><%=e.firstName+" "+e.lastName%></a></td>
						<td><a href="<%=request.getContextPath()%>/dept/deptUpdateForm.jsp?emptNo=<%=e.empNo%>" class="btn btn-light">수정</a></td>
						<td><a href="<%=request.getContextPath()%>/dept/deptDelete.jsp?emptNo=<%=e.empNo%>" class="btn btn-light">삭제</a></td>
					</tr>
			<%
				}
			%>
		</table>
		<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="btn btn-outline-primary float-end" >사원 추가</a>
		<div>현재 페이지 수: <%=currentPage%></div>
		<!-- 페이징 코드 -->
		<ul class="pagination justify-content-center">
			<li class="page-item">
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=1" class="page-link"><<</a>
			</li>
			<%
				if(currentPage > 10){
			%>
				<li class="page-item">
					<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage-10%>" class="page-link"><</a>
				</li>
			<%
				}
			
				for(int i=currentPage; i<currentPage+rowPerPage; i++){
					
			%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=i%>" class="page-link"><%=i%></a>
					</li>
			<%
				}
				
				if(currentPage+10 < lastPage){
			%>
					<li class="page-item">
						<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=currentPage+10%>" class="page-link">></a>
					</li>
			<%
				}
			%>
			<li class="page-item">
				<a href="<%=request.getContextPath()%>/emp/empList.jsp?currentPage=<%=lastPage%>" class="page-link">>></a>
			</li>
		</ul>
	</div>
	</body>
</html>