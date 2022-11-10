<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
<%
	// 인코딩
	request.setCharacterEncoding("utf-8");

	// 1. 요청분석 + alpha (Controller)
	
	// 2. 요청처리(Model) -> 모델 데이터(단일값 or 자료구조: 배열, list 형태)
	
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("deptList.jsp 드라이버 로딩 성공");
	
	// db 접속
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/employees", "root", "java1234");
	System.out.println(conn + "<-- employees db 접속 확인");
	
	// 쿼리문 입력
	String sql = "SELECT dept_no deptNo, dept_name deptName FROM departments ORDER BY dept_no ASC;";
	PreparedStatement stmt = conn.prepareStatement(sql); // 쿼리문장을 실행시키는 객체
	
	// 결과 저장
	ResultSet rs = stmt.executeQuery(); 
	// 모델데이터로서 ResultSet는 일반적인 타입이 아님
	// -> ResultSet rs라는 모델자료구조를 일반적이고 독립적인 자료구조로 아래와 같이 변경
	ArrayList<Department> list = new ArrayList<Department>();
	while(rs.next()){
		Department d = new Department();
		d.deptNo = rs.getString("deptNo");
		d.deptName = rs.getString("deptName");
		list.add(d);
	}

	// while(rs.next()) 말고 (ResultSet의 API(사용방법)을 모른다면 사용할 수 없음)
	
	// 3. 요청출력(View) -> 모델 데이터를 고객이 원하는 데이터로 출력 -> 뷰(리포트)
	

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
		
		<!-- 본문 시작 -->
		<div class="h1 clearfix mt-2" id="header">부서 목록</div>
		<!-- 부서목록출력(부서번호 내림차순으로) -->
		<table class="table table-hover align-middle shadow-sm p-4 mb-4 bg-white">
			<tr class="table-primary">
				<th>부서번호</th>
				<th>부서이름</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
				<%
					for(Department d : list){
				%>
					<tr>
						<td><%=d.deptNo%></td>
						<td><%=d.deptName%></td>
						<td><a href="<%=request.getContextPath()%>/dept/deptUpdateForm.jsp?deptNo=<%=d.deptNo%>" class="btn btn-light">수정</a></td>
						<td><a href="<%=request.getContextPath()%>/dept/deptDelete.jsp?deptNo=<%=d.deptNo%>" class="btn btn-light">삭제</a></td>
					<tr>	
				<%
					}
				%>
		</table>
		<a href="<%=request.getContextPath()%>/dept/insertDeptForm.jsp" class="btn btn-outline-primary float-end" >부서 추가</a>
	</div>
	</body>
</html>