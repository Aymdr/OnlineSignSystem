package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import DB.db_con;

public class UserAndPhotoDAO {
    public UserAndPhotoDAO() {

    }
    private ResultSet rst =null;
    //增加关系
    public int userAndPhotoAdd(String userId, int photoId, int statu, String username) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        //上传印章与用户关系
        try {
            String sql = "insert into user_photo(photo_id, user_id, status, user_name) values (?,?,1,?)";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, Integer.toString(photoId));
            pstm.setString(2, userId);
            pstm.setString(3, username);
            k = pstm.executeUpdate();
            System.out.println(k);
            pstm.close();
        } catch (SQLException e) {
            System.out.println("Error occured at UserAndPhotoDAO->userAndPhotoAdd");
        } finally {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error occured at closing connection in DesignReportDAO");
            }
        }
        return k;
    }

    //删除印章与用户关系
    public int userAndPhotoDelete(int photoId) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        try {
            String sql = "UPDATE user_photo SET status = 0 WHERE photo_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, Integer.toString(photoId));
            k = pstm.executeUpdate();
        }catch (SQLException e){
            e.printStackTrace();
        }
        return k;
    }

    public ArrayList<Integer> userAndPhotoDeleteByUser(int userId) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        ArrayList<Integer> photoId = new ArrayList<Integer>();
        try{
            String sql1 = "select photo_id from user_photo WHERE (user_id = ? and status=1)";
            pstm = conn.prepareStatement(sql1);
            pstm.setString(1, Integer.toString(userId));
            rst = pstm.executeQuery();
            while (rst.next()) {
                int i = rst.getInt("photo_id");
                photoId.add(i);
            }
            String sql = "UPDATE user_photo SET status = 0 WHERE user_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, Integer.toString(userId));
            pstm.executeUpdate();
        }catch (SQLException e){
            e.printStackTrace();
        }
        return photoId;
    }


    public ArrayList<Integer> photoCheck(String userId) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        ArrayList<Integer> photoId = new ArrayList<Integer>();
        try{
            //查询图片Id
            String sql = "select photo_id from user_photo WHERE user_id = ? and status!=0";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, userId);
            rst = pstm.executeQuery();
            while (rst.next()) {
                int i = rst.getInt("photo_id");
                photoId.add(i);
            }
        }catch (SQLException e){
            e.printStackTrace();
        }
        return photoId;
    }
}
