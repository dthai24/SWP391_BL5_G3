<%@ page contentType="text/html; charset=UTF-8" %>
<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
            <span class="sidebar-brand-text align-middle">
                Dashboards
            </span>


        <ul class="sidebar-nav">
            <li class="sidebar-header">Quản lý hệ thống</li>
            <li class="sidebar-item">
		<a data-bs-target="#dashboards" data-bs-toggle="collapse" class="sidebar-link collapsed">
                    <i class="align-middle" data-feather="user"></i> <span class="align-middle">Quản lý người dùng</span>
		</a>
		<ul id="dashboards" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">
                    <li class="sidebar-item"><a class="sidebar-link" href="<%= request.getContextPath() %>/employee">Quản lý nhân viên</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="<%= request.getContextPath() %>/customer">Quản lý khách hàng</a></li>
							
		</ul>
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
                    <i class="align-middle fas fa-door-open"></i> 
                    <span class="align-middle">Quản lý phòng</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/roomcategory">
                    <i class="align-middle" data-feather="layers"></i>
                    <span class="align-middle">Quản lý loại phòng</span>
                </a>
            </li>
            
            <li class="sidebar-item">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/inventory-item">
                    <i class="align-middle" data-feather="box"></i>
                    <span class="align-middle">Quản lý đồ vật</span>
                </a>
            </li>
            
            <li class="sidebar-item">
                <a class="sidebar-link" href="<%= request.getContextPath() %>/inventory-room">
                    <i class="align-middle fas fa-door-closed"></i>
                    <span class="align-middle">Quản lý đồ vật theo phòng</span>
                </a>
            </li>
        </ul>
    </div>
</nav>