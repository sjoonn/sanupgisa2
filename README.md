# <div align="center"> 산업기사 준비2</div>

## <div align="center"> 데이터 베이스(oracle) </div>

### <div align="center"> 선생님 테이블 </div>
```c 
  create table tbl_teacher_202201(
  teacher_code char(3) not null,
  teacher_name varchar2(15),
  class_name varchar2(20),
  class_price varchar2(8),
  teach_resist_date varchar2(8),
  primary key(teacher_code));


  insert into tbl_teacher_202201 values('100','이초급','초급반',100000,'20220101');
  insert into tbl_teacher_202201 values('200','김중급','중급반',200000,'20220102');
  insert into tbl_teacher_202201 values('300','박고급','고급반',300000,'20220103');
  insert into tbl_teacher_202201 values('400','정심화','심화반',400000,'20220104');
```
 
### <div align="center"> 멤버 테이블 </div>
```c 
  create table tbl_member_202201(
  c_no char(5) not null,
  c_name varchar2(15),
  phone varchar2(11),
  address varchar2(50),
  grade varchar2(6),
  primary key(c_no));
  
  insert into tbl_member_202201 values('10001','홍길동','01011112222','서울시 강남구','일반');
  insert into tbl_member_202201 values('10002','장발장','01022223333','성남시 분당구','일반');
  insert into tbl_member_202201 values('10003','임꺽정','01033334444','대전시 유성구','일반');
  insert into tbl_member_202201 values('20001','성춘향','01044445555','부산시 서구','VIP');
  insert into tbl_member_202201 values('20002','이몽룡','01055556666','대구시 북구','VIP');
```
### <div align="center"> 클래스 테이블 </div>
```c
  create table tbl_class_202201 (
  resist_month varchar2(6) not null,
  c_no char(5) not null,
  class_area varchar2(15),
  tuition number(8),
  teacher_code char(3),
  primary key(resist_month,c_no));
  
  insert into tbl_class_202201 values('202203','10001','서울본원',100000,'100');
  insert into tbl_class_202201 values('202203','10002','성남분원',100000,'100');
  insert into tbl_class_202201 values('202203','10003','대전분원',200000,'200');
  insert into tbl_class_202201 values('202203','20001','부산분원',150000,'300');
  insert into tbl_class_202201 values('202203','20002','대구분원',200000,'400');
```
## <div align="center"> index 페이지 </div>

