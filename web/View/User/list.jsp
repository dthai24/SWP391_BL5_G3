<%@ page import="java.util.List" %>
<%@ page import="Model.User" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Người Dùng</title>
    <%@ include file="/View/Common/header.jsp" %> <!-- Include header -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
    <style>
        .info-label { font-weight: 600; }
        .status-active { background-color: #28A745; color: #fff; padding: 5px 10px; border-radius: 4px; }
        .status-inactive { background-color: #DC3545; color: #fff; padding: 5px 10px; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="wrapper">
        <%@ include file="/View/Common/sidebar.jsp" %> <!-- Include sidebar -->
        <div class="main">
            <%@ include file="/View/Common/navbar.jsp" %> <!-- Include navbar -->
            <main class="content">
                <div class="container mt-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 style="font-weight: 700;">Danh Sách Người Dùng</h2>
                        <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addUserModal">
                            <i class="fa fa-plus"></i> Thêm Người Dùng
                        </button>
                    </div>
                    <!-- Filter form -->
                    <form method="get" action="user" class="form-inline mb-3" id="user-filter-form">
                        <div class="form-group mr-2">
                            <label for="filterRole" class="mr-2">Vai trò</label>
                            <select name="filterRole" id="filterRole" class="form-control">
                                <option value="">Tất cả</option>
                                <option value="Admin" <%= "Admin".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Admin</option>
                                <option value="Customer" <%= "Customer".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Customer</option>
                                <option value="Staff" <%= "Staff".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Staff</option>
                                <option value="Manager" <%= "Manager".equals(request.getParameter("filterRole")) ? "selected" : "" %>>Manager</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary mr-2">Lọc</button>
                        <a href="user" class="btn btn-secondary">Hủy</a>
                    </form>
                    <!-- End filter form -->
                    <div class="table-responsive mb-0">
                        <table id="user-datatable" class="table table-hover table-striped">
                            <thead class="thead-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ và Tên</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% List<User> users = (List<User>) request.getAttribute("users");
                                   if (users != null && !users.isEmpty()) {
                                       for (User user : users) { %>
                                <tr>
                                    <td><%= user.getUserID() %></td>
                                    <td><%= user.getFullName() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><%= user.getRole() %></td>
                                    <td>
                                        <% if ("Active".equals(user.getStatus())) { %>
                                            <span class="status-active">Active</span>
                                        <% } else { %>
                                            <span class="status-inactive">Inactive</span>
                                        <% } %>
                                    </td>
                                    <td><%= user.getRegistrationDate() %></td>
                                    <td>
                                        <button type="button" class="btn btn-link p-0 view-btn"
                                            data-userid="<%= user.getUserID() %>"
                                            data-fullname="<%= user.getFullName() %>"
                                            data-email="<%= user.getEmail() %>"
                                            data-role="<%= user.getRole() %>"
                                            data-status="<%= user.getStatus() %>"
                                            data-registrationdate="<%= user.getRegistrationDate() %>"
                                            data-toggle="modal" data-target="#viewUserModal"
                                            title="Xem chi tiết">
                                            <i class="fa fa-eye" style="color: #17a2b8; font-size: 1.2rem;"></i>
                                        </button>
                                        <button type="button" class="btn btn-link p-0 edit-btn"
                                            data-userid="<%= user.getUserID() %>"
                                            data-fullname="<%= user.getFullName() %>"
                                            data-email="<%= user.getEmail() %>"
                                            data-role="<%= user.getRole() %>"
                                            data-status="<%= user.getStatus() %>"
                                            data-toggle="modal" data-target="#editUserModal"
                                            title="Chỉnh sửa">
                                            <i class="fa fa-edit" style="color: #ffc107; font-size: 1.2rem;"></i>
                                        </button>
                                        <form method="post" action="user" class="d-inline delete-user-form">
                                            <input type="hidden" name="deleteUserID" value="<%= user.getUserID() %>" />
                                            <button type="submit" class="btn btn-link p-0 delete-btn"
                                                title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này?');">
                                                <i class="fa fa-trash" style="color: #dc3545; font-size: 1.2rem;"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% }
                                   } else { %>
                                <tr><td colspan="7" class="text-center">Không có người dùng nào.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </main>
            <%@ include file="/View/Common/footer.jsp" %> <!-- Include footer -->
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
    <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
    <script>
    $(document).ready(function() {
        $('#user-datatable').DataTable({
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
    });
    </script>
</body>
</html>