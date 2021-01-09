--Nguyen Duc Cong Khoa
--1811061630
--18DTHC4

create database QUANLYBANHANG
ON
	(
		name = 'QUANLYBANHANG_DATA',
		filename = 'C:\QUANLYBANHANG.MDF'
	)
LOG ON
	(	
		name = 'QUANLYBANHANG_LOG',
		filename = 'C:\QUANLYBANHANG.LDF'
	)

use QUANLYBANHANG
go

create table KHACHHANG
(
	MAKH VARCHAR(5) PRIMARY KEY,
	TENKH NVARCHAR(30) NOT NULL,
	DIACHI NVARCHAR(50),
	DT VARCHAR(11),
	EMAIL VARCHAR(30)
)

create table VATTU
(
	MAVT VARCHAR(5) PRIMARY KEY,
	TENVT NVARCHAR(30) NOT NULL,
	DVT NVARCHAR(20),
	GIAMUA MONEY CHECK (GIAMUA > 0),
	SLTON INT CHECK (SLTON >= 0)
)

create table HOADON
(
	MAHD VARCHAR(10) PRIMARY KEY,
	NGAY DATE CHECK (NGAY < GETDATE()),
	MAKH VARCHAR(5) FOREIGN KEY REFERENCES KHACHHANG,
	TONGTG FLOAT
)

create table CTHD 
(
	MAHD VARCHAR(10) FOREIGN KEY REFERENCES HOADON,
	MAVT VARCHAR(5) FOREIGN KEY REFERENCES VATTU,
	PRIMARY KEY(MAHD, MAVT),
	SL INT CHECK (SL > 0),
	KHUYENMAI FLOAT,
	GIABAN FLOAT
)
	
