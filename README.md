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

### <div align="center"> 이름을 누르면 회원번호 자동생성 </div>

```
