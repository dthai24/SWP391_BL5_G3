<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Edit Booking #${booking.bookingID}</h5>
                        <div>
                            <a href="manage-bookings" class="btn btn-sm btn-light me-2">
                                <i class="fas fa-arrow-left"></i> Back to List
                            </a>
                            <a href="manage-bookings?action=view&bookingId=${booking.bookingID}" class="btn btn-sm btn-light">
                                <i class="fas fa-eye"></i> View
                            </a>
                        </div>
                    </div>
                    
                    <div class="card-header bg-white">
                        <ul class="nav nav-tabs card-header-tabs" id="myTab" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="details-tab" data-bs-toggle="tab" 
                                        data-bs-target="#details" type="button" role="tab" 
                                        aria-controls="details" aria-selected="true">
                                    Booking Details
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="rooms-tab" data-bs-toggle="tab" 
                                        data-bs-target="#rooms" type="button" role="tab" 
                                        aria-controls="rooms" aria-selected="false">
                                    Manage Rooms
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="services-tab" data-bs-toggle="tab" 
                                        data-bs-target="#services" type="button" role="tab" 
                                        aria-controls="services" aria-selected="false">
                                    Manage Services
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
                                            <label for="customerID" class="form-label">Customer <span class="text-danger">*</span></label>
                                            <select name="customerID" id="customerID" class="form-select" required>
                                                <c:forEach var="customer" items="${customerList}">
                                                    <option value="${customer.userID}" ${customer.userID == booking.customerID ? 'selected' : ''}>
                                                        ${customer.fullName} (${customer.email})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="invalid-feedback">Please select a customer.</div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                            <select name="status" id="status" class="form-select" required>
                                                <option value="Pending" ${booking.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                                <option value="Confirmed" ${booking.status == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                                <option value="Cancelled" ${booking.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                                <option value="Completed" ${booking.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                            </select>
                                            <div class="invalid-feedback">Please select a status.</div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="checkInDate" class="form-label">Check-in Date <span class="text-danger">*</span></label>
                                            <input type="date" name="checkInDate" id="checkInDate" class="form-control" 
                                                   value="<fmt:formatDate value="${booking.checkInDate}" pattern="yyyy-MM-dd" />" required>
                                            <div class="invalid-feedback">Please provide a valid check-in date.</div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="checkOutDate" class="form-label">Check-out Date <span class="text-danger">*</span></label>
                                            <input type="date" name="checkOutDate" id="checkOutDate" class="form-control" 
                                                   value="<fmt:formatDate value="${booking.checkOutDate}" pattern="yyyy-MM-dd" />" required>
                                            <div class="invalid-feedback">Please provide a valid check-out date.</div>
                                            <div class="form-text text-muted">Check-out date must be after check-in date.</div>
                                        </div>
                                    </div>
                                    
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="numberOfGuests" class="form-label">Number of Guests <span class="text-danger">*</span></label>
                                            <input type="number" name="numberOfGuests" id="numberOfGuests" class="form-control" 
                                                   min="1" value="${booking.numberOfGuests}" required>
                                            <div class="invalid-feedback">Please enter a valid number of guests (minimum 1).</div>
                                        </div>
                                        
                                        <div class="col-md-6">
                                            <label for="totalPrice" class="form-label">Total Price</label>
                                            <div class="input-group">
                                                <span class="input-group-text">$</span>
                                                <input type="text" class="form-control" id="totalPrice" 
                                                       value="<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00" />" readonly>
                                            </div>
                                            <div class="form-text text-muted">Price is calculated based on rooms and services.</div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="notes" class="form-label">Notes</label>
                                        <textarea name="notes" id="notes" class="form-control" rows="3">${booking.notes}</textarea>
                                    </div>
                                    
                                    <div class="mb-3 d-flex justify-content-between">
                                        <span class="text-muted">Last Updated: <fmt:formatDate value="${booking.updatedAt}" pattern="yyyy-MM-dd HH:mm" /></span>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save"></i> Save Changes
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
                                                <h6 class="mb-0">Assigned Rooms</h6>
                                                <span class="badge bg-primary">${assignedRooms.size()} Room(s)</span>
                                            </div>
                                            <div class="card-body p-0">
                                                <c:choose>
                                                    <c:when test="${empty assignedRooms}">
                                                        <div class="p-4 text-center text-muted">
                                                            No rooms assigned to this booking yet.
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="table-responsive">
                                                            <table class="table table-hover table-striped mb-0">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Room #</th>
                                                                        <th>Category</th>
                                                                        <th>Status</th>
                                                                        <th>Price</th>
                                                                        <th class="text-center">Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="room" items="${assignedRooms}">
                                                                        <tr>
                                                                            <td>${room.room.roomNumber}</td>
                                                                            <td>${room.categoryName}</td>
                                                                            <td>
                                                                                <span class="badge ${room.room.vacancyStatus == 'Vacant' ? 'bg-success' : 'bg-warning'}">
                                                                                    ${room.room.vacancyStatus}
                                                                                </span>
                                                                            </td>
                                                                            <td><fmt:formatNumber value="${room.priceAtBooking}" type="currency" currencySymbol="$" /></td>
                                                                            <td class="text-center">
                                                                                <form method="post" action="manage-bookings" class="d-inline" onsubmit="return confirm('Are you sure you want to remove this room from the booking?')">
                                                                                    <input type="hidden" name="action" value="removeRoom">
                                                                                    <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                                                    <input type="hidden" name="bookingRoomId" value="${room.bookingRoomID}">
                                                                                    <button type="submit" class="btn btn-sm btn-danger">
                                                                                        <i class="fas fa-trash"></i> Remove
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
                                                <h6 class="mb-0">Add Room</h6>
                                            </div>
                                            <div class="card-body">
                                                <form method="post" action="manage-bookings" class="needs-validation" novalidate>
                                                    <input type="hidden" name="action" value="addRoom">
                                                    <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                    
                                                    <div class="mb-3">
                                                        <label for="roomId" class="form-label">Select Room <span class="text-danger">*</span></label>
                                                        <select name="roomId" id="roomId" class="form-select" required>
                                                            <option value="">-- Select Room --</option>
                                                            <c:forEach var="availableRoom" items="${allRooms}">
                                                                <c:if test="${availableRoom.vacancyStatus == 'Vacant'}">
                                                                    <option value="${availableRoom.roomID}">
                                                                        ${availableRoom.roomNumber} (${availableRoom.categoryName})
                                                                    </option>
                                                                </c:if>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a room.</div>
                                                        <div class="form-text">Only vacant rooms are shown.</div>
                                                    </div>
                                                    
                                                    <div class="d-grid">
                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fas fa-plus"></i> Add Room
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
                                                <h6 class="mb-0">Added Services</h6>
                                                <span class="badge bg-primary">${assignedServices.size()} Service(s)</span>
                                            </div>
                                            <div class="card-body p-0">
                                                <c:choose>
                                                    <c:when test="${empty assignedServices}">
                                                        <div class="p-4 text-center text-muted">
                                                            No services added to this booking yet.
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="table-responsive">
                                                            <table class="table table-hover table-striped mb-0">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Service</th>
                                                                        <th>Quantity</th>
                                                                        <th>Unit Price</th>
                                                                        <th>Total</th>
                                                                        <th>Date</th>
                                                                        <th class="text-center">Action</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="service" items="${assignedServices}">
                                                                        <tr>
                                                                            <td>${service.service.serviceName}</td>
                                                                            <td>${service.quantity}</td>
                                                                            <td><fmt:formatNumber value="${service.priceAtBooking}" type="currency" currencySymbol="$" /></td>
                                                                            <td>
                                                                                <fmt:formatNumber value="${service.priceAtBooking * service.quantity}" 
                                                                                                  type="currency" currencySymbol="$" />
                                                                            </td>
                                                                            <td><fmt:formatDate value="${service.serviceDate}" pattern="yyyy-MM-dd" /></td>
                                                                            <td class="text-center">
                                                                                <form method="post" action="manage-bookings" class="d-inline" onsubmit="return confirm('Are you sure you want to remove this service from the booking?')">
                                                                                    <input type="hidden" name="action" value="removeService">
                                                                                    <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                                                    <input type="hidden" name="bookingServiceId" value="${service.bookingServiceID}">
                                                                                    <button type="submit" class="btn btn-sm btn-danger">
                                                                                        <i class="fas fa-trash"></i> Remove
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
                                                <h6 class="mb-0">Add Service</h6>
                                            </div>
                                            <div class="card-body">
                                                <form method="post" action="manage-bookings" class="needs-validation" novalidate>
                                                    <input type="hidden" name="action" value="addService">
                                                    <input type="hidden" name="bookingId" value="${booking.bookingID}">
                                                    
                                                    <div class="mb-3">
                                                        <label for="serviceId" class="form-label">Select Service <span class="text-danger">*</span></label>
                                                        <select name="serviceId" id="serviceId" class="form-select" required>
                                                            <option value="">-- Select Service --</option>
                                                            <c:forEach var="availableService" items="${availableServices}">
                                                                <option value="${availableService.serviceID}" 
                                                                        data-price="${availableService.price}">
                                                                    ${availableService.serviceName} - $<fmt:formatNumber value="${availableService.price}" pattern="#,##0.00" />
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="invalid-feedback">Please select a service.</div>
                                                    </div>
                                                    
                                                    <div class="mb-3">
                                                        <label for="quantity" class="form-label">Quantity <span class="text-danger">*</span></label>
                                                        <input type="number" name="quantity" id="quantity" class="form-control" 
                                                               min="1" value="1" required>
                                                        <div class="invalid-feedback">Please enter a valid quantity (minimum 1).</div>
                                                    </div>
                                                    
                                                    <div class="mb-3">
                                                        <label for="serviceDate" class="form-label">Service Date <span class="text-danger">*</span></label>
                                                        <input type="date" name="serviceDate" id="serviceDate" class="form-control" 
                                                               value="<fmt:formatDate value='${booking.checkInDate}' pattern='yyyy-MM-dd' />" required>
                                                        <div class="invalid-feedback">Please select a date for the service.</div>
                                                        <div class="form-text">Date must be during the stay period.</div>
                                                    </div>
                                                    
                                                    <div class="d-grid">
                                                        <button type="submit" class="btn btn-success">
                                                            <i class="fas fa-plus"></i> Add Service
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
                                <i class="fas fa-arrow-left"></i> Back to List
                            </a>
                            <div>
                                <button id="recalculateBtn" class="btn btn-info me-2" 
                                        onclick="recalculateTotal(${booking.bookingID})">
                                    <i class="fas fa-calculator"></i> Recalculate Price
                                </button>
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                    <i class="fas fa-trash"></i> Delete Booking
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirm Deletion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete Booking #${booking.bookingID}?</p>
                    <p class="mb-0 text-danger"><strong>Warning:</strong> This action cannot be undone. The booking will be marked as deleted.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form method="post" action="manage-bookings">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="bookingId" value="${booking.bookingID}">
                        <button type="submit" class="btn btn-danger">Delete Booking</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
                            alert('Check-out date must be after check-in date');
                        }
                    }
                    
                    // Additional validation for service date
                    if (form.querySelector('#serviceDate')) {
                        const serviceDate = new Date(document.getElementById('serviceDate').value);
                        const checkInDate = new Date(document.getElementById('checkInDate').value);
                        const checkOutDate = new Date(document.getElementById('checkOutDate').value);
                        
                        if (serviceDate < checkInDate || serviceDate > checkOutDate) {
                            event.preventDefault();
                            alert('Service date must be during the booking period');
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
            if (confirm('Recalculate the total price based on rooms and services?')) {
                fetch('manage-bookings?action=recalculateTotal&bookingId=' + bookingId, {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload(); // Reload to show updated price
                    } else {
                        alert('Failed to recalculate total. Please try again.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('An error occurred. Please try again.');
                });
            }
        }
    </script>
</body>
</html>