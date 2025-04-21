Create Database SWP391_BL5_G3;
GO

Use SWP391_BL5_G3; 
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(100) NOT NULL UNIQUE,
	Password NVARCHAR(255) NOT NULL, -- Lưu mật khẩu thông thường
    PasswordHash NVARCHAR(255) NOT NULL, -- Store the hashed password here
    FullName NVARCHAR(150) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    PhoneNumber NVARCHAR(20) NULL,
    Address NVARCHAR(255) NULL,
    Role NVARCHAR(50) NOT NULL,
    ProfilePictureURL NVARCHAR(255) NULL,
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Active', 'Inactive')) DEFAULT 'Active',
    RegistrationDate DATETIME DEFAULT GETDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0,
    CONSTRAINT CK_User_Role CHECK (Role IN ('Admin', 'Manager', 'Receptionist', 'Staff', 'Customer')) -- Đảm bảo giá trị vai trò hợp lệ
);
GO

CREATE TABLE RoomCategories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    BasePricePerNight DECIMAL(10, 2) NOT NULL,
    IsDeleted BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber NVARCHAR(20) NOT NULL UNIQUE,
    CategoryID INT NOT NULL,
    VacancyStatus NVARCHAR(20) NOT NULL DEFAULT 'Vacant',
    Description NVARCHAR(MAX) NULL,
    PriceOverride DECIMAL(10, 2) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0,
	FOREIGN KEY (CategoryID) REFERENCES RoomCategories(CategoryID) ON DELETE NO ACTION,
    CONSTRAINT CK_Room_VacancyStatus CHECK (VacancyStatus IN ('Vacant', 'Occupied'))
    FOREIGN KEY (CategoryID) REFERENCES RoomCategories(CategoryID) ON DELETE NO ACTION, -- Không xóa loại phòng nếu còn phòng tồn tại
    CONSTRAINT CK_Room_VacancyStatus CHECK (VacancyStatus IN ('Vacant', 'Occupied')) -- Đảm bảo giá trị trạng thái phòng hợp lệ
);
GO

CREATE TABLE RoomImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    RoomCategoryID INT NOT NULL,
    ImageUrl NVARCHAR(255) NOT NULL,
    IsMain BIT NOT NULL DEFAULT 0,
    UploadedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RoomCategoryID) REFERENCES RoomCategories(CategoryID) ON DELETE CASCADE
);
GO

CREATE TABLE Services (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    ServiceName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Price DECIMAL(10, 2) NOT NULL,
    ImageURL NVARCHAR(255) NULL,
    IsAvailable BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    NumberOfGuests INT NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    TotalPrice DECIMAL(12, 2) NULL,
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')) DEFAULT 'Pending',
    BookingDate DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID) ON DELETE NO ACTION, -- Không xóa người dùng nếu họ có đặt phòng đang hoạt động
    CONSTRAINT CK_Booking_CheckOutDate CHECK (CheckOutDate > CheckInDate) -- Đảm bảo ngày trả phòng sau ngày nhận phòng
);
GO

CREATE TABLE BookingRooms (
    BookingRoomID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    RoomID INT NOT NULL,
    PriceAtBooking DECIMAL(10, 2) NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE, -- Nếu xóa đặt phòng, xóa luôn các phòng được gán
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE NO ACTION, -- Không xóa phòng nếu nó là một phần của lịch sử đặt phòng
    CONSTRAINT UQ_Booking_Room UNIQUE (BookingID, RoomID) -- Ngăn chặn việc thêm cùng một phòng hai lần vào cùng một đặt phòng
);
GO

CREATE TABLE BookingServices (
    BookingServiceID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    PriceAtBooking DECIMAL(10, 2) NOT NULL,
    ServiceDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE, -- Nếu xóa đặt phòng, xóa luôn các dịch vụ được gán
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID) ON DELETE NO ACTION -- Không xóa định nghĩa dịch vụ nếu nó được sử dụng trong các đặt phòng
);
GO

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    Amount DECIMAL(12, 2) NOT NULL,
    PaymentMethod NVARCHAR(50) NOT NULL,
    PaymentStatus NVARCHAR(50) NOT NULL,
    TransactionID NVARCHAR(255) NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    ProcessedByUserID INT NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE NO ACTION, -- Giữ lại lịch sử thanh toán ngay cả khi đặt phòng bị xóa
    FOREIGN KEY (ProcessedByUserID) REFERENCES Users(UserID) ON DELETE SET NULL -- Nếu xóa người dùng nhân viên, giữ lại bản ghi thanh toán nhưng xóa liên kết
);
GO

