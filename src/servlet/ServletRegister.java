package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.ws.Response;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import com.DAO.userDAO;
import net.sf.json.JSONObject;
import servlet.fileHandle;

public class ServletRegister extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
//        String realPath=request.getServletContext().getRealPath("/log");
        String userid=request.getParameter("userID");
        String usname=request.getParameter("name");
        String username = request.getParameter("username");  //用户名
        String password = request.getParameter("password");
        String device_id = request.getParameter("deviceID");
        userDAO dao=new userDAO();
        JSONObject object = new JSONObject();
        PrintWriter pw = response.getWriter();
        fileHandle myFile = new fileHandle();
        String path = "G:\\OnlineSignSystem\\log\\";
        try {
            int flag = dao.user_add(userid,usname,username,password,device_id);
            if(flag!=0){
                String filePath = path + username +".txt";
                boolean fileFlag = myFile.createTxtFile(filePath);
                if(fileFlag==true){
                    System.out.println("success");
                }
            }
            // 向客户端返回信息
            response.setContentType("text/html;charset=utf-8");
//            pw.print(object.toString());
            object.put("result1",flag);
            pw.print(object.toString());
//            response.sendRedirect("/login.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
        pw.flush();
        pw.close();
    }
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
