<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
<%@include file="header.jsp" %>
<!-- Breadcrumb Section Begin -->
<div class="breadcrumb-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb-text">
                    <h2>Giới thiệu</h2>
                    <div class="bt-option">
                        <a href="homepage.jsp">Trang chủ</a>
                        <span>Giới thiệu</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb Section End -->

<!-- About Us Page Section Begin -->
<section class="aboutus-page-section spad">
    <div class="container">
        <div class="about-page-text">
            <div class="row">
                <div class="col-lg-6">
                    <div class="ap-title">
                        <h2>Chào mừng đến với Sona.</h2>
                        <p>Tại Sona.com, chúng tôi tin rằng mỗi hành trình đều xứng đáng được khởi đầu bằng những trải nghiệm lưu trú hoàn hảo. Với sứ mệnh kết nối du khách với hàng ngàn khách sạn hàng đầu trong và ngoài nước, Sona.com mang đến nền tảng đặt phòng nhanh chóng, an toàn và ưu đãi vượt trội.

Chúng tôi không ngừng cập nhật đa dạng lựa chọn phòng từ khách sạn boutique tinh tế, resort 5 sao đẳng cấp đến những homestay độc đáo, giúp bạn dễ dàng tìm thấy nơi nghỉ lý tưởng cho mỗi chuyến đi. Đội ngũ tư vấn tận tâm và dịch vụ chăm sóc khách hàng 24/7 luôn sẵn sàng hỗ trợ bạn từ những bước đầu tiên đến khi hoàn tất hành trình.

Với Sona.com, mỗi chuyến đi không chỉ là hành trình khám phá mà còn là trải nghiệm đáng nhớ được chăm chút từ từng chi tiết nhỏ nhất.</p>
                    </div>
                </div>
                <div class="col-lg-5 offset-lg-1">
                    <ul class="ap-services">
                        <li><i class="icon_check"></i> Giảm giá 20% cho chỗ ở.</li>
                        <li><i class="icon_check"></i> Bữa sáng miễn phí hàng ngàyt</li>
                        <li><i class="icon_check"></i> Wifi miễn phí.</li>
                      
                    </ul>
                </div>
            </div>
        </div>
        <div class="about-page-services">
            <div class="row">
                <div class="col-md-4">
                    <div class="ap-service-item set-bg" data-setbg="<%= request.getContextPath() %>/img/about/about-p1.jpg">
                        <div class="api-text">
                            <h3>Restaurants Services</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="ap-service-item set-bg" data-setbg="<%= request.getContextPath() %>/img/about/about-p2.jpg">
                        <div class="api-text">
                            <h3>Travel &amp; Camping</h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="ap-service-item set-bg" data-setbg="<%= request.getContextPath() %>/img/about/about-p3.jpg">
                        <div class="api-text">
                            <h3>Event &amp; Party</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- About Us Page Section End -->

<!-- Video Section Begin -->
<section class="video-section set-bg" data-setbg="<%= request.getContextPath() %>/img/video-bg.jpg">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="video-text">
                    <h2>Discover Our Hotel &amp; Services.</h2>
                    <p>It S Hurricane Season But We Are Visiting Hilton Head Island</p>
                    <a href="https://www.youtube.com/watch?v=EzKkl64rRbM" class="play-btn video-popup"><img
                            src="<%= request.getContextPath() %>/img/play.png" alt=""></a>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Video Section End -->

<!-- Gallery Section Begin -->
<section class="gallery-section spad">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="section-title">
                    <span>Phòng Trưng bày</span>
                   
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-6">
                <div class="gallery-item set-bg" data-setbg="<%= request.getContextPath() %>/img/gallery/gallery-1.jpg">
                    <div class="gi-text">
                        <h3>Room Luxury</h3>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="gallery-item set-bg" data-setbg="<%= request.getContextPath() %>/img/gallery/gallery-3.jpg">
                            <div class="gi-text">
                                <h3>Room Luxury</h3>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="gallery-item set-bg" data-setbg="<%= request.getContextPath() %>/img/gallery/gallery-4.jpg">
                            <div class="gi-text">
                                <h3>Room Luxury</h3>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="gallery-item large-item set-bg" data-setbg="<%= request.getContextPath() %>/img/gallery/gallery-2.jpg">
                    <div class="gi-text">
                        <h3>Room Luxury</h3>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Gallery Section End -->

<!-- Footer Section Begin -->
<footer class="footer-section">
    <div class="container">
        <div class="footer-text">
            <div class="row">
                <div class="col-lg-4">
                    <div class="ft-about">
                        <div class="logo">
                            <a href="#">
                                <img src="<%= request.getContextPath() %>/img/footer-logo.png" alt="">
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
  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
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
<script src="<%= request.getContextPath() %>/js/jquery-3.3.1.min.js"></script>
<script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
<script src="<%= request.getContextPath() %>/js/jquery.magnific-popup.min.js"></script>
<script src="<%= request.getContextPath() %>/js/jquery.nice-select.min.js"></script>
<script src="<%= request.getContextPath() %>/js/jquery-ui.min.js"></script>
<script src="<%= request.getContextPath() %>/js/jquery.slicknav.js"></script>
<script src ="<%= request.getContextPath() %>/js/owl.carousel.min.js"></script>
<script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>