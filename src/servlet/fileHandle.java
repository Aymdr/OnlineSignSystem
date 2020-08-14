package servlet;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;

/**
 * @author Aymdr
 * 日志文件处理
 */
public class fileHandle {
    // 新建文件
    // 输入：新建文件路径
    public boolean createTxtFile(String filePath) {
        boolean flag = false;
        try {
            File newfile = new File(filePath);
            if (!newfile.exists()) {
                newfile.createNewFile();
                flag = true;
            }
        } catch (Exception e) {
            System.out.println("文件创建失败！" + e);
        }
        return flag;
    }

    // 追加写文件
    // 输入：文件路径，内容
    public boolean writeTxtFileAppend(String filePath, String content) throws IOException {
        boolean flag = false;
        try {
            // 构造函数中的第二个参数true表示以追加形式写文件
            FileWriter fw = new FileWriter(filePath, true);
            fw.write(content+"\r\n");
            fw.close();
            flag=true;
        } catch (IOException e) {
            System.out.println("文件写入失败！" + e);
        }
        return flag;
    }

    // 覆盖写文件
    // 输入：文件路径，内容
    public boolean writeTxtFile(String filePath, String content) throws Exception {
        boolean flag = false;
        FileOutputStream fileOutputStream = null;
        File file = new File(filePath);
        try {
            fileOutputStream = new FileOutputStream(file);
            fileOutputStream.write(content.getBytes("UTF-8"));
            fileOutputStream.close();
            flag = true;
        } catch (Exception e) {
            System.out.println("文件写入失败！" + e);
        }
        return flag;
    }

    // 读文件
    // 输入：文件路径
    // 输出：文件信息
    public String readTxtFile(String filePath) {
        String result = "";
        File file = new File(filePath);
        try {
            InputStreamReader reader = new InputStreamReader(new FileInputStream(file), "UTF-8");
            BufferedReader br = new BufferedReader(reader);
            String s = null;
            while ((s = br.readLine()) != null) {
                result = result + s;
                System.out.println(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
