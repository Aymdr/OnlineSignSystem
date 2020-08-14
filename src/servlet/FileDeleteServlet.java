package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.DAO.PdfFileDAO;
import net.sf.json.JSONObject;

/**
 * @author Aymdr
 * 文件删除，输入文件路径文件名，数据库中删除文件
 */
public class FileDeleteServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PdfFileDAO PDFfile = new PdfFileDAO();
        JSONObject result = new JSONObject();
        PrintWriter out = response.getWriter();
        int fileId =  Integer.parseInt(request.getParameter("fileId"));
        try {
            int flag = PDFfile.fileDelete(fileId);
            //若返回值不为0，则成功删除文件，向浏览器返回提示信息
            if(flag!=0){
                result.put("result",flag);
            }else {
                result.put("result","error");
            }
            out.print(result);
        } catch (Exception e) {
            e.printStackTrace();
        }
        out.flush();
        out.close();
    }
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
