<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%@ page import="Model.Customer" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Đặt Phòng</title>

        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/style.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
        <%@ include file="/View/Common/header.jsp" %>
        <style>
            .info-label {
                font-weight: 600;
            }
            .booking-status {
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 4px;
                display: inline-block;
            }
            .status-pending {
                background-color: #ffc107;
                color: #212529;
            }
            .status-confirmed {
                background-color: #28a745;
                color: #fff;
            }
            .status-cancelled {
                background-color: #dc3545;
                color: #fff;
            }
            .status-completed {
                background-color: #6c757d;
                color: #fff;
            }
            .table-responsive {
                overflow-x: auto !important;
            }
            #booking-datatable {
                min-width: 900px !important;
                table-layout: fixed;
            }
            #booking-datatable th, #booking-datatable td {
                white-space: normal !important;
                word-break: break-word !important;
                vertical-align: middle;
            }
            .notification-box {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1050;
                display: none;
            }
            .avatar-large {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
            }
            .nav-tabs .nav-link.active {
                font-weight: bold;
                border-bottom: 2px solid #007bff;
            }
            /* Spinner for loading states */
            .spinner-container {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }
            /* Badge counter styles */
            .badge-counter {
                font-size: 14px;
                padding: 4px 8px;
                margin-left: 5px;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="/View/Common/sidebar.jsp" %>
            <div class="main">
                <%@ include file="/View/Common/navbar.jsp" %>
                <main class="content">
                    <%
                        String successMessage = (String) request.getAttribute("successMessage");
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                    %>

                    <!-- Notification Box -->
                    <% if (successMessage != null) {%>
                    <div class="alert alert-success alert-dismissible fade show notification-box" role="alert">
                        <%= successMessage%>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% } %>
                    <% if (errorMessage != null) {%>
                    <div class="alert alert-danger alert-dismissible fade show notification-box" role="alert">
                        <%= errorMessage%>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% }%>

                    <!-- Table Section -->
                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Đặt Phòng</h3>
                                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addBookingModal">
                                    <i class="fa fa-plus"></i> Thêm Đặt Phòng
                                </button>
                            </div>

                            <div class="card-body">
                                <form method="get" action="manage-bookings" class="form-inline mb-3">
                                    <div class="form-group mr-2">
                                        <label for="filterStatus" class="mr-2">Trạng thái</label>
                                        <select name="filterStatus" id="filterStatus" class="form-control">
                                            <option value="">Tất cả</option>
                                            <option value="Pending" <%= "Pending".equals(request.getParameter("filterStatus")) ? "selected" : ""%>>Đang xử lý</option>
                                            <option value="Confirmed" <%= "Confirmed".equals(request.getParameter("filterStatus")) ? "selected" : ""%>>Đã xác nhận</option>
                                            <option value="Cancelled" <%= "Cancelled".equals(request.getParameter("filterStatus")) ? "selected" : ""%>>Đã hủy</option>
                                            <option value="Completed" <%= "Completed".equals(request.getParameter("filterStatus")) ? "selected" : ""%>>Hoàn thành</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary mr-2">Lọc</button>
                                    <a href="manage-bookings" class="btn btn-secondary">Hủy</a>
                                </form>

                                <div class="table-responsive">
                                    <table id="booking-datatable" class="table table-hover table-striped align-middle">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th>Mã</th>
                                                <th>Khách hàng</th>
                                                <th>Nhận phòng</th>
                                                <th>Trả phòng</th>
                                                <th>Trạng thái</th>
                                                <th>Tổng tiền</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="booking" items="${bookings}">
                                                <tr>
                                                    <td>${booking.bookingID}</td>
                                                    <td>${booking.customer.fullName}</td>
                                                    <td><fmt:formatDate value="${booking.checkInDate}" pattern="dd-MM-yyyy" /></td>
                                                    <td><fmt:formatDate value="${booking.checkOutDate}" pattern="dd-MM-yyyy" /></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${booking.status eq 'Pending'}">
                                                                <span class="booking-status status-pending">Đang xử lý</span>
                                                            </c:when>
                                                            <c:when test="${booking.status eq 'Confirmed'}">
                                                                <span class="booking-status status-confirmed">Đã xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${booking.status eq 'Cancelled'}">
                                                                <span class="booking-status status-cancelled">Đã hủy</span>
                                                            </c:when>
                                                            <c:when test="${booking.status eq 'Completed'}">
                                                                <span class="booking-status status-completed">Hoàn thành</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span>${booking.status}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                                    <td>
                                                        <button type="button" class="btn btn-link p-0 view-btn" 
                                                                data-bookingid="${booking.bookingID}"
                                                                data-toggle="modal" data-target="#viewBookingModal">
                                                            <i class="fa fa-eye" style="color: #17a2b8;"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-link p-0 edit-btn"
                                                                data-bookingid="${booking.bookingID}"
                                                                data-toggle="modal" data-target="#editBookingModal">
                                                            <i class="fa fa-edit" style="color: #ffc107;"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-link p-0 delete-btn" onclick="confirmDelete(${booking.bookingID})">
                                                            <i class="fa fa-trash" style="color: #dc3545;"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty bookings}">
                                                <tr><td colspan="7" class="text-center">Không có đặt phòng nào.</td></tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Booking Modal -->
                    <div class="modal fade" id="addBookingModal" tabindex="-1" role="dialog" aria-labelledby="addBookingModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <form id="addBookingForm" action="manage-bookings" method="post" class="needs-validation" novalidate>
                                    <input type="hidden" name="action" value="save">

                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addBookingModalLabel">Thêm Đặt Phòng Mới</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>

                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="add-customerID">Khách hàng <span class="text-danger">*</span></label>
                                                    <select name="customerID" id="add-customerID" class="form-control" required>
                                                        <option value="">-- Chọn khách hàng --</option>
                                                        <c:forEach var="customer" items="${customerList}">
                                                            <option value="${customer.userID}">${customer.fullName} (${customer.email})</option>
                                                        </c:forEach>
                                                    </select>
                                                    <div class="invalid-feedback">Vui lòng chọn khách hàng.</div>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="add-status">Trạng thái <span class="text-danger">*</span></label>
                                                    <select name="status" id="add-status" class="form-control" required>
                                                        <option value="Pending">Đang xử lý</option>
                                                        <option value="Confirmed">Đã xác nhận</option>
                                                        <option value="Cancelled">Đã hủy</option>
                                                        <option value="Completed">Hoàn thành</option>
                                                    </select>
                                                    <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="add-checkInDate">Ngày nhận phòng <span class="text-danger">*</span></label>
                                                    <input type="date" name="checkInDate" id="add-checkInDate" class="form-control" required>
                                                    <div class="invalid-feedback">Vui lòng chọn ngày nhận phòng hợp lệ.</div>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label for="add-checkOutDate">Ngày trả phòng <span class="text-danger">*</span></label>
                                                    <input type="date" name="checkOutDate" id="add-checkOutDate" class="form-control" required>
                                                    <div class="invalid-feedback">Vui lòng chọn ngày trả phòng hợp lệ.</div>
                                                    <div class="form-text text-muted">Ngày trả phòng phải sau ngày nhận phòng.</div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label for="add-numberOfGuests">Số lượng khách <span class="text-danger">*</span></label>
                                            <input type="number" name="numberOfGuests" id="add-numberOfGuests" class="form-control" 
                                                   min="1" value="1" required>
                                            <div class="invalid-feedback">Vui lòng nhập số lượng khách hợp lệ (tối thiểu 1).</div>
                                        </div>

                                        <div class="form-group">
                                            <label for="add-notes">Ghi chú</label>
                                            <textarea name="notes" id="add-notes" class="form-control" rows="3"></textarea>
                                        </div>
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-primary" id="addBookingSubmit">
                                            <i class="fas fa-save"></i> Tạo đặt phòng
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- View Booking Modal -->
                    <div class="modal fade" id="viewBookingModal" tabindex="-1" role="dialog" aria-labelledby="viewBookingModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="viewBookingModalLabel">Chi tiết đặt phòng #<span id="view-bookingID"></span></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>

                                <div class="modal-body">
                                    <div id="view-loading" class="spinner-container">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="sr-only">Đang tải...</span>
                                        </div>
                                    </div>

                                    <div id="view-content" style="display: none;">
                                        <div class="row">
                                            <!-- Left Column - Booking Info -->
                                            <div class="col-md-6">
                                                <div class="card mb-3">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Thông tin đặt phòng</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="row mb-2">
                                                            <div class="col-md-5 info-label">Trạng thái:</div>
                                                            <div class="col-md-7" id="view-status"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-5 info-label">Ngày đặt phòng:</div>
                                                            <div class="col-md-7" id="view-bookingDate"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-5 info-label">Ngày nhận phòng:</div>
                                                            <div class="col-md-7" id="view-checkInDate"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-5 info-label">Ngày trả phòng:</div>
                                                            <div class="col-md-7" id="view-checkOutDate"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-5 info-label">Số lượng khách:</div>
                                                            <div class="col-md-7" id="view-numberOfGuests"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-5 info-label">Tổng tiền:</div>
                                                            <div class="col-md-7" id="view-totalPrice"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-5 info-label">Cập nhật lần cuối:</div>
                                                            <div class="col-md-7" id="view-updatedAt"></div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Ghi chú</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <p class="mb-0" id="view-notes">Không có ghi chú.</p>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Right Column - Customer Info -->
                                            <div class="col-md-6">
                                                <div class="card">
                                                    <div class="card-header bg-light">
                                                        <h6 class="mb-0">Thông tin khách hàng</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="row mb-2">
                                                            <div class="col-md-4 info-label">Họ và tên:</div>
                                                            <div class="col-md-8" id="view-customerName"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-4 info-label">Email:</div>
                                                            <div class="col-md-8" id="view-customerEmail"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-4 info-label">Điện thoại:</div>
                                                            <div class="col-md-8" id="view-customerPhone"></div>
                                                        </div>
                                                        <div class="row mb-2">
                                                            <div class="col-md-4 info-label">Địa chỉ:</div>
                                                            <div class="col-md-8" id="view-customerAddress"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Rooms Section -->
                                        <div class="card mt-3">
                                            <div class="card-header bg-light">
                                                <h6 class="mb-0">Phòng đã đặt</h6>
                                            </div>
                                            <div class="card-body p-0">
                                                <div id="view-rooms-container">
                                                    <!-- Room data will be populated by AJAX -->
                                                    <div class="spinner-container">
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Đang tải...</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Services Section -->
                                        <div class="card mt-3">
                                            <div class="card-header bg-light">
                                                <h6 class="mb-0">Dịch vụ đã sử dụng</h6>
                                            </div>
                                            <div class="card-body p-0">
                                                <div id="view-services-container">
                                                    <!-- Service data will be populated by AJAX -->
                                                    <div class="spinner-container">
                                                        <div class="spinner-border text-primary" role="status">
                                                            <span class="sr-only">Đang tải...</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                    <button type="button" class="btn btn-warning edit-btn-modal" data-bookingid="">
                                        <i class="fa fa-edit"></i> Chỉnh sửa
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Booking Modal -->
                    <div class="modal fade" id="editBookingModal" tabindex="-1" role="dialog" aria-labelledby="editBookingModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="editBookingModalLabel">Chỉnh sửa đặt phòng #<span id="edit-bookingID-display"></span></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>

                                <div id="edit-loading" class="spinner-container">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="sr-only">Đang tải...</span>
                                    </div>
                                </div>

                                <div id="edit-content" style="display: none;">
                                    <div class="modal-body">
                                        <ul class="nav nav-tabs card-header-tabs" id="editTabs" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="details-tab" data-toggle="tab" href="#details" role="tab" aria-controls="details" aria-selected="true">
                                                    Thông tin đặt phòng
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="rooms-tab" data-toggle="tab" href="#rooms" role="tab" aria-controls="rooms" aria-selected="false">
                                                    Quản lý phòng
                                                </a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="services-tab" data-toggle="tab" href="#services" role="tab" aria-controls="services" aria-selected="false">
                                                    Quản lý dịch vụ
                                                </a>
                                            </li>
                                        </ul>

                                        <div class="tab-content mt-3" id="editTabsContent">
                                            <!-- Booking Details Tab -->
                                            <div class="tab-pane fade show active" id="details" role="tabpanel" aria-labelledby="details-tab">
                                                <form id="editBookingForm" method="post" class="needs-validation" novalidate>
                                                    <input type="hidden" name="action" value="update">
                                                    <input type="hidden" name="bookingId" id="edit-bookingID" value="">

                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="edit-customerID">Khách hàng <span class="text-danger">*</span></label>
                                                                <select name="customerID" id="edit-customerID" class="form-control" required>
                                                                    <option value="">-- Chọn khách hàng --</option>
                                                                    <!-- Customer options will be loaded by AJAX -->
                                                                </select>
                                                                <div class="invalid-feedback">Vui lòng chọn khách hàng.</div>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="edit-status">Trạng thái <span class="text-danger">*</span></label>
                                                                <select name="status" id="edit-status" class="form-control" required>
                                                                    <option value="Pending">Đang xử lý</option>
                                                                    <option value="Confirmed">Đã xác nhận</option>
                                                                    <option value="Cancelled">Đã hủy</option>
                                                                    <option value="Completed">Hoàn thành</option>
                                                                </select>
                                                                <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="edit-checkInDate">Ngày nhận phòng <span class="text-danger">*</span></label>
                                                                <input type="date" name="checkInDate" id="edit-checkInDate" class="form-control" required>
                                                                <div class="invalid-feedback">Vui lòng chọn ngày nhận phòng hợp lệ.</div>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="edit-checkOutDate">Ngày trả phòng <span class="text-danger">*</span></label>
                                                                <input type="date" name="checkOutDate" id="edit-checkOutDate" class="form-control" required>
                                                                <div class="invalid-feedback">Vui lòng chọn ngày trả phòng hợp lệ.</div>
                                                                <div class="form-text text-muted">Ngày trả phòng phải sau ngày nhận phòng.</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="edit-numberOfGuests">Số lượng khách <span class="text-danger">*</span></label>
                                                                <input type="number" name="numberOfGuests" id="edit-numberOfGuests" class="form-control" 
                                                                       min="1" value="1" required>
                                                                <div class="invalid-feedback">Vui lòng nhập số lượng khách hợp lệ (tối thiểu 1).</div>
                                                            </div>
                                                        </div>

                                                        <div class="col-md-6">
                                                            <div class="form-group">
                                                                <label for="edit-totalPrice">Tổng tiền</label>
                                                                <div class="input-group">
                                                                    <div class="input-group-prepend">
                                                                        <span class="input-group-text">₫</span>
                                                                    </div>
                                                                    <input type="text" class="form-control" id="edit-totalPrice" readonly>
                                                                </div>
                                                                <div class="form-text text-muted">Giá được tính dựa trên phòng và dịch vụ.</div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="edit-notes">Ghi chú</label>
                                                        <textarea name="notes" id="edit-notes" class="form-control" rows="3"></textarea>
                                                    </div>

                                                    <div class="d-flex justify-content-between">
                                                        <span class="text-muted">Cập nhật lần cuối: <span id="edit-updatedAt"></span></span>
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
                                                    <div class="col-md-8">
                                                        <div class="card mb-4">
                                                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                                                <h6 class="mb-0">Phòng đã chọn</h6>
                                                                <span class="badge badge-primary badge-counter" id="room-count">0 phòng</span>
                                                            </div>
                                                            <div class="card-body p-0">
                                                                <div id="assigned-rooms-container">
                                                                    <!-- Room data will be populated by AJAX -->
                                                                    <div class="spinner-container">
                                                                        <div class="spinner-border text-primary" role="status">
                                                                            <span class="sr-only">Đang tải...</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
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
                                                                <form id="addRoomForm" method="post" class="needs-validation" novalidate>
                                                                    <input type="hidden" name="action" value="addRoom">
                                                                    <input type="hidden" name="bookingId" id="edit-bookingID-room" value="">

                                                                    <div class="form-group">
                                                                        <label for="edit-roomId">Chọn phòng <span class="text-danger">*</span></label>
                                                                        <select name="roomId" id="edit-roomId" class="form-control" required>
                                                                            <option value="">-- Chọn phòng --</option>
                                                                            <!-- Available rooms will be loaded by AJAX -->
                                                                        </select>
                                                                        <div class="invalid-feedback">Vui lòng chọn phòng.</div>
                                                                        <div class="form-text">Chỉ hiển thị phòng trống.</div>
                                                                    </div>

                                                                    <div class="d-grid">
                                                                        <button type="submit" class="btn btn-success btn-block">
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
                                                    <div class="col-md-8">
                                                        <div class="card mb-4">
                                                            <div class="card-header bg-light d-flex justify-content-between align-items-center">
                                                                <h6 class="mb-0">Dịch vụ đã thêm</h6>
                                                                <span class="badge badge-primary badge-counter" id="service-count">0 dịch vụ</span>
                                                            </div>
                                                            <div class="card-body p-0">
                                                                <div id="assigned-services-container">
                                                                    <!-- Service data will be populated by AJAX -->
                                                                    <div class="spinner-container">
                                                                        <div class="spinner-border text-primary" role="status">
                                                                            <span class="sr-only">Đang tải...</span>
                                                                        </div>
                                                                    </div>
                                                                </div>
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
                                                                <form id="addServiceForm" method="post" class="needs-validation" novalidate>
                                                                    <input type="hidden" name="action" value="addService">
                                                                    <input type="hidden" name="bookingId" id="edit-bookingID-service" value="">

                                                                    <div class="form-group">
                                                                        <label for="edit-serviceId">Chọn dịch vụ <span class="text-danger">*</span></label>
                                                                        <select name="serviceId" id="edit-serviceId" class="form-control" required>
                                                                            <option value="">-- Chọn dịch vụ --</option>
                                                                            <!-- Available services will be loaded by AJAX -->
                                                                        </select>
                                                                        <div class="invalid-feedback">Vui lòng chọn dịch vụ.</div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label for="edit-quantity">Số lượng <span class="text-danger">*</span></label>
                                                                        <input type="number" name="quantity" id="edit-quantity" class="form-control" min="1" value="1" required>
                                                                        <div class="invalid-feedback">Vui lòng nhập số lượng hợp lệ (tối thiểu 1).</div>
                                                                    </div>

                                                                    <div class="form-group">
                                                                        <label for="edit-serviceDate">Ngày sử dụng dịch vụ <span class="text-danger">*</span></label>
                                                                        <input type="date" name="serviceDate" id="edit-serviceDate" class="form-control" required>
                                                                        <div class="invalid-feedback">Vui lòng chọn ngày sử dụng dịch vụ.</div>
                                                                        <div class="form-text">Ngày phải trong thời gian đặt phòng.</div>
                                                                    </div>

                                                                    <div class="d-grid">
                                                                        <button type="submit" class="btn btn-success btn-block">
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
                                    </div>

                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button id="recalculateBtn" class="btn btn-info" onclick="recalculateTotal()">
                                            <i class="fas fa-calculator"></i> Tính lại tổng tiền
                                        </button>
                                        <button type="button" class="btn btn-primary" id="saveBookingChanges">
                                            <i class="fas fa-save"></i> Lưu thay đổi
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Delete Modal -->
                    <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title">Xác nhận xóa</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    Bạn có chắc chắn muốn xóa đặt phòng này? Hành động này không thể hoàn tác.
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Ajax Result Modal -->
                    <div class="modal fade" id="ajaxResultModal" tabindex="-1" role="dialog" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="ajaxResultTitle">Thông báo</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <p id="ajaxResultMessage"></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-primary" data-dismiss="modal">Đồng ý</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
                    <script src="<%= request.getContextPath()%>/js/bootstrap.min.js"></script>
                    <script>
                                            $(document).ready(function () {
                                                // Initialize DataTable
                                                $('#booking-datatable').DataTable({
                                                    responsive: true,
                                                    paging: true,
                                                    ordering: true,
                                                    info: true,
                                                    columnDefs: [
                                                        {orderable: false, targets: -1} // Disable sort for last column (Action)
                                                    ],
                                                    language: {
                                                        url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                                                    }
                                                });

                                                // Load customer list for add booking form on page load
                                                loadCustomerList();

                                                // Set minimum dates for date inputs on page load
                                                setMinDates();

                                                // Handle Notification Box
                                                const notificationBox = $('.notification-box');
                                                if (notificationBox.children().length > 0) {
                                                    notificationBox.fadeIn();
                                                    setTimeout(() => notificationBox.fadeOut(), 3000);
                                                }

                                                // Initialize form validation
                                                initializeFormValidation();

                                                // Add booking modal initialization
                                                $('#addBookingModal').on('show.bs.modal', function () {
                                                    setMinDates();
                                                });

                                                // View booking modal initialization
                                                $('.view-btn').on('click', function () {
                                                    const bookingId = $(this).data('bookingid');
                                                    $('#view-loading').show();
                                                    $('#view-content').hide();
                                                    loadBookingDetails(bookingId, 'view');
                                                });

                                                // Edit booking modal initialization
                                                $('.edit-btn').on('click', function () {
                                                    const bookingId = $(this).data('bookingid');
                                                    $('#edit-loading').show();
                                                    $('#edit-content').hide();
                                                    loadBookingDetails(bookingId, 'edit');
                                                });

                                                // Edit button in view modal
                                                $(document).on('click', '.edit-btn-modal', function () {
                                                    const bookingId = $(this).data('bookingid');
                                                    $('#viewBookingModal').modal('hide');
                                                    setTimeout(() => {
                                                        $('#edit-loading').show();
                                                        $('#edit-content').hide();
                                                        loadBookingDetails(bookingId, 'edit');
                                                        $('#editBookingModal').modal('show');
                                                    }, 500);
                                                });

                                                // Tab change event in edit modal
                                                $('#editTabs a').on('click', function (e) {
                                                    e.preventDefault();
                                                    $(this).tab('show');

                                                    // Load data for the specific tab if needed
                                                    const tab = $(this).attr('href');
                                                    const bookingId = $('#edit-bookingID').val();

                                                    if (tab === '#rooms' && !$('#assigned-rooms-container').data('loaded')) {
                                                        loadRooms(bookingId);
                                                        loadAvailableRooms(bookingId);
                                                    } else if (tab === '#services' && !$('#assigned-services-container').data('loaded')) {
                                                        loadServices(bookingId);
                                                        loadAvailableServices();
                                                    }
                                                });

                                                // Save button in edit modal
                                                $('#saveBookingChanges').on('click', function () {
                                                    $('#editBookingForm').submit();
                                                });

                                                // Form submissions with AJAX
                                                $('#editBookingForm').on('submit', function (e) {
                                                    e.preventDefault();
                                                    submitForm($(this), 'edit');
                                                });

                                                $('#addBookingForm').on('submit', function (e) {
                                                    e.preventDefault();
                                                    submitForm($(this), 'add');
                                                });

                                                $('#addRoomForm').on('submit', function (e) {
                                                    e.preventDefault();
                                                    submitForm($(this), 'addRoom');
                                                });

                                                $('#addServiceForm').on('submit', function (e) {
                                                    e.preventDefault();
                                                    submitForm($(this), 'addService');
                                                });

                                                // Modal reset on close
                                                $('#viewBookingModal').on('hidden.bs.modal', function () {
                                                    resetViewModal();
                                                });

                                                $('#editBookingModal').on('hidden.bs.modal', function () {
                                                    resetEditModal();
                                                });

                                                $('#addBookingModal').on('hidden.bs.modal', function () {
                                                    resetAddModal();
                                                });
                                            });

                                            // Set minimum dates for date inputs
                                            function setMinDates() {
                                                const today = new Date();
                                                const yyyy = today.getFullYear();
                                                const mm = String(today.getMonth() + 1).padStart(2, '0');
                                                const dd = String(today.getDate()).padStart(2, '0');
                                                const todayFormatted = `${yyyy}-${mm}-${dd}`;

                                                        // For add form
                                                        $('#add-checkInDate').attr('min', todayFormatted);
                                                        $('#add-checkOutDate').attr('min', todayFormatted);
                                                        $('#add-checkInDate').val(todayFormatted);

                                                        // For edit form - these might be overridden when loading booking data
                                                        $('#edit-checkInDate').attr('min', todayFormatted);
                                                        $('#edit-checkOutDate').attr('min', todayFormatted);

                                                        // Event listeners for check-in date changes
                                                        $('#add-checkInDate').on('change', function () {
                                                            $('#add-checkOutDate').attr('min', this.value);

                                                            // If check-out date is earlier than check-in date, update it
                                                            const checkInDate = new Date(this.value);
                                                            const checkOutDate = new Date($('#add-checkOutDate').val());
                                                            if (checkOutDate <= checkInDate) {
                                                                // Set to next day
                                                                checkInDate.setDate(checkInDate.getDate() + 1);
                                                                const nextDay = formatDateForInput(checkInDate);
                                                                $('#add-checkOutDate').val(nextDay);
                                                            }
                                                        });

                                                        $('#edit-checkInDate').on('change', function () {
                                                            $('#edit-checkOutDate').attr('min', this.value);
                                                            $('#edit-serviceDate').attr('min', this.value);
                                                            $('#edit-serviceDate').attr('max', $('#edit-checkOutDate').val());

                                                            // If check-out date is earlier than check-in date, update it
                                                            const checkInDate = new Date(this.value);
                                                            const checkOutDate = new Date($('#edit-checkOutDate').val());
                                                            if (checkOutDate <= checkInDate) {
                                                                // Set to next day
                                                                checkInDate.setDate(checkInDate.getDate() + 1);
                                                                const nextDay = formatDateForInput(checkInDate);
                                                                $('#edit-checkOutDate').val(nextDay);
                                                            }
                                                        });

                                                        $('#edit-checkOutDate').on('change', function () {
                                                            $('#edit-serviceDate').attr('max', this.value);
                                                        });

                                                        // Set default for add form
                                                        const tomorrow = new Date(today);
                                                        tomorrow.setDate(tomorrow.getDate() + 1);
                                                        const tomorrowFormatted = formatDateForInput(tomorrow);
                                                        $('#add-checkOutDate').val(tomorrowFormatted);
                                                    }

                                                    // Initialize form validation
                                                    function initializeFormValidation() {
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
                                                                if (form.querySelector('#add-checkInDate') && form.querySelector('#add-checkOutDate')) {
                                                                    const checkInDate = new Date(document.getElementById('add-checkInDate').value);
                                                                    const checkOutDate = new Date(document.getElementById('add-checkOutDate').value);

                                                                    if (checkOutDate <= checkInDate) {
                                                                        event.preventDefault();
                                                                        showAlert('Lỗi', 'Ngày trả phòng phải sau ngày nhận phòng');
                                                                        return false;
                                                                    }
                                                                }

                                                                // Additional validation for edit form
                                                                if (form.querySelector('#edit-checkInDate') && form.querySelector('#edit-checkOutDate')) {
                                                                    const checkInDate = new Date(document.getElementById('edit-checkInDate').value);
                                                                    const checkOutDate = new Date(document.getElementById('edit-checkOutDate').value);

                                                                    if (checkOutDate <= checkInDate) {
                                                                        event.preventDefault();
                                                                        showAlert('Lỗi', 'Ngày trả phòng phải sau ngày nhận phòng');
                                                                        return false;
                                                                    }
                                                                }

                                                                // Additional validation for service date
                                                                if (form.querySelector('#edit-serviceDate')) {
                                                                    const serviceDate = new Date(document.getElementById('edit-serviceDate').value);
                                                                    const checkInDate = new Date(document.getElementById('edit-checkInDate').value);
                                                                    const checkOutDate = new Date(document.getElementById('edit-checkOutDate').value);

                                                                    if (serviceDate < checkInDate || serviceDate > checkOutDate) {
                                                                        event.preventDefault();
                                                                        showAlert('Lỗi', 'Ngày sử dụng dịch vụ phải trong thời gian đặt phòng');
                                                                        return false;
                                                                    }
                                                                }

                                                                form.classList.add('was-validated');
                                                            }, false);
                                                        });
                                                    }

                                                    // Load customer list
                                                    function loadCustomerList() {
                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getCustomers'
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                if (data.customers && data.customers.length > 0) {
                                                                    $('#add-customerID').empty();
                                                                    $('#add-customerID').append('<option value="">-- Chọn khách hàng --</option>');

                                                                    $.each(data.customers, function (i, customer) {
                                                                        $('#add-customerID').append(`<option value="${customer.userID}">${customer.fullName} (${customer.email})</option>`);
                                                                    });
                                                                }
                                                            },
                                                            error: function () {
                                                                showAlert('Lỗi', 'Đã xảy ra lỗi khi tải danh sách khách hàng.');
                                                            }
                                                        });
                                                    }

                                                    // Load booking details for view or edit
                                                    function loadBookingDetails(bookingId, mode) {
                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getBooking',
                                                                bookingId: bookingId
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                if (mode === 'view') {
                                                                    populateViewModal(data);
                                                                } else if (mode === 'edit') {
                                                                    populateEditModal(data);
                                                                }
                                                            },
                                                            error: function () {
                                                                showAlert('Lỗi', 'Đã xảy ra lỗi khi tải thông tin đặt phòng. Vui lòng thử lại.');
                                                                if (mode === 'view') {
                                                                    $('#viewBookingModal').modal('hide');
                                                                } else if (mode === 'edit') {
                                                                    $('#editBookingModal').modal('hide');
                                                                }
                                                            }
                                                        });
                                                    }

                                                    // Populate view modal with booking data
                                                    function populateViewModal(data) {
                                                        const booking = data.booking;

                                                        // Hide loading spinner
                                                        $('#view-loading').hide();
                                                        $('#view-content').show();

                                                        // Update booking information
                                                        $('#view-bookingID').text(booking.bookingID);

                                                        // Set status with proper styling
                                                        let statusHtml = '';
                                                        if (booking.status === 'Pending') {
                                                            statusHtml = '<span class="booking-status status-pending">Đang xử lý</span>';
                                                        } else if (booking.status === 'Confirmed') {
                                                            statusHtml = '<span class="booking-status status-confirmed">Đã xác nhận</span>';
                                                        } else if (booking.status === 'Cancelled') {
                                                            statusHtml = '<span class="booking-status status-cancelled">Đã hủy</span>';
                                                        } else if (booking.status === 'Completed') {
                                                            statusHtml = '<span class="booking-status status-completed">Hoàn thành</span>';
                                                        }
                                                        $('#view-status').html(statusHtml);

                                                        // Format dates
                                                        $('#view-bookingDate').text(formatDate(booking.bookingDate));
                                                        $('#view-checkInDate').text(formatDate(booking.checkInDate));
                                                        $('#view-checkOutDate').text(formatDate(booking.checkOutDate));
                                                        $('#view-updatedAt').text(formatDate(booking.updatedAt, true));

                                                        // Other booking details
                                                        $('#view-numberOfGuests').text(booking.numberOfGuests);
                                                        $('#view-totalPrice').text(formatCurrency(booking.totalPrice));
                                                        $('#view-notes').text(booking.notes ? booking.notes : 'Không có ghi chú');

                                                        // Update customer information
                                                        $('#view-customerName').text(booking.customer.fullName);
                                                        $('#view-customerEmail').text(booking.customer.email);
                                                        $('#view-customerPhone').text(booking.customer.phoneNumber || 'N/A');
                                                        $('#view-customerAddress').text(booking.customer.address || 'N/A');

                                                        // Set bookingId for edit button
                                                        $('.edit-btn-modal').data('bookingid', booking.bookingID);

                                                        // Load rooms and services
                                                        loadRoomsForView(booking.bookingID);
                                                        loadServicesForView(booking.bookingID);
                                                    }

                                                    // Populate edit modal with booking data
                                                    function populateEditModal(data) {
                                                        const booking = data.booking;
                                                        const customerList = data.customerList;

                                                        // Hide loading spinner
                                                        $('#edit-loading').hide();
                                                        $('#edit-content').show();

                                                        // Update booking ID display and hidden fields
                                                        $('#edit-bookingID-display').text(booking.bookingID);
                                                        $('#edit-bookingID').val(booking.bookingID);
                                                        $('#edit-bookingID-room').val(booking.bookingID);
                                                        $('#edit-bookingID-service').val(booking.bookingID);

                                                        // Clear and populate customer dropdown
                                                        $('#edit-customerID').empty();
                                                        $('#edit-customerID').append('<option value="">-- Chọn khách hàng --</option>');
                                                        $.each(customerList, function (i, customer) {
                                                            const selected = customer.userID == booking.customer.userID ? 'selected' : '';
                                                            $('#edit-customerID').append(`<option value="${customer.userID}" ${selected}>${customer.fullName} (${customer.email})</option>`);
                                                        });

                                                        // Set status
                                                        $('#edit-status').val(booking.status);

                                                        // Format dates for input fields (YYYY-MM-DD)
                                                        $('#edit-checkInDate').val(formatDateForInput(booking.checkInDate));
                                                        $('#edit-checkOutDate').val(formatDateForInput(booking.checkOutDate));

                                                        // Set other fields
                                                        $('#edit-numberOfGuests').val(booking.numberOfGuests);
                                                        $('#edit-totalPrice').val(formatNumber(booking.totalPrice));
                                                        $('#edit-notes').val(booking.notes);
                                                        $('#edit-updatedAt').text(formatDate(booking.updatedAt, true));

                                                        // Update service date min/max based on check-in/out dates
                                                        $('#edit-serviceDate').attr('min', formatDateForInput(booking.checkInDate));
                                                        $('#edit-serviceDate').attr('max', formatDateForInput(booking.checkOutDate));
                                                        // Default service date to check-in date
                                                        $('#edit-serviceDate').val(formatDateForInput(booking.checkInDate));
                                                    }

                                                    // Load rooms for view modal
                                                    function loadRoomsForView(bookingId) {
                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getRooms',
                                                                bookingId: bookingId
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                if (data.rooms && data.rooms.length > 0) {
                                                                    let html = '<table class="table table-bordered table-striped mb-0">';
                                                                    html += '<thead class="thead-light">';
                                                                    html += '<tr>';
                                                                    html += '<th>Số phòng</th>';
                                                                    html += '<th>Loại phòng</th>';
                                                                    html += '<th>Giá</th>';
                                                                    html += '<th>Trạng thái</th>';
                                                                    html += '</tr>';
                                                                    html += '</thead>';
                                                                    html += '<tbody>';

                                                                    $.each(data.rooms, function (i, room) {
                                                                        html += '<tr>';
                                                                        html += `<td>${room.roomNumber}</td>`;
                                                                        html += `<td>${room.categoryName}</td>`;
                                                                        html += `<td>${formatCurrency(room.priceAtBooking)}</td>`;

                                                                        let status = '';
                                                                        if (room.vacancyStatus === 'Vacant') {
                                                                            status = '<span class="badge badge-success">Trống</span>';
                                                                        } else {
                                                                            status = '<span class="badge badge-warning">Đã đặt</span>';
                                                                        }
                                                                        html += `<td>${status}</td>`;
                                                                        html += '</tr>';
                                                                    });

                                                                    html += '</tbody>';
                                                                    html += '</table>';
                                                                    $('#view-rooms-container').html
                                                                } else {
                                                                    $('#view-rooms-container').html('<div class="p-3 text-center text-muted">Không có phòng nào được đặt.</div>');
                                                                }
                                                            },
                                                            error: function () {
                                                                $('#view-rooms-container').html('<div class="p-3 text-center text-danger">Lỗi khi tải thông tin phòng. Vui lòng thử lại.</div>');
                                                            }
                                                        });
                                                    }

                                                    // Load services for view modal
                                                    function loadServicesForView(bookingId) {
                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getServices',
                                                                bookingId: bookingId
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                if (data.services && data.services.length > 0) {
                                                                    let html = '<table class="table table-bordered table-striped mb-0">';
                                                                    html += '<thead class="thead-light">';
                                                                    html += '<tr>';
                                                                    html += '<th>Dịch vụ</th>';
                                                                    html += '<th>Giá</th>';
                                                                    html += '<th>Số lượng</th>';
                                                                    html += '<th>Tổng</th>';
                                                                    html += '<th>Ngày sử dụng</th>';
                                                                    html += '</tr>';
                                                                    html += '</thead>';
                                                                    html += '<tbody>';

                                                                    $.each(data.services, function (i, service) {
                                                                        html += '<tr>';
                                                                        html += `<td>${service.serviceName}</td>`;
                                                                        html += `<td>${formatCurrency(service.priceAtBooking)}</td>`;
                                                                        html += `<td>${service.quantity}</td>`;
                                                                        html += `<td>${formatCurrency(service.priceAtBooking * service.quantity)}</td>`;
                                                                        html += `<td>${formatDate(service.serviceDate)}</td>`;
                                                                        html += '</tr>';
                                                                    });

                                                                    html += '</tbody>';
                                                                    html += '</table>';
                                                                    $('#view-services-container').html(html);
                                                                } else {
                                                                    $('#view-services-container').html('<div class="p-3 text-center text-muted">Không có dịch vụ nào được sử dụng.</div>');
                                                                }
                                                            },
                                                            error: function () {
                                                                $('#view-services-container').html('<div class="p-3 text-center text-danger">Lỗi khi tải thông tin dịch vụ. Vui lòng thử lại.</div>');
                                                            }
                                                        });
                                                    }

                                                    // Load rooms for edit modal
                                                    function loadRooms(bookingId) {
                                                        // Load assigned rooms
                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getRooms',
                                                                bookingId: bookingId
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                if (data.rooms && data.rooms.length > 0) {
                                                                    let html = '<table class="table table-hover table-striped mb-0">';
                                                                    html += '<thead class="thead-light">';
                                                                    html += '<tr>';
                                                                    html += '<th>Số phòng</th>';
                                                                    html += '<th>Loại phòng</th>';
                                                                    html += '<th>Giá</th>';
                                                                    html += '<th>Trạng thái</th>';
                                                                    html += '<th class="text-center">Thao tác</th>';
                                                                    html += '</tr>';
                                                                    html += '</thead>';
                                                                    html += '<tbody>';

                                                                    $.each(data.rooms, function (i, room) {
                                                                        html += '<tr>';
                                                                        html += `<td>${room.roomNumber}</td>`;
                                                                        html += `<td>${room.categoryName}</td>`;
                                                                        html += `<td>${formatCurrency(room.priceAtBooking)}</td>`;

                                                                        let status = '';
                                                                        if (room.vacancyStatus === 'Vacant') {
                                                                            status = '<span class="badge badge-success">Trống</span>';
                                                                        } else {
                                                                            status = '<span class="badge badge-warning">Đã đặt</span>';
                                                                        }
                                                                        html += `<td>${status}</td>`;

                                                                        html += '<td class="text-center">';
                                                                        html += `<button type="button" class="btn btn-sm btn-danger" onclick="removeRoom(${bookingId}, ${room.bookingRoomID})">`;
                                                                        html += '<i class="fas fa-trash"></i> Xóa';
                                                                        html += '</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                    });

                                                                    html += '</tbody>';
                                                                    html += '</table>';
                                                                    $('#assigned-rooms-container').html(html);
                                                                    $('#room-count').text(`${data.rooms.length} phòng`);
                                                                    $('#assigned-rooms-container').data('loaded', true);
                                                                } else {
                                                                    $('#assigned-rooms-container').html('<div class="p-3 text-center text-muted">Không có phòng nào được đặt.</div>');
                                                                    $('#room-count').text('0 phòng');
                                                                    $('#assigned-rooms-container').data('loaded', true);
                                                                }
                                                            },
                                                            error: function () {
                                                                $('#assigned-rooms-container').html('<div class="p-3 text-center text-danger">Lỗi khi tải thông tin phòng. Vui lòng thử lại.</div>');
                                                                $('#assigned-rooms-container').data('loaded', false);
                                                            }
                                                        });
                                                    }

                                                    // Load available rooms for booking
                                                    function loadAvailableRooms(bookingId) {
                                                        const checkInDate = $('#edit-checkInDate').val();
                                                        const checkOutDate = $('#edit-checkOutDate').val();

                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getAvailableRooms',
                                                                bookingId: bookingId,
                                                                checkInDate: checkInDate,
                                                                checkOutDate: checkOutDate
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                $('#edit-roomId').empty();
                                                                $('#edit-roomId').append('<option value="">-- Chọn phòng --</option>');

                                                                if (data.availableRooms && data.availableRooms.length > 0) {
                                                                    $.each(data.availableRooms, function (i, room) {
                                                                        $('#edit-roomId').append(`<option value="${room.roomID}">${room.roomNumber} - ${room.categoryName} - ${formatCurrency(room.price)}</option>`);
                                                                    });
                                                                } else {
                                                                    $('#edit-roomId').append('<option value="" disabled>Không có phòng trống</option>');
                                                                }
                                                            },
                                                            error: function () {
                                                                $('#edit-roomId').empty();
                                                                $('#edit-roomId').append('<option value="">-- Lỗi khi tải danh sách phòng --</option>');
                                                            }
                                                        });
                                                    }

                                                    // Load available services
                                                    function loadAvailableServices() {
                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getAvailableServices'
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                $('#edit-serviceId').empty();
                                                                $('#edit-serviceId').append('<option value="">-- Chọn dịch vụ --</option>');

                                                                if (data.availableServices && data.availableServices.length > 0) {
                                                                    $.each(data.availableServices, function (i, service) {
                                                                        $('#edit-serviceId').append(`<option value="${service.serviceID}">${service.serviceName} - ${formatCurrency(service.price)}</option>`);
                                                                    });
                                                                } else {
                                                                    $('#edit-serviceId').append('<option value="" disabled>Không có dịch vụ</option>');
                                                                }
                                                            },
                                                            error: function () {
                                                                $('#edit-serviceId').empty();
                                                                $('#edit-serviceId').append('<option value="">-- Lỗi khi tải danh sách dịch vụ --</option>');
                                                            }
                                                        });
                                                    }

                                                    // Load services for edit modal
                                                    function loadServices(bookingId) {
                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'getServices',
                                                                bookingId: bookingId
                                                            },
                                                            dataType: 'json',
                                                            success: function (data) {
                                                                if (data.services && data.services.length > 0) {
                                                                    let html = '<table class="table table-hover table-striped mb-0">';
                                                                    html += '<thead class="thead-light">';
                                                                    html += '<tr>';
                                                                    html += '<th>Dịch vụ</th>';
                                                                    html += '<th>Giá</th>';
                                                                    html += '<th>Số lượng</th>';
                                                                    html += '<th>Tổng</th>';
                                                                    html += '<th>Ngày sử dụng</th>';
                                                                    html += '<th class="text-center">Thao tác</th>';
                                                                    html += '</tr>';
                                                                    html += '</thead>';
                                                                    html += '<tbody>';

                                                                    $.each(data.services, function (i, service) {
                                                                        html += '<tr>';
                                                                        html += `<td>${service.serviceName}</td>`;
                                                                        html += `<td>${formatCurrency(service.priceAtBooking)}</td>`;
                                                                        html += `<td>${service.quantity}</td>`;
                                                                        html += `<td>${formatCurrency(service.priceAtBooking * service.quantity)}</td>`;
                                                                        html += `<td>${formatDate(service.serviceDate)}</td>`;
                                                                        html += '<td class="text-center">';
                                                                        html += `<button type="button" class="btn btn-sm btn-danger" onclick="removeService(${bookingId}, ${service.bookingServiceID})">`;
                                                                        html += '<i class="fas fa-trash"></i> Xóa';
                                                                        html += '</button>';
                                                                        html += '</td>';
                                                                        html += '</tr>';
                                                                    });

                                                                    html += '</tbody>';
                                                                    html += '</table>';
                                                                    $('#assigned-services-container').html(html);
                                                                    $('#service-count').text(`${data.services.length} dịch vụ`);
                                                                    $('#assigned-services-container').data('loaded', true);
                                                                } else {
                                                                    $('#assigned-services-container').html('<div class="p-3 text-center text-muted">Không có dịch vụ nào được sử dụng.</div>');
                                                                    $('#service-count').text('0 dịch vụ');
                                                                    $('#assigned-services-container').data('loaded', true);
                                                                }
                                                            },
                                                            error: function () {
                                                                $('#assigned-services-container').html('<div class="p-3 text-center text-danger">Lỗi khi tải thông tin dịch vụ. Vui lòng thử lại.</div>');
                                                                $('#assigned-services-container').data('loaded', false);
                                                            }
                                                        });
                                                    }

                                                    // Remove room from booking
                                                    function removeRoom(bookingId, bookingRoomId) {
                                                        if (!confirm('Bạn có chắc chắn muốn xóa phòng này khỏi đặt phòng?')) {
                                                            return;
                                                        }

                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'POST',
                                                            data: {
                                                                action: 'removeRoom',
                                                                bookingId: bookingId,
                                                                bookingRoomId: bookingRoomId
                                                            },
                                                            dataType: 'json',
                                                            success: function (response) {
                                                                if (response.success) {
                                                                    // Reload rooms list
                                                                    loadRooms(bookingId);
                                                                    // Reload available rooms
                                                                    loadAvailableRooms(bookingId);
                                                                    // Update total price
                                                                    if (response.totalPrice !== undefined) {
                                                                        $('#edit-totalPrice').val(formatNumber(response.totalPrice));
                                                                    }
                                                                    showAlert('Thành công', 'Đã xóa phòng khỏi đặt phòng.');
                                                                } else {
                                                                    showAlert('Lỗi', response.message || 'Không thể xóa phòng khỏi đặt phòng.');
                                                                }
                                                            },
                                                            error: function () {
                                                                showAlert('Lỗi', 'Đã xảy ra lỗi khi xóa phòng. Vui lòng thử lại.');
                                                            }
                                                        });
                                                    }

                                                    // Remove service from booking
                                                    function removeService(bookingId, bookingServiceId) {
                                                        if (!confirm('Bạn có chắc chắn muốn xóa dịch vụ này khỏi đặt phòng?')) {
                                                            return;
                                                        }

                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'POST',
                                                            data: {
                                                                action: 'removeService',
                                                                bookingId: bookingId,
                                                                bookingServiceId: bookingServiceId
                                                            },
                                                            dataType: 'json',
                                                            success: function (response) {
                                                                if (response.success) {
                                                                    // Reload services list
                                                                    loadServices(bookingId);
                                                                    // Update total price
                                                                    if (response.totalPrice !== undefined) {
                                                                        $('#edit-totalPrice').val(formatNumber(response.totalPrice));
                                                                    }
                                                                    showAlert('Thành công', 'Đã xóa dịch vụ khỏi đặt phòng.');
                                                                } else {
                                                                    showAlert('Lỗi', response.message || 'Không thể xóa dịch vụ khỏi đặt phòng.');
                                                                }
                                                            },
                                                            error: function () {
                                                                showAlert('Lỗi', 'Đã xảy ra lỗi khi xóa dịch vụ. Vui lòng thử lại.');
                                                            }
                                                        });
                                                    }

                                                    // Recalculate booking total
                                                    function recalculateTotal() {
                                                        const bookingId = $('#edit-bookingID').val();

                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'GET',
                                                            data: {
                                                                action: 'recalculateTotal',
                                                                bookingId: bookingId
                                                            },
                                                            dataType: 'json',
                                                            success: function (response) {
                                                                if (response.success && response.totalPrice !== undefined) {
                                                                    $('#edit-totalPrice').val(formatNumber(response.totalPrice));
                                                                    showAlert('Thành công', 'Đã cập nhật tổng tiền.');
                                                                } else {
                                                                    showAlert('Lỗi', response.message || 'Không thể tính lại tổng tiền.');
                                                                }
                                                            },
                                                            error: function () {
                                                                showAlert('Lỗi', 'Đã xảy ra lỗi khi tính lại tổng tiền. Vui lòng thử lại.');
                                                            }
                                                        });
                                                    }

                                                    // Submit form via AJAX
                                                    function submitForm(form, type) {
                                                        const formData = form.serialize();

                                                        $.ajax({
                                                            url: 'manage-bookings',
                                                            type: 'POST',
                                                            data: formData,
                                                            dataType: 'json',
                                                            success: function (response) {
                                                                if (response.success) {
                                                                    switch (type) {
                                                                        case 'add':
                                                                            $('#addBookingModal').modal('hide');
                                                                            showAlert('Thành công', 'Đã tạo đặt phòng mới thành công.');
                                                                            // Reload page after short delay
                                                                            setTimeout(() => window.location.reload(), 1500);
                                                                            break;

                                                                        case 'edit':
                                                                            showAlert('Thành công', 'Đã cập nhật thông tin đặt phòng.');
                                                                            // Update total price if returned
                                                                            if (response.totalPrice !== undefined) {
                                                                                $('#edit-totalPrice').val(formatNumber(response.totalPrice));
                                                                            }
                                                                            break;

                                                                        case 'addRoom':
                                                                            // Reload rooms list
                                                                            loadRooms(response.bookingId);
                                                                            // Reload available rooms
                                                                            loadAvailableRooms(response.bookingId);
                                                                            // Update total price if returned
                                                                            if (response.totalPrice !== undefined) {
                                                                                $('#edit-totalPrice').val(formatNumber(response.totalPrice));
                                                                            }
                                                                            // Reset room form
                                                                            $('#edit-roomId').val('');
                                                                            showAlert('Thành công', 'Đã thêm phòng vào đặt phòng.');
                                                                            break;

                                                                        case 'addService':
                                                                            // Reload services list
                                                                            loadServices(response.bookingId);
                                                                            // Update total price if returned
                                                                            if (response.totalPrice !== undefined) {
                                                                                $('#edit-totalPrice').val(formatNumber(response.totalPrice));
                                                                            }
                                                                            // Reset service form
                                                                            $('#edit-serviceId').val('');
                                                                            $('#edit-quantity').val(1);
                                                                            showAlert('Thành công', 'Đã thêm dịch vụ vào đặt phòng.');
                                                                            break;
                                                                    }
                                                                } else {
                                                                    showAlert('Lỗi', response.message || 'Không thể lưu. Vui lòng thử lại.');
                                                                }
                                                            },
                                                            error: function () {
                                                                showAlert('Lỗi', 'Đã xảy ra lỗi khi lưu. Vui lòng thử lại.');
                                                            }
                                                        });
                                                    }

                                                    // Reset modals
                                                    function resetViewModal() {
                                                        $('#view-bookingID').text('');
                                                        $('#view-status').html('');
                                                        $('#view-bookingDate').text('');
                                                        $('#view-checkInDate').text('');
                                                        $('#view-checkOutDate').text('');
                                                        $('#view-numberOfGuests').text('');
                                                        $('#view-totalPrice').text('');
                                                        $('#view-notes').text('Không có ghi chú');
                                                        $('#view-updatedAt').text('');
                                                        $('#view-customerName').text('');
                                                        $('#view-customerEmail').text('');
                                                        $('#view-customerPhone').text('');
                                                        $('#view-customerAddress').text('');
                                                        $('#view-rooms-container').html('<div class="spinner-container"><div class="spinner-border text-primary" role="status"><span class="sr-only">Đang tải...</span></div></div>');
                                                        $('#view-services-container').html('<div class="spinner-container"><div class="spinner-border text-primary" role="status"><span class="sr-only">Đang tải...</span></div></div>');
                                                        $('.edit-btn-modal').data('bookingid', '');
                                                    }

                                                    function resetEditModal() {
                                                        $('#edit-bookingID-display').text('');
                                                        $('#edit-bookingID').val('');
                                                        $('#edit-bookingID-room').val('');
                                                        $('#edit-bookingID-service').val('');
                                                        $('#edit-customerID').empty();
                                                        $('#edit-status').val('Pending');
                                                        $('#edit-checkInDate').val('');
                                                        $('#edit-checkOutDate').val('');
                                                        $('#edit-numberOfGuests').val(1);
                                                        $('#edit-totalPrice').val('');
                                                        $('#edit-notes').val('');
                                                        $('#edit-updatedAt').text('');
                                                        $('#assigned-rooms-container').html('<div class="spinner-container"><div class="spinner-border text-primary" role="status"><span class="sr-only">Đang tải...</span></div></div>');
                                                        $('#assigned-services-container').html('<div class="spinner-container"><div class="spinner-border text-primary" role="status"><span class="sr-only">Đang tải...</span></div></div>');
                                                        $('#edit-roomId').empty();
                                                        $('#edit-serviceId').empty();
                                                        $('#edit-quantity').val(1);
                                                        $('#edit-serviceDate').val('');
                                                        $('#assigned-rooms-container').data('loaded', false);
                                                        $('#assigned-services-container').data('loaded', false);
                                                        // Reset to first tab
                                                        $('#details-tab').tab('show');
                                                    }

                                                    function resetAddModal() {
                                                        $('#add-customerID').val('');
                                                        $('#add-status').val('Pending');
                                                        const today = new Date();
                                                        const tomorrow = new Date(today);
                                                        tomorrow.setDate(tomorrow.getDate() + 1);
                                                        $('#add-checkInDate').val(formatDateForInput(today));
                                                        $('#add-checkOutDate').val(formatDateForInput(tomorrow));
                                                        $('#add-numberOfGuests').val(1);
                                                        $('#add-notes').val('');
                                                        $('#addBookingForm').removeClass('was-validated');
                                                    }

                                                    // Show alert using modal
                                                    function showAlert(title, message) {
                                                        $('#ajaxResultTitle').text(title);
                                                        $('#ajaxResultMessage').text(message);
                                                        $('#ajaxResultModal').modal('show');
                                                    }

                                                    // Format date for display
                                                    function formatDate(dateStr, includeTime = false) {
                                                        if (!dateStr)
                                                            return '';

                                                        const date = new Date(dateStr);
                                                        const day = String(date.getDate()).padStart(2, '0');
                                                        const month = String(date.getMonth() + 1).padStart(2, '0');
                                                        const year = date.getFullYear();

                                                        if (!includeTime) {
                                                            return `${day}-${month}-${year}`;
                                                                    }

                                                                    const hours = String(date.getHours()).padStart(2, '0');
                                                                    const minutes = String(date.getMinutes()).padStart(2, '0');

                                                                    return `${day}-${month}-${year} ${hours}:${minutes}`;
                                                                        }

                                                                        // Format date for input fields (YYYY-MM-DD)
                                                                        function formatDateForInput(dateStr) {
                                                                            if (!dateStr)
                                                                                return '';

                                                                            const date = new Date(dateStr);
                                                                            const year = date.getFullYear();
                                                                            const month = String(date.getMonth() + 1).padStart(2, '0');
                                                                            const day = String(date.getDate()).padStart(2, '0');

                                                                            return `${year}-${month}-${day}`;
                                                                                }

                                                                                // Format currency
                                                                                function formatCurrency(amount) {
                                                                                    return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND', minimumFractionDigits: 0}).format(amount);
                                                                                }

                                                                                // Format number
                                                                                function formatNumber(amount) {
                                                                                    return new Intl.NumberFormat('vi-VN', {minimumFractionDigits: 0}).format(amount);
                                                                                }

                                                                                // Delete confirmation function
                                                                                function confirmDelete(bookingId) {
                                                                                    $('#confirmDeleteBtn').attr('href', 'manage-bookings?action=delete&bookingId=' + bookingId);
                                                                                    $('#deleteModal').modal('show');
                                                                                }
                    </script>
                </main>
                <%@ include file="/View/Common/footer.jsp" %>
            </div>
        </div>
    </body>
</html>