<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Model.User" %>

<!DOCTYPE html>
<html lang="zxx">

    <head>
        <meta charset="UTF-8">
        <meta name="description" content="Sona Template">
        <meta name="keywords" content="Sona, unica, creative, html">
        <meta name="viewport" content="width=1024, initial-scale=1.0">
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
            <nav class="mainmenu">
                <ul>
                    <li class="active"><a href="./homepage.jsp">Trang chủ</a></li>
                    <li><a href="./roompage">Phòng</a></li>
                    <li><a href="./about-us.jsp">Giới thiệu</a></li>
                    <li><a href="./contact.jsp">Liên hệ</a></li>
                </ul>
            </nav>
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
                                <li><i class="fa fa-phone"></i> (12) 345 67890</li>
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
<% Boolean isEmployee = (Boolean) session.getAttribute("isEmployee"); %>
<% User user = (User) session.getAttribute("user");
   if (user != null) { %>
<div class="dropdown d-inline-block">
  <a href="#" id="userDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle" style="display:inline-block;">
    <i class="fa fa-user"></i> <%= user.getFullName() %>
  </a>
  <div class="dropdown-menu dropdown-menu-right" aria-labelledby="userDropdown">
    <a class="dropdown-item" href="myprofile.jsp"><i class="fa fa-user-circle"></i> Trang cá nhân</a>
    <% if (isEmployee != null && isEmployee) { %>
    <a class="dropdown-item" href="Room.jsp"><i class="fa fa-dashboard"></i> Dash Board</a>
    <% } %>
    <div class="dropdown-divider"></div>
    <a class="dropdown-item" href="logout.jsp"><i class="fa fa-sign-out"></i> Đăng xuất</a>
  </div>
</div>
<% } else { %>
    <a href="javascript:void(0);" onclick="loadLoginForm()"><i class="fa fa-sign-in"></i> Đăng nhập</a>
<% } %>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="menu-item">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-2">
                            <div class="logo">
                                <a href="./homepage.jsp">
                                    <img src="img/logo.png" alt="">
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-10">
                            <div class="nav-menu">
                                <nav class="mainmenu">
                                    <ul>
                                        <li class="active"><a href="./index.jsp">Trang chủ</a></li>
                                        <li><a href="./roompage">Phòng</a></li>
                                        <li><a href="./about-us.jsp">Giới thiệu</a></li>
                                        <li><a href="./contact.jsp">Liên hệ</a></li>
                                    </ul>
                                </nav>
                                <div class="nav-right search-switch">
                                    <i class="icon_search"></i>
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
                    <div class="col-xl-4 col-lg-5 offset-xl-2 offset-lg-1">
                        <div id="bookingFormContainer" class="booking-form">
                            <h3>Booking Your Hotel</h3>
                            <form action="#">
                                <div class="check-date">
                                    <label for="date-in">Check In:</label>
                                    <input type="text" class="date-input" id="date-in">
                                    <i class="icon_calendar"></i>
                                </div>
                                <div class="check-date">
                                    <label for="date-out">Check Out:</label>
                                    <input type="text" class="date-input" id="date-out">
                                    <i class="icon_calendar"></i>
                                </div>
                                <div class="select-option">
                                    <label for="guest">Guests:</label>
                                    <select id="guest">
                                        <option value="">2 Adults</option>
                                        <option value="">3 Adults</option>
                                    </select>
                                </div>
                                <div class="select-option">
                                    <label for="room">Room:</label>
                                    <select id="room">
                                        <option value="">1 Room</option>
                                        <option value="">2 Room</option>
                                    </select>
                                </div>
                                <button type="submit">Check Availability</button>
                            </form>
                        </div>
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

        <!-- About Us Section Begin -->
        <section class="aboutus-section spad">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="about-text">
                            <div class="section-title">
                                <span>Giới thiệu</span>
                                <h2>Sona HaNoi <br />Westlake Hotel</h2>
                            </div>
                            <p class="f-para">
