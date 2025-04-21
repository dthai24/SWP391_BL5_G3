CREATE DATABASE [SWP391_BL5_G3]
USE [SWP391_BL5_G3]
GO
/****** Object:  Table [dbo].[BookingRoomInventoryChecks]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingRoomInventoryChecks](
	[CheckID] [int] IDENTITY(1,1) NOT NULL,
	[BookingRoomID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[CheckType] [nvarchar](10) NOT NULL,
	[ItemStatus] [nvarchar](50) NOT NULL,
	[QuantityChecked] [int] NULL,
	[ChargeApplied] [decimal](10, 2) NULL,
	[Notes] [nvarchar](max) NULL,
	[CheckedByUserID] [int] NULL,
	[CheckTimestamp] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[CheckID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookingRooms]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingRooms](
	[BookingRoomID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL,
	[RoomID] [int] NOT NULL,
	[PriceAtBooking] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[BookingRoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bookings]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bookings](
	[BookingID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CheckInDate] [date] NOT NULL,
	[CheckOutDate] [date] NOT NULL,
	[NumberOfGuests] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[TotalPrice] [decimal](12, 2) NULL,
	[Status] [nvarchar](50) NOT NULL,
	[BookingDate] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[BookingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BookingServices]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BookingServices](
	[BookingServiceID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL,
	[ServiceID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[PriceAtBooking] [decimal](10, 2) NOT NULL,
	[ServiceDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[BookingServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feedbacks]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feedbacks](
	[FeedbackID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NULL,
	[CustomerID] [int] NOT NULL,
	[Rating] [int] NULL,
	[Comment] [nvarchar](max) NULL,
	[SubmissionDate] [datetime] NULL,
	[IsApproved] [bit] NULL,
	[Response] [nvarchar](max) NULL,
	[RespondedByUserID] [int] NULL,
	[ResponseDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[FeedbackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InventoryItems]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InventoryItems](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DefaultCharge] [decimal](10, 2) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PasswordResetTokens]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PasswordResetTokens](
	[TokenID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[TokenValue] [nvarchar](255) NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
	[IsUsed] [bit] NOT NULL,
	[CreatedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payments]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments](
	[PaymentID] [int] IDENTITY(1,1) NOT NULL,
	[BookingID] [int] NOT NULL,
	[Amount] [decimal](12, 2) NOT NULL,
	[PaymentMethod] [nvarchar](50) NOT NULL,
	[PaymentStatus] [nvarchar](50) NOT NULL,
	[TransactionID] [nvarchar](255) NULL,
	[PaymentDate] [datetime] NULL,
	[ProcessedByUserID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomCategories]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomCategories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[BasePricePerNight] [decimal](10, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomCategoryInventory]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomCategoryInventory](
	[RoomCategoryInventoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[DefaultQuantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoomCategoryInventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoomImages]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoomImages](
	[ImageID] [int] IDENTITY(1,1) NOT NULL,
	[RoomCategoryID] [int] NOT NULL,
	[ImageUrl] [nvarchar](255) NOT NULL,
	[IsMain] [bit] NOT NULL,
	[UploadedAt] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rooms]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rooms](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[RoomNumber] [nvarchar](20) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[VacancyStatus] [nvarchar](20) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[PriceOverride] [decimal](10, 2) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Services]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Services](
	[ServiceID] [int] IDENTITY(1,1) NOT NULL,
	[ServiceName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[ImageURL] [nvarchar](255) NULL,
	[IsAvailable] [bit] NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 21.04.2025 14:53:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](100) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](150) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[Address] [nvarchar](255) NULL,
	[Role] [nvarchar](50) NOT NULL,
	[ProfilePictureURL] [nvarchar](255) NULL,
	[Status] [nvarchar](20) NOT NULL,
	[RegistrationDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Bookings] ON 
GO
INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Notes], [TotalPrice], [Status], [BookingDate], [UpdatedAt], [IsDeleted]) VALUES (1, 6, CAST(N'2025-04-23' AS Date), CAST(N'2025-04-26' AS Date), 4, N'', CAST(0.00 AS Decimal(12, 2)), N'Cancelled', CAST(N'2025-04-21T14:34:40.727' AS DateTime), CAST(N'2025-04-21T14:34:40.727' AS DateTime), 0)
GO
INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Notes], [TotalPrice], [Status], [BookingDate], [UpdatedAt], [IsDeleted]) VALUES (2, 6, CAST(N'2025-04-24' AS Date), CAST(N'2025-04-27' AS Date), 5, N'', CAST(0.00 AS Decimal(12, 2)), N'Confirmed', CAST(N'2025-04-21T14:40:52.270' AS DateTime), CAST(N'2025-04-21T14:40:52.270' AS DateTime), 0)
GO
INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Notes], [TotalPrice], [Status], [BookingDate], [UpdatedAt], [IsDeleted]) VALUES (3, 11, CAST(N'2025-04-22' AS Date), CAST(N'2025-04-24' AS Date), 3, N'', CAST(0.00 AS Decimal(12, 2)), N'Cancelled', CAST(N'2025-04-21T14:49:49.760' AS DateTime), CAST(N'2025-04-21T14:49:49.760' AS DateTime), 0)
GO
INSERT [dbo].[Bookings] ([BookingID], [CustomerID], [CheckInDate], [CheckOutDate], [NumberOfGuests], [Notes], [TotalPrice], [Status], [BookingDate], [UpdatedAt], [IsDeleted]) VALUES (4, 10, CAST(N'2025-04-23' AS Date), CAST(N'2025-04-30' AS Date), 3, N'', CAST(0.00 AS Decimal(12, 2)), N'Completed', CAST(N'2025-04-21T14:53:25.517' AS DateTime), CAST(N'2025-04-21T14:53:25.517' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Bookings] OFF
GO
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
SET IDENTITY_INSERT [dbo].[RoomCategories] ON 
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [IsDeleted]) VALUES (1, N'Premium King Room', N'Phòng cao cấp với giường king size', CAST(200.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [IsDeleted]) VALUES (2, N'Deluxe Room', N'Phòng deluxe tiện nghi', CAST(150.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [IsDeleted]) VALUES (3, N'Double Room', N'Phòng đôi dành cho hai người', CAST(120.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [IsDeleted]) VALUES (4, N'Luxury Room', N'Phòng sang trọng với dịch vụ cao cấp', CAST(250.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [IsDeleted]) VALUES (5, N'Room With View', N'Phòng có tầm nhìn đẹp', CAST(180.00 AS Decimal(10, 2)), 0)
GO
INSERT [dbo].[RoomCategories] ([CategoryID], [CategoryName], [Description], [BasePricePerNight], [IsDeleted]) VALUES (6, N'Small View', N'Phòng nhỏ có cửa sổ nhìn ra cảnh quan', CAST(100.00 AS Decimal(10, 2)), 0)
GO
SET IDENTITY_INSERT [dbo].[RoomCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[Rooms] ON 
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (1, N'101', 1, N'Vacant', N'Phòng Premium King tầng trệt, gần sảnh chính', CAST(210.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (2, N'102', 1, N'Occupied', N'Phòng Premium King có ban công rộng', CAST(220.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (3, N'201', 2, N'Vacant', N'Deluxe Room với view hồ bơi', CAST(160.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (4, N'202', 2, N'Occupied', N'Deluxe Room nội khu yên tĩnh', CAST(155.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (5, N'301', 3, N'Vacant', N'Double Room với 2 giường đơn', CAST(125.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (6, N'302', 3, N'Occupied', N'Double Room có góc học tập', CAST(130.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (7, N'401', 4, N'Vacant', N'Luxury Room tầng cao, trang bị hiện đại', CAST(260.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (8, N'402', 4, N'Vacant', N'Luxury Room có bồn tắm jacuzzi', CAST(270.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (9, N'501', 5, N'Occupied', N'Room With View nhìn ra biển', CAST(185.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (10, N'502', 5, N'Vacant', N'Room With View hướng đồi thông', CAST(180.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (11, N'601', 6, N'Vacant', N'Small View Room tiện nghi gọn nhẹ', CAST(105.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
INSERT [dbo].[Rooms] ([RoomID], [RoomNumber], [CategoryID], [VacancyStatus], [Description], [PriceOverride], [CreatedAt], [UpdatedAt], [IsDeleted]) VALUES (12, N'602', 6, N'Occupied', N'Small View Room dành cho khách công tác', CAST(110.00 AS Decimal(10, 2)), CAST(N'2025-04-21T14:29:46.700' AS DateTime), CAST(N'2025-04-21T14:29:46.700' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Rooms] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Role], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (1, N'admin_user', N'123456', N'Administrator', N'admin@yourhotel.com', NULL, NULL, N'Admin', NULL, N'Active', CAST(N'2025-04-21T14:29:46.667' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Role], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (3, N'manager_user', N'123456', N'Hotel Manager', N'manager@yourhotel.com', NULL, NULL, N'Manager', NULL, N'Active', CAST(N'2025-04-21T14:33:59.197' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Role], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (4, N'reception_user', N'123456', N'Reception Desk', N'reception@yourhotel.com', NULL, NULL, N'Receptionist', NULL, N'Active', CAST(N'2025-04-21T14:33:59.213' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Role], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (5, N'staff_user', N'123456', N'General Staff', N'staff@yourhotel.com', NULL, NULL, N'Staff', NULL, N'Active', CAST(N'2025-04-21T14:33:59.227' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Role], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (6, N'customer_user', N'123456', N'Valued Customer', N'customer@email.com', NULL, NULL, N'Customer', NULL, N'Active', CAST(N'2025-04-21T14:33:59.227' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Role], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (10, N'abc', N'123', N'abc', N'abc@gmail.com', N'123456798', N'123 abc', N'Customer', NULL, N'Active', CAST(N'2025-04-21T00:00:00.000' AS DateTime), 0)
GO
INSERT [dbo].[Users] ([UserID], [Username], [Password], [FullName], [Email], [PhoneNumber], [Address], [Role], [ProfilePictureURL], [Status], [RegistrationDate], [IsDeleted]) VALUES (11, N'nghiant', N'123456', N'Nghia Nguyen', N'nghianthe150495@fpt.edu.vn', N'123456789', N'123 abc', N'Customer', NULL, N'Active', CAST(N'2025-04-21T00:00:00.000' AS DateTime), 0)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [UQ_Booking_Room]    Script Date: 21.04.2025 14:53:42 ******/
ALTER TABLE [dbo].[BookingRooms] ADD  CONSTRAINT [UQ_Booking_Room] UNIQUE NONCLUSTERED 
(
	[BookingID] ASC,
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Inventor__4E4373F722C80757]    Script Date: 21.04.2025 14:53:42 ******/
ALTER TABLE [dbo].[InventoryItems] ADD UNIQUE NONCLUSTERED 
(
	[ItemName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Password__FE1B80EC04A94560]    Script Date: 21.04.2025 14:53:42 ******/
ALTER TABLE [dbo].[PasswordResetTokens] ADD UNIQUE NONCLUSTERED 
(
	[TokenValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_RoomCategory_Item]    Script Date: 21.04.2025 14:53:42 ******/
ALTER TABLE [dbo].[RoomCategoryInventory] ADD  CONSTRAINT [UQ_RoomCategory_Item] UNIQUE NONCLUSTERED 
(
	[CategoryID] ASC,
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Rooms__AE10E07A905131A8]    Script Date: 21.04.2025 14:53:42 ******/
ALTER TABLE [dbo].[Rooms] ADD UNIQUE NONCLUSTERED 
(
	[RoomNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__536C85E43DE1065F]    Script Date: 21.04.2025 14:53:42 ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D105348F02F1AD]    Script Date: 21.04.2025 14:53:42 ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
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
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD FOREIGN KEY([BookingRoomID])
REFERENCES [dbo].[BookingRooms] ([BookingRoomID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD FOREIGN KEY([CheckedByUserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[BookingRoomInventoryChecks]  WITH CHECK ADD FOREIGN KEY([ItemID])
REFERENCES [dbo].[InventoryItems] ([ItemID])
GO
ALTER TABLE [dbo].[BookingRooms]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BookingRooms]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[Rooms] ([RoomID])
GO
ALTER TABLE [dbo].[Bookings]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[BookingServices]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BookingServices]  WITH CHECK ADD FOREIGN KEY([ServiceID])
REFERENCES [dbo].[Services] ([ServiceID])
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Users] ([UserID])
GO
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD FOREIGN KEY([RespondedByUserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[PasswordResetTokens]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD FOREIGN KEY([BookingID])
REFERENCES [dbo].[Bookings] ([BookingID])
GO
ALTER TABLE [dbo].[Payments]  WITH CHECK ADD FOREIGN KEY([ProcessedByUserID])
REFERENCES [dbo].[Users] ([UserID])
ON DELETE SET NULL
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
ALTER TABLE [dbo].[Feedbacks]  WITH CHECK ADD CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD  CONSTRAINT [CK_Room_VacancyStatus] CHECK  (([VacancyStatus]='Occupied' OR [VacancyStatus]='Vacant'))
GO
ALTER TABLE [dbo].[Rooms] CHECK CONSTRAINT [CK_Room_VacancyStatus]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD CHECK  (([Status]='Inactive' OR [Status]='Active'))
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [CK_User_Role] CHECK  (([Role]='Customer' OR [Role]='Staff' OR [Role]='Receptionist' OR [Role]='Manager' OR [Role]='Admin'))
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [CK_User_Role]
GO
USE [master]
GO
ALTER DATABASE [SWP391_BL5_G3] SET  READ_WRITE 
GO
