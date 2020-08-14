package com.DAO;

import java.sql.*;
import java.util.ArrayList;

import com.Bean.User;
import DB.db_con;
import net.sf.json.JSONObject;

/*
包含对用户信息的增删改查操作
增删改只有管理员权限可以使用
 */
public class userDAO {
    private ResultSet rst = null;

    public userDAO() {

    }

    //增加用户
    public int user_add(String userid, String usname, String username, String password, String device_id) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        ResultSet rs;
        int k = 0;
        /*
        本方法的输入参数，目前的两个信息都是来自注册的jsp页面中管理员填写。
        根据从前台传过来的信息，给数据库添加新的信息。
         */
        try {
            String sql1 = "select count(*) as cont from users where (user_id = ? or user_name = ?) and status = 1";
            pstm = conn.prepareStatement(sql1);
            pstm.setString(1, userid);
            pstm.setString(2, username);
            rs = pstm.executeQuery();
            int flag = 1;
            if (rs.next()) {
                flag = rs.getInt("cont");
            }
            String sql2 = "select count(*) as cont from users where (user_id = ? or user_name = ?) and status = 0";
            pstm = conn.prepareStatement(sql2);
            pstm.setString(1, userid);
            pstm.setString(2, username);
            rs = pstm.executeQuery();
            int flag1 = 1;
            if (rs.next()) {
                flag1 = rs.getInt("cont");
            }
            if(flag1 != 0){
                try {
                    String sql = "UPDATE users SET status = 1 and name_user = ? and password = ? and device_id = ? and user_name= ? where user_id = ?";
                    pstm = conn.prepareStatement(sql);
                    pstm.setString(1, usname);
                    pstm.setString(2, password);
                    pstm.setString(3, device_id);
                    pstm.setString(4, username);
                    pstm.setString(5, userid);
                    k = pstm.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (flag == 0) {
                String sql = "insert into users(user_id,user_name,password,device_id,name_user) values (?,?,?,?,?)";
                pstm = conn.prepareStatement(sql);
                pstm.setString(1, userid);
                pstm.setString(2, username);
                pstm.setString(3, password);
                pstm.setString(4, device_id);
                pstm.setString(5, usname);
                System.out.println(username);
                k = pstm.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    //查
    public boolean login_check(User uu) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        try {
            String sql = "select * from users where(user_name=? and password=? and device_id=? and status=1)";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, uu.getName());
            pstm.setString(2, uu.getPassword());
            pstm.setString(3, uu.getDevice_id());
            rst = pstm.executeQuery();
            if (rst.next())
                return true;
            else
                return false;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }


    public ArrayList<JSONObject> userCheck(String name) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        ArrayList<JSONObject> array = new ArrayList<JSONObject>();
        try {
            String sql = "select * from users where (status=1 and user_name!=?)";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, name);
            rst = pstm.executeQuery();
            while (rst.next()) {
                if (rst.getString("user_name").equals("admin"))
                    continue;
                JSONObject bean = new JSONObject();
                bean.put("user_id", rst.getString("user_id"));
                bean.put("user_name", rst.getString("user_name"));
                bean.put("name_user", rst.getString("name_user"));
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

    //获取所有用户信息
    public ArrayList<JSONObject> userInfo() throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        ArrayList<JSONObject> array = new ArrayList<JSONObject>();
        try {
            String sql = "select * from users where (status=1 and user_name!=?)";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, "admin");
            rst = pstm.executeQuery();
            while (rst.next()) {
                JSONObject bean = new JSONObject();
                bean.put("user_id", rst.getString("user_id"));
                bean.put("name_user", rst.getString("name_user"));
                bean.put("user_name", rst.getString("user_name"));
                bean.put("Password", rst.getString("password"));
                bean.put("device_id", rst.getString("device_id"));
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

    //删除
    public int userDelete(int userId) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        /*
            上传图片路径和名称
         */
        try {
            String sql = "UPDATE users SET status = 0 WHERE user_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, Integer.toString(userId));
            k = pstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    public String userIDCheck(String username) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        String result = "";
        try{
            String sql = "select user_id from users where user_name = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, username);
            rst = pstm.executeQuery();
            while (rst.next()) {
                result = rst.getString("user_id");
            }
            pstm.close();
            rst.close();
        }catch (SQLException e){
            e.printStackTrace();
        }
        return result;
    }

    public String nameCheck(String username) throws Exception{
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        String result = "";
        try{
            String sql = "select name_user from users where user_name = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, username);
            rst = pstm.executeQuery();
            while (rst.next()) {
                result = rst.getString("name_user");
            }
            pstm.close();
            rst.close();
        }catch (SQLException e){
            e.printStackTrace();
        }
        return result;
    }
}