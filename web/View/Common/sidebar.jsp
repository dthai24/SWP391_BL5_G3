<%@ page contentType="text/html; charset=UTF-8" %>
<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
            <span class="sidebar-brand-text align-middle">
                Dashboards
            </span>


        <ul class="sidebar-nav">
            <li class="sidebar-header">Quản lý hệ thống</li>
            <li class="sidebar-item">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/user">
                    <i class="align-middle" data-feather="user"></i> 
                    <span class="align-middle">Quản lý người dùng</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/manage-bookings">
                    <i class="align-middle" data-feather="calendar"></i>
                    <span class="align-middle">Quản lý đặt phòng</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a class="sidebar-link" href="service-management.jsp">
                    <i class="align-middle" data-feather="settings"></i>
                    <span class="align-middle">Quản lý dịch vụ</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/room">
                    <i class="align-middle fas fa-door-open"></i> <span class="align-middle">Quản lý phòng</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/room-category">
                    <i class="align-middle" data-feather="layers"></i>
                    <span class="align-middle">Quản lý loại phòng</span>
                </a>
            </li>
        </ul>
    </div>
</nav>