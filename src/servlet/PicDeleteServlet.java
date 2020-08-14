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
import net.sf.json.JSONObject;
/**
 * @author Aymdr
 * 图片删除
 */

public class PicDeleteServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        PhotoDAO pic = new PhotoDAO();
        UserAndPhotoDAO relation = new UserAndPhotoDAO();
        JSONObject result = new JSONObject();
        PrintWriter out = response.getWriter();
        int picId =  Integer.parseInt(request.getParameter("picId"));
        int status =  Integer.parseInt(request.getParameter("status"));
        if(status==1){
            try {
                //删除用户与签章的关联
                int flag1 = relation.userAndPhotoDelete(picId);
                //删除签章
                int flag = pic.photoDelete(picId);
                // 都不为0说明成功删除
                if(flag!=0 && flag1!=0){
                    result.put("result",flag);
                }else {
                    result.put("result","error");
                }
                out.print(result);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }else if(status==0){
            //删除用户与签章的关联
            try {
                int flag1 = relation.userAndPhotoDelete(picId);
                //重置签章
                ArrayList<Integer> photoId = new ArrayList<Integer>();
                photoId.add(picId);
                int flag = pic.photoUserDelete(photoId);
                // 都不为0说明成功删除
                if(flag!=0 && flag1!=0){
                    result.put("result",flag);
                }else {
                    result.put("result","error");
                }
                out.print(result);
            } catch (Exception e) {
                e.printStackTrace();
            }
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
