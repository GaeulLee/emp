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
			<table class="table table-borderless table-light rounded-3 shadow-sm p-4 mb-4 bg-white mt-5">
				<tr>
					<td>
						<h1>INDEX</h1>
					</td>
				</tr>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-outline-secondary btn-lg mb-1">부서 관리</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/emp/empList.jsp" class="btn btn-outline-secondary btn-lg mb-1">사원 관리</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="btn btn-outline-secondary btn-lg">연봉 관리</a>
					</td>
				</tr>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-outline-secondary btn-lg">게시물 관리</a>
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>