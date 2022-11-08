<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index</title>
		<!-- Latest compiled and minified CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Latest compiled JavaScript -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"></script>
		</head>
	<body>
		<div class="container">
			<h1>INDEX</h1>
			<ol class="nav nav-pills nav-justified">
				<li class="nav-item">
					<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="nav-link active">부서 관리</a>
				</li>
			</ol>
		</div>
	</body>
</html>