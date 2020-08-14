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

public class PdfFileDAO {
    private String logPath = "E:\\OnlineSignSystem\\log\\";
    private ResultSet rst = null;

    public PdfFileDAO() {

    }

    //添加PDF文件
    public int pdfAdd(String pdfName, String pdfPath, String startTime, String startUser, String endUser, int fileType, int status, String startName,String endName) throws Exception {
        fileHandle fileLog = new fileHandle();
        db_con db = new db_con();
        Connection conn = db.getConn();
        String endTime;
        endTime = startTime;
        int k = 0;
        PreparedStatement pstm;
        try {
            //上传图片路径和名称
            String sql = "insert into pdf_files(file_name, file_path, start_time, end_time, start_user, start_name, end_user, end_name, file_type, status) values (?,?,?,?,?,?,?,?,?,?)";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, pdfName);
            pstm.setString(2, pdfPath);
            pstm.setString(3, startTime);
            pstm.setString(4, endTime);
            pstm.setString(5, startUser);
            pstm.setString(6, startName);
            pstm.setString(7, endUser);
            pstm.setString(8, endName);
            pstm.setString(9, Integer.toString(fileType));
            pstm.setString(10, Integer.toString(status));
            k = pstm.executeUpdate();
            String finalPath = logPath + startUser + ".txt";
            String content = "添加文件 " + startTime + "  " + endTime + "  " + pdfName + "  " + startUser + "  " + endUser;
            boolean flag = fileLog.writeTxtFileAppend(finalPath, content);
            pstm.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    //查
    public ArrayList<JSONObject> fileCheck(String userName, int status) {
        ArrayList<JSONObject> array = new ArrayList<JSONObject>();
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        try {
            if (status == 0) {
                // 查找当前用户全部文件
                String sql = "select * from pdf_files where end_user = ? and status!=0";
                pstm = conn.prepareStatement(sql);
                pstm.setString(1, userName);
                rst = pstm.executeQuery();
                String start_name = null;
                String end_name = null;
                while (rst.next()) {
                    JSONObject bean = new JSONObject();
                    bean.put("PDF_id", rst.getString("PDF_id"));
                    bean.put("file_name", rst.getString("file_name"));
                    bean.put("file_path", rst.getString("file_path"));
                    bean.put("start_time", rst.getString("start_time"));
                    bean.put("end_time", rst.getString("end_time"));
                    bean.put("start_user", rst.getString("start_user"));
                    bean.put("start_name", rst.getString("start_name"));
                    bean.put("end_user", rst.getString("end_user"));
                    bean.put("end_name", rst.getString("end_name"));
                    bean.put("file_type", rst.getString("file_type"));
                    bean.put("sign_status", rst.getString("status"));
                    array.add(bean);
                }
                pstm.close();
                rst.close();
            } else if (status == 1) {
                // 查找当前用户未完成文件
                String sql = "select * from pdf_files where end_user=? and status=1";
                pstm = conn.prepareStatement(sql);
                pstm.setString(1, userName);
                rst = pstm.executeQuery();
                while (rst.next()) {
                    JSONObject bean = new JSONObject();
                    bean.put("PDF_id", rst.getString("PDF_id"));
                    bean.put("file_name", rst.getString("file_name"));
                    bean.put("file_path", rst.getString("file_path"));
                    bean.put("start_time", rst.getString("start_time"));
                    bean.put("end_time", rst.getString("end_time"));
                    bean.put("start_user", rst.getString("start_user"));
                    bean.put("start_name", rst.getString("start_name"));
                    bean.put("end_user", rst.getString("end_user"));
                    bean.put("end_name", rst.getString("end_name"));
                    bean.put("file_type", rst.getString("file_type"));
                    bean.put("sign_status", rst.getString("status"));
                    array.add(bean);
                }
                pstm.close();
                rst.close();
            } else if (status == 2) {
                // 查找当前用户已完成文件
                String sql = "select * from pdf_files where end_user=? and status=2";
                pstm = conn.prepareStatement(sql);
                pstm.setString(1, userName);
                rst = pstm.executeQuery();
                while (rst.next()) {
                    JSONObject bean = new JSONObject();
                    bean.put("PDF_id", rst.getString("PDF_id"));
                    bean.put("file_name", rst.getString("file_name"));
                    bean.put("file_path", rst.getString("file_path"));
                    bean.put("start_time", rst.getString("start_time"));
                    bean.put("end_time", rst.getString("end_time"));
                    bean.put("start_user", rst.getString("start_user"));
                    bean.put("start_name", rst.getString("start_name"));
                    bean.put("end_user", rst.getString("end_user"));
                    bean.put("end_name", rst.getString("end_name"));
                    bean.put("file_type", rst.getString("file_type"));
                    bean.put("sign_status", rst.getString("status"));
                    array.add(bean);
                }
                pstm.close();
                rst.close();
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
        return array;
    }

    //搜索功能
    public ArrayList<JSONObject> fileSearch(String userName, int status, String fileName, int filetype) {
        ArrayList<JSONObject> array = new ArrayList<JSONObject>();
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        String whereClause = "(start_user='" + userName + "' or end_user='" + userName + "')";
        if (fileName != null && fileName.trim().length() != 0) {
            if (whereClause.length() != 0) {
                whereClause += " AND file_name LIKE '%" + fileName + "%'";
            }
        }
        if (filetype != 0) {
            if (whereClause.length() == 0) {
                whereClause += " file_type = " + Integer.toString(filetype);
            } else {
                whereClause += " AND file_type = " + Integer.toString(filetype);
            }
        }
        if (whereClause.length() != 0) {
            whereClause = "WHERE " + whereClause;
        }
        try {
            String sql = "select * from pdf_files " + whereClause;
            pstm = conn.prepareStatement(sql);
            rst = pstm.executeQuery();
            while (rst.next()) {
                JSONObject bean = new JSONObject();
                bean.put("PDF_id", rst.getString("PDF_id"));
                bean.put("file_name", rst.getString("file_name"));
                bean.put("file_path", rst.getString("file_path"));
                bean.put("start_time", rst.getString("start_time"));
                bean.put("end_time", rst.getString("end_time"));
                bean.put("start_user", rst.getString("start_user"));
                bean.put("start_name", rst.getString("start_name"));
                bean.put("end_user", rst.getString("end_user"));
                bean.put("end_name", rst.getString("end_name"));
                bean.put("file_type", rst.getString("file_type"));
                bean.put("sign_status", rst.getString("status"));
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

    //文件删除
    public int fileDelete(int fileId) throws Exception {
        fileHandle fileLog = new fileHandle();
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        try {
            String sql1 = "select * from pdf_files where PDF_id= ?";
            pstm = conn.prepareStatement(sql1);
            pstm.setString(1, Integer.toString(fileId));
            rst = pstm.executeQuery();
            String startUser = null;
            String endUser = null;
            String pdfName = null;
            while (rst.next()) {
                startUser = rst.getString("start_user");
                endUser = rst.getString("end_user");
                pdfName = rst.getString("file_name");
            }
            String sql = "UPDATE pdf_files SET status = 0 WHERE PDF_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, Integer.toString(fileId));
            k = pstm.executeUpdate();
            Date date = new Date();
            String datePath = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
            String startTime = datePath.replaceAll(" ", "+");
            String finalPath = logPath + endUser + ".txt";
            String content = "删除文件 " + startTime + "  " + pdfName + "  " + startUser + "  " + endUser;
            boolean flag = fileLog.writeTxtFileAppend(finalPath, content);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }

    //将文件更改为已完成
    public int fileChange(String fileId) throws Exception {
        db_con db = new db_con();
        Connection conn = db.getConn();
        PreparedStatement pstm;
        int k = 0;
        Date date = new Date();
        String datePath = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
        String nowTime = datePath.replaceAll(" ", "+");
        try {
            String sql = "UPDATE pdf_files SET status = 2, end_time=? WHERE PDF_id = ?";
            pstm = conn.prepareStatement(sql);
            pstm.setString(1, nowTime);
            pstm.setString(2, fileId);
            k = pstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return k;
    }
}
