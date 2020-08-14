package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import com.DAO.PhotoDAO;
import com.DAO.UserAndPhotoDAO;
import com.sun.corba.se.impl.interceptors.PIHandlerImpl;
import net.sf.json.JSONObject;
import net.sf.json.JSONException;
public class UserPhotoServlet extends HttpServlet {

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        JSONObject result = new JSONObject();
        //获取到图片id，用户id，拥有者
        int picId =  Integer.parseInt(request.getParameter("picId"));
        String userId = request.getParameter("userId");
        String owner = request.getParameter("owner");
        String flagAlloction = request.getParameter("flag");
        PrintWriter out = response.getWriter();
        UserAndPhotoDAO relation = new UserAndPhotoDAO();
        PhotoDAO ownerPhoto = new PhotoDAO();
        try{
            int flag1;
            int flag;
            int flag2;
            if("0".equals(flagAlloction)){
                flag = relation.userAndPhotoAdd(userId,picId,1,owner);
                flag1 = ownerPhoto.photoUserAdd(picId,owner,1);
                flag2 = 1;
            }else{
                flag2 = ownerPhoto.photoUpdate(picId,owner);
                flag1 = relation.userAndPhotoDelete(picId);
                flag = relation.userAndPhotoAdd(userId,picId,1,owner);
            }

            if(flag!=0 && flag1!=0 && flag2!=0){
                result.put("result",flag);
            }else {
                result.put("result","error");
            }
            out.print(result);
        }catch (Exception e) {
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
