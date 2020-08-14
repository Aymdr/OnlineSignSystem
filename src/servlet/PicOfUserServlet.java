package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.DAO.PhotoDAO;
import com.DAO.UserAndPhotoDAO;
import com.DAO.userDAO;
import net.sf.json.JSONObject;

public class PicOfUserServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        userDAO userInfo = new userDAO();
        UserAndPhotoDAO relation = new UserAndPhotoDAO();
        PhotoDAO photoInfo = new PhotoDAO();
        String loginName =  request.getParameter("user_name");
        ArrayList<Integer> resultPhotoId = new ArrayList<Integer>();
        //JSONObject resultPhotoName = new JSONObject();
        ArrayList<JSONObject> array = null;
        ArrayList<JSONObject> array1 = null;
        ArrayList<ArrayList<JSONObject>> arrayResult = new ArrayList();
        try {
            String resultUserID = userInfo.userIDCheck(loginName);
            resultPhotoId = relation.photoCheck(resultUserID);
            array = photoInfo.photoNameCheck(resultPhotoId);
            array1 = userInfo.userCheck(loginName);
            int i=1;
            arrayResult.add(array);
            arrayResult.add(array1);
            response.setContentType("text/html;charset=utf-8");
            PrintWriter pw = response.getWriter();
            pw.print(arrayResult.toString());
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
