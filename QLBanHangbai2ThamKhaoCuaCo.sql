create database QLBANHANG
	on (name = 'QLBANHANG_DATA', filename = 'C:\SQL\BANHANG.MDF')
	log on (name = 'QLBANHANG_LOG', filename = 'C:\SQL\BANHANG.LDF')
GO

use QLBANHANG
GO

-- Tạo bảng 
create table KHACHHANG
(
	MAKH varchar(5) primary key,
	TENKH nvarchar(30) NOT NULL,
	DIACHI nvarchar(50) ,
	DT varchar(11), 
	--constraint CK_DienThoai
	--	check (DT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
	--		OR DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	--		OR DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
	--		OR DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') ,
	EMAIL varchar(30)
)
-- Hoặc làm theo cách này
ALTER TABLE KHACHHANG
	ADD CONSTRAINT ck_DIENTHOAI CHECK (DT like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' 
									OR DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
									OR DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
									OR DT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

create table VATTU
(
	MAVT varchar(5) constraint PRK_VATTU_MAVT primary key ,
	TENVT Nvarchar(30) NOT NULL ,
	DVT Nvarchar(20) ,
	GIAMUA MONEY constraint CK_GIAMUA check (GIAMUA > 0) ,
	SLTON INT constraint CK_SLTON check (SLTON >= 0) ,
)
create table HOADON
(
	MAHD varchar(10) primary key,
	NGAY SmallDateTime constraint CK_NGAY check (NGAY <= Getdate()),
	MAKH varchar(5) constraint FRK_HOADON_MAKH 
	foreign key references KHACHHANG(MAKH),
	TONGTG Float
)
create table CTHD
(
	MAHD varchar(10) constraint FRK_CTHD_MAHD foreign key references HOADON(MAHD),
	MAVT varchar(5) constraint FRK_CTHD_MAVT foreign key references VATTU(MAVT),
	SL int constraint CHK_CTHD_SL check (SL > 0),
	KHUYENMAI Float,
	GIABAN Float,
	constraint PRK_CTHD_MAHD_MAVT primary key (MAHD, MAVT)
)

-- Nhập dữ liệu
set dateformat DMY
insert into VATTU values ('VT01', N'Xi măng', N'Bao', 50000, 5000)
insert into VATTU values ('VT02', N'Cát', N'Khối', 45000,  50000)
insert into VATTU values ('VT03', N'Gạch ống', N'Viên', 120, 800000)
insert into VATTU values ('VT04', N'Gạch thẻ', N'Viên', 110, 800000)
insert into VATTU values ('VT05', N'Đá lớn', N'Khối', 25000, 100000)
insert into VATTU values ('VT06', N'Đá nhỏ', N'Khối', 33000, 100000)
insert into VATTU values ('VT07', N'Lam gió', N'Cái', 15000, 5000)

insert into KHACHHANG values ('KH01', N'Nguyễn Thị Bé', N'Tân Bình', 38457895, 'btn@yahoo.com')
insert into KHACHHANG values ('KH02', N'Lê Hoàng Nam', N'Bình Chánh', 39878987, 'btn@yahoo.com')
insert into KHACHHANG values ('KH03', N'Trần Thị Chiêu', N'Tân Bình', 38457895, NULL)
insert into KHACHHANG values ('KH04', N'Mai Thị Quế Anh', N'Bình Chánh', NULL, NULL)
insert into KHACHHANG values ('KH05', N'Lê Văn Sáng', N'Quận 10', NULL, 'btn@yahoo.com')
insert into KHACHHANG values ('KH06', N'Trần Hoàng', N'Tân Bình', 38457895, NULL)

										
		---------------------------------------- VIEW ------------------------------------------------

		SET DATEFORMAT DMY

--1.	Hiển thị danh sách các khách hàng có địa chỉ là “Tân Bình” gồm mã khách hàng, 
		--tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.
		
		CREATE VIEW CAU1
		AS
		SELECT *
		FROM KHACHHANG
		WHERE DIACHI = N'TÂN BÌNH'

--2.	Hiển thị danh sách các khách hàng gồm các thông tin mã khách hàng, tên khách hàng, 
		--địa chỉ và địa chỉ E-mail của những khách hàng chưa có số điện thoại.

		CREATE VIEW CAU2
		AS
		SELECT *
		FROM KHACHHANG
		WHERE DT IS NULL

--3.	Hiển thị danh sách các khách hàng chưa có số điện thoại và cũng chưa có địa chỉ Email 
		--gồm mã khách hàng, tên khách hàng, địa chỉ.

		CREATE VIEW CAU3
		AS
		SELECT *
		FROM KHACHHANG
		WHERE DT IS NULL AND EMAIL IS NULL

--4.	Hiển thị danh sách các khách hàng đã có số điện thoại và địa chỉ E-mail gồm mã khách hàng, 
		--tên khách hàng, địa chỉ, điện thoại, và địa chỉ E-mail.

		CREATE VIEW CAU4
		AS
		SELECT *
		FROM KHACHHANG
		WHERE DT <> 'IS NULL' AND EMAIL <> 'IS NULL'

--5.	Hiển thị danh sách các vật tư có đơn vị tính là “Cái” gồm mã vật tư, tên vật tư và giá mua.

		CREATE VIEW CAU5
		AS
		SELECT MAVT, TENVT, GIAMUA
		FROM VATTU
		WHERE DVT = N'CÁI'

--6.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có 
		--giá mua trên 25000.

		CREATE VIEW CAU6
		AS
		SELECT MAVT, TENVT, DVT, GIAMUA
		FROM VATTU
		WHERE GIAMUA > 25000

--7.	Hiển thị danh sách các vật tư là “Gạch” (bao gồm các loại gạch) gồm mã vật tư, tên vật tư, 
		--đơn vị tính và giá mua. 

		CREATE VIEW CAU7
		AS
		SELECT MAVT, TENVT, DVT, GIAMUA
		FROM VATTU
		WHERE TENVT LIKE N'%GẠCH%'

--8.	Hiển thị danh sách các vật tư gồm mã vật tư, tên vật tư, đơn vị tính và giá mua mà có giá
		-- mua nằm trong khoảng từ 20000 đến 40000.

		CREATE VIEW CAU8
		AS
		SELECT MAVT, TENVT, DVT, GIAMUA
		FROM VATTU
		WHERE GIAMUA > 20000 AND GIAMUA < 40000

--9.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng 
		--và số điện thoại.

		CREATE VIEW CAU9
		AS
		SELECT MAHD, NGAY, TENKH, DIACHI, DT
		FROM HOADON, KHACHHANG
		WHERE HOADON.MAKH = KHACHHANG.MAKH

--10.	Lấy ra các thông tin gồm Mã hóa đơn, tên khách hàng, địa chỉ khách hàng và số điện thoại
		--của ngày 25/5/2010.

		CREATE VIEW CAU10
		AS
		SELECT MAHD, TENKH, DIACHI, DT
		FROM KHACHHANG, HOADON
		WHERE KHACHHANG.MAKH = HOADON.MAKH AND HOADON.NGAY= '25/05/2010'

--11.	Lấy ra các thông tin gồm Mã hóa đơn, ngày lập hóa đơn, tên khách hàng, địa chỉ khách hàng
		--và số điện thoại của những hóa đơn trong tháng 6/2010.

		CREATE VIEW CAU11
		AS
		SELECT MAHD, NGAY, TENKH, DIACHI, DT
		FROM KHACHHANG, HOADON
		WHERE KHACHHANG.MAKH = HOADON.MAKH AND MONTH(NGAY) = 6 AND YEAR(NGAY) = 2010

--12.	Lấy ra danh sách những khách hàng (tên khách hàng, địa chỉ, số điện thoại) đã mua hàng 
		--trong tháng 6/2010.

		CREATE VIEW CAU12
		AS
		SELECT TENKH, DIACHI, DT
		FROM KHACHHANG, HOADON
		WHERE KHACHHANG.MAKH = HOADON.MAKH AND MONTH(NGAY) = 6 AND YEAR(NGAY) = 2010 
		GROUP BY TENKH, DIACHI, DT

--13.	Lấy ra danh sách những khách hàng không mua hàng trong tháng 6/2010 gồm các thông tin tên 
		--khách hàng, địa chỉ, số điện thoại.

		CREATE VIEW CAU13
		AS
		SELECT TENKH, DIACHI, DT 
		FROM KHACHHANG
		WHERE MAKH NOT IN (SELECT MAKH FROM HOADON WHERE MONTH(NGAY) = 6 AND YEAR(NGAY) = 2010)
		GROUP BY TENKH, DIACHI, DT

--14.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, đơn vị 
		--tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), 
		--trị giá bán (giá bán * số lượng).

		CREATE VIEW CAU14
		AS
		SELECT HOADON.MAHD, CTHD.MAVT, TENVT, DVT, GIABAN, GIAMUA, SL, (VATTU.GIAMUA*CTHD.SL) AS [TRI GIA MUA], (CTHD.GIABAN*CTHD.SL) AS [TRI GIA BAN]
		FROM HOADON, CTHD, VATTU
		WHERE HOADON.MAHD = CTHD.MAHD AND CTHD.MAVT=VATTU.MAVT
		GROUP BY HOADON.MAHD, CTHD.MAVT, TENVT, DVT, GIABAN, GIAMUA, SL

--15.	Lấy ra các chi tiết hóa đơn gồm các thông tin mã hóa đơn, mã vật tư, tên vật tư, 
		--đơn vị tính, giá bán, giá mua, số lượng, trị giá mua (giá mua * số lượng), 
		--trị giá bán (giá bán * số lượng) mà có giá bán lớn hơn hoặc bằng giá mua.

		CREATE VIEW CAU15
		AS
		SELECT HOADON.MAHD, CTHD.MAVT, TENVT, DVT, GIABAN, GIAMUA, SL, (VATTU.GIAMUA*CTHD.SL) AS [TRI GIA MUA], (CTHD.GIABAN*CTHD.SL) AS [TRI GIA BAN]
		FROM HOADON, CTHD, VATTU
		WHERE HOADON.MAHD = CTHD.MAHD AND CTHD.MAVT=VATTU.MAVT AND CTHD.GIABAN >= VATTU.GIAMUA
		GROUP BY HOADON.MAHD, CTHD.MAVT, TENVT, DVT, GIABAN, GIAMUA, SL

--16.	Lấy ra các thông tin gồm mã hóa đơn, mã vật tư, tên vật tư, đơn vị tính, giá bán, giá mua, 
		--số lượng, trị giá mua (giá mua * số lượng), trị giá bán (giá bán * số lượng) 
		--và cột khuyến mãi với khuyến mãi 10% cho những mặt hàng bán trong một hóa đơn lớn hơn 100.

		CREATE VIEW CAU16
		AS
		SELECT HOADON.MAHD, CTHD.MAVT, TENVT, DVT, KHUYENMAI, GIABAN, GIAMUA, SL, (VATTU.GIAMUA*CTHD.SL) AS [TRI GIA MUA], (CTHD.GIABAN*CTHD.SL) AS [TRI GIA BAN]
		FROM HOADON, CTHD, VATTU
		WHERE HOADON.MAHD = CTHD.MAHD AND CTHD.MAVT=VATTU.MAVT
		GROUP BY HOADON.MAHD, CTHD.MAVT, TENVT, DVT, GIABAN, GIAMUA, SL, KHUYENMAI

--17.	Tìm ra những mặt hàng chưa bán được.

		CREATE VIEW CAU17
		AS
		SELECT TENVT
		FROM VATTU
		WHERE MAVT NOT IN (SELECT MAVT FROM HOADON, CTHD WHERE HOADON.MAHD = CTHD.MAHD GROUP BY MAVT)

--18.	Tạo bảng tổng hợp gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, địa chỉ, 
		--số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, 
		--trị giá bán. 

		CREATE VIEW CAU18
		AS
		SELECT HOADON.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL, (GIAMUA*SL) AS [TRI GIA MUA], (GIABAN*SL) AS [TRI GIA BAN]
		FROM HOADON, CTHD, VATTU, KHACHHANG
		WHERE HOADON.MAHD = CTHD.MAHD AND CTHD.MAVT=VATTU.MAVT AND KHACHHANG.MAKH = HOADON.MAKH
		GROUP BY HOADON.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIABAN, GIAMUA, SL

--19.	Tạo bảng tổng hợp tháng 5/2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng,
		--địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, 
		--trị giá bán. 

		CREATE VIEW CAU19
		AS
		SELECT HOADON.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL, (GIAMUA*SL) AS [TRI GIA MUA], (GIABAN*SL) AS [TRI GIA BAN]
		FROM HOADON, CTHD, VATTU, KHACHHANG
		WHERE HOADON.MAHD = CTHD.MAHD AND CTHD.MAVT=VATTU.MAVT AND KHACHHANG.MAKH = HOADON.MAKH AND MONTH(NGAY) = 5 AND YEAR(NGAY) = 2010
		GROUP BY HOADON.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIABAN, GIAMUA, SL

--20.	Tạo bảng tổng hợp quý 1 – 2010 gồm các thông tin: mã hóa đơn, ngày hóa đơn, tên khách hàng, 
		--địa chỉ, số điện thoại, tên vật tư, đơn vị tính, giá mua, giá bán, số lượng, trị giá mua, 
		--trị giá bán. 

		CREATE VIEW CAU20
		AS
		SELECT HOADON.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIAMUA, GIABAN, SL, (GIAMUA*SL) AS [TRI GIA MUA], (GIABAN*SL) AS [TRI GIA BAN]
		FROM HOADON, CTHD, VATTU, KHACHHANG
		WHERE HOADON.MAHD = CTHD.MAHD AND CTHD.MAVT=VATTU.MAVT AND KHACHHANG.MAKH = HOADON.MAKH AND MONTH(NGAY) IN (1,2,3) AND YEAR(NGAY) = 2010
		GROUP BY HOADON.MAHD, NGAY, TENKH, DIACHI, DT, TENVT, DVT, GIABAN, GIAMUA, SL

--21.	Lấy ra danh sách các hóa đơn gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, địa chỉ 
		--khách hàng, tổng trị giá của hóa đơn.

		CREATE VIEW CAU21
		AS 
		SELECT HOADON.MAHD, NGAY, TENKH, DIACHI, SUM(GIABAN*SL) AS [TONG TRI GIA HD]
		FROM  HOADON, CTHD, KHACHHANG
		WHERE HOADON.MAHD = CTHD.MAHD AND KHACHHANG.MAKH = HOADON.MAKH
		GROUP BY HOADON.MAHD, NGAY, TENKH, DIACHI

--22.	Lấy ra hóa đơn có tổng trị giá lớn nhất gồm các thông tin: Số hóa đơn, ngày, tên khách hàng, 
		--địa chỉ khách hàng, tổng trị giá của hóa đơn.

		CREATE VIEW CAU22
		AS
		SELECT TOP 1 WITH TIES HOADON.MAHD, NGAY, TENKH, DIACHI, SUM(GIABAN*SL) AS [TONG TRI GIA]
		FROM HOADON, KHACHHANG, CTHD
		WHERE HOADON.MAHD = CTHD.MAHD AND HOADON.MAKH = KHACHHANG.MAKH
		GROUP BY HOADON.MAHD, NGAY, TENKH, DIACHI
		ORDER BY SUM(GIABAN*SL) DESC

--23.	Lấy ra hóa đơn có tổng trị giá lớn nhất trong tháng 5/2010 gồm các thông tin: Số hóa đơn, 
		--ngày, tên khách hàng, địa chỉ khách hàng, tổng trị giá của hóa đơn.

		CREATE VIEW CAU23
		AS
		SELECT TOP 1 WITH TIES HOADON.MAHD, NGAY, TENKH, DIACHI, SUM(GIABAN*SL) AS [TONG TRI GIA]
		FROM HOADON, KHACHHANG, CTHD
		WHERE HOADON.MAHD = CTHD.MAHD AND HOADON.MAKH = KHACHHANG.MAKH AND MONTH(NGAY) = 5 AND YEAR(NGAY) = 2010
		GROUP BY HOADON.MAHD, NGAY, TENKH, DIACHI
		ORDER BY SUM(GIABAN*SL) DESC

--24.	Đếm xem mỗi khách hàng có bao nhiêu hóa đơn.

		CREATE VIEW CAU24
		AS
		SELECT MAKH, COUNT(MAHD) AS [TONG SO HD]
		FROM HOADON
		GROUP BY MAKH

--25.	Đếm xem mỗi khách hàng, mỗi tháng có bao nhiêu hóa đơn.

		CREATE VIEW CAU25
		AS
		SELECT MAKH, COUNT(MAHD) AS [TONG SO HD], MONTH(NGAY) AS THANG, YEAR(NGAY) AS NAM
		FROM HOADON
		GROUP BY MAKH, MONTH(NGAY), YEAR(NGAY)

--26.	Lấy ra các thông tin của khách hàng có số lượng hóa đơn mua hàng nhiều nhất.
		
		CREATE VIEW CAU26
		AS
		SELECT TOP 1 WITH TIES MAKH, COUNT(MAHD) AS [TONG SO HD]
		FROM HOADON
		GROUP BY MAKH
		ORDER BY COUNT(MAHD) DESC

--27.	Lấy ra các thông tin của khách hàng có số lượng hàng mua nhiều nhất.

		CREATE VIEW CAU27
		AS
		SELECT TOP 1 WITH TIES KHACHHANG.*, SUM(SL) AS [SO LUONG MUA]
		FROM KHACHHANG, CTHD, HOADON
		WHERE KHACHHANG.MAKH = HOADON.MAKH AND HOADON.MAHD = CTHD.MAHD
		GROUP BY KHACHHANG.MAKH,TENKH,DIACHI, DT, EMAIL, SL
		ORDER BY SUM(SL) DESC

--28.	Lấy ra các thông tin về các mặt hàng mà được bán trong nhiều hóa đơn nhất.

		CREATE VIEW CAU28
		AS
		SELECT TOP 1 WITH TIES CTHD.MAVT, TENVT, DVT, COUNT(CTHD.MAVT) AS [SO LAN BAN]
		FROM VATTU, HOADON, CTHD
		WHERE VATTU.MAVT = CTHD.MAVT AND HOADON.MAHD = CTHD.MAHD
		GROUP BY CTHD.MAVT, TENVT, DVT
		ORDER BY COUNT(CTHD.MAVT) DESC

--29.	Lấy ra các thông tin về các mặt hàng mà được bán nhiều nhất.

		CREATE VIEW CAU29
		AS
		SELECT TOP 1 WITH TIES CTHD.MAVT, TENVT, DVT, SUM(SL) AS [SO LUONG BAN RA]
		FROM VATTU, HOADON, CTHD
		WHERE VATTU.MAVT = CTHD.MAVT AND HOADON.MAHD = CTHD.MAHD
		GROUP BY CTHD.MAVT, TENVT, DVT
		ORDER BY SUM(SL) DESC

--30.	Lấy ra danh sách tất cả các khách hàng gồm Mã khách hàng, tên khách hàng, địa chỉ, 
		--số lượng hóa đơn đã mua (nếu khách hàng đó chưa mua hàng thì cột số lượng hóa đơn 
		--để trống)

		CREATE VIEW CAU30
		AS
		SELECT KHACHHANG.MAKH, TENKH, DIACHI, COUNT(HOADON.MAHD) AS [SO LUONG HD DA MUA]
		FROM KHACHHANG LEFT JOIN HOADON HOADON ON KHACHHANG.MAKH = HOADON.MAKH 
		GROUP BY KHACHHANG.MAKH, TENKH, DIACHI



		-------------------------------- STORED PROCEDURES ---------------------------------------

		SET DATEFORMAT DMY

--1.	Lấy ra danh các khách hàng đã mua hàng trong ngày X, với X là tham số truyền vào.

		CREATE PROC PRO_CAU1
		@NGAY SMALLDATETIME
		AS
		SELECT MAHD, NGAY, KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL
		FROM KHACHHANG, HOADON
		WHERE HOADON.MAKH = KHACHHANG.MAKH AND NGAY = @NGAY


				------------THUC THI-------------
		DECLARE	@NGAY SMALLDATETIME
		SET @NGAY = CONVERT(SMALLDATETIME,'25/5/2010',103)
		EXEC PRO_CAU1 @NGAY

--2.	Lấy ra danh sách khách hàng có tổng trị giá các đơn hàng lớn hơn X (X là tham số).

		CREATE PROC PRO_CAU2
		@TRIGIA INT
		AS
		SELECT HOADON.MAHD, NGAY, KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL, SUM(GIABAN*SL) AS [TONG TRI GIA]
		FROM KHACHHANG, HOADON, CTHD
		WHERE HOADON.MAKH = KHACHHANG.MAKH AND HOADON.MAHD = CTHD.MAHD 
		GROUP BY HOADON.MAHD, NGAY, KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL
		HAVING SUM(GIABAN*SL) > @TRIGIA

						------------THUC THI-------------
		DECLARE	@TRIGIA INT
		SET @TRIGIA = 500000
		EXEC PRO_CAU2 @TRIGIA

--3.	Lấy ra danh sách X khách hàng có tổng trị giá các đơn hàng lớn nhất (X là tham số).

		CREATE PROC PRO_CAU3
		@NUMBER INT
		AS
		SELECT TOP (@NUMBER) WITH TIES HOADON.MAHD, NGAY, KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL, SUM(GIABAN*SL) AS [TONG TRI GIA]
		FROM KHACHHANG, HOADON, CTHD
		WHERE HOADON.MAKH = KHACHHANG.MAKH AND HOADON.MAHD = CTHD.MAHD 
		GROUP BY HOADON.MAHD, NGAY, KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL
		ORDER BY SUM(GIABAN*SL) DESC
		
						------------THUC THI-------------
		DECLARE	@NUMBER INT
		SET @NUMBER = 1
		EXEC PRO_CAU3 @NUMBER

--4.	Lấy ra danh sách X mặt hàng có số lượng bán lớn nhất (X là tham số).

		CREATE PROC PRO_CAU4
		@NUMBER INT
		AS
		SELECT TOP (@NUMBER) WITH TIES CTHD.MAVT, TENVT, DVT, SUM(SL) AS [SO LUONG BAN]
		FROM VATTU, HOADON, CTHD
		WHERE CTHD.MAVT = VATTU.MAVT AND HOADON.MAHD = CTHD.MAHD 
		GROUP BY CTHD.MAVT, TENVT, DVT
		ORDER BY SUM(SL) DESC
		
						------------THUC THI-------------
		DECLARE	@NUMBER INT
		SET @NUMBER = 1
		EXEC PRO_CAU4 @NUMBER

--5.	Lấy ra danh sách X mặt hàng bán ra có lãi ít nhất (X là tham số).

		CREATE PROC PRO_CAU5
		@NUMBER INT 
		AS
		SELECT TOP (@NUMBER) WITH TIES CTHD.MAVT, TENVT, DVT, (SUM(GIABAN-GIAMUA)*SUM(SL)) AS [LAI SUAT]
		FROM VATTU, CTHD 
		WHERE CTHD.MAVT = VATTU.MAVT
		GROUP BY CTHD.MAVT, TENVT, DVT
		ORDER BY [LAI SUAT]

								------------THUC THI-------------
		DECLARE	@NUMBER INT
		SET @NUMBER = 1
		EXEC PRO_CAU5 @NUMBER

--6.	Lấy ra danh sách X đơn hàng có tổng trị giá lớn nhất (X là tham số).

		CREATE PROC PRO_CAU6
		@NUMBER INT
		AS
		SELECT TOP (@NUMBER) WITH  TIES HOADON.MAHD, NGAY, MAKH, SUM(GIABAN*SL) AS [TONG TRI GIA]
		FROM HOADON, CTHD
		WHERE HOADON.MAHD = CTHD.MAHD 
		GROUP BY HOADON.MAHD, NGAY, MAKH
		ORDER BY SUM(GIABAN*SL) DESC

								------------THUC THI-------------
		DECLARE	@NUMBER INT
		SET @NUMBER = 1
		EXEC PRO_CAU6 @NUMBER

--7.	Tính giá trị cho cột khuyến mãi như sau: Khuyến mãi 5% nếu SL > 100, 10% nếu SL > 500.

		CREATE PROC PRO_CAU7
		AS
		UPDATE CTHD
		SET KHUYENMAI = (CASE 
						WHEN (SL > 100 AND SL <= 500) THEN 0.05 
						WHEN (SL > 500) THEN 0.1 
						END)

--8.	Tính lại số lượng tồn cho tất cả các mặt hàng (SLTON = SLTON – tổng SL bán được).

		CREATE PROC PRO_CAU8
		AS
		SELECT  VATTU.MAVT, (SUM(VATTU.SLTON) - ISNULL(SUM(CTHD.SL), 0)) TONKHO
		FROM VATTU LEFT JOIN CTHD ON VATTU.MAVT = CTHD.MAVT
		GROUP BY VATTU.MAVT
			
					------------THUC THI-------------
		EXEC PRO_CAU8

--9.	Tính trị giá cho mỗi hóa đơn.

		CREATE PROC PRO_CAU9
		AS
		SELECT HOADON.MAHD, NGAY, MAKH, TONGTG = SUM(GIABAN*SL)
		FROM HOADON, CTHD
		WHERE HOADON.MAHD = CTHD.MAHD
		GROUP BY HOADON.MAHD,NGAY,MAKH

							------------THUC THI-------------
		EXEC PRO_CAU9

--10.	Tạo ra table KH_VIP có cấu trúc giống với cấu trúc table KHACHHANG. Lưu các khách hàng 
		--có tổng trị giá của tất cả các đơn hàng >=10.000.000 vào table KH_VIP.

		CREATE PROC PRO_CAU10
		AS
		IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'KH_VIP')
			BEGIN
			--TON TAI ROI
				PRINT N'BẢNG KH_VIP ĐÃ TỒN TẠI NÊN CHỈ CHÈN DỮ LIỆU VÀO BẢNG'
				IF NOT EXISTS(SELECT KH_VIP.MAKH FROM KH_VIP, KHACHHANG WHERE KH_VIP.MAKH = KHACHHANG.MAKH)
				INSERT INTO KH_VIP(MAKH,TENKH,DIACHI,DT,EMAIL)
				SELECT KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL
				FROM KHACHHANG, HOADON, CTHD
				WHERE KHACHHANG.MAKH = HOADON.MAKH AND CTHD.MAHD = HOADON.MAHD
				GROUP BY KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL
				HAVING SUM(GIABAN*SL)>=10000000
				PRINT N'THÊM KHÁCH HÀNG THÀNH CÔNG'
			END
		 ELSE
			BEGIN
				SELECT KHACHHANG.* 
				INTO KH_VIP 
				FROM KHACHHANG,HOADON, CTHD
				WHERE KHACHHANG.MAKH = HOADON.MAKH AND CTHD.MAHD = HOADON.MAHD
				GROUP BY KHACHHANG.MAKH, TENKH, DIACHI, DT, EMAIL
				HAVING SUM(GIABAN*SL)>=5000000
				PRINT N'TẠO BẢNG THÀNH CÔNG'
			END

							------------THUC THI-------------
		EXEC PRO_CAU10

		-------------------------------FUNCTION-------------------------------------