CREATE TABLE Feedbacks (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NULL,
    CustomerID INT NOT NULL,
    Rating INT NULL CHECK (Rating >= 1 AND Rating <= 5), -- Đảm bảo khoảng giá trị đánh giá
    Comment NVARCHAR(MAX) NULL,
    SubmissionDate DATETIME DEFAULT GETDATE(),
    IsApproved BIT DEFAULT 0,
    Response NVARCHAR(MAX) NULL,
    RespondedByUserID INT NULL,
    ResponseDate DATETIME NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE SET NULL, -- Giữ lại phản hồi ngay cả khi đặt phòng bị xóa, xóa liên kết
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID) ON DELETE NO ACTION, -- Giữ lại phản hồi ngay cả khi khách hàng bị xóa
    FOREIGN KEY (RespondedByUserID) REFERENCES Users(UserID) ON DELETE SET NULL -- Nếu xóa người dùng nhân viên, giữ lại phản hồi nhưng xóa liên kết
);
GO

CREATE TABLE PasswordResetTokens (
    TokenID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    TokenValue NVARCHAR(255) NOT NULL UNIQUE,
    ExpiryDate DATETIME NOT NULL,
    IsUsed BIT NOT NULL DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE -- Nếu người dùng bị xóa, xóa luôn các token đặt lại mật khẩu liên quan
);
GO

CREATE TABLE InventoryItems (
    ItemID INT PRIMARY KEY IDENTITY(1,1),
    ItemName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL,
    DefaultCharge DECIMAL(10, 2) NULL,
    IsDeleted BIT NOT NULL DEFAULT 0
);
GO

CREATE TABLE RoomCategoryInventory (
    RoomCategoryInventoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryID INT NOT NULL,
    ItemID INT NOT NULL,
    DefaultQuantity INT NOT NULL DEFAULT 1,
    FOREIGN KEY (CategoryID) REFERENCES RoomCategories(CategoryID) ON DELETE CASCADE, -- Nếu xóa loại phòng, xóa luôn định nghĩa kiểm kê của nó
    FOREIGN KEY (ItemID) REFERENCES InventoryItems(ItemID) ON DELETE CASCADE, -- Nếu xóa vật dụng, xóa nó khỏi danh sách kiểm kê của các loại phòng
    CONSTRAINT UQ_RoomCategory_Item UNIQUE (CategoryID, ItemID) -- Đảm bảo vật dụng chỉ được liệt kê một lần cho mỗi loại phòng
);
GO

CREATE TABLE BookingRoomInventoryChecks (
    CheckID INT PRIMARY KEY IDENTITY(1,1),
    BookingRoomID INT NOT NULL,
    ItemID INT NOT NULL,
    CheckType NVARCHAR(10) NOT NULL,
    ItemStatus NVARCHAR(50) NOT NULL,
    QuantityChecked INT NULL,
    ChargeApplied DECIMAL(10, 2) NULL,
    Notes NVARCHAR(MAX) NULL,
    CheckedByUserID INT NULL,
    CheckTimestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookingRoomID) REFERENCES BookingRooms(BookingRoomID) ON DELETE CASCADE, -- Nếu xóa việc gán phòng cho đặt phòng, xóa luôn các kiểm tra
    FOREIGN KEY (ItemID) REFERENCES InventoryItems(ItemID) ON DELETE NO ACTION, -- Không xóa định nghĩa vật dụng nếu có kiểm tra tồn tại
    FOREIGN KEY (CheckedByUserID) REFERENCES Users(UserID) ON DELETE SET NULL, -- Nếu xóa người dùng nhân viên, giữ lại bản ghi kiểm tra nhưng xóa liên kết
    CONSTRAINT CK_InventoryCheck_Type CHECK (CheckType IN ('CheckIn', 'CheckOut')), -- Đảm bảo giá trị loại kiểm tra hợp lệ
    CONSTRAINT CK_InventoryCheck_Status CHECK (ItemStatus IN ('Present', 'Missing', 'Damaged')) -- Đảm bảo giá trị trạng thái vật dụng hợp lệ
);
GO

