package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.Bean.User;
import com.DAO.userDAO;
import net.sf.json.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class ServletLogin extends HttpServlet {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = null;
        String password = null;
        // U盾校验
        String uid = request.getParameter("UID");
//        String uid = "5eb29fb46acb8332cbe3978306c6e50e";
        username = request.getParameter("username");
        password = request.getParameter("password");
        User user = new User(username, password, uid);
        userDAO dao = new userDAO();
        JSONObject object = new JSONObject();
        PrintWriter pw = response.getWriter();
        try {
            if (dao.login_check(user)) {
                HttpSession session = request.getSession();
                session.setAttribute("username", user.getName());
                if ("admin".equals(username)) {
                    response.setContentType("text/html;charset=utf-8");
                    object.put("result1",1);
                    pw.print(object.toString());
//                    response.sendRedirect("/admin.jsp");
                } else {
//                    response.sendRedirect("/HomePage.jsp");
                    response.setContentType("text/html;charset=utf-8");
                    object.put("result1",2);
                    pw.print(object.toString());
                    System.out.println("登陆主页");
                }
            } else {
//                request.getRequestDispatcher("/loginError.jsp").forward(request, response);
                // 向客户端返回信息
                response.setContentType("text/html;charset=utf-8");
//                pw.print(object.toString());
                object.put("result1",0);
                pw.print(object.toString());
//                request.getRequestDispatcher("login.jsp").forward(request, response);
                System.out.println("密码错误或用户名不存在或U盾不正确");
                //response.sendRedirect("login.jsp?err=yes");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