--1.	Hiển thị danh sách các khách hàng có địa chỉ là “Tân Bình” gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
CREATE VIEW V1
AS 
SELECT MAKH, TENKH, DIACHI, EMAIL  
FROM KHACHHANG 
WHERE DIACHI = N'Tân Bình'
SELECT * FROM V1
--2.	Hiển thị danh sách các khách hàng gồm các thông tin mã khách hàng, tên khách hàng, địa chỉ và địa chỉ E-mail của những khách hàng chưa có số điện thoại.
CREATE VIEW V2
AS
SELECT MAKH, TENKH, DIACHI, EMAIL 
FROM KHACHHANG
WHERE DT IS NULL
SELECT * FROM V2
--3.	Hiển thị danh sách các khách hàng chưa có số điện thoại và cũng chưa có địa chỉ Email gồm mã khách hàng, tên khách hàng, địa chỉ.
CREATE VIEW V3
AS
SELECT MAKH, TENKH, DIACHI
FROM KHACHHANG
WHERE DT IS NULL AND EMAIL IS NULL
SELECT * FROM V3
--4.	Hiển thị danh sách các khách hàng đã có số điện thoại và địa chỉ E-mail gồm mã khách hàng, tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
CREATE VIEW V4
AS
SELECT MAKH, TENKH, DIACHI, DT, EMAIL
FROM KHACHHANG
WHERE DT IS NOT NULL AND EMAIL IS NOT NULL
SELECT * FROM V4
--5.	Hiển thị danh sách các vật tư có đơn vị tính là “Cái” gồm mã vật tư, tên vật tư và giá mua.
CREATE VIEW V5
AS
SELECT MAVT, TENVT, GIAMUA 
FROM VATTU
WHERE DVT = N'Cái'
SELECT * FROM V5
--6.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua trên 25000.
CREATE VIEW V6
AS
SELECT MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE GIAMUA > 25000
SELECT * FROM V6
--7.	Hiển thị danh sách các vật tư là “Gạch” (bao gồm các loại gạch) gồm mã vật tư, tên vật tư, đơn vị tính và giá mua.
CREATE VIEW V7
AS
SELECT MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE TENVT LIKE N'Gạch%'
SELECT * FROM V7
--8.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá mua nằm trong khoảng từ 20000 đến 40000.
CREATE VIEW V8
AS
SELECT  MAVT, TENVT, DVT, GIAMUA
FROM VATTU
WHERE GIAMUA >= 20000 AND GIAMUA <= 40000
SELECT * FROM V8
--9.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại.
CREATE VIEW V9
AS
SELECT MAHD, NGAY, TENKH, DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH 
SELECT * FROM V9
--10.	Lấy ra các thông tin gồm Mã hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của ngày 25/5/2010
CREATE VIEW V10
AS
SELECT MAHD, TENKH, DIACHI, DT, NGAY
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND A.NGAY = '2010-05-25'
SELECT * FROM V10
--11.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại của những hóa đơn trong tháng 6/2010.
CREATE VIEW V11
AS
SELECT MAHD, NGAY, TENKH, DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND MONTH(NGAY) = '6' AND YEAR(NGAY) = '2010' 
SELECT * FROM V11
--12.	Lấy ra danh sách những khách hàng (tên khách hàng, địa chỉ, số điện thoại) đã mua hàng trong tháng 6/2010.
CREATE VIEW V12
AS
SELECT TENKH, DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND MONTH(NGAY) = '6' AND YEAR(NGAY) = '2010'
SELECT * FROM V12
--13.	Lấy ra danh sách những khách hàng không mua hàng trong tháng 6/2010 gồm các thông tin tên khách hàng, địa chỉ, số điện thoại.
CREATE VIEW V13
AS
SELECT TENKH, DIACHI, DT
FROM HOADON A, KHACHHANG B
WHERE A.MAKH = B.MAKH AND MONTH(NGAY) <> '6'
SELECT * FROM V13
--14.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng).
CREATE VIEW V14
AS
SELECT C.MAHD, A.MAVT, TENVT, DVT, GIABAN, GIAMUA, SL, (GIAMUA * SL) AS [TRỊ GIÁ MUA], (GIABAN * SL) AS [TRỊ GIÁ BÁN]
FROM  VATTU A, CTHD B, HOADON C
WHERE A.MAVT = B.MAVT AND B.MAHD = C.MAHD
SELECT * FROM V14
--15.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) mà có giá bán lớn hơn hoặc bằng giá mua.
CREATE VIEW V15
AS
SELECT C.MAHD, A.MAVT, TENVT, DVT, GIABAN, GIAMUA, SL, (GIAMUA * SL) AS [TRỊ GIÁ MUA], (GIABAN * SL) AS [TRỊ GIÁ BÁN]
FROM VATTU A, CTHD B, HOADON C
WHERE A.MAVT = B.MAVT AND B.MAHD = C.MAHD AND GIABAN >= GIAMUA
SELECT * FROM V15						  
--16.	Lấy ra các thông tin gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) và cột khuyến mãi với khuyến mãi 10% cho những mặt hàng bán trong một hóa đơn lớn hơn 100.
CREATE VIEW V16
AS
SELECT B.MAHD, A.MAVT, DVT, GIABAN, GIAMUA, SL, (GIAMUA * SL) AS [TRỊ GIÁ MUA], (GIABAN * SL) AS [TRỊ GIÁ BÁN], ((GIABAN * SL) * 0.1) AS [KHUYẾM MÃI 10%]
FROM VATTU A, HOADON B, CTHD C
WHERE A.MAVT = C.MAVT AND B.MAHD = C.MAHD AND SL > 100
SELECT * FROM V16
--17.	Tìm ra những mặt hàng chưa bán được.
CREATE VIEW V17
AS
SELECT A.TENVT
FROM VATTU A, CTHD B
WHERE A.MAVT = B.MAVT AND B.SL = 0
SELECT *  FROM V17
--18.	Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
CREATE VIEW V18
AS
SELECT A.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL ,(GIAMUA * SL) AS [TRỊ GIÁ MUA], (GIABAN * SL) AS [TRỊ GIÁ BÁN]
FROM HOADON A, KHACHHANG B, CTHD C, VATTU D
WHERE A.MAKH = B.MAKH AND A.MAHD = C.MAHD AND C.MAVT = D.MAVT
SELECT * FROM V18
--19.	Tạo bảng tổng hợp tháng 5/2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán.
CREATE VIEW V19
AS
SELECT A.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL ,(GIAMUA * SL) AS [TRỊ GIÁ MUA], (GIABAN * SL) AS [TRỊ GIÁ BÁN]
FROM HOADON A, KHACHHANG B, CTHD C, VATTU D
WHERE A.MAKH = B.MAKH AND A.MAHD = C.MAHD AND C.MAVT = D.MAVT AND MONTH(NGAY) = '5' AND YEAR(NGAY) = '2010'
SELECT * FROM V19
--20.	Tạo bảng tổng hợp quý 1 – 2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, trị giá bán. 
CREATE VIEW V20
AS
SELECT A.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL ,(GIAMUA * SL) AS [TRỊ GIÁ MUA], (GIABAN * SL) AS [TRỊ GIÁ BÁN]
FROM HOADON A, KHACHHANG B, CTHD C, VATTU D
WHERE A.MAKH = B.MAKH AND A.MAHD = C.MAHD AND C.MAVT = D.MAVT AND DATEPART(QUARTER,NGAY) = 1
SELECT * FROM V20
--21.	Lấy ra danh sách các hóa đơn gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
CREATE VIEW V21
AS
SELECT A.MAHD, NGAY, TENKH, DIACHI, SUM(GIABAN) AS [TỔNG TRỊ GIÁ HÓA ĐƠN]
FROM HOADON A, CTHD B, KHACHHANG C
WHERE A.MAHD = B.MAHD AND A.MAKH = C.MAKH
GROUP BY A.MAHD, NGAY, TENKH, DIACHI
SELECT * FROM V21
--22.	Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
CREATE VIEW V22
AS
SELECT TOP 1 WITH TIES A.MAHD, NGAY, TENKH, DIACHI, SUM(GIABAN) AS [TỔNG TRỊ GIÁ HÓA ĐƠN]
FROM HOADON A, CTHD B, KHACHHANG C
WHERE A.MAHD = B.MAHD AND A.MAKH = C.MAKH
GROUP BY A.MAHD, NGAY, TENKH, DIACHI
ORDER BY SUM(GIABAN) DESC
SELECT * FROM V22
--23.	Lấy ra hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.
CREATE VIEW V23
AS
SELECT TOP 1 WITH TIES A.MAHD, NGAY, TENKH, DIACHI, SUM(GIABAN) AS [TỔNG TRỊ GIÁ HÓA ĐƠN]
FROM HOADON A, CTHD B, KHACHHANG C
WHERE A.MAHD = B.MAHD AND A.MAKH = C.MAKH AND MONTH(NGAY) = '5' AND YEAR(NGAY) = '2010'
GROUP BY A.MAHD, NGAY, TENKH, DIACHI
ORDER BY SUM(GIABAN) DESC
SELECT * FROM V23
--24.	Đếm xem mỗi khách hàng có bao nhiêu hóa đơn.
CREATE VIEW V24
AS
SELECT COUNT(MAHD) AS [TỔNG SỐ HÓA ĐƠN], TENKH
FROM KHACHHANG A, HOADON B
WHERE A.MAKH = B.MAKH
GROUP BY TENKH
SELECT * FROM V24
--25.	Đếm xem mỗi khách hàng, mỗi tháng có bao nhiêu hóa đơn.
CREATE VIEW V25
AS
SELECT COUNT(MAHD) AS [TỔNG SỐ HÓA ĐƠN], TENKH
FROM KHACHHANG A, HOADON B
WHERE A.MAKH = B.MAKH AND MONTH(NGAY) 
GROUP BY TENKH
SELECT * FROM V25
--26.	Lấy ra các thông tin của khách hàng có số lượng hóa đơn mua hàng nhiều nhất.
CREATE VIEW V26
AS
SELECT TOP 1 WITH TIES TENKH, DIACHI, DT, EMAIL, COUNT(MAHD) AS [TỔNG SỐ HÓA ĐƠN]
FROM KHACHHANG A, HOADON B
WHERE A.MAKH = B.MAKH
GROUP BY TENKH, DIACHI, DT, EMAIL
ORDER BY COUNT(MAHD) DESC
SELECT * FROM V26
--27.	Lấy ra các thông tin của khách hàng có số lượng hàng mua nhiều nhất.
CREATE VIEW V27
AS
SELECT TOP 1 WITH TIES TENKH, DIACHI, DT, EMAIL, SUM(SL) AS [SỐ LƯỢNG HÀNG MUA]
FROM KHACHHANG A, HOADON B, CTHD C
WHERE A.MAKH = B.MAKH AND B.MAHD = C.MAHD 
GROUP BY TENKH, DIACHI, DT, EMAIL
ORDER BY SUM(SL) DESC
SELECT * FROM V27
--28.	Lấy ra các thông tin về các mặt hàng mà được bán trong nhiều hóa đơn nhất.
CREATE VIEW V28
AS
SELECT TOP 1 WITH TIES A.MAVT, TENVT, DVT, GIAMUA, SLTON, COUNT(MAHD) AS [SỐ HÓA ĐƠN]
FROM VATTU A, CTHD B
WHERE A.MAVT = B.MAVT 
GROUP BY  A.MAVT, TENVT, DVT, GIAMUA, SLTON
ORDER BY COUNT(MAHD) DESC
SELECT * FROM V28
--29.	Lấy ra các thông tin về các mặt hàng mà được bán nhiều nhất.
CREATE VIEW V29
AS
SELECT TOP 1 WITH TIES A.MAVT, TENVT, DVT, GIAMUA, SLTON, SUM(SL) AS [SỐ LƯỢNG BÁN ĐƯỢC]
FROM VATTU A, HOADON B, CTHD C
WHERE A.MAVT = C.MAVT AND B.MAHD = C.MAHD
GROUP BY A.MAVT, TENVT, DVT, GIAMUA, SLTON
ORDER BY SUM(SL) desc
SELECT * FROM V29
--30.	Lấy ra danh sách tất cả các khách hàng gồm Mã khách hàng, tên khách hàng, địa chỉ, số lượng hóa đơn đã mua (nếu khách hàng đó chưa mua hàng thì cột số lượng hóa đơn để trống)
CREATE VIEW V30
AS
SELECT KHACHHANG.MAKH, TENKH, DIACHI, COUNT(HOADON.MAHD) AS [SỐ LƯỢNG HÓA ĐƠN ĐÃ MUA]
FROM HOADON RIGHT JOIN KHACHHANG ON HOADON.MAKH = KHACHHANG.MAKH 
GROUP BY KHACHHANG.MAKH, TENKH, DIACHI
ORDER BY COUNT(HOADON.MAHD) DESC
SELECT * FROM V30

		-------------------------------PROC-------------------------------------

