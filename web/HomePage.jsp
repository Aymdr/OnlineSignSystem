<%--
  Created by IntelliJ IDEA.
  User: Aymdr
  Date: 2020-5-16
  Time: 10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" pageEncoding="UTF-8" %>

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
    <link rel="stylesheet" href="css/img.css">
    <link rel="stylesheet" href="css/homePage.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="stylesheet" href="css/base_css.css">
</head>
<%--加载首页--%>
<body onload="onload()" style="position:relative;">
<div class="header1">
    <div class="container1">
        <h3 class="header_h3">电子签章系统</h3>
        <a class="return_btn" onclick="exit()">退出</a>
        <%--<input type="button" value="退出" onclick="exit()" class="return_btn">--%>
    </div>
</div>
<div class="content-middle">
    <%--菜单栏--%>
    <div id="menu">
        <%--主菜单栏，主要包括全部文件、待我处理、待他人处理、未完成、已完成、筛选(搜索)等--%>
        <button id="sign-files" class="files-button" type="button" onclick="signNewFiles()">签发文件</button>
        <button id="all-files" class="files-button" type="button" onclick="AllFiles()">全部文件</button>
        <button id="unfinished-files" class="files-button" type="button" onclick="UnfinishedFiles()">待签署</button>
        <button id="finished-files" type="button" class="files-button" onclick="FinishedFiles()">已签署</button>
        <span style="margin-left: 10px;">请输入待搜索文件：</span>
        <input type="text" autocomplete="off" placeholder="文件名称" id="find-files" value="" style="border:1px solid;border-color:black;">
        <span>文件类型：</span>
        <select name="selectType" id="selectType" onchange="chooseType()">
            <%--增加盖章模式--%>
            <option value="1">政府采购类</option>
            <option value="2">工程建设类</option>
            <option value="3">公文类</option>
            <option value="4">其他类</option>
        </select>
        <button id="sign-files" class="files-button" type="button" onclick="SearchFiles()" style="margin-left: 0px;width: 50px;">搜索</button>
        <%--<input type="button" value="搜 索" class="forbutton" onclick="SearchFiles()">--%>
        <hr style="color: #46b8da; size: 5px;">

        <form id="form1" action="signFilesHandle" method="post">
            <input type="hidden" id="user_name" name="user_name" value="">
        </form>

        <%--<form id="form2" action="searchHandle" method="post">--%>
        <%--<input type="hidden" id="searchFile" name="searchFile" value="">--%>
        <%--<input type="hidden" id="fileType" name="fileType" value="">--%>
        <%--</form>--%>
    </div>
    <%--界面栏--%>
    <div id="middle">
        <%--文件列表--%>
        <div id="file-table" class="middle-table">
            <table id="mytable" class="table table-striped">
                <%--表头--%>
                <thead>
                <tr>
                    <th colspan="11" style="text-align: center; font-size: 20px" color="black">全部文件管理</th>
                </tr>
                <tr style="font-size:15px">
                    <th style="text-align: center;">文件编号</th>
                    <th style="text-align: center;">文件名称</th>
                    <th style="text-align: center;">发送方</th>
                    <th style="text-align: center;">签署状态</th>
                    <th style="text-align: center;">建立时间</th>
                    <th style="text-align: center;">签署时间</th>
                    <th style="text-align: center;">文件类型</th>
                    <th style="text-align: center;">下载</th>
                </tr>
                </thead>
                <tbody id="tbody">

                </tbody>
            </table>
        </div>
        <div id="unfinished-file-table" class="middle-table">
            <table id="mytable-unfinished" class="table table-striped">
                <%--表头--%>
                <thead>
                <tr>
                    <th colspan="11" style="text-align: center; font-size: 20px" color="black">未完成文件管理</th>
                </tr>
                <tr style="font-size:15px">
                    <th style="text-align: center;">文件编号</th>
                    <th style="text-align: center;">文件名称</th>
                    <th style="text-align: center;">发送方</th>
                    <th style="text-align: center;">签署状态</th>
                    <th style="text-align: center;">建立时间</th>
                    <th style="text-align: center;">签署时间</th>
                    <th style="text-align: center;">文件类型</th>
                    <th style="text-align: center;">签署</th>
                    <th style="text-align: center;">下载</th>
                </tr>
                </thead>
                <tbody id="tbody1">

                </tbody>
            </table>
        </div>
        <div id="finished-file-table" class="middle-table">
            <table id="mytable-finished" class="table table-striped">
                <%--表头--%>
                <thead>
                <tr>
                    <th colspan="11" style="text-align: center; font-size: 20px" color="black">已完成文件管理</th>
                </tr>
                <tr style="font-size:15px">
                    <th style="text-align: center;">文件编号</th>
                    <th style="text-align: center;">文件名称</th>
                    <th style="text-align: center;">发送方</th>
                    <th style="text-align: center;">签署状态</th>
                    <th style="text-align: center;">建立时间</th>
                    <th style="text-align: center;">签署时间</th>
                    <th style="text-align: center;">文件类型</th>
                    <th style="text-align: center;">下载</th>
                    <th style="text-align: center;">删除</th>
                </tr>
                </thead>
                <tbody id="tbody2">

                </tbody>
            </table>
        </div>
    </div>
