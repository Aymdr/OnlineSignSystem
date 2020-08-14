package com.Bean;
/***
 * 创建一个签章的数据库操作类
 *
 */
public class Photo {
    private int id;
    private String photoPath;
    private String photoName;
    private int statu;

    public Photo(int id, String photoPath, String photoName, int statu) {
        this.id = id;
        this.photoPath = photoPath;
        this.photoName = photoName;
        this.statu = statu;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPhotoPath() {
        return photoPath;
    }

    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    public String getPhotoName() {
        return photoName;
    }

    public void setPhotoName(String photoName) {
        this.photoName = photoName;
    }

    public int getStatu() {
        return statu;
    }

    public void setStatu(int statu) {
        this.statu = statu;
    }
}