--1.	Viết hàm tính doanh thu của năm, với năm là tham số truyền vào.

		CREATE FUNCTION FUN_CAU1
		(
			@NAM INT
		)
		RETURNS INT
		AS
		BEGIN
			DECLARE @DOANHTHU FLOAT
			SET @DOANHTHU = (SELECT SUM(GIABAN*SL) FROM HOADON,CTHD WHERE CTHD.MAHD = HOADON.MAHD AND YEAR(NGAY) = @NAM)
			RETURN @DOANHTHU
		END

		-----------THỰC THI------------

		PRINT 'TONG:' +STR(DBO.FUN_CAU1(2010))

--2.	Viết hàm tính doanh thu của tháng, năm, với tháng và năm là 2 tham số truyền vào.

		CREATE FUNCTION FUN_CAU2
		(
			@THANG INT
			,@NAM INT
		)
		RETURNS INT
		AS
		BEGIN
			DECLARE @DOANHTHU FLOAT
			SET @DOANHTHU = (SELECT SUM(GIABAN*SL) FROM HOADON,CTHD WHERE CTHD.MAHD = HOADON.MAHD AND MONTH(NGAY) = @THANG AND YEAR(NGAY) = @NAM)
			RETURN @DOANHTHU
		END

		-----------THỰC THI------------

		PRINT 'TONG:' +STR(DBO.FUN_CAU1(5,2010))

