<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Thêm đặt phòng mới</title>
    
    <%@ include file="/View/Common/header.jsp" %>
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
                            <h3>Thêm đặt phòng mới</h3>
                        </div>

                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<%= request.getContextPath() %>/manage-bookings" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại danh sách
                            </a>
                        </div>
                    </div>
                    
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">Thông tin đặt phòng</h5>
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
                                        <label for="customerID" class="form-label">Khách hàng <span class="text-danger">*</span></label>
                                        <select name="customerID" id="customerID" class="form-select" required>
                                            <option value="">-- Chọn khách hàng --</option>
                                            <c:forEach var="customer" items="${customerList}">
                                                <option value="${customer.userID}">${customer.fullName} (${customer.email})</option>
                                            </c:forEach>
                                        </select>
                                        <div class="invalid-feedback">Vui lòng chọn khách hàng.</div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                        <select name="status" id="status" class="form-select" required>
                                            <option value="Pending">Đang xử lý</option>
                                            <option value="Confirmed">Đã xác nhận</option>
                                            <option value="Cancelled">Đã hủy</option>
                                            <option value="Completed">Hoàn thành</option>
                                        </select>
                                        <div class="invalid-feedback">Vui lòng chọn trạng thái.</div>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="checkInDate" class="form-label">Ngày nhận phòng <span class="text-danger">*</span></label>
                                        <input type="date" name="checkInDate" id="checkInDate" class="form-control" required>
                                        <div class="invalid-feedback">Vui lòng chọn ngày nhận phòng hợp lệ.</div>
                                    </div>
                                    
                                    <div class="col-md-6">
                                        <label for="checkOutDate" class="form-label">Ngày trả phòng <span class="text-danger">*</span></label>
                                        <input type="date" name="checkOutDate" id="checkOutDate" class="form-control" required>
                                        <div class="invalid-feedback">Vui lòng chọn ngày trả phòng hợp lệ.</div>
                                        <div class="form-text text-muted">Ngày trả phòng phải sau ngày nhận phòng.</div>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="numberOfGuests" class="form-label">Số lượng khách <span class="text-danger">*</span></label>
                                        <input type="number" name="numberOfGuests" id="numberOfGuests" class="form-control" 
                                               min="1" value="1" required>
                                        <div class="invalid-feedback">Vui lòng nhập số lượng khách hợp lệ (tối thiểu 1).</div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="notes" class="form-label">Ghi chú</label>
                                    <textarea name="notes" id="notes" class="form-control" rows="3"></textarea>
                                </div>
                                
                                <div class="d-flex justify-content-end">
                                    <a href="manage-bookings" class="btn btn-secondary me-2">Hủy bỏ</a>
                                    <button type="submit" class="btn btn-primary">Tạo đặt phòng</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </main>
            
            <%@ include file="/View/Common/footer.jsp" %>
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
                    const checkInDate = new Date(document.getElementById('checkInDate').value);
                    const checkOutDate = new Date(document.getElementById('checkOutDate').value);
                    
                    if (checkOutDate <= checkInDate) {
                        event.preventDefault();
                        alert('Ngày trả phòng phải sau ngày nhận phòng');
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