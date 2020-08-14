<%--
  Created by IntelliJ IDEA.
  User: Aymdr
  Date: 2019/12/10
  Time: 10:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>uploadImages</title>
</head>
<body>
<%--<form action="upload" method="post" enctype="multipart/form-data">--%>
    <%--<p><label>图片名称：</label><input type="text" id="name" name="pic_name"></p>--%>
    <%--<p><label>上传图片：</label><input type="file" multiple="multiple" id="pic" name="picture"></p>--%>
    <%--<input type="submit" value="提交" >--%>
    <%--<input type="reset" value="重置" >--%>
<%--</form>--%>
<script language="JavaScript" type="text/javascript">
    function loadImageFile(event)
    {
        var image = document.getElementById('image');
        image.src = URL.createObjectURL(event.target.files[0]);
    };
</script>

<div align="center">
    <form action="ServletUpload" method="post" enctype="multipart/form-data">
        <table>
            <tr>
                <td>图片名称：</td>
                <td><input id="name" type="text" name="Filename">
                </td>
            </tr>
            <tr>
                <td>选择上传的图片</td>
                <td><input id="file1" type="file" name="File" οnchange="loadImageFile(event)">
                </td>
                <td> <img id="image" src="" ></td>
            </tr>
            <tr>
                <td><input id="button" type="submit" value="上传"></td>
                <td><input id="reset" type="reset" value="重置">
                </td>
            </tr>

            <%--<tr>--%>
                <%--<td align="center" colspan="2"><input id="button"--%>
                    <%--type="submit" value="上传"> <a id="a"--%>
                     <%--href="show_img.jsp">查看上传图片</a>--%>
                <%--</td>--%>
            <%--</tr>--%>
        </table>
    </form>
</div>
</body>
<script>
    var yes ='<%=request.getParameter("yes")%>';
    if(yes=='yes'){
        alert("上传成功！")
    }
</script>

</html>
