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
            #customer-datatable {
                min-width: 900px !important;
                table-layout: fixed;
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

                    <!-- Table Section -->
                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Khách Hàng</h3>
                                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addCustomerModal">
                                    <i class="fa fa-plus"></i> Thêm Khách Hàng
                                </button>
                            </div>

                            <div class="card-body">
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
                                            <div id="add-customer-username-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-password">Mật Khẩu</label>
                                            <input type="password" name="password" id="customer-password" class="form-control" required />
                                            <div id="add-customer-password-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-fullName">Họ Và Tên</label>
                                            <input type="text" name="fullName" id="customer-fullName" class="form-control" required />
                                            <div id="add-customer-fullName-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-email">Email</label>
                                            <input type="email" name="email" id="customer-email" class="form-control" required />
                                            <div id="add-customer-email-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-phoneNumber">Số Điện Thoại</label>
                                            <input type="text" name="phoneNumber" id="customer-phoneNumber" class="form-control" required />
                                            <div id="add-customer-phoneNumber-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-address">Địa Chỉ</label>
                                            <input type="text" name="address" id="customer-address" class="form-control" />
                                            <div id="add-customer-address-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="customer-profilePictureURL">Avatar (URL)</label>
                                            <input type="url" name="profilePictureURL" id="customer-profilePictureURL" class="form-control" />
                                            <div id="add-customer-profilePictureURL-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
