<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .table th, .table td {
            vertical-align: middle;
        }
        .action-buttons {
            white-space: nowrap;
        }
        .booking-status {
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .status-pending { background-color: #FFC107; color: #000; }
        .status-confirmed { background-color: #28A745; color: #fff; }
        .status-cancelled { background-color: #DC3545; color: #fff; }
        .status-completed { background-color: #6C757D; color: #fff; }
    </style>
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Sidebar/Navigation will go here -->
            
            <div class="col-md-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Booking Management</h5>
                        <c:if test="${sessionScope.user.role eq 'Manager'}">
                            <a href="manage-bookings?action=add" class="btn btn-sm btn-light">
                                <i class="fas fa-plus"></i> New Booking
                            </a>
                        </c:if>
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
                        
                        <!-- Filter Form -->
                        <form method="get" action="manage-bookings" class="row g-3 mb-4">
                            <input type="hidden" name="action" value="list">
                            <div class="col-md-4">
                                <select name="statusFilter" class="form-select">
                                    <option value="" ${statusFilter == null ? 'selected' : ''}>All Statuses</option>
                                    <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Pending</option>
                                    <option value="Confirmed" ${statusFilter == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                    <option value="Cancelled" ${statusFilter == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                    <option value="Completed" ${statusFilter == 'Completed' ? 'selected' : ''}>Completed</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-secondary w-100">Filter</button>
                            </div>
                        </form>
                        
                        <!-- Bookings Table -->
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>ID</th>
                                        <th>Customer</th>
                                        <th>Check In</th>
                                        <th>Check Out</th>
                                        <th>Guests</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty bookingList}">
                                            <tr>
                                                <td colspan="8" class="text-center py-4">No bookings found</td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="booking" items="${bookingList}">
                                                <tr>
                                                    <td>${booking.bookingID}</td>
                                                    <td>${booking.customer.fullName}</td>
                                                    <td><fmt:formatDate value="${booking.checkInDate}" pattern="yyyy-MM-dd" /></td>
                                                    <td><fmt:formatDate value="${booking.checkOutDate}" pattern="yyyy-MM-dd" /></td>
                                                    <td>${booking.numberOfGuests}</td>
                                                    <td><fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="$" /></td>
                                                    <td>
                                                        <span class="booking-status status-${booking.status.toLowerCase()}">${booking.status}</span>
                                                    </td>
                                                    <td class="action-buttons">
                                                        <a href="manage-bookings?action=view&bookingId=${booking.bookingID}" 
                                                           class="btn btn-sm btn-info" title="View Details">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        
                                                        <c:if test="${sessionScope.user.role eq 'Manager'}">
                                                            <a href="manage-bookings?action=edit&bookingId=${booking.bookingID}" 
                                                               class="btn btn-sm btn-warning" title="Edit Booking">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            
                                                            <button type="button" class="btn btn-sm btn-danger" 
                                                                    data-bs-toggle="modal" data-bs-target="#deleteModal${booking.bookingID}"
                                                                    title="Delete Booking">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                            
                                                            <!-- Delete Modal -->
                                                            <div class="modal fade" id="deleteModal${booking.bookingID}" tabindex="-1" aria-hidden="true">
                                                                <div class="modal-dialog">
                                                                    <div class="modal-content">
                                                                        <div class="modal-header">
                                                                            <h5 class="modal-title">Confirm Deletion</h5>
                                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                        </div>
                                                                        <div class="modal-body">
                                                                            Are you sure you want to delete Booking #${booking.bookingID}?
                                                                        </div>
                                                                        <div class="modal-footer">
                                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                            <form method="post" action="manage-bookings">
                                                                                <input type="hidden" name="action" value="delete">
                                                                                <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                                                <button type="submit" class="btn btn-danger">Delete</button>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:if>
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
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="manage-bookings?action=list&page=${currentPage - 1}&statusFilter=${statusFilter}">Previous</a>
                                    </li>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="manage-bookings?action=list&page=${i}&statusFilter=${statusFilter}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="manage-bookings?action=list&page=${currentPage + 1}&statusFilter=${statusFilter}">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>