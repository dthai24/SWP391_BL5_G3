<%@ page import="java.util.List" %>
<%@ page import="Model.Room" %>
<%@ page import="Dal.RoomDAO" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room List</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
    <%@ include file="/View/Common/header.jsp" %>
    <style>
        .room-status {
            font-weight: bold;
            padding: 5px 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .status-vacant { background-color: #28A745; color: #fff; }
        .status-occupied { background-color: #DC3545; color: #fff; }
        .info-label { font-weight: 600; }
        .table-responsive {
            overflow-x: auto !important;
        }
        #room-datatable {
            min-width: 900px !important;
            table-layout: fixed;
        }
        #room-datatable th, #room-datatable td {
            white-space: normal !important;
            word-break: break-word !important;
            vertical-align: middle;
        }
        #room-datatable td.description-col,
        #room-datatable td.category-col {
            max-width: 180px;
            overflow-wrap: break-word;
        }
        #room-datatable td {
            max-width: 160px;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="/View/Common/sidebar.jsp" %>
    <div class="main">
        <%@ include file="/View/Common/navbar.jsp" %>
        <main class="content">
            <%
                List<Room> rooms = (List<Room>)request.getAttribute("rooms");
                Map<Integer, Model.RoomCategory> catMap = (Map<Integer, Model.RoomCategory>)request.getAttribute("roomCategoryMap");
                List<Model.RoomCategory> allCategories = (List<Model.RoomCategory>)request.getAttribute("allCategories");
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
                        <div id="add-roomNumber-error" style="color:red;font-size:14px;margin-top:4px;"></div>
                      </div>
                      <div class="form-group">
                        <label>Loại phòng</label>
                        <select name="categoryID" class="form-control" required>
                          <% if (allCategories != null) {
                               for (Model.RoomCategory cat : allCategories) { %>
                                 <option value="<%= cat.getCategoryID() %>"><%= cat.getCategoryName() %></option>
                          <%   }
                             } %>
                        </select>
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
            <div class="container mt-5">
                <div class="card shadow-lg">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center" style="border-bottom: 1px solid #dee2e6;">
                        <h3 class="mb-0">Danh Sách Phòng</h3>
                        <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addRoomModal">
                            <i class="fa fa-plus"></i> Thêm Phòng Mới
                        </button>
                    </div>
                    <div class="card-body">
                        <!-- Filter form -->
                        <form method="get" action="room" class="form-inline mb-3" id="room-filter-form">
                          <div class="form-group mr-2">
                            <label for="filterCategory" class="mr-2">Loại phòng</label>
                            <select name="filterCategory" id="filterCategory" class="form-control">
                              <option value="">Tất cả</option>
                              <% if (allCategories != null) {
                                   for (Model.RoomCategory cat : allCategories) { %>
                                     <option value="<%= cat.getCategoryID() %>" <%= request.getParameter("filterCategory") != null && request.getParameter("filterCategory").equals(String.valueOf(cat.getCategoryID())) ? "selected" : "" %>><%= cat.getCategoryName() %></option>
                              <%   }
                                 } %>
                            </select>
                          </div>
                          <div class="form-group mr-2">
                            <label for="filterStatus" class="mr-2">Trạng thái</label>
                            <select name="filterStatus" id="filterStatus" class="form-control">
                              <option value="">Tất cả</option>
                              <option value="Vacant" <%= "Vacant".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Vacant</option>
                              <option value="Occupied" <%= "Occupied".equals(request.getParameter("filterStatus")) ? "selected" : "" %>>Occupied</option>
                            </select>
                          </div>
                          <button type="submit" class="btn btn-primary mr-2">Lọc</button>
                          <a href="room" class="btn btn-secondary">Hủy</a>
                        </form>
                        <!-- End filter form -->
                        <div class="table-responsive" style="overflow-x:auto;">
                            <table id="room-datatable" class="table table-hover table-striped align-middle mb-0" style="width:100%; table-layout:fixed; font-size: 15px;">
                                <thead class="thead-dark">
                                    <tr>
                                        <th style="white-space:normal; word-break:break-word; max-width:90px;">Số phòng</th>
                                        <th style="white-space:normal; word-break:break-word; max-width:120px;">Loại phòng</th>
                                        <th style="white-space:normal; word-break:break-word; max-width:90px;">Trạng thái</th>
                                        <th style="white-space:normal; word-break:break-word; max-width:180px;">Mô tả</th>
                                        <th style="white-space:normal; word-break:break-word; max-width:120px;">Giá phòng</th>
                                        <th style="white-space:normal; word-break:break-word; max-width:120px;">Ngày tạo</th>
                                        <th style="white-space:normal; word-break:break-word; max-width:120px;">Ngày sửa</th>
                                        <th style="white-space:normal; word-break:break-word; max-width:100px;">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (rooms != null && !rooms.isEmpty()) {
                                        for(Room room : rooms) { %>
                                    <tr>
                                        <td style="font-weight: 600; color: #007bff;"> <%= room.getRoomNumber() %> </td>
                                        <td class="category-col">
                                            <%= catMap.get(room.getCategoryID()) != null ? catMap.get(room.getCategoryID()).getCategoryName() : "" %>
                                        </td>
                                        <td>
                                            <% if ("Vacant".equals(room.getVacancyStatus())) { %>
                                                <span class="badge badge-success">Vacant</span>
                                            <% } else { %>
                                                <span class="badge badge-danger">Occupied</span>
                                            <% } %>
                                        </td>
                                        <td class="description-col"><%= room.getDescription() %></td>
                                        <td style="font-weight: 600; color: #28a745;">
                                            <%= room.getPriceOverride() %>$
                                        </td>
                                        <td><%= room.getCreatedAt() %></td>
                                        <td><%= room.getUpdatedAt() %></td>
                                        <td>
                                            <button type="button" class="btn btn-link p-0 view-btn" 
                                                data-roomid="<%= room.getRoomID() %>"
                                                data-roomnumber="<%= room.getRoomNumber() %>"
                                                data-categoryid="<%= room.getCategoryID() %>"
                                                data-vacancystatus="<%= room.getVacancyStatus() %>"
                                                data-description="<%= room.getDescription() %>"
                                                data-priceoverride="<%= room.getPriceOverride() %>"
                                                data-createdat="<%= room.getCreatedAt() %>"
                                                data-updatedat="<%= room.getUpdatedAt() %>"
                                                data-categoryname="<%= catMap.get(room.getCategoryID()) != null ? catMap.get(room.getCategoryID()).getCategoryName() : "" %>"
                                                data-categorydesc="<%= catMap.get(room.getCategoryID()) != null ? catMap.get(room.getCategoryID()).getDescription() : "" %>"
                                                data-categorybaseprice="<%= catMap.get(room.getCategoryID()) != null ? catMap.get(room.getCategoryID()).getBasePricePerNight() : "" %>"
                                                data-toggle="modal" data-target="#viewRoomModal"
                                                title="Xem chi tiết">
                                                <i class="fa fa-eye" style="color: #17a2b8; font-size: 1.2rem;"></i>
                                            </button>
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
                        <div id="edit-roomNumber-error" style="color:red;font-size:14px;margin-top:4px;"></div>
                      </div>
                      <div class="form-group">
                        <label>Loại phòng</label>
                        <select name="categoryID" id="edit-categoryID" class="form-control" required>
                          <% if (allCategories != null) {
                               for (Model.RoomCategory cat : allCategories) { %>
                                 <option value="<%= cat.getCategoryID() %>"><%= cat.getCategoryName() %></option>
                          <%   }
                             } %>
                        </select>
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
            <!-- Modal for View Room -->
            <div class="modal fade" id="viewRoomModal" tabindex="-1" role="dialog" aria-labelledby="viewRoomModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                  <div class="card shadow-sm m-0">
                    <div class="card-header thead-dark text-white d-flex justify-content-between align-items-center" style="background: #343a40;">
                      <h5 class="mb-0">Phòng <span id="view-roomNumber"></span></h5>
                      <button type="button" class="btn btn-sm btn-light" data-dismiss="modal">
                        <span style="font-weight:bold; color:#222;">X</span> Đóng
                      </button>
                    </div>
                    <div class="card-body">
                      <div class="row g-4">
                        <!-- Left Column: Room Info -->
                        <div class="col-md-6">
                          <div class="card mb-3">
                            <div class="card-header bg-light">
                              <h6 class="mb-0">Thông tin phòng</h6>
                            </div>
                            <div class="card-body">
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Số phòng:</div>
                                <div class="col-md-7"><span id="view-roomNumber-info"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Trạng thái:</div>
                                <div class="col-md-7"><span id="view-vacancyStatus-info"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Mô tả:</div>
                                <div class="col-md-7"><span id="view-description"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Giá phòng:</div>
                                <div class="col-md-7"><span id="view-priceOverride"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Ngày tạo:</div>
                                <div class="col-md-7"><span id="view-createdAt"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Ngày sửa:</div>
                                <div class="col-md-7"><span id="view-updatedAt"></span></div>
                              </div>
                            </div>
                          </div>
                        </div>
                        <!-- Right Column: Room Category Info -->
                        <div class="col-md-6">
                          <div class="card mb-3">
                            <div class="card-header bg-light">
                              <h6 class="mb-0">Thông tin loại phòng</h6>
                            </div>
                            <div class="card-body">
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Tên loại phòng:</div>
                                <div class="col-md-7"><span id="view-categoryName"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Mô tả loại phòng:</div>
                                <div class="col-md-7"><span id="view-categoryDesc"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-5 info-label">Giá gốc/đêm:</div>
                                <div class="col-md-7"><span id="view-categoryBasePrice"></span></div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
            <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
            <script>
            $(document).ready(function(){
                // Validate RoomNumber chỉ chứa số, không khoảng trắng, không trùng nhau, không để trống
                var existingRoomNumbers = [];
                $("#room-datatable tbody tr").each(function() {
                    var roomNumber = $(this).find("td").eq(0).text().trim();
                    if(roomNumber) existingRoomNumbers.push(roomNumber);
                });
                // Thêm phòng
                $("#addRoomModal form").on("submit", function(e) {
                    var roomNumber = $(this).find('[name="roomNumber"]').val();
                    var errorDiv = $('#add-roomNumber-error');
                    errorDiv.text("");
                    if (!roomNumber || roomNumber.trim() === "") {
                        errorDiv.text("Số phòng không được để trống.");
                        $(this).find('[name="roomNumber"]').focus();
                        e.preventDefault();
                        return false;
                    }
                    if (/\s/.test(roomNumber)) {
                        errorDiv.text("Số phòng không được chứa khoảng trắng.");
                        $(this).find('[name="roomNumber"]').focus();
                        e.preventDefault();
                        return false;
                    }
                    if (!/^\d+$/.test(roomNumber)) {
                        errorDiv.text("Số phòng chỉ được chứa các số.");
                        $(this).find('[name="roomNumber"]').focus();
                        e.preventDefault();
                        return false;
                    }
                    if (existingRoomNumbers.includes(roomNumber)) {
                        errorDiv.text("Số phòng đã tồn tại.");
                        $(this).find('[name="roomNumber"]').focus();
                        e.preventDefault();
                        return false;
                    }
                });
                //Sửa phòng (lưu số phòng cũ vào data-old)
                $('.edit-btn').click(function(){
                    $('#edit-roomID').val($(this).data('roomid'));
                    $('#edit-roomNumber').val($(this).data('roomnumber'));
                    $('#edit-roomNumber').data('old', $(this).data('roomnumber'));
                    $('#edit-categoryID').val($(this).data('categoryid'));
                    $('#edit-vacancyStatus').val($(this).data('vacancystatus'));
                    $('#edit-description').val($(this).data('description'));
                    $('#edit-priceOverride').val($(this).data('priceoverride'));
                    $('#edit-roomNumber-error').text(''); // Clear error when open modal
                });

                // Validate khi submit form edit
                $('#editRoomModal form').on('submit', function(e) {
                    var roomNumber = $('#edit-roomNumber').val();
                    var oldRoomNumber = $('#edit-roomNumber').data('old');
                    var errorDiv = $('#edit-roomNumber-error');
                    errorDiv.text('');

                    // 1. Không để trống
                    if (!roomNumber || roomNumber.trim() === "") {
                        errorDiv.text("Số phòng không được để trống.");
                        $('#edit-roomNumber').focus();
                        e.preventDefault();
                        return false;
                    }
                    // 2. Không chứa khoảng trắng
                    if (/\s/.test(roomNumber)) {
                        errorDiv.text("Số phòng không được chứa khoảng trắng.");
                        $('#edit-roomNumber').focus();
                        e.preventDefault();
                        return false;
                    }
                    // 3. Chỉ chứa số
                    if (!/^\d+$/.test(roomNumber)) {
                        errorDiv.text("Số phòng chỉ được chứa các số.");
                        $('#edit-roomNumber').focus();
                        e.preventDefault();
                        return false;
                    }
                    // 4. Kiểm tra trùng số phòng (nếu thay đổi)
                    if (roomNumber.trim() !== String(oldRoomNumber).trim()) {
                        if (existingRoomNumbers.includes(roomNumber)) {
                            errorDiv.text("Số phòng đã tồn tại.");
                            $('#edit-roomNumber').focus();
                            e.preventDefault();
                            return false;
                        }
                    }
                });

                $('.view-btn').click(function(){
                    $('#view-roomNumber').text($(this).data('roomnumber'));
                    $('#view-roomNumber-info').text($(this).data('roomnumber'));
                    var status = $(this).data('vacancystatus');
                    var statusHtml = '<span class="room-status status-' + status.toLowerCase() + '">' + status + '</span>';
                    $('#view-vacancyStatus').text(status);
                    $('#view-vacancyStatus-info').html(statusHtml);
                    $('#view-description').text($(this).data('description'));
                    $('#view-priceOverride').text($(this).data('priceoverride'));
                    $('#view-createdAt').text($(this).data('createdat'));
                    $('#view-updatedAt').text($(this).data('updatedat'));
                    $('#view-categoryName').text($(this).data('categoryname'));
                    $('#view-categoryDesc').text($(this).data('categorydesc'));
                    $('#view-categoryBasePrice').text($(this).data('categorybaseprice'));
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
            });
            </script>
        </main>
        <%@ include file="/View/Common/footer.jsp" %>
    </div>
</div>
</body>
</html>
