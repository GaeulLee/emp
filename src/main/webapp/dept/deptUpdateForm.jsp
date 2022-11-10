<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석
	String deptNo = request.getParameter("deptNo");
	if(deptNo == null){ // updateDeptForm.jsp를 주소창에 직접 호줄하면 입력값은 null이 됨
		response.sendRedirect(request.getContextPath()+"/dept/deptList.jsp");
		return;
	}
	
	System.out.println("deptNo--> " + deptNo);
	
	// 2. 요청처리
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("deptUpdateForm.jsp 드라이버 로딩 성공");
	
	// db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");

	// 쿼리문 입력
	String sql = "SELECT dept_name deptName FROM departments WHERE dept_no = ?;";
	PreparedStatement stmt = conn.prepareStatement(sql); // 쿼리문장을 실행시키는 객체
	stmt.setString(1, deptNo);
	ResultSet rs = stmt.executeQuery(); 
	
	Department dept = null;
	if(rs.next()){
		dept = new Department();
		dept.deptNo = deptNo;
		dept.deptName = rs.getString("deptName");
	}
	
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deptList</title>
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		<style>
			h1{
				height: 70px;
				line-height: 60px;
				background-color: lightgrey;
				text-align: center;"
			}
		</style>
	</head>
	<body>
		<div class="container w-25 mx-auto">
			<div class="clearfix">
				<h1 class="text-white rounded mt-1">EDIT DEPT LIST</h1>
			</div>
			<!-- msg파라메터 값이 있으면 출력 -->
			<%
				String msg = request.getParameter("msg");
				if(msg != null){
				%>
				<tr>
					<td colspan="2" class="text-primary"> &#10069;<%=msg%></td>
				</tr>
				<%
				}
			%>
			<form action="<%=request.getContextPath()%>/dept/deptUpdateAction.jsp" method="post">
				<table class="table table-borderless shadow-sm p-4 mb-4 bg-white">
					<tr>
						<th>부서번호</th>
						<td>
							<input type="text" value="<%=deptNo%>" name="deptNo" class="form-control" readonly="readonly" placeholder="d000(4자리)">
						</td>
					</tr>
					<tr>
						<th>부서이름</th>
						<td>
							<input type="text" value="<%=dept.deptName%>" name="deptName" class="form-control" placeholder="부서이름은 중복될 수 없습니다.">
						</td>
					<tr>	
					<tr>
						<td colspan="2">
							<button type="submit" class="btn btn-outline-primary float-end">EDIT</button>
							<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-outline-primary float-start">BACK</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>