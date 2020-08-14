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
/**
 * @author Aymdr
 * 用户删除
 */
public class UserDeleteServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        userDAO user = new userDAO();
        UserAndPhotoDAO relation = new UserAndPhotoDAO();
        PhotoDAO photo = new PhotoDAO();
        JSONObject result = new JSONObject();
        PrintWriter out = response.getWriter();
        int userId =  Integer.parseInt(request.getParameter("userId"));
        try {
            ArrayList<Integer> photoId = relation.userAndPhotoDeleteByUser(userId);
            int flag1= photo.photoUserDelete(photoId);
            int flag = user.userDelete(userId);
            if(flag!=0 && flag1!=0){
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
