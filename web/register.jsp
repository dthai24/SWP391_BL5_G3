<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>
<!DOCTYPE html>
<html lang="zxx">

    <head>
        <meta charset="UTF-8">
        <meta name="description" content="Sona Template">
        <meta name="keywords" content="Sona, unica, creative, html">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>ROSE MOTEL</title>

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css?family=Lora:400,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Cabin:400,500,600,700&display=swap" rel="stylesheet">

        <!-- Css Styles -->
        <link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="css/font-awesome.min.css" type="text/css">
        <link rel="stylesheet" href="css/elegant-icons.css" type="text/css">
        <link rel="stylesheet" href="css/flaticon.css" type="text/css">
        <link rel="stylesheet" href="css/owl.carousel.min.css" type="text/css">
        <link rel="stylesheet" href="css/nice-select.css" type="text/css">
        <link rel="stylesheet" href="css/jquery-ui.min.css" type="text/css">
        <link rel="stylesheet" href="css/magnific-popup.css" type="text/css">
        <link rel="stylesheet" href="css/slicknav.min.css" type="text/css">
        <link rel="stylesheet" href="css/style.css" type="text/css">
        

        <style>
            a {
                text-decoration: none;
                color: black;
            }

            a:hover,
            a:active,
            a:focus,
            a:visited {
                color: black;
                text-decoration: none;
            }
        </style>

    </head>

    <body>
        <!-- Page Preloder -->
        <div id="preloder">
            <div class="loader"></div>
        </div>

        <!-- Offcanvas Menu Section Begin -->
        <div class="offcanvas-menu-overlay"></div>
        <div class="canvas-open">
            <i class="icon_menu"></i>
        </div>
        <div class="offcanvas-menu-wrapper">
            <div class="canvas-close">
                <i class="icon_close"></i>
            </div>
            <div class="search-icon search-switch">
                <i class="icon_search"></i>
            </div>
            <div class="header-configure-area">
                <div class="language-option">
                    <img src="img/flag.jpg" alt="">
                    <span>EN <i class="fa fa-angle-down"></i></span>
                    <div class="flag-dropdown">
                        <ul>
                            <li><a href="#">VIE</a></li>
                        </ul>
                    </div>
                </div>
                <a href="#" class="bk-btn">Đặt Phòng Ngay</a>
            </div>
           
            <div id="mobile-menu-wrap"></div>
            <div class="top-social">
                <a href="#"><i class="fa fa-facebook"></i></a>
                <a href="#"><i class="fa fa-twitter"></i></a>
                <a href="#"><i class="fa fa-tripadvisor"></i></a>
                <a href="#"><i class="fa fa-instagram"></i></a>
            </div>
            <ul class="top-widget">
                <li><i class="fa fa-phone"></i> (12) 345 67890</li>
                <li><i class="fa fa-envelope"></i> info.colorlib@gmail.com</li>
                </ </ul>
        </div>
        <!-- Offcanvas Menu Section End -->

        <!-- Header Section Begin -->
        <header class="header-section">
            <div class="top-nav">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-6">
                            <ul class="tn-left">
                                <li><i class="logo"></i> <a href="./index.html">
                                    <img src="img/logo.png" alt="">
                                </a></li>
                                <li><i class="fa fa-envelope"></i> info.colorlib@gmail.com</li>
                            </ul>
                        </div>
                        <div class="col-lg-6">
                            <div class="tn-right">
                                <div class="top-social">
                                    <a href="#"><i class="fa fa-facebook"></i></a>
                                    <a href="#"><i class="fa fa-twitter"></i></a>
                                    <a href="#"><i class="fa fa-tripadvisor"></i></a>
                                    <a href="#"><i class="fa fa-instagram"></i></a>
                                </div>
                                <a href="#" class="bk-btn">Đặt Phòng Ngay</a>
                                <div class="language-option">
                                    <%
                         User user = (User) session.getAttribute("user");
                         if (user != null) {
                                    %>
                                    <a href="myprofile.jsp"><i class="fa fa-user"></i> <%= user.getFullName() %></a> |
                                    <a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a>
                                    <%
                                        } else {
                                   
                                        }
                                    %>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
        </header>
        <!-- Header End -->

        <!-- Hero Section Begin -->
        <section class="hero-section">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="hero-text">
                            <h1>Sona A Luxury Hotel</h1>
                            <p>Here are the best hotel booking sites, including recommendations for international
                                travel and for finding low-priced hotel rooms.</p>
                            <a href="#" class="primary-btn">Discover Now</a>
                        </div>
                    </div>
                     <div class="login-container">
            <h2>Đăng Ký</h2>

            <% String error = (String) request.getAttribute("error");
               if (error != null) {
                   out.println("<p style='color:red;'>" + error + "</p>");
               }
            %>

            <form action="register" method="post" onsubmit="return validateForm()">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required><br>

                <label for="password">Password:</label>
                <input type="password" id="password" name="password"
                       pattern="(?=.*[!@#$%^&*]).{6,}"
                       title="Ít nhất 6 ký tự và có ít nhất một ký tự đặc biệt" required><br>

                <label for="fullName">Full Name:</label>
                <input type="text" id="fullName" name="fullName" required><br>

                <label for="email">Email:</label>
                <input type="email" id="email" name="email"
                       pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
                       title="Email phải đúng định dạng như example@gmail.com" required><br>

                <label for="phone">Phone Number:</label>
                <input type="text" id="phone" name="phone" pattern="\d{10,11}"
                       title="Số điện thoại phải từ 10 đến 11 chữ số" required>

                <label for="address">Address:</label>
                <input type="text" id="address" name="address" minlength="5" required><br>

                <button type="submit">Đăng Ký</button>
            </form>

            <script>
                function validateForm() {
                    var password = document.getElementById("password").value;
                    var specialCharRegex = /[!@#$%^&*(),.?":{}|<>]/;
                    if (!specialCharRegex.test(password)) {
                        alert("Mật khẩu phải chứa ít nhất một ký tự đặc biệt.");
                        return false;
                    }
                    return true;
                }
            </script>

            <p>Đã có tài khoản? <a href="login.jsp">Đăng nhập</a></p>
        </div>
                </div>
            </div>
            <div class="hero-slider owl-carousel">
                <div class="hs-item set-bg" data-setbg="img/hero/hero-1.jpg"></div>
                <div class="hs-item set-bg" data-setbg="img/hero/hero-2.jpg"></div>
                <div class="hs-item set-bg" data-setbg="img/hero/hero-3.jpg"></div>
            </div>
        </section>
        <!-- Hero Section End -->

       

        <!-- Footer Section Begin -->
        <footer class="footer-section">
            <div class="container">
                <div class="footer-text">
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="ft-about">
                                <div class="logo">
                                    <a href="#">
                                        <img src="img/footer-logo.png" alt="">
                                    </a>
                                </div>
                                <p>We inspire and reach millions of travelers<br /> across 90 local websites</p>
                                <div class="fa-social">
                                    <a href="#"><i class="fa fa-facebook"></i></a>
                                    <a href="#"><i class="fa fa-twitter"></i></a>
                                    <a href="#"><i class="fa fa-tripadvisor"></i></a>
                                    <a href="#"><i class="fa fa-instagram"></i></a>
                                    <a href="#"><i class="fa fa-youtube-play"></i></a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 offset-lg-1">
                            <div class="ft-contact">
                                <h6>Contact Us</h6>
                                <ul>
                                    <li>(12) 345 67890</li>
                                    <li>info.colorlib@gmail.com</li>
                                    <li>856 Cordia Extension Apt. 356, Lake, United State</li>
                                </ul>
                            </div>
                        </div>
                        <div class="col-lg-3 offset-lg-1">
                            <div class="ft-newslatter">
                                <h6>New latest</h6>
                                <p>Get the latest updates and offers.</p>
                                <form action="#" class="fn-form">
                                    <input type="text" placeholder="Email">
                                    <button type="submit"><i class="fa fa-send"></i></button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="copyright-option">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-7">
                            <ul>
                                <li><a href="#">Contact</a></li>
                                <li><a href="#">Terms of use</a></li>
                                <li><a href="#">Privacy</a></li>
                                <li><a href="#">Environmental Policy</a></li>
                            </ul>
                        </div>
                        <div class="col-lg-5">
                            <div class="co-text"><p><!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
                                    Copyright &copy;<script>document.write(new Date().getFullYear());</script> Made by Group 3
                                    <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. --></p></div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
        <!-- Footer Section End -->

        <!-- Search model Begin -->
        <div class="search-model">
            <div class="h-100 d-flex align-items-center justify-content-center">
                <div class="search-close-switch"><i class="icon_close"></i></div>
                <form class="search-model-form">
                    <input type="text" id="search-input" placeholder="Search here.....">
                </form>
            </div>
        </div>
        <!-- Search model end -->

        <!-- Js Plugins -->
        <script src="js/jquery-3.3.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery.magnific-popup.min.js"></script>
        <script src="js/jquery.nice-select.min.js"></script>
        <script src="js/jquery-ui.min.js"></script>
        <script src="js/jquery.slicknav.js"></script>
        <script src="js/owl.carousel.min.js"></script>
        <script src="js/main.js"></script>
        <script>
                                        function loadLoginForm() {
                                            const container = document.getElementById("bookingFormContainer");
                                            container.innerHTML = '<div class="text-center">Đang tải form đăng nhập...</div>';

                                            fetch("login-form.jsp")
                                                    .then(response => response.text())
                                                    .then(html => {
                                                        container.innerHTML = html;
                                                    })
                                                    .catch(error => {
                                                        container.innerHTML = '<div class="text-danger">Không thể tải form đăng nhập.</div>';
                                                        console.error('Lỗi:', error);
                                                    });
                                        }

        </script>
    </body>

</html>