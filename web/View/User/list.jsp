<%@ page import="java.util.List" %>
<%@ page import="Model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Người Dùng</title>
        <!-- CSS -->
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css">
    </head>
    <body>
        <%
            // Lấy danh sách người dùng từ Servlet
            List<User> users = (List<User>) request.getAttribute("users");
        %>

        <!-- Main Container -->
        <div class="container mt-5">
            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">Danh Sách Người Dùng</h3>
                    <!-- Nút Thêm Người Dùng -->
                    <button type="button" class="btn btn-light btn-sm" data-toggle="modal" data-target="#addUserModal">
                        <i class="fa fa-plus"></i> Thêm Người Dùng
                    </button>
                </div>
                <div class="card-body">
                    <!-- Bảng Người Dùng -->
                    <div class="table-responsive">
                        <table id="user-datatable" class="table table-hover table-bordered">
                            <thead class="thead-dark">
                                <tr>
                                    <th>Avatar</th>
                                    <th>ID</th>
                                    <th>Tên Người Dùng</th>
                                    <th>Email</th>
                                    <th>Vai Trò</th>
                                    <th>Trạng Thái</th>
                                    <th>Hành Động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (users != null && !users.isEmpty()) {
                                for (User user : users) { %>
                                <tr>
                                    <td>
                                        <% if (user.getProfilePictureURL() != null && !user.getProfilePictureURL().isEmpty()) { %>
                                        <img src="<%= user.getProfilePictureURL() %>" alt="Avatar" class="img-fluid rounded-circle" style="width: 50px; height: 50px;">
                                        <% } else { %>
                                        <img src="https://media.tenor.com/k_UsDt9xfWIAAAAM/i-will-eat-you-cat.gif" alt="Default Avatar" class="img-fluid rounded-circle">
                                        <% } %>
                                    </td>
                                    <td><%= user.getUserID() %></td>
                                    <td><%= user.getUsername() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><%= user.getRole() %></td>
                                    <td>
                                        <% if ("Active".equals(user.getStatus())) { %>
                                        <span class="badge badge-success">Active</span>
                                        <% } else { %>
                                        <span class="badge badge-danger">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <!-- Nút Chi Tiết -->
                                        <button type="button" class="btn btn-info btn-sm detail-btn"
                                                data-userid="<%= user.getUserID() %>"
                                                data-username="<%= user.getUsername() %>"
                                                data-fullname="<%= user.getFullName() %>"
                                                data-email="<%= user.getEmail() %>"
                                                data-role="<%= user.getRole() %>"
                                                data-status="<%= user.getStatus() %>"
                                                data-profilepictureurl="<%= user.getProfilePictureURL() != null ? user.getProfilePictureURL() : "https://via.placeholder.com/150" %>"
                                                data-toggle="modal" data-target="#detailUserModal">
                                            <i class="fa fa-info-circle"></i> Chi Tiết
                                        </button>
                                        <!-- Nút Sửa -->
                                        <button type="button" class="btn btn-warning btn-sm edit-btn"
                                                data-userid="<%= user.getUserID() %>"
                                                data-username="<%= user.getUsername() %>"
                                                data-fullname="<%= user.getFullName() %>"
                                                data-email="<%= user.getEmail() %>"
                                                data-role="<%= user.getRole() %>"
                                                data-status="<%= user.getStatus() %>"
                                                data-profilepictureurl="<%= user.getProfilePictureURL() %>"
                                                data-toggle="modal" data-target="#editUserModal">
                                            <i class="fa fa-pencil-alt"></i> Sửa
                                        </button>
                                        <!-- Nút Xóa -->
                                        <button type="button" class="btn btn-danger btn-sm delete-btn" data-userid="<%= user.getUserID() %>">
                                            <i class="fa fa-trash"></i> Xóa
                                        </button>
                                    </td>
                                </tr>
                                <% }
                            } else { %>
                                <tr>
                                    <td colspan="7" class="text-center">Không có người dùng nào.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Thêm Người Dùng -->
        <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="user" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-header">
                            <h5 class="modal-title">Thêm Người Dùng</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label>URL Ảnh:</label>
                                <input type="url" name="imageUrl" class="form-control" placeholder="Nhập URL ảnh (tùy chọn)">
                            </div>
                            <div class="form-group">
                                <label>Tên Người Dùng</label>
                                <input type="text" name="username" class="form-control" placeholder="Nhập tên người dùng" required>
                            </div>
                            <div class="form-group">
                                <label>Họ Tên</label>
                                <input type="text" name="fullName" class="form-control" placeholder="Nhập họ và tên" required>
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" class="form-control" placeholder="Nhập email" required>
                            </div>
                            <div class="form-group">
                                <label>Vai Trò</label>
                                <select name="role" class="form-control">
                                    <option value="Admin">Admin</option>
                                    <option value="Customer">Customer</option>
                                    <option value="Staff">Staff</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Trạng Thái</label>
                                <select name="status" class="form-control">
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Thêm Mới</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Modal Sửa Người Dùng -->
        <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <form action="user" method="post">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="userID" id="edit-userID">
                        <div class="modal-header">
                            <h5 class="modal-title">Sửa Người Dùng</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label>URL Ảnh:</label>
                                <input type="url" name="imageUrl" id="edit-imageUrl" class="form-control" placeholder="Nhập URL ảnh (tùy chọn)">
                            </div>
                            <div class="form-group">
                                <label>Tên Người Dùng</label>
                                <input type="text" name="username" id="edit-username" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Họ Tên</label>
                                <input type="text" name="fullName" id="edit-fullname" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Email</label>
                                <input type="email" name="email" id="edit-email" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Vai Trò</label>
                                <select name="role" id="edit-role" class="form-control">
                                    <option value="Admin">Admin</option>
                                    <option value="Customer">Customer</option>
                                    <option value="Staff">Staff</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Trạng Thái</label>
                                <select name="status" id="edit-status" class="form-control">
                                    <option value="Active">Active</option>
                                    <option value="Inactive">Inactive</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-primary">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
        <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
        <script>
            $(document).ready(function () {
                $('.edit-btn').click(function () {
                    $('#edit-userID').val($(this).data('userid'));
                    $('#edit-username').val($(this).data('username'));
                    $('#edit-fullname').val($(this).data('fullname'));
                    $('#edit-email').val($(this).data('email'));
                    $('#edit-role').val($(this).data('role'));
                    $('#edit-status').val($(this).data('status'));
                    $('#edit-imageUrl').val($(this).data('profilepictureurl'));
                });
                $('#user-datatable').DataTable();
            });
        </script>
    </body>
</html>