--1.	Lấy ra danh các khách hàng đã mua hàng trong ngày X, với X là tham số truyền vào.
CREATE PROC BAI1(@A DATE)
AS
	BEGIN
		SELECT TENKH, B.NGAY
 		FROM KHACHHANG A, HOADON B
		WHERE A.MAKH = B.MAKH AND NGAY = @A
	END
EXEC BAI1'2010-5-25'

--2.	Lấy ra danh sách khách hàng có tổng trị giá các đơn hàng lớn hơn X (X là tham số).
CREATE PROC BAI2(@X INT)
AS
	BEGIN
		SELECT A.TENKH, SUM(SL*GIABAN) AS [TỔNG GIÁ TRỊ CÁC ĐƠN HÀNG LỚN HƠN X]
		FROM KHACHHANG A, HOADON B, CTHD C
		WHERE A.MAKH = B.MAKH AND B.MAHD = C.MAHD
		GROUP BY A.TENKH
		HAVING SUM(SL*GIABAN) > @X
	END
EXEC BAI2 500000

--3.	Lấy ra danh sách X khách hàng có tổng trị giá các đơn hàng lớn nhất (X là tham số).
CREATE PROC BAI3(@X INT)
AS
	BEGIN
		SELECT TOP (@X) WITH TIES TENKH,  SUM(SL*GIABAN) AS [TỔNG]
		FROM KHACHHANG A, HOADON B, CTHD C
		WHERE A.MAKH = B.MAKH AND B.MAHD = C.MAHD
		GROUP BY A.TENKH
		ORDER BY SUM(SL*GIABAN) DESC
	END