--3.	Viết hàm tính doanh thu của khách hàng với mã khách hàng là tham số truyền vào.

		CREATE FUNCTION FUN_CAU3
		(
			@MAKH VARCHAR(5)
		)
		RETURNS FLOAT
		AS
		BEGIN
			DECLARE @DOANHTHU FLOAT
			SET @DOANHTHU=(SELECT SUM(GIABAN*SL) FROM HOADON, CTHD WHERE HOADON.MAHD=CTHD.MAHD AND HOADON.MAKH = @MAKH)
			RETURN @DOANHTHU
		END

				-----------THỰC THI------------

		PRINT 'TONG:' +STR(DBO.FUN_CAU3('KH01'))

--4.	Viết hàm tính tổng số lượng bán được cho từng mặt hàng theo tháng, năm nào đó. 
		--Với mã hàng, tháng và năm là các tham số truyền vào, nếu tháng không nhập vào tức 
		--là tính tất cả các tháng.

		CREATE FUNCTION FUN_CAU4
		(
			@MAVT VARCHAR(5),
			@THANG INT,
			@NAM INT
		) 
		RETURNS FLOAT
		BEGIN	
			DECLARE @DOANHTHU FLOAT
			SET @DOANHTHU = (CASE
							WHEN (@THANG IS NULL) THEN (SELECT SUM(SL*GIABAN) FROM HOADON, VATTU, CTHD WHERE HOADON.MAHD=CTHD.MAHD AND VATTU.MAVT=CTHD.MAVT 
								AND CTHD.MAVT=@MAVT AND YEAR(NGAY)=@NAM)
							WHEN (@THANG IS NOT NULL) THEN (SELECT SUM(SL*GIABAN) FROM HOADON, VATTU, CTHD WHERE HOADON.MAHD=CTHD.MAHD AND VATTU.MAVT=CTHD.MAVT 
								AND CTHD.MAVT=@MAVT AND MONTH(NGAY)=@THANG AND YEAR(NGAY)=@NAM)
							END)
			RETURN @DOANHTHU
		END

		-----------THỰC THI------------
		PRINT N'DOANH THU CUA VT01 LA: '+str(DBO.FUN_CAU4('VT01',NULL,2010))
		PRINT N'DOANH THU CUA VT01 LA: '+str(DBO.FUN_CAU4('VT01',5,2010))
	
