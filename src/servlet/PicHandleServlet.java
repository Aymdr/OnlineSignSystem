package servlet;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServlet;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import com.DAO.PhotoDAO;
import java.io.File;
import java.io.IOException;
import net.sf.json.*;
/**
 * @author Aymdr
 * 图片处理
 */
public class PicHandleServlet extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String localPath = "E:/OnlineSignSystem/resource/";
        // 返回信息
        JSONObject jsonTemp=new JSONObject();
        PhotoDAO photoInfo =new PhotoDAO();

        //得到上传印章的保存目录，将上传的印章存放于WEB-INF目录下，不允许外界直接访问，保证上传文件的安全
        String savePath = this.getServletContext().getRealPath("/WEB-INF/upload");
        //上传时生成的临时文件保存目录
        String tempPath = this.getServletContext().getRealPath("/WEB-INF/temp");
        String tempPathFile = this.getServletContext().getRealPath("/WEB-INF/tempFile");
        File tmpFile = new File(tempPath);
        String filename="";
        String picName="";
        // 拓展名
        String fileExtName = "";
        // 文件保存的名称
        String saveFilename = "";
        String realSavePath = "";

        if (!tmpFile.exists()) {
            //创建临时目录
            tmpFile.mkdir();
        }
        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(1024 * 1000);
            factory.setRepository(tmpFile);
            ServletFileUpload upload = new ServletFileUpload(factory);
            //解决上传文件名的中文乱码
            upload.setHeaderEncoding("UTF-8");
            if (!ServletFileUpload.isMultipartContent(request)) {
                return;
            }
            upload.setFileSizeMax(50 * 1024 * 1024);
            //设置上传文件总量的最大值，最大值=同时上传的多个文件的大小的最大值的和，目前设置为100MB
            upload.setSizeMax(1024 * 1024 * 100);
            //使用ServletFileUpload解析器解析上传数据，解析结果返回的是一个List<FileItem>集合，每一个FileItem对应一个Form表单的输入项
            List<FileItem> list = upload.parseRequest(request);
            for (FileItem item : list) {
                //如果fileitem中封装的是普通输入项的数据
                if (item.isFormField()) {
                    String name = item.getFieldName();
                    //解决普通输入项的数据的中文乱码问题
                    String value = item.getString("UTF-8");
                } else {
                    //得到上传的文件名称，
                    filename = item.getName();
                    if (filename == null || filename.trim().equals("")) {
                        continue;
                    }
                    picName= filename.substring(filename.lastIndexOf("\\") + 1);
                    filename = filename.substring(filename.lastIndexOf("\\") + 1);
                    //得到上传文件的扩展名
                    fileExtName = filename.substring(filename.lastIndexOf(".") + 1);
                    //如果需要限制上传的文件类型，那么可以通过文件的扩展名来判断上传的文件类型是否合法

                    //获取item中的上传文件的输入流
                    InputStream in = item.getInputStream();
                    //得到文件保存的名称
                    saveFilename = makeFileName(filename);
                    //得到文件的保存目录
                    realSavePath = makePath(saveFilename, savePath);
                    //创建一个文件输出流
                    FileOutputStream out = new FileOutputStream(realSavePath + "\\" + saveFilename);
                    //创建一个缓冲区
                    byte buffer[] = new byte[1024];
                    //判断输入流中的数据是否已经读完的标识
                    int len = 0;
                    //循环将输入流读入到缓冲区当中，(len=in.read(buffer))>0就表示in里面还有数据
                    while ((len = in.read(buffer)) > 0) {
                        out.write(buffer, 0, len);
                    }
                    in.close();
                    out.close();
                    //删除处理文件上传时生成的临时文件
                    item.delete();
                }
            }
            // 将上传的印章提取出来
            // 清除临时文件
            deleteFile(new File(tempPathFile));
            // 待提取印章的上传文件
            String image = realSavePath + '/' + saveFilename;
            String resultImage = localPath;
            // 根据时间戳重命名文件名
            SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddhhmmss");
            String time = sf.format(new Date());
            String dirFilename = time + "+" + filename;
            // 最终得到的文件路径
            String resultName = resultImage + dirFilename;
            // 上传图片处理
            ImageRead example = new ImageRead();
            example.getImagePixel(image,1);
            // 裁剪出印章区域
            example.biii = ImageRead.img_tailor(example.biii,example.minX,example.minY,example.maxX-example.minX,example.maxY-example.minY);
            // 生成图片，透明化处理
//            example.img2file(example.biii,"jpg",resultName);
            picTransparency transprancyImage = new picTransparency();
            transprancyImage.image=example.biii;
            transprancyImage.image=transprancyImage.transparency(transprancyImage.image);
            transprancyImage.img2file(transprancyImage.image,"png",resultName);
            // 添加到数据库
            int flagPhoto = photoInfo.photoAdd(localPath,dirFilename,1,"",0);
            // 数据库添加成功，返回信息
            System.out.println(flagPhoto);
            if(flagPhoto!=0){
                jsonTemp.put("picFileName",dirFilename);
            }

        } catch (FileUploadBase.FileSizeLimitExceededException e) {
            e.printStackTrace();
            return;
        } catch (FileUploadBase.SizeLimitExceededException e) {
            e.printStackTrace();
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out=response.getWriter();
        out.println(jsonTemp);
        out.close();
    }


    private static void deleteFile(File file){
        //判断文件不为null或文件目录存在
        if (file == null || !file.exists()){
            //flag = 0;
            System.out.println("文件删除失败,请检查文件路径是否正确");
            return;
        }
        //取得这个目录下的所有子文件对象
        File[] files = file.listFiles();
        //遍历该目录下的文件对象
        if(files!=null){
            for (File f: files){
                //打印文件名
                String name = f.getName();
                //判断子目录是否存在子目录,如果是文件则删除
                if (f.isDirectory()){
                    deleteFile(f);
                }else {
                    f.delete();
                    System.out.println(name);
                }
            }
        }
        else{
            return;
        }
    }

    private String makeFileName(String filename) {  //2.jpg
        //为防止文件覆盖的现象发生，要为上传文件产生一个唯一的文件名
        return UUID.randomUUID().toString() + "_" + filename;
    }

    private String makePath(String filename, String savePath) {
        //得到文件名的hashCode的值，得到的就是filename这个字符串对象在内存中的地址
        int hashcode = filename.hashCode();
        //0--15
        int dir1 = hashcode & 0xf;
        //0-15
        int dir2 = (hashcode & 0xf0) >> 4;
        //构造新的保存目录
        //upload\2\3  upload\3\5
        String dir = savePath + "\\" + dir1 + "\\" + dir2;
        //File既可以代表文件也可以代表目录
        File file = new File(dir);
        //如果目录不存在
        if (!file.exists()) {
            //创建目录
            file.mkdirs();
        }
        return dir;
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }


}

