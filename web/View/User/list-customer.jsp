<%@ page import="java.util.List" %>
<%@ page import="Model.Customer" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Khách Hàng</title>

        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
        <%@ include file="/View/Common/header.jsp" %>
        <style>
            .info-label {
                font-weight: 600;
            }
            .status-active {
                background-color: #28A745;
                color: #fff;
                padding: 5px 10px;
                border-radius: 4px;
            }
            .status-inactive {
                background-color: #DC3545;
                color: #fff;
                padding: 5px 10px;
                border-radius: 4px;
            }
            .avatar {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
            }
            .avatar-large {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
            }
            .table-responsive {
                overflow-x: auto !important;
            }
            #customer-datatable th, #customer-datatable td {
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
                    <%
                        List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                    %>

                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Khách Hàng</h3>
                                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addCustomerModal">
                                    <i class="fa fa-plus"></i> Thêm Khách Hàng
                                </button>
                            </div>

                            <div class="card-body">
                                <!-- Filter Form -->
                                <form method="get" action="employee" class="form-inline mb-3">
                                    <div class="form-group mr-2">
                                        <label for="filterStatus" class="mr-2">Trạng thái</label>
                                        <select name="filterStatus" id="filterStatus" class="form-control">
                                            <option value="">Tất cả</option>
                                            <option value="Active" <%= "Active".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Active</option>
                                            <option value="Inactive" <%= "Inactive".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Inactive</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-primary mr-2">Lọc</button>
                                    <a href="employee" class="btn btn-secondary">Hủy</a>
                                </form>
                                <div class="table-responsive">
                                    <table id="customer-datatable" class="table table-hover table-striped align-middle">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Avatar</th>
                                                <th>Tên Người Dùng</th>
                                                <th>Họ và Tên</th>
                                                <th>Email</th>
                                                <th>Số Điện Thoại</th>
                                                <th>Địa Chỉ</th>
                                                <th>Trạng Thái</th>
                                                <th>Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% if (customers != null && !customers.isEmpty()) {
                                                for (Customer customer : customers) { %>
                                            <tr>
                                                <td><%= customer.getCustomerID() %></td>
                                                <td>
                                                    <% if (customer.getUser().getProfilePictureURL() != null && !customer.getUser().getProfilePictureURL().isEmpty()) { %>
                                                    <img src="<%= customer.getUser().getProfilePictureURL() %>" alt="Avatar" class="avatar">
                                                    <% } else { %>
                                                    <img src="https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg" alt="Avatar" class="avatar">
                                                    <% } %>
                                                </td>
                                                <td><%= customer.getUser().getUsername() %></td>
                                                <td><%= customer.getUser().getFullName() %></td>
                                                <td><%= customer.getUser().getEmail() %></td>
                                                <td><%= (customer.getUser().getPhoneNumber() != null && !customer.getUser().getPhoneNumber().trim().isEmpty()) ? customer.getUser().getPhoneNumber() : "N/A" %></td>
                                                <td><%= (customer.getUser().getAddress() != null && !customer.getUser().getAddress().trim().isEmpty()) ? customer.getUser().getAddress() : "N/A" %></td>
                                                <td>
                                                    <% if ("Active".equals(customer.getUser().getStatus())) { %>
                                                    <span class="status-active">Active</span>
                                                    <% } else { %>
                                                    <span class="status-inactive">Inactive</span>
                                                    <% } %>
                                                </td>
                                                <td>
                                                    <!-- Button View -->
                                                    <button type="button" class="btn btn-link p-0 view-btn" 
                                                            data-customerid="<%= customer.getCustomerID() %>"
                                                            data-username="<%= customer.getUser().getUsername() %>"
                                                            data-fullname="<%= customer.getUser().getFullName() %>"
                                                            data-email="<%= customer.getUser().getEmail() %>"
                                                            data-phonenumber="<%= customer.getUser().getPhoneNumber() %>"
                                                            data-address="<%= customer.getUser().getAddress() %>"
                                                            data-status="<%= customer.getUser().getStatus() %>"
                                                            data-profilepictureurl="<%= customer.getUser().getProfilePictureURL() %>"
                                                            data-toggle="modal" data-target="#viewCustomerModal"
                                                            title="Xem chi tiết khách hàng">
                                                        <i class="fa fa-eye" style="color: #17a2b8; font-size: 1.2rem;"></i>
                                                    </button>

                                                    <!-- Button Edit -->
                                                    <button type="button" class="btn btn-link p-0 edit-btn"
                                                            data-customerid="<%= customer.getCustomerID() %>"
                                                            data-username="<%= customer.getUser().getUsername() %>"
                                                            data-fullname="<%= customer.getUser().getFullName() %>"
                                                            data-email="<%= customer.getUser().getEmail() %>"
                                                            data-phonenumber="<%= customer.getUser().getPhoneNumber() %>"
                                                            data-address="<%= customer.getUser().getAddress() %>"
                                                            data-status="<%= customer.getUser().getStatus() %>"
                                                            data-profilepictureurl="<%= customer.getUser().getProfilePictureURL() %>"
                                                            data-toggle="modal" data-target="#editCustomerModal"
                                                            title="Chỉnh sửa thông tin khách hàng">
                                                        <i class="fa fa-edit" style="color: #ffc107; font-size: 1.2rem;"></i>
                                                    </button>
                                                    <form method="post" action="customer" class="d-inline delete-customer-form">
                                                        <input type="hidden" name="deleteCustomerID" value="<%= customer.getCustomerID() %>" />
                                                        <button type="submit" class="btn btn-link p-0 delete-btn" onclick="return confirm('Bạn có chắc chắn muốn xóa khách hàng này?');">
                                                            <i class="fa fa-trash" style="color: #dc3545;"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <%  } 
                                            } else { %>
                                            <tr><td colspan="10" class="text-center">Không có khách hàng nào.</td></tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add Customer Modal -->
                    <div class="modal fade" id="addCustomerModal" tabindex="-1" role="dialog" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="customer" method="post" id="addCustomerForm">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addCustomerModalLabel">Thêm Khách Hàng Mới</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="customer-username">Tên Người Dùng</label>
                                            <input type="text" name="username" id="customer-username" class="form-control" required />
                                            <div id="add-customer-username-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-password">Mật Khẩu</label>
                                            <input type="password" name="password" id="customer-password" class="form-control" required />
                                            <div id="add-customer-password-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-fullName">Họ và Tên</label>
                                            <input type="text" name="fullName" id="customer-fullName" class="form-control" required />
                                            <div id="add-customer-fullName-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-email">Email</label>
                                            <input type="email" name="email" id="customer-email" class="form-control" required />
                                            <div id="add-customer-email-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-phoneNumber">Số Điện Thoại</label>
                                            <input type="text" name="phoneNumber" id="customer-phoneNumber" class="form-control" required />
                                            <div id="add-customer-phoneNumber-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-address">Địa Chỉ</label>
                                            <input type="text" name="address" id="customer-address" class="form-control" />
                                            <div id="add-customer-address-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-profilePictureURL">Avatar (URL)</label>
                                            <input type="url" name="profilePictureURL" id="customer-profilePictureURL" class="form-control" />
                                            <div id="add-customer-profilePictureURL-error" class="text-danger"></div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Thêm Khách Hàng</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- View Customer Modal -->
                    <div class="modal fade" id="viewCustomerModal" tabindex="-1" role="dialog" aria-labelledby="viewCustomerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="viewCustomerModalLabel">Chi Tiết Khách Hàng</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="text-center mb-3">
                                        <img id="view-avatar" src="https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg" alt="Avatar" class="avatar-large">
                                    </div>
                                    <p><strong>Tên Người Dùng:</strong> <span id="view-username"></span></p>
                                    <p><strong>Họ và Tên:</strong> <span id="view-fullName"></span></p>
                                    <p><strong>Email:</strong> <span id="view-email"></span></p>
                                    <p><strong>Số Điện Thoại:</strong> <span id="view-phoneNumber"></span></p>
                                    <p><strong>Địa Chỉ:</strong> <span id="view-address"></span></p>
                                    <p><strong>Trạng Thái:</strong> <span id="view-status"></span></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Customer Modal -->
                    <div class="modal fade" id="editCustomerModal" tabindex="-1" role="dialog" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="customer" method="post" id="editCustomerForm">
                                    <input type="hidden" name="customerID" id="edit-customerID">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editCustomerModalLabel">Chỉnh Sửa Thông Tin Khách Hàng</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="text-center mb-3">
                                            <img id="edit-avatar-preview" src="" alt="Avatar" class="avatar-large">
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-username">Tên Người Dùng</label>
                                            <input type="text" name="username" id="edit-username" class="form-control" required />
                                            <div id="edit-username-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-fullName">Họ và Tên</label>
                                            <input type="text" name="fullName" id="edit-fullName" class="form-control" required />
                                            <div id="edit-fullName-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-email">Email</label>
                                            <input type="email" name="email" id="edit-email" class="form-control" required />
                                            <div id="edit-email-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-phoneNumber">Số Điện Thoại</label>
                                            <input type="text" name="phoneNumber" id="edit-phoneNumber" class="form-control" />
                                            <div id="edit-phoneNumber-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-address">Địa Chỉ</label>
                                            <input type="text" name="address" id="edit-address" class="form-control" />
                                            <div id="edit-address-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-profilePictureURL">Avatar (URL)</label>
                                            <input type="url" name="profilePictureURL" id="edit-profilePictureURL" class="form-control" />
                                            <div id="edit-profilePictureURL-error" class="text-danger"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-status">Trạng Thái</label>
                                            <select name="status" id="edit-status" class="form-control">
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                            <div id="edit-status-error" class="text-danger"></div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Cập Nhật</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
                    <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
                    <script>
                        $(document).ready(function () {
                            // Initialize DataTable
                            $('#customer-datatable').DataTable({
                                responsive: true,
                                paging: true,
                                ordering: true,
                                info: true,
                                columnDefs: [
                                    { orderable: false, targets: -1 } // Disable sort for last column (Action)
                                ],
                                language: {
                                    url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                                }
                            });

                            // Collect existing usernames, emails, and phone numbers
                            const existingUsernames = [];
                            const existingEmails = [];
                            const existingPhoneNumbers = [];

                            $("#customer-datatable tbody tr").each(function () {
                                const username = $(this).find("td").eq(2).text().trim();
                                const email = $(this).find("td").eq(4).text().trim();
                                const phoneNumber = $(this).find("td").eq(5).text().trim();

                                if (username) existingUsernames.push(username.toLowerCase());
                                if (email) existingEmails.push(email.toLowerCase());
                                if (phoneNumber) existingPhoneNumbers.push(phoneNumber);
                            });

                            // Add Customer Form Validation
                            $("#addCustomerForm").on("submit", function (e) {
                                let hasError = false;

                                const username = $('#customer-username').val();
                                const password = $('#customer-password').val();
                                const fullName = $('#customer-fullName').val();
                                const email = $('#customer-email').val();
                                const phoneNumber = $('#customer-phoneNumber').val();
                                const address = $('#customer-address').val();
                                const avatarURL = $('#customer-profilePictureURL').val();

                                const errorFields = {
                                    username: $('#add-customer-username-error'),
                                    password: $('#add-customer-password-error'),
                                    fullName: $('#add-customer-fullName-error'),
                                    email: $('#add-customer-email-error'),
                                    phoneNumber: $('#add-customer-phoneNumber-error'),
                                    address: $('#add-customer-address-error'),
                                    avatarURL: $('#add-customer-profilePictureURL-error')
                                };

                                // Reset errors
                                Object.values(errorFields).forEach(field => field.text(""));

                                // Username validation
                                if (!username || username.trim() === "") {
                                    errorFields.username.text("Tên người dùng không được để trống.");
                                    hasError = true;
                                } else if (username.trim() !== username) {
                                    errorFields.username.text("Tên người dùng không được chứa khoảng trắng ở đầu hoặc cuối.");
                                    hasError = true;
                                } else if (existingUsernames.includes(username.toLowerCase())) {
                                    errorFields.username.text("Tên người dùng đã tồn tại.");
                                    hasError = true;
                                }

                                // Password validation
                                if (!password || password.trim() === "" || password.length < 6 || !/\d/.test(password)) {
                                    errorFields.password.text("Mật khẩu phải có ít nhất 6 ký tự và chứa ít nhất 1 chữ số.");
                                    hasError = true;
                                }

                                // Full name validation
                                if (!fullName || fullName.trim() === "" || fullName.length < 3) {
                                    errorFields.fullName.text("Họ và tên phải có ít nhất 3 ký tự và không được để trống.");
                                    hasError = true;
                                }

                                // Email validation
                                const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
                                if (!email || email.trim() === "" || !emailRegex.test(email)) {
                                    errorFields.email.text("Email không hợp lệ hoặc để trống.");
                                    hasError = true;
                                } else if (existingEmails.includes(email.toLowerCase())) {
                                    errorFields.email.text("Email đã tồn tại.");
                                    hasError = true;
                                }

                                // Phone number validation
                                const phoneRegex = /^[0-9]{10,11}$/;
                                if (!phoneNumber || phoneNumber.trim() === "") {
                                    errorFields.phoneNumber.text("Số điện thoại không được để trống.");
                                    hasError = true;
                                } else if (!phoneRegex.test(phoneNumber)) {
                                    errorFields.phoneNumber.text("Số điện thoại phải chứa 10 hoặc 11 chữ số.");
                                    hasError = true;
                                } else if (existingPhoneNumbers.includes(phoneNumber)) {
                                    errorFields.phoneNumber.text("Số điện thoại đã tồn tại.");
                                    hasError = true;
                                }

                                // Address validation
                                if (address && (address.trim() === "" || address.trim().length < 5)) {
                                    errorFields.address.text("Địa chỉ phải có ít nhất 5 ký tự và không được để mỗi khoảng trắng.");
                                    hasError = true;
                                }

                                // Avatar URL validation
                                if (avatarURL && avatarURL.trim() === "") {
                                    errorFields.avatarURL.text("Avatar URL không được chứa mỗi khoảng trắng.");
                                    hasError = true;
                                }

                                // Prevent form submission if there are errors
                                if (hasError) e.preventDefault();
                            });

                            // Populate Edit Customer Modal
                            $('.edit-btn').on('click', function () {
                                $('#edit-customerID').val($(this).data('customerid'));
                                $('#edit-username').val($(this).data('username'));
                                $('#edit-username').data('old', $(this).data('username')); // Store old username
                                $('#edit-fullName').val($(this).data('fullname'));
                                $('#edit-email').val($(this).data('email'));
                                $('#edit-email').data('old', $(this).data('email')); // Store old email
                                $('#edit-phoneNumber').val($(this).data('phonenumber'));
                                $('#edit-phoneNumber').data('old', $(this).data('phonenumber')); // Store old phone number
                                $('#edit-address').val($(this).data('address'));
                                $('#edit-profilePictureURL').val($(this).data('profilepictureurl'));
                                $('#edit-status').val($(this).data('status'));
                                $('#edit-avatar-preview').attr('src', $(this).data('profilepictureurl') || 'https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg');

                                // Clear previous errors
                                $('.text-danger').text('');
                            });

                            // Edit Customer Form Validation
                            $('#editCustomerForm').on('submit', function (e) {
                                let hasError = false;

                                const username = $('#edit-username').val();
                                const oldUsername = $('#edit-username').data('old');
                                const fullName = $('#edit-fullName').val();
                                const email = $('#edit-email').val();
                                const oldEmail = $('#edit-email').data('old');
                                const phoneNumber = $('#edit-phoneNumber').val();
                                const oldPhoneNumber = $('#edit-phoneNumber').data('old');
                                const address = $('#edit-address').val();
                                const profilePictureURL = $('#edit-profilePictureURL').val();
                                const status = $('#edit-status').val();

                                const errorFields = {
                                    username: $('#edit-username-error'),
                                    fullName: $('#edit-fullName-error'),
                                    email: $('#edit-email-error'),
                                    phoneNumber: $('#edit-phoneNumber-error'),
                                    address: $('#edit-address-error'),
                                    profilePictureURL: $('#edit-profilePictureURL-error'),
                                    status: $('#edit-status-error')
                                };

                                // Reset errors
                                Object.values(errorFields).forEach(field => field.text(""));

                                // Username validation
                                if (!username || username.trim() === "") {
                                    errorFields.username.text("Tên người dùng không được để trống.");
                                    hasError = true;
                                } else if (username.trim() !== username) {
                                    errorFields.username.text("Tên người dùng không được chứa khoảng trắng ở đầu hoặc cuối.");
                                    hasError = true;
                                } else if (username.toLowerCase() !== oldUsername.toLowerCase() && existingUsernames.includes(username.toLowerCase())) {
                                    errorFields.username.text("Tên người dùng đã tồn tại.");
                                    hasError = true;
                                }

                                // Full name validation
                                if (!fullName || fullName.trim() === "" || fullName.length < 3) {
                                    errorFields.fullName.text("Họ và tên phải có ít nhất 3 ký tự và không được để trống.");
                                    hasError = true;
                                }

                                // Email validation
                                const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
                                if (!email || email.trim() === "" || !emailRegex.test(email)) {
                                    errorFields.email.text("Email không hợp lệ hoặc để trống.");
                                    hasError = true;
                                } else if (email.toLowerCase() !== oldEmail.toLowerCase() && existingEmails.includes(email.toLowerCase())) {
                                    errorFields.email.text("Email đã tồn tại.");
                                    hasError = true;
                                }

                                // Phone number validation
                                const phoneRegex = /^[0-9]{10,11}$/;
                                if (phoneNumber && phoneNumber.trim() !== "") {
                                    if (!phoneRegex.test(phoneNumber)) {
                                        errorFields.phoneNumber.text("Số điện thoại phải chứa 10 hoặc 11 chữ số.");
                                        hasError = true;
                                    } else if (phoneNumber !== oldPhoneNumber && existingPhoneNumbers.includes(phoneNumber)) {
                                        errorFields.phoneNumber.text("Số điện thoại đã tồn tại.");
                                        hasError = true;
                                    }
                                }

                                // Address validation
                                if (address && address.trim() === "" && address.trim().length < 5) {
                                    errorFields.address.text("Địa chỉ phải có ít nhất 5 ký tự.");
                                    hasError = true;
                                }

                                // Avatar URL validation
                                if (profilePictureURL && profilePictureURL.trim() === "") {
                                    errorFields.profilePictureURL.text("URL Avatar không được chứa mỗi khoảng trắng.");
                                    hasError = true;
                                }

                                // Status validation
                                if (status !== 'Active' && status !== 'Inactive') {
                                    errorFields.status.text("Trạng thái phải là 'Active' hoặc 'Inactive'.");
                                    hasError = true;
                                }

                                // Prevent form submission if there are errors
                                if (hasError) e.preventDefault();
                            });

                            // Reset modal forms when closed
                            $('#addCustomerModal').on('hidden.bs.modal', function () {
                                $(this).find('form')[0].reset();
                                $('.text-danger').text('');
                            });

                            $('#editCustomerModal').on('hidden.bs.modal', function () {
                                $(this).find('form')[0].reset();
                                $('.text-danger').text('');
                            });

                            // Populate View Customer Modal
                            $('.view-btn').on('click', function () {
                                $('#view-username').text($(this).data('username'));
                                $('#view-fullName').text($(this).data('fullname'));
                                $('#view-email').text($(this).data('email'));
                                $('#view-phoneNumber').text($(this).data('phonenumber'));
                                $('#view-address').text($(this).data('address'));

                                const status = $(this).data('status');
                                const statusHtml = status === 'Active'
                                    ? '<span class="status-active">Active</span>'
                                    : '<span class="status-inactive">Inactive</span>';
                                $('#view-status').html(statusHtml);

                                const profilePictureUrl = $(this).data('profilepictureurl') || 'https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg';
                                $('#view-avatar').attr('src', profilePictureUrl);
                            });
                        });
                    </script>
                </main>
                <%@ include file="/View/Common/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
