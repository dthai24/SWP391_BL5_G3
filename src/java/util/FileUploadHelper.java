/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;


import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Paths;
import jakarta.servlet.http.Part;

public class FileUploadHelper {
    private static final String UPLOAD_DIR = "C:\\Users\\Phan Huu Kien\\Desktop\\Health-care-servicee\\SWP\\web\\assets\\img";  // Thay đổi thư mục phù hợp
     

    public static String saveProfilePicture(Part filePart) throws Exception {
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // Lấy tên file
        String uploadPath = UPLOAD_DIR + File.separator + fileName; 

        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs(); // Tạo thư mục nếu chưa có
        }
        
        // Lưu file vào thư mục
        try (InputStream fileContent = filePart.getInputStream();
             FileOutputStream fos = new FileOutputStream(uploadPath)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fileContent.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
        }
        return   fileName; // Trả về đường dẫn tương đối để lưu vào DB
    }
}
