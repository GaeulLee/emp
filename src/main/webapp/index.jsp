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
		<style>
			*{
				text-align: center;
				list-style: none;
			}
		</style>
		</head>
	<body>
		<div class="container w-25">
			<!-- 메뉴는 파티션jsp로 구성 -->
			<h1>INDEX</h1>
			<ol class="ps-0">
				<li>
					<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-outline-secondary btn-lg mb-1">부서 관리</a>
				</li>
				<li>
					<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="btn btn-outline-secondary btn-lg mb-1">사원 관리</a>
				</li>
				<li>
					<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-outline-secondary btn-lg">연봉 관리</a>
				</li>
			</ol>
		</div>
	</body>
</html>