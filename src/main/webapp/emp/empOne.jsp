<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.Employee" %>
<%@ page import="java.util.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	
	if(request.getParameter("empNo") == null){ // empNo값이 없다면 사원 목록 페이지로 다시 돌아가게
		response.sendRedirect(request.getContextPath()+"/emp.empList.jsp");
		return;
	}
	
	// 2. 요청처리
	// n번의 empNo에 해당하는 사원의 이름을 눌렀을 때 해당 사원의 상세정보가 보이도록
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("empOne.jsp 드라이버 로딩 성공");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	String sql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender, hire_date hireDate FROM employees WHERE emp_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, empNo);
	ResultSet rs = stmt.executeQuery();
	
	ArrayList<Employee> empList = new ArrayList<Employee>();
	Employee e = new Employee();
	if(rs.next()){
		e.empNo = rs.getInt("empNo");
		e.birthDate = rs.getString("birthDate");
		e.firstName = rs.getString("firstName");
		e.lastName = rs.getString("lastName");
		e.gender = rs.getString("gender");
		e.hireDate =  rs.getString("hireDate");
	}
	
	
	// 3. 요청출력
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>empOne</title>
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
			<div class="rounded mt-1 h4 text-white w-50 mx-auto" id="title"><%=e.firstName+" "+e.lastName%> 상세보기</div>
			<table class="table table-borderless shadow-sm p-4 mb-4 bg-white align-middle w-50 mx-auto">
				<tr>
					<th class="w-25">사원번호</th>
					<td><%=e.empNo%></td>
				</tr>
				<tr class="h-50">
					<th class="w-25">생일</th>
					<td><%=e.birthDate%></td>
				</tr>
				<tr>
					<th class="w-25">이름</th>
					<td><%=e.firstName+" "+e.lastName%></td>
				</tr>
				<tr>
					<th class="w-25">성별</th>
					<td><%=e.gender%></td>
				</tr>
				<tr>
					<th class="w-25">입사일</th>
					<td><%=e.hireDate%></td>
				</tr>
				<tr>
					<td colspan="2">
						<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="btn btn-outline-primary float-start">BACK</a>
						<a href="<%=request.getContextPath()%>/emp/deleteEmpForm.jsp?empNo=<%=e.empNo%>" class="btn btn-light float-end">삭제</a>
						<a href="<%=request.getContextPath()%>/emp/updateEmpForm.jsp?empNo=<%=e.empNo%>" class="btn btn-light float-end me-2">수정</a>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>