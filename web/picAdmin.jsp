<%--
  Created by IntelliJ IDEA.
  User: Aymdr
  Date: 2020/3/10
  Time: 15:05
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
    <link rel="stylesheet" href="css/base_css.css">
    <link rel="stylesheet" href="css/homePage.css">
</head>
<body onload="onload()">
<div class="file_box">
    <div class="pic-menu">
        <button id="pic-upload" class="files-button" type="button" onclick="uploadPic('pic-to-upload')">上传</button>
        <button id="pic-show" class="files-button" type="button" onclick="createImg()">显示</button>
        <button id="pic-scan" class="files-button" type="button" onclick="scanPic()">查看</button>
        <form id="form1" action="picHandle" enctype="multipart/form-data" method="post" style="width:250px; display: inline-block; margin-left: 20px;">
            <input type="file" id="pic-to-upload" name="uploadPic" style="width: 100%;">
        </form>
    </div>
    <div id="pic-view" align="center" >
        <input type="image" id="signPic" alt="上传印章" class="img_seal">
    </div>
    <%--<button id="pic-upload" onclick="uploadPic('pic-to-upload')">上传</button>--%>
    <%--<button id="pic-show" onclick="createImg()">显示</button>--%>


    <%--查看所有印章--%>
    <%--<button id="pic-scan" type="button" onclick="scanPic()">查看</button>--%>
    <%--印章列表--%>
    <div id="pic-table" class="seal_list">
        <p class="list_title">印章管理</p>
        <table id="mytable" class="table table-striped">
            <%--表头--%>
            <thead>
            <tr>
                <th colspan="11" style="text-align: center;" size="4px" color="black">印章管理</th>
            </tr>
            <tr style="font-size:15px">
                <th style="text-align: center;">印章编号</th>
                <th style="text-align: center;">印章名称</th>
                <th style="text-align: center;">上传时间</th>
                <th style="text-align: center;">附件</th>
                <th style="text-align: center;">使用者</th>
                <th style="text-align: center;">分配印章</th>
                <th style="text-align: center;">重置印章</th>
                <th style="text-align: center;">删除印章</th>
            </tr>
            </thead>
            <tbody id="tbody">

            </tbody>
        </table>
    </div>
