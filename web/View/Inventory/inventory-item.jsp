<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="Model.InventoryItem" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Vật Phẩm</title>

        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
        <%@ include file="/View/Common/header.jsp" %>
        <style>
            .table-responsive {
                overflow-x: auto !important;
                }
            #inventory-item-datatable {
                min-width: 900px !important;
                table-layout: fixed;
                }
            #inventory-item-datatable th, #inventory-item-datatable td {
                white-space: normal !important;
                word-break: break-word !important;
                vertical-align: middle;
                }
            #inventory-item-datatable td.description-col {
                max-width: 180px;
                overflow-wrap: break-word;
                }
            #inventory-item-datatable td {
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
                        List<InventoryItem> items = (List<InventoryItem>) request.getAttribute("items");
                    %>
                    
                    <!-- Table Section -->
                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Vật Phẩm</h3>
                                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addInventoryItemModal">
                                    <i class="fa fa-plus"></i> Thêm Vật Phẩm
                                </button>
                            </div>

                            <div class="card-body">
                                <form class="form-inline mb-3" method="get" action="inventory-item">
                                    <div class="form-group mr-2">
                                        <label for="minPrice" class="mr-2">Giá từ:</label>
                                        <input type="number" class="form-control" id="minPrice" name="minPrice" placeholder="Min" min="0" value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>">
                                    </div>
                                    <div class="form-group mr-2">
                                        <label for="maxPrice" class="mr-2">đến</label>
                                        <input type="number" class="form-control" id="maxPrice" name="maxPrice" placeholder="Max" min="0" value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "" %>">
                                    </div>
                                    <button type="submit" class="btn btn-primary mr-2">Lọc</button>
                                    <a href="inventory-item" class="btn btn-secondary">Hủy lọc</a>
                                </form>
                                <div class="table-responsive">
                                    <table id="inventory-item-datatable" class="table table-hover table-striped align-middle">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên Vật Phẩm</th>
                                                <th>Mô Tả</th>
                                                <th>Phí Mặc Định</th>
                                                <th>Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% if (items != null && !items.isEmpty()) {
                                                for (InventoryItem item : items) { %>
                                            <tr>
                                                <td style="font-weight: 600; color: #007bff;"><%= item.getItemID() %></td>
                                                <td><%= item.getItemName() %></td>
                                                <td><%= (item.getDescription() != null && !item.getDescription().trim().isEmpty()) ? item.getDescription() : "N/A" %></td>
                                                <td style="font-weight: 600; color: #28a745;"><%= item.getDefaultCharge() %>$</td>
                                                <td>
                                                    <button type="button" class="btn btn-link p-0 view-btn" 
                                                        data-itemid="<%= item.getItemID() %>"
                                                        data-itemname="<%= item.getItemName() %>"
                                                        data-description="<%= item.getDescription() %>"
                                                        data-defaultcharge="<%= item.getDefaultCharge() %>"
                                                        data-toggle="modal" data-target="#viewInventoryItemModal"
                                                        title="Xem chi tiết">
                                                        <i class="fa fa-eye" style="color: #17a2b8; font-size: 1.2rem;"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-link p-0 edit-btn"
                                                            data-itemid="<%= item.getItemID() %>"
                                                            data-itemname="<%= item.getItemName() %>"
                                                            data-description="<%= item.getDescription() %>"
                                                            data-defaultcharge="<%= item.getDefaultCharge() %>"
                                                            data-toggle="modal" data-target="#editInventoryItemModal">
                                                        <i class="fa fa-edit" style="color: #ffc107;"></i>
                                                    </button>
                                                    <form method="post" action="inventory-item" class="d-inline delete-inventory-item-form">
                                                        <input type="hidden" name="deleteItemID" value="<%= item.getItemID() %>" />
                                                        <button type="submit" class="btn btn-link p-0 delete-btn" onclick="return confirm('Bạn có chắc chắn muốn xóa vật phẩm này?');">
                                                            <i class="fa fa-trash" style="color: #dc3545;"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <%  } 
                                        } else { %>
                                            <tr><td colspan="5" class="text-center">Không có vật phẩm nào.</td></tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                        </div>                
                    </div>

                    <!-- Add Inventory Item Modal -->
                    <div class="modal fade" id="addInventoryItemModal" tabindex="-1" role="dialog" aria-labelledby="addInventoryItemModalLabel" aria-hidden="true">
                      <div class="modal-dialog" role="document">
                        <div class="modal-content">
                          <form action="inventory-item" method="post">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addInventoryItemModalLabel">Thêm Vật Phẩm Mới</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                              <div class="form-group">
                                <label for="add-itemName">Tên Vật Phẩm</label>
                                <input type="text" name="itemName" class="form-control" required />
                                <div id="add-itemName-error" style="color:red;font-size:14px;margin-top:4px;"></div>
                              </div>
                              <div class="form-group">
                                <label for="add-description">Mô Tả</label>
                                <textarea name="description" class="form-control"></textarea>
                              </div>
                              <div class="form-group">
                                 <label for="add-defaultCharge">Phí Mặc Định</label>
                                 <input type="number" name="defaultCharge" id="add-defaultCharge" class="form-control" required />
                                 <div id="add-defaultCharge-error" style="color:red;font-size:14px;margin-top:4px;"></div>
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
                    
                    <!-- Edit Inventory Item Modal -->
                    <div class="modal fade" id="editInventoryItemModal" tabindex="-1" role="dialog" aria-labelledby="editInventoryItemModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="inventory-item" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editCategoryModalLabel">Cập nhật loại phòng</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="itemID" id="edit-itemID">
                                        <div class="modal-body">
                                            <div class="form-group">
                                                <label for="edit-itemName">Tên Vật Phẩm</label>
                                                <input type="text" name="itemName" id="edit-itemName" class="form-control" required />
                                                <div id="edit-itemName-error" style="color:red;font-size:14px;margin-top:4px;"></div>
                                            </div>
                                            <div class="form-group">
                                                <label for="edit-description">Mô Tả</label>
                                                <textarea name="description" id="edit-description" class="form-control"></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label for="edit-defaultCharge">Phí Mặc Định</label>
                                                <input type="number" name="defaultCharge" id="edit-defaultCharge" class="form-control" required />
                                                <div id="edit-defaultCharge-error" style="color:red;font-size:14px;margin-top:4px;"></div>
                                            </div>
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

                    <!-- View Inventory Item Modal -->
                    <div class="modal fade" id="viewInventoryItemModal" tabindex="-1" role="dialog" aria-labelledby="viewInventoryItemModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="card shadow-sm m-0">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="viewInventoryItemModalLabel">Chi Tiết Vật Phẩm</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <p><strong>ID Sản Phẩm:</strong> <span id="view-inventoryID"></span></p>
                                    <p><strong>Tên Sản Phẩm:</strong> <span id="view-inventoryName"></span></p>
                                    <p><strong>Mô Tả:</strong> <span id="view-description"></span></p>
                                    <p><strong>Phí Mặc Định:</strong> <span id="view-defaultCharge"></span></p>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap4.min.js"></script>
                    <script src="<%= request.getContextPath() %>/js/bootstrap.min.js"></script>
                    <script>
                        $(document).ready(function () {
                            // Initialize DataTable
                            $('#inventory-item-datatable').DataTable({
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

                            // Lấy danh sách tên vật phẩm hiện có
                            var existingItemNames = [];
                            $("#inventory-item-datatable tbody tr").each(function () {
                                var name = $(this).find("td").eq(1).text().trim();
                                if (name) existingItemNames.push(name.toLowerCase());
                            });

                            // Validate thêm vật phẩm
                            $("#addInventoryItemModal form").on("submit", function (e) {
                                var name = $(this).find('[name="itemName"]').val();
                                var charge = $(this).find('[name="defaultCharge"]').val();
                                var errorDivName = $('#add-itemName-error');
                                var errorDivCharge = $('#add-defaultCharge-error');
                                var hasError = false;

                                // Reset lỗi trước khi kiểm tra
                                errorDivName.text("");
                                errorDivCharge.text("");

                                // Kiểm tra tên
                                if (!name || name.trim() === "") {
                                    errorDivName.text("Tên vật phẩm không được để trống.");
                                    hasError = true;
                                } else if (name.trim() !== name) {
                                    errorDivName.text("Tên vật phẩm không được chứa khoảng trắng ở đầu hoặc cuối.");
                                    hasError = true;
                                } else if (existingItemNames.includes(name.toLowerCase())) {
                                    errorDivName.text("Tên vật phẩm đã tồn tại.");
                                    hasError = true;
                                }

                                // Kiểm tra giá
                                if (!charge || isNaN(charge) || parseFloat(charge) < 0) {
                                    errorDivCharge.text("Phí mặc định phải là số lớn hơn hoặc bằng 0.");
                                    hasError = true;
                                }

                                // Ngăn gửi form nếu có lỗi
                                if (hasError) {
                                    e.preventDefault();
                                }
                            });

                            // Khi mở modal sửa
                            $('.edit-btn').click(function () {
                                $('#edit-itemID').val($(this).data('itemid'));
                                $('#edit-itemName').val($(this).data('itemname'));
                                $('#edit-itemName').data('old', $(this).data('itemname'));
                                $('#edit-description').val($(this).data('description'));
                                $('#edit-defaultCharge').val($(this).data('defaultcharge'));
                                $('#edit-itemName-error').text('');
                                $('#edit-defaultCharge-error').text('');
                            });

                            // Validate khi submit form edit
                            $('#editInventoryItemModal form').on('submit', function (e) {
                                var name = $('#edit-itemName').val();
                                var oldName = $('#edit-itemName').data('old');
                                var charge = $('#edit-defaultCharge').val();
                                var errorDivName = $('#edit-itemName-error');
                                var errorDivCharge = $('#edit-defaultCharge-error');
                                var hasError = false;

                                // Reset lỗi trước khi kiểm tra
                                errorDivName.text('');
                                errorDivCharge.text('');

                                // Kiểm tra tên
                                if (!name || name.trim() === "") {
                                    errorDivName.text("Tên vật phẩm không được để trống.");
                                    hasError = true;
                                } else if (name.trim() !== name) {
                                    errorDivName.text("Tên vật phẩm không được chứa khoảng trắng ở đầu hoặc cuối.");
                                    hasError = true;
                                } else if (name.toLowerCase() !== oldName.toLowerCase() && existingItemNames.includes(name.toLowerCase())) {
                                    errorDivName.text("Tên vật phẩm đã tồn tại.");
                                    hasError = true;
                                }

                                // Kiểm tra giá
                                if (!charge || isNaN(charge) || parseFloat(charge) < 0) {
                                    errorDivCharge.text("Phí mặc định phải là số lớn hơn hoặc bằng 0.");
                                    hasError = true;
                                }

                                // Ngăn gửi form nếu có lỗi
                                if (hasError) {
                                    e.preventDefault();
                                }
                            });
                            
                            // Reset form khi đóng modal Add
                            $('#addInventoryItemModal').on('hidden.bs.modal', function () {
                                var form = $(this).find('form');
                                form[0].reset(); // Reset tất cả các trường trong form
                                $('#add-itemName-error').text(''); // Xóa lỗi tên vật phẩm
                                $('#add-defaultCharge-error').text(''); // Xóa lỗi phí mặc định
                            });

                            // Reset form khi đóng modal Edit
                            $('#editInventoryItemModal').on('hidden.bs.modal', function () {
                                var form = $(this).find('form');
                                form[0].reset(); // Reset tất cả các trường trong form
                                $('#edit-itemName-error').text(''); // Xóa lỗi tên vật phẩm
                                $('#edit-defaultCharge-error').text(''); // Xóa lỗi phí mặc định
                            });
                            
                            // Populate View Modal
                            $('.view-btn').on('click', function () {
                                $('#view-inventoryID').text($(this).data('itemid'));
                                $('#view-inventoryName').text($(this).data('itemname'));
                                $('#view-description').text($(this).data('description'));
                                $('#view-defaultCharge').text($(this).data('defaultcharge') + " $");
                            });
                        });
                    </script>
                </main>
                <%@ include file="/View/Common/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
