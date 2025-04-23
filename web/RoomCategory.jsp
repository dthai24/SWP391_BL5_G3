<%@ page import="java.util.List" %>
<%@ page import="Model.RoomCategory" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Category List</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
    <%@ include file="/View/Common/header.jsp" %>
    <style>
        .table-responsive { overflow-x: auto !important; }
        #category-datatable { min-width: 900px !important; table-layout: fixed; }
        #category-datatable th, #category-datatable td { white-space: normal !important; word-break: break-word !important; vertical-align: middle; }
        #category-datatable td.description-col { max-width: 180px; overflow-wrap: break-word; }
        #category-datatable td { max-width: 160px; }
    </style>
</head>
<body>
<div class="wrapper">
    <%@ include file="/View/Common/sidebar.jsp" %>
    <div class="main">
        <%@ include file="/View/Common/navbar.jsp" %>
        <main class="content">
            <% List<RoomCategory> categories = (List<RoomCategory>)request.getAttribute("categories"); %>
            <!-- Modal for Add Category -->
            <div class="modal fade" id="addCategoryModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                  <form action="roomcategory" method="post">
                    <div class="modal-header">
                      <h5 class="modal-title" id="addCategoryModalLabel">Thêm loại phòng mới</h5>
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                    </div>
                    <div class="modal-body">
                      <div class="form-group">
                        <label>Tên loại phòng</label>
                        <input type="text" name="categoryName" class="form-control" required />
                      </div>
                      <div class="form-group">
                        <label>Mô tả</label>
                        <input type="text" name="description" class="form-control" />
                      </div>
                      <div class="form-group">
                        <label>Giá gốc/đêm</label>
                        <input type="number" name="basePricePerNight" class="form-control" required />
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
                        <h3 class="mb-0">Danh Sách Loại Phòng</h3>
                        <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addCategoryModal">
                            <i class="fa fa-plus"></i> Thêm Loại Phòng Mới
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive" style="overflow-x:auto;">
                            <table id="category-datatable" class="table table-hover table-striped align-middle mb-0" style="width:100%; table-layout:fixed; font-size: 15px;">
                                <thead class="thead-dark">
                                    <tr>
                                        <th style="max-width:60px;">ID</th>
                                        <th style="max-width:120px;">Tên loại phòng</th>
                                        <th style="max-width:180px;">Mô tả</th>
                                        <th style="max-width:120px;">Giá gốc/đêm</th>
                                        <th style="max-width:120px;">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (categories != null && !categories.isEmpty()) {
                                        for(RoomCategory cat : categories) { %>
                                    <tr>
                                        <td style="font-weight: 600; color: #007bff;"> <%= cat.getCategoryID() %> </td>
                                        <td> <%= cat.getCategoryName() %> </td>
                                        <td class="description-col"> <%= cat.getDescription() %> </td>
                                        <td style="font-weight: 600; color: #28a745;"> <%= cat.getBasePricePerNight() %>$ </td>
                                        <td>
                                            <button type="button" class="btn btn-link p-0 view-btn" 
                                                data-categoryid="<%= cat.getCategoryID() %>"
                                                data-categoryname="<%= cat.getCategoryName() %>"
                                                data-description="<%= cat.getDescription() %>"
                                                data-baseprice="<%= cat.getBasePricePerNight() %>"
                                                data-isdeleted="<%= cat.getIsDeleted() %>"
                                                data-toggle="modal" data-target="#viewCategoryModal"
                                                title="Xem chi tiết">
                                                <i class="fa fa-eye" style="color: #17a2b8; font-size: 1.2rem;"></i>
                                            </button>
                                            <button type="button" class="btn btn-link p-0 edit-btn"
                                                data-categoryid="<%= cat.getCategoryID() %>"
                                                data-categoryname="<%= cat.getCategoryName() %>"
                                                data-description="<%= cat.getDescription() %>"
                                                data-baseprice="<%= cat.getBasePricePerNight() %>"
                                                data-toggle="modal" data-target="#editCategoryModal"
                                                title="Edit">
                                                <i class="fa fa-edit" style="color: #ffc107; font-size: 1.2rem;"></i>
                                            </button>
                                            <form method="post" action="roomcategory" class="d-inline delete-category-form" style="display:inline;">
                                                <input type="hidden" name="deleteCategoryID" value="<%= cat.getCategoryID() %>" />
                                                <button type="submit" class="btn btn-link p-0 delete-btn" title="Xóa" onclick="return confirm('Bạn có chắc chắn muốn xóa loại phòng này?');">
                                                    <i class="fa fa-trash" style="color: #dc3545; font-size: 1.2rem;"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <%  } 
                                    } else { %>
                                    <tr><td colspan="5" class="text-center">Không có loại phòng nào.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Modal for Edit Category -->
            <div class="modal fade" id="editCategoryModal" tabindex="-1" role="dialog" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                  <form action="roomcategory" method="post">
                    <div class="modal-header">
                      <h5 class="modal-title" id="editCategoryModalLabel">Cập nhật loại phòng</h5>
                      <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                    </div>
                    <div class="modal-body">
                      <input type="hidden" name="categoryID" id="edit-categoryID" />
                      <div class="form-group">
                        <label>Tên loại phòng</label>
                        <input type="text" name="categoryName" id="edit-categoryName" class="form-control" required />
                      </div>
                      <div class="form-group">
                        <label>Mô tả</label>
                        <input type="text" name="description" id="edit-description" class="form-control" />
                      </div>
                      <div class="form-group">
                        <label>Giá gốc/đêm</label>
                        <input type="number" name="basePricePerNight" id="edit-basePrice" class="form-control" required />
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
            <!-- Modal for View Category -->
            <div class="modal fade" id="viewCategoryModal" tabindex="-1" role="dialog" aria-labelledby="viewCategoryModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                  <div class="card shadow-sm m-0">
                    <div class="card-header thead-dark text-white d-flex justify-content-between align-items-center" style="background: #343a40;">
                      <h5 class="mb-0">Loại phòng <span id="view-categoryName"></span></h5>
                      <button type="button" class="btn btn-sm btn-light" data-dismiss="modal">
                        <span style="font-weight:bold; color:#222;">X</span> Đóng
                      </button>
                    </div>
                    <div class="card-body">
                      <div class="row g-4">
                        <div class="col-md-12">
                          <div class="card mb-3">
                            <div class="card-header bg-light">
                              <h6 class="mb-0">Thông tin loại phòng</h6>
                            </div>
                            <div class="card-body">
                              <div class="row mb-2">
                                <div class="col-md-4 font-weight-bold">ID:</div>
                                <div class="col-md-8"><span id="view-categoryID"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-4 font-weight-bold">Tên loại phòng:</div>
                                <div class="col-md-8"><span id="view-categoryName-info"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-4 font-weight-bold">Mô tả:</div>
                                <div class="col-md-8"><span id="view-description"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-4 font-weight-bold">Giá gốc/đêm:</div>
                                <div class="col-md-8"><span id="view-basePrice"></span></div>
                              </div>
                              <div class="row mb-2">
                                <div class="col-md-4 font-weight-bold">Trạng thái:</div>
                                <div class="col-md-8"><span id="view-isDeleted"></span></div>
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
                // Thêm loại phòng
                $("#addCategoryModal form").on("submit", function(e) {
                    var name = $(this).find('[name="categoryName"]').val();
                    if (!name || name.trim() === "") {
                        alert("Tên loại phòng không được để trống.");
                        $(this).find('[name="categoryName"]').focus();
                        e.preventDefault();
                        return false;
                    }
                });
                // Khi mở modal sửa
                $('.edit-btn').click(function(){
                    $('#edit-categoryID').val($(this).data('categoryid'));
                    $('#edit-categoryName').val($(this).data('categoryname'));
                    $('#edit-description').val($(this).data('description'));
                    $('#edit-basePrice').val($(this).data('baseprice'));
                });
                // Khi mở modal xem
                $('.view-btn').click(function(){
                    $('#view-categoryID').text($(this).data('categoryid'));
                    $('#view-categoryName').text($(this).data('categoryname'));
                    $('#view-categoryName-info').text($(this).data('categoryname'));
                    $('#view-description').text($(this).data('description'));
                    $('#view-basePrice').text($(this).data('baseprice'));
                    var isDeleted = $(this).data('isdeleted') === true || $(this).data('isdeleted') === 'true';
                    var statusHtml = isDeleted ? '<span class="badge badge-danger">Đã xóa</span>' : '<span class="badge badge-success">Hoạt động</span>';
                    $('#view-isDeleted').html(statusHtml);
                });
                $('#category-datatable').DataTable({
                    responsive: true,
                    paging: true,
                    ordering: true,
                    info: true,
                    columnDefs: [
                        { orderable: false, targets: -1 }
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
