<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("deptList.jsp 드라이버 로딩 성공");
	
	// db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// 쿼리문 입력
	String sql = "select dept_no deptNo, dept_name deptName from departments ORDER BY dept_no ASC;";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// 결과 저장
	ResultSet rs = stmt.executeQuery();
	
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deptList</title>
</head>
<body>
	<h1>DEPT LIST</h1>
	<div>
		<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp">부서 추가</a>
	</div>
	<div>
		<!-- 부서목록출력(부서번호 내림차순으로) -->
		<table>
			<tr>
				<th>부서번호</th>
				<th>부서이름</th>
			</tr>
				<%
					while(rs.next()){
				%>
					<tr>
						<td><%=rs.getString("deptNo")%></td>
						<td><%=rs.getString("deptName")%></td>
					<tr>	
				<%
					}
				%>
		</table>
	</div>
</body>
</html>