create database QLHocPhan;
use QLHocPhan;

create table TaiKhoan(
	TenTaiKhoan varchar(30),
    MatKhau varchar(50),
    Loai char(2),
    primary key (TenTaiKhoan)
);

create table GiaoVu(
	MaGVu int AUTO_INCREMENT,
	TenTaiKhoan varchar(30),
    TenGiaoVu nvarchar(30),
    GioiTinh nvarchar(3),
    NgSinh datetime,
    primary key (MaGVu)
);

create table SinhVien(
	MSSV int AUTO_INCREMENT,
	TenTaiKhoan varchar(30),
    HoTen nvarchar(30),
    GioiTinh nvarchar(3),
    NgSinh datetime,
    Khoa nvarchar(30),
    primary key (MSSV)
);
alter table SinhVien auto_increment = 19120001;

create table MonHoc(
	MaMH char(6),
    TenMH nvarchar(40),
    SoTinChi int,
    primary key (MaMH)
);

create table HocKi(
	MaHK int AUTO_INCREMENT,
	TenHocKi char(3),
    NamHoc int,
    NgayBatDau datetime,
    NgayKetThuc datetime,
    primary key (MaHK)
);

create table Hoc(
	MSSV int,
    MaLop varchar(7),
    primary key (MSSV, MaLop)
);

create table LopHoc(
	MaLop varchar(7),
    TongSoSV int,
    TongSoNam int,
    TongSoNu int,
    primary key (MaLop)
);

create table KyDKHP(
	MaHK int,
    Lan int,
    NgayBatDau datetime,
    NgayKetThuc datetime,
    primary key (MaHK, Lan)
);

create table HocPhan(
	MaHP int auto_increment,
	MaMH char(6),
    GVLT int,
    TenPhong char(4),
    Thu nvarchar(3),
    Ca varchar(13),
    SlotToiDa int,
	MaHK int,
    Lan int,
    primary key (MaHP)
);

create table DKHP(
	MSSV int,
    MaHP int,
    ThoiGianDKHP datetime,
    primary key (MSSV, MAHP)
);

create table GiaoVien(
	MaGV int auto_increment,
    TenGV nvarchar(30),
    primary key (MaGV)
);

create table HocKiHienTai(
	id int auto_increment,
	MaHK int,
    primary key(id)
);

alter table GiaoVu add constraint GVNamNu check(GioiTinh in ('Nam', N'Nữ'));
alter table HocPhan add constraint Thu7Ngay check(Thu in (N'Hai', N'Ba', N'Tư', N'Năm', N'Sáu', N'Bảy'));
alter table HocPhan add constraint CaThoiGian check (Ca in ('7:30 – 9:30', '9:30 – 11:30', '13:30 – 15:30', '15:30 – 17:30'));
alter table GiaoVu add constraint FK_GiaoVu_TaiKhoan foreign key(TenTaiKhoan) references TaiKhoan(TenTaiKhoan);
alter table SinhVien add constraint SVNamNu check(GioiTinh in ('Nam', N'Nữ'));
alter table SinhVien add constraint FK_SinhVien_TaiKhoan foreign key(TenTaiKhoan) references TaiKhoan(TenTaiKhoan);
alter table Hoc add constraint FK_Hoc_SinhVien foreign key(MSSV) references SinhVien(MSSV);
alter table Hoc add constraint FK_Hoc_LopHoc foreign key(MaLop) references LopHoc(MaLop);
alter table KyDKHP add constraint FK_KyDKHP_HocKi foreign key(MaHK) references HocKi(MaHK);
alter table HocPhan add constraint FK_HocPhan_MonHoc foreign key(MaMH) references MonHoc(MaMH);
alter table HocPhan add constraint FK_HocPhan_KyDKHP foreign key(MaHK, Lan) references KyDKHP(MaHK, Lan);
alter table HocPhan add constraint FK_HocPhan_GiaoVien foreign key(GVLT) references GiaoVien(MaGV);
alter table DKHP add constraint FK_DKHP_SinhVien foreign key(MSSV) references SinhVien(MSSV);
alter table DKHP add constraint FK_DKHP_HocPhan foreign key(MaHP) references HocPhan(MaHP);
alter table HocKiHienTai add constraint FK_HKHT_HK foreign key(MaHK) references HocKi(MaHK);

