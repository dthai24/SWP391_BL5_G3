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
        <style>
            .sortable:hover {
                text-decoration: underline;
                cursor: pointer;
            }

            .sortable i {
                margin-left: 5px;
            }
            
            .action-buttons a {
                margin-right: 5px;
            }
        </style>
    </head>
    <body>
        <%
            List<User> users = (List<User>) request.getAttribute("users");
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
            int currentPage = (int) request.getAttribute("currentPage");
            int totalPages = (int) request.getAttribute("totalPages");
            String sortField = (String) request.getAttribute("sortField");
            String sortDir = (String) request.getAttribute("sortDir");
            String filterRole = request.getParameter("filterRole");
            String filterStatus = request.getParameter("filterStatus");
            String searchKeyword = request.getParameter("searchKeyword");
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

        <div class="container mt-5">
            <!-- Hiển thị thông báo nếu có -->
            <% String success = request.getParameter("success");
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
                        <!-- Link đến add.jsp -->
                        <a href="<%= request.getContextPath() %>/View/User/add.jsp" class="btn btn-light btn-sm">
                            <i class="fa fa-plus"></i> Thêm Người Dùng
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <!-- Bộ lọc và tìm kiếm -->
                    <form method="get" action="<%= request.getContextPath() %>/user">
                        <input type="hidden" name="action" value="list">
                        <div class="row mb-3">
                            <!-- Tìm kiếm -->
                            <div class="col-md-4">
                                <input type="text" name="searchKeyword" class="form-control" placeholder="Tìm kiếm tên hoặc email"
                                       value="<%= searchKeyword != null ? searchKeyword : "" %>">
                            </div>
                            <!-- Lọc vai trò -->
                            <div class="col-md-3">
                                <select name="filterRole" class="form-control">
                                    <option value="">Tất cả vai trò</option>
                                    <option value="Admin" <%= "Admin".equals(filterRole) ? "selected" : "" %>>Admin</option>
                                    <option value="Customer" <%= "Customer".equals(filterRole) ? "selected" : "" %>>Customer</option>
                                    <option value="Staff" <%= "Staff".equals(filterRole) ? "selected" : "" %>>Staff</option>
                                    <option value="Receptionist" <%= "Receptionist".equals(filterRole) ? "selected" : "" %>>Receptionist</option>
                                    <option value="Manager" <%= "Manager".equals(filterRole) ? "selected" : "" %>>Manager</option>
                                </select>
                            </div>
                            <!-- Lọc trạng thái -->
