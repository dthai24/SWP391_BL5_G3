CREATE DATABASE SWP391_BL5_G3;
GO

USE SWP391_BL5_G3; 

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL, -- Lưu mật khẩu thông thường
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

-- Dữ liệu mẫu cho Users
INSERT INTO Users (Username, Password, FullName, Email, Role, Status, IsDeleted)
VALUES 
('admin_user', '123456', 'Administrator', 'admin@yourhotel.com', 'Admin', 'Active', 0),
('manager_user', '123456', 'Hotel Manager', 'manager@yourhotel.com', 'Manager', 'Active', 0),
('reception_user', '123456', 'Reception Desk', 'reception@yourhotel.com', 'Receptionist', 'Active', 0),
('staff_user', '123456', 'General Staff', 'staff@yourhotel.com', 'Staff', 'Active', 0),
('customer_user', '123456', 'Valued Customer', 'customer@email.com', 'Customer', 'Active', 0);
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
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID) ON DELETE NO ACTION,
    CONSTRAINT CK_Booking_CheckOutDate CHECK (CheckOutDate > CheckInDate)
);
GO

CREATE TABLE BookingRooms (
    BookingRoomID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    RoomID INT NOT NULL,
    PriceAtBooking DECIMAL(10, 2) NULL,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID) ON DELETE NO ACTION,
    CONSTRAINT UQ_Booking_Room UNIQUE (BookingID, RoomID)
);
GO

CREATE TABLE BookingServices (
    BookingServiceID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    PriceAtBooking DECIMAL(10, 2) NOT NULL,
    ServiceDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID) ON DELETE NO ACTION
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
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE NO ACTION,
    FOREIGN KEY (ProcessedByUserID) REFERENCES Users(UserID) ON DELETE SET NULL
);
GO

CREATE TABLE Feedbacks (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    BookingID INT NULL,
    CustomerID INT NOT NULL,
    Rating INT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment NVARCHAR(MAX) NULL,
    SubmissionDate DATETIME DEFAULT GETDATE(),
    IsApproved BIT DEFAULT 0,
    Response NVARCHAR(MAX) NULL,
    RespondedByUserID INT NULL,
    ResponseDate DATETIME NULL,
    IsDeleted BIT NOT NULL DEFAULT 0,
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE SET NULL,
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID) ON DELETE NO ACTION,
    FOREIGN KEY (RespondedByUserID) REFERENCES Users(UserID) ON DELETE SET NULL
);
GO