EXEC BAI3 2

--4.	Lấy ra danh sách X mặt hàng có số lượng bán lớn nhất (X là tham số).
CREATE PROC BAI4(@X INT)
AS
	BEGIN
		SELECT TOP (@X) WITH TIES TENVT, SUM(SL) AS [SỐ LƯỢNG]
		FROM VATTU A, CTHD B
		WHERE A.MAVT = B.MAVT
		GROUP BY TENVT
		ORDER BY SUM(SL) DESC
	END
EXEC BAI4 2

--5.	Lấy ra danh sách X mặt hàng bán ra có lãi ít nhất (X là tham số).
CREATE PROC BAI5 (@X INT)
AS
	BEGIN
		SELECT TOP (@X) WITH TIES TENVT, (SUM(SL*GIABAN) - SUM(SL*GIAMUA)) AS [LÃI]
		FROM VATTU A, CTHD B
		WHERE A.MAVT = B.MAVT 
		GROUP BY TENVT
		ORDER BY [LÃI] ASC
	END
EXEC BAI5 1

--6.	Lấy ra danh sách X đơn hàng có tổng trị giá lớn nhất (X là tham số).
CREATE PROC BAI6(@X INT)
AS
	BEGIN
		SELECT TOP (@X) WITH TIES A.MAHD, NGAY, SUM(SL*GIABAN) AS [TỔNG GIÁ TRỊ]
		FROM HOADON A, CTHD B
		WHERE A.MAHD = B.MAHD 
		GROUP BY A.MAHD, NGAY
		ORDER BY SUM(SL*GIABAN) DESC
	END
