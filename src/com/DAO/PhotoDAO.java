package com.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import DB.db_con;
import net.sf.json.JSONObject;
import servlet.fileHandle;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.sql.SQLException;
import java.util.Date;

public class PhotoDAO {
    //本地绝对路径
    private String logPath = "E:\\OnlineSignSystem\\log\\";
    private ResultSet rst = null;

    public PhotoDAO() {
    }

    //增加用户
    public int photoAdd(String PhotoPath, String PhotoName, int statu, String owner, int alloction) throws Exception {
        fileHandle fileLog = new fileHandle();
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        try {
            //上传图片路径和名称
            String sql = "insert into photo(photo_path, photo_name, status, owner,alloction) values (?,?,1,?,0)";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, PhotoPath);
            pstm.setString(2, PhotoName);
            pstm.setString(3, owner);
            k = pstm.executeUpdate();
            Date date = new Date();
            String datePath = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
            String startTime = datePath.replaceAll(" ", "+");
            String finalPath = logPath + "admin.txt";
            String content = "添加签章 " + startTime + "  " + "  " + PhotoName;
            boolean flag = fileLog.writeTxtFileAppend(finalPath, content);
            pstm.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    //增加用户与签章关联关系
    public int photoUserAdd(int Pic_id, String UserName, int statu) throws Exception {
        fileHandle fileLog = new fileHandle();
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        try {
            String sql1 = "select * from photo where pic_id= ?";
            pstm = conn.prepareStatement(sql1);
            pstm.setString(1, Integer.toString(Pic_id));
            rst = pstm.executeQuery();
            String PhotoName = null;
            while (rst.next()) {
                PhotoName = rst.getString("photo_name");
            }
            //分配
            String sql = "update photo set owner = ?, alloction = 1 where pic_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, UserName);
            pstm.setString(2, Integer.toString(Pic_id));
            k = pstm.executeUpdate();
            pstm.close();
            Date date = new Date();
            String datePath = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
            String startTime = datePath.replaceAll(" ", "+");
            String finalPath = logPath + "admin.txt";
            String content = "分配签章 " + startTime + "  " + "  " + PhotoName + "  " + UserName;
            boolean flag = fileLog.writeTxtFileAppend(finalPath, content);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    //查
    public ArrayList<JSONObject> photoCheck() throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        ArrayList<JSONObject> array = new ArrayList<JSONObject>();
        try {
            String sql = "select * from photo where status=1";
            pstm = conn.prepareStatement(sql);
            rst = pstm.executeQuery();
            while (rst.next()) {
                JSONObject bean = new JSONObject();
                bean.put("pic_id", rst.getString("pic_id"));
                bean.put("photo_name", rst.getString("photo_name"));
                bean.put("photo_path", rst.getString("photo_path"));
                bean.put("owner", rst.getString("owner"));
                bean.put("alloction", rst.getString("alloction"));
                array.add(bean);
            }
            pstm.close();
            rst.close();
            return array;
        } catch (SQLException e) {
            System.out.println("Error occured at DesignReportDAO->select_all()");
            return array;
        } finally {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error occured at closing connection in DesignReportDAO");
            }
        }
    }

    //删除用户
    public int photoDelete(int photoId) throws Exception {
        fileHandle fileLog = new fileHandle();
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        try {
            String sql1 = "select * from photo where pic_id= ?";
            pstm = conn.prepareStatement(sql1);
            pstm.setString(1, Integer.toString(photoId));
            rst = pstm.executeQuery();
            String PhotoName = null;
            while (rst.next()) {
                PhotoName = rst.getString("photo_name");
            }
            String sql = "UPDATE photo SET status = 0 WHERE pic_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, Integer.toString(photoId));
            k = pstm.executeUpdate();
            Date date = new Date();
            String datePath = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
            String startTime = datePath.replaceAll(" ", "+");
            String finalPath = logPath + "admin.txt";
            String content = "删除签章 " + startTime + "  " + "  " + PhotoName;
            boolean flag = fileLog.writeTxtFileAppend(finalPath, content);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    //更改拥有者
    public int photoUpdate(int photoId, String name) throws Exception {
        fileHandle fileLog = new fileHandle();
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k=0;
        try{
            String sql1 = "select * from photo where pic_id= ?";
            pstm = conn.prepareStatement(sql1);
            pstm.setString(1, Integer.toString(photoId));
            rst = pstm.executeQuery();
            String PhotoName = null;
            while (rst.next()) {
                PhotoName = rst.getString("photo_name");
            }
            String sql = "UPDATE photo SET owner = ? WHERE pic_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, name);
            pstm.setString(2, Integer.toString(photoId));
            k = pstm.executeUpdate();
            Date date = new Date();
            String datePath = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
            String startTime = datePath.replaceAll(" ", "+");
            String finalPath = logPath + "admin.txt";
            String content = "重新分配签章 " + startTime + "  " + "  " + PhotoName + "  " + name;
            boolean flag = fileLog.writeTxtFileAppend(finalPath, content);
        }catch (SQLException e){
            e.printStackTrace();
        }
        return k;
    }

    public ArrayList<JSONObject> photoNameCheck(ArrayList<Integer> photoId) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        ArrayList<JSONObject> array = new ArrayList<JSONObject>();
        PreparedStatement pstm = null;
        try {
            if (photoId.size() != 0) {
                for (Integer aPhotoId : photoId) {
                    String sql = "select photo_name from photo where (status=1 and pic_id =?)";
                    pstm = conn.prepareStatement(sql);
                    pstm.setString(1, Integer.toString(aPhotoId));
                    rst = pstm.executeQuery();
                    while (rst.next()) {
                        JSONObject bean = new JSONObject();
                        String resultName = rst.getString("photo_name");
                        bean.put("photo_name", resultName);
                        array.add(bean);
                    }
                }
                pstm.close();
                rst.close();
                return array;
            } else {
                return array;
            }
        } catch (SQLException e) {
            System.out.println("Error occured at DesignReportDAO->select_all()");
            return array;
        } finally {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error occured at closing connection in DesignReportDAO");
            }
        }
    }
    //印章用户关系删除
    public int photoUserDelete(ArrayList<Integer> photoId) {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 1;
        try {
            if (photoId.size() != 0) {
                for (int i = 0; i < photoId.size(); i++) {
                    String sql = "update photo set owner='', alloction=0 where (status=1 and pic_id =?)";
                    pstm = conn.prepareStatement(sql);
                    pstm.setString(1, Integer.toString(photoId.get(i)));
                    k = pstm.executeUpdate();
                    if (k == 0) {
                        return k;
                    }
                }
                return k;
            } else {
                return k;
            }
        } catch (SQLException e) {
            System.out.println("Error occured at DesignReportDAO->select_all()");
            return 0;
        } finally {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error occured at closing connection in DesignReportDAO");
            }
        }
    }

}
