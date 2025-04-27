<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="Model.RoomCategory" %>
<%@page import="Dal.RoomCategoryDAO" %>
<%@include file="header.jsp" %>
<%
    String categoryIdParam = request.getParameter("categoryId");
    RoomCategory category = null;
    if (categoryIdParam != null) {
        try {
            int categoryId = Integer.parseInt(categoryIdParam);
            category = new Dal.RoomCategoryDAO().getRoomCategoryById(categoryId);
        } catch (Exception e) {
            // handle error
        }
    }
%>
<!-- Breadcrumb Section Begin -->
<div class="breadcrumb-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb-text">
                    <h2>Chi tiết phòng</h2>
                    <div class="bt-option">
                        <a href="homepage.jsp">Trang chủ</a>
                        <a href="RoomPage.jsp">Phòng</a>
                        <span>Chi tiết phòng</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb Section End -->

<!-- Room Details Section Begin -->
<section class="room-details-section spad">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 mx-auto">
                <div class="room-details-item">
                    <img src="img/room/room-<%=category != null ? category.getCategoryID() : "1"%>.jpg" alt="">
                    <div class="rd-text">
                        <div class="rd-title">
                            <h3><%=category != null ? category.getCategoryName() : "Room Not Found"%></h3>
                            <div class="rdt-right">
                                <div class="rating">
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star"></i>
                                    <i class="icon_star-half_alt"></i>
                                </div>
                                <!-- Link to booking-form.jsp with categoryId -->
                                <a href="booking-form.jsp?categoryId=<%=category != null ? category.getCategoryID() : ""%>">Đặt phòng</a>
                            </div>
                        </div>
                        <h2><%=category != null ? category.getBasePricePerNight() : "-"%>$<span>/Pernight</span></h2>
                        <table>
                            <tbody>
                                <tr>
                                    <td class="r-o">Description:</td>
                                    <td><%=category != null ? category.getDescription() : "-"%></td>
                                </tr>
                            </tbody>
                        </table>
                        <p class="f-para">Thông tin chi tiết về loại phòng sẽ được cập nhật ở đây.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- Room Details Section End -->
<%@include file="footer.jsp" %>