<!--                            <div class="col-md-3">
                                <select name="filterStatus" class="form-control">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="Active" <%= "Active".equals(filterStatus) ? "selected" : "" %>>Hoạt động</option>
                                    <option value="Inactive" <%= "Inactive".equals(filterStatus) ? "selected" : "" %>>Không hoạt động</option>
                                </select>
                            </div>-->
                            <!-- Nút áp dụng và hủy -->
                            <div class="col-md-2 d-flex">
                                <button type="submit" class="btn btn-primary mr-2">Áp dụng</button>
                                <a href="<%= request.getContextPath() %>/user?action=list" class="btn btn-secondary">Hủy</a>
                            </div>
                        </div>
                    </form>

                    <!-- Bảng danh sách người dùng -->
                    <table class="table table-hover table-bordered">
                        <thead>
                            <tr>
                                <th>Avatar</th>
                                <th class="sortable">
                                    <a href="<%= buildSortUrl("userID", nextSortDir, searchKeyword, filterRole) %>">
                                        ID
                                        <% if ("userID".equals(sortField)) { %>
                                        <i class="fa <%= "asc".equals(sortDir) ? "fa-sort-up" : "fa-sort-down" %>"></i>
                                        <% } %>
                                    </a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= buildSortUrl("username", nextSortDir, searchKeyword, filterRole) %>">
                                        Tên Người Dùng
                                        <% if ("username".equals(sortField)) { %>
                                        <i class="fa <%= "asc".equals(sortDir) ? "fa-sort-up" : "fa-sort-down" %>"></i>
                                        <% } %>
                                    </a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= buildSortUrl("email", nextSortDir, searchKeyword, filterRole) %>">
                                        Email
                                        <% if ("email".equals(sortField)) { %>
                                        <i class="fa <%= "asc".equals(sortDir) ? "fa-sort-up" : "fa-sort-down" %>"></i>
                                        <% } %>
                                    </a>
                                </th>
                                <th>Số Điện Thoại</th>
                                <th class="sortable">  
                                    <a href="<%= buildSortUrl("address", nextSortDir, searchKeyword, filterRole) %>">
                                        Địa chỉ
                                        <% if ("address".equals(sortField)) { %>
                                        <i class="fa <%= "asc".equals(sortDir) ? "fa-sort-up" : "fa-sort-down" %>"></i>
                                        <% } %>
                                    </a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= buildSortUrl("role", nextSortDir, searchKeyword, filterRole) %>">
                                        Vai trò
                                        <% if ("role".equals(sortField)) { %>
                                        <i class="fa <%= "asc".equals(sortDir) ? "fa-sort-up" : "fa-sort-down" %>"></i>
                                        <% } %>
                                    </a>
                                </th>
                                <th class="sortable">
                                    <a href="<%= buildSortUrl("status", nextSortDir, searchKeyword, filterRole) %>">
                                        Trạng Thái
                                        <% if ("status".equals(sortField)) { %>
                                        <i class="fa <%= "asc".equals(sortDir) ? "fa-sort-up" : "fa-sort-down" %>"></i>
                                        <% } %>
                                    </a>
                                </th>
                                <th>
                                    <a href="<%= buildSortUrl("registrationDate", nextSortDir, searchKeyword, filterRole) %>">
                                        Ngày Đăng Ký
                                        <% if ("registrationDate".equals(sortField)) { %>
                                        <i class="fa <%= "asc".equals(sortDir) ? "fa-sort-up" : "fa-sort-down" %>"></i>
                                        <% } %>
                                    </a>
                                </th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (users != null && !users.isEmpty()) {
                for (User user : users) { %>
                            <tr>
                                <td>
                                    <img src="<%= user.getProfilePictureURL() != null ? user.getProfilePictureURL() : "https://i.pinimg.com/222x/2a/65/f9/2a65f948b71ff3a70e21c64bca10a312.jpg" %>" 
                                         alt="Avatar" class="img-fluid rounded-circle" style="width: 50px; height: 50px;">
                                </td>
                                <td><%= user.getUserID() %></td>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A" %></td>
                                <td><%= user.getAddress() != null ? user.getAddress() : "N/A" %></td>
                                <td><%= user.getRole() %></td>
                                <td>
                                    <% if ("Active".equals(user.getStatus())) { %>
                                    <span class="badge badge-success">Hoạt động</span>
                                    <% } else { %>
                                    <span class="badge badge-danger">Không hoạt động</span>
                                    <% } %>
                                </td>
                                <td><%= user.getRegistrationDate() != null ? dateFormat.format(user.getRegistrationDate()) : "N/A" %></td>
                                <td class="action-buttons">
                                    <a href="<%= request.getContextPath() %>/user?action=detail&userID=<%= user.getUserID() %>" class="btn btn-info btn-sm">
                                         <i class="fa fa-eye"></i> Chi Tiết
                                    </a>
                                    <a href="<%= request.getContextPath() %>/user?action=edit&userID=<%= user.getUserID() %>" class="btn btn-warning btn-sm">
                                        <i class="fa fa-pencil-alt"></i> Sửa
                                    </a>
                                    <a href="<%= request.getContextPath() %>/user?action=delete&userID=<%= user.getUserID() %>" 
                                       class="btn btn-danger btn-sm" 
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa người dùng này không?');">
                                        <i class="fa fa-trash"></i> Xóa
                                    </a>
                                </td>
                            </tr>
                            <% }
            } else { %>
                            <tr>
                                <td colspan="9" class="text-center">Không có người dùng nào.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <!-- Phân trang -->
                    <nav>
                        <ul class="pagination justify-content-center">
                            <% for (int i = 1; i <= totalPages; i++) { %>
                            <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                <a class="page-link" href="?action=list&page=<%= i %><%= sortField != null ? "&sortField=" + sortField : "" %><%= sortDir != null ? "&sortDir=" + sortDir : "" %><%= filterRole != null ? "&filterRole=" + filterRole : "" %><%= filterStatus != null ? "&filterStatus=" + filterStatus : "" %><%= searchKeyword != null ? "&searchKeyword=" + searchKeyword : "" %>">
                                    <%= i %>
                                </a>
                            </li>
                            <% } %>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
        <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
    </body>
</html>