insert into TaiKhoan values('gvu1', '21232f297a57a5a743894a0e4a801fc3', 'GV');
insert into TaiKhoan values('gvu2', '21232f297a57a5a743894a0e4a801fc3', 'GV');
insert into TaiKhoan values('gvu3', '21232f297a57a5a743894a0e4a801fc3', 'GV');
insert into TaiKhoan values('19120001', '6903d0aa97f72d07c7deec92d0106857', 'SV');
insert into TaiKhoan values('19120002', '68e96060464c72663b3e061090f1db72', 'SV');
insert into TaiKhoan values('19120003', 'a0a0c43209892e4eb5298d14695d3664', 'SV');
insert into TaiKhoan values('19120004', '41f76acb41d773230d50c548f45279b2', 'SV');
insert into TaiKhoan values('19120005', '5cb40da88eeb3695e097b878ffa71649', 'SV');

insert into GiaoVu(TenTaiKhoan, TenGiaoVu, GioiTinh, NgSinh) values('gvu1', N'Nguyễn Thị 1', N'Nữ', '1980/01/01');
insert into GiaoVu(TenTaiKhoan, TenGiaoVu, GioiTinh, NgSinh) values('gvu2', N'Nguyễn Văn 2', 'Nam', '1975/01/31');
insert into GiaoVu(TenTaiKhoan, TenGiaoVu, GioiTinh, NgSinh) values('gvu3', N'Trần Tiến 3', 'Nam', '1972/05/26');

insert into SinhVien(TenTaiKhoan, HoTen, GioiTinh, NgSinh, Khoa) values('19120001', N'Đỗ Văn A', 'Nam', '2000/01/01', N'Công nghệ thông tin');
insert into SinhVien(TenTaiKhoan, HoTen, GioiTinh, NgSinh, Khoa) values('19120002', N'Đinh Thị B', N'Nữ', '2001/05/04', N'Công nghệ thông tin');
insert into SinhVien(TenTaiKhoan, HoTen, GioiTinh, NgSinh, Khoa) values('19120003', N'Vũ Văn C', 'Nam', '1998/06/29', N'Toán tin');
insert into SinhVien(TenTaiKhoan, HoTen, GioiTinh, NgSinh, Khoa) values('19120004', N'Trần Văn D', 'Nam', '1999/03/17', N'Công nghệ thông tin');
insert into SinhVien(TenTaiKhoan, HoTen, GioiTinh, NgSinh, Khoa) values('19120005', N'Võ Mỹ E', N'Nữ', '2002/04/25', N'Công nghệ thông tin');

insert into MonHoc values('CSC101', N'Nhập môn lập trình', 4);
insert into MonHoc values('MTH003', N'Vi tích phân 1B', 3);
insert into MonHoc values('CSC102', N'Kỹ thuật lập trình', 4);
insert into MonHoc values('CSC103', N'Phương pháp lập trình hướng đối tượng', 4);
insert into MonHoc values('CSC104', N'Cấu trúc dữ liệu và giải thuật', 4);
insert into MonHoc values('MTH041', N'Toán rời rạc', 3);
insert into MonHoc values('MTH030', N'Đại số tuyến tính', 3);
insert into MonHoc values('PHY002', N'Vật lý đại cương 2', 3);
insert into MonHoc values('CSC108', N'Mạng máy tính', 4);
insert into MonHoc values('CSC106', N'Cơ sở dữ liệu', 4);

insert into HocKi(TenHocKi, NamHoc, NgayBatDau, NgayKetThuc) values('HK1', 2021, '2020/10/12', '2021/02/01');
insert into HocKi(TenHocKi, NamHoc, NgayBatDau, NgayKetThuc) values('HK2', 2021, '2021/03/08', '2021/06/01');
insert into HocKi(TenHocKi, NamHoc, NgayBatDau, NgayKetThuc) values('HK3', 2021, '2021/07/01', '2021/10/01');