</div>
<script>
    var srcName = null;
    var AllPicReport;
    var AllUserReport;
    var OptionString;
    var message1 = "error";
    var originName;
    var chooseIndex=null;
    //预加载
    function onload() {
        $('#signPic').hide();
        $('#pic-table').hide();
        try {
            $.ajax({
                type: 'post',
                async: false,
                url: '/userShowHandle',
                data: {"user_name": "admin"},
                dataType: 'json',
                success: function (data1) {
                    AllUserReport = data1;
                    console.log(data1);
                    for (var i = 0; i <= data1.length; i++) {
                        var user_id = data1[i].user_id;
                        var name_user = data1[i].name_user;
                        OptionString += "<option value=\"" + user_id + "\" >" + name_user + "</option>";
                    }
                },
                error: function () {
                    alert("无法与数据库取得连接!!!1111");
                }
            });
        } catch (e) {
            alert("失败！");
        }
    }

    //上传图片
    function uploadPic(inputid) {
        var fileValue = $('#' + inputid).val();
        if (null == fileValue || fileValue == '') {
            alert("还未选择文件！");
        } else {
            var formData = new FormData();
            try {
                formData.append("file", $('#' + inputid).prop('files')[0]);
                $.ajax({
                    type: 'POST',
                    async:false,
                    url: '/picHandle',
                    data: formData,
                    dataType: "json",
                    contentType: false,// 注意：让jQuery不要处理数据
                    processData: false,// 注意：让jQuery不要设置contentType
                    success: function (data) {
                        alert("上传成功！");
                        srcName = data.picFileName;
                    },
                    error: function (data) {
                        alert("上传失败，请重试");
                    }
                });
            } catch (e) {
                alert("上传失败！")
            }
            return srcName;
        }
    }

    //显示印章
    function createImg() {
        if (srcName != null) {
            document.getElementById("signPic").src = "/picSource/" + srcName;
            $('#signPic').show();
        } else {
            alert("未选择文件！")
        }
    }

    //将数据库中的信息显示到前端
    function scanPic() {
        try {
            $.ajax({
                type: 'post',
                async: false,
                processData: false,
                url: '/picShowHandle',
                dataType: 'json',
                success: function (data) {
                    AllPicReport = data;
                    console.log(data);

                    $("#data").text(data.length);
//初始化一开始的时候加载的时候的分页
                    $("#tbody").empty();
                    var str = "";
                    var page = 1;

                    for (var j = 0; j < data.length; j++) {
                        var originName = "";
                        if (data[j].owner != "") {
                            originName = data[j].owner;
                        }

                        var picTime = null;
                        var picDate = null;
                        var picName = null;
                        var allName = data[j].photo_name;
                        var temp = allName.split("+");
                        picName = temp[1];
                        picTime = temp[0].slice(0, 8);
                        var List = new Array(picTime.slice(0, 4), picTime.slice(4, 6), picTime.slice(6, 8));
                        picDate = List.join(".");
                        str += "<tr><td align='center'>" + data[j].pic_id + "</td><td align='center'>" + picName +"</td>"
                            + "<td align='center'>" + picDate + "</td><td align='center'><a href='./picSource/" + data[j].photo_name + "' target='_blank'>查看 </a></td>"
                            + "<td align='center'>" + originName + "</td>"
                            + "<td align='center'><select id='user_info[" + j + "]'>" + OptionString + "</select>"
                            + "<button id=\"pic-allot\" type=\"button\" onclick=\"allotPic(" + j + ")\">分配</button></td>"
                            + "<td align='center'>" + "<button id=\"pic-restart\" type=\"button\" onclick=\"restartPic(" + j + ")\">重置</button>" + "</td>"
                            + "<td align='center'>" + "<button id=\"pic-delete\" type=\"button\" onclick=\"deletePic(" + j + ")\">删除</button>" + "</td><tr>";
                        // document.getElementById("user_info").selectedIndex = -1;
                    }

                    $("#tbody").append(str);//插入节点中
                    $("#pic-table").show();

                },
                error: function () {
                    alert("无法与数据库取得连接!!!1111");
                }
            });
        } catch (e) {
            alert("失败！");
        }
    }

    //分配印章
    function allotPic(inputId) {
        //当前行的图片id
        var picId = AllPicReport[inputId].pic_id;
        //分配给这个用户
        var choose = "user_info[" +inputId+"]";
        var obj1 = document.getElementById(choose);
        var userIndex = obj1.selectedIndex;
        var userId = AllUserReport[userIndex].user_id;
        var userName = AllUserReport[userIndex].name_user;
        var flagAlloction = AllPicReport[inputId].alloction;
        try {
            $.ajax({
                type: "post",
                async: false,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
                url: "/userPhotoHandle",    //请求发送到UserServlet处
                data: {"picId": picId, "userId": userId, "owner": userName, "flag": flagAlloction},
                dataType: "json",        //返回数据形式为json
                success: function (data) {
//请求成功时执行该函数内容，result即为服务器返回的json对象
                    if (data.result != message1) {
                        alert("分配印章成功！");
//originName[inputId] = name;
                    } else {
                        alert("分配印章失败！");
                    }
                    scanPic();
                },
                error: function (data) {
//请求失败时执行该函数
                    alert("请求分配印章服务器失败!");
                }
            });
        } catch (e) {
            alert("分配失败！");
        }
    }
    //重置印章
    function restartPic(inputId) {
        var picId = AllPicReport[inputId].pic_id;
        try {
            $.ajax({
                type: "post",
                async: false,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
                url: "/photoDeleteHandle",    //请求发送到UserServlet处
                data: {"picId": picId,"status":0},
                dataType: "json",        //返回数据形式为json
                success: function (data) {
                    //请求成功时执行该函数内容，result即为服务器返回的json对象
                    if (data.result != message1) {
                        alert("重置印章成功！");
                    } else {
                        alert("重置印章失败！");
                    }
                    scanPic();
                },
                error: function (data) {
                    //请求失败时执行该函数
                    alert("请求重置印章服务器失败!");
                }
            });
        } catch (e) {
            alert("重置失败！");
        }
    }
    //删除印章
    function deletePic(inputId) {
        var picId = AllPicReport[inputId].pic_id;

        try {
            $.ajax({
                type: "post",
                async: false,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
                url: "/photoDeleteHandle",    //请求发送到UserServlet处
                data: {"picId": picId,"status":1},
                dataType: "json",        //返回数据形式为json
                success: function (data) {
                    //请求成功时执行该函数内容，result即为服务器返回的json对象
                    if (data.result != message1) {
                        alert("删除印章成功！");
                    } else {
                        alert("删除印章失败！");
                    }
                    scanPic();
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
</script>
</body>
</html>
