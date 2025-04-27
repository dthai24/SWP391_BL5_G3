USE [master]
GO
CREATE DATABASE [SWP391_BL5_G3]
GO

USE [SWP391_BL5_G3]
GO

-- Bảng: BookingRoomInventoryChecks
-- Mục đích: Ghi lại việc kiểm tra vật tư/trang thiết bị trong phòng khi khách check-in/check-out.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingRoomInventoryChecks](
	[CheckID] [int] IDENTITY(1,1) NOT NULL,
	[BookingRoomID] [int] NOT NULL, -- Liên kết đến phòng cụ thể trong một booking
	[ItemID] [int] NOT NULL, -- Liên kết đến vật tư/trang thiết bị
	[CheckType] [nvarchar](10) NOT NULL, -- Loại kiểm tra (CheckIn / CheckOut)
	[ItemStatus] [nvarchar](50) NOT NULL, -- Tình trạng vật tư (Present / Missing / Damaged)
	[QuantityChecked] [int] NULL, -- Số lượng kiểm tra (nếu cần)
	[ChargeApplied] [decimal](10, 2) NULL, -- Phí phạt nếu vật tư bị hỏng/mất
	[Notes] [nvarchar](max) NULL, -- Ghi chú thêm
	[CheckedByUserID] [int] NULL, -- ID Nhân viên thực hiện kiểm tra (FK -> Employees)
	[CheckTimestamp] [datetime] NULL, -- Thời điểm kiểm tra
PRIMARY KEY CLUSTERED
(
	[CheckID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng: BookingRooms
-- Mục đích: Liên kết giữa một Đặt phòng (Booking) và các Phòng (Room) cụ thể được đặt. Lưu giá phòng tại thời điểm đặt.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingRooms](
	[BookingRoomID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL, -- Liên kết đến Đặt phòng
	[RoomID] [int] NOT NULL, -- Liên kết đến Phòng
	[PriceAtBooking] [decimal](10, 2) NULL, -- Giá phòng tại thời điểm đặt
PRIMARY KEY CLUSTERED
(
	[BookingRoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: Bookings
-- Mục đích: Lưu thông tin chính về các lượt đặt phòng của khách hàng.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bookings](
	[BookingID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL, -- ID Khách hàng đặt phòng (FK -> Customers)
	[CheckInDate] [datetime] NOT NULL, -- Ngày nhận phòng
	[CheckOutDate] [datetime] NOT NULL, -- Ngày trả phòng
	[NumberOfGuests] [int] NOT NULL, -- Số lượng khách
	[Notes] [nvarchar](max) NULL, -- Ghi chú của khách hàng hoặc nhân viên
	[TotalPrice] [decimal](12, 2) NULL, -- Tổng tiền dự kiến/thanh toán
	[Status] [nvarchar](50) NOT NULL, -- Trạng thái đặt phòng (Pending, Confirmed, Cancelled, Completed)
	[BookingDate] [datetime] NULL, -- Ngày thực hiện đặt phòng
	[UpdatedAt] [datetime] NULL, -- Thời điểm cập nhật cuối cùng
	[IsDeleted] [bit] NOT NULL, -- Cờ đánh dấu xóa mềm
	[CreatedByUserID] [int] NOT NULL, -- ID Người dùng (Customer/Employee) tạo booking này (FK -> Users)
PRIMARY KEY CLUSTERED
(
	[BookingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng: BookingServices
-- Mục đích: Lưu thông tin về các Dịch vụ (Service) được khách hàng sử dụng trong một Đặt phòng (Booking).
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingServices](
	[BookingServiceID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL, -- Liên kết đến Đặt phòng
	[ServiceID] [int] NOT NULL, -- Liên kết đến Dịch vụ
	[Quantity] [int] NOT NULL, -- Số lượng dịch vụ sử dụng
	[PriceAtBooking] [decimal](10, 2) NOT NULL, -- Giá dịch vụ tại thời điểm đặt/sử dụng
	[ServiceDate] [datetime] NULL, -- Ngày sử dụng dịch vụ
PRIMARY KEY CLUSTERED
(
	[BookingServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: Feedbacks
-- Mục đích: Lưu trữ phản hồi, đánh giá của Khách hàng về lượt đặt phòng và phản hồi từ Nhân viên.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedbacks](
	[FeedbackID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NULL, -- Liên kết đến Đặt phòng (có thể NULL nếu phản hồi chung)
	[CustomerID] [int] NOT NULL, -- ID Khách hàng gửi phản hồi (FK -> Customers)
	[Rating] [int] NULL, -- Điểm đánh giá (1-5)
	[Comment] [nvarchar](max) NULL, -- Nội dung bình luận
	[SubmissionDate] [datetime] NULL, -- Ngày gửi
	[IsApproved] [bit] NULL, -- Trạng thái phê duyệt (để hiển thị công khai)
	[Response] [nvarchar](max) NULL, -- Nội dung phản hồi từ nhân viên
	[RespondedByUserID] [int] NULL, -- ID Nhân viên phản hồi (FK -> Employees)
	[ResponseDate] [datetime] NULL, -- Ngày phản hồi
	[IsDeleted] [bit] NOT NULL, -- Cờ đánh dấu xóa mềm
PRIMARY KEY CLUSTERED
(
	[FeedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng: InventoryItems
-- Mục đích: Danh mục các vật tư, trang thiết bị có trong phòng hoặc khách sạn.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryItems](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [nvarchar](100) NOT NULL, -- Tên vật tư
	[Description] [nvarchar](max) NULL, -- Mô tả
	[DefaultCharge] [decimal](10, 2) NULL, -- Phí phạt mặc định nếu hỏng/mất
	[IsDeleted] [bit] NOT NULL, -- Cờ đánh dấu xóa mềm
PRIMARY KEY CLUSTERED
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng: PasswordResetTokens
-- Mục đích: Lưu trữ token dùng cho chức năng quên/đặt lại mật khẩu.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PasswordResetTokens](
	[TokenID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL, -- ID Người dùng yêu cầu reset (FK -> Users)
	[TokenValue] [nvarchar](255) NOT NULL, -- Giá trị token (duy nhất)
	[ExpiryDate] [datetime] NOT NULL, -- Thời gian hết hạn token
	[IsUsed] [bit] NOT NULL, -- Đánh dấu token đã được sử dụng hay chưa
	[CreatedAt] [datetime] NULL, -- Thời điểm tạo token
PRIMARY KEY CLUSTERED
(
	[TokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: Payments
-- Mục đích: Ghi lại thông tin các giao dịch thanh toán cho Đặt phòng.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL, -- Liên kết đến Đặt phòng được thanh toán
	[Amount] [decimal](12, 2) NOT NULL, -- Số tiền thanh toán
	[PaymentMethod] [nvarchar](50) NOT NULL, -- Phương thức thanh toán (Cash, Credit Card, Bank Transfer,...)
	[PaymentStatus] [nvarchar](50) NOT NULL, -- Trạng thái thanh toán (Pending, Completed, Failed, Refunded)
	[TransactionID] [nvarchar](255) NULL, -- Mã giao dịch (nếu có)
	[PaymentDate] [datetime] NULL, -- Ngày thanh toán
	[ProcessedByUserID] [int] NULL, -- ID Nhân viên xử lý thanh toán (FK -> Employees)
PRIMARY KEY CLUSTERED
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: RoomCategories
-- Mục đích: Định nghĩa các loại phòng khác nhau trong khách sạn.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomCategories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL, -- Tên loại phòng (Premium, Deluxe,...)
	[Description] [nvarchar](max) NULL, -- Mô tả loại phòng
	[BasePricePerNight] [decimal](10, 2) NOT NULL, -- Giá cơ bản mỗi đêm
	[Capacity] [int] NOT NULL, -- Sức chứa tối đa
	[IsDeleted] [bit] NOT NULL, -- Cờ đánh dấu xóa mềm
PRIMARY KEY CLUSTERED
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng: RoomCategoryInventory
-- Mục đích: Xác định số lượng vật tư mặc định cho mỗi loại phòng.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomCategoryInventory](
	[RoomCategoryInventoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL, -- Liên kết đến Loại phòng
	[ItemID] [int] NOT NULL, -- Liên kết đến Vật tư
	[DefaultQuantity] [int] NOT NULL, -- Số lượng mặc định của vật tư trong loại phòng này
PRIMARY KEY CLUSTERED
(
	[RoomCategoryInventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: RoomImages
-- Mục đích: Lưu trữ đường dẫn hình ảnh cho các Loại phòng.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomImages](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[RoomCategoryID] [int] NOT NULL, -- Liên kết đến Loại phòng
	[ImageUrl] [nvarchar](255) NOT NULL, -- Đường dẫn đến file ảnh
	[IsMain] [bit] NOT NULL, -- Đánh dấu ảnh đại diện chính
	[UploadedAt] [datetime] NULL, -- Thời điểm tải ảnh lên
PRIMARY KEY CLUSTERED
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: Rooms
-- Mục đích: Danh sách các phòng cụ thể trong khách sạn.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rooms](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[RoomNumber] [nvarchar](20) NOT NULL, -- Số phòng (duy nhất)
	[CategoryID] [int] NOT NULL, -- Liên kết đến Loại phòng
	[VacancyStatus] [nvarchar](20) NOT NULL, -- Trạng thái phòng (Vacant / Occupied)
	[Description] [nvarchar](max) NULL, -- Mô tả chi tiết về phòng cụ thể
	[PriceOverride] [decimal](10, 2) NULL, -- Giá riêng cho phòng này (nếu khác giá loại phòng)
	[CreatedAt] [datetime] NULL, -- Ngày tạo bản ghi phòng
	[UpdatedAt] [datetime] NULL, -- Ngày cập nhật cuối
	[IsDeleted] [bit] NOT NULL, -- Cờ đánh dấu xóa mềm
PRIMARY KEY CLUSTERED
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng: Services
-- Mục đích: Danh mục các dịch vụ phụ trợ mà khách sạn cung cấp.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[ServiceID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [nvarchar](100) NOT NULL, -- Tên dịch vụ
	[Description] [nvarchar](max) NULL, -- Mô tả dịch vụ
	[Price] [decimal](10, 2) NOT NULL, -- Giá dịch vụ
	[ImageURL] [nvarchar](255) NULL, -- Đường dẫn ảnh minh họa
	[IsAvailable] [bit] NULL, -- Trạng thái sẵn có của dịch vụ
	[CreatedAt] [datetime] NULL, -- Ngày tạo bản ghi dịch vụ
	[UpdatedAt] [datetime] NULL, -- Ngày cập nhật cuối
	[IsDeleted] [bit] NOT NULL, -- Cờ đánh dấu xóa mềm
PRIMARY KEY CLUSTERED
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Bảng: Users
-- Mục đích: Lưu trữ thông tin chung và thông tin đăng nhập cho tất cả người dùng (Khách hàng và Nhân viên).
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NOT NULL, -- Tên đăng nhập (duy nhất)
	[Password] [nvarchar](255) NOT NULL, -- Mật khẩu (nên được mã hóa)
	[FullName] [nvarchar](150) NOT NULL, -- Họ và tên đầy đủ
	[Email] [nvarchar](150) NOT NULL, -- Email (duy nhất)
	[PhoneNumber] [nvarchar](20) NULL, -- Số điện thoại
	[Address] [nvarchar](255) NULL, -- Địa chỉ
	[ProfilePictureURL] [nvarchar](255) NULL, -- Đường dẫn ảnh đại diện
	[Status] [nvarchar](20) NOT NULL, -- Trạng thái tài khoản (Active / Inactive)
	[RegistrationDate] [datetime] NULL, -- Ngày đăng ký
	[IsDeleted] [bit] NOT NULL, -- Cờ đánh dấu xóa mềm
PRIMARY KEY CLUSTERED
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: Customers
-- Mục đích: Lưu thông tin định danh Khách hàng, kế thừa từ bảng Users.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] NOT NULL, -- ID Khách hàng (PK, FK -> Users)
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Bảng: Employees
-- Mục đích: Lưu thông tin định danh Nhân viên và vai trò, kế thừa từ bảng Users.
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] NOT NULL, -- ID Nhân viên (PK, FK -> Users)
	[EmployeeRole] [nvarchar](50) NOT NULL, -- Vai trò nhân viên (Admin, Manager, Receptionist, Staff)
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- =============================================
-- == CHÈN DỮ LIỆU MẪU (SAMPLE DATA INSERTION) ==
-- =============================================
-- (Dữ liệu mẫu cho BookingRooms)
SET IDENTITY_INSERT [dbo].[BookingRooms] ON
GO
INSERT [dbo].[BookingRooms] ([BookingRoomID], [BookingID], [RoomID], [PriceAtBooking]) VALUES (1, 6, 5, CAST(125.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[BookingRooms] ([BookingRoomID], [BookingID], [RoomID], [PriceAtBooking]) VALUES (2, 7, 3, CAST(160.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[BookingRooms] ([BookingRoomID], [BookingID], [RoomID], [PriceAtBooking]) VALUES (3, 8, 10, CAST(180.00 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[BookingRooms] OFF
GO
-- (Dữ liệu mẫu cho Bookings)
SET IDENTITY_INSERT [dbo].[Bookings] ON
GO
INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Notes], [TotalPrice], [Status], [BookingDate], [UpdatedAt], [IsDeleted], [CreatedByUserID]) 
VALUES (1, 6, CAST(N'2025-04-23T14:00:00' AS DateTime), CAST(N'2025-04-26T12:00:00' AS DateTime), 4, N'', CAST(0.00 AS Decimal(12, 2)), N'Cancelled', CAST(N'2025-04-21T14:34:40.727' AS DateTime), CAST(N'2025-04-21T14:34:40.727' AS DateTime), 0, 6)
GO
INSERT [dbo].[Bookings] 
VALUES (2, 6, CAST(N'2025-04-24T14:00:00' AS DateTime), CAST(N'2025-04-27T12:00:00' AS DateTime), 5, N'', CAST(0.00 AS Decimal(12, 2)), N'Confirmed', CAST(N'2025-04-21T14:40:52.270' AS DateTime), CAST(N'2025-04-21T14:40:52.270' AS DateTime), 0, 6)
GO
INSERT [dbo].[Bookings] 
VALUES (3, 11, CAST(N'2025-04-22T14:00:00' AS DateTime), CAST(N'2025-04-24T12:00:00' AS DateTime), 3, N'', CAST(0.00 AS Decimal(12, 2)), N'Cancelled', CAST(N'2025-04-21T14:49:49.760' AS DateTime), CAST(N'2025-04-21T14:49:49.760' AS DateTime), 0, 11)
GO
INSERT [dbo].[Bookings] 
VALUES (4, 10, CAST(N'2025-04-23T14:00:00' AS DateTime), CAST(N'2025-04-30T12:00:00' AS DateTime), 3, N'', CAST(0.00 AS Decimal(12, 2)), N'Completed', CAST(N'2025-04-21T14:53:25.517' AS DateTime), CAST(N'2025-04-21T14:53:25.517' AS DateTime), 0, 10)
GO
INSERT [dbo].[Bookings] 
VALUES (5, 10, CAST(N'2025-04-22T14:00:00' AS DateTime), CAST(N'2025-04-23T12:00:00' AS DateTime), 3, N'', CAST(0.00 AS Decimal(12, 2)), N'Confirmed', CAST(N'2025-04-21T14:56:05.167' AS DateTime), CAST(N'2025-04-21T14:56:05.167' AS DateTime), 0, 10)
GO
INSERT [dbo].[Bookings] 
VALUES (6, 6, CAST(N'2025-04-23T14:00:00' AS DateTime), CAST(N'2025-04-25T12:00:00' AS DateTime), 1, N'', CAST(250.00 AS Decimal(12, 2)), N'Confirmed', CAST(N'2025-04-21T15:00:57.940' AS DateTime), CAST(N'2025-04-21T15:01:13.820' AS DateTime), 0, 6)
GO
INSERT [dbo].[Bookings] 
VALUES (7, 11, CAST(N'2025-04-23T14:00:00' AS DateTime), CAST(N'2025-04-30T12:00:00' AS DateTime), 3, N'', CAST(1145.00 AS Decimal(12, 2)), N'Confirmed', CAST(N'2025-04-21T15:07:59.277' AS DateTime), CAST(N'2025-04-21T15:09:45.910' AS DateTime), 0, 11)
GO
INSERT [dbo].[Bookings] 
VALUES (8, 6, CAST(N'2025-04-26T14:00:00' AS DateTime), CAST(N'2025-04-28T12:00:00' AS DateTime), 2, N'', CAST(375.00 AS Decimal(12, 2)), N'Pending', CAST(N'2025-04-21T15:10:13.087' AS DateTime), CAST(N'2025-04-21T15:10:39.097' AS DateTime), 0, 6)
GO
INSERT [dbo].[Bookings] 
VALUES (9, 6, CAST(N'2025-04-21T14:00:00' AS DateTime), CAST(N'2025-04-22T12:00:00' AS DateTime), 1, N'', CAST(0.00 AS Decimal(12, 2)), N'Cancelled', CAST(N'2025-04-21T15:14:16.723' AS DateTime), CAST(N'2025-04-21T15:14:17.653' AS DateTime), 0, 6)
GO
INSERT [dbo].[Bookings] 
VALUES (10, 11, CAST(N'2025-04-23T14:00:00' AS DateTime), CAST(N'2025-04-26T12:00:00' AS DateTime), 2, N'', CAST(0.00 AS Decimal(12, 2)), N'Pending', CAST(N'2025-04-21T15:14:35.950' AS DateTime), CAST(N'2025-04-21T15:14:37.003' AS DateTime), 0, 11)
GO
INSERT [dbo].[Bookings] 
VALUES (11, 11, CAST(N'2025-04-23T14:00:00' AS DateTime), CAST(N'2025-04-27T12:00:00' AS DateTime), 2, N'', CAST(0.00 AS Decimal(12, 2)), N'Pending', CAST(N'2025-04-21T15:14:51.380' AS DateTime), CAST(N'2025-04-21T15:14:52.417' AS DateTime), 0, 11)
GO
INSERT [dbo].[Bookings] 
VALUES (12, 6, CAST(N'2025-04-23T14:00:00' AS DateTime), CAST(N'2025-04-26T12:00:00' AS DateTime), 2, N'', CAST(0.00 AS Decimal(12, 2)), N'Pending', CAST(N'2025-04-21T16:22:22.223' AS DateTime), CAST(N'2025-04-21T16:22:22.223' AS DateTime), 0, 6)
GO
SET IDENTITY_INSERT [dbo].[Bookings] OFF
GO
-- (Dữ liệu mẫu cho BookingServices)
SET IDENTITY_INSERT [dbo].[BookingServices] ON
GO
INSERT [dbo].[BookingServices] ([BookingServiceID], [BookingID], [ServiceID], [Quantity], [PriceAtBooking], [ServiceDate]) VALUES (1, 7, 2, 1, CAST(25.00 AS Decimal(10, 2)), CAST(N'2025-04-21T15:09:44.453' AS DateTime))
GO
INSERT [dbo].[BookingServices] ([BookingServiceID], [BookingID], [ServiceID], [Quantity], [PriceAtBooking], [ServiceDate]) VALUES (2, 8, 8, 1, CAST(15.00 AS Decimal(10, 2)), CAST(N'2025-04-21T15:10:26.180' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[BookingServices] OFF
GO
-- (Dữ liệu mẫu cho Customers)
INSERT [dbo].[Customers] ([CustomerID]) VALUES (6)
GO
INSERT [dbo].[Customers] ([CustomerID]) VALUES (10)
GO
INSERT [dbo].[Customers] ([CustomerID]) VALUES (11)
GO
-- (Dữ liệu mẫu cho Employees)
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeRole]) VALUES (1, N'Admin')
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeRole]) VALUES (3, N'Manager')
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeRole]) VALUES (4, N'Receptionist')
GO
INSERT [dbo].[Employees] ([EmployeeID], [EmployeeRole]) VALUES (5, N'Staff')
GO
-- (Dữ liệu mẫu cho InventoryItems)
SET IDENTITY_INSERT [dbo].[InventoryItems] ON
GO
INSERT [dbo].[InventoryItems] ([ItemID], [ItemName], [Description], [DefaultCharge], [IsDeleted]) VALUES (1, N'Bath Towel', N'Standard white bath towel', CAST(15.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[InventoryItems] ([ItemID], [ItemName], [Description], [DefaultCharge], [IsDeleted]) VALUES (2, N'Hand Towel', N'Standard white hand towel', CAST(8.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[InventoryItems] ([ItemID], [ItemName], [Description], [DefaultCharge], [IsDeleted]) VALUES (3, N'TV Remote', N'Remote control for television', CAST(25.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[InventoryItems] ([ItemID], [ItemName], [Description], [DefaultCharge], [IsDeleted]) VALUES (4, N'Kettle', N'Electric kettle', CAST(30.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[InventoryItems] ([ItemID], [ItemName], [Description], [DefaultCharge], [IsDeleted]) VALUES (5, N'Minibar - Coke', N'Can of Coca-Cola from minibar', CAST(3.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[InventoryItems] ([ItemID], [ItemName], [Description], [DefaultCharge], [IsDeleted]) VALUES (6, N'Minibar - Water', N'Bottle of water from minibar', CAST(2.00 AS Decimal(10, 2)), 0)
GO
SET IDENTITY_INSERT [dbo].[InventoryItems] OFF
GO
-- (Dữ liệu mẫu cho RoomCategories)
SET IDENTITY_INSERT [dbo].[RoomCategories] ON
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [Capacity], [IsDeleted]) VALUES (1, N'Phòng Cao Cấp', N'Phòng cao cấp với giường king size', CAST(200.00 AS Decimal(10, 2)), 2, 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [Capacity], [IsDeleted]) VALUES (2, N'Phòng Hạng Sang', N'Phòng hang sang tiện nghi', CAST(150.00 AS Decimal(10, 2)), 2, 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [Capacity], [IsDeleted]) VALUES (3, N'Phòng Đôi', N'Phòng đôi dành cho hai người', CAST(120.00 AS Decimal(10, 2)), 2, 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [Capacity], [IsDeleted]) VALUES (4, N'Phòng Sang Trọng', N'Phòng sang trọng với dịch vụ cao cấp', CAST(250.00 AS Decimal(10, 2)), 4, 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [Capacity], [IsDeleted]) VALUES (5, N'Phòng Ba Người ', N'Phòng dành cho ba người ', CAST(180.00 AS Decimal(10, 2)), 3, 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [Capacity], [IsDeleted]) VALUES (6, N'Phòng Nhỏ Có Cửa Sổ', N'Phòng nhỏ có cửa sổ nhìn ra cảnh quan', CAST(100.00 AS Decimal(10, 2)), 1, 0)
GO
SET IDENTITY_INSERT [dbo].[RoomCategories] OFF
GO
-- (Dữ liệu mẫu cho Rooms)
SET IDENTITY_INSERT [dbo].[Rooms] ON
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, N'101', 1, N'Vacant', N'Phòng Premium King tầng trệt, gần sảnh chính', CAST(210.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, N'102', 1, N'Occupied', N'Phòng Premium King có ban công rộng', CAST(220.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, N'201', 2, N'Occupied', N'Deluxe Room với view hồ bơi', CAST(160.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, N'202', 2, N'Occupied', N'Deluxe Room nội khu yên tĩnh', CAST(155.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, N'301', 3, N'Occupied', N'Double Room với 2 giường đơn', CAST(125.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, N'302', 3, N'Occupied', N'Double Room có góc học tập', CAST(130.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, N'401', 4, N'Vacant', N'Luxury Room tầng cao, trang bị hiện đại', CAST(260.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, N'402', 4, N'Vacant', N'Luxury Room có bồn tắm jacuzzi', CAST(270.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, N'501', 5, N'Occupied', N'Room With View nhìn ra biển', CAST(185.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, N'502', 5, N'Occupied', N'Room With View hướng đồi thông', CAST(180.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, N'601', 6, N'Vacant', N'Small View Room tiện nghi gọn nhẹ', CAST(105.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (12, N'602', 6, N'Occupied', N'Small View Room dành cho khách công tác', CAST(110.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (13, N'303', 4, N'Vacant', N'123', CAST(120.00 AS Decimal(10, 2)), CAST(N'2025-04-21T15:50:56.023' AS DateTime), CAST(N'2025-04-21T15:50:56.023' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Rooms] OFF
GO
-- (Dữ liệu mẫu cho Services)
SET IDENTITY_INSERT [dbo].[Services] ON
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, N'Room Cleaning', N'Daily room cleaning service with fresh towels and bed linen.', CAST(15.00 AS Decimal(10, 2)), N'/images/services/room-cleaning.jpg', 1, CAST(N'2025-04-21T15:09:34.197' AS DateTime), CAST(N'2025-04-21T15:09:34.197' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, N'Breakfast Buffet', N'All-you-can-eat breakfast buffet with local and international cuisine.', CAST(25.00 AS Decimal(10, 2)), N'/images/services/breakfast-buffet.jpg', 1, CAST(N'2025-04-21T15:09:34.213' AS DateTime), CAST(N'2025-04-21T15:09:34.213' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, N'Laundry Service', N'Same-day laundry and ironing service for guest clothing.', CAST(30.00 AS Decimal(10, 2)), N'/images/services/laundry.jpg', 1, CAST(N'2025-04-21T15:09:34.217' AS DateTime), CAST(N'2025-04-21T15:09:34.217' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, N'Spa Treatment', N'Relaxing massage and spa treatments by professional therapists.', CAST(80.00 AS Decimal(10, 2)), N'/images/services/spa.jpg', 1, CAST(N'2025-04-21T15:09:34.217' AS DateTime), CAST(N'2025-04-21T15:09:34.217' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, N'Airport Transfer', N'Comfortable transport service between the hotel and airport.', CAST(45.00 AS Decimal(10, 2)), N'/images/services/airport-transfer.jpg', 1, CAST(N'2025-04-21T15:09:34.220' AS DateTime), CAST(N'2025-04-21T15:09:34.220' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, N'Room Service', N'Food and beverage service delivered directly to your room.', CAST(10.00 AS Decimal(10, 2)), N'/images/services/room-service.jpg', 1, CAST(N'2025-04-21T15:09:34.223' AS DateTime), CAST(N'2025-04-21T15:09:34.223' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, N'Guided City Tour', N'Half-day tour of local attractions with a knowledgeable guide.', CAST(50.00 AS Decimal(10, 2)), N'/images/services/city-tour.jpg', 1, CAST(N'2025-04-21T15:09:34.227' AS DateTime), CAST(N'2025-04-21T15:09:34.227' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, N'Gym Access', N'24/7 access to our fully equipped fitness center.', CAST(15.00 AS Decimal(10, 2)), N'/images/services/gym.jpg', 1, CAST(N'2025-04-21T15:09:34.227' AS DateTime), CAST(N'2025-04-21T15:09:34.227' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, N'Business Center', N'Access to computers, printers and meeting facilities.', CAST(25.00 AS Decimal(10, 2)), N'/images/services/business-center.jpg', 1, CAST(N'2025-04-21T15:09:34.230' AS DateTime), CAST(N'2025-04-21T15:09:34.230' AS DateTime), 0)
GO
INSERT [dbo].[Services] ([ServiceID], [ServiceName], [Description], [Price], [ImageURL], [IsAvailable], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, N'Childcare Service', N'Professional childcare service for children aged 3-12 years.', CAST(35.00 AS Decimal(10, 2)), N'/images/services/childcare.jpg', 1, CAST(N'2025-04-21T15:09:34.230' AS DateTime), CAST(N'2025-04-21T15:09:34.230' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Services] OFF
GO
-- (Dữ liệu mẫu cho Users)
SET IDENTITY_INSERT [dbo].[Users] ON
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (1, N'admin_user', N'123456', N'Administrator', N'admin@yourhotel.com', NULL, NULL, NULL, N'Active', CAST(N'2025-04-21T14:29:46.667' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (3, N'manager_user', N'123456', N'Hotel Manager', N'manager@yourhotel.com', NULL, NULL, NULL, N'Active', CAST(N'2025-04-21T14:33:59.197' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (4, N'reception_user', N'123456', N'Reception Desk', N'reception@yourhotel.com', NULL, NULL, NULL, N'Active', CAST(N'2025-04-21T14:33:59.213' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (5, N'staff_user', N'123456', N'General Staff', N'staff@yourhotel.com', N'1234567891', N'123 abc', N'', N'Inactive', CAST(N'2025-04-21T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (6, N'customer_user', N'123456', N'Valued Customer', N'customer@email.com', NULL, NULL, NULL, N'Active', CAST(N'2025-04-21T14:33:59.227' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (10, N'abc', N'123', N'abc', N'abc@gmail.com', N'123456798', N'123 abc', NULL, N'Active', CAST(N'2025-04-21T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (11, N'nghiant', N'123456', N'Nghia Nguyen', N'nghianthe150495@fpt.edu.vn', N'123456789', N'123 abc', NULL, N'Active', CAST(N'2025-04-21T00:00:00.000' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO

-- =============================================
-- == ĐỊNH NGHĨA INDEX VÀ UNIQUE CONSTRAINTS ==
-- =============================================
ALTER TABLE [dbo].[BookingRooms] ADD CONSTRAINT [UQ_Booking_Room] UNIQUE NONCLUSTERED
(
	[BookingID] ASC,
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[InventoryItems] ADD UNIQUE NONCLUSTERED
(
	[ItemName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[PasswordResetTokens] ADD UNIQUE NONCLUSTERED
(
	[TokenValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RoomCategoryInventory] ADD CONSTRAINT [UQ_RoomCategory_Item] UNIQUE NONCLUSTERED
(
	[CategoryID] ASC,
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Rooms] ADD UNIQUE NONCLUSTERED
(
	[RoomNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

-- =============================================
-- == ĐỊNH NGHĨA DEFAULT CONSTRAINTS        ==
-- =============================================
ALTER TABLE [dbo].[BookingRoomInventoryChecks] ADD  DEFAULT (getdate()) FOR [CheckTimestamp]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT (getdate()) FOR [BookingDate]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Bookings] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[BookingServices] ADD  DEFAULT ((1)) FOR [Quantity]
GO
ALTER TABLE [dbo].[BookingServices] ADD  DEFAULT (getdate()) FOR [ServiceDate]
GO
ALTER TABLE [dbo].[Feedbacks] ADD  DEFAULT (getdate()) FOR [SubmissionDate]
GO
ALTER TABLE [dbo].[Feedbacks] ADD  DEFAULT ((0)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[Feedbacks] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[InventoryItems] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[PasswordResetTokens] ADD  DEFAULT ((0)) FOR [IsUsed]
GO
ALTER TABLE [dbo].[PasswordResetTokens] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Payments] ADD  DEFAULT (getdate()) FOR [PaymentDate]
GO
ALTER TABLE [dbo].[RoomCategories] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[RoomCategoryInventory] ADD  DEFAULT ((1)) FOR [DefaultQuantity]
GO
ALTER TABLE [dbo].[RoomImages] ADD  DEFAULT ((0)) FOR [IsMain]
GO
ALTER TABLE [dbo].[RoomImages] ADD  DEFAULT (getdate()) FOR [UploadedAt]
GO
ALTER TABLE [dbo].[Rooms] ADD  DEFAULT ('Vacant') FOR [VacancyStatus]
GO
ALTER TABLE [dbo].[Rooms] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Rooms] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Rooms] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT ((1)) FOR [IsAvailable]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT (getdate()) FOR [UpdatedAt]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ('Active') FOR [Status]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [RegistrationDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO

-- =============================================
-- == ĐỊNH NGHĨA FOREIGN KEY CONSTRAINTS     ==
-- =============================================
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD FOREIGN KEY([BookingRoomID])
REFERENCES [dbo].[BookingRooms] ([BookingRoomID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItems] ([ItemID])
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD  CONSTRAINT [FK_BookingRoomInventoryChecks_CheckedByEmployee] FOREIGN KEY([CheckedByUserID])
REFERENCES [dbo].[Employees] ([EmployeeID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks] CHECK CONSTRAINT [FK_BookingRoomInventoryChecks_CheckedByEmployee]
GO
ALTER TABLE [dbo].[BookingRooms]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BookingRooms]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[Rooms] ([RoomID])
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD  CONSTRAINT [FK_Bookings_CreatedByUser] FOREIGN KEY([CreatedByUserID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Bookings] CHECK CONSTRAINT [FK_Bookings_CreatedByUser]
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD  CONSTRAINT [FK_Bookings_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Bookings] CHECK CONSTRAINT [FK_Bookings_Customers]
GO
ALTER TABLE [dbo].[BookingServices]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BookingServices]  WITH CHECK ADD FOREIGN KEY([ServiceID])
REFERENCES [dbo].[Services] ([ServiceID])
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Users] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Users]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Users] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Users]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD  CONSTRAINT [FK_Feedbacks_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_Feedbacks_Customers]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD  CONSTRAINT [FK_Feedbacks_RespondedByEmployee] FOREIGN KEY([RespondedByUserID])
REFERENCES [dbo].[Employees] ([EmployeeID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Feedbacks] CHECK CONSTRAINT [FK_Feedbacks_RespondedByEmployee]
GO
ALTER TABLE [dbo].[PasswordResetTokens]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD  CONSTRAINT [FK_Payments_ProcessedByEmployee] FOREIGN KEY([ProcessedByUserID])
REFERENCES [dbo].[Employees] ([EmployeeID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Payments] CHECK CONSTRAINT [FK_Payments_ProcessedByEmployee]
GO
ALTER TABLE [dbo].[RoomCategoryInventory]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[RoomCategories] ([CategoryID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoomCategoryInventory]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItems] ([ItemID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RoomImages]  WITH CHECK ADD FOREIGN KEY([RoomCategoryID])
REFERENCES [dbo].[RoomCategories] ([CategoryID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[RoomCategories] ([CategoryID])
GO

-- =============================================
-- == ĐỊNH NGHĨA CHECK CONSTRAINTS          ==
-- =============================================
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD  CONSTRAINT [CK_InventoryCheck_Status] CHECK  (([ItemStatus]='Damaged' OR [ItemStatus]='Missing' OR [ItemStatus]='Present'))
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks] CHECK CONSTRAINT [CK_InventoryCheck_Status]
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD  CONSTRAINT [CK_InventoryCheck_Type] CHECK  (([CheckType]='CheckOut' OR [CheckType]='CheckIn'))
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks] CHECK CONSTRAINT [CK_InventoryCheck_Type]
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD CHECK  (([Status]='Completed' OR [Status]='Cancelled' OR [Status]='Confirmed' OR [Status]='Pending'))
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD  CONSTRAINT [CK_Booking_CheckOutDate] CHECK  (([CheckOutDate]>[CheckInDate]))
GO
ALTER TABLE [dbo].[Bookings] CHECK CONSTRAINT [CK_Booking_CheckOutDate]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [CK_Employee_Role] CHECK  (([EmployeeRole]='Staff' OR [EmployeeRole]='Receptionist' OR [EmployeeRole]='Manager' OR [EmployeeRole]='Admin'))
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [CK_Employee_Role]
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD  CONSTRAINT [CK_Room_VacancyStatus] CHECK  (([VacancyStatus]='Occupied' OR [VacancyStatus]='Vacant'))
GO
ALTER TABLE [dbo].[Rooms] CHECK CONSTRAINT [CK_Room_VacancyStatus]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([Status]='Inactive' OR [Status]='Active'))
GO

PRINT 'Database schema script executed successfully.'
GO