<!--                                        <div class="form-group">
                                            <label for="customer-status">Trạng Thái</label>
                                            <select name="status" id="customer-status" class="form-control">
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                            <div id="add-customer-status-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>-->
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
                                            <div id="edit-username-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-fullName">Họ và Tên</label>
                                            <input type="text" name="fullName" id="edit-fullName" class="form-control" required />
                                            <div id="edit-fullName-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-email">Email</label>
                                            <input type="email" name="email" id="edit-email" class="form-control" required />
                                            <div id="edit-email-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-phoneNumber">Số Điện Thoại</label>
                                            <input type="text" name="phoneNumber" id="edit-phoneNumber" class="form-control" />
                                            <div id="edit-phoneNumber-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-address">Địa Chỉ</label>
                                            <input type="text" name="address" id="edit-address" class="form-control" />
                                            <div id="edit-address-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-profilePictureURL">Avatar (URL)</label>
                                            <input type="url" name="profilePictureURL" id="edit-profilePictureURL" class="form-control" />
                                            <div id="edit-profilePictureURL-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-status">Trạng Thái</label>
                                            <select name="status" id="edit-status" class="form-control">
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                            <div id="edit-status-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
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
                                                                        {orderable: false, targets: -1} // Disable sort for last column (Action)
                                                                    ],
                                                                    language: {
                                                                        url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                                                                    }
                                                                });

                                                                // Lấy danh sách username, email, phone number hiện có
                                                                var existingUsernames = [];
                                                                var existingEmails = [];
                                                                var existingPhoneNumbers = [];
                                                                $("#customer-datatable tbody tr").each(function () {
                                                                    var username = $(this).find("td").eq(2).text().trim();
                                                                    var email = $(this).find("td").eq(4).text().trim();
                                                                    var phoneNumber = $(this).find("td").eq(5).text().trim();

                                                                    if (username)
                                                                        existingUsernames.push(username.toLowerCase());
                                                                    if (email)
                                                                        existingEmails.push(email.toLowerCase());
                                                                    if (phoneNumber)
                                                                        existingPhoneNumbers.push(phoneNumber);
                                                                });

                                                                // Validate thêm khách hàng
                                                                $("#addCustomerForm").on("submit", function (e) {
                                                                    var username = $('#customer-username').val();
                                                                    var password = $('#customer-password').val();
                                                                    var fullName = $('#customer-fullName').val();
                                                                    var email = $('#customer-email').val();
                                                                    var phoneNumber = $('#customer-phoneNumber').val();
                                                                    var address = $('#customer-address').val();
                                                                    var avatarURL = $('#customer-').val();

                                                                    var errorUsername = $('#add-customer-username-error');
                                                                    var errorPassword = $('#add-customer-password-error');
                                                                    var errorFullName = $('#add-customer-fullName-error');
                                                                    var errorEmail = $('#add-customer-email-error');
                                                                    var errorPhoneNumber = $('#add-customer-phoneNumber-error');
                                                                    var errorAddress = $('#add-customer-address-error');
                                                                    var errorAvatarURL = $('#add-customer-profilePictureURL-error');

                                                                    var hasError = false;

                                                                    // Reset lỗi trước khi kiểm tra
                                                                    errorUsername.text("");
                                                                    errorPassword.text("");
                                                                    errorFullName.text("");
                                                                    errorEmail.text("");
                                                                    errorPhoneNumber.text("");
                                                                    errorAddress.text("");
                                                                    errorAvatarURL.text("");

                                                                    // Kiểm tra username
                                                                    if (!username || username.trim() === "") {
                                                                        errorUsername.text("Tên người dùng không được để trống.");
                                                                        hasError = true;
                                                                    } else if (username.trim() !== username) {
                                                                        errorUsername.text("Tên người dùng không được chứa khoảng trắng ở đầu hoặc cuối.");
                                                                        hasError = true;
                                                                    } else if (existingUsernames.includes(username.toLowerCase())) {
                                                                        errorUsername.text("Tên người dùng đã tồn tại.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra password
                                                                    if (!password || password.trim() === "" || password.length < 6 || !/\d/.test(password)) {
                                                                        errorPassword.text("Mật khẩu phải có ít nhất 6 ký tự và chứa ít nhất 1 chữ số.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra họ và tên
                                                                    if (!fullName || fullName.trim() === "" || fullName.length < 3) {
                                                                        errorFullName.text("Họ và tên phải có ít nhất 3 ký tự và không được để trống.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra email
                                                                    const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
                                                                    if (!email || email.trim() === "" || !emailRegex.test(email)) {
                                                                        errorEmail.text("Email không hợp lệ hoặc để trống.");
                                                                        hasError = true;
                                                                    } else if (existingEmails.includes(email.toLowerCase())) {
                                                                        errorEmail.text("Email đã tồn tại.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra số điện thoại
                                                                    const phoneRegex = /^[0-9]{10,11}$/;
                                                                    if (!phoneNumber || phoneNumber.trim() === "") {
                                                                        errorPhoneNumber.text("Số điện thoại không được để trống.");
                                                                        hasError = true;
                                                                    } else if (!phoneRegex.test(phoneNumber)) {
                                                                        errorPhoneNumber.text("Số điện thoại phải chứa 10 hoặc 11 chữ số.");
                                                                        hasError = true;
                                                                    } else if (existingPhoneNumbers.includes(phoneNumber)) {
                                                                        errorPhoneNumber.text("Số điện thoại đã tồn tại.");
                                                                        hasError = true;
                                                                    }

                                                                    //Validate address
                                                                    if (address && (address.trim() === "" || address.trim().length < 5)) {
                                                                        errorAddress.text("Địa chỉ phải có ít nhất 5 ký tự và không được để mỗi khoảng trắng.");
                                                                        hasError = true;
                                                                    }


                                                                    // Validate avatar URL
                                                                    if (avatarURL && address.trim().length > 0) {
                                                                        errorAvatarURL.text("Avatar URL không dược chứa mỗi khoảng trắng.");
                                                                        hasError = true;
                                                                    }

                                                                    // Ngăn gửi form nếu có lỗi
                                                                    if (hasError) {
                                                                        e.preventDefault();
                                                                    }
                                                                });

                                                                // Populate Edit Customer Modal
                                                                $('.edit-btn').on('click', function () {
                                                                    $('#edit-customerID').val($(this).data('customerid'));
                                                                    $('#edit-username').val($(this).data('username'));
                                                                    $('#edit-username').data('old', $(this).data('username')); // Lưu giá trị cũ để kiểm tra trùng lặp
                                                                    $('#edit-fullName').val($(this).data('fullname'));
                                                                    $('#edit-email').val($(this).data('email'));
                                                                    $('#edit-email').data('old', $(this).data('email')); // Lưu giá trị cũ để kiểm tra trùng lặp
                                                                    $('#edit-phoneNumber').val($(this).data('phonenumber'));
                                                                    $('#edit-phoneNumber').data('old', $(this).data('phonenumber')); // Lưu giá trị cũ để kiểm tra trùng lặp
                                                                    $('#edit-address').val($(this).data('address'));
                                                                    $('#edit-profilePictureURL').val($(this).data('profilepictureurl'));
                                                                    $('#edit-status').val($(this).data('status'));
                                                                    $('#edit-avatar-preview').attr('src', $(this).data('profilepictureurl') || 'https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg');

                                                                    // Xóa lỗi cũ
                                                                    $('.text-danger').text('');
                                                                });

                                                                // Validate khi submit form edit
                                                                $('#editCustomerForm').on('submit', function (e) {
                                                                    var username = $('#edit-username').val();
                                                                    var oldUsername = $('#edit-username').data('old'); // Lấy giá trị cũ của username
                                                                    var fullName = $('#edit-fullName').val();
                                                                    var email = $('#edit-email').val();
                                                                    var oldEmail = $('#edit-email').data('old'); // Lấy giá trị cũ của email
                                                                    var phoneNumber = $('#edit-phoneNumber').val();
                                                                    var oldPhoneNumber = $('#edit-phoneNumber').data('old'); // Lấy giá trị cũ của phone number
                                                                    var address = $('#edit-address').val();
                                                                    var profilePictureURL = $('#edit-profilePictureURL').val();
                                                                    var status = $('#edit-status').val();

                                                                    var errorUsername = $('#edit-username-error');
                                                                    var errorFullName = $('#edit-fullName-error');
                                                                    var errorEmail = $('#edit-email-error');
                                                                    var errorPhoneNumber = $('#edit-phoneNumber-error');
                                                                    var errorAddress = $('#edit-address-error');
                                                                    var errorProfilePictureURL = $('#edit-profilePictureURL-error');
                                                                    var errorStatus = $('#edit-status-error');

                                                                    var hasError = false;

                                                                    // Reset lỗi trước khi kiểm tra
                                                                    errorUsername.text('');
                                                                    errorFullName.text('');
                                                                    errorEmail.text('');
                                                                    errorPhoneNumber.text('');
                                                                    errorAddress.text('');
                                                                    errorProfilePictureURL.text('');
                                                                    errorStatus.text('');

                                                                    // Kiểm tra username
                                                                    if (!username || username.trim() === "") {
                                                                        errorUsername.text("Tên người dùng không được để trống.");
                                                                        hasError = true;
                                                                    } else if (username.trim() !== username) {
                                                                        errorUsername.text("Tên người dùng không được chứa khoảng trắng ở đầu hoặc cuối.");
                                                                        hasError = true;
                                                                    } else if (username.toLowerCase() !== oldUsername.toLowerCase() && existingUsernames.includes(username.toLowerCase())) {
                                                                        errorUsername.text("Tên người dùng đã tồn tại.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra full name
                                                                    if (!fullName || fullName.trim() === "" || fullName.length < 3) {
                                                                        errorFullName.text("Họ và tên phải có ít nhất 3 ký tự và không được để trống.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra email
                                                                    const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
                                                                    if (!email || email.trim() === "" || !emailRegex.test(email)) {
                                                                        errorEmail.text("Email không hợp lệ hoặc để trống.");
                                                                        hasError = true;
                                                                    } else if (email.toLowerCase() !== oldEmail.toLowerCase() && existingEmails.includes(email.toLowerCase())) {
                                                                        errorEmail.text("Email đã tồn tại.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra phone number
                                                                    const phoneRegex = /^[0-9]{10,11}$/;
                                                                    if (phoneNumber && phoneNumber.trim() !== "") {
                                                                        if (!phoneRegex.test(phoneNumber)) {
                                                                            errorPhoneNumber.text("Số điện thoại phải chứa 10 hoặc 11 chữ số.");
                                                                            hasError = true;
                                                                        } else if (phoneNumber !== oldPhoneNumber && existingPhoneNumbers.includes(phoneNumber)) {
                                                                            errorPhoneNumber.text("Số điện thoại đã tồn tại.");
                                                                            hasError = true;
                                                                        }
                                                                    }

                                                                    // Kiểm tra địa chỉ
                                                                    if (address && address.trim().length > 0 && address.trim().length < 5) {
                                                                        errorAddress.text("Địa chỉ phải có ít nhất 5 ký tự.");
                                                                        hasError = true;
                                                                    }

                                                                    // Kiểm tra URL avatar
                                                                    if (profilePictureURL && profilePictureURL.trim().length > 0) {
                                                                        errorAddress.text("URL Avatar không được chứa mỗi khoảng trắng");
                                                                        hasError = true;
                                                                    }
                  

                                                                    // Kiểm tra trạng thái
                                                                    if (status !== 'Active' && status !== 'Inactive') {
                                                                        errorStatus.text("Trạng thái phải là 'Active' hoặc 'Inactive'.");
                                                                        hasError = true;
                                                                    }

                                                                    // Ngăn gửi form nếu có lỗi
                                                                    if (hasError) {
                                                                        e.preventDefault();
                                                                    }
                                                                });

                                                                // Reset form khi đóng modal Edit
                                                                $('#editCustomerModal').on('hidden.bs.modal', function () {
                                                                    var form = $(this).find('form');
                                                                    form[0].reset(); // Reset tất cả các trường trong form
                                                                    $('.text-danger').text(''); // Xóa tất cả lỗi
                                                                });

                                                                // Populate View Customer Modal
                                                                $('.view-btn').on('click', function () {
                                                                    $('#view-username').text($(this).data('username'));
                                                                    $('#view-fullName').text($(this).data('fullname'));
                                                                    $('#view-email').text($(this).data('email'));
                                                                    $('#view-phoneNumber').text($(this).data('phonenumber'));
                                                                    $('#view-address').text($(this).data('address'));

                                                                    var status = $(this).data('status');
                                                                    var statusHtml = status === 'Active' ? '<span class="status-active">Active</span>' : '<span class="status-inactive">Inactive</span>';
                                                                    $('#view-status').html(statusHtml);

                                                                    var profilePictureUrl = $(this).data('profilepictureurl') || 'https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg';
                                                                    $('#view-avatar').attr('src', profilePictureUrl);
                                                                });

                                                                // Reset form when closing Add Customer Modal
                                                                $('#addCustomerModal').on('hidden.bs.modal', function () {
                                                                    $(this).find('form')[0].reset();
                                                                    $('.text-danger').text('');
                                                                });
                                                            });
                    </script>
                </main>
                <%@ include file="/View/Common/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