--5.	Viết hàm tính lãi ((giá bán – giá mua ) * số lượng bán được) cho từng mặt hàng, với mã 
		--mặt hàng là tham số truyền vào. Nếu mã mặt hàng không truyền vào thì tính cho tất cả 
		--các mặt hàng.

		CREATE FUNCTION FUN_CAU5
		(
			@MAVT VARCHAR(5)
		)
		RETURNS FLOAT
		AS
		BEGIN
			DECLARE @LAISUAT FLOAT
			SET @LAISUAT = (CASE
							WHEN (@MAVT IS NULL) THEN (SELECT (SUM(GIABAN-GIAMUA)*SUM(SL)) FROM VATTU, CTHD WHERE CTHD.MAVT = VATTU.MAVT)
							WHEN (@MAVT IS NOT NULL) THEN (SELECT (SUM(GIABAN-GIAMUA)*SUM(SL)) FROM VATTU, CTHD WHERE CTHD.MAVT = VATTU.MAVT AND CTHD.MAVT = @MAVT)
							END)
			RETURN @LAISUAT
		END

		-----------THỰC THI------------
		PRINT N'LAI SUAT KINH DOANH LA: '+str(DBO.FUN_CAU5(NULL))
		PRINT N'LAI SUAT KINH DOANH VT01 LA: '+str(DBO.FUN_CAU5('VT01'))


		-------------------------------TRIGGER-----------------------------------

