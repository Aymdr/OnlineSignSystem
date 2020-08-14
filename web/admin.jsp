<%--
  Created by IntelliJ IDEA.
  User: Aymdr
  Date: 2020/3/4
  Time: 11:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale = 1.0, maximum-scale = 1.0, user-scalable=no">
    <title>兰州卓凡电子科技有限公司印章管理系统</title>
    <script src="js/jquery.min.js"></script>
    <script src="js/pdf.js"></script>
    <script src="js/pdf.worker.js"></script>
    <script src="js/some_pdf.js"></script>
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/homePage.css">
    <link rel="stylesheet" href="css/base_css.css">
</head>
<body style="position:relative;text-align: center">
<div class="header1">
    <div class="container1">
        <h3 class="header_h3">后台管理</h3>
        <a class="return_btn" onclick="exit()">退出</a>
        <%--<input type="button" value="退出" onclick="exit()" class="return_btn">--%>
    </div>
</div>
<div class="content-middle" style="margin-top: 0;">
    <div class="content">
        <div class="main_left">
            <ul class="ul-style" >
                <li id="picAdmin" class="menu_item" data-src="picAdmin.jsp">印章管理</li>
                <li id="userAdmin" class="menu_item" data-src="userAdmin.jsp">人员管理</li>
            </ul>
        </div>
        <div class="main_right">
            <iframe frameborder="0" scrolling="yes" id="aa" class="iframe-style" style=""></iframe>
        </div>
    </div>
</div>
<script>
    $(function () {
        $(".menu_item").on("click", function () {
            var address = $(this).attr("data-src");
            $("iframe").attr("src", address);
        });
    });

    function exit() {
        window.location = "login.jsp"
    }
</script>


</body>
</html>
