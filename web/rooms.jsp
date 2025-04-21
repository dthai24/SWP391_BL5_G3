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
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
</head>
<body>
    <%
        List<Room> rooms = (List<Room>)request.getAttribute("rooms");
    %>
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
    <div style="max-width: 100vw; margin: 32px auto;">
      <div style="background: #fff; border-radius: 12px; padding: 32px; box-shadow: 0 6px 24px rgba(0,0,0,0.13);">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h2 style="font-weight: 700; color: #2d2d2d; letter-spacing: 1px; margin-bottom: 0;">Danh Sách Phòng</h2>
          <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addRoomModal">Thêm phòng mới</button>
        </div>
        <div class="table-responsive mb-0" style="overflow-x:unset;">
            <table id="room-datatable" class="table table-hover table-striped align-middle mb-0" style="background: #fff; border-radius: 10px; overflow: visible; table-layout: auto; width: 100%;">
                <thead class="thead-dark" style="background: #343a40; color: #fff;">
                    <tr>
                        <th style="min-width:110px; white-space:nowrap;">Số phòng</th>
                        <th style="min-width:120px; white-space:nowrap;">Loại phòng (ID)</th>
                        <th style="min-width:120px; white-space:nowrap;">Trạng thái</th>
                        <th style="min-width:150px; white-space:nowrap;">Mô tả</th>
                        <th style="min-width:120px; white-space:nowrap;">Giá phòng</th>
                        <th style="min-width:140px; white-space:nowrap;">Ngày tạo</th>
                        <th style="min-width:140px; white-space:nowrap;">Ngày sửa</th>
                        <th style="min-width:110px; white-space:nowrap;">Hành động</th>
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
                            <%= room.getPriceOverride() %>$
                        </td>
                        <td><%= room.getCreatedAt() %></td>
                        <td><%= room.getUpdatedAt() %></td>
                        <td>
                            <button type="button" class="btn btn-link p-0 edit-btn"
                                data-roomid="<%= room.getRoomID() %>"
                                data-roomnumber="<%= room.getRoomNumber() %>"
                                data-categoryid="<%= room.getCategoryID() %>"
                                data-vacancystatus="<%= room.getVacancyStatus() %>"
                                data-description="<%= room.getDescription() %>"
                                data-priceoverride="<%= room.getPriceOverride() %>"
                                data-toggle="modal" data-target="#editRoomModal"
                                title="Edit">
                                <i class="fa fa-edit" style="color: #ffc107; font-size: 1.2rem;"></i>
                            </button>
                            <form method="post" action="room" class="d-inline delete-room-form" style="display:inline;">
                                <input type="hidden" name="deleteRoomID" value="<%= room.getRoomID() %>" />
                                <button type="submit" class="btn btn-link p-0 delete-btn" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa phòng này?');">
                                    <i class="fa fa-trash" style="color: #dc3545; font-size: 1.2rem;"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%  } 
                    } else { %>
                    <tr><td colspan="8" class="text-center">Không có phòng nào.</td></tr>
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
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
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

        $('#room-datatable').DataTable({
            responsive: true,
            paging: true,
            ordering: true,
            info: true,
            columnDefs: [
                { orderable: false, targets: -1 } // Disable sort for last column (Action)
            ],
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
            }
        });

        // Validate RoomNumber chỉ chứa số và không trùng nhau 
        var existingRoomNumbers = [];
        $("#room-datatable tbody tr").each(function() {
            var roomNumber = $(this).find("td").eq(0).text().trim();
            if(roomNumber) existingRoomNumbers.push(roomNumber);
        });
        $("#addRoomModal form").on("submit", function(e) {
            var roomNumber = $(this).find('[name="roomNumber"]').val().trim();
            if (!/^\d+$/.test(roomNumber)) {
                alert("Số phòng chỉ được chứa các số.");
                $(this).find('[name="roomNumber"]').focus();
                e.preventDefault();
                return false;
            }
            if (existingRoomNumbers.includes(roomNumber)) {
                alert("Số phòng đã tồn tại.");
                $(this).find('[name="roomNumber"]').focus();
                e.preventDefault();
                return false;
            }
        });
    });
    </script>
</body>
</html>
