﻿--Nguyen Duc Cong Khoa
--1811061630
--18DTHC4
--BAI TAP 3

create database QUANLYTHONGTINSP 
go

use QUANLYTHONGTINSP
go

create table LOAI
(
	MALOAI INT PRIMARY KEY,
	TENLOAI NVARCHAR(50)
)

create table SANPHAM
(
	MASP INT PRIMARY KEY,
	TENSP NVARCHAR(50),
	MALOAI INT FOREIGN KEY REFERENCES LOAI(MALOAI)
)

create table NHANVIEN
(
	MANV CHAR(5) PRIMARY KEY,
	HOTEN NVARCHAR(50),
	NGAYSINH DATETIME CHECK ((YEAR(GETDATE())- YEAR(NGAYSINH)) BETWEEN 18 AND 55),
	PHAI BIT DEFAULT 0
)

create table PHIEUXUAT
(
	MAPX INT PRIMARY KEY,
	NGAYLAP DATETIME,
	MANV CHAR(5) FOREIGN KEY REFERENCES NHANVIEN(MANV)
)

create table CTPX
(
	MAPX INT FOREIGN KEY REFERENCES PHIEUXUAT(MAPX),
	MASP INT FOREIGN KEY REFERENCES SANPHAM(MASP),
	PRIMARY KEY(MAPX, MASP),
	SOLUONG INT
)

----------------------------------------------VIEW------------------------------------------------------


--1.	Cho biết mã sản phẩm, tên sản phẩm, tổng số lượng xuất của từng sản phẩm trong năm 2010. Lấy dữ liệu từ View này sắp xếp tăng dần theo tên sản phẩm.
CREATE VIEW V1
AS
SELECT A.MASP, TENSP, SUM(SOLUONG) AS [TỔNG SỐ LƯỢNG XUẤT]
FROM SANPHAM A, CTPX B, PHIEUXUAT C
WHERE A.MASP = B.MASP AND B.MAPX= C.MAPX AND YEAR(NGAYLAP) = '2010'
GROUP BY A.MASP, TENSP
B
SELECT* FROM V1

--2.	Cho biết mã sản phẩm, tên sản phẩm, tên loại sản phẩm mà đã được bán từ ngày 1/1/2010 đến 30/6/2010.
CREATE VIEW V2
AS
SELECT A.MASP, TENSP,TENLOAI
FROM SANPHAM A,LOAI B, PHIEUXUAT C, CTPX D
WHERE A.MASP = D.MASP and A.MALOAI = B.MALOAI and C.MAPX = D.MAPX and CONVERT(VARCHAR, C.NGAYLAP) between '1/1/2010' and '30/06/2010' 

SELECT* FROM V2

--3.	Cho biết số lượng sản phẩm trong từng loại sản phẩm gồm các thông tin: mã loại sản phẩm, tên loại sản phẩm, số lượng các sản phẩm.
CREATE VIEW V3
AS
SELECT A.MALOAI, TENLOAI, TENSP, SUM(SOLUONG) AS [SỐ LƯỢNG SẢN PHẨM]
FROM LOAI A, SANPHAM B, CTPX C
WHERE A.MALOAI = B.MALOAI AND B.MASP = C.MASP
GROUP BY A.MALOAI, TENLOAI, TENSP

SELECT* FROM V3

--4.	Cho biết tổng số lượng phiếu xuất trong tháng 6 năm 2010.
CREATE VIEW V4
AS
SELECT COUNT(B.MAPX) AS [TỔNG SỐ LƯỢNG PHIẾU XUẤT TRONG THÁNG 6 NĂM 2010]
FROM CTPX A, PHIEUXUAT B 
WHERE A.MAPX = B.MAPX AND YEAR(NGAYLAP) = '2010' AND MONTH(NGAYLAP) = '06'

SELECT* FROM V4

--5.	Cho biết thông tin về các phiếu xuất mà nhân viên có mã NV01 đã xuất.
CREATE VIEW V5
AS
SELECT A.MANV, HOTEN, B.MAPX, SOLUONG, NGAYLAP
FROM NHANVIEN A, PHIEUXUAT B, CTPX C
WHERE A.MANV = B.MANV AND B.MAPX = C.MAPX AND A.MANV = 'NV01'

SELECT* FROM V5