--1.	Thực hiện việc kiểm tra các ràng buộc khóa ngoại.
CREATE TRIGGER TRIG_CAU1
INSTEAD OF ?? UPDATE
AS
	DECLARE @MAKH VARCHAR(5)
	SET @MAHD = (SELECT MAHD FROM deleted)
	IF EXISTS(SELECT * FROM CTHD WHERE MAHD = @MAHD)
	IF KDSJKS (KJDKGJK)
		BEGIN 
			PRINT N'MAHD CON TON TAI TRONG CTHD'
			ROLLBACK TRAN
		END
HIEN THONG BAO: KHONH TON TAI KH NAY		
--2.	Không cho phép CASCADE DELETE trong các ràng buộc khóa ngoại. Ví dụ không cho phép xóa các 
		--HOADON nào có SOHD còn trong table CTHOADON.
CREATE TRIGGER TRIG_CAU2
ON HOADON
INSTEAD OF DELETE, UPDATE
AS
	DECLARE @MAHD VARCHAR(5)
	SET @MAHD = (SELECT MAHD FROM deleted)
	IF EXISTS(SELECT * FROM CTHD WHERE MAHD = @MAHD)
		BEGIN 
			PRINT N'MAHD CON TON TAI TRONG CTHD'
			ROLLBACK TRAN
		END