INSERT INTO Users (Username, Password , PasswordHash, FullName, Email, [Role], Status, IsDeleted)
VALUES ('admin_user','123456', 'placeholder_hash_admin', 'Administrator', 'admin@yourhotel.com', 'Admin', 'Active', 0);
GO
INSERT INTO Users (Username, Password , PasswordHash, FullName, Email, [Role], Status, IsDeleted)
VALUES ('manager_user', 'placeholder_hash_manager', 'Hotel Manager', 'manager@yourhotel.com', 'Manager', 'Active', 0);
GO
INSERT INTO Users (Username, Password , PasswordHash, FullName, Email, [Role], Status, IsDeleted)
VALUES ('reception_user', 'placeholder_hash_reception', 'Reception Desk', 'reception@yourhotel.com', 'Receptionist', 'Active', 0);
GO
INSERT INTO Users (Username, Password , PasswordHash, FullName, Email, [Role], Status, IsDeleted)
VALUES ('staff_user', 'placeholder_hash_staff', 'General Staff', 'staff@yourhotel.com', 'Staff', 'Active', 0);
GO
INSERT INTO Users (Username, Password , PasswordHash, FullName, Email, [Role], Status, IsDeleted)
VALUES ('customer_user', 'placeholder_hash_customer', 'Valued Customer', 'customer@email.com', 'Customer', 'Active', 0);
GO

INSERT INTO InventoryItems (ItemName, Description, DefaultCharge) VALUES
('Bath Towel', 'Standard white bath towel', 15.00),
('Hand Towel', 'Standard white hand towel', 8.00),
('TV Remote', 'Remote control for television', 25.00),
('Kettle', 'Electric kettle', 30.00),
('Minibar - Coke', 'Can of Coca-Cola from minibar', 3.00),
('Minibar - Water', 'Bottle of water from minibar', 2.00);
GO

-- Dữ liệu mẫu cho RoomCategories
INSERT INTO RoomCategories (CategoryName, Description, BasePricePerNight)
VALUES 
(N'Premium King Room', N'Phòng cao cấp với giường king size', 200.00),
(N'Deluxe Room', N'Phòng deluxe tiện nghi', 150.00),
(N'Double Room', N'Phòng đôi dành cho hai người', 120.00),
(N'Luxury Room', N'Phòng sang trọng với dịch vụ cao cấp', 250.00),
(N'Room With View', N'Phòng có tầm nhìn đẹp', 180.00),
(N'Small View', N'Phòng nhỏ có cửa sổ nhìn ra cảnh quan', 100.00);
GO

-- Dữ liệu mẫu cho Rooms
INSERT INTO Rooms (RoomNumber, CategoryID, VacancyStatus, Description, PriceOverride, CreatedAt, UpdatedAt, IsDeleted)
VALUES
(N'101', 1, 'Vacant', N'Phòng Premium King tầng trệt, gần sảnh chính', 210.00, GETDATE(), GETDATE(), 0),
(N'102', 1, 'Occupied', N'Phòng Premium King có ban công rộng', 220.00, GETDATE(), GETDATE(), 0),
(N'201', 2, 'Vacant', N'Deluxe Room với view hồ bơi', 160.00, GETDATE(), GETDATE(), 0),
(N'202', 2, 'Occupied', N'Deluxe Room nội khu yên tĩnh', 155.00, GETDATE(), GETDATE(), 0),
(N'301', 3, 'Vacant', N'Double Room với 2 giường đơn', 125.00, GETDATE(), GETDATE(), 0),
(N'302', 3, 'Occupied', N'Double Room có góc học tập', 130.00, GETDATE(), GETDATE(), 0),
(N'401', 4, 'Vacant', N'Luxury Room tầng cao, trang bị hiện đại', 260.00, GETDATE(), GETDATE(), 0),
(N'402', 4, 'Vacant', N'Luxury Room có bồn tắm jacuzzi', 270.00, GETDATE(), GETDATE(), 0),
(N'501', 5, 'Occupied', N'Room With View nhìn ra biển', 185.00, GETDATE(), GETDATE(), 0),
(N'502', 5, 'Vacant', N'Room With View hướng đồi thông', 180.00, GETDATE(), GETDATE(), 0),
(N'601', 6, 'Vacant', N'Small View Room tiện nghi gọn nhẹ', 105.00, GETDATE(), GETDATE(), 0),
(N'602', 6, 'Occupied', N'Small View Room dành cho khách công tác', 110.00, GETDATE(), GETDATE(), 0);
GO
