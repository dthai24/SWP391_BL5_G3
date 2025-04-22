<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Add New Booking</h5>
                        <a href="manage-bookings" class="btn btn-sm btn-light">
                            <i class="fas fa-arrow-left"></i> Back to List
                        </a>
                    </div>
                    
                    <div class="card-body">
                        <!-- Alert Messages -->
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${sessionScope.errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session" />
                        </c:if>
                        
                        <!-- Add Booking Form -->
                        <form method="post" action="manage-bookings" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="save">
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="customerID" class="form-label">Customer <span class="text-danger">*</span></label>
                                    <select name="customerID" id="customerID" class="form-select" required>
                                        <option value="">-- Select Customer --</option>
                                        <c:forEach var="customer" items="${customerList}">
                                            <option value="${customer.userID}">${customer.fullName} (${customer.email})</option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">Please select a customer.</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="status" class="form-label">Status <span class="text-danger">*</span></label>
                                    <select name="status" id="status" class="form-select" required>
                                        <option value="Pending">Pending</option>
                                        <option value="Confirmed">Confirmed</option>
                                        <option value="Cancelled">Cancelled</option>
                                        <option value="Completed">Completed</option>
                                    </select>
                                    <div class="invalid-feedback">Please select a status.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="checkInDate" class="form-label">Check-in Date <span class="text-danger">*</span></label>
                                    <input type="date" name="checkInDate" id="checkInDate" class="form-control" required>
                                    <div class="invalid-feedback">Please provide a valid check-in date.</div>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="checkOutDate" class="form-label">Check-out Date <span class="text-danger">*</span></label>
                                    <input type="date" name="checkOutDate" id="checkOutDate" class="form-control" required>
                                    <div class="invalid-feedback">Please provide a valid check-out date.</div>
                                    <div class="form-text text-muted">Check-out date must be after check-in date.</div>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="numberOfGuests" class="form-label">Number of Guests <span class="text-danger">*</span></label>
                                    <input type="number" name="numberOfGuests" id="numberOfGuests" class="form-control" 
                                           min="1" value="1" required>
                                    <div class="invalid-feedback">Please enter a valid number of guests (minimum 1).</div>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea name="notes" id="notes" class="form-control" rows="3"></textarea>
                            </div>
                            
                            <div class="d-flex justify-content-end">
                                <a href="manage-bookings" class="btn btn-secondary me-2">Cancel</a>
                                <button type="submit" class="btn btn-primary">Create Booking</button>
                            </div>
                        </form>
                    </div>
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
                    const checkInDate = new Date(document.getElementById('checkInDate').value);
                    const checkOutDate = new Date(document.getElementById('checkOutDate').value);
                    
                    if (checkOutDate <= checkInDate) {
                        event.preventDefault();
                        alert('Check-out date must be after check-in date');
                    }
                    
                    form.classList.add('was-validated');
                }, false);
            });
        })();
        
        // Set minimum dates to today for check-in and check-out
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const yyyy = today.getFullYear();
            const mm = String(today.getMonth() + 1).padStart(2, '0');
            const dd = String(today.getDate()).padStart(2, '0');
            
            const todayFormatted = `${yyyy}-${mm}-${dd}`;
            document.getElementById('checkInDate').setAttribute('min', todayFormatted);
            document.getElementById('checkOutDate').setAttribute('min', todayFormatted);
            
            // Set check-out date min when check-in date changes
            document.getElementById('checkInDate').addEventListener('change', function() {
                document.getElementById('checkOutDate').setAttribute('min', this.value);
            });
        });
    </script>
</body>
</html>