</div>
<%--<div class="footer3">--%>

<%--</div>--%>

<script>
    var LoginName = null;
    var status = 0;
    var AllFileReport = null;
    var filePath = null;
    var message1 = "error";
    var type_flag = 0;

    // 初始化加载
    function onload() {
        // 获取登录用户名
        LoginName = '<%=session.getAttribute("username")%>';
        $("#file-table").hide();
        $("#unfinished-file-table").hide();
        $("#finished-file-table").hide();
        document.getElementById("selectType").selectedIndex = -1;
    }

    // 新建签发文件
    function signNewFiles() {
        var name = LoginName;
        document.getElementById("user_name").value = name;
        var formData = new FormData($("#form1")[0]);
        $.ajax({
            async: false,
            cache: false,
            type: "post",
            data: formData,
            url: '/signFilesHandle',
            contentType: false, //必须
            processData: false, //必须
            success: function (data) {
                window.open("/mainPage.jsp?user_name=" + name);
            },
            error: function (e) {
                alert("进入签发界面失败！")
            }
        });
    }

    // 继续签署文件
    function signFiles(inputID) {
        var fileId = AllFileReport[inputID].PDF_id;
        var name = LoginName;
        document.getElementById("user_name").value = name;
        var formData = new FormData($("#form1")[0]);
        $.ajax({
            async: false,
            cache: false,
            type: "post",
            data: {"user_name": name, "PDF_id": fileId},
            url: '/signFilesHandle',
            //contentType: false, //必须
            // processData: false, //必须
            success: function (data) {
                window.open("/mainPage.jsp?user_name=" + name);
                downloadFiles(inputID);
            },
            error: function (e) {
                alert("进入签发界面失败！")
                // console.log(arg1 + "--" + arg2 + "--" + arg3);
            }
        });
    }

    // 显示所有文件
    function AllFiles() {
        scanFiles(LoginName, 0);
    }

    function UnfinishedFiles() {
        scanUnfinishedFiles(LoginName, 1);
    }

    function FinishedFiles() {
        scanFinishedFiles(LoginName, 2);
    }

    function SearchFiles() {
        search(LoginName, 3)
    }

    //将数据库中的信息显示到前端
    function scanFiles(LoginName, status) {
        var name = LoginName;
        var file_status = status;
        try {
            $.ajax({
                type: 'post',
                async: false,
                url: '/fileShowHandle',
                data: {"user_name": name, "status": file_status},
                dataType: 'json',
                success: function (data) {
                    AllFileReport = data;
                    console.log(data);

                    $("#data").text(data.length);
                    //初始化一开始的时候加载的时候的分页
                    $("#tbody").empty();
                    var str = "";
                    var page = 1;

                    for (var j = 0; j < data.length; j++) {
                        var file_name = data[j].file_name;
                        var PDF_id = data[j].PDF_id;
                        var start_user = data[j].start_user;
                        var start_name = data[j].start_name;
                        var sign_status = data[j].sign_status;
                        var sign_time = data[j].start_time;
                        var finish_time = data[j].end_time;
                        var file_status = data[j].file_type;
                        var start_time = sign_time.replace("+", " ");
                        var end_time = finish_time.replace("+", " ");
                        var sign_type = null;
                        var file_type = null;
                        if (file_status == 1) {
                            file_type = "政府采购类";
                        } else if (file_status == 2) {
                            file_type = "工程建设类";
                        } else if (file_status == 3) {
                            file_type = "公文类";
                        } else {
                            file_type = "其他类";
                        }
                        if (sign_status == 1) {
                            sign_type = "未完成";
                        } else {
                            sign_type = "已完成";
                        }
                        str += "<tr><td align='center'>" + PDF_id + "</td><td align='center'>" + file_name
                            + "</td><td align='center'>" + start_name + "</td><td align='center'>" + sign_type
                            + "</td><td align='center'>" + start_time + "</td><td align='center'>" + end_time + "</td><td align='center'>" + file_type
                            + "</td><td align='center'>" + "<button id=\"file-download\" type=\"button\" onclick=\"downloadFiles(" + j + ")\">下载</button>" + "</td><tr>";
                        // document.getElementById("user_info").selectedIndex = -1;
                    }

                    $("#tbody").append(str);//插入节点中
                    $('#unfinished-file-table').hide();
                    $('#finished-file-table').hide();
                    $("#file-table").show();

                },
                error: function () {
                    alert("无法与数据库取得连接!!!scanfiles");
                }
            });
        } catch (e) {
            alert("失败！");
        }
    }

    function scanUnfinishedFiles(LoginName, status) {
        var name = LoginName;
        var file_status = status;
        try {
            $.ajax({
                type: 'post',
                async: false,
                url: '/fileShowHandle',
                data: {"user_name": name, "status": file_status},
                dataType: 'json',
                success: function (data) {
                    AllFileReport = data;
                    console.log(data);

                    $("#data").text(data.length);
                    //初始化一开始的时候加载的时候的分页
                    $("#tbody1").empty();
                    var str = "";
                    var page = 1;

                    for (var j = 0; j < data.length; j++) {
                        var file_name = data[j].file_name;
                        var PDF_id = data[j].PDF_id;
                        var start_user = data[j].start_user;
                        var start_name = data[j].start_name;
                        var sign_status = data[j].sign_status;
                        var sign_time = data[j].start_time;
                        var finish_time = data[j].end_time;
                        var file_status = data[j].file_type;
                        var start_time = sign_time.replace("+", " ");
                        var end_time = finish_time.replace("+", " ");
                        var sign_type = null;
                        var file_type = null;
                        if (file_status == 1) {
                            file_type = "政府采购类";
                        } else if (file_status == 2) {
                            file_type = "工程建设类";
                        } else if (file_status == 3) {
                            file_type = "公文类";
                        } else {
                            file_type = "其他类";
                        }
                        if (sign_status == 1) {
                            sign_type = "未完成";
                        } else {
                            sign_type = "已完成";
                        }
                        str += "<tr><td align='center'>" + PDF_id + "</td><td align='center'>" + file_name
                            + "</td><td align='center'>" + start_name + "</td><td align='center'>" + sign_type
                            + "</td><td align='center'>" + start_time + "</td><td align='center'>" + end_time + "</td><td align='center'>" + file_type
                            + "</td><td align='center'>" + "<button id=\"file-sign\" type=\"button\" onclick=\"signFiles(" + j + ")\">签署</button>" + "</td>"
                            + "<td align='center'>" + "<button id=\"file-download\" type=\"button\" onclick=\"downloadFiles(" + j + ")\">下载</button>" + "</td><tr>";
                        // document.getElementById("user_info").selectedIndex = -1;
                    }

                    $("#tbody1").append(str);//插入节点中
                    $('#finished-file-table').hide();
                    $("#file-table").hide();
                    $("#unfinished-file-table").show();

                },
                error: function () {
                    alert("无法与数据库取得连接!!!scanfiles");
                }
            });
        } catch (e) {
            alert("失败！");
        }
    }

    function scanFinishedFiles(LoginName, status) {
        var name = LoginName;
        var file_status = status;
        try {
            $.ajax({
                type: 'post',
                async: false,
                url: '/fileShowHandle',
                data: {"user_name": name, "status": file_status},
                dataType: 'json',
                success: function (data) {
                    AllFileReport = data;
                    console.log(data);

                    $("#data").text(data.length);
                    //初始化一开始的时候加载的时候的分页
                    $("#tbody2").empty();
                    var str = "";
                    var page = 1;

                    for (var j = 0; j < data.length; j++) {
                        var file_name = data[j].file_name;
                        var PDF_id = data[j].PDF_id;
                        var start_user = data[j].start_user;
                        var start_name = data[j].start_name;
                        var sign_status = data[j].sign_status;
                        var sign_time = data[j].start_time;
                        var finish_time = data[j].end_time;
                        var file_status = data[j].file_type;
                        var start_time = sign_time.replace("+", " ");
                        var end_time = finish_time.replace("+", " ");
                        var sign_type = null;
                        var file_type = null;
                        if (file_status == 1) {
                            file_type = "政府采购类";
                        } else if (file_status == 2) {
                            file_type = "工程建设类";
                        } else if (file_status == 3) {
                            file_type = "公文类";
                        } else {
                            file_type = "其他类";
                        }
                        if (sign_status == 1) {
                            sign_type = "未完成";
                        } else {
                            sign_type = "已完成";
                        }
                        str += "<tr><td align='center'>" + PDF_id + "</td><td align='center'>" + file_name
                            + "</td><td align='center'>" + start_name + "</td><td align='center'>" + sign_type
                            + "</td><td align='center'>" + start_time + "</td><td align='center'>" + end_time + "</td><td align='center'>" + file_type
                            + "</td><td align='center'>" + "<button id=\"file-download\" type=\"button\" onclick=\"downloadFiles(" + j + ")\">下载</button>" + "</td>"
                            + "<td align='center'>" + "<button id=\"file-delete\" type=\"button\" onclick=\"deleteFiles(" + j + ")\">删除</button>" + "</td><tr>";
                        // document.getElementById("user_info").selectedIndex = -1;
                    }

                    $("#tbody2").append(str);//插入节点中
                    $('#finished-file-table').show();
                    $("#file-table").hide();
                    $("#unfinished-file-table").hide();

                },
                error: function () {
                    alert("无法与数据库取得连接!!!scanfiles");
                }
            });
        } catch (e) {
            alert("失败！");
        }
    }

    function downloadFiles(inputId) {
        var downloadFileName = AllFileReport[inputId].file_name;
        var path = AllFileReport[inputId].file_path;
        downLoadFile(downloadFileName, path);
    }

    // 下载表单
    function downLoadFile(filename, filepath) {
        var form = $("<form>");    // 定义一个form表单
        form.attr("style", "display:none");
        form.attr("target", "_blank");
        form.attr("method", "post");
        form.attr("action", "downloadHandle");    // 此处填写文件下载提交路径
        var input1 = $("<input>");
        input1.attr("type", "hidden");
        input1.attr("name", "downLoadFileName");    // 后台接收参数名
        input1.attr("value", filename);
        var input2 = $("<input>");
        input2.attr("type", "hidden");
        input2.attr("name", "downLoadFilePath");    // 后台接收参数名
        input2.attr("value", filepath);
        $("body").append(form);    // 将表单放置在web中
        form.append(input1);
        form.append(input2);
        form.submit();    // 表单提交
    }

    function deleteFiles(inputId) {
        var fileId = AllFileReport[inputId].PDF_id;

        try {
            $.ajax({
                type: "post",
                async: false,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
                url: "/fileDeleteHandle",    //请求发送到UserServlet处
                data: {"fileId": fileId},
                dataType: "json",        //返回数据形式为json
                success: function (data) {
                    //请求成功时执行该函数内容，result即为服务器返回的json对象
                    if (data.result != message1) {
                        alert("删除文件成功！");
                    } else {
                        alert("删除文件失败！");
                    }
                    AllFiles();
                },
                error: function (data) {
                    //请求失败时执行该函数
                    alert("请求删除印章服务器失败!");
                }
            });
        } catch (e) {
            alert("删除失败！");
        }
    }

    // 退出到登录界面
    function exit() {
        //二次确认
        var gnl = confirm("确定要退出?");
        if (gnl == true) {
            window.location = "login.jsp";
        }
    }

    function openPDF(inputId) {
        // Document.charset="utf-8";
        var path = AllFileReport[inputId].file_path;
        window.open("pdfjs/web/viewer.html?file=" + path);
    }

    function decodeUtf8(bytes) {
        var encoded = "";
        for (var i = 0; i < bytes.length; i++) {
            encoded += '%' + bytes[i].toString(16);
        }
        return decodeURIComponent(encoded);
    }

    function chooseType() {
        // 选择盖章模式，0：单页盖章；1：多页盖章；2：除首页外盖章
        var type = document.getElementById("selectType");
        var index = type.selectedIndex;
        if (parseInt(index) == 0)
            type_flag = 1;
        if (parseInt(index) == 1)
            type_flag = 2;
        if (parseInt(index) == 2)
            type_flag = 3;
        if (parseInt(index) == 3)
            type_flag = 4;
        // document.getElementById("fileType").value = type_flag;
    }

    function search(LoginName, status) {
        var name = LoginName;
        var flag = status;
        var filename = document.getElementById("find-files").value;
        var filetype = type_flag;
        try {
            $.ajax({
                //异步请求，用户必须等待上传文件盖章操作完成后才能进行下一步
                async: false,
                type: "post",
                data: {"user_name": name, "status": flag, "filename": filename, "filetype": filetype},
                url: '/searchHandle',
                dataType: 'json',
                success: function (data) {
                    AllFileReport = data;
                    console.log(data);

                    $("#data").text(data.length);
                    //初始化一开始的时候加载的时候的分页
                    $("#tbody").empty();
                    var str = "";
                    var page = 1;

                    for (var j = 0; j < data.length; j++) {
                        var file_name = data[j].file_name;
                        var PDF_id = data[j].PDF_id;
                        var start_user = data[j].start_user;
                        var start_name = data[j].start_name;
                        var sign_status = data[j].sign_status;
                        var sign_time = data[j].start_time;
                        var file_status = data[j].file_type;
                        var start_time = sign_time.replace("+", " ");
                        var sign_type = null;
                        var file_type = null;
                        if (file_status == 1) {
                            file_type = "政府采购类";
                        } else if (file_status == 2) {
                            file_type = "工程建设类";
                        } else if (file_status == 3) {
                            file_type = "公文类";
                        } else {
                            file_type = "其他类";
                        }
                        if (sign_status == 1) {
                            sign_type = "未完成";
                        } else {
                            sign_type = "已完成";
                        }
                        str += "<tr><td align='center'>" + PDF_id + "</td><td align='center'>" + file_name
                            + "</td><td align='center'>" + start_name + "</td><td align='center'>" + sign_type
                            + "</td><td align='center'>" + start_time + "</td><td align='center'>" + file_type
                            + "</td><td align='center'>" + "<button id=\"file-download\" type=\"button\" onclick=\"downloadFiles(" + j + ")\">下载</button>" + "</td><tr>";
                        // document.getElementById("user_info").selectedIndex = -1;
                    }

                    $("#tbody").append(str);//插入节点中
                    $('#unfinished-file-table').hide();
                    $('#finished-file-table').hide();
                    $("#file-table").show();

                },
                error: function () {
                    alert("无法与数据库取得连接!!!scanfiles");
                }
            });
        } catch (e) {
            alert("发送上传盖章ajax数据失败！");
        }
    }
</script>
</html>
