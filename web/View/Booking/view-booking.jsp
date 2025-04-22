<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Details</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
        
        .info-label {
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Booking Details #${booking.bookingID}</h5>
                        <div>
                            <a href="manage-bookings" class="btn btn-sm btn-light me-2">
                                <i class="fas fa-arrow-left"></i> Back to List
                            </a>
                            <c:if test="${sessionScope.user.role eq 'Manager'}">
                                <a href="manage-bookings?action=edit&bookingId=${booking.bookingID}" class="btn btn-sm btn-warning">
                                    <i class="fas fa-edit"></i> Edit
                                </a>
                            </c:if>
                        </div>
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
                        
                        <!-- Booking Info -->
                        <div class="row g-4">
                            <!-- Left Column -->
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h6 class="mb-0">Booking Information</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-2">
                                            <div class="col-md-5 info-label">Status:</div>
                                            <div class="col-md-7">
                                                <span class="booking-status status-${booking.status.toLowerCase()}">${booking.status}</span>
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-5 info-label">Booking Date:</div>
                                            <div class="col-md-7">
                                                <fmt:formatDate value="${booking.bookingDate}" pattern="yyyy-MM-dd HH:mm" />
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-5 info-label">Check-in Date:</div>
                                            <div class="col-md-7">
                                                <fmt:formatDate value="${booking.checkInDate}" pattern="yyyy-MM-dd" />
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-5 info-label">Check-out Date:</div>
                                            <div class="col-md-7">
                                                <fmt:formatDate value="${booking.checkOutDate}" pattern="yyyy-MM-dd" />
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-5 info-label">Number of Guests:</div>
                                            <div class="col-md-7">
                                                ${booking.numberOfGuests}
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-5 info-label">Total Price:</div>
                                            <div class="col-md-7">
                                                <fmt:formatNumber value="${booking.totalPrice}" type="currency" currencySymbol="$" />
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-5 info-label">Last Updated:</div>
                                            <div class="col-md-7">
                                                <fmt:formatDate value="${booking.updatedAt}" pattern="yyyy-MM-dd HH:mm" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Right Column -->
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h6 class="mb-0">Customer Information</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-2">
                                            <div class="col-md-4 info-label">Full Name:</div>
                                            <div class="col-md-8">${booking.customer.fullName}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-4 info-label">Email:</div>
                                            <div class="col-md-8">${booking.customer.email}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-4 info-label">Phone:</div>
                                            <div class="col-md-8">${booking.customer.phoneNumber}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-md-4 info-label">Address:</div>
                                            <div class="col-md-8">${booking.customer.address}</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="card mt-3">
                                    <div class="card-header bg-light">
                                        <h6 class="mb-0">Notes</h6>
                                    </div>
                                    <div class="card-body">
                                        <p class="mb-0">${booking.notes != null && !booking.notes.isEmpty() ? booking.notes : 'No notes provided'}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Rooms Section -->
                        <div class="card mt-4">
                            <div class="card-header bg-light">
                                <h6 class="mb-0">Assigned Rooms</h6>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty assignedRooms}">
                                        <p class="text-muted">No rooms assigned to this booking.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Room Number</th>
                                                        <th>Category</th>
                                                        <th>Price</th>
                                                        <th>Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="room" items="${assignedRooms}">
                                                        <tr>
                                                            <td>${room.room != null ? room.room.roomNumber : room.roomNumber}</td>
                                                            <td>${room.categoryName}</td>
                                                            <td><fmt:formatNumber value="${room.priceAtBooking}" type="currency" currencySymbol="$" /></td>
                                                            <td>${room.vacancyStatus}</td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <!-- Services Section -->
                        <div class="card mt-4">
                            <div class="card-header bg-light">
                                <h6 class="mb-0">Added Services</h6>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty assignedServices}">
                                        <p class="text-muted">No services added to this booking.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>Service Name</th>
                                                        <th>Price</th>
                                                        <th>Quantity</th>
                                                        <th>Total</th>
                                                        <th>Service Date</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="service" items="${assignedServices}">
                                                        <tr>
                                                            <td>${bookingService.service.serviceName}</td>
                                                            <td><fmt:formatNumber value="${service.priceAtBooking}" type="currency" currencySymbol="$" /></td>
                                                            <td>${service.quantity}</td>
                                                            <td><fmt:formatNumber value="${service.priceAtBooking * service.quantity}" type="currency" currencySymbol="$" /></td>
                                                            <td><fmt:formatDate value="${service.serviceDate}" pattern="yyyy-MM-dd" /></td>
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
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>${bookingService.service.serviceName}