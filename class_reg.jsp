<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="DB.DBConnect"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String sql = "select c_no, c_name from tbl_member_202201";
	String sql2 = "select teacher_code, class_name from tbl_teacher_202201";
	Connection conn = DBConnect.getConnection();
	PreparedStatement pstmt = conn.prepareStatement(sql);
	PreparedStatement pstmt2 = conn.prepareStatement(sql2);
	ResultSet rs = pstmt.executeQuery();
	ResultSet rs2 = pstmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="css/style.css">
<script type="text/javascript">
	function chkVal() {
		var cls = document.classData;
		
		if(!cls.resist_month.value) {
			alert("수강월이 입력되지 않았습니다!");
			cls.resist_month.focus();
			return false;
		}
		if(cls.c_name.value=="none") {
			alert("회원명이 선택되지 않았습니다!");
			cls.c_name.focus();
			return false;
		}
		if(!cls.class_area.value) {
			alert("강의장소가 입력되지 않았습니다!");
			cls.class_area.focus();
			return false;
		}
		if(cls.class_name.value=="none") {
			alert("강의명이 선택되지 않았습니다!");
			cls.class_name.focus();
			return false;
		}
	}
	function vDisplay(code) {
		document.classData.c_no.value = code;
		document.classData.class_name.value = "none";
		document.classData.tuition.value = "";
	}
	function calTuition(tcode) {
		var mbr = document.classData.c_no.value;
		if(!mbr) {
			alert("회원명을 먼저 선택하세요.");
			document.classData.class_name[0].selected = true;
			document.classData.c_name.focus();
		} else {
			
			var salePrice = 0;
			switch (tcode) {
				case "100":
					salePrice = 100000;
					break;
				case "200":
					salePrice = 200000;
					break;
				case "300":
					salePrice = 300000;
					break;
				case "400":
					salePrice = 400000;
					break;
			}
			
			if(mbr.charAt(0)=='2') {
				alert("수강료가 50% 할인 되었습니다.");
				salePrice = salePrice / 2;
			}
			
			document.classData.tuition.value = salePrice;
		}
	}
</script>
</head>
<body>

	<header>
		<jsp:include page="layout/header.jsp"></jsp:include>
	</header>
	
	<nav>
		<jsp:include page="layout/nav.jsp"></jsp:include>
	</nav>

	<section id="section">
		<h2>투표 하기</h2>

		<form name="classData" action="class_reg_p.jsp" method="post" onsubmit="return chkVal()">
			<table class="inputTable">
				<tr>
					<th>수강월</th>
					<td><input type="text" name="resist_month" size="20"><span> 2022년03월 예)202203</span></td>
				</tr>
				<tr>
					<th>회원명</th>
					<td>
						<select name="c_name" onchange="vDisplay(this.value)">
							<option value="none">회원명</option>
							<%
							while (rs.next()) {
							%>
			<option value="<%=rs.getString("c_no")%>"><%=rs.getString("c_name")%></option>
							<%
							}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>회원번호</th>
					<td><input type="text" name="c_no" size="20" readonly><span>예)10001</span></td>
				</tr>
				<tr>
					<th>강의장소</th>
					<td><input type="text" name="class_area" size="20"></td>
				</tr>
				<tr>
					<th>강의명</th>
					<td>
					<select name="class_name" onchange="calTuition(this.value)">
						<option value="none">강의신청</option>
							<%
							while (rs2.next()) {
							%>
	<option value="<%=rs2.getString("teacher_code")%>"><%=rs2.getString("class_name")%></option>
							<%
							}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<th>수강료</th>
					<td><input type="text" name="tuition" size="20" readonly></td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="submit" value="수강신청">
						<input type="reset" value="다시쓰기">
					</td>
				</tr>
			</table>
		</form>
	</section>

	<footer>
		<jsp:include page="layout/footer.jsp"></jsp:include>
	</footer>
</body>
</html>
