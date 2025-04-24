/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import Dal.UserDAO;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import org.mindrot.jbcrypt.BCrypt;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import Model.User;
import java.util.Locale;


public class ValidFunction {

    public boolean containsDigitOrSpecialChar(String str) {
        return str.matches(".*[^a-zA-Z\\s].*"); // Kiểm tra nếu có ký tự không phải chữ cái hoặc khoảng trắng
    }

    public boolean containsSpecialCharacter(String str) {
        return str.matches(".*[^a-zA-Z0-9\\s].*");
    }

    public String normalizeName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "";
        }
        name = name.trim().toLowerCase(); // Loại bỏ khoảng trắng đầu cuối và chuyển về chữ thường
        String[] words = name.split("\\s+"); // Tách các từ dựa vào khoảng trắng
        StringBuilder normalized = new StringBuilder();

        for (String word : words) {
            if (!word.isEmpty()) {
                normalized.append(Character.toUpperCase(word.charAt(0))) // Viết hoa chữ cái đầu
                        .append(word.substring(1)) // Giữ lại phần còn lại
                        .append(" "); // Thêm khoảng trắng giữa các từ
            }
        }

        return normalized.toString().trim(); // Loại bỏ khoảng trắng cuối cùng
    }

    public boolean isValidPhoneNumber(String input) {
        // Kiểm tra chuỗi có đúng 10 ký tự số không
        if (!input.matches("\\d{10}")) {
            return false;
        }

        // Kiểm tra chuỗi có bắt đầu bằng '0' không
        return input.startsWith("0");
    }

    public boolean isValidPassword(String password) {
        // Kiểm tra độ dài ít nhất 8 ký tự
        if (password.length() < 8) {
            return false;
        }

        // Biểu thức chính quy kiểm tra điều kiện
        String regex = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$";

        return password.matches(regex);
    }

    public String formatDate(String input) {
        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        LocalDateTime dateTime = LocalDateTime.parse(input, inputFormatter);
        return dateTime.format(outputFormatter);
    }

    public String formatDateInvoice(String date) {
        // Chuyển từ chuỗi ngày ban đầu (yyyy-MM-dd HH:mm:ss) sang Timestamp
        java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(date);
        // Định dạng Timestamp thành chuỗi dd/MM/yyyy
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("yyyy, MMMM dd", Locale.ENGLISH);
        return dateFormat.format(timestamp);
    }

    public String formatDateTime(String date, String pattern) {
        java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(date);
        SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);
        return dateFormat.format(timestamp);
    }

    //chuyển ngày sinh thành dd/mm/yyy
    public String convertDateString(String inputDate, String outputPattern) {
        if (inputDate == null || inputDate.isEmpty()) {
            return "";
        }
        try {
            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date date = inputFormat.parse(inputDate);
            SimpleDateFormat outputFormat = new SimpleDateFormat(outputPattern);
            return outputFormat.format(date);
        } catch (ParseException e) {
            e.printStackTrace();
            return "";
        }
    }

    // Chuyển từ chuỗi ngày ban đầu (yyyy-MM-dd HH:mm:ss) sang Timestamp
    public String formatDateNews(String date) {
        java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(date);
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy");
        return dateFormat.format(timestamp);
    }
    
    public String formatDateFeedback(String date) {
        java.sql.Timestamp timestamp = java.sql.Timestamp.valueOf(date);
        java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
        return dateFormat.format(timestamp);
    }

    public String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public boolean checkPassword(String password, String hashedPassword) {
        return BCrypt.checkpw(password, hashedPassword);
    }
    
    private java.sql.Date convertStringToSqlDate(String dateStr) {
    try {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // Định dạng đầu vào
        java.util.Date utilDate = sdf.parse(dateStr);
        return new java.sql.Date(utilDate.getTime()); // Chuyển sang java.sql.Date
    } catch (ParseException e) {
        e.printStackTrace();
        return null; // Trả về null nếu lỗi
    }
}

    
    
    public static void main(String[] args) {
        ValidFunction valid = new ValidFunction();
        System.out.println(valid.hashPassword("00"));
    }
}
