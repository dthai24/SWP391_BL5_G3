<%@ page import="java.util.List" %>
<%@ page import="Model.Booking" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Management</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
    <%@ include file="/View/Common/header.jsp" %>
    <style>
        .table-responsive { overflow-x: auto !important; }
        #booking-datatable { min-width: 900px !important; table-layout: fixed; }
        #booking-datatable th, #booking-datatable td { white-space: normal !important; word-break: break-word !important; vertical-align: middle; }
        #booking-datatable td { max-width: 160px; }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="/View/Common/sidebar.jsp" %>
    <div class="main">
        <%@ include file="/View/Common/navbar.jsp" %>
        <main class="content">
            <% List<Booking> bookings = (List<Booking>)request.getAttribute("bookings"); %>
            <!-- Add Booking Modal -->
            <div class="modal fade" id="addBookingModal" tabindex="-1" role="dialog" aria-labelledby="addBookingModalLabel" aria-hidden="true">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                  <form action="manage-bookings" method="post">
                    <div class="modal-header">
                      <h5 class="modal-title" id="addBookingModalLabel">Thêm đặt phòng mới</h5>
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                    </div>
                    <div class="modal-body">
                      <div class="form-group">
                        <label>Khách hàng (ID)</label>
                        <input type="number" name="customerID" class="form-control" required />
                      </div>
                      <div class="form-group">
                        <label>Ngày nhận</label>
                        <input type="date" name="checkInDate" class="form-control" required />
                      </div>
                      <div class="form-group">
                        <label>Ngày trả</label>
                        <input type="date" name="checkOutDate" class="form-control" required />
                      </div>
                      <div class="form-group">
                        <label>Số khách</label>
                        <input type="number" name="numberOfGuests" class="form-control" min="1" required />
                      </div>
                      <div class="form-group">
                        <label>Trạng thái</label>
                        <select name="status" class="form-control">
                          <option value="Pending">Pending</option>
                          <option value="Confirmed">Confirmed</option>
                          <option value="Completed">Completed</option>
                          <option value="Cancelled">Cancelled</option>
                        </select>
                      </div>
                      <div class="form-group">
                        <label>Ghi chú</label>
                        <input type="text" name="notes" class="form-control" />
                      </div>
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                      <button type="submit" class="btn btn-primary">Thêm mới</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
            <div class="container mt-5">
                <div class="card shadow-lg">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center" style="border-bottom: 1px solid #dee2e6;">
                        <h3 class="mb-0">Danh Sách Đặt Phòng</h3>
                        <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addBookingModal">
                            <i class="fa fa-plus"></i> Thêm Đặt Phòng Mới
                        </button>
                    </div>
                    <div class="card-body">
                        <!-- Filter -->
                        <form method="get" action="manage-bookings" class="form-inline mb-3" id="booking-filter-form">
                          <div class="form-group mr-2">
                            <label for="filterStatus" class="mr-2">Trạng thái</label>
                            <select name="filterStatus" id="filterStatus" class="form-control">
                              <option value="">Tất cả</option>
                              <option value="Pending">Pending</option>
                              <option value="Confirmed">Confirmed</option>
                              <option value="Completed">Completed</option>
                              <option value="Cancelled">Cancelled</option>
                            </select>
                          </div>
                          <button type="submit" class="btn btn-primary mr-2">Lọc</button>
                          <a href="manage-bookings" class="btn btn-secondary">Hủy</a>
                        </form>
                        <!-- End filter -->
                        <div class="table-responsive" style="overflow-x:auto;">
                            <table id="booking-datatable" class="table table-hover table-striped align-middle mb-0" style="width:100%; table-layout:fixed; font-size: 15px;">
                                <thead class="thead-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày nhận</th>
                                        <th>Ngày trả</th>
                                        <th>Số khách</th>
                                        <th>Trạng thái</th>
                                        <th>Tổng tiền</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (bookings != null && !bookings.isEmpty()) {
                                        for (Booking b : bookings) { %>
                                    <tr>
                                        <td><%= b.getBookingID() %></td>
                                        <td><%= b.getCustomerID() %></td>
                                        <td><%= b.getCheckInDate() %></td>
                                        <td><%= b.getCheckOutDate() %></td>
                                        <td><%= b.getNumberOfGuests() %></td>
                                        <td><%= b.getStatus() %></td>
                                        <td><%= b.getTotalPrice() != null ? b.getTotalPrice() : "-" %></td>
                                        <td>
                                            <button type="button" class="btn btn-link p-0 view-btn"
                                                data-bookingid="<%= b.getBookingID() %>"
                                                data-customerid="<%= b.getCustomerID() %>"
                                                data-checkindate="<%= b.getCheckInDate() %>"
                                                data-checkoutdate="<%= b.getCheckOutDate() %>"
                                                data-numberofguests="<%= b.getNumberOfGuests() %>"
                                                data-status="<%= b.getStatus() %>"
                                                data-totalprice="<%= b.getTotalPrice() %>"
                                                data-toggle="modal" data-target="#viewBookingModal"
                                                title="Xem chi tiết">
                                                <i class="fa fa-eye" style="color: #17a2b8; font-size: 1.2rem;"></i>
                                            </button>
                                            <button type="button" class="btn btn-link p-0 edit-btn"
                                                data-bookingid="<%= b.getBookingID() %>"
                                                data-customerid="<%= b.getCustomerID() %>"
                                                data-checkindate="<%= b.getCheckInDate() %>"
                                                data-checkoutdate="<%= b.getCheckOutDate() %>"
                                                data-numberofguests="<%= b.getNumberOfGuests() %>"
                                                data-status="<%= b.getStatus() %>"
                                                data-totalprice="<%= b.getTotalPrice() %>"
                                                data-toggle="modal" data-target="#editBookingModal"
                                                title="Sửa">
                                                <i class="fa fa-edit" style="color: #ffc107; font-size: 1.2rem;"></i>
                                            </button>
                                            <form method="post" action="manage-bookings" class="d-inline delete-booking-form" style="display:inline;">
                                                <input type="hidden" name="deleteBookingID" value="<%= b.getBookingID() %>" />
                                                <button type="submit" class="btn btn-link p-0 delete-btn" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa đặt phòng này?');">
                                                    <i class="fa fa-trash" style="color: #dc3545; font-size: 1.2rem;"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <%   }
                                    } else { %>
                                    <tr><td colspan="8" class="text-center">Không có đặt phòng nào.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
            <script src="js/bootstrap.min.js"></script>
            <script>
            $(document).ready(function(){
                $('#booking-datatable').DataTable({
                    responsive: true,
                    paging: true,
                    ordering: true,
                    info: true,
                    columnDefs: [
                        { orderable: false, targets: -1 }
                    ],
                    language: {
                        url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                    }
                });
            });
            </script>
        </main>
        <%@ include file="/View/Common/footer.jsp" %>
    </div>
</div>
</body>
</html>