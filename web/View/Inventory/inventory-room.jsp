<%@ page import="java.util.List" %>
<%@ page import="Model.RoomCategoryInventory" %>
<%@ page import="Model.RoomCategory" %>
<%@ page import="Model.InventoryItem" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Room Category Inventory</title>

        <!-- Styles -->
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css"/>
        <%@ include file="/View/Common/header.jsp" %>
    </head>
    <body>
        <div class="wrapper">
            <%@ include file="/View/Common/sidebar.jsp" %>
            <div class="main">
                <%@ include file="/View/Common/navbar.jsp" %>
                <main class="content">
                    <% 
                        // Fetch data from request once to avoid duplicate variable declarations
                        List<RoomCategoryInventory> inventories = (List<RoomCategoryInventory>) request.getAttribute("inventories");
                        List<RoomCategory> categories = (List<RoomCategory>) request.getAttribute("categories");
                        List<InventoryItem> items = (List<InventoryItem>) request.getAttribute("items");
                    %>

                    <!-- Table Section -->
                    <div class="container mt-5">
                        <div class="card shadow-lg">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center">
                                <h3 class="mb-0">Danh Sách Room Category Inventory</h3>
                                <button type="button" class="btn btn-success" data-toggle="modal" data-target="#addRoomCategoryInventoryModal">
                                    <i class="fa fa-plus"></i> Thêm Mới
                                </button>
                            </div>
                            <div class="card-body">
                                <!-- Filter Form -->
                                <form class="form-inline" method="get" action="inventory-room">
                                    <div class="form-group mr-3">
                                        <label for="filter-category" class="mr-2">Loại Phòng:</label>
                                        <select name="categoryID" id="filter-category" class="form-control">
                                            <option value="">Tất cả</option>
                                            <% for (RoomCategory category : categories) { %>
                                            <option value="<%= category.getCategoryID() %>"><%= category.getCategoryName() %></option>
                                            <% } %>
                                        </select>
                                    </div>

                                    <div class="form-group mr-3">
                                        <label for="filter-item" class="mr-2">Vật Phẩm:</label>
                                        <select name="itemID" id="filter-item" class="form-control">
                                            <option value="">Tất cả</option>
                                            <% for (InventoryItem item : items) { %>
                                            <option value="<%= item.getItemID() %>"><%= item.getItemName() %></option>
                                            <% } %>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn btn-primary mr-2">Lọc</button>
                                    <a href="inventory-room" class="btn btn-secondary">Hủy Lọc</a>
                                </form>
                                <div class="table-responsive">
                                    <table id="inventory-room-datatable" class="table table-hover table-striped align-middle">
                                        <thead class="thead-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th>Loại Phòng</th>
                                                <th>Vật Phẩm</th>
                                                <th>Số Lượng</th>
                                                <th>Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% if (inventories != null && !inventories.isEmpty()) {
                                                for (RoomCategoryInventory inventory : inventories) { %>
                                            <tr>
                                                <td><%= inventory.getRoomCategoryInventoryID() %></td>
                                                <td><%= inventory.getCategory().getCategoryName() %></td>
                                                <td><%= inventory.getItem().getItemName() %></td>
                                                <td><%= inventory.getDefaultQuantity() %></td>
                                                <td>
                                                    <button type="button" class="btn btn-link p-0 view-btn" 
                                                            data-roomcategoryinventoryid="<%= inventory.getRoomCategoryInventoryID() %>"
                                                            data-categoryname="<%= inventory.getCategory() != null ? inventory.getCategory().getCategoryName() : "" %>"
                                                            data-itemname="<%= inventory.getItem() != null ? inventory.getItem().getItemName() : "" %>"
                                                            data-defaultquantity="<%= inventory.getDefaultQuantity() %>"
                                                            data-toggle="modal" data-target="#viewRoomCategoryInventoryModal">
                                                        <i class="fa fa-eye" style="color: #17a2b8;"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-link p-0 edit-btn" 
                                                            data-roomcategoryinventoryid="<%= inventory.getRoomCategoryInventoryID() %>"
                                                            data-categoryid="<%= inventory.getCategory() != null ? inventory.getCategory().getCategoryID() : "" %>"
                                                            data-categoryname="<%= inventory.getCategory() != null ? inventory.getCategory().getCategoryName() : "" %>"
                                                            data-itemid="<%= inventory.getItem() != null ? inventory.getItem().getItemID() : "" %>"
                                                            data-itemname="<%= inventory.getItem() != null ? inventory.getItem().getItemName() : "" %>"
                                                            data-defaultquantity="<%= inventory.getDefaultQuantity() %>"
                                                            data-toggle="modal" data-target="#editRoomCategoryInventoryModal">
                                                        <i class="fa fa-edit" style="color: #ffc107;"></i>
                                                    </button>
                                                    <form method="post" action="inventory-room" class="d-inline">
                                                        <input type="hidden" name="deleteRoomCategoryInventoryID" value="<%= inventory.getRoomCategoryInventoryID() %>" />
                                                        <button type="submit" class="btn btn-link p-0 delete-btn" onclick="return confirm('Bạn có chắc chắn muốn xóa?');">
                                                            <i class="fa fa-trash" style="color: #dc3545;"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                            <% } 
                                            } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- View Room Category Inventory Modal -->
                    <div class="modal fade" id="viewRoomCategoryInventoryModal" tabindex="-1" role="dialog" aria-labelledby="viewRoomCategoryInventoryModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="viewRoomCategoryInventoryModalLabel">Chi Tiết Room Category Inventory</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label><strong>ID:</strong></label>
                                        <p id="view-roomCategoryInventoryID" class="form-control-plaintext"></p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong>Loại Phòng:</strong></label>
                                        <p id="view-categoryName" class="form-control-plaintext"></p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong>Vật Phẩm:</strong></label>
                                        <p id="view-itemName" class="form-control-plaintext"></p>
                                    </div>
                                    <div class="form-group">
                                        <label><strong>Số Lượng Mặc Định:</strong></label>
                                        <p id="view-defaultQuantity" class="form-control-plaintext"></p>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Add Room Category Inventory Modal -->
                    <div class="modal fade" id="addRoomCategoryInventoryModal" tabindex="-1" role="dialog" aria-labelledby="addRoomCategoryInventoryModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="inventory-room" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addRoomCategoryInventoryModalLabel">Thêm Đồ Vật vào Phòng</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="form-group">
                                            <label for="add-categoryID">Loại Phòng</label>
                                            <select name="categoryID" id="add-categoryID" class="form-control" required>
                                                <option value="">Chọn Loại Phòng</option>
                                                <% for (RoomCategory category : categories) { %>
                                                <option value="<%= category.getCategoryID() %>"><%= category.getCategoryName() %></option>
                                                <% } %>
                                            </select>
                                            <div id="add-categoryID-error" class="text-danger mt-1" style="font-size: 14px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="add-itemID">Vật Phẩm</label>
                                            <select name="itemID" id="add-itemID" class="form-control" required>
                                                <option value="">Chọn Vật Phẩm</option>
                                                <% for (InventoryItem item : items) { %>
                                                <option value="<%= item.getItemID() %>"><%= item.getItemName() %></option>
                                                <% } %>
                                            </select>
                                            <div id="add-itemID-error" class="text-danger mt-1" style="font-size: 14px;"></div>
                                        </div>
                                        <div class="form-group">
                                            <label for="add-defaultQuantity">Số Lượng Mặc Định</label>
                                            <input type="number" name="defaultQuantity" id="add-defaultQuantity" class="form-control" min="1" required />
                                            <div id="add-defaultQuantity-error" class="text-danger mt-1" style="font-size: 14px;"></div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Thêm</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Room Category Inventory Modal -->
                    <div class="modal fade" id="editRoomCategoryInventoryModal" tabindex="-1" role="dialog" aria-labelledby="editRoomCategoryInventoryModalLabel" aria-hidden="true">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <form action="inventory-room" method="post">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editRoomCategoryInventoryModalLabel">Cập Nhật Room Category Inventory</h5>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="roomCategoryInventoryID" id="edit-roomCategoryInventoryID">
                                        <div class="form-group">
                                            <label for="edit-categoryID">Loại Phòng</label>
                                            <select name="categoryID" id="edit-categoryID" class="form-control" required>
                                                <option value="">Chọn Loại Phòng</option>
                                                <% for (RoomCategory category : categories) { %>
                                                    <option value="<%= category.getCategoryID() %>"><%= category.getCategoryName() %></option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-itemID">Vật Phẩm</label>
                                            <select name="itemID" id="edit-itemID" class="form-control" required>
                                                <option value="">Chọn Vật Phẩm</option>
                                                <% for (InventoryItem item : items) { %>
                                                    <option value="<%= item.getItemID() %>"><%= item.getItemName() %></option>
                                                <% } %>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <label for="edit-defaultQuantity">Số Lượng Mặc Định</label>
                                            <input type="number" name="defaultQuantity" id="edit-defaultQuantity" class="form-control" min="1" required />
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-primary">Cập Nhật</button>
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
                            // ---------------------- Initialize DataTable ----------------------
                            $('#inventory-room-datatable').DataTable({
                                responsive: true,
                                paging: true,
                                ordering: true,
                                info: true,
                                columnDefs: [
                                    { orderable: false, targets: -1 } // Disable ordering for the last column (Actions)
                                ],
                                language: {
                                    url: '//cdn.datatables.net/plug-ins/1.13.4/i18n/vi.json', // Vietnamese localization
                                    emptyTable: 'Không có thông tin.' // Message for empty table
                                }
                            });

                            // ---------------------- View Modal ----------------------
                            $('.view-btn').on('click', function () {
                                // Populate View Modal with data from data-* attributes
                                $('#view-roomCategoryInventoryID').text($(this).data('roomcategoryinventoryid'));
                                $('#view-categoryName').text($(this).data('categoryname'));
                                $('#view-itemName').text($(this).data('itemname'));
                                $('#view-defaultQuantity').text($(this).data('defaultquantity'));
                            });

                            // ---------------------- Edit Modal ----------------------
                            $('.edit-btn').on('click', function () {
                                // Populate Edit Modal with data from data-* attributes
                                $('#edit-roomCategoryInventoryID').val($(this).data('roomcategoryinventoryid'));
                                $('#edit-defaultQuantity').val($(this).data('defaultquantity'));

                                // Set selected option for category dropdown
                                const categoryID = $(this).data('categoryid');
                                $('#edit-categoryID').val(categoryID);

                                // Set selected option for item dropdown
                                const itemID = $(this).data('itemid');
                                $('#edit-itemID').val(itemID);

                                // Clear validation errors for Edit Modal
                                clearEditErrors();
                            });

                            // Validate and Submit Edit Form
                            $('#editRoomCategoryInventoryModal form').on('submit', function (e) {
                                const hasError = validateEditForm();
                                if (hasError) e.preventDefault(); // Prevent form submission if validation fails
                            });

                            // Reset Edit Modal on close
                            $('#editRoomCategoryInventoryModal').on('hidden.bs.modal', function () {
                                resetEditForm();
                            });

                            // ---------------------- Add Modal ----------------------
                            $('.add-btn').on('click', function () {
                                // Clear validation errors for Add Modal
                                clearAddErrors();
                            });

                            // Validate and Submit Add Form
                            $('#addRoomCategoryInventoryModal form').on('submit', function (e) {
                                const hasError = validateAddForm();
                                if (hasError) e.preventDefault(); // Prevent form submission if validation fails
                            });

                            // Reset Add Modal on close
                            $('#addRoomCategoryInventoryModal').on('hidden.bs.modal', function () {
                                resetAddForm();
                            });

                            // ---------------------- Utility Functions ----------------------

                            /**
                             * Clear validation errors for Edit Modal.
                             */
                            function clearEditErrors() {
                                $('#edit-categoryID-error').text('');
                                $('#edit-itemID-error').text('');
                                $('#edit-defaultQuantity-error').text('');
                            }

                            /**
                             * Clear validation errors for Add Modal.
                             */
                            function clearAddErrors() {
                                $('#add-categoryID-error').text('');
                                $('#add-itemID-error').text('');
                                $('#add-defaultQuantity-error').text('');
                            }

                            /**
                             * Reset Edit Form and clear validation errors.
                             */
                            function resetEditForm() {
                                const form = $('#editRoomCategoryInventoryModal form');
                                form[0].reset(); // Reset all fields in the form
                                clearEditErrors();
                            }

                            /**
                             * Reset Add Form and clear validation errors.
                             */
                            function resetAddForm() {
                                const form = $('#addRoomCategoryInventoryModal form');
                                form[0].reset(); // Reset all fields in the form
                                clearAddErrors();
                            }

                            /**
                             * Validate Edit Form fields and display errors if any.
                             * @returns {boolean} - Returns true if there are validation errors, otherwise false.
                             */
                            function validateEditForm() {
                                const categoryID = $('#edit-categoryID').val();
                                const itemID = $('#edit-itemID').val();
                                const defaultQuantity = $('#edit-defaultQuantity').val();

                                const errorCategory = $('#edit-categoryID-error');
                                const errorItem = $('#edit-itemID-error');
                                const errorQuantity = $('#edit-defaultQuantity-error');

                                let hasError = false;

                                // Reset errors
                                clearEditErrors();

                                // Validate categoryID
                                if (!categoryID || categoryID.trim() === "") {
                                    errorCategory.text("Loại phòng không được để trống.");
                                    hasError = true;
                                }

                                // Validate itemID
                                if (!itemID || itemID.trim() === "") {
                                    errorItem.text("Vật phẩm không được để trống.");
                                    hasError = true;
                                }

                                // Validate defaultQuantity
                                if (!defaultQuantity || isNaN(defaultQuantity) || parseInt(defaultQuantity) < 1) {
                                    errorQuantity.text("Số lượng mặc định phải là số lớn hơn hoặc bằng 1.");
                                    hasError = true;
                                }

                                return hasError;
                            }

                            /**
                             * Validate Add Form fields and display errors if any.
                             * @returns {boolean} - Returns true if there are validation errors, otherwise false.
                             */
                            function validateAddForm() {
                                const categoryID = $('#add-categoryID').val();
                                const itemID = $('#add-itemID').val();
                                const defaultQuantity = $('#add-defaultQuantity').val();

                                const errorCategory = $('#add-categoryID-error');
                                const errorItem = $('#add-itemID-error');
                                const errorQuantity = $('#add-defaultQuantity-error');

                                let hasError = false;

                                // Reset errors
                                clearAddErrors();

                                // Validate categoryID
                                if (!categoryID || categoryID.trim() === "") {
                                    errorCategory.text("Loại phòng không được để trống.");
                                    hasError = true;
                                }

                                // Validate itemID
                                if (!itemID || itemID.trim() === "") {
                                    errorItem.text("Vật phẩm không được để trống.");
                                    hasError = true;
                                }

                                // Validate defaultQuantity
                                if (!defaultQuantity || isNaN(defaultQuantity) || parseInt(defaultQuantity) < 1) {
                                    errorQuantity.text("Số lượng mặc định phải là số lớn hơn hoặc bằng 1.");
                                    hasError = true;
                                }

                                return hasError;
                            }
                        });
                    </script>
                </main>
                <%@ include file="/View/Common/footer.jsp" %>
            </div>
        </div>
    </body>
</html>

