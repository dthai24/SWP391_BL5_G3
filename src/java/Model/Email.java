/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Date;
import java.util.Properties;

/**
 *
 * @author tiend
 */
public class Email {

    public static final String pass = "iokp ormm dpaz wkcf";
    // lấy pass
    public static final String from = "capduythai11@gmail.com";
// gửi đến địa chỉ email
    public String to, subject, content;

    public Email() {
    }

    public Email(String to, String subject, String content) {
        this.to = to;
        this.subject = subject;
        this.content = content;
    }

    public String getFrom() {
        return from;
    }

    public String getTo() {
        return to;
    }

    public void setTo(String to) {
        this.to = to;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public boolean sendMess(String to, String subject, String content) {
        // khai báo thuộc tính
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");// smtp host
        props.put("mail.smtp.port", "587");// TLS 587,SSL 465
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator authen = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, pass); 
            }
            
        };
        Session session = Session.getInstance(props, authen);

        MimeMessage msg = new MimeMessage(session);
        try {       // kieu noi dung
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            // nguoi gui
            msg.setFrom(from);
            // nguoi nhan
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            // tieu de
            msg.setSubject(subject, "UTF-8");
            // quy dinh ngay gui
            msg.setSentDate(new Date());
            // quy dinh email nhan phan hoi khi ma nguoi nhan nhan nut Reply   msg.setReplyTo(InternetAddress.parse(from,false));
            msg.setContent(content, "text/HTML; charset=UTF-8");
            Transport.send(msg);

            return true;
        } catch (Exception e) {
            System.out.println("Gap loi trong van qua tring gui email");
            e.printStackTrace();
            return false;
        }

    }

}
