package servlet;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

/**
 * @author Aymdr
 * 上传图片处理
 */

public class ImageRead {
    BufferedImage bi = null;
    BufferedImage bii = null;
    BufferedImage biii = null;
    int minX = 0;
    int maxX = 0;
    int minY = 0;
    int maxY = 0;

    public void getImagePixel(String image, int flag1) throws IOException {
        //读取图片文件
        File file = new File(image);
        try {
            bi = ImageIO.read(file);
        } catch (Exception e) {
            e.printStackTrace();
        }
        int w = 2470;
        int h = 3519;
        int width = bi.getWidth();
        int height = bi.getHeight();
        if (width / height > w / h) {
            //以宽度为标准，等比例压缩图片
            h = (int) (height * w / width);
        }else {
            w = (int) (width * h / height);
        }

        biii = new BufferedImage(w, h,BufferedImage.TYPE_INT_RGB );
        biii.getGraphics().drawImage(bi, 0, 0, w, h, null); // 绘制缩小后的图


        int flag = 0;
        int[][] imageArray = new int[width][height];

        //输出每一个像素点的color
        for (int i = 0; i < w; i++) {
            for (int j = 0; j < h; j++) {
                // 下面三行代码将一个数字转换为RGB数字
                int pixel = biii.getRGB(i, j);
                float R = (pixel & 0xff0000) >> 16;
                float G = (pixel & 0xff00) >> 8;
                float B = (pixel & 0xff);
                if (flag1 == 1) {
                    if ( R >= 128 && G/R < 0.25 && B/R < 0.5) {
                        if (flag == 0) {
                            minX = i;
                            maxX = i;
                            minY = j;
                            maxY = j;
                            flag = 1;
                        } else {
                            if (i > maxX) {
                                maxX = i;
                            }
                            if (j < minY) {
                                minY = j;
                            }
                            if (j > maxY) {
                                maxY = j;
                            }
                        }
                    }
                }
            }
        }
        if(maxX-minX<=490){
            minX = minX - (490-(maxX-minX));
        }else{
            minX = minX + ((maxX-minX)-490);
        }
//        if(maxY-minY<=490){
//            minY = minY - (490-(maxY-minY));
//        }else{
//            minY = minY + ((maxY-minY)-490);
//        }
    }

    //图像裁剪
    public static BufferedImage img_tailor(BufferedImage src, int x, int y, int width, int height) {
        BufferedImage back = src.getSubimage(x, y, width, height);
        return back;
    }

    //写入图像
    public static void img2file(BufferedImage img, String extent, String newfile) {
        try {
            ImageIO.write(img, extent, new File(newfile));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //比例转换
    public static float getInch(float x1, float y1, float x) {
        return (y1 / x1) * x;
    }
}
