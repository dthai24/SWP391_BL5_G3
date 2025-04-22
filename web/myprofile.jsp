<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<%
    User user = (User ) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi" kite-lang="vi" class="chrome no-js" dir="ltr">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hồ Sơ Của Tôi</title>
    <link rel="icon" href="/favicon.ico" />
    <link href='https://cdn6.agoda.net/cdn-universal-login/js/assets/LEGACY-BROWSERS/profile-33db565d3ecc.css' rel='stylesheet' />
</head>

<body class="profile desktop ltr themed theme-agoda">
    <div id="page-root">
        <header id="page-header" data-selenium="page-header" class="navbar-agoda main-header scrollTo"></header>
        <div class="container-agoda mmb-profile">
            <div class="mmb-left-pane">
                <section class="mmb-menu-component" data-selenium="mmb-menu-component">
                    <ul>
                        <li class="mmb-menu-topitem-inactive" data-selenium="mmb-menuitem-bookings">
                            <a href="/vi-vn/account/bookings.html" data-selenium="mmb-menuitem-bookings-link">
                                <i class="mmb-menu-icon ficon ficon-24 ficon-mmb-my-booking"></i>
                                <span data-selenium="mmb-menuitem-bookings-label">Đơn đặt chỗ của tôi</span>
                            </a>
                        </li>
                        <li class="mmb-menu-topitem-active" data-selenium="mmb-menuitem-profile">
                            <a href="#" data-selenium="mmb-menuitem-profile-link">
                                <i class="mmb-menu-icon ficon ficon-24 ficon-mmb-account"></i>
                                <span data-selenium="mmb-menuitem-profile-label">Hồ sơ của tôi</span>
                            </a>
                        </li>
                    </ul>
                </section>
                <div class="mmb-seperate-line"></div>
            </div>

            <div id="mmb-account-page" class="mmb-page">
                <section id="user-details" class="mmb-panel" data-selenium="mmb-user-details-panel">
                    <h1 data-selenium="mmb-user-details-panel-title">Thông tin người dùng</h1>
                    <section id="mmb-name-component" class="mmb-component" data-selenium="m mb-name-component">
                        <div id="mmb-name-component-display" class="name-gradient-3" data-selenium="mmb-name-component-display">
                            <div id="mmb-name-component-display-avatar" data-selenium="mmb-name-component-display-avatar">
                                <i class="bg-user-icon-3" data-selenium="user-icon" data-user-badge-icon>
                                    <span>C</span>
                                </i>
                            </div>
                            <div id="mmb-name-component-display-name">
                                <h2 data-selenium="mmb-name-component-display-name-label">Họ & Tên</h2>
                                <span id="mmb-name-component-display-name-value" class="mmb-value-text" data-selenium="mmb-name-component-display-name-value">
                                    <%= user.getFullName() %>
                                </span>
                            </div>
                            <div id="mmb-name-component-display-edit">
                                <span id="mmb-name-component-display-edit-label" class="mmb-action-text" data-selenium="mmb-name-component-display-edit-label">Chỉnh sửa</span>
                            </div>
                        </div>
                        <div id="mmb-name-component-change" data-selenium="mmb-name-component-change">
                            <h2 data-selenium="mmb-name-component-change-firstname-label">Tên</h2>
                            <input id="mmb-name-component-change-firstname" type="text" class="form-control"
                                   value="<%= user.getFirstName() %>" placeholder="Tên"
                                   data-selenium="mmb-name-component-change-firstname-field" maxlength="64" />
                            <h2 data-selenium="mmb-name-component-change-lastname-label">Họ</h2>
                            <input id="mmb-name-component-change-lastname" type="text" class="form-control"
                                   value="<%= user.getLastName() %>" placeholder="Họ"
                                   data-selenium="mmb-name-component-change-lastname-field" maxlength="64" />
                            <div class="mmb-component-buttons">
                                <input id="mmb-name-component-change-cancel" type="button" class="btn btn-blueline"
                                       value="Hủy" data-selenium="mmb-name-component-change-cancel-button" />
                                <input id="mmb-name-component-change-save" type="button" class="btn btn-primary"
                                       value="Lưu" data-selenium="mmb-name-component-change-save-button" />
                            </div>
                        </div>
                    </section>

                    <section id="mmb-email-component" class="mmb-component" data-selenium="mmb-email-component">
                        <div id="mmb-email-component-display" class="mmb-email-verified-component">
                            <div id="mmb-email-component-display-email" class="mmb-notification-component">
                                <div>
                                    <h2 data-selenium="mmb-email-component-display-email-label">Email</h2>
                                    <span id="mmb-email-success-notification-component" class="mmb-success-notification-component">
                                        <i class="ficon ficon-right-tick ficon-18"></i>Đã lưu
                                    </span>
                                </div>
                                <span id="mmb-email-component-display-email-value" data-selenium="mmb-email-component-display-email-value">
                                    <%= user.getEmail() %>
                                </span>
                            </div>
                        </div>
                    </section>

                    <section id="mmb-phone-component" class="mmb-component" data-selenium="mmb-phone-component">
                        <div id="mmb-phone-component-display" class="mmb-phone-verified-component">
                            <div id="mmb-phone-component-display-phone" class="mmb-notification-component">
                                <div>
                                    <h2 id="mmb-phone-component-display-phone-label">Số điện thoại</h2>
                                    <span id="mmb-phone-success-notification-component" class="mmb-success-notification-component">
                                        <i class="ficon ficon-right-tick ficon-18"></i>Đã lưu
                                    </span>
                                </div>
                                <span id="mmb-phone-component-display-phone-value" data-selenium="mmb-phone-component-display-phone-value">
                                    <%= user.getPhoneNumber() %>
                                </span>
                            </div>
                        </div>
                    </section>

                    <section id="mmb-password-component" class="mmb-component" data-selenium="mmb-password-component">
                        <div id="mmb-password-component-display">
                            <div id="mmb-password-component-display-password">
                                <div>
                                    <h2 data-selenium="mmb-password-component-display-password-label">Mật khẩu</h2>
                                    <span id="mmb-password-success-notification-component" class="mmb-success-notification-component">
                                        <i class="ficon ficon-right-tick f icon-18"></i>Đã lưu
                                    </span>
                                </div>
                                <span id="mmb-password-component-display-password-value" data-selenium="mmb-password-component-display-password-value">
                                    ********
                                </span>
                            </div>
                            <div id="mmb-password-component-display-edit">
                                <span id="mmb-password-component-display-edit-label" class="mmb-action-text" data-selenium="mmb-password-component-display-edit-label">Chỉnh sửa</span>
                            </div>
                        </div>
                        <div id="mmb-password-component-change" data-selenium="mmb-password-component-change">
                            <h2 data-selenium="mmb-password-component-change-currentpassword-label">Mật khẩu hiện tại</h2>
                            <input id="mmb-password-component-change-currentpassword" type="password" class="form-control"
                                   placeholder="Mật khẩu hiện tại" data-selenium="mmb-password-component-change-currentpassword-field" maxlength="64" />
                            <h2 data-selenium="mmb-password-component-change-newpassword-label">Mật khẩu mới</h2>
                            <input id="mmb-password-component-change-newpassword" type="password" class="form-control"
                                   placeholder="Mật khẩu mới" data-selenium="mmb-password-component-change-newpassword-field" maxlength="64" />
                            <h2 data-selenium="mmb-password-component-change-confirmnewpassword-label">Xác nhận mật khẩu mới</h2>
                            <input id="mmb-password-component-change-confirmnewpassword" type="password" class="form-control"
                                   placeholder="Xác nhận mật khẩu mới" data-selenium="mmb-password-component-change-confirmnewpassword-field" maxlength="64" />
                            <div class="mmb-component-buttons">
                                <input id="mmb-password-component-change-cancel" type="button" class="btn btn-blueline"
                                       value="Hủy" data-selenium="mmb-password-component-change-cancel-button" />
                                <input id="mmb-password-component-change-save" type="button" class="btn btn-primary"
                                       value="Lưu" data-selenium="mmb-password-component-change-save-button" />
                            </div>
                        </div>
                    </section>
                </section>
            </div>
        </div>
    </div>

    <script>
        // Additional JavaScript code for functionality
    </script>
</body>
</html>