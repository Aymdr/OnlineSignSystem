<%--
  Created by IntelliJ IDEA.
  User: Aymdr
  Date: 2020/3/10
  Time: 15:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale = 1.0, maximum-scale = 1.0, user-scalable=no">
    <script src="js/jquery.min.js"></script>
    <script src="js/pdf.js"></script>
    <script src="js/pdf.worker.js"></script>
    <script src="js/some_pdf.js"></script>
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body onload="onload()">
<div id="user">
    <div id="pic-table">
        <table id="userTable" class="table table-striped">
            <%--表头--%>
            <thead>
            <tr>
                <th colspan="11" style="text-align: center;" size="4px" color="black">人员管理</th>
            </tr>
            <tr style="font-size:15px">
                <th style="text-align: center;">编号</th>
                <th style="text-align: center;">姓名</th>
                <th style="text-align: center;">用户名</th>
                <th style="text-align: center;">密码</th>
                <th style="text-align: center;">U盾ID</th>
                <th style="text-align: center;">删除用户</th>
            </tr>
            </thead>
            <tbody id="tbody">

            </tbody>
        </table>
    </div>
</div>
<script>
    var AllUserReport;
    var AllPicReport;

    function onload() {
        scanUser();
    }
    function scanUser() {
        try {
            $.ajax({
                type: 'post',
                async: false,
                processData: false,
                url: '/userInfoHandle',
                dataType: 'json',
                success: function (data) {
                    AllUserReport = data;
                    console.log(data);
                    $("#data").text(data.length);
                    //初始化一开始的时候加载的时候的分页
                    $("#tbody").empty();

                    var str = "";
                    var page = 1;
                    for (var j = 0; j < data.length; j++) {
                        str += "<tr><td align='center'>" + data[j].user_id + "</td><td align='center'>" + data[j].name_user
                            + "</td><td align='center'>" + data[j].user_name + "</td><td align='center'>" + data[j].Password
                            + "</td><td align='center'>" + data[j].device_id + "</td>"
                            + "</td><td align='center'>" + "<button id=\"user-delete\" type=\"button\" onclick=\"deleteUser(" + j + ")\">删除</button>" + "</td><tr>";
                    }
                    $("#tbody").append(str);//插入节点中
                    // $("#pic-table").show();
                },
                error: function () {
                    alert("无法与数据库取得连接!!!");
                }
            });
        } catch (e) {
            alert("失败！");
        }
    }
    //删除用户
    function deleteUser(inputId) {
        var userId = AllUserReport[inputId].user_id;
        var message1 = "error";
        try {
            $.ajax({
                type: "post",
                async: false,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
                url: "/userDeleteHandle",    //请求发送到UserServlet处
                data: {"userId": userId},
                dataType: "json",        //返回数据形式为json
                success: function (data) {
                    //请求成功时执行该函数内容，result即为服务器返回的json对象
                    if (data.result != message1) {
                        alert("删除用户成功！");
                    } else {
                        alert("删除用户失败！");
                    }
                    scanUser();
                },
                error: function (data) {
                    //请求失败时执行该函数
                    alert("请求删除用户服务器失败!");
                }
            });
        } catch (e) {
            alert("删除失败！");
        }
        //alert("删除");
    }
</script>
</body>
</html>