DELETE FROM HOADON WHERE MAHD = 'HD001'	
--3.	Không cho phép user nhập vào hai vật tư có cùng tên.
CREATE TRIGGER TRIG_CAU3
ON VATTU
FOR INSERT
AS
	BEGIN
		DECLARE @TENVT NVARCHAR(30), @MAVT VARCHAR(5)
		SET @TENVT = (SELECT TENVT FROM inserted)
		SET @MAVT = (SELECT MAVT FROM inserted)
		IF EXISTS(SELECT * FROM VATTU WHERE TENVT = @TENVT AND MAVT <> @MAVT)
		BEGIN
			PRINT N'TÊN VẬT TƯ ĐÃ TỒN TẠI'
			ROLLBACK TRAN
		END
	END

INSERT INTO VATTU(MAVT, TENVT) VALUES('VT08', N'Lam gió')

--4.	Khi user đặt hàng thì KHUYENMAI là 5% nếu SL >100, 10% nếu SL > 500.
CREATE TRIGGER TRIG_CAU4
ON CTHD
FOR INSERT, UPDATE
AS
	DECLARE @MAHD VARCHAR(5), @MAVT VARCHAR(5), @SL INT
	
	SELECT @MAHD = MAHD, @MAVT = MAVT, @SL = SL FROM INSERTED
	
	IF @SL > 500
		UPDATE CTHD
		SET KHUYENMAI = 0.1
		WHERE MAHD = @MAHD AND MAVT = @MAVT
	ELSE
		IF (@SL >100 AND @SL <=500)
			UPDATE CTHD
			SET KHUYENMAI = 0.05
			WHERE MAHD = @MAHD AND MAVT = @MAVT
		ELSE
			UPDATE CTHD
			SET KHUYENMAI = 0
			WHERE MAHD = @MAHD AND MAVT = @MAVT
			
