create database QLTT
on
(
	Name = 'QLTT_DATA',
	FILENAME = 'C:\QLTT.MDF'
)
log on
(
	Name = 'QLTT_LOG',
	FILENAME = 'C:\QLTT.LDF'
)

use QLTT
go

create table LOAI
(
	Maloai int primary key,
	Tenloai nvarchar(40),
)

create table SANPHAM
(
	MaSP int primary key,
	TenSP nvarchar(40),
	Maloai int foreign key references Loai(Maloai),
)

create table NHANVIEN
(
	MaNV char(5) primary key,
	Hoten nvarchar(40),
	Ngaysinh datetime check ((year(getdate())- year(Ngaysinh)) between 18 and 55),
	Phai bit default 0,
)

create table PX
(
	MaPX int primary key,
	Ngaylap datetime,
	MaNV char(5) foreign key references NHANVIEN(MaNV),
)

create table CTPX
(
	MaPX int foreign key references PX(MaPX),
	MaSP int foreign key references SANPHAM(MaSP),
	primary key(MaPX,MaSP),
	SL int,
)
-----------VIEW----------------
--1.	Cho biết mã sản phẩm, tên sản phẩm, tổng số lượng xuất của từng sản phẩm trong năm 2010. Lấy dữ liệu từ View này sắp xếp tăng dần theo tên sản phẩm.
create view cau1
as
select a.MaSP,TENSP,SUM(SL) as [Tong SL xuat]
from SANPHAM a, PX b, CTPX c 
where a.MaSP = c.MaSP and b.MaPX = c.MaPX and year(Ngaylap)= '2010'
group by a.MaSP,TENSP

select *
from cau1
--2.	Cho biết mã sản phẩm, tên sản phẩm, tên loại sản phẩm mà đã được bán từ ngày 1/1/2010 đến 30/6/2010.
create view cau2
as
select a.MaSP,TENSP,TENLOAI
from SANPHAM a,LOAI b,PX c,CTPX d
where a.MaSP = d.MaSP and a.Maloai = b.Maloai and c.MaPX = d.MaPX and convert(nvarchar,Ngaylap) between '1/1/2010' and '30/06/2010' 
--3.	Cho biết số lượng sản phẩm trong từng loại sản phẩm gồm các thông tin: mã loại sản phẩm, tên loại sản phẩm, số lượng các sản phẩm.
create view cau3
as
select a.MaSP,TENLOAI,SUM(SL) as [SL SP]
from SANPHAM a, LOAI b,CTPX c
where a.Maloai = b.Maloai and a.MaSP = c.MaSP
group by a.MaSP,TENLOAI

select *
from cau3
--4.	Cho biết tổng số lượng phiếu xuất trong tháng 6 năm 2010.
create view cau4 
as
select count(a.MaPX) as [Tong SL phieu xuat]
from PX a, CTPX b
where a.MaPX = b.MaPX and year(Ngaylap)='2010' and month(Ngaylap)= '06'

select *
from cau4
--5.	Cho biết thông tin về các phiếu xuất mà nhân viên có mã NV01 đã xuất.
create view cau5
as
select a.MaNV,Hoten,ngaylap,SL
from NHANVIEN a, PX b, CTPX c
where a.MaNV = b.MaNV and b.MaPX = c.MaPX and a.MaNV = 'NV01'

select *
from cau5
--6.	Cho biết danh sách nhân viên nam có tuổi trên 25 nhưng dưới 30.
create view cau6
as
select MaNV,Hoten,Phai
from NHANVIEN
where Phai = 1 and year(getdate()-year(Ngaysinh)) between 25 and 30 

select *
from cau6
--7.	Thống kê số lượng phiếu xuất theo từng nhân viên.
create view cau7
as
select a.MaNV,Hoten,count(c.MaPX) as [SL phieu xuat]
from NHANVIEN a, PX c, CTPX b
where a.MaNV = c.MaNV and b.MaPX = c.MaPX
group by a.MaNV,Hoten

select *
from cau7
--8.	Thống kê số lượng sản phẩm đã xuất theo từng sản phẩm.
create view cau8
as
select TenSP,Sum(SL) as [So luong san phan da xuat]
from SANPHAM a , CTPX b, PX c
where a.MaSP = b.MaSP and b.MaPX = c.MaPX
group by TenSP

select *
from cau8
--9.	Lấy ra tên của nhân viên có số lượng phiếu xuất lớn nhất.
create view cau9
as
select top 1 a.MaNV,Hoten,count(c.MaPX) as [SL phieu xuat]
from NHANVIEN a, PX c, CTPX b
where a.MaNV = c.MaNV and b.MaPX = c.MaPX
group by a.MaNV,Hoten

select *
from cau9
--10.	Lấy ra tên sản phẩm được xuất nhiều nhất trong năm 2010.
create view cau10
as
select top 1 TenSP,Sum(SL) as [So luong san phan da xuat]
from SANPHAM a , CTPX b, PX c
where a.MaSP = b.MaSP and b.MaPX = c.MaPX and year(Ngaylap) = '2010'
group by TenSP

select *
from cau10

-------------------FUNCTION------------------------
--1.	Function F1 có 2 tham số vào là: tên sản phẩm, năm. Function cho biết: số lượng xuất kho của tên sản phẩm này trong năm này. (Chú ý: Nếu tên sản phẩm này không tồn tại thì phải trả về 0)
create function F1
(
	@tensp nvarchar(40)
	,@nam datetime
)
returns int
as
begin
	declare @sl int
	if @tensp is NULL
		return 0
	else
		select @sl = sum(SL)
		from CTPX a, PX b, SANPHAM c
		where a.MaSP = c.MaSP and b.MaPX = a.MaPX and year(Ngaylap)=@nam and c.TenSP = @tensp
	return @sl;
