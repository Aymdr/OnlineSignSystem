package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import com.DAO.PdfFileDAO;
/**
 * @author Aymdr
 * 签署文件
 */
@WebServlet(name = "signFilesServlet", urlPatterns = "/signFilesHandle")
public class signFilesServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("user_name");
        String PDF_id = request.getParameter("PDF_id");
        PdfFileDAO files = new PdfFileDAO();
        try {
            int k = files.fileChange(PDF_id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        HttpSession session = request.getSession();
        session.setAttribute("username", username);
        response.sendRedirect("/mainPage.jsp");
    }
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
