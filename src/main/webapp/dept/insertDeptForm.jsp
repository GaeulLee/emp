<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
				<h1 class="text-white rounded mt-1">ADD DEPT LIST</h1>
			</div>
			<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
				<table class="table table-borderless shadow-sm p-4 mb-4 bg-white">
					<tr>
						<th>부서번호</th>
						<td>
							<input type="text" name="deptNo" class="form-control" placeholder="d000(4자리)">
						</td>
					</tr>
					<tr>
						<th>부서이름</th>
						<td>
							<input type="text" name="deptName" class="form-control" placeholder="부서이름은 중복될 수 없습니다.">
						</td>
					<tr>	
					<tr>
						<td colspan="2">
							<button type="submit" class="btn btn-outline-primary float-end">ADD</button>
							<a href="<%=request.getContextPath()%>/dept/deptUpdateAction.jsp" class="btn btn-outline-primary float-start">BACK</a>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</body>
</html>