package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.DAO.PdfFileDAO;
import net.sf.json.JSONObject;
import net.sf.json.JSONException;

/**
 * @author Aymdr
 * 文件显示，分为所有文件显示，已完成文件显示，未完成文件显示
 */
public class FileShowServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        String loginName = request.getParameter("user_name");
        String test = request.getParameter("status");
        int status = Integer.parseInt(test);
        PdfFileDAO files = new PdfFileDAO();
        ArrayList<JSONObject> array = null;
        try {
            array = files.fileCheck(loginName, status);
        } catch (JSONException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=utf-8");
        PrintWriter pw = response.getWriter();
        if (array != null) {
            pw.print(array.toString());
        }else{
            pw.print("");
        }
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

