<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
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

        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
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
            .status-pending { background-color: #ffc107; color: #212529; }
            .status-confirmed { background-color: #28a745; color: #fff; }
            .status-cancelled { background-color: #dc3545; color: #fff; }
            .status-completed { background-color: #6c757d; color: #fff; }
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
                    <% if (successMessage != null) { %>
                    <div class="alert alert-success alert-dismissible fade show notification-box" role="alert">
                        <%= successMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% } %>
                    <% if (errorMessage != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show notification-box" role="alert">
                        <%= errorMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% } %>

                    <!-- Table Section -->
                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Đặt Phòng</h3>
                                <a href="<%= request.getContextPath() %>/manage-bookings?action=add" class="btn btn-success">
                                    <i class="fa fa-plus"></i> Thêm Đặt Phòng Mới
                                </a>
                            </div>

                            <div class="card-body">
                                <form method="get" action="manage-bookings" class="form-inline mb-3">
                                    <div class="form-group mr-2">
                                        <label for="filterStatus" class="mr-2">Trạng thái</label>
                                        <select name="filterStatus" id="filterStatus" class="form-control">
                                            <option value="">Tất cả</option>
                                            <option value="Pending" <%= "Pending".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Đang xử lý</option>
                                            <option value="Confirmed" <%= "Confirmed".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Đã xác nhận</option>
                                            <option value="Cancelled" <%= "Cancelled".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Đã hủy</option>
                                            <option value="Completed" <%= "Completed".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Hoàn thành</option>
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
                                                        <a href="manage-bookings?action=view&bookingId=${booking.bookingID}" class="btn btn-link p-0">
                                                            <i class="fa fa-eye" style="color: #17a2b8;"></i>
                                                        </a>
                                                        <a href="manage-bookings?action=edit&bookingId=${booking.bookingID}" class="btn btn-link p-0">
                                                            <i class="fa fa-edit" style="color: #ffc107;"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-link p-0" onclick="confirmDelete(${booking.bookingID})">
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

                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
                    <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
                    <script>
                        $(document).ready(function() {
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
                            
                            // Handle Notification Box
                            const notificationBox = $('.notification-box');
                            if (notificationBox.children().length > 0) {
                                notificationBox.fadeIn();
                                setTimeout(() => notificationBox.fadeOut(), 3000);
                            }
                        });
                        
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