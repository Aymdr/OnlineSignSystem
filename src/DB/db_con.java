package DB;
/***
 * 数据库的建立打开与关闭
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class db_con {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    private String className; //驱动名
    private String url; //连接数据库的URL地址
    private String username; //数据库的用户名
    private String password; //数据库的密码
    //打开连接
    public Connection getConn(){
        String DRIVER = "com.mysql.jdbc.Driver";
        className="com.mysql.jdbc.Driver";
        url="jdbc:mysql://localhost:3306/stamp";
        username="root";
        password="123456";
        try{
            Class.forName(DRIVER);
            conn = DriverManager.getConnection(url,username,password);
        }catch(Exception e){
            e.printStackTrace();
        }
        return conn;
    }
    //关闭连接
    public void closeAll(){
        try{
            if(rs != null){
                rs.close();
            }
        }catch(SQLException e){
            e.printStackTrace();
        }finally{
            try{
                if(ps != null){
                    ps.close();
                }
            }catch(SQLException e){
                e.printStackTrace();
            }finally{
                try{
                    if(conn != null){
                        conn.close();
                    }
                }catch (SQLException e){
                    e.printStackTrace();
                }
            }
        }

    }
    //执行sql语句，可以进行查询
    public ResultSet executeQuery(String preparedSql,String []param){
        try{
            ps = conn.prepareStatement(preparedSql);
            if(param != null){
                for (int i = 0; i < param.length; i++) {
                    ps.setString(i + 1, param[i]);
                }
            }
            rs = ps.executeQuery();
        }catch(SQLException e){
            e.printStackTrace();
        }
        return rs;

    }
    //执行sql语句，增加，修改，删除
    public int executeUpdate(String preparedSql,String[]param){
        int num = 0;
        try{
            ps = conn.prepareStatement(preparedSql);
            if(ps != null){
                for (int i = 0; i < param.length; i++) {
                    ps.setString(i + 1, param[i]);
                }
            }
            if (ps != null) {
                num = ps.executeUpdate();
            }
        }catch(SQLException e){
            e.printStackTrace();
        }
        return num;
    }
}
