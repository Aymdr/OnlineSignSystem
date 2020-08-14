package com.Bean;
/***
 * 创建一个用户的数据库操作类
 *
 */
public class User {
    private int id;
    private String name;
    private String password;
    private String device_id;

    public User( String name, String password,String uid) {
        this.id = id;
        this.name = name;
        this.password = password;
        this.device_id = uid;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDevice_id() {
        return device_id;
    }

    public void setDevice_id(String uid) {
        this.device_id = uid;
    }
}
