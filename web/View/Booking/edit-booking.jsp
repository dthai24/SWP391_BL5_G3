<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Chỉnh sửa đặt phòng</title>
    
    <%@ include file="/View/Common/header.jsp" %>
    
    <style>
        .card-header-tabs {
            margin-right: 0;
            margin-bottom: -0.75rem;
            margin-left: 0;
            border-bottom: 0;
        }
        .tab-content {
            padding: 20px 0;
        }
        .action-buttons {
            white-space: nowrap;
        }
    </style>
</head>

<body>
    <div class="wrapper">
        <%@ include file="/View/Common/sidebar.jsp" %>

        <div class="main">
            <%@ include file="/View/Common/navbar.jsp" %>

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3>Chỉnh sửa đặt phòng #${booking.bookingID}</h3>
                        </div>

                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<%= request.getContextPath() %>/manage-bookings" class="btn btn-secondary me-2">
                                <i class="fas fa-arrow-left"></i> Quay lại danh sách
                            </a>
                            <a href="manage-bookings?action=view&bookingId=${booking.bookingID}" class="btn btn-info">
                                <i class="fas fa-eye"></i> Xem chi tiết
                            </a>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header bg-white">
                            <ul class="nav nav-tabs card-header-tabs" id="myTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="details-tab" data-bs-toggle="tab" 
                                            data-bs-target="#details" type="button" role="tab" 
                                            aria-controls="details" aria-selected="true">
                                        Thông tin đặt phòng
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="rooms-tab" data-bs-toggle="tab" 
                                            data-bs-target="#rooms" type="button" role="tab" 
                                            aria-controls="rooms" aria-selected="false">
                                        Quản lý phòng
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="services-tab" data-bs-toggle="tab" 
                                            data-bs-target="#services" type="button" role="tab" 
                                            aria-controls="services" aria-selected="false">
                                        Quản lý dịch vụ
                                    </button>
                                </li>
                            </ul>
                        </div>
                        
                        <div class="card-body">
                            <!-- Alert Messages -->
                            <c:if test="${not empty sessionScope.successMessage}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${sessionScope.successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                                <c:remove var="successMessage" scope="session" />
                            </c:if>
                            
                            <c:if test="${not empty sessionScope.errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${sessionScope.errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                                <c:remove var="errorMessage" scope="session" />
                            </c:if>
                            
                            <div class="tab-content" id="myTabContent">
                                <!-- Booking Details Tab -->
                                <div class="tab-pane fade show active" id="details" role="tabpanel" aria-labelledby="details-tab">
                                    <form method="post" action="manage-bookings" class="needs-validation" novalidate>
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="customerID" class="form-label">Khách hàng <span class="text-danger">*</span></label>
                                                <select name="customerID" id="customerID" class="form-select" required>
                                                    <c:forEach var="customer" items="${customerList}">
                                                        <option value="${customer.userID}" ${customer.userID == booking.customerID ? 'selected' : ''}>
                                                            ${customer.fullName} (${customer.email})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <div class="invalid-feedback">Vui lòng chọn khách hàng.</div>
                                            </div>
                                            
                                            <div class="col-md-6">
                                                <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                                <select name="status" id="status" class="form-select" required>
                                                    <option value="Pending" ${booking.status == 'Pending' ? 'selected' : ''}>Đang xử lý</option>
                                                    <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                                                    <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                                                    <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                                                </select>
                                                <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="checkInDate" class="form-label">Ngày nhận phòng <span class="text-danger">*</span></label>
                                                <input type="date" name="checkInDate" id="checkInDate" class="form-control" 
                                                       value="<fmt:formatDate value="${booking.checkInDate}" pattern="yyyy-MM-dd" />" required>
                                                <div class="invalid-feedback">Vui lòng chọn ngày nhận phòng hợp lệ.</div>
                                            </div>
                                            
                                            <div class="col-md-6">
                                                <label for="checkOutDate" class="form-label">Ngày trả phòng <span class="text-danger">*</span></label>
                                                <input type="date" name="checkOutDate" id="checkOutDate" class="form-control" 
                                                       value="<fmt:formatDate value="${booking.checkOutDate}" pattern="yyyy-MM-dd" />" required>
                                                <div class="invalid-feedback">Vui lòng chọn ngày trả phòng hợp lệ.</div>
                                                <div class="form-text text-muted">Ngày trả phòng phải sau ngày nhận phòng.</div>
                                            </div>
                                        </div>
                                        
                                        <div class="row mb-3">
                                            <div class="col-md-6">
                                                <label for="numberOfGuests" class="form-label">Số lượng khách <span class="text-danger">*</span></label>
                                                <input type="number" name="numberOfGuests" id="numberOfGuests" class="form-control" 
                                                       min="1" value="${booking.numberOfGuests}" required>
                                                <div class="invalid-feedback">Vui lòng nhập số lượng khách hợp lệ (tối thiểu 1).</div>
                                            </div>
                                            
                                            <div class="col-md-6">
                                                <label for="totalPrice" class="form-label">Tổng tiền</label>
                                                <div class="input-group">
                                                    <span class="input-group-text">₫</span>
                                                    <input type="text" class="form-control" id="totalPrice" 
                                                           value="<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0" />" readonly>
                                                </div>
                                                <div class="form-text text-muted">Giá được tính dựa trên phòng và dịch vụ.</div>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <label for="notes" class="form-label">Ghi chú</label>
                                            <textarea name="notes" id="notes" class="form-control" rows="3">${booking.notes}</textarea>
                                        </div>
                                        
                                        <div class="mb-3 d-flex justify-content-between">
                                            <span class="text-muted">Cập nhật lần cuối: <fmt:formatDate value="${booking.updatedAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save"></i> Lưu thay đổi
                                            </button>
                                        </div>
                                    </form>
                                </div>
                                
                                <!-- Rooms Tab -->
                                <div class="tab-pane fade" id="rooms" role="tabpanel" aria-labelledby="rooms-tab">
                                    <div class="row">
                                        <!-- Currently Assigned Rooms -->
                                        <div class="col-md-8 mb-4">
                                            <div class="card">
                                                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0">Phòng đã chọn</h6>
                                                    <span class="badge bg-primary">${assignedRooms.size()} phòng</span>
                                                </div>
                                                <div class="card-body p-0">
                                                    <c:choose>
                                                        <c:when test="${empty assignedRooms}">
                                                            <div class="p-4 text-center text-muted">
                                                                Chưa có phòng nào được chọn cho đặt phòng này.
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="table-responsive">
                                                                <table class="table table-hover table-striped mb-0">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Số phòng</th>
                                                                            <th>Loại phòng</th>
                                                                            <th>Trạng thái</th>
                                                                            <th>Giá tiền</th>
                                                                            <th class="text-center">Thao tác</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:forEach var="room" items="${assignedRooms}">
                                                                            <tr>
                                                                                <td>${room.room.roomNumber}</td>
                                                                                <td>${room.categoryName}</td>
                                                                                <td>
                                                                                    <c:choose>
                                                                                        <c:when test="${room.room.vacancyStatus == 'Vacant'}">
                                                                                            <span class="badge bg-success">Trống</span>
                                                                                        </c:when>
                                                                                        <c:when test="${room.room.vacancyStatus == 'Occupied'}">
                                                                                            <span class="badge bg-warning">Đã đặt</span>
                                                                                        </c:when>
                                                                                        <c:otherwise>
                                                                                            <span class="badge bg-secondary">${room.room.vacancyStatus}</span>
                                                                                        </c:otherwise>
                                                                                    </c:choose>
                                                                                </td>
                                                                                <td><fmt:formatNumber value="${room.priceAtBooking}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                                                                <td class="text-center">
                                                                                    <form method="post" action="manage-bookings" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa phòng này khỏi đặt phòng?')">
                                                                                        <input type="hidden" name="action" value="removeRoom">
                                                                                        <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                                                        <input type="hidden" name="bookingRoomId" value="${room.bookingRoomID}">
                                                                                        <button type="submit" class="btn btn-sm btn-danger">
                                                                                            <i class="fas fa-trash"></i> Xóa
                                                                                        </button>
                                                                                    </form>
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Add Room Form -->
                                        <div class="col-md-4">
                                            <div class="card">
                                                <div class="card-header bg-light">
                                                    <h6 class="mb-0">Thêm phòng</h6>
                                                </div>
                                                <div class="card-body">
                                                    <form method="post" action="manage-bookings" class="needs-validation" novalidate>
                                                        <input type="hidden" name="action" value="addRoom">
                                                        <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                        
                                                        <div class="mb-3">
                                                            <label for="roomId" class="form-label">Chọn phòng <span class="text-danger">*</span></label>
                                                            <select name="roomId" id="roomId" class="form-select" required>
                                                                <option value="">-- Chọn phòng --</option>
                                                                <c:forEach var="availableRoom" items="${allRooms}">
                                                                    <c:if test="${availableRoom.vacancyStatus == 'Vacant'}">
                                                                        <option value="${availableRoom.roomID}">
                                                                            ${availableRoom.roomNumber} (${availableRoom.categoryName})
                                                                        </option>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </select>
                                                            <div class="invalid-feedback">Vui lòng chọn phòng.</div>
                                                            <div class="form-text">Chỉ hiển thị phòng trống.</div>
                                                        </div>
                                                        
                                                        <div class="d-grid">
                                                            <button type="submit" class="btn btn-success">
                                                                <i class="fas fa-plus"></i> Thêm phòng
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Services Tab -->
                                <div class="tab-pane fade" id="services" role="tabpanel" aria-labelledby="services-tab">
                                    <div class="row">
                                        <!-- Currently Assigned Services -->
                                        <div class="col-md-8 mb-4">
                                            <div class="card">
                                                <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                                    <h6 class="mb-0">Dịch vụ đã thêm</h6>
                                                    <span class="badge bg-primary">${assignedServices.size()} dịch vụ</span>
                                                </div>
                                                <div class="card-body p-0">
                                                    <c:choose>
                                                        <c:when test="${empty assignedServices}">
                                                            <div class="p-4 text-center text-muted">
                                                                Chưa có dịch vụ nào được thêm vào đặt phòng này.
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="table-responsive">
                                                                <table class="table table-hover table-striped mb-0">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>Tên dịch vụ</th>
                                                                            <th>Số lượng</th>
                                                                            <th>Đơn giá</th>
                                                                            <th>Thành tiền</th>
                                                                            <th>Ngày dùng</th>
                                                                            <th class="text-center">Thao tác</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>
                                                                        <c:forEach var="service" items="${assignedServices}">
                                                                            <tr>
                                                                                <td>${service.service.serviceName}</td>
                                                                                <td>${service.quantity}</td>
                                                                                <td><fmt:formatNumber value="${service.priceAtBooking}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                                                                <td>
                                                                                    <fmt:formatNumber value="${service.priceAtBooking * service.quantity}" 
                                                                                                      type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                                                </td>
                                                                                <td><fmt:formatDate value="${service.serviceDate}" pattern="dd/MM/yyyy" /></td>
                                                                                <td class="text-center">
                                                                                    <form method="post" action="manage-bookings" class="d-inline" onsubmit="return confirm('Bạn có chắc chắn muốn xóa dịch vụ này khỏi đặt phòng?')">
                                                                                        <input type="hidden" name="action" value="removeService">
                                                                                        <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                                                        <input type="hidden" name="bookingServiceId" value="${service.bookingServiceID}">
                                                                                        <button type="submit" class="btn btn-sm btn-danger">
                                                                                            <i class="fas fa-trash"></i> Xóa
                                                                                        </button>
                                                                                    </form>
                                                                                </td>
                                                                            </tr>
                                                                        </c:forEach>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Add Service Form -->
                                        <div class="col-md-4">
                                            <div class="card">
                                                <div class="card-header bg-light">
                                                    <h6 class="mb-0">Thêm dịch vụ</h6>
                                                </div>
                                                <div class="card-body">
                                                    <form method="post" action="manage-bookings" class="needs-validation" novalidate>
                                                        <input type="hidden" name="action" value="addService">
                                                        <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                        
                                                        <div class="mb-3">
                                                            <label for="serviceId" class="form-label">Chọn dịch vụ <span class="text-danger">*</span></label>
                                                            <select name="serviceId" id="serviceId" class="form-select" required>
                                                                <option value="">-- Chọn dịch vụ --</option>
                                                                <c:forEach var="availableService" items="${availableServices}">
                                                                    <option value="${availableService.serviceID}" 
                                                                            data-price="${availableService.price}">
                                                                        ${availableService.serviceName} - <fmt:formatNumber value="${availableService.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" />
                                                                    </option>
                                                                </c:forEach>
                                                            </select>
                                                            <div class="invalid-feedback">Vui lòng chọn dịch vụ.</div>
                                                        </div>
                                                        
                                                        <div class="mb-3">
                                                            <label for="quantity" class="form-label">Số lượng <span class="text-danger">*</span></label>
                                                            <input type="number" name="quantity" id="quantity" class="form-control" 
                                                                   min="1" value="1" required>
                                                            <div class="invalid-feedback">Vui lòng nhập số lượng hợp lệ (tối thiểu 1).</div>
                                                        </div>
                                                        
                                                        <div class="mb-3">
                                                            <label for="serviceDate" class="form-label">Ngày sử dụng <span class="text-danger">*</span></label>
                                                            <input type="date" name="serviceDate" id="serviceDate" class="form-control" 
                                                                   value="<fmt:formatDate value='${booking.checkInDate}' pattern='yyyy-MM-dd' />" required>
                                                            <div class="invalid-feedback">Vui lòng chọn ngày sử dụng dịch vụ.</div>
                                                            <div class="form-text">Ngày phải nằm trong thời gian lưu trú.</div>
                                                        </div>
                                                        
                                                        <div class="d-grid">
                                                            <button type="submit" class="btn btn-success">
                                                                <i class="fas fa-plus"></i> Thêm dịch vụ
                                                            </button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Bottom Action Bar -->
                            <div class="mt-4 py-3 bg-light rounded d-flex justify-content-between align-items-center px-3">
                                <a href="manage-bookings" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại danh sách
                                </a>
                                <div>
                                    <button id="recalculateBtn" class="btn btn-info me-2" 
                                            onclick="recalculateTotal(${booking.bookingID})">
                                        <i class="fas fa-calculator"></i> Tính lại giá
                                    </button>
                                    <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                        <i class="fas fa-trash"></i> Xóa đặt phòng
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <%@ include file="/View/Common/footer.jsp" %>
        </div>
    </div>
    
    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa đặt phòng #${booking.bookingID}?</p>
                    <p class="mb-0 text-danger"><strong>Cảnh báo:</strong> Hành động này không thể hoàn tác. Đặt phòng sẽ bị đánh dấu là đã xóa.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>
                    <form method="post" action="manage-bookings">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="bookingId" value="${booking.bookingID}">
                        <button type="submit" class="btn btn-danger">Xóa đặt phòng</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
    <script>
        // Bootstrap form validation
        (() => {
            'use strict';
            
            // Fetch all forms we want to apply validation to
            const forms = document.querySelectorAll('.needs-validation');
            
            // Loop over them and prevent submission
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    
                    // Additional validation for check-in/check-out dates
                    if (form.querySelector('#checkInDate') && form.querySelector('#checkOutDate')) {
                        const checkInDate = new Date(document.getElementById('checkInDate').value);
                        const checkOutDate = new Date(document.getElementById('checkOutDate').value);
                        
                        if (checkOutDate <= checkInDate) {
                            event.preventDefault();
                            alert('Ngày trả phòng phải sau ngày nhận phòng');
                        }
                    }
                    
                    // Additional validation for service date
                    if (form.querySelector('#serviceDate')) {
                        const serviceDate = new Date(document.getElementById('serviceDate').value);
                        const checkInDate = new Date(document.getElementById('checkInDate').value);
                        const checkOutDate = new Date(document.getElementById('checkOutDate').value);
                        
                        if (serviceDate < checkInDate || serviceDate > checkOutDate) {
                            event.preventDefault();
                            alert('Ngày sử dụng dịch vụ phải trong thời gian lưu trú');
                        }
                    }
                    
                    form.classList.add('was-validated');
                }, false);
            });
        })();
        
        // Function to enforce minimum date for service date based on check-in
        document.addEventListener('DOMContentLoaded', function() {
            // Initial date range setting
            const checkInInput = document.getElementById('checkInDate');
            const checkOutInput = document.getElementById('checkOutDate');
            const serviceDateInput = document.getElementById('serviceDate');
            
            // Set min/max for service date when tabs change
            const serviceTab = document.getElementById('services-tab');
            if (serviceTab) {
                serviceTab.addEventListener('shown.bs.tab', function() {
                    if (serviceDateInput && checkInInput && checkOutInput) {
                        serviceDateInput.min = checkInInput.value;
                        serviceDateInput.max = checkOutInput.value;
                    }
                });
            }
            
            // Update service date constraints when check-in/out changes
            if (checkInInput) {
                checkInInput.addEventListener('change', function() {
                    if (checkOutInput && this.value > checkOutInput.value) {
                        checkOutInput.value = this.value;
                    }
                    if (serviceDateInput) {
                        serviceDateInput.min = this.value;
                    }
                });
            }
            
            if (checkOutInput) {
                checkOutInput.addEventListener('change', function() {
                    if (serviceDateInput) {
                        serviceDateInput.max = this.value;
                    }
                });
            }
        });
        
        // Function to recalculate the total price
        function recalculateTotal(bookingId) {
            if (confirm('Tính lại tổng tiền dựa trên phòng và dịch vụ?')) {
                fetch('manage-bookings?action=recalculateTotal&bookingId=' + bookingId, {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload(); // Reload to show updated price
                    } else {
                        alert('Không thể tính lại tổng tiền. Vui lòng thử lại.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Đã xảy ra lỗi. Vui lòng thử lại.');
                });
            }
        }
    </script>
</body>
</html>