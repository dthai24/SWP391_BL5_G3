<%@ page import="java.util.List" %>
<%@ page import="Model.Employee" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Nhân Viên</title>

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
            #employee-datatable {
                min-width: 900px !important;
                table-layout: fixed;
            }
            #employee-datatable th, #employee-datatable td {
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
                        List<Employee> employees = (List<Employee>) request.getAttribute("employees");
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                    %>

                    <!-- Table Section -->
                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Nhân Viên</h3>
                                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addEmployeeModal">
                                    <i class="fa fa-plus"></i> Thêm Nhân Viên
                                </button>
                            </div>

                            <div class="card-body">
                                <form method="get" action="employee" class="form-inline mb-3">
                                    <div class="form-group mr-2">
                                        <label for="filterRole" class="mr-2">Vai trò</label>
                                        <select name="filterRole" id="filterRole" class="form-control">
                                            <option value="">Tất cả</option>
                                            <option value="Manager" <%= "Manager".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Manager</option>
                                            <option value="Staff" <%= "Staff".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Staff</option>
                                            <option value="Receptionist" <%= "Receptionist".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Receptionist</option>
                                        </select>
                                    </div>
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
                                    <table id="employee-datatable" class="table table-hover table-striped align-middle">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Avatar</th>
                                                <th>Tên Người Dùng</th>
                                                <th>Họ và Tên</th>
                                                <th>Email</th>
                                                <th>Số Điện Thoại</th>
                                                <th>Địa Chỉ</th>
                                                <th>Vai Trò Nhân Viên</th>
                                                <th>Trạng Thái</th>
                                                <th>Ngày Tạo</th>
                                                <th>Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% if (employees != null && !employees.isEmpty()) {
                                                for (Employee employee : employees) { %>
                                            <tr>
                                                <td><%= employee.getEmployeeID() %></td>
                                                <td>
                                                    <% if (employee.getUser().getProfilePictureURL() != null && !employee.getUser().getProfilePictureURL().isEmpty()) { %>
                                                    <img src="<%= employee.getUser().getProfilePictureURL() %>" alt="Avatar" class="avatar">
                                                    <% } else { %>
                                                    <img src="https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg" alt="Avatar" class="avatar">
                                                    <% } %>
                                                </td>
                                                <td><%= employee.getUser().getUsername() %></td>
                                                <td><%= employee.getUser().getFullName() %></td>
                                                <td><%= employee.getUser().getEmail() %></td>
                                                <td><%= (employee.getUser().getPhoneNumber() != null && !employee.getUser().getPhoneNumber().trim().isEmpty()) ? employee.getUser().getPhoneNumber() : "N/A" %></td>
                                                <td><%= (employee.getUser().getAddress() != null && !employee.getUser().getAddress().trim().isEmpty()) ? employee.getUser().getAddress() : "N/A" %></td>
                                                <td><%= employee.getEmployeeRole() %></td>
                                                <td>
                                                    <% if ("Active".equals(employee.getUser().getStatus())) { %>
                                                    <span class="status-active">Active</span>
                                                    <% } else { %>
                                                    <span class="status-inactive">Inactive</span>
                                                    <% } %>
                                                </td>
                                                <td><%= employee.getUser().getRegistrationDate() != null ? sdf.format(employee.getUser().getRegistrationDate()) : "N/A" %></td>
                                                <td>
                                                    <button type="button" class="btn btn-link p-0 view-btn" 
                                                            data-employeeid="<%= employee.getEmployeeID() %>"
                                                            data-username="<%= employee.getUser().getUsername() %>"
                                                            data-fullname="<%= employee.getUser().getFullName() %>"
                                                            data-email="<%= employee.getUser().getEmail() %>"
                                                            data-phonenumber="<%= employee.getUser().getPhoneNumber() %>"
                                                            data-address="<%= employee.getUser().getAddress() %>"
                                                            data-employeerole="<%= employee.getEmployeeRole() %>"
                                                            data-status="<%= employee.getUser().getStatus() %>"
                                                            data-registrationdate="<%= employee.getUser().getRegistrationDate() != null ? sdf.format(employee.getUser().getRegistrationDate()) : "N/A" %>"
                                                            data-profilepictureurl="<%= employee.getUser().getProfilePictureURL() %>"
                                                            data-toggle="modal" data-target="#viewEmployeeModal">
                                                        <i class="fa fa-eye" style="color: #17a2b8;"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-link p-0 edit-btn"
                                                            data-employeeid="<%= employee.getEmployeeID() %>"
                                                            data-username="<%= employee.getUser().getUsername() %>"
                                                            data-fullname="<%= employee.getUser().getFullName() %>"
                                                            data-email="<%= employee.getUser().getEmail() %>"
                                                            data-phonenumber="<%= employee.getUser().getPhoneNumber() %>"
                                                            data-address="<%= employee.getUser().getAddress() %>"
                                                            data-employeerole="<%= employee.getEmployeeRole() %>"
                                                            data-status="<%= employee.getUser().getStatus() %>"
                                                            data-profilepictureurl="<%= employee.getUser().getProfilePictureURL() %>"
                                                            data-registrationdate="<%= employee.getUser().getRegistrationDate() != null ? sdf.format(employee.getUser().getRegistrationDate()) : "N/A" %>"
                                                            data-toggle="modal" data-target="#editEmployeeModal">
                                                        <i class="fa fa-edit" style="color: #ffc107;"></i>
                                                    </button>
                                                    <form method="post" action="employee" class="d-inline delete-employee-form">
                                                        <input type="hidden" name="deleteEmployeeID" value="<%= employee.getEmployeeID() %>" />
                                                        <button type="submit" class="btn btn-link p-0 delete-btn" onclick="return confirm('Bạn có chắc chắn muốn xóa nhân viên này?');">
                                                            <i class="fa fa-trash" style="color: #dc3545;"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <%  } 
                                    } else { %>
                                            <tr><td colspan="11" class="text-center">Không có nhân viên nào.</td></tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add User Modal -->
                                       <!-- Add Employee Modal -->
                    <div class="modal fade" id="addEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="employee" method="post" id="addEmployeeForm">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addEmployeeModalLabel">Thêm Nhân Viên Mới</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="username">Tên Người Dùng</label>
                                            <input type="text" name="username" id="username" class="form-control" required />
                                            <div id="add-username-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="password">Mật Khẩu</label>
                                            <input type="password" name="password" id="password" class="form-control" required />
                                            <div id="add-password-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="fullName">Họ Và Tên</label>
                                            <input type="text" name="fullName" id="fullName" class="form-control" required />
                                            <div id="add-fullName-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="email">Email</label>
                                            <input type="email" name="email" id="email" class="form-control" required />
                                            <div id="add-email-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="phoneNumber">Số Điện Thoại</label>
                                            <input type="text" name="phoneNumber" id="phoneNumber" class="form-control" required />
                                            <div id="add-phoneNumber-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="address">Địa Chỉ</label>
                                            <input type="text" name="address" id="address" class="form-control" />
                                            <div id="add-address-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="profilePictureURL">Avatar (URL)</label>
                                            <input type="url" name="profilePictureURL" id="profilePictureURL" class="form-control" />
                                            <div id="add-profilePictureURL-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="employeeRole">Vai Trò Nhân Viên</label>
                                            <select name="employeeRole" id="employeeRole" class="form-control" required>
                                                <option value="Manager">Manager</option>
                                                <option value="Staff">Staff</option>
                                                <option value="Receptionist">Receptionist</option>
                                            </select>
                                            <div id="add-employeeRole-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="status">Trạng Thái</label>
                                            <select name="status" id="status" class="form-control">
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                            <div id="add-status-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Thêm Nhân Viên</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                    
                    <!-- View Employee Modal -->
                    <div class="modal fade" id="viewEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="viewEmployeeModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="viewEmployeeModalLabel">Chi Tiết Nhân Viên</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="text-center mb-3">
                                        <img id="view-avatar" src="https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg" alt="Avatar" class="avatar-large">
                                    </div>
                                    <p><strong>ID:</strong> <span id="view-employeeID"></span></p>
                                    <p><strong>Tên Người Dùng:</strong> <span id="view-username"></span></p>
                                    <p><strong>Họ và Tên:</strong> <span id="view-fullName"></span></p>
                                    <p><strong>Email:</strong> <span id="view-email"></span></p>
                                    <p><strong>Số Điện Thoại:</strong> <span id="view-phoneNumber"></span></p>
                                    <p><strong>Địa Chỉ:</strong> <span id="view-address"></span></p>
                                    <p><strong>Vai Trò Nhân Viên:</strong> <span id="view-employeeRole"></span></p>
                                    <p><strong>Trạng Thái:</strong> <span id="view-status"></span></p>
                                    <p><strong>Ngày Tạo:</strong> <span id="view-registrationDate"></span></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- Edit Employee Modal -->
                    <div class="modal fade" id="editEmployeeModal" tabindex="-1" role="dialog" aria-labelledby="editEmployeeModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="employee" method="post" id="editEmployeeForm">
                                    <input type="hidden" name="employeeID" id="edit-employeeID">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editEmployeeModalLabel">Chỉnh Sửa Thông Tin Nhân Viên</h5>
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
                                            <label for="edit-employeeRole">Vai Trò Nhân Viên</label>
                                            <select name="employeeRole" id="edit-employeeRole" class="form-control" required>
                                                <option value="Manager">Manager</option>
                                                <option value="Staff">Staff</option>
                                                <option value="Receptionist">Receptionist</option>
                                            </select>
                                            <div id="edit-employeeRole-error" class="text-danger" style="font-size:14px;margin-top:4px;"></div>
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
                            $('#employee-datatable').DataTable({
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

                            // Lấy danh sách username, email, phone number hiện có
                            var existingUsernames = [];
                            var existingEmails = [];
                            var existingPhoneNumbers = [];
                            $("#employee-datatable tbody tr").each(function () {
                                var username = $(this).find("td").eq(2).text().trim();
                                var email = $(this).find("td").eq(4).text().trim();
                                var phoneNumber = $(this).find("td").eq(5).text().trim();

                                if (username) existingUsernames.push(username.toLowerCase());
                                if (email) existingEmails.push(email.toLowerCase());
                                if (phoneNumber) existingPhoneNumbers.push(phoneNumber);
                            });

                            // Validate thêm nhân viên
                            $("#addEmployeeForm").on("submit", function (e) {
                                var username = $('#username').val();
                                var password = $('#password').val();
                                var fullName = $('#fullName').val();
                                var email = $('#email').val();
                                var phoneNumber = $('#phoneNumber').val();
                                var employeeRole = $('#employeeRole').val();
                                var status = $('#status').val();

                                var errorUsername = $('#add-username-error');
                                var errorPassword = $('#add-password-error');
                                var errorFullName = $('#add-fullName-error');
                                var errorEmail = $('#add-email-error');
                                var errorPhoneNumber = $('#add-phoneNumber-error');
                                var errorEmployeeRole = $('#add-employeeRole-error');
                                var errorStatus = $('#add-status-error');

                                var hasError = false;

                                // Clear all error messages
                                errorUsername.text("");
                                errorPassword.text("");
                                errorFullName.text("");
                                errorEmail.text("");
                                errorPhoneNumber.text("");
                                errorEmployeeRole.text("");
                                errorStatus.text("");

                                // Validate username
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

                                // Validate password
                                if (!password || password.trim() === "" || password.length < 6 || !/\d/.test(password)) {
                                    errorPassword.text("Mật khẩu phải có ít nhất 6 ký tự và chứa ít nhất 1 chữ số.");
                                    hasError = true;
                                }

                                // Validate full name
                                if (!fullName || fullName.trim() === "" || fullName.length < 3) {
                                    errorFullName.text("Họ và tên phải có ít nhất 3 ký tự và không được để trống.");
                                    hasError = true;
                                }

                                // Validate email
                                const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
                                if (!email || email.trim() === "" || !emailRegex.test(email)) {
                                    errorEmail.text("Email không hợp lệ hoặc để trống.");
                                    hasError = true;
                                } else if (existingEmails.includes(email.toLowerCase())) {
                                    errorEmail.text("Email đã tồn tại.");
                                    hasError = true;
                                }

                                // Validate phone number
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

                                // Validate employee role
                                const validRoles = ['Manager', 'Staff', 'Receptionist'];
                                if (!validRoles.includes(employeeRole)) {
                                    errorEmployeeRole.text("Vai trò nhân viên không hợp lệ.");
                                    hasError = true;
                                }

                                // Validate status
                                if (status !== 'Active' && status !== 'Inactive') {
                                    errorStatus.text("Trạng thái phải là 'Active' hoặc 'Inactive'.");
                                    hasError = true;
                                }

                                // Prevent form submission if errors exist
                                if (hasError) {
                                    e.preventDefault();
                                }
                            });

                            // Populate Edit Employee Modal
                            $('.edit-btn').on('click', function () {
                                $('#edit-employeeID').val($(this).data('employeeid'));
                                $('#edit-username').val($(this).data('username'));
                                $('#edit-username').data('old', $(this).data('username')); // Lưu giá trị cũ để kiểm tra trùng lặp
                                $('#edit-fullName').val($(this).data('fullname'));
                                $('#edit-email').val($(this).data('email'));
                                $('#edit-email').data('old', $(this).data('email')); // Lưu giá trị cũ để kiểm tra trùng lặp
                                $('#edit-phoneNumber').val($(this).data('phonenumber'));
                                $('#edit-phoneNumber').data('old', $(this).data('phonenumber')); // Lưu giá trị cũ để kiểm tra trùng lặp
                                $('#edit-address').val($(this).data('address'));
                                $('#edit-profilePictureURL').val($(this).data('profilepictureurl'));
                                $('#edit-employeeRole').val($(this).data('employeerole'));
                                $('#edit-status').val($(this).data('status'));
                                $('#edit-avatar-preview').attr('src', $(this).data('profilepictureurl') || 'https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg');

                                // Xóa lỗi cũ
                                $('.text-danger').text('');
                            });

                            // Validate khi submit form edit
                            $('#editEmployeeForm').on('submit', function (e) {
                                var username = $('#edit-username').val();
                                var oldUsername = $('#edit-username').data('old'); // Lấy giá trị cũ của username
                                var fullName = $('#edit-fullName').val();
                                var email = $('#edit-email').val();
                                var oldEmail = $('#edit-email').data('old'); // Lấy giá trị cũ của email
                                var phoneNumber = $('#edit-phoneNumber').val();
                                var oldPhoneNumber = $('#edit-phoneNumber').data('old'); // Lấy giá trị cũ của phone number
                                var address = $('#edit-address').val();
                                var profilePictureURL = $('#edit-profilePictureURL').val();
                                var employeeRole = $('#edit-employeeRole').val();
                                var status = $('#edit-status').val();

                                var errorUsername = $('#edit-username-error');
                                var errorFullName = $('#edit-fullName-error');
                                var errorEmail = $('#edit-email-error');
                                var errorPhoneNumber = $('#edit-phoneNumber-error');
                                var errorAddress = $('#edit-address-error');
                                var errorProfilePictureURL = $('#edit-profilePictureURL-error');
                                var errorEmployeeRole = $('#edit-employeeRole-error');
                                var errorStatus = $('#edit-status-error');

                                var hasError = false;

                                // Reset lỗi trước khi kiểm tra
                                errorUsername.text('');
                                errorFullName.text('');
                                errorEmail.text('');
                                errorPhoneNumber.text('');
                                errorAddress.text('');
                                errorProfilePictureURL.text('');
                                errorEmployeeRole.text('');
                                errorStatus.text('');

                                // Validate username
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

                                // Validate full name
                                if (!fullName || fullName.trim() === "" || fullName.length < 3) {
                                    errorFullName.text("Họ và tên phải có ít nhất 3 ký tự và không được để trống.");
                                    hasError = true;
                                }

                                // Validate email
                                const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
                                if (!email || email.trim() === "" || !emailRegex.test(email)) {
                                    errorEmail.text("Email không hợp lệ hoặc để trống.");
                                    hasError = true;
                                } else if (email.toLowerCase() !== oldEmail.toLowerCase() && existingEmails.includes(email.toLowerCase())) {
                                    errorEmail.text("Email đã tồn tại.");
                                    hasError = true;
                                }

                                // Validate phone number
                                const phoneRegex = /^[0-9]{10,11}$/;
                                if (!phoneNumber || phoneNumber.trim() === "") {
                                    errorPhoneNumber.text("Số điện thoại không được để trống.");
                                    hasError = true;
                                } else if (!phoneRegex.test(phoneNumber)) {
                                    errorPhoneNumber.text("Số điện thoại phải chứa 10 hoặc 11 chữ số.");
                                    hasError = true;
                                } else if (phoneNumber !== oldPhoneNumber && existingPhoneNumbers.includes(phoneNumber)) {
                                    errorPhoneNumber.text("Số điện thoại đã tồn tại.");
                                    hasError = true;
                                }

                                // Validate địa chỉ
                                if (address && address.trim().length < 5) {
                                    errorAddress.text("Địa chỉ phải có ít nhất 5 ký tự.");
                                    hasError = true;
                                }

                                // Validate URL avatar
                                const urlRegex = /^(https?|ftp):\/\/[^\s/$.?#].[^\s]*$/;
                                if (profilePictureURL && !urlRegex.test(profilePictureURL)) {
                                    errorProfilePictureURL.text("URL avatar không hợp lệ.");
                                    hasError = true;
                                }

                                // Validate employee role
                                const validRoles = ['Manager', 'Staff', 'Receptionist'];
                                if (!validRoles.includes(employeeRole)) {
                                    errorEmployeeRole.text("Vai trò nhân viên không hợp lệ.");
                                    hasError = true;
                                }

                                // Validate status
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
                            $('#editEmployeeModal').on('hidden.bs.modal', function () {
                                var form = $(this).find('form');
                                form[0].reset(); // Reset tất cả các trường trong form
                                $('.text-danger').text(''); // Xóa tất cả lỗi
                            });

                            // Populate View Employee Modal
                            $('.view-btn').on('click', function () {
                                $('#view-employeeID').text($(this).data('employeeid'));
                                $('#view-username').text($(this).data('username'));
                                $('#view-fullName').text($(this).data('fullname'));
                                $('#view-email').text($(this).data('email'));
                                $('#view-phoneNumber').text($(this).data('phonenumber'));
                                $('#view-address').text($(this).data('address'));
                                $('#view-employeeRole').text($(this).data('employeerole'));
                                $('#view-registrationDate').text($(this).data('registrationdate'));

                                var status = $(this).data('status');
                                var statusHtml = status === 'Active' ? '<span class="status-active">Active</span>' : '<span class="status-inactive">Inactive</span>';
                                $('#view-status').html(statusHtml);

                                var profilePictureUrl = $(this).data('profilepictureurl') || 'https://i.pinimg.com/236x/5e/e0/82/5ee082781b8c41406a2a50a0f32d6aa6.jpg';
                                $('#view-avatar').attr('src', profilePictureUrl);
                            });

                            // Reset form when closing Add Employee Modal
                            $('#addEmployeeModal').on('hidden.bs.modal', function () {
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