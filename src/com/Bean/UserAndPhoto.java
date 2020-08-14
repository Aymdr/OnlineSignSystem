package com.Bean;
/***
 * 创建一个用户与签章关系的数据库操作类
 *
 */
public class UserAndPhoto {
    private int tabId;
    private int photoId;
    private int userId;
    private int statu;

    public UserAndPhoto(int tabId, int photoId, int userId, int statu) {
        this.tabId = tabId;
        this.photoId = photoId;
        this.userId = userId;
        this.statu = statu;
    }

    public UserAndPhoto() {
        
    }

    public int getTabId() {
        return tabId;
    }

    public void setTabId(int tabId) {
        this.tabId = tabId;
    }

    public int getPhotoId() {
        return photoId;
    }

    public void setPhotoId(int photoId) {
        this.photoId = photoId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getStatu() {
        return statu;
    }

    public void setStatu(int statu) {
        this.statu = statu;
    }
}
