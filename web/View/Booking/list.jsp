<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Booking Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <!-- Include the header/navigation -->
        <jsp:include page="../includes/header.jsp" />

        <div class="container mt-4">
            <div class="row">
                <div class="col-md-12">
                    <h2>Booking Management</h2>

                    <!-- Display success or error messages if any -->
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${sessionScope.successMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <c:remove var="successMessage" scope="session" />
                    </c:if>

                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${sessionScope.errorMessage}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

                    <!-- Search and Filter Form -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5>Search and Filter</h5>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/staff/booking" method="get" class="row">
                                <div class="col-md-4 form-group">
                                    <label for="search">Search</label>
                                    <input type="text" name="search" id="search" class="form-control" 
                                           placeholder="Search by booking ID or customer name" value="${searchTerm}">
                                </div>
                                <div class="col-md-3 form-group">
                                    <label for="status">Status</label>
                                    <select name="status" id="status" class="form-control">
                                        <option value="">All Statuses</option>
                                        <c:forEach items="${statusOptions}" var="option">
                                            <option value="${option}" ${status eq option ? 'selected' : ''}>${option}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2 form-group align-self-end">
                                    <button type="submit" class="btn btn-primary btn-block">Search</button>
                                </div>
                                <div class="col-md-3 form-group align-self-end">
                                    <a href="${pageContext.request.contextPath}/staff/booking/create" class="btn btn-success btn-block">
                                        <i class="fa fa-plus"></i> Create New Booking
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Bookings Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5>Bookings</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Customer</th>
                                            <th>Check-in Date</th>
                                            <th>Check-out Date</th>
                                            <th>Status</th>
                                            <th>Total Price</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty bookings}">
                                                <tr>
                                                    <td colspan="7" class="text-center">No bookings found</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach items="${bookings}" var="booking">
                                                    <tr>
                                                        <td>${booking.bookingID}</td>
                                                        <td>${booking.customer.fullName}</td>
                                                        <td><fmt:formatDate value="${booking.checkInDate}" pattern="dd-MM-yyyy" /></td>
                                                        <td><fmt:formatDate value="${booking.checkOutDate}" pattern="dd-MM-yyyy" /></td>
                                                        <td>
                                                            <span class="badge 
                                                                  ${booking.status eq 'Pending' ? 'badge-warning' : 
                                                                    booking.status eq 'Confirmed' ? 'badge-primary' : 
                                                                    booking.status eq 'Cancelled' ? 'badge-danger' : 
                                                                    booking.status eq 'Completed' ? 'badge-success' : 'badge-secondary'}">
                                                                      ${booking.status}
                                                                  </span>
                                                            </td>
                                                            <td>$<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00" /></td>
                                                            <td>
                                                                <div class="btn-group" role="group">
                                                                    <a href="${pageContext.request.contextPath}/staff/booking/view?id=${booking.bookingID}" 
                                                                       class="btn btn-sm btn-info" title="View">
                                                                        <i class="fa fa-eye"></i>
                                                                    </a>
                                                                    <a href="${pageContext.request.contextPath}/staff/booking/edit?id=${booking.bookingID}" 
                                                                       class="btn btn-sm btn-primary" title="Edit">
                                                                        <i class="fa fa-edit"></i>
                                                                    </a>
                                                                    <button type="button" class="btn btn-sm btn-danger" title="Delete"
                                                                            onclick="confirmDelete(${booking.bookingID})">
                                                                        <i class="fa fa-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${totalPages > 1}">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination justify-content-center">
                                            <!-- Previous page link -->
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/staff/booking?page=${currentPage - 1}&search=${searchTerm}&status=${status}">Previous</a>
                                            </li>

                                            <!-- Page numbers -->
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/staff/booking?page=${i}&search=${searchTerm}&status=${status}">${i}</a>
                                                </li>
                                            </c:forEach>

                                            <!-- Next page link -->
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/staff/booking?page=${currentPage + 1}&search=${searchTerm}&status=${status}">Next</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Delete Confirmation Modal -->
            <div class="modal fade" id="deleteModal" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            Are you sure you want to delete this booking? This action cannot be undone.
                        </div>
                        <div class="modal-footer">
                            <form id="deleteForm" action="${pageContext.request.contextPath}/staff/booking/delete" method="post">
                                <input type="hidden" id="deleteBookingId" name="id" value="">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Include the footer -->
            <jsp:include page="../includes/footer.jsp" />

            <script>
                // Function to show delete confirmation modal
                function confirmDelete(bookingId) {
                    document.getElementById('deleteBookingId').value = bookingId;
                    $('#deleteModal').modal('show');
                }

                // Automatically close alerts after 5 seconds
                $(document).ready(function () {
                    window.setTimeout(function () {
                        $(".alert").fadeTo(500, 0).slideUp(500, function () {
                            $(this).remove();
                        });
                    }, 5000);
                });
            </script>
        </body>
    </html>