EXEC BAI6 2

--7.	Tính giá trị cho cột khuyến mãi như sau: Khuyến mãi 5% nếu SL > 100, 10% nếu SL > 500.
CREATE PROC BAI7
AS
	BEGIN
		SELECT TENVT, (CASE WHEN SL > 100 THEN SL*GIABAN*0.05 WHEN SL > 500 THEN SL*GIABAN*0.01 END) AS [KHUYẾN MÃI]
		FROM VATTU A, CTHD B
		WHERE A.MAVT = B.MAVT 
	END
EXEC BAI7
DROP PROC BAI7

--8.	Tính lại số lượng tồn cho tất cả các mặt hàng (SLTON = SLTON – tổng SL bán được).
CREATE PROC BAI8
AS
	BEGIN
		SELECT TENVT, (SLTON - SUM(SL)) AS [SỐ LƯỢNG TỒN]
		FROM VATTU A, CTHD B
		WHERE A.MAVT = B.MAVT
		GROUP BY TENVT, SLTON
	END
EXEC BAI8

--9.	Tính trị giá cho mỗi hóa đơn.
CREATE PROC BAI9
AS
	BEGIN
		SELECT MAHD,  SUM(SL*GIABAN) AS [TRỊ GIÁ]
		FROM VATTU A, CTHD B
		WHERE A.MAVT = B.MAVT
		GROUP BY MAHD
	END
EXEC BAI9

--10.	Tạo ra table KH_VIP có cấu trúc giống với cấu trúc table KHACHHANG. Lưu các khách hàng có tổng trị giá của tất cả các đơn hàng >=10.000.000 vào table KH_VIP.
CREATE PROC BAI10
AS
	BEGIN
		SELECT TENKH, SUM(SL*GIABAN) AS [TỔNG TRỊ GIÁ] 
		INTO KH_VIP
		FROM KHACHHANG A, HOADON B, CTHD C
		WHERE A.MAKH = B.MAKH AND B.MAHD = C.MAHD 
		GROUP BY TENKH
		HAVING	SUM(SL*GIABAN) >=10000000
	END
EXEC BAI10



				-------------------------------FUNCTION-------------------------------------

--1.	Viết hàm tính doanh thu của năm, với năm là tham số truyền vào.
 CREATE FUNCTION F1(@NAM INT)
 RETURNS BIGINT 
 AS
	BEGIN
		DECLARE @DOANHTHU BIGINT 
			IF NOT EXISTS (SELECT * 
						   FROM HOADON 
						   WHERE YEAR(NGAY) = @NAM)
				SET @DOANHTHU = 0
			ELSE 
				SET @DOANHTHU = (SELECT ISNULL(SUM(SL*GIABAN),0) 
							 FROM HOADON A, CTHD B
							 WHERE A.MAHD = B.MAHD AND YEAR(A.NGAY) = @NAM)
	RETURN @DOANHTHU
END

SELECT DOANDTHUCUANAM = DBO.F1(2010)

--2.	Viết hàm tính doanh thu của tháng, năm, với tháng và năm là 2 tham số truyền vào.
CREATE FUNCTION F2(@NAM INT, @THANG INT)
 RETURNS BIGINT 
 AS
	BEGIN
		DECLARE @DOANHTHU BIGINT 
			IF NOT EXISTS (SELECT * 
						   FROM HOADON 
						   WHERE YEAR(NGAY) = @NAM AND MONTH(NGAY) = @THANG)
				SET @DOANHTHU = 0
			ELSE 
				SET @DOANHTHU = (SELECT ISNULL(SUM(SL*GIABAN),0) 
							 FROM HOADON A, CTHD B
							 WHERE A.MAHD = B.MAHD AND YEAR(A.NGAY) = @NAM AND MONTH(A.NGAY) = @THANG)
	RETURN @DOANHTHU