--6.	Cho biết danh sách nhân viên nam có tuổi trên 25 nhưng dưới 30.
CREATE VIEW V6
AS
SELECT MANV, HOTEN, PHAI
FROM NHANVIEN 
WHERE PHAI = 1 AND YEAR(GETDATE()) - YEAR(NGAYSINH) BETWEEN 25 AND 30

SELECT* FROM V6

--7.	Thống kê số lượng phiếu xuất theo từng nhân viên.
CREATE VIEW V7
AS
SELECT A.MANV, HOTEN, COUNT(B.MAPX) AS [SỐ LƯỢNG PHIẾU XUẤT]
FROM NHANVIEN A, PHIEUXUAT B, CTPX C
WHERE A.MANV = B.MANV AND B.MAPX = C.MAPX
GROUP BY A.MANV, HOTEN

SELECT* FROM V7

--8.	Thống kê số lượng sản phẩm đã xuất theo từng sản phẩm.
CREATE VIEW V8
AS
SELECT TENSP, SUM(SOLUONG) AS [SỐ LƯỢNG ĐÃ XUẤT]
FROM SANPHAM A, CTPX B
WHERE A.MASP = B.MASP
GROUP BY TENSP

SELECT* FROM V8

--9.	Lấy ra tên của nhân viên có số lượng phiếu xuất lớn nhất.
CREATE VIEW V9
AS
SELECT TOP 1 A.MANV, HOTEN, COUNT(B.MAPX) AS [SỐ LƯỢNG PHIẾU XUẤT]
FROM NHANVIEN A, PHIEUXUAT B, CTPX C
WHERE A.MANV = B.MANV AND B.MAPX = C.MAPX
GROUP BY A.MANV, HOTEN

SELECT* FROM V9

--10.	Lấy ra tên sản phẩm được xuất nhiều nhất trong năm 2010.
CREATE VIEW V10
AS
SELECT TOP 1 TENSP, SUM(SOLUONG) AS [SỐ LƯỢNG ĐƯỢC XUẤT]
FROM SANPHAM A, CTPX B, PHIEUXUAT C
WHERE A.MASP = B.MASP AND B.MAPX = C.MAPX AND YEAR(NGAYLAP) = '2010'
GROUP BY TENSP

SELECT* FROM V10