INSERT INTO CTHD(MAHD, MAVT, SL, GIABAN) VALUES('HD003', 'VT04', 400, 15000)

--5.	Chỉ cho phép mua các mặt hàng có số lượng tồn lớn hơn hoặc bằng số lượng cần mua và 
--		tính lại số lượng tồn mỗi khi có đơn hàng.

CREATE TRIGGER TRIG_CAU5
ON CTHD 
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @SLMUA INT, @MAVT VARCHAR(5), @SLTONKHO INT
				
	SELECT @MAVT = MAVT, @SLMUA = SL FROM inserted	
	SELECT @SLTONKHO = SUM(SLTON) FROM VATTU WHERE MAVT = @MAVT
	
	IF (@SLMUA <= @SLTONKHO) 
		BEGIN
			UPDATE VATTU
			SET SLTON = (SLTON-@SLMUA)
			WHERE MAVT = @MAVT
			PRINT 'GIAO DICH THANH CONG'
		END	
	ELSE	
		BEGIN	
			ROLLBACK TRAN
			PRINT 'GIAO DICH THAT BAI'
		END	
END

------ LENH INSERT -----------
INSERT INTO CTHD VALUES ('HD012','VT01',4000,NULL,5000)
DELETE FROM CTHD WHERE MAHD='HD011'