insert into HocKiHienTai(MaHK) values(2);

insert into LopHoc values('19CTT1', 100, 81, 19);
insert into LopHoc values('19TTH', 120, 85, 35);
insert into LopHoc values('19CTT2', 120, 87, 33);

insert into Hoc(MSSV, MaLop) values('19120001', '19CTT1');
insert into Hoc(MSSV, MaLop) values('19120002', '19CTT2');
insert into Hoc(MSSV, MaLop) values('19120003', '19TTH');
insert into Hoc(MSSV, MaLop) values('19120004', '19CTT1');
insert into Hoc(MSSV, MaLop) values('19120005', '19CTT2');

insert into KyDKHP(MaHK, Lan, NgayBatDau, NgayKetThuc) values(1, 1, '2020/10/1', '2020/10/10');
insert into KyDKHP(MaHK, Lan, NgayBatDau, NgayKetThuc) values(2, 1, '2021/02/20', '2021/03/01');
insert into KyDKHP(MaHK, Lan ,NgayBatDau, NgayKetThuc) values(3, 1, '2021/06/08', '2021/06/25');
insert into KyDKHP(MaHK, Lan ,NgayBatDau, NgayKetThuc) values(3, 2, '2021/07/01', '2021/07/26');
insert into KyDKHP(MaHK, Lan ,NgayBatDau, NgayKetThuc) values(2, 2, '2021/04/15', '2021/05/10');

insert into GiaoVien(TenGV) values(N'Nguyễn Lê Hoàng Dũng');
insert into GiaoVien(TenGV) values(N'Lê Văn Chánh');
insert into GiaoVien(TenGV) values(N'Nguyễn Minh Huy');
insert into GiaoVien(TenGV) values(N'Phạm Nguyễn Sơn Tùng');
insert into GiaoVien(TenGV) values(N'Bùi Tiến Lên');
insert into GiaoVien(TenGV) values(N'Hồ Tuấn Thanh');
insert into GiaoVien(TenGV) values(N'Lê Văn Hợp');
insert into GiaoVien(TenGV) values(N'Lê Nguyễn Hoài Nam');
insert into GiaoVien(TenGV) values(N'Huỳnh Thuỵ Bảo Trân');
insert into GiaoVien(TenGV) values(N'Nguyễn Văn Thuận');
insert into GiaoVien(TenGV) values(N'Nguyễn Văn Thuận');
insert into GiaoVien(TenGV) values(N'Nguyễn Khánh Tùng');

insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC101', 1, 'E302', 'Hai', '7:30 – 9:30', 100, 1, 1);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('MTH003', 2, 'E204', 'Tư', '13:30 – 15:30', 120, 2, 1);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC102', 3, 'F202', 'Năm', '15:30 – 17:30', 100, 3, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC103', 4, 'F203', 'Sáu', '9:30 – 11:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC104', 5, 'F105', 'Ba', '15:30 – 17:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('MTH041', 11, 'F105', 'Ba', '15:30 – 17:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('MTH030', 7, 'F105', 'Tư', '15:30 – 17:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('PHY002', 10, 'F105', 'Hai', '15:30 – 17:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC108', 9, 'F104', 'Bảy', '7:30 – 9:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC106', 8, 'E201', 'Sáu', '9:30 – 11:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC104', 5, 'F204', 'Ba', '7:30 – 9:30', 100, 2, 2);
insert into HocPhan(MaMH, GVLT, TenPhong, Thu, Ca, SlotToiDa, MaHK, Lan) values('CSC102', 6, 'F302', 'Năm', '9:30 – 11:30', 100, 2, 2);

insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120001, 1, '2020/10/3');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120002, 3, '2021/02/21');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120003, 4, '2021/06/9');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120004, 2, '2020/10/2');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120005, 5, '2020/10/1');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120001, 4, '2021/06/10');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120002, 1, '2020/10/4');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120003, 5, '2020/10/3');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120004, 3, '2021/02/23');
insert into DKHP(MSSV, MaHP, ThoiGianDKHP) values(19120005, 2, '2020/10/5');