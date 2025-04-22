<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="Model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Người Dùng</title>

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
            #user-datatable {
                min-width: 900px !important;
                table-layout: fixed;
            }
            #user-datatable th, #user-datatable td {
                white-space: normal !important;
                word-break: break-word !important;
                vertical-align: middle;
            }
            .notification-box {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1050;
                display: none;
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
                        List<User> users = (List<User>) request.getAttribute("users");
                        User editUser = (User) request.getAttribute("editUser");
                        String successMessage = (String) request.getAttribute("successMessage");
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                    %>

                    <!-- Notification Box -->
                    <% if (successMessage != null) { %>
                    <div class="alert alert-success alert-dismissible fade show notification-box" role="alert">
                        <%= successMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% } %>
                    <% if (errorMessage != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show notification-box" role="alert">
                        <%= errorMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% } %>

                    <!-- Table Section -->
                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Người Dùng</h3>
                                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addUserModal">
                                    <i class="fa fa-plus"></i> Thêm Người Dùng
                                </button>
                            </div>

                            <div class="card-body">
                                <form method="get" action="user" class="form-inline mb-3">
                                    <div class="form-group mr-2">
                                        <label for="filterRole" class="mr-2">Vai trò</label>
                                        <select name="filterRole" id="filterRole" class="form-control">
                                            <option value="">Tất cả</option>
                                            <option value="Admin" <%= "Admin".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Admin</option>
                                            <option value="Customer" <%= "Customer".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Customer</option>
                                            <option value="Staff" <%= "Staff".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Staff</option>
                                            <option value="Receptionist" <%= "Receptionist".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Receptionist</option>
                                            <option value="Manager" <%= "Manager".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Manager</option>
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
                                    <a href="user" class="btn btn-secondary">Hủy</a>
                                </form>
                                <div class="table-responsive">
                                    <table id="user-datatable" class="table table-hover table-striped align-middle">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Avatar</th>
                                                <th>Tên Người Dùng</th>
                                                <th>Họ và Tên</th>
                                                <th>Email</th>
                                                <th>Số Điện Thoại</th>
                                                <th>Địa Chỉ</th>
                                                <th>Vai Trò</th>
                                                <th>Trạng Thái</th>
                                                <th>Ngày Tạo</th>
                                                <th>Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% if (users != null && !users.isEmpty()) {
                                                for (User user : users) { %>
                                            <tr>
                                                <td><%= user.getUserID() %></td>
                                                <td>
                                                    <% if (user.getProfilePictureURL() != null && !user.getProfilePictureURL().isEmpty()) { %>
                                                    <img src="<%= user.getProfilePictureURL() %>" alt="Avatar" class="avatar">
                                                    <% } else { %>
                                                    <img src="<%= request.getContextPath() %>/img/default-avatar.png" alt="Avatar" class="avatar">
                                                    <% } %>
                                                </td>
                                                <td><%= user.getUsername() %></td>
                                                <td><%= user.getFullName() %></td>
                                                <td><%= user.getEmail() %></td>
                                                <td><%= user.getPhoneNumber() %></td>
                                                <td><%= user.getAddress() %></td>
                                                <td><%= user.getRole() %></td>
                                                <td>
                                                    <% if ("Active".equals(user.getStatus())) { %>
                                                    <span class="status-active">Active</span>
                                                    <% } else { %>
                                                    <span class="status-inactive">Inactive</span>
                                                    <% } %>
                                                </td>
                                                <td><%= user.getRegistrationDate() != null ? sdf.format(user.getRegistrationDate()) : "N/A" %></td>
                                                <td>
                                                    <button type="button" class="btn btn-link p-0 view-btn" 
                                                            data-userid="<%= user.getUserID() %>"
                                                            data-username="<%= user.getUsername() %>"
                                                            data-fullname="<%= user.getFullName() %>"
                                                            data-email="<%= user.getEmail() %>"
                                                            data-phonenumber="<%= user.getPhoneNumber() %>"
                                                            data-address="<%= user.getAddress() %>"
                                                            data-role="<%= user.getRole() %>"
                                                            data-status="<%= user.getStatus() %>"
                                                            data-registrationdate="<%= user.getRegistrationDate() != null ? sdf.format(user.getRegistrationDate()) : "N/A" %>"
                                                            data-profilepictureurl="<%= user.getProfilePictureURL() %>"
                                                            data-toggle="modal" data-target="#viewUserModal">
                                                        <i class="fa fa-eye" style="color: #17a2b8;"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-link p-0 edit-btn"
                                                            data-userid="<%= user.getUserID() %>"
                                                            data-username="<%= user.getUsername() %>"
                                                            data-fullname="<%= user.getFullName() %>"
                                                            data-email="<%= user.getEmail() %>"
                                                            data-phonenumber="<%= user.getPhoneNumber() %>"
                                                            data-address="<%= user.getAddress() %>"
                                                            data-role="<%= user.getRole() %>"
                                                            data-status="<%= user.getStatus() %>"
                                                            data-profilepictureurl="<%= user.getProfilePictureURL() %>"
                                                            data-registrationdate="<%= user.getRegistrationDate() != null ? sdf.format(user.getRegistrationDate()) : "N/A" %>"
                                                            data-toggle="modal" data-target="#editUserModal">
                                                        <i class="fa fa-edit" style="color: #ffc107;"></i>
                                                    </button>
                                                    <form method="post" action="user" class="d-inline delete-user-form">
                                                        <input type="hidden" name="deleteUserID" value="<%= user.getUserID() %>" />
                                                        <button type="submit" class="btn btn-link p-0 delete-btn" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?');">
                                                            <i class="fa fa-trash" style="color: #dc3545;"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <%  } 
                                    } else { %>
                                            <tr><td colspan="11" class="text-center">Không có người dùng nào.</td></tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Add User Modal -->
                    <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addUserModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="user" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addUserModalLabel">Thêm Người Dùng Mới</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="add-username">Tên Người Dùng</label>
                                            <input type="text" name="username" id="add-username" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-password">Mật Khẩu</label>
                                            <input type="password" name="password" id="add-password" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-fullName">Họ Và Tên</label>
                                            <input type="text" name="fullName" id="add-fullName" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-email">Email</label>
                                            <input type="email" name="email" id="add-email" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-phoneNumber">Số Điện Thoại</label>
                                            <input type="text" name="phoneNumber" id="add-phoneNumber" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-address">Địa Chỉ</label>
                                            <input type="text" name="address" id="add-address" class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-profilePictureURL">Avatar (URL)</label>
                                            <input type="url" name="profilePictureURL" id="add-profilePictureURL" class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-role">Vai Trò</label>
                                            <select name="role" id="add-role" class="form-control" required>
                                                <option value="Admin">Admin</option>
                                                <option value="Customer">Customer</option>
                                                <option value="Staff">Staff</option>
                                                <option value="Manager">Manager</option>
                                                <option value="Receptionist">Receptionist</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="add-status">Trạng Thái</label>
                                            <select name="status" id="add-status" class="form-control">
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Thêm Người Dùng</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- View User Modal -->
                    <div class="modal fade" id="viewUserModal" tabindex="-1" role="dialog" aria-labelledby="viewUserModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="viewUserModalLabel">Chi Tiết Người Dùng</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="text-center mb-3">
                                        <img id="view-avatar" src="<%= request.getContextPath() %>/img/default-avatar.png" alt="Avatar" class="avatar-large">
                                    </div>
                                    <p><strong>ID:</strong> <span id="view-userID"></span></p>
                                    <p><strong>Tên Người Dùng:</strong> <span id="view-username"></span></p>
                                    <p><strong>Họ và Tên:</strong> <span id="view-fullName"></span></p>
                                    <p><strong>Email:</strong> <span id="view-email"></span></p>
                                    <p><strong>Số Điện Thoại:</strong> <span id="view-phoneNumber"></span></p>
                                    <p><strong>Địa Chỉ:</strong> <span id="view-address"></span></p>
                                    <p><strong>Vai Trò:</strong> <span id="view-role"></span></p>
                                    <p><strong>Trạng Thái:</strong> <span id="view-status"></span></p>
                                    <p><strong>Ngày Tạo:</strong> <span id="view-registrationDate"></span></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>


                    <!-- Edit User Modal -->
                    <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="editUserModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="user" method="post">
                                    <input type="hidden" name="action" value="edit">
                                    <input type="hidden" name="userID" id="edit-userID">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editUserModalLabel">Chỉnh Sửa Thông Tin Người Dùng</h5>
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
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-fullName">Họ và Tên</label>
                                            <input type="text" name="fullName" id="edit-fullName" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-email">Email</label>
                                            <input type="email" name="email" id="edit-email" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-phoneNumber">Số Điện Thoại</label>
                                            <input type="text" name="phoneNumber" id="edit-phoneNumber" class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-address">Địa Chỉ</label>
                                            <input type="text" name="address" id="edit-address" class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-profilePictureURL">Avatar (URL)</label>
                                            <input type="url" name="profilePictureURL" id="edit-profilePictureURL" class="form-control" />
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-role">Vai Trò</label>
                                            <select name="role" id="edit-role" class="form-control" required>
                                                <option value="Admin">Admin</option>
                                                <option value="Customer">Customer</option>
                                                <option value="Staff">Staff</option>
                                                <option value="Manager">Manager</option>
                                                <option value="Receptionist">Receptionist</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-status">Trạng Thái</label>
                                            <select name="status" id="edit-status" class="form-control">
                                                <option value="Active">Active</option>
                                                <option value="Inactive">Inactive</option>
                                            </select>
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
                                                                $('#user-datatable').DataTable({
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

                                                                // Handle Notification Box
                                                                const notificationBox = $('.notification-box');
                                                                if (notificationBox.children().length > 0) {
                                                                    notificationBox.fadeIn();
                                                                    setTimeout(() => notificationBox.fadeOut(), 3000);
                                                                }

                                                                // Populate View User Modal
                                                                $('.view-btn').on('click', function () {
                                                                    // Lấy dữ liệu người dùng từ các thuộc tính data-* của nút
                                                                    $('#view-userID').text($(this).data('userid'));
                                                                    $('#view-username').text($(this).data('username'));
                                                                    $('#view-fullName').text($(this).data('fullname'));
                                                                    $('#view-email').text($(this).data('email'));
                                                                    $('#view-phoneNumber').text($(this).data('phonenumber'));
                                                                    $('#view-address').text($(this).data('address'));
                                                                    $('#view-role').text($(this).data('role'));
                                                                    $('#view-registrationDate').text($(this).data('registrationdate'));

                                                                    // Xử lý trạng thái với HTML tùy chỉnh
                                                                    var status = $(this).data('status');
                                                                    var statusHtml = '';
                                                                    if (status === 'Active') {
                                                                        statusHtml = '<span class="status-active">Active</span>'; // Class cho trạng thái Active
                                                                    } else if (status === 'Inactive') {
                                                                        statusHtml = '<span class="status-inactive">Inactive</span>'; // Class cho trạng thái Inactive
                                                                    }
                                                                    $('#view-status').html(statusHtml); // Thay đổi nội dung trạng thái với HTML đã định dạng

                                                                    // Cập nhật hình đại diện (nếu không có thì dùng hình mặc định)
                                                                    var profilePictureUrl = $(this).data('profilepictureurl') || '<%= request.getContextPath() %>/img/default-avatar.png';
                                                                    $('#view-avatar').attr('src', profilePictureUrl);
                                                                });

                                                                // Populate Edit User Modal
                                                                $('.edit-btn').on('click', function () {
                                                                    $('#edit-userID').val($(this).data('userid'));
                                                                    $('#edit-username').val($(this).data('username'));
                                                                    $('#edit-fullName').val($(this).data('fullname'));
                                                                    $('#edit-email').val($(this).data('email'));
                                                                    $('#edit-phoneNumber').val($(this).data('phonenumber'));
                                                                    $('#edit-address').val($(this).data('address'));
                                                                    $('#edit-profilePictureURL').val($(this).data('profilepictureurl'));
                                                                    $('#edit-role').val($(this).data('role'));
                                                                    $('#edit-status').val($(this).data('status'));
                                                                    $('#edit-avatar-preview').attr('src', $(this).data('profilepictureurl') || '<%= request.getContextPath() %>/img/default-avatar.png');
                                                                    $('#edit-registrationDate').text($(this).data('registrationdate'));
                                                                });
                                                            });
                    </script>
                </main>
                <%@ include file="/View/Common/footer.jsp" %>
            </div>
        </div>
    </body>
</html>