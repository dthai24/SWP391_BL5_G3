<%@ page import="java.util.List" %>
<%@ page import="Model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Người Dùng</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <%@ include file="/View/Common/header.jsp" %>
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="/View/Common/sidebar.jsp" %> <!-- Sidebar -->
            <div class="main">
                <%@ include file="/View/Common/navbar.jsp" %> <!-- Navbar -->
                <main class="content">
                    <div class="container mt-5">
                        <% 
                            List<User> users = (List<User>) request.getAttribute("users");
                            SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
                            int currentPage = (int) request.getAttribute("currentPage");
                            int totalPages = (int) request.getAttribute("totalPages");
                            String sortField = (String) request.getAttribute("sortField");
                            String sortDir = (String) request.getAttribute("sortDir");
                            String filterRole = request.getParameter("filterRole");
                            String nextSortDir = "asc".equals(sortDir) ? "desc" : "asc";
                        %>
                        <%!
            // Hàm hỗ trợ xây dựng URL động
            String buildSortUrl(String field, String nextSortDir, String searchKeyword, String filterRole) {
                StringBuilder url = new StringBuilder();
                url.append("?action=list");
                url.append("&sortField=").append(field);
                url.append("&sortDir=").append(nextSortDir);
                if (searchKeyword != null && !searchKeyword.isEmpty()) {
                    url.append("&searchKeyword=").append(searchKeyword);
                }
                if (filterRole != null && !filterRole.isEmpty()) {
                    url.append("&filterRole=").append(filterRole);
                }
                return url.toString();
            }
                        %>
                        <% 
                            String success = request.getParameter("success");
                            String error = request.getParameter("error");
                            if (success != null) { %>
                        <div class="alert alert-success"><%= success %></div>
                        <% } else if (error != null) { %>
                        <div class="alert alert-danger"><%= error %></div>
                        <% } %>

                        <div class="card shadow-lg">
                            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Người Dùng</h3>
                                <div>
                                    <a href="<%= request.getContextPath() %>/View/User/add.jsp" class="btn btn-light btn-sm">
                                        <i class="fa fa-plus"></i> Thêm Người Dùng
                                    </a>
                                </div>
                            </div>
                            <div class="card-body">
                                <form method="get" action="<%= request.getContextPath() %>/user">
                                    <input type="hidden" name="action" value="list">
                                    <div class="row mb-3">
                                        <div class="col-md-4">
                                            <input type="text" name="searchKeyword" class="form-control" placeholder="Tìm kiếm tên hoặc email"
                                                   value="<%= request.getParameter("searchKeyword") %>">
                                        </div>
                                        <div class="col-md-3">
                                            <select name="filterRole" class="form-control">
                                                <option value="">Tất cả vai trò</option>
                                                <option value="Admin" <%= "Admin".equals(filterRole) ? "selected" : "" %>>Admin</option>
                                                <option value="Customer" <%= "Customer".equals(filterRole) ? "selected" : "" %>>Customer</option>
                                                <option value="Staff" <%= "Staff".equals(filterRole) ? "selected" : "" %>>Staff</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2 d-flex">
                                            <button type="submit" class="btn btn-primary mr-2">Áp dụng</button>
                                            <a href="<%= request.getContextPath() %>/user?action=list" class="btn btn-secondary">Hủy</a>
                                        </div>
                                    </div>
                                </form>

                                <table class="table table-hover table-bordered">
                                    <thead>
                                        <tr>
                                            <th>Avatar</th>
                                            <th>
                                                <a href="<%= buildSortUrl("userID", nextSortDir, null, null) %>">ID</a>
                                            </th>
                                            <th>Tên Người Dùng</th>
                                            <th>Email</th>
                                            <th>Số Điện Thoại</th>
                                            <th>Vai trò</th>
                                            <th>Trạng Thái</th>
                                            <th>Ngày Đăng Ký</th>
                                            <th>Hành Động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (users == null || users.isEmpty()) { %>
                                        <tr><td colspan="9" class="text-center">Không có người dùng nào.</td></tr>
                                        <% } else { 
                                            for (User user : users) { %>
                                        <tr>
                                            <td>
                                                <img src="<%= user.getProfilePictureURL() != null ? user.getProfilePictureURL() : "https://example.com/default-avatar.jpg" %>" 
                                                     alt="Avatar" class="img-fluid rounded-circle" style="width: 50px; height: 50px;">
                                            </td>
                                            <td><%= user.getUserID() %></td>
                                            <td><%= user.getUsername() %></td>
                                            <td><%= user.getEmail() %></td>
                                            <td><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A" %></td>
                                            <td><%= user.getRole() %></td>
                                            <td><%= "Active".equals(user.getStatus()) ? "Hoạt động" : "Không hoạt động" %></td>
                                            <td><%= user.getRegistrationDate() != null ? dateFormat.format(user.getRegistrationDate()) : "N/A" %></td>
                                            <td class="action-buttons">
                                                <a href="<%= request.getContextPath() %>/user?action=detail&userID=<%= user.getUserID() %>" class="btn btn-info btn-sm">Chi Tiết</a>
                                                <a href="<%= request.getContextPath() %>/user?action=edit&userID=<%= user.getUserID() %>" class="btn btn-warning btn-sm">Sửa</a>
                                                <a href="<%= request.getContextPath() %>/user?action=delete&userID=<%= user.getUserID() %>" 
                                                   class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này không?');">Xóa</a>
                                            </td>
                                        </tr>
                                        <% } } %>
                                    </tbody>
                                </table>

                                <nav>
                                    <ul class="pagination justify-content-center">
                                        <% for (int i = 1; i <= totalPages; i++) { %>
                                        <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                            <a class="page-link" href="?action=list&page=<%= i %>"><%= i %></a>
                                        </li>
                                        <% } %>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </main>
                <%@ include file="/View/Common/footer.jsp" %> <!-- Footer -->
            </div>
        </div>
        <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
    </body>
</html>