<%@page import="java.util.List" %>
<%@page import="Model.RoomCategory" %>
<%@include file="header.jsp" %>
<!-- Breadcrumb Section Begin -->
<div class="breadcrumb-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-12">
                <div class="breadcrumb-text">
                    <h2>Phòng</h2>
                    <div class="bt-option">
                        <a href="homepage.jsp">Trang chủ</a>
                        <span>Phòng</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Breadcrumb Section End -->

<!-- Rooms Section Begin -->
<section class="rooms-section spad">
    <div class="container">
        <div class="row">
            <% 
                List<RoomCategory> categories = (List<RoomCategory>)request.getAttribute("categories");
                if (categories != null && !categories.isEmpty()) {
                    for (RoomCategory cat : categories) {
            %>
            <div class="col-lg-4 col-md-6">
                <div class="room-item">
                    <img src="img/room/room-<%=cat.getCategoryID()%>.jpg" alt="<%=cat.getCategoryName()%>" onerror="this.onerror=null;this.src='img/room/room-1.jpg';">
                    <div class="ri-text">
                        <h4><%=cat.getCategoryName()%></h4>
                        <h3><%=cat.getBasePricePerNight()%>$<span>/Pernight</span></h3>
                        <table>
                            <tbody>
                                <tr>
                                    <td class="r-o">Description:</td>
                                    <td><%=cat.getDescription()%></td>
                                </tr>
                            </tbody>
                        </table>
                        <a href="RoomDetailsPage.jsp?categoryId=<%=cat.getCategoryID()%>" class="primary-btn">Xem thêm</a>
                    </div>
                </div>
            </div>
            <%   }
                } else { %>
            <div class="col-12 text-center">
                <p>No room categories available.</p>
            </div>
            <% } %>
        </div>
    </div>
</section>
<!-- Rooms Section End -->
<%@include file="footer.jsp" %>