![image](https://user-images.githubusercontent.com/102125786/207217417-04f5abfe-91ef-4b6d-90d7-fc3707126a6e.png)

## <div align="center"> teacher_list 페이지 </div>

### <div align="center"> 기본화면 </div>
![image](https://user-images.githubusercontent.com/102125786/207217308-b738529e-628f-441e-96cc-6d5edfa01098.png)

### <div align="center"> 강사 조회 코드 </div>

```jsp
    <%
	  StringBuffer sb = new StringBuffer();
	  sb.append("select teacher_code, teacher_name, class_name,"); // 강사 코드, 강사 이름, 강의명 조회
	  sb.append(" '￦'||to_char(class_price, '999,999') class_price,"); // 쌍 파이프로 글자를 붙여준다. to_char로 콤마 찍어주기.
	  sb.append(" substr(teach_resist_date,1,4)||'년'||substr(teach_resist_date,5,2)||'월'||substr(teach_resist_date,7,2)||'일' teach_resist_date"); //substr로 년도 월 일 을 끊어주고 쌍파이프로 글자를 붙여준다. 
	  sb.append(" from tbl_teacher_202201"); 
	
	  String sql = sb.toString();
	
	  Connection conn = DBConnect.getConnection();
	  PreparedStatement pstmt = conn.prepareStatement(sql);
	  ResultSet rs = pstmt.executeQuery();
    %>
```


### <div align="center"> 강사 조회값 받아오는 코드 </div>

```jsp
    <%
      while(rs.next()) { // rs에 값이 없을 때 까지 반복하면서 테이블 생성.
    %>
      <tr>
        <td><%=rs.getString(1) %></td>
        <td><%=rs.getString(2) %></td>
        <td><%=rs.getString(3) %></td>
        <td><%=rs.getString(4) %></td>
        <td><%=rs.getString(5) %></td>
      </tr>
    <%
       }
    %>
```

## <div align="center"> class_reg 페이지 </div>

### <div align="center"> 기본화면 </div>
![image](https://user-images.githubusercontent.com/102125786/207217697-59dcdee8-5cda-4834-bc42-be591a9a9932.png)

### <div align="center"> 유효성 검사 </div>

```javascript
function chkVal() {
	var cls = document.classData; // form 이름이 classData
		
	if(!cls.resist_month.value) { 
		alert("수강월이 입력되지 않았습니다!");
		cls.resist_month.focus();
		return false;
	}
	if(!cls.c_name.value) {
		alert("회원명이 선택되지 않았습니다!");
		cls.c_name.focus();
		return false;
	}
	if(!cls.class_area.value) {
		alert("강의장소가 입력되지 않았습니다!");
		cls.class_area.focus();
		return false;
	}
	if(!cls.class_name.value) {
		alert("강의명이 선택되지 않았습니다!");
		cls.class_name.focus();
		return false;
	}
}
```

### <div align="center"> 이름을 누르면 회원번호 자동생성 </div>

![image](https://user-images.githubusercontent.com/102125786/207747517-bbee54c0-34f2-4f6c-b8ee-59d562236701.png) ![image](https://user-images.githubusercontent.com/102125786/207747697-e7fd6e00-95df-488b-8f4a-11a38d653928.png)

### <div align="center"> 수강신청 페이지의 SQL문 </div>

```jsp
<%
	String sql = "select c_no, c_name from tbl_member_202201";
	String sql2 = "select teacher_code, class_name from tbl_teacher_202201";
	Connection conn = DBConnect.getConnection();
	PreparedStatement pstmt = conn.prepareStatement(sql);
	PreparedStatement pstmt2 = conn.prepareStatement(sql2);
	ResultSet rs = pstmt.executeQuery();
	ResultSet rs2 = pstmt2.executeQuery();
%>
```

### <div align="center"> 회원코드 찍어주는 코드 및 초기화 코드 </div>

```javascript
function vDisplay(code) { // 회원명 선택 시 회원 코드 값을 value로 받아옴 
	document.classData.c_no.value = code; // 회원 코드값을 실제 테이블에 찍어줌.
	document.classData.class_name.value = "none"; // 강의명을 none으로 초기화 
	document.classData.tuition.value = ""; // 수강료를 초기화
}
```

### <div align="center"> body의 회원명 </div>

```jsp
<tr>
	<th>회원명</th>
	<td><select name="c_name" onchange="vDisplay(this.value)"> <!-- 테이블 한칸에 select + option 으로 콤보 박스(선택 박스)를 만들고 value 값을 들고  vDisplay 코드를 호출한다. -->
		<option value="none">회원명</option>
	<%
	while (rs.next()) { // 값이 없을때 까지 무한 반복
	%>
		<option value="<%=rs.getString("c_no")%>"><%=rs.getString("c_name")%></option> <!-- c_name으로 선택박스가 생성되고 누르면 value값에 회원명의 회원 코드가 들어간다. -->
	<%
	}
	%>
	</select></td>
</tr>
```

### <div align="center"> 강의명을 누르면 수강료 자동 생성</div>

![image](https://user-images.githubusercontent.com/102125786/207751204-eb1dc53c-295e-41f4-be7f-4aa8135d120e.png) ![image](https://user-images.githubusercontent.com/102125786/207751269-9dffccf0-0871-4328-bc01-b9aa0ae05723.png)

### <div align="center"> 수강료를 생성해주는 코드 및 유효성 검사 및 할인값 </div>

```javascript
function calTuition(tcode) { // 선생님 코드값을 value로 받아옴
	var mbr = document.classData.c_no.value; // 회원 번호값이 mbr
	if(!mbr) { // 회원번호가 입력되어 있지 않다면 
		alert("회원명을 먼저 선택하세요."); // 알림창으로 회원명을 입력하라고 알려준다.
		document.classData.class_name[0].selected = true; // 
		document.classData.c_name.focus(); // 회원명의 focus가 간다.
	} else {
		var salePrice = 0; // salePrice라는 변수 생성
		switch (tcode) { // 선생님 코드로 switc + case 문
			case "100": 
				salePrice = 100000; // 100 이면 100000로 salePrice에저장
				break; // 멈춤
			case "200":
				salePrice = 200000; // 200 이면 200000로 salePrice에저장
				break; // 멈춤
			case "300":
				salePrice = 300000; // 300 이면 300000로 salePrice에저장
				break; // 멈춤
			case "400":
				salePrice = 400000; // 400 이면 400000로 salePrice에저장
				break; // 멈춤
	}
	if(mbr.charAt(0)=='2') { // 만약 회원 번호의 첫번째 자리 수 가 2인 경우
		alert("수강료가 50% 할인 되었습니다."); // 알림창으로 수강료가 할인된걸 출력해준다.
		salePrice = salePrice / 2; // 계산된 salePrice에서 반을 나눠준다. 
	}
	document.classData.tuition.value = salePrice; // 수강료에 salePrice 값을 찍어준다.
}
```

### <div align="center"> body의 강의명 </div>

``` jsp
<tr>
	<th>강의명</th>
	<td><select name="class_name" onchange="calTuition(this.value)"> <!-- 테이블 한칸에 select + option 으로 콤보 박스(선택 박스)를 만들고 value 값을 들고 calTuition 코드를 호출한다. -->
		<option value="none">강의신청</option>
	<%
	while (rs2.next()) { // 값이 없을 때 까지 무한 반복
	%>
		<option value="<%=rs2.getString("teacher_code")%>"><%=rs2.getString("class_name")%></option> <!-- 강의명을 선택하면 value에 선생님 코드 값이 들어간다. -->
	<%
	}
	%>
	</select></td>
</tr>
```
