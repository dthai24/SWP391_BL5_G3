<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Hotel Management System">
    <meta name="author" content="Your Name">

    <title>Booking Management</title>

    <%@ include file="/View/Common/header.jsp" %>
    
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
    
    <!-- Custom CSS for Booking -->
    <style>
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
                            <h3>Booking Management</h3>
                        </div>

                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<%= request.getContextPath() %>/manage-bookings?action=add" class="btn btn-primary">
                                <i class="fa fa-plus"></i> New Booking
                            </a>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">All Bookings</h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    ${errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    ${successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>

                            <div class="table-responsive">
                                <table id="booking-datatable" class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Customer</th>
                                            <th>Check-in</th>
                                            <th>Check-out</th>
                                            <th>Status</th>
                                            <th>Total Amount</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="booking" items="${bookings}">
                                            <tr>
                                                <td>${booking.bookingID}</td>
                                                <td>${booking.customer.fullName}</td>
                                                <td><fmt:formatDate value="${booking.checkInDate}" pattern="yyyy-MM-dd" /></td>
                                                <td><fmt:formatDate value="${booking.checkOutDate}" pattern="yyyy-MM-dd" /></td>
                                                <td>
                                                    <span class="booking-status status-${booking.status.toLowerCase()}">${booking.status}</span>
                                                </td>
                                                <td><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="$" /></td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="manage-bookings?action=view&bookingId=${booking.bookingID}" class="btn btn-info btn-sm">
                                                            <i class="fa fa-eye"></i>
                                                        </a>
                                                        <a href="manage-bookings?action=edit&bookingId=${booking.bookingID}" class="btn btn-primary btn-sm">
                                                            <i class="fa fa-edit"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-danger btn-sm" onclick="confirmDelete(${booking.bookingID})">
                                                            <i class="fa fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <%@ include file="/View/Common/footer.jsp" %>
        </div>
    </div>

    <!-- jQuery, DataTables & Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
    <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
    
    <!-- Delete confirmation modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete this booking? This action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Initialize DataTable
        $(document).ready(function() {
            $('#booking-datatable').DataTable({
                "pageLength": 10,
                "language": {
                    "search": "Search bookings:",
                    "lengthMenu": "Show _MENU_ bookings per page",
                    "zeroRecords": "No bookings found",
                    "info": "Showing _START_ to _END_ of _TOTAL_ bookings",
                    "infoEmpty": "No bookings available",
                    "infoFiltered": "(filtered from _MAX_ total bookings)"
                },
                "order": [[0, 'desc']], // Sort by ID descending
                "columns": [
                    { "width": "5%" },  // ID
                    { "width": "20%" }, // Customer
                    { "width": "12%" }, // Check-in
                    { "width": "12%" }, // Check-out
                    { "width": "13%" }, // Status
                    { "width": "13%" }, // Total Amount
                    { "width": "15%", "orderable": false } // Actions (non-sortable)
                ]
            });
        });

        // Delete confirmation function
        function confirmDelete(bookingId) {
            $('#confirmDeleteBtn').attr('href', 'manage-bookings?action=delete&bookingId=' + bookingId);
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }
    </script>
</body>
</html>