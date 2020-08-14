package com.Bean;

/***
 * 创建一个PDF的数据库操作类
 *
 */
public class PdfFile {
    private int id;
    private String file_name;
    private String start_time;
    private String start_user;
    private String end_time;
    private String end_user;
    private String file_type;
    private String file_path;
    private int status;

    public PdfFile(int id, String file_name, String start_time, String start_user, String file_type, String file_path, int status) {
        this.id = id;
        this.file_name = file_name;
        this.start_time = start_time;
        this.start_user = start_user;
        this.file_type = file_type;
        this.file_path = file_path;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFile_name() {
        return file_name;
    }

    public void setFile_name(String file_name) {
        this.file_name = file_name;
    }

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public String getStart_user() {
        return start_user;
    }

    public void setStart_user(String start_user) {
        this.start_user = start_user;
    }

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }

    public String getEnd_user() {
        return end_user;
    }

    public void setEnd_user(String end_user) {
        this.end_user = end_user;
    }

    public String getFile_type() {
        return file_type;
    }

    public void setFile_type(String file_type) {
        this.file_type = file_type;
    }

    public String getFile_path() {
        return file_path;
    }

    public void setFile_path(String file_path) {
        this.file_path = file_path;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