end

select dbo.F1 (N'Gạch',2010) as [Số lượng xuất kho trong năm này]
drop function dbo.F1
--2.	Function F2 có 1 tham số nhận vào là mã nhân viên. Function trả về số lượng phiếu xuất của nhân viên truyền vào. Nếu nhân viên này không tồn tại thì trả về 0.
create function F2
(
	@manv char(5)
)
returns int
as
begin
	declare @sl int
	if @manv is NULL
		set @manv = 0
	else
		select @sl = count(c.MaPX)
		from NHANVIEN a, PX c, CTPX b
		where a.MaNV = c.MaNV and b.MaPX = c.MaPX and a.MaNV = @manv
	return @sl;
end

select dbo.F2 ('NV01') as [Số lượng phiếu xuất của nhân viên]
drop function dbo.F2
--3.	Function F3 có 1 tham số vào là năm, trả về danh sách các sản phẩm được xuất trong năm truyền vào. 
create function F3
(
	@nam int
)
returns @SP table
(
	MaSP int,
	TenSP nvarchar(40),
	Ngaylap datetime
)
as
begin
	insert into @SP
	select a.MaSP,TenSP,Ngaylap
				from SANPHAM a , CTPX b, PX c
				where a.MaSP = b.MaSP and b.MaPX = c.MaPX and year(Ngaylap) = @nam
	return
end

select * from dbo.F3('2010') as [DS các sp được xuất trong năm]
drop function dbo.F3
--4.	Function F4 có một tham số vào là mã nhân viên để trả về danh sách các phiếu xuất của nhân viên đó. Nếu mã nhân viên không truyền vào thì trả về tất cả các phiếu xuất.
create function F4
(
	@manv char(5)
)
returns @PX table
(
	MaPX int,
	Ngaylap datetime,
	MaNV char(5)
)
as
begin
		insert into @PX
		select b.MaPX,Ngaylap,a.MaNV
		from NHANVIEN a, PX b, CTPX c
		where a.MaNV = b.MaNV and b.MaPX = c.MaPX and a.MaNV = @manv
		return
end

select * from dbo.F4('NV01')
drop function dbo.F4
--5.	Function F5 để cho biết tên nhân viên của một phiếu xuất có mã phiếu xuất là tham số truyền vào.
create function F5
(
	@mapx int
)
returns nvarchar(40)
as
begin
	declare @tennv varchar(40) 
	set @tennv=(select Hoten from NHANVIEN a,PX b where a.MaNV = b.MaNV and b.MaPX = @mapx)
	return @tennv
end

select dbo.F5(4)
drop function dbo.F5
--6.	Function F6 để cho biết danh sách các phiếu xuất từ ngày T1 đến ngày T2. (T1, T2 là tham số truyền vào). Chú ý: T1 <= T2.
create function F6
(
	@T1 date,
	@T2 date
)
returns @PX table
(
	MaPX int,
	Ngaylap date,
	MaNV char(5)
)
as 
begin
	insert into @PX
	select c.MaPX,Ngaylap,b.MaNV
	from NHANVIEN a, PX b, CTPX c
	where a.MaNV = b.MaNV and b.MaPX = c.MaPX and Ngaylap between @T1 and @T2 and @T1<=@T2
	return
end

select * from dbo.F6 ('2010-02-03','2010-06-16')
drop function dbo.F6
--7.	Function F7 để cho biết ngày xuất của một phiếu xuất với mã phiếu xuất là tham số truyền vào.
create function F7
(
	@mapx int
)
returns date
as
begin
	declare @ngayxuat date
	set @ngayxuat = (select Ngaylap
						from PX a,CTPX b
						where a.MaPX=@mapx and a.MaPX = b.MaPX)
	return @ngayxuat
end

select dbo.F7(2) as [Ngày xuất của 1 phiếu]
drop function dbo.F7

-------------------------PROCEDUCE------------------
--1.	Procedure tên là P1 cho có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong năm 2010 (Không viết lại truy vấn, hãy sử dụng Function F1 ở câu 4 để thực hiện) 
create proc P1
@tensp nvarchar(40)
as
select a.MaSP,TENSP,sum(SL)
from CTPX a, PX b, SANPHAM c
where a.MaPX = b.MaPX and a.MaSP = c.MaSP and year(Ngaylap) = 2010 and TenSP = @tensp
group by a.MaSP,TENSP
	-------------ThucThi-------------
declare @tensp nvarchar(40)
set @tensp = N'Xi Măng'
exec P1 @tensp 
drop proc P1
--2.	Procedure tên là P2 có 2 tham số sau:
--•	1 tham số nhận vào là: tên sản phẩm.
--•	1 tham số trả về cho biết: tổng số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010 (Chú ý: Nếu tên sản phẩm này không tồn tại thì trả về 0)
--3.	Procedure tên là P3 chỉ có duy nhất 1 tham số nhận vào là tên sản phẩm. Trong Procedure này có khai báo 1 biến cục bộ được gán giá trị là: số lượng xuất kho của tên sản phẩm này trong khoảng thời gian từ đầu tháng 4/2010 đến hết tháng 6/2010. Việc gán trị này chỉ được thực hiện bằng cách gọi Procedure P2.
--4.	Procedure P4 để INSERT một record vào trong table LOAI. Giá trị các field là tham số truyền vào.
--5.	Procedure P5 để DELETE một record trong Table NhânViên theo mã nhân viên. Mã NV là tham số truyền vào.