----------------------------------------FUNCTION----------------------------------------------
--1.	Function F1 có 2 tham số vào là: tên sản phẩm, năm. Function cho biết: số lượng xuất kho của tên sản phẩm đó trong năm này. 
--(Chú ý: Nếu tên sản phẩm đó không tồn tại thì phải trả về 0)
CREATE FUNCTION F1(@TENSP NVARCHAR(50), @NAM DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @SOLUONG INT
	IF @TENSP is NULL
		RETURN 0
	ELSE
		SELECT @SOLUONG = sum(SOLUONG)
		FROM CTPX A, PHIEUXUAT B, SANPHAM C
		WHERE A.MASP = C.MASP and B.MAPX = A.MAPX and YEAR(NGAYLAP) = @NAM and C.TENSP = @TENSP
	return @SOLUONG;
END

select dbo.F1 (N'Gạch', 2010) as [Số lượng xuất kho trong năm này]

--2.	Function F2 có 1 tham số nhận vào là mã nhân viên. Function trả về số lượng phiếu xuất của nhân viên truyền vào. 
--Nếu nhân viên này không tồn tại thì trả về 0.
CREATE FUNCTION F2(@MANV CHAR(5))
RETURNS INT 
AS
BEGIN 
	DECLARE @SOLUONGPX INT
	IF @MANV IS NULL
		RETURN 0
	ELSE
		SELECT @SOLUONGPX = COUNT(B.MAPX)
		FROM NHANVIEN A, PHIEUXUAT B, CTPX C
		WHERE A.MANV = B.MANV AND B.MAPX = C.MAPX AND A.MANV = @MANV
	RETURN @SOLUONGPX;
END

SELECT dbo.F2 ('NV01') AS [SỐ LƯỢNG PHIẾU XUẤT]


--3.	Function F3 có 1 tham số vào là năm, trả về danh sách các sản phẩm được xuất trong năm truyền vào. 
CREATE FUNCTION F3(@NAM INT)
returns @SP TABLE
(
	MaSP int,
	TenSP nvarchar(40),
	Ngaylap datetime
)
AS
BEGIN
	insert into @SP
	select A.MASP, TENSP, NGAYLAP
	from SANPHAM A , CTPX B, PHIEUXUAT C
	where A.MASP = B.MASP and B.MAPX = C.MAPX and year(NGAYLAP) = @NAM
	return
END

SELECT* FROM dbo.F3 ('2010')

--4.	Function F4 có một tham số vào là mã nhân viên để trả về danh sách các phiếu xuất của nhân viên đó.
--Nếu mã nhân viên không truyền vào thì trả về tất cả các phiếu xuất.
CREATE FUNCTION F4(@MANV CHAR(5))
RETURNS @PHIEUXUAT TABLE
(
	MAPX INT,
	NGAYLAP DATETIME,
	MANV CHAR(5)
)
AS
BEGIN
		INSERT INTO @PHIEUXUAT
		SELECT B.MAPX, NGAYLAP, A.MANV
		from NHANVIEN A, PHIEUXUAT B, CTPX C
		WHERE A.MANV = B.MANV and B.MAPX = C.MAPX and A.MANV = @MANV
		RETURN
END

SELECT* FROM dbo.F4 ('VN01')

--5.	Function F5 để cho biết tên nhân viên của một phiếu xuất có mã phiếu xuất là tham số truyền vào.
CREATE FUNCTION F5(@MAPX INT)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @TENNV NVARCHAR(50)
	SET @TENNV = (SELECT HOTEN 
				  FROM NHANVIEN A, PHIEUXUAT B 
				  WHERE A.MANV = B.MANV and B.MAPX = @MAPX)
	RETURN @TENNV
END

SELECT dbo.F5 (2) AS [HỌ TÊN]

--6.	Function F6 để cho biết danh sách các phiếu xuất từ ngày T1 đến ngày T2. (T1, T2 là tham số truyền vào). Chú ý: T1 <= T2.
CREATE FUNCTION F6(@T1 DATE, @T2 DATE)
returns @PHIEUXUAT TABLE
(
	MAPX INT,
	NGAYLAP DATE,
	MaNV CHAR(5)
)
AS
BEGIN
	INSERT INTO @PHIEUXUAT
	select B.MaPX, Ngaylap, A.MaNV
	FROM NHANVIEN A, PHIEUXUAT B, CTPX C
	WHERE A.MANV = B.MANV and B.MAPX = C.MAPX and NGAYLAP between @T1 and @T2 and @T1 <= @T2
	RETURN
END

select * from dbo.F6 ('2010-02-03','2010-06-16')

--7.	Function F7 để cho biết ngày xuất của một phiếu xuất với mã phiếu xuất là tham số truyền vào.
CREATE FUNCTION F7(@MAPX int)
RETURNS DATE
AS
BEGIN
	DECLARE @NGAYXUAT DATE
	SET @NGAYXUAT = (SELECT NGAYLAP
					 FROM PHIEUXUAT A,CTPX B
					 WHERE A.MAPX = @MAPX and A.MAPX = B.MAPX)
	RETURN @NGAYXUAT
END


SELECT dbo.F7 (2) AS [NGÀY XUẤT]

-------------------------------------------------PROC------------------------------------------------------------
--1.	Procedure tên là P1 cho có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong năm 2010 
--(Không viết lại truy vấn, hãy sử dụng Function F1 ở câu 4 để thực hiện)
CREATE PROC P1(@TENSP NVARCHAR(50))
AS
	BEGIN
		SELECT A.MASP, TENSP, SUM(SOLUONG) as [TỔNG SỐ LƯỢNG XUẤT KHO]
		FROM SANPHAM A, CTPX B, PHIEUXUAT C
		WHERE A.MASP = B.MASP AND B.MAPX = C.MAPX AND YEAR(NGAYLAP) = '2010' AND TENSP = @TENSP
		GROUP BY A.MASP, TENSP
	END

EXEC P1 N'Gạch'		

--2.	Procedure tên là P2 có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010 
--(Chú ý: Nếu tên sản phẩm này không tồn tại thì trả về 0)
CREATE PROC P2(@TENSP NVARCHAR(50))
AS
	BEGIN
		SELECT A.MASP, TENSP, SUM(SOLUONG) as [TỔNG SỐ LƯỢNG XUẤT KHO]
		FROM SANPHAM A, CTPX B, PHIEUXUAT C
		WHERE A.MASP = B.MASP AND B.MAPX = C.MAPX AND CONVERT(nvarchar, NGAYLAP) BETWEEN '4/2010' AND '6/2010' AND TENSP = @TENSP
		GROUP BY A.MASP, TENSP
	END
DROP PROC P2
EXEC P2 N'Gạch'

--3.	Procedure tên là P3 chỉ có duy nhất 1 tham số nhận vào là tên sản phẩm. 
--Trong Procedure này có khai báo 1 biến cục bộ được gán giá trị là: số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010. 
--Việc gán trị này chỉ được thực hiện bằng cách gọi Procedure P2.
CREATE PROC P2(@TENSP NVARCHAR(50))
AS
	BEGIN
		SELECT A.MASP, TENSP, SUM(SOLUONG) as [TỔNG SỐ LƯỢNG XUẤT KHO]
		FROM SANPHAM A, CTPX B, PHIEUXUAT C
		WHERE A.MASP = B.MASP AND B.MAPX = C.MAPX AND CONVERT(nvarchar, NGAYLAP) BETWEEN '4/2010' AND '6/2010' AND TENSP = @TENSP
		GROUP BY A.MASP, TENSP
	END
DROP PROC P2
EXEC P2 N'Gạch'


--4.	Procedure P4 để INSERT một record vào trong table LOAI. Giá trị các field là tham số truyền vào.
CREATE PROCEDURE P4(@ MALOAI INT, @TENLOAI NVARCHAR)
AS 
BEGIN 
	INSERT INTO LOAI(MALOAI, TENLOAI) 
	VALUES (@MALOAI, @TENLOAI) 
END 
	
--5.	Procedure P5 để DELETE một record trong Table NhânViên theo mã nhân viên. Mã NV là tham số truyền vào.
CREATE PROCEDURE P5(@MANV CHAR(5)) 
AS 
BEGIN 
	DELETE FROM NHANVIEN
	WHERE MANV = @MANV 
END 

---------------------------------------------------TRIGGER-------------------------------------------------------
--1.	Chỉ cho phép một phiếu xuất có tối đa 5 chi tiết phiếu xuất.
CREATE TRIGGER T1 ON CTPX
FOR INSERT, UPDATE
AS
	IF(EXISTS (SELECT A.MAPX, COUNT(A.MAPX)
			   FROM CTPX A, inserted I
			   WHERE A.MAPX = I.MAPX
			   GROUP BY A.MAPX
			   HAVING COUNT(MAPX) > 5)
BEGIN
		PRINT 'MOI PHIEU XUAT CO TOI DA 5 CHI TIET PHIEU XUAT'
		ROLLBACK TRAN
END


--2.	Chỉ cho phép một nhân viên lập tối đa 10 phiếu xuất trong một ngày.
CREATE TRIGGER T1 ON PHIEUXUAT
FOR INSERT, UPDATE
AS
	IF(EXISTS (SELECT A.MANV, COUNT(A.MAPX)
			   FROM PHIEUXUAT A, inserted I
			   WHERE A.MAPX = I.MAPX and DAY(NGAYLAP) = 1
			   GROUP BY A.MAPX
			   HAVING COUNT(MAPX) > 10) 
BEGIN
		PRINT 'MOI NHAN VIEN LAP TOI DA 10 PHIEU XUAT TRONG 1 NGAY'
		ROLLBACK TRAN
END


--3.	Khi người dùng viết 1 câu truy vấn nhập 1 dòng cho bảng chi tiết phiếu xuất thì CSDL kiểm tra, 
--nếu mã phiếu xuất mới đó chưa tồn tại trong bảng phiếu xuất thì CSDL sẽ không cho phép nhập và thông báo lỗi “Phiếu xuất này không tồn tại”. Hãy viết 1 trigger đảm bảo điều này.
CREATE TRIGGER T3 ON CTPX
FOR INSERT, UPDATE
AS
	IF EXISTS (SELECT *
			   FROM CTPX A, inserted I
			   WHERE A.MAPX = I.MAPX)
BEGIN
	PRINT N'PHIẾU XUẤT TRONG TỒN TẠI'
	ROLLBACK TRAN
END

INSERT INTO CTPX VALUES ('9', '6', '30')