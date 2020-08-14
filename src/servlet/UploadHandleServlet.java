package servlet;

import java.io.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.DAO.PdfFileDAO;
import com.DAO.userDAO;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import net.sf.json.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.http.HttpSession;

/**
 * @author Aymdr
 * @time 2020/3/31
 */
public class UploadHandleServlet extends HttpServlet {
    private static String picPath = "E:/OnlineSignSystem/resource/";

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //得到上传文件的保存目录，将上传的文件存放于WEB-INF目录下，不允许外界直接访问，保证上传文件的安全
        String savePath = this.getServletContext().getRealPath("/files");
        //上传时生成的临时文件保存目录
        String tempPath = this.getServletContext().getRealPath("/WEB-INF/temp");
        String tempPathFile = this.getServletContext().getRealPath("/WEB-INF/tempFile");
        File tmpFile = new File(tempPath);
        // 之后要用到的变量
        String point_x = "";
        String point_y = "";
        String signPage = "";
        int signMode = 0;
        int totalPage = 0;
        String filename = "";
        String fileExtName = "";
        // 文件保存的名称
        String saveFilename = "";
        String realSavePath = "";
        String pngName = "";
        String startName = "";
        String endName = "";
        String fileType = "";
        String starter = "";
        if (!tmpFile.exists()) {
            //创建临时目录
            tmpFile.mkdir();
        }
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(1024 * 100);
            //设置上传时生成的临时文件的保存目录
            factory.setRepository(tmpFile);
            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("UTF-8");
            if (!ServletFileUpload.isMultipartContent(request)) {
                return;
            }
            //设置上传单个文件的大小的最大值，100MB
            upload.setFileSizeMax(100 * 1024 * 1024);
            //设置上传文件总量的最大值，最大值=同时上传的多个文件的大小的最大值的和，目前设置为10MB
            upload.setSizeMax(1024 * 1024 * 200);
            //使用ServletFileUpload解析器解析上传数据，解析结果返回的是一个List<FileItem>集合，每一个FileItem对应一个Form表单的输入项
            List<FileItem> list = upload.parseRequest(request);
            for (FileItem item : list) {
                //如果fileitem中封装的是普通输入项的数据
                if (item.isFormField()) {
                    String name = item.getFieldName();
                    String value = item.getString("UTF-8");
                    if ("sign_x".equals(name)) {
                        point_x = value;
                    }
                    if ("sign_y".equals(name)) {
                        point_y = value;
                    }
                    if ("signPage".equals(name)) {
                        signPage = value;
                    }
                    if ("signMode".equals(name)) {
                        signMode = Integer.parseInt(value);
                    }
                    if ("totalPage".equals(name)) {
                        totalPage = Integer.parseInt(value);
                    }
                    if ("pngName".equals(name)) {
                        pngName = value;
                    }
                    if ("startName".equals(name)) {
                        startName = value;
                    }
                    if ("endName".equals(name)) {
                        endName = value;
                    }
                    if ("fileType".equals(name)) {
                        fileType = value;
                    }
                } else {
                    //如果fileitem中封装的是上传文件
                    filename = item.getName();
                    if (filename == null || filename.trim().equals("")) {
                        continue;
                    }
                    //保留文件名部分，例如：xxx.pdf
                    filename = filename.substring(filename.lastIndexOf("\\") + 1);

//                    if(endName != "无"){
//                        if(filename.split("\\+")[0]==filename){
//                            filename = startName+"+"+filename;
//                        }else {
//                            starter = filename.split("\\+")[0];
//                        }
//                    }


                    //得到上传文件的扩展名，例如pdf
                    fileExtName = filename.substring(filename.lastIndexOf(".") + 1);
                    //如果需要限制上传的文件类型，那么可以通过文件的扩展名来判断上传的文件类型是否合法

                    //获取item中的上传文件的输入流
                    InputStream in = item.getInputStream();
                    //得到文件保存的名称
                    saveFilename = makeFileName(filename);
                    //得到文件的保存目录，该目录用于缓冲上传文件的临时目录
                    realSavePath = makePath(savePath, startName, endName);
                    //创建一个文件输出流
                    FileOutputStream out = new FileOutputStream(realSavePath + "\\" + saveFilename);
                    //创建一个缓冲区
                    byte buffer[] = new byte[1024];
                    //判断输入流中的数据是否已经读完的标识
                    int len = 0;
                    //循环将输入流读入到缓冲区当中，(len=in.read(buffer))>0就表示in里面还有数据
                    while ((len = in.read(buffer)) > 0) {
                        //使用FileOutputStream输出流将缓冲区的数据写入到指定的目录(savePath + "\\" + filename)当中
                        out.write(buffer, 0, len);
                    }
                    //关闭输入流
                    in.close();
                    //关闭输出流
                    out.close();
                    //删除处理文件上传时生成的临时文件
                    item.delete();
                }
            }
        } catch (FileUploadBase.FileSizeLimitExceededException e) {
            e.printStackTrace();
            request.setAttribute("message", "单个文件超出最大值！！！");
            return;
        } catch (FileUploadBase.SizeLimitExceededException e) {
            e.printStackTrace();
            request.setAttribute("message", "上传文件的总的大小超出限制的最大值！！！");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }
        //删除临时文件
        deleteFile(new File(tempPathFile));
        /*
            接下来的过程是对PDF文件盖章
         */

        int result = signPic(realSavePath, saveFilename, filename, pngName, signMode, point_x, point_y, signPage, startName, endName, fileType,starter);
        JSONObject object = new JSONObject();
        object.put("result", result);
        // 再次删除临时文件
        deleteFile(new File(tempPathFile));
        // 向客户端返回信息
        response.setContentType("text/html;charset=utf-8");
        PrintWriter pw = response.getWriter();
        pw.print(object.toString());
    }

    // 盖章
    private int signPic(String realSavePath, String saveFilename, String filename, String pngName, int signMode, String point_x, String point_y, String signPage, String startName, String endName, String fileType,String starter) {
        int flag = 0;
        String SignPDFSrc = realSavePath + '/' + saveFilename;
        // 目标文件路径及文件流
        String PDFPath = realSavePath + "/" + filename;
        FileOutputStream f = null;
        PdfFileDAO pdfFile = new PdfFileDAO();
        userDAO users = new userDAO();
        try {
            f = new FileOutputStream(new File(PDFPath));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        // 不同盖章模式下的处理方式，0代表单页盖章，1代表多页盖章，2代表除首页盖章
        if (signMode == 0) {
            try {
                imagePdf(pngName, SignPDFSrc, PDFPath, point_x, point_y, 0, signPage, f);
                f.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (signMode == 1) {
            try {
                imagePdf(pngName, SignPDFSrc, PDFPath, point_x, point_y, 1, signPage, f);
                f.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if (signMode == 2) {
            try {
                imagePdf(pngName, SignPDFSrc, PDFPath, point_x, point_y, 2, signPage, f);
                f.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        File resultFile = new File(PDFPath);
        File originFile = new File(SignPDFSrc);
        Date date = new Date();
        String datePath = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
        String startTime = datePath.replaceAll(" ", "+");
        // 0为无效文件，1为未完成，2为已完成
        int status = 0;
        if (resultFile.exists()) {
            if (endName.equals("无")) {
                status = 2;
            } else {
                status = 1;
            }
            try {
                int fileStatus = 0;
                if (fileType.equals("政府采购类")) {
                    fileStatus = 1;
                } else if (fileType.equals("工程建设类")) {
                    fileStatus = 2;
                } else if (fileType.equals("公文类")) {
                    fileStatus = 3;
                } else {
                    fileStatus = 4;
                }
                if (endName.equals("无")) {
                    endName = startName;
                }
                if (filename == "" || PDFPath == "" || startTime == "" || startName == "" || fileStatus == 0) {
                    flag = 0;
                } else {
                    String start_name = users.nameCheck(startName);
                    String end_name = users.nameCheck(endName);
                    flag = pdfFile.pdfAdd(filename, PDFPath, startTime, startName, endName, fileStatus, status,start_name,end_name);
                }
                if (flag == 1) {
                    System.out.println("插入成功！");

                } else {
                    System.out.println("插入失败！");

                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            originFile.delete();
        }
        return flag;
    }

    // 删除文件
    private static void deleteFile(File file) {
        //判断文件不为null或文件目录存在
        if (file == null || !file.exists()) {
            System.out.println("文件删除失败,请检查文件路径是否正确");
            return;
        }
        //取得这个目录下的所有子文件对象
        File[] files = file.listFiles();
        //遍历该目录下的文件对象
        if (files != null) {
            for (File f : files) {
                //打印文件名
                String name = f.getName();
                //判断子目录是否存在子目录,如果是文件则删除
                if (f.isDirectory()) {
                    deleteFile(f);
                } else {
                    f.delete();
                    System.out.println(name);
                }
            }
        } else {
            return;
        }
    }

    // 生成上传文件的文件名
    private String makeFileName(String filename) {
        //为防止文件覆盖的现象发生，要为上传文件产生一个唯一的文件名
        return UUID.randomUUID().toString() + "_" + filename;
    }

    // 为防止一个目录下面出现太多文件，要使用hash算法打散存储
    private String makePath(String savePath, String sendName, String receiveName) {
        Date date = new Date();
        String datePath = new SimpleDateFormat("yyyy-MM").format(date);
        String dir = null;
        //构造新的保存目录，例如upload/zhangxiang/finished/2020-05
        if (!receiveName.equals("无")) {
            // 说明文件要发给下一个人进行处理，将文件直接存在下一个人的待处理区
            dir = savePath + "\\" + receiveName + "\\" + "unfinished" + "\\" + datePath;
        } else {
            // 说明文件不对外发，盖好章后直接存储在本人已完成区
            dir = savePath + "\\" + sendName + "\\" + "finished" + "\\" + datePath;
        }
        //File既可以代表文件也可以代表目录
        File file = new File(dir);
        //如果目录不存在
        if (!file.exists()) {
            //创建目录
            file.mkdirs();
        }
        return dir;
    }

    // 盖章主函数，本质上是在PDF文件上添加图片域
    private static void imagePdf(String pngName, String urlPdf, String pdfUrl, String point_x, String point_y, int mode, String signPage, FileOutputStream f) throws Exception {
        String[] splitX = point_x.split("\\,");
        String[] splitY = point_y.split("\\,");
        String[] splitName = pngName.split("\\,");
        String[] splitPage = signPage.split("\\,");


        PdfReader reader = new PdfReader(urlPdf, "PDF".getBytes());
        //加了水印后要输出的路径
        PdfStamper stamp = new PdfStamper(reader, f);
        int pageSize = reader.getNumberOfPages();
        float rate = ((float)119/495)*100;
        if (mode == 0) {
            for (int i = 1; i < splitX.length; i++) {
                Float x = Float.parseFloat(splitX[i]);
                Float y = Float.parseFloat(splitY[i]);
                String name = splitName[i];
                int page = Integer.parseInt(splitPage[i]);
                String urljPG = picPath + '/' + name ;
                // 插入水印
                Image img = Image.getInstance(urljPG);
                //原pdf文件的总页数

                //印章位置
                img.setAbsolutePosition(x, y);
                //印章大小，72/300=0.24
                img.scalePercent(rate);
                PdfContentByte under = stamp.getOverContent(page);
                under.addImage(img);
            }
        } else if (mode == 1) {
            for (int j = 1; j <= pageSize; j++) {
                for (int i = 1; i < splitX.length; i++) {
                    Float x = Float.parseFloat(splitX[i]);
                    Float y = Float.parseFloat(splitY[i]);
                    String name = splitName[i];
                    int page = Integer.parseInt(splitPage[i]);
                    String urljPG = picPath + '/' + name ;
                    // 插入水印
                    Image img = Image.getInstance(urljPG);
                    //印章位置
                    img.setAbsolutePosition(x, y);
                    //印章大小，72/300=0.24
                    img.scalePercent(rate);
                    PdfContentByte under = stamp.getOverContent(j);
                    under.addImage(img);
                }
            }
        } else if (mode == 2) {
            for (int j = 2; j <= pageSize; j++) {
                for (int i = 1; i < splitX.length; i++) {
                    Float x = Float.parseFloat(splitX[i]);
                    Float y = Float.parseFloat(splitY[i]);
                    String name = splitName[i];
                    int page = Integer.parseInt(splitPage[i]);
                    String urljPG = picPath + '/' + name ;
                    // 插入水印
                    Image img = Image.getInstance(urljPG);
                    //印章位置
                    img.setAbsolutePosition(x, y);
                    //印章大小，72/300=0.24

                    img.scalePercent(rate);
                    PdfContentByte under = stamp.getOverContent(j);
                    under.addImage(img);
                }
            }
        }
        // 关闭
        stamp.close();
        //关闭
        reader.close();
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}