END

PRINT DBO.F2(2010)
PRINT DBO.F2(05)

SELECT DTN= DBO.F2(2010,5)

--3.	Viết hàm tính doanh thu của khách hàng với mã khách hàng là tham số truyền vào.
CREATE FUNCTION F3(@MAKH CHAR(4))
RETURNS BIGINT
AS
	BEGIN
		DECLARE @DOANHTHU BIGINT
		IF NOT EXISTS (SELECT *
					   FROM HOADON A
					   WHERE H.MAKH = @MAKH)
			SET @DOANHTHU = 0
		ELSE
			SET @DOANHTHU = (SELECT ISNULL(SUM(SL*GIABAN), 0)
						 FROM CTHD A, HOADON B
						 WHERE A.MAHD = B.MAHD AND B.MAKH = @MAKH)
	RETURN @DOANHTHU
END

SELECT DTH = DBO.F3('KH04')

--4.	Viết hàm tính tổng số lượng bán được cho từng mặt hàng theo tháng, năm nào đó. 
--Với mã hàng, tháng và năm là các tham số truyền vào, nếu tháng không nhập vào tức là tính tất cả các tháng.
CREATE FUNCTION F4(@MAVT VARCHAR(5), @THANG INT, @NAM INT) 
RETURNS FLOAT
	BEGIN	
		DECLARE @DOANHTHU FLOAT
		SET @DOANHTHU = (CASE
						 WHEN (@THANG IS NULL) THEN (SELECT SUM(SL*GIABAN) 
													 FROM HOADON A, VATTU B, CTHD C 
													 WHERE A.MAHD = C.MAHD AND B.MAVT = C.MAVT AND C.MAVT = @MAVT AND YEAR(NGAY)= @NAM)
						 WHEN (@THANG IS NOT NULL) THEN (SELECT SUM(SL*GIABAN) 
														 FROM HOADON A, VATTU B, CTHD C 
														 WHERE A.MAHD = C.MAHD AND B.MAVT = C.MAVT AND C.MAVT = @MAVT AND MONTH(NGAY)= @THANG AND YEAR(NGAY)= @NAM)
						 END)
	RETURN @DOANHTHU
END

PRINT N'DOANH THU CUA VT01 LA: '+str(DBO.F4('VT01',NULL,2010))
PRINT N'DOANH THU CUA VT01 LA: '+str(DBO.F4('VT01',5,2010))
	

--5.	Viết hàm tính lãi ((giá bán – giá mua) * số lượng bán được) cho từng mặt hàng, với mã mặt hàng là tham số truyền vào. 
--Nếu mã mặt hàng không truyền vào thì tính cho tất cả các mặt hàng.
CREATE FUNCTION F5(@MAVT VARCHAR(5))
RETURNS FLOAT
AS
	BEGIN
		DECLARE @LAISUAT FLOAT
		SET @LAISUAT = (CASE
						WHEN (@MAVT IS NULL) THEN (SELECT (SUM(GIABAN-GIAMUA)*SUM(SL)) 
												   FROM VATTU A, CTHD B 
												   WHERE A.MAVT = B.MAVT)
						WHEN (@MAVT IS NOT NULL) THEN (SELECT (SUM(GIABAN-GIAMUA)*SUM(SL)) 
													   FROM VATTU A, CTHD B 
													   WHERE A.MAVT = B.MAVT AND A.MAVT = @MAVT)
						END)
	RETURN @LAISUAT
END

PRINT N'LAI SUAT KINH DOANH LA: '+str(DBO.F5(NULL))
PRINT N'LAI SUAT KINH DOANH VT01 LA: '+str(DBO.F5('VT01'))

		-------------------------------TRIGGER-----------------------------------

--1.	Thực hiện việc kiểm tra các ràng buộc khóa ngoại.
CREATE TRIGGER KTKHOANGOAI1 ON KHACHHANG
FOR INSERT, UPDATE
AS
	IF EXISTS (SELECT *
			   FROM KHACHHANG K, inserted I
			   WHERE K.MAKH = I.MAKH)
