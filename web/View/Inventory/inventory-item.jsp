<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="Model.InventoryItem" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Vật Dụng</title>

        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
        <%@ include file="/View/Common/header.jsp" %>
        <style>
            .info-label {
                font-weight: 600;
            }
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
            .notification-box {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1050;
                display: none;
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
                        InventoryItem editInventoryItem = (InventoryItem) request.getAttribute("editInventoryItem");
                        String successMessage = (String) request.getAttribute("successMessage");
                        String errorMessage = (String) request.getAttribute("errorMessage");
                        Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
                    %>

                    <!-- Notification Box -->
                    <% if (successMessage != null) { %>
                    <div class="alert alert-success alert-dismissible fade show notification-box" role="alert">
                        <%= successMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% } %>
                    <% if (errorMessage != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show notification-box" role="alert">
                        <%= errorMessage %>
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <% } %>
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
                                                <td style="font-weight: 600; color: #28a745;"><%= item.getItemName() %></td>
                                                <td style="font-weight: 600; color: #28a745;"><%= (item.getDescription() != null && !item.getDescription().trim().isEmpty()) ? item.getDescription() : "N/A" %></td>
                                                <td style="font-weight: 600; color: #28a745;"><%= item.getDefaultCharge()%></td>
                                                <td>
                                                    <button type="button" class="btn btn-link p-0 view-btn" 
                                                            data-itemid="<%= item.getItemID() %>"
                                                            data-itemname="<%= item.getItemName() %>"
                                                            data-description="<%= item.getDescription() %>"
                                                            data-defaultcharge="<%= item.getDefaultCharge() %>"
                                                            data-toggle="modal" data-target="#viewInventoryItemModal">
                                                        <i class="fa fa-eye" style="color: #17a2b8;"></i>
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

                    <!-- View Inventory Item Modal -->
                    <div class="modal fade" id="viewInventoryItemModal" tabindex="-1" role="dialog" aria-labelledby="viewInventoryItemModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
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

                    <!-- Add Inventory Item Modal -->
                    <div class="modal fade" id="addInventoryItemModal" tabindex="-1" role="dialog" aria-labelledby="addInventoryItemModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="inventory-item" method="post">
                                    <input type="hidden" name="action" value="add">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addInventoryItemModalLabel">Thêm Vật Phẩm Mới</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="add-itemName">Tên Vật Phẩm</label>
                                            <input type="text" name="itemName" id="add-itemName" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="add-description">Mô Tả</label>
                                            <textarea name="description" id="add-description" class="form-control"></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="add-defaultCharge">Phí Mặc Định</label>
                                            <input type="number" step="0.01" name="defaultCharge" id="add-defaultCharge" class="form-control" required />
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Thêm Vật Phẩm</button>
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
                                    <input type="hidden" name="action" value="edit">
                                    <input type="hidden" name="itemID" id="edit-itemID">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editInventoryItemModalLabel">Chỉnh Sửa Vật Phẩm</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="edit-itemName">Tên Vật Phẩm</label>
                                            <input type="text" name="itemName" id="edit-itemName" class="form-control" required />
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-description">Mô Tả</label>
                                            <textarea name="description" id="edit-description" class="form-control"></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-defaultCharge">Phí Mặc Định</label>
                                            <input type="number" step="0.01" name="defaultCharge" id="edit-defaultCharge" class="form-control" required />
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Cập Nhật Vật Phẩm</button>
                                    </div>
                                </form>
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
                                                                        {orderable: false, targets: -1} // Disable sort for last column (Action)
                                                                    ],
                                                                    language: {
                                                                        url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json'
                                                                    }
                                                                });

                                                                // Handle Notification Box
                                                                const notificationBox = $('.notification-box');
                                                                if (notificationBox.children().length > 0) {
                                                                    notificationBox.fadeIn();
                                                                    setTimeout(() => notificationBox.fadeOut(), 3000);
                                                                }

                                                                // Populate View Inventory Item Modal
                                                                $('.view-btn').on('click', function () {
                                                                    // Lấy dữ liệu vật phẩm từ các thuộc tính data-* của nút
                                                                    $('#view-itemID').text($(this).data('itemid'));
                                                                    $('#view-itemName').text($(this).data('itemname'));
                                                                    $('#view-description').text($(this).data('description'));
                                                                    $('#view-defaultCharge').text($(this).data('defaultcharge'));
                                                                });

// Populate Edit Inventory Item Modal
                                                                $('.edit-btn').on('click', function () {
                                                                    $('#edit-itemID').val($(this).data('itemid'));
                                                                    $('#edit-itemName').val($(this).data('itemname'));
                                                                    $('#edit-description').val($(this).data('description'));
                                                                    $('#edit-defaultCharge').val($(this).data('defaultcharge'));
                                                                });

                                                            });
                    </script>
                </main>
                <%@ include file="/View/Common/footer.jsp" %>
            </div>
        </div>
    </body>
</html>