Sona.com là nền tảng đặt phòng khách sạn uy tín, kết nối bạn với hàng ngàn lựa chọn lưu trú đa dạng trên toàn quốc và quốc tế.<br><br>
Chúng tôi cam kết mang đến trải nghiệm đặt phòng nhanh chóng, giá cả minh bạch và dịch vụ hỗ trợ tận tâm.<br><br>
Với giao diện thân thiện và quy trình đặt phòng đơn giản, Sona.com giúp bạn tiết kiệm thời gian và tận hưởng chuyến đi một cách trọn vẹn nhất.
</p>
 
                            <a href="#" class="primary-btn about-btn">Xem thêm</a>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="about-pic">
                            <div class="row">
                                <div class="col-sm-6">
                                    <img src="img/about/about-1.jpg" alt="">
                                </div>
                                <div class="col-sm-6">
                                    <img src="img/about/about-2.jpg" alt="">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- About Us Section End -->

        <!-- Home Room Section Begin -->
        <section class="hp-room-section">
            <div class="container-fluid">
                <div class="hp-room-items">
                    <div class="row">
                        <div class="col-lg-3 col-md-6">
                            <div class="hp-room-item set-bg" data-setbg="img/room/room-b1.jpg">
                                <div class="hr-text">
                                    <h3>Double Room</h3>
                                    <h2>199$<span>/Pernight</span></h2>
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="r-o">Size:</td>
                                                <td>30 ft</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Capacity:</td>
                                                <td>Max persion 5</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Bed:</td>
                                                <td>King Beds</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Services:</td>
                                                <td>Wifi, Television, Bathroom,...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <a href="#" class="primary-btn">More Details</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="hp-room-item set-bg" data-setbg="img/room/room-b2.jpg">
                                <div class="hr-text">
                                    <h3>Premium King Room</h3>
                                    <h2>159$<span>/Pernight</span></h2>
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="r-o">Size:</td>
                                                <td>30 ft</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Capacity:</td>
                                                <td>Max persion 5</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Bed:</td>
                                                <td>King Beds</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Services:</td>
                                                <td>Wifi, Television, Bathroom,...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <a href="#" class="primary-btn">More Details</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="hp-room-item set-bg" data-setbg="img/room/room-b3.jpg">
                                <div class="hr-text">
                                    <h3>Deluxe Room</h3>
                                    <h2>198$<span>/Pernight</span></h2>
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="r-o">Size:</td>
                                                <td>30 ft</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Capacity:</td>
                                                <td>Max persion 5</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Bed:</td>
                                                <td>King Beds</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Services:</td>
                                                <td>Wifi, Television, Bathroom,...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <a href="#" class="primary-btn">More Details</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-6">
                            <div class="hp-room-item set-bg" data-setbg="img/room/room-b4.jpg">
                                <div class="hr-text">
                                    <h3>Family Room</h3>
                                    <h2>299$<span>/Pernight</span></h2>
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td class="r-o">Size:</td>
                                                <td>30 ft</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Capacity:</td>
                                                <td>Max persion 5</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Bed:</td>
                                                <td>King Beds</td>
                                            </tr>
                                            <tr>
                                                <td class="r-o">Services:</td>
                                                <td>Wifi, Television, Bathroom,...</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <a href="#" class="primary-btn">More Details</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Home Room Section End -->

        <!-- Testimonial Section Begin -->
        <section class="testimonial-section spad">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="section-title">
                            <span>Testimonials</span>
                            <h2>What Customers Say?</h2>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-8 offset-lg-2">
                        <div class="testimonial-slider owl-carousel">
                            <div class="ts-item">
                                <p>After a construction project took longer than expected, my husband, my daughter and I
                                    needed a place to stay for a few nights. As a Chicago resident, we know a lot about our
                                    city, neighborhood and the types of housing options available and absolutely love our
                                    vacation at Sona Hotel.</p>
                                <div class="ti-author">
                                    <div class="rating">
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star-half_alt"></i>
                                    </div>
                                    <h5> - Alexander Vasquez</h5>
                                </div>
                                <img src="img/testimonial-logo.png" alt="">
                            </div>
                            <div class="ts-item">
                                <p>After a construction project took longer than expected, my husband, my daughter and I
                                    needed a place to stay for a few nights. As a Chicago resident, we know a lot about our
                                    city, neighborhood and the types of housing options available and absolutely love our
                                    vacation at Sona Hotel.</p>
                                <div class="ti-author">
                                    <div class="rating">
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star"></i>
                                        <i class="icon_star-half_alt"></i>
                                    </div>
                                    <h5> - Alexander Vasquez</h5>
                                </div>
                                <img src="img/testimonial-logo.png" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- Testimonial Section End -->
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
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
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

    fetch("login.jsp")
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