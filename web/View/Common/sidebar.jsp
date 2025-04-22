<%@ page contentType="text/html; charset=UTF-8" %>
<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
        <a class="sidebar-brand" href="index.html">
            <span class="sidebar-brand-text align-middle">
                Dashboard
            </span>
        </a>

        <ul class="sidebar-nav">
            <li class="sidebar-header">Pages</li>
            <li class="sidebar-item active">
                <a data-bs-target="#dashboards" data-bs-toggle="collapse" class="sidebar-link">
                    <i class="align-middle" data-feather="sliders"></i> <span class="align-middle">Dashboards</span>
                </a>
                <ul id="dashboards" class="sidebar-dropdown list-unstyled collapse show" data-bs-parent="#sidebar">
                    <li class="sidebar-item active"><a class="sidebar-link" href="index.html">Analytics</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="dashboard-ecommerce.html">E-Commerce</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="dashboard-crypto.html">Crypto</a></li>
                </ul>
            </li>
            <li class="sidebar-item">
                <a data-bs-target="#pages" data-bs-toggle="collapse" class="sidebar-link collapsed">
                    <i class="align-middle" data-feather="layout"></i> <span class="align-middle">Pages</span>
                </a>
                <ul id="pages" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-settings.html">Settings</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-projects.html">Projects <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-clients.html">Clients <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-pricing.html">Pricing <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-chat.html">Chat <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-blank.html">Blank Page</a></li>
                </ul>
            </li>
            <li class="sidebar-item">
                <a href="#auth" data-bs-toggle="collapse" class="sidebar-link collapsed">
                    <i class="align-middle" data-feather="users"></i> <span class="align-middle">Auth</span>
                </a>
                <ul id="auth" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-sign-in.html">Sign In</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-sign-up.html">Sign Up</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-reset-password.html">Reset Password <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-404.html">404 Page <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="pages-500.html">500 Page <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                </ul>
            </li>

            <li class="sidebar-header">
                Components
            </li>
            
            <li class="sidebar-item">
                <a data-bs-target="#ui" data-bs-toggle="collapse" class="sidebar-link collapsed">
                    <i class="align-middle" data-feather="briefcase"></i> <span class="align-middle">UI Elements</span>
                </a>
                <ul id="ui" class="sidebar-dropdown list-unstyled collapse " data-bs-parent="#sidebar">
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-alerts.html">Alerts</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-buttons.html">Buttons</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-cards.html">Cards</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-general.html">General</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-grid.html">Grid</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-modals.html">Modals</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-offcanvas.html">Offcanvas <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-placeholders.html">Placeholders <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-tabs.html">Tabs <span
                                class="sidebar-badge badge bg-primary">Pro</span></a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="ui-typography.html">Typography</a></li>
                </ul>
            </li>
        </ul>
    </div>
</nav>