--6.	Không cho phép user xóa một lúc nhiều hơn một vật tư.
CREATE TRIGGER TRIG_CAU6
ON VATTU
FOR DELETE
AS
	BEGIN
		DECLARE @SODONG INT
		SET @SODONG=(SELECT COUNT(*) FROM deleted)
		IF( @SODONG > 1)
			BEGIN
				PRINT 'TONG SO DONG DINH XOA: ' + STR(@SODONG)
				PRINT N'BẠN KHÔNG THỂ XÓA MỘT LÚC NHIỀU HƠN 1 VẬT TƯ !'
				ROLLBACK TRAN
			END
		ELSE
			PRINT 'XOA THANH CONG !'
	END
	
DELETE FROM VATTU WHERE MAVT IN ('VT01', 'VT02', 'VT03')

--7.	Mỗi hóa đơn cho phép bán tối đa 5 mặt hàng.

ALTER TRIGGER TRIG_CAU7
ON CTHD
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

------ LENH INSERT------------
INSERT INTO CTHD VALUES ('HD005','VT01',1,NULL,5000)
INSERT INTO CTHD VALUES ('HD005','VT02',1,NULL,5000)
INSERT INTO CTHD VALUES ('HD005','VT03',1,NULL,5000)


--8.	Mỗi hóa đơn có tổng trị giá tối đa 50000000.
CREATE TRIGGER TRIG_CAU8
ON HOADON
FOR INSERT, UPDATE
AS
BEGIN
	IF EXISTS(SELECT * FROM inserted WHERE TONGTG>50000000)
		PRINT N'VƯỢT QUÁ MỨC QUY ĐINH'
	ELSE
		PRINT N'CẢM ƠN QUÝ KHÁCH'
END

--9.	Không được phép bán hàng lỗ quá 50%.
	
ALTER TRIGGER TRIG_CAU9
ON CTHD
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

--------- LENH INSERT------------
INSERT INTO CTHD VALUES ('HD009','VT01',2,NULL,2000)

--10.	Chỉ bán mặt hàng Gạch (các loại gạch) với số lượng là bội số của 100.

	
CREATE TRIGGER TRIG_CAU10 
ON CTHD
FOR INSERT,UPDATE
AS	
DECLARE @MAVT VARCHAR(5)
DECLARE @SLBan INT		
DECLARE @TENVT NVARCHAR(30)

SELECT @MAVT=MAVT,@SLBan=SL FROM INSERTED
SELECT @TENVT=TENVT FROM VATTU WHERE MAVT=@MAVT

IF (@TENVT LIKE N'%Gạch%' AND @SLBan % 100 <> 0)			
BEGIN
	PRINT N'CHI BAN MAT HANG ' + @TENVT + ' VOI SL LA BOI CUA 100.'
	ROLLBACK TRANSACTION
END

		--------- LENH INSERT------------
INSERT INTO CTHD VALUES ('HD009','VT01',2,NULL,2000)