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
 * 文件搜索
 */
public class SearchServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        String loginName =  request.getParameter("user_name");
        String status1 = request.getParameter("status");
        String filename = request.getParameter("filename");
        String filetype1 = request.getParameter("filetype");
        int status = Integer.parseInt(status1);
        int filetype = Integer.parseInt(filetype1);
        PdfFileDAO files = new PdfFileDAO();
        ArrayList<JSONObject> array = null;
        try{
            array = files.fileSearch(loginName,status,filename,filetype);
        }catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=utf-8");
        PrintWriter pw = response.getWriter();
        pw.print(array.toString());
    }
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

