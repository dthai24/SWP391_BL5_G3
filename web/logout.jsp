<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    session.invalidate(); // Xóa session
    response.sendRedirect("index.html"); // Quay lại trang đăng nhập
%>