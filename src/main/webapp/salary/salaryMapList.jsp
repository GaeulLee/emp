<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%> <!-- hashMap<키, 값>, ArrayList<요소> -->
<%
	// 1. 요청분석
	//currentPage...(paging)
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 2. 요청처리
	//beginRow, rowPerPage(paging)
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage-1)*ROW_PER_PAGE;
	
	// db연결 -> 모델 생성
	// 매개변수에는 값을 직접적으로 넣는 것 보다 변수를 넣어주는 것이 좋음(유지보수 용이)
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/employees";
	String dbUser = "root";
	String dbPw = "java1234";
	
	Class.forName(driver); // 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw); // 커넥션을 가져옴(프로토콜://주소(ip형식 또는 도메인 형식):포트번호/db이름)
	/*
	SELECT 
		s.emp_no empNo,
		s.from_date fromDate,
		CONCAT(e.first_name, ' ', e.last_name) name  <- concat으로 e.first_name과 e,last_name을 합쳐줌(' '공백 추가)
	FROM salaries s INNER JOIN employees e 
	ON s.emp_no = e.emp_no 
	ORDER BY s.emp_no ASC 
	LIMIT ?, ?
	*/
	String sql = "SELECT s.emp_no empNo, s.salary salary, s.from_date fromDate, CONCAT(e.first_name, ' ', e.last_name) name FROM salaries s INNER JOIN employees e ON s.emp_no = e.emp_no ORDER BY s.emp_no ASC LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, beginRow);
	stmt.setInt(2, ROW_PER_PAGE);
	ResultSet rs = stmt.executeQuery();
	
	// 하나의 행을 하나의 맵으로 옮김 -> 여러 행이면? ArrayList로
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("empNo",rs.getInt("empNo"));
		m.put("salary",rs.getInt("salary"));
		m.put("fromDate",rs.getString("fromDate"));
		m.put("name",rs.getString("name"));
		list.add(m);
	}
	
	// 연결을 끊어줌(불필요한 메모리 제거) 역순으로
	rs.close();
	stmt.close();
	conn.close();
	
	// 3. 요청출력
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>salaryMapList</title>
	</head>
	<body>
		<h1>Salary List</h1>
		<table>
			<tr>
				<th>empNo</th>
				<th>name</th>
				<th>salary</th>
				<th>fromDate</th>				
			</tr>
			<%
				for(HashMap<String, Object> m : list){
			%>
					<tr>
						<td><%=m.get("empNo")%></td>
						<td><%=m.get("name")%></td>
						<td><%=m.get("salary")%></td>
						<td><%=m.get("fromDate")%></td>
					</tr>
			<%
				}
			%>
		</table>
	</body>
</html>