BEGIN
	PRINT N'KHÔNG TỒN TẠI MÃ KHÁCH HÀNG'
	ROLLBACK TRAN
END

INSERT INTO KHACHHANG VALUES ('KH009','Nguyen Chi Thien','Binh Thanh','035415661',NULL)

-------------------------------------------
CREATE TRIGGER KTKHOANGOAI2 ON VATTU
FOR INSERT, UPDATE
AS
	IF EXISTS (SELECT *
			   FROM VATTU V, inserted I
			   WHERE V.MAVT = I.MAVT)
BEGIN
	PRINT N'KHÔNG TỒN TẠI MÃ VẬT TƯ'
	ROLLBACK TRAN
END

INSERT INTO VATTU VALUES ('HD0011','Băng dán','Bao','150000','3000')

-------------------------------------------
CREATE TRIGGER KTKHOANGOAI3 ON HOADON
FOR INSERT, UPDATE
AS
	IF(EXISTS (SELECT *
			   FROM HOADON H, inserted I
			   WHERE H.MAHD = I.MAHD)
BEGIN
	PRINT N'KHÔNG TỒN TẠI MÃ HÓA ĐƠN'
	ROLLBACK TRAN
END

INSERT INTO HOADON VALUES ('HD0011', '11/10/2010','KH009',NULL)

--2.	Không cho phép CASCADE DELETE trong các ràng buộc khóa ngoại. 
--Ví dụ không cho phép xóa các HOADON nào có SOHD còn trong table CTHD.
CREATE TRIGGER T2 ON CTHD
FOR DELETE
AS
	IF(EXISTS (SELECT *
			   FROM CTHD C, deleted D
			   WHERE C.MAHD = D.MAHD)
BEGIN
	PRINT N'KHÔNG THỂ XÓA'
	ROLLBACK TRAN
END

DELETE CTHD WHERE MAHD ='HD008'

--3.	Không cho phép user nhập vào hai vật tư có cùng tên.
CREATE TRIGGER T3 ON VATTU
FOR INSERT, UPDATE
AS
	IF(EXISTS (SELECT *
			   FROM VATTU V, inserted I
			   WHERE V.TENVT = I.TENVT AND V.MAVT<>I.MAVT)
BEGIN
	PRINT N'TÊN VẬT TƯ BỊ TRÙNG'
	ROLLBACK TRAN
END

INSERT INTO VATTU(MAVT, TENVT) VALUES ('VT08','LAM GIO')

--4.	Khi user đặt hàng thì KHUYENMAI là 5% nếu SL > 100, 10% nếu SL > 500.
CREATE TRIGGER T4 ON CTHD
FOR INSERT, UPDATE
AS
	DECLARE @MAHD VARCHAR(5), @MAVT VARCHAR(5), @SL INT
	SET @MAHD = (SELECT MAHD FROM inserted )
	SET @MAVT = (SELECT MAVT FROM inserted )
	SET @SL = (SELECT SL FROM inserted )
	IF(@SL > 500)
		UPDATE CTHD
		SET KHUYENMAI = 0.1
		WHERE MAHD = @MAHD AND MAVT = @MAVT
	ELSE
		IF(@SL > 100 AND @SL < 500)
			UPDATE CTHD
			SET KHUYENMAI = 0.05
			WHERE MAHD = @MAHD AND MAVT = @MAVT
		ELSE
			UPDATE CTHD
			SET KHUYENMAI = 0
			WHERE MAHD = @MAHD AND MAVT = @MAVT

INSERT INTO HOADON(MAHD, MAKH) VALUES ('HD011','HD05')
INSERT INTO CTHD(MAHD, MAVT, SL, GIABAN) VALUES ('HD011','VT03','1000','500000'

--5.	Chỉ cho phép mua các mặt hàng có số lượng tồn lớn hơn hoặc bằng số lượng cần mua 
		--tính lại số lượng tồn mỗi khi có đơn hàng.
CREATE TRIGGER T5 ON CTHD 
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @SLMUA INT, @MAVT VARCHAR(5), @SLTONKHO INT
				
	SELECT @MAVT = MAVT, @SLMUA = SL FROM inserted	
	SELECT @SLTONKHO = SUM(SLTON) FROM VATTU WHERE MAVT = @MAVT
	
	IF (@SLMUA <= @SLTONKHO) 
		BEGIN
			UPDATE VATTU
			SET SLTON = (SLTON - @SLMUA)
			WHERE MAVT = @MAVT
			PRINT 'GIAO DICH THANH CONG'
		END	
	ELSE	
		BEGIN	
			ROLLBACK TRAN
			PRINT 'GIAO DICH THAT BAI'
		END	
END


INSERT INTO CTHD VALUES ('HD012','VT01',4000,NULL,5000)
DELETE FROM CTHD WHERE MAHD='HD011'

--6.	Không cho phép user xóa một lúc nhiều hơn một vật tư.
CREATE TRIGGER T6 ON VATTU
FOR DELETE
AS
BEGIN
	DECLARE @XOA INT
	SET @XOA = (SELECT COUNT(*) FROM deleted)
	IF(@XOA > 1)
		BEGIN
			PRINT N'SỐ LƯỢNG ĐỊNH XÓA' + STR(@XOA)
			PRINT N'KHÔNG THỂ XÓA 1 LÚC NHIỀU HƠN 1 VẬT TƯ'
			ROLLBACK TRAN
		END
	ELSE
		PRINT N'XÓA THÀNH CÔNG'
END

DELETE FROM VATTU WHERE MAVT IN ('VT01','VT02','VT03')

--7.	Mỗi hóa đơn cho phép bán tối đa 5 mặt hàng.
CREATE TRIGGER T7 ON CTHD
FOR INSERT 
AS
BEGIN
	DECLARE @MAHD VARCHAR(5), @COUNTHD INT
	SELECT @MAHD = MAHD FROM INSERTED
	SELECT @COUNTHD = COUNT(CTHD.MAVT) FROM CTHD WHERE CTHD.MAHD=@MAHD
	IF(@COUNTHD > 5)
		BEGIN
			PRINT 'MOI HOA DON CHI CHO PHAP BAN TOI DA 5 MAT HANG'
			ROLLBACK TRAN
		END
END


INSERT INTO CTHD VALUES ('HD005','VT01',1,NULL,5000)
INSERT INTO CTHD VALUES ('HD005','VT02',1,NULL,5000)
INSERT INTO CTHD VALUES ('HD005','VT03',1,NULL,5000)

--8.	Mỗi hóa đơn có tổng trị giá tối đa 50000000.
CREATE TRIGGER T8 ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted WHERE TONGTG > 50000000)
		PRINT N'VƯỢT QUÁ MỨC QUY ĐINH'
	ELSE
		PRINT N'CẢM ƠN QUÝ KHÁCH'
END

--9.	Không được phép bán hàng lỗ quá 50%.
ALTER TRIGGER T9 ON CTHD
FOR INSERT
AS
BEGIN
	DECLARE @GIABAN INT, @DINHMUC INT, @MAVT VARCHAR(5)
	SELECT @GIABAN = GIABAN, @MAVT = MAVT FROM INSERTED
	SELECT @DINHMUC = (GIAMUA*0.5) FROM VATTU WHERE MAVT = @MAVT
	IF(@GIABAN <= @DINHMUC)
		BEGIN
			PRINT 'BAN KHONG CO LOI'
			ROLLBACK TRAN
		END
END


INSERT INTO CTHD VALUES ('HD009','VT01',2,NULL,2000)

--10.	Chỉ bán mặt hàng Gạch (các loại gạch) với số lượng là bội số của 100.
CREATE TRIGGER T10 ON CTHD
FOR INSERT,UPDATE
AS	
	DECLARE @MAVT VARCHAR(5)
	DECLARE @SLBAN INT		
	DECLARE @TENVT NVARCHAR(30)

	SELECT @MAVT=MAVT, @SLBAN = SL FROM INSERTED
	SELECT @TENVT=TENVT FROM VATTU WHERE MAVT=@MAVT

	IF (@TENVT LIKE N'%Gạch%' AND @SLBAN % 100 <> 0)			
BEGIN
	PRINT N'CHI BAN MAT HANG ' + @TENVT + ' VOI SL LA BOI CUA 100.'		ROLLBACK TRANSACTION
END

		--------- LENH INSERT------------
INSERT INTO CTHD VALUES ('HD009','VT01',2,NULL,2000)
