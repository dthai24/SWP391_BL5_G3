<%@ page import="java.util.List" %>
<%@ page import="Model.Room" %>
<%@ page import="Dal.RoomDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room List</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
</head>
<body>
    <%
        List<Room> rooms = (List<Room>)request.getAttribute("rooms");
    %>
    <div class="container mt-4">
        <button type="button" class="btn btn-success mb-3" data-toggle="modal" data-target="#addRoomModal">Thêm phòng mới</button>
    </div>
    <!-- Modal for Add Room -->
    <div class="modal fade" id="addRoomModal" tabindex="-1" role="dialog" aria-labelledby="addRoomModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <form action="room" method="post">
            <div class="modal-header">
              <h5 class="modal-title" id="addRoomModalLabel">Thêm phòng mới</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label>Số phòng</label>
                <input type="text" name="roomNumber" class="form-control" required />
              </div>
              <div class="form-group">
                <label>Loại phòng (CategoryID)</label>
                <input type="number" name="categoryID" class="form-control" required />
              </div>
              <div class="form-group">
                <label>Trạng thái</label>
                <select name="vacancyStatus" class="form-control">
                  <option value="Vacant">Vacant</option>
                  <option value="Occupied">Occupied</option>
                </select>
              </div>
              <div class="form-group">
                <label>Mô tả</label>
                <input type="text" name="description" class="form-control" />
              </div>
              <div class="form-group">
                <label>Giá phòng</label>
                <input type="number" name="priceOverride" class="form-control" required />
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
              <button type="submit" class="btn btn-primary">Thêm mới</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <div style="max-width: 1100px; margin: 32px auto;">
      <div style="background: #fff; border-radius: 12px; padding: 32px; box-shadow: 0 6px 24px rgba(0,0,0,0.13);">
        <h2 class="mb-4" style="font-weight: 700; color: #2d2d2d; letter-spacing: 1px;">Danh Sách Phòng</h2>
        <div class="table-responsive mb-0">
            <table class="table table-hover table-striped align-middle mb-0" style="background: #fff; border-radius: 10px; overflow: hidden;">
                <thead class="thead-dark" style="background: #343a40; color: #fff;">
                    <tr>
                        <th style="min-width:110px;">Room Number</th>
                        <th style="min-width:120px;">Category ID</th>
                        <th style="min-width:120px;">Vacancy Status</th>
                        <th>Description</th>
                        <th style="min-width:120px;">Price Override</th>
                        <th style="min-width:110px;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (rooms != null && !rooms.isEmpty()) {
                        for(Room room : rooms) { %>
                    <tr>
                        <td style="font-weight: 600; color: #007bff;"><%= room.getRoomNumber() %></td>
                        <td><%= room.getCategoryID() %></td>
                        <td>
                            <% if ("Vacant".equals(room.getVacancyStatus())) { %>
                                <span class="badge badge-success">Vacant</span>
                            <% } else { %>
                                <span class="badge badge-danger">Occupied</span>
                            <% } %>
                        </td>
                        <td><%= room.getDescription() %></td>
                        <td style="font-weight: 600; color: #28a745;">
                            <%= room.getPriceOverride() %>₫
                        </td>
                        <td>
                            <button type="button" class="btn btn-warning btn-sm edit-btn"
                                data-roomid="<%= room.getRoomID() %>"
                                data-roomnumber="<%= room.getRoomNumber() %>"
                                data-categoryid="<%= room.getCategoryID() %>"
                                data-vacancystatus="<%= room.getVacancyStatus() %>"
                                data-description="<%= room.getDescription() %>"
                                data-priceoverride="<%= room.getPriceOverride() %>"
                                data-toggle="modal" data-target="#editRoomModal">
                                <i class="fa fa-pencil"></i> Edit
                            </button>
                        </td>
                    </tr>
                    <%  } 
                    } else { %>
                    <tr><td colspan="6" class="text-center">Không có phòng nào.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
      </div>
    </div>
    <!-- Modal for Edit Room -->
    <div class="modal fade" id="editRoomModal" tabindex="-1" role="dialog" aria-labelledby="editRoomModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <form action="room" method="post">
            <div class="modal-header">
              <h5 class="modal-title" id="editRoomModalLabel">Cập nhật phòng</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <input type="hidden" name="roomID" id="edit-roomID" />
              <div class="form-group">
                <label>Số phòng</label>
                <input type="text" name="roomNumber" id="edit-roomNumber" class="form-control" required />
              </div>
              <div class="form-group">
                <label>Loại phòng (CategoryID)</label>
                <input type="number" name="categoryID" id="edit-categoryID" class="form-control" required />
              </div>
              <div class="form-group">
                <label>Trạng thái</label>
                <select name="vacancyStatus" id="edit-vacancyStatus" class="form-control">
                  <option value="Vacant">Vacant</option>
                  <option value="Occupied">Occupied</option>
                </select>
              </div>
              <div class="form-group">
                <label>Mô tả</label>
                <input type="text" name="description" id="edit-description" class="form-control" />
              </div>
              <div class="form-group">
                <label>Giá phòng</label>
                <input type="number" name="priceOverride" id="edit-priceOverride" class="form-control" required />
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
              <button type="submit" class="btn btn-primary">Cập nhật</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <script src="js/jquery-3.3.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script>
    $(document).ready(function(){
        $('.edit-btn').click(function(){
            $('#edit-roomID').val($(this).data('roomid'));
            $('#edit-roomNumber').val($(this).data('roomnumber'));
            $('#edit-categoryID').val($(this).data('categoryid'));
            $('#edit-vacancyStatus').val($(this).data('vacancystatus'));
            $('#edit-description').val($(this).data('description'));
            $('#edit-priceOverride').val($(this).data('priceoverride'));
        });
    });
    </script>
</body>
</html>
