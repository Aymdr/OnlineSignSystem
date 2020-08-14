<%--
  Created by IntelliJ IDEA.
  User: Aymdr
  Date: 2019/12/19
  Time: 10:53
  首页的编写，包含所有的逻辑功能
--%>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale = 1.0, maximum-scale = 1.0, user-scalable=no">
    <script src="js/jquery.min.js"></script>
    <script src="js/pdf.js"></script>
    <script src="js/pdf.worker.js"></script>
    <script src="js/some_pdf.js"></script>
    <script src="js/drag.js"></script>
    <link rel="stylesheet" href="css/img.css">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/homePage.css">
    <link rel="stylesheet" href="css/base_css.css">
</head>
<%--加载首页--%>
<body onload="onload()" style="position:relative;">
<div class="header1">
    <div class="container1">
        <h3 class="header_h3">电子签章系统</h3>
        <a class="return_btn" onclick="exit()">退出</a>
    </div>
</div>
<div class="content-middle">
    <%--菜单栏--%>
    <div id="menu">
        <!--上传PDF按钮,分为上传本地文件和上传数据库待我处理文件-->
        <span style="margin-left: 20px;">选择签章文档:</span>
        <button id="upload-button" class="files-button" style="margin-left: 0;">浏览</button>

        <%--盖章模式的选择--%>
        <span style="margin-left: 10px;">选择盖章模式：</span>
        <select name="selectMode" id="selectMode" onchange="chooseMode()">
            <%--增加盖章模式--%>
            <option value="1">单页盖章</option>
            <option value="2">多页盖章</option>
            <option value="3">除首页外盖章</option>
        </select>

        <%--选择一个印章进行盖章--%>
        <span style="margin-left: 10px;">签章操作：</span>
        <button  class="files-button" type="button" onclick="savePic()" style="margin-left: 0px;width: 50px;">添加</button>
        <button  class="files-button" type="button" onclick="canclePic()" style="margin-left: 0px;width: 50px;">删除</button>
        <span style="margin-left: 10px;">选择印章：</span> <select name="selectSign" id="selectSign" onchange="chooseSign()"></select>
        <%--选择一个用户进行文件的传递，如不传递，则默认为无--%>

        <span style="margin-left: 10px;">选择发送用户(默认为"无")：</span> <select name="selectUser" id="selectUser" onchange="chooseUser()"></select>
        <%--选择文件类型以便之后筛选--%>
        <span style="margin-left: 10px;">选择类型：</span> <select name="selectType" id="selectType" onchange="chooseType()"></select>
        <%--上传文件至后台盖章，并上传到数据库进行处理--%>


        <%--<input type="button" value="盖 章"  onclick="upload()" >--%>
        <button  class="files-button" type="button" onclick="upload()" style="margin-left: 0px;width: 50px;">盖章</button>

        <!--用于将盖章坐标通过表单传送到后端servlet，类型为隐藏-->
        <form id="form1" action="uploadHandle" enctype="multipart/form-data" method="post">
            <input type="hidden" id="sign_x" name="sign_x" value="">
            <input type="hidden" id="sign_y" name="sign_y" value="">
            <input type="hidden" id="signMode" name="signMode" value="">
            <input type="hidden" id="totalPage" name="totalPage" value="">
            <input type="hidden" id="pngName" name="pngName" value="">
            <input type="hidden" id="startName" name="startName" value="">
            <input type="hidden" id="endName" name="endName" value="">
            <input type="hidden" id="signPage" name="signPage" value="">
            <input type="hidden" id="fileType" name="fileType" value="">
            <input type="file" id="file-to-upload" name="uploadPDF" accept="application/pdf"/>
        </form>
    </div>
    <%--界面栏--%>
    <div id="middle">
        <!--PDF主体部分-->
        <div id="pdf-main-container">
            <!--上传时候显示加载文档-->
            <div id="pdf-loader">加载中 ...</div>
            <!--PDF主体内容-->
            <div id="pdf-contents">
                <!--PDF元数据-->
                <div id="pdf-meta">
                    <div id="pdf-buttons" text-align:center>
                        <!--前翻页和后翻页-->
                        <button id="pdf-prev" float:left>前一页</button>
                        <!--PDF 当前页-->
                        <%--<div id="jumpButton" >--%>
                        <div id="page-count-container" text-align:center>
                            <input type="text" oninput="value=value.replace(/[^\d]/g,'')" size="2" id="jumpPage"
                                   value="" style="border:1px solid;border-color:black;width: 25px;height: 17.6px;background-color: white;">
                            <span style="height: 28.4px;">/</span>
                            <div id="pdf-total-pages" style="height: 28.4px;width: 15px;"></div>
                            <button id="jumpDoc">转 到</button>
                            <button id="pdf-next" float:right>后一页</button>
                        </div>
                        <%--</div>--%>

                    </div>
                </div>
                <!--创建一个PDF画布-->
                <%--<img class="img" id="selected0">--%>
                <div id="pdf-canvas-wh">
                    <canvas id="pdf-canvas" width="595px" height="842px"></canvas>
                </div>
                <!--加载每一页内容-->
                <div id="page-loader">Loading page ...</div>
            </div>
        </div>
    </div>

    <script>
        var choose_sign; // 选择的印章信息
        var sign_point_x; //印章的x坐标
        var sign_point_y; //印章的y坐标
        var choose_page; //选择的页码
        var src_choose;
        var counts = 0; //印章个数，初始为0，登录后根据用户印章载入
        var mode_flag; //印章模式
        var arr = []; //印章名字
        var allName; //所有印章信息
        var allUser; //所有用户信息
        var userName = []; //所有用户姓名
        var userCounts = 0;
        var downloadFileName = null; //待下载的文件名
        var LoginName = null;
        var allType = ["政府采购类", "工程建设类", "公文类", "其他类"]
        var curID = "";
        var curID_src = "";
        var pdf_url = "";
        var currentPage = "";
        var loginPath = null;
        var Allsign_x = [];
        var Allsign_y = [];
        var AllpngName = [];
        var AllsignPage = [];
        var PicCount = -1;
        var PicFlag = 1;

        function savePic() {
            var flag = document.getElementById("selectMode").selectedIndex;
            if(flag != -1){
                // 添加新的img
                if (PicFlag == 1) {
                    PicCount = PicCount + 1;
                    var current = "selected".concat(PicCount);
                    var currentQuery = "#".concat(current);
                    var bigImg = document.createElement("img");
                    bigImg.className = "img";
                    bigImg.id = current;
                    var mydiv = document.getElementById("pdf-canvas-wh");
                    mydiv.parentNode.insertBefore(bigImg, mydiv);

                    $(currentQuery).hide();
                    document.getElementById("selectSign").selectedIndex = -1;
                    PicFlag = 0;
                }
            }
        }

        function canclePic() {
            var temp = "#selected".concat(PicCount);
            if (PicCount != -1) {
                PicCount = PicCount - 1;
                $(temp).remove();
                AllsignPage.pop();
                Allsign_x.pop();
                Allsign_y.pop();
                AllpngName.pop();
                document.getElementById("selectSign").selectedIndex = -1;
            } else {
                document.getElementById("selectSign").selectedIndex = -1;
            }
        }

        // 上传表单
        function upload() {
            // 上传表单的数据
            var x = "";
            var y = "";
            var name = "";
            var page = "";
            document.getElementById("startName").value = LoginName;
            for (var i = 0; i < AllpngName.length; i++) {
                x = x + "," + Allsign_x[i];
                y = y + "," + Allsign_y[i];
                name = name + "," + AllpngName[i];
                page = page + "," + AllsignPage[i];
            }
            document.getElementById("sign_x").value = x;
            document.getElementById("sign_y").value = y;
            document.getElementById("pngName").value = name;
            document.getElementById("signPage").value = page;
            var formData = new FormData($("#form1")[0]);
            try {
                $.ajax({
                    //异步请求，用户必须等待上传文件盖章操作完成后才能进行下一步
                    async: false,
                    cache: false,
                    type: "post",
                    data: formData,
                    url: '/uploadHandle',
                    dataType: 'json',
                    contentType: false, //必须
                    processData: false, //必须
                    success: function (data) {
                        if (data.result == 1) {
                            alert("上传成功！")
                        } else {
                            alert("上传失败！")
                        }
                    },
                    error: function (e) {
                        alert("上传失败！")
                    }
                });
            } catch (e) {
                alert("发送上传盖章ajax数据失败！");
            }
        }

        // 退出到登录界面
        function exit() {
            window.close();
        }

        // 下载表单
        function downLoadFile(filename) {
            var form = $("<form>");    // 定义一个form表单
            form.attr("style", "display:none");
            form.attr("target", "_blank");
            form.attr("method", "post");
            form.attr("action", "downloadHandle");    // 此处填写文件下载提交路径
            var input1 = $("<input>");
            input1.attr("type", "hidden");
            input1.attr("name", "downLoadFileName");    // 后台接收参数名
            input1.attr("value", filename);
            $("body").append(form);    // 将表单放置在web中
            form.append(input1);
            form.submit();    // 表单提交
        }

        // 登录后加载相关需要的信息，输入登录用户名，返回用户名下所有图片
        function onloadData(LoginName) {
            try {
                $.ajax({
                    type: "post",
                    async: false,            //异步请求（同步请求将会锁住浏览器，用户其他操作必须等待请求完成才可以执行）
                    url: "/picOfUserHandle",    //请求发送到UserServlet处
                    data: {"user_name": LoginName},
                    dataType: "json",        //返回数据形式为json
                    success: function (data) {
                        //请求成功时执行该函数内容，result即为服务器返回的json对象
                        console.log(data);
                        if (data[0] != null || data[1] != null) {
                            if (data[1] != null) {
                                allUser = data[1];
                                userCounts = data[1].length;
                                userName[0] = "无";
                                console.log(data[1]);
                                for (var i = 1; i < userCounts + 1; i++) {
                                    userName[i] = allUser[i - 1].name_user;
                                }
                            } else {
                                userName[0] = ["无"];
                            }
                            if (data[0] != null) {
                                allName = data[0];
                                counts = data[0].length;
                                for (var i = 0; i <= allName.length; i++) {
                                    var eachName = allName[i].photo_name;
                                    // 去掉时间数据，获得文件名+扩展名，例如xxx.jpg
                                    var temp = eachName.split("+");
                                    // 去除扩展名，获得文件名，例如xxx
                                    var temp1 = temp[1].split(".");
                                    // 存储该用户所拥有的印章名
                                    arr[i] = temp1[0];
                                }
                            } else {
                                arr = null;
                            }

                        } else {
                            // 该用户下无印章数据
                            arr = null;
                            userName = ["无"];
                        }
                    },
                    error: function (data) {
                        // 请求失败时执行该函数
                        alert("请求登录数据失败，请稍后再试!");
                        window.location = "login.jsp"
                    }
                });
            } catch (e) {
                alert("发送请求登录数据ajax失败！");
            }

        }

        // 登录后加载相关用户信息，输入登录用户名，返回除此用户外所有用户
        function onloadUser(LoginName) {
            try {
                if (LoginName != null) {
                    $.ajax({
                        type: 'post',
                        async: true,
                        processData: false,
                        url: '/userShowHandle',
                        data: {"user_name": LoginName},
                        dataType: 'json',
                        success: function (data1) {
                            if (data1 != null) {
                                allUser = data1;
                                userCounts = data1.length;
                                console.log(data1);
                                userName[0] = "无";
                                for (var i = 1; i < data1.length + 1; i++) {
                                    userName[i] = data[i - 1].name_user;
                                }
                            }
                            else {
                                userName = ["无"];
                            }
                        },
                        error: function () {
                            alert("无法与数据库取得连接!!!1111");
                        }
                    });
                }
            } catch (e) {
                alert("失败！");
            }
        }

        // 初始化加载函数，加载印章信息等
        function onload() {
            // 获取登录用户名
            <%--LoginName = '<%=session.getAttribute("username")%>';--%>
            var query = location.search.substring(1);
            var values = query.split("=");
            LoginName = values[1];
            <%--if('<%=session.getAttribute("file_path")%>'!=null){--%>
            <%--loginPath = '<%=session.getAttribute("file_path")%>';--%>
            <%--}--%>

            if (LoginName != null) {
                onloadData(LoginName);
                // document.getElementById("welcomeName").innerHTML = LoginName;
            }
            // 获取用户的印章数据

            // 隐藏已选择图片的显示框
            // $("#selected0").hide();
            for (var i = 0; i < counts; i++) {
                document.getElementById("selectSign").add(new Option(arr[i], i));
            }

            for (var i = 0; i < userCounts + 1; i++) {
                document.getElementById("selectUser").add(new Option(userName[i], i));
            }
            for (var i = 0; i < allType.length; i++) {
                document.getElementById("selectType").add(new Option(allType[i], i));
            }
            // 将所选印章和模式初始化为无
            document.getElementById("selectSign").selectedIndex = -1;
            document.getElementById("selectUser").selectedIndex = 0;
            document.getElementById("endName").value = "无";
            document.getElementById("selectType").selectedIndex = -1;
            document.getElementById("fileType").value = "其他类";
            document.getElementById("selectMode").selectedIndex = -1;
            // $("#selected0").hide();

        }

        // 选择印章并返回印章地址
        function chooseSign() {
            if (PicCount != -1) {
                // 获得所选择的印章索引值
                var choose = document.getElementById("selectSign");
                var index = choose.selectedIndex;
                // 获得所选择的印章的文件名
                src_choose = allName[index].photo_name;
                // 在表单中填入图片名，服务器在数据库中查找
                var current = "selected".concat(PicCount);
                var currentQuery = "#selected".concat(PicCount);
                // document.getElementById("pngName").value = src_choose;
                var src_origin = "/picSource/";
                // 获取路径并在前端显示
                document.getElementById(current).src = src_origin + src_choose;
                // 前端显示用于拖动印章
                $(currentQuery).show();
                // 初始化印章坐标
                sign_point_x = document.getElementById(current).offsetLeft;
                sign_point_y = document.getElementById(current).offsetTop;

                if (PicCount == AllsignPage.length) {
                    AllsignPage.push(__CURRENT_PAGE);
                    AllpngName.push(src_choose);
                    Allsign_x.push(sign_point_x);
                    Allsign_y.push(sign_point_y);
                } else {
                    AllsignPage[PicCount] = __CURRENT_PAGE;
                    AllpngName[PicCount] = src_choose;
                }
                // 用于单页盖章时所要上传的页码
                // document.getElementById("signPage").value = __CURRENT_PAGE;

                choose_sign = document.getElementById(current);
                choose_page = __CURRENT_PAGE;
                var drag = document.getElementById(current);
                doDrag(drag);
                PicFlag = 1;
            } else {
                document.getElementById("selectSign").selectedIndex = -1;
            }
        }

        // 选择用户并返回用户名
        function chooseUser() {
            var choose = document.getElementById("selectUser");
            var index = choose.selectedIndex;
            var name_choose = null;
            if (index == 0) {
                name_choose = "无";
            } else {
                name_choose = allUser[index - 1].user_name;
            }
            document.getElementById("endName").value = name_choose;
        }

        // 选择文件类型
        function chooseType() {
            var choose = document.getElementById("selectType");
            var index = choose.selectedIndex;
            var name_choose = allType[index];
            if (index != -1) {
                document.getElementById("fileType").value = name_choose;
            } else {
                document.getElementById("fileType").value = "其他类";
            }
        }

        // 选择盖章模式并分情况处理
        function chooseMode() {
            for (var i = PicCount; i >= 0; i--) {
                var temp = "#selected".concat(i);
                if (i != -1) {
                    $(temp).remove();
                    AllsignPage.pop();
                    document.getElementById("selectSign").selectedIndex = -1;
                } else {
                    document.getElementById("selectSign").selectedIndex = -1;
                }
            }
            // 选择盖章模式，0：单页盖章；1：多页盖章；2：除首页外盖章
            var mode = document.getElementById("selectMode");
            var index = mode.selectedIndex;
            if (parseInt(index) == 0)
                mode_flag = 0;
            if (parseInt(index) == 1)
                mode_flag = 1;
            if (parseInt(index) == 2)
                mode_flag = 2;
            document.getElementById("signMode").value = mode_flag;
            PicCount = -1;
        }

        // 显示PDF部分
        // PDF_DOC:PDF文档；CURRENT_PAGE：当前页码；TOTAL_PAGES：总页数；
        // PAGE_RENDERING_IN_PROGRESS：正在渲染的页码
        // CANVAS：显示PDF；CANVAS_CTX：画布绘图环境
        var __PDF_DOC,
            __CURRENT_PAGE,
            __TOTAL_PAGES,
            __PAGE_RENDERING_IN_PROGRESS = 0,
            __CANVAS = $('#pdf-canvas').get(0),
            __CANVAS_CTX = __CANVAS.getContext('2d');

        //显示PDF
        function showPDF(pdf_url) {
            //显示加载文档的提示语
            $("#selected0").hide();
            $("#pdf-loader").show();

            PDFJS.getDocument({url: pdf_url}).then(
                function (pdf_doc) {
                    //选择的PDF文档
                    __PDF_DOC = pdf_doc;
                    __TOTAL_PAGES = __PDF_DOC.numPages;
                    document.getElementById("totalPage").value = __TOTAL_PAGES;
                    document.getElementById("jumpPage").value = 1;

                    //将提示语隐藏并加载pdf内容到HTML上
                    $("#pdf-loader").hide();
                    $("#pdf-contents").show();
                    $("#pdf-total-pages").text(__TOTAL_PAGES);

                    // 函数显示第一页
                    showPage(1);
                }).catch(function (error) {
                // 若发生错误则重新显示加载PDF按钮
                $("#pdf-loader").hide();
                $("#upload-button").show();
                alert(error.message);
            });
            for (var i = PicCount; i >= 0; i--) {
                var temp = "#selected".concat(i);
                if (i != -1) {
                    $(temp).remove();
                    AllsignPage.pop();
                    document.getElementById("selectSign").selectedIndex = -1;
                } else {
                    document.getElementById("selectSign").selectedIndex = -1;
                }
            }
            document.getElementById("selectMode").selectedIndex = -1;
            PicCount = -1;
        }

        //根据页码显示当前页
        function showPage(page_no) {
            __PAGE_RENDERING_IN_PROGRESS = 1;
            document.getElementById("jumpPage").value = page_no;
            __CURRENT_PAGE = page_no;

            // Disable Prev & Next buttons while page is being loaded
            $("#pdf-next, #pdf-prev").attr('disabled', 'disabled');

            //当页面正在被渲染了，隐藏canvas并显示加载信息
            $("#pdf-canvas").hide();
            $("#page-loader").show();
            $("#download-image").hide();

            //更新当前页码
            $("#pdf-current-page").text(page_no);

            // Fetch the page
            __PDF_DOC.getPage(page_no).then(function (page) {
                //自适应调整窗宽
                var scale_required = __CANVAS.width / page.getViewport(1).width;
                //
                // Get viewport of the page at required scale
                var viewport = page.getViewport(scale_required);

                // Set canvas height
                __CANVAS.height = viewport.height;

                var renderContext = {
                    canvasContext: __CANVAS_CTX,
                    viewport: viewport
                };
                // Render the page contents in the canvas
                page.render(renderContext).then(function () {
                    __PAGE_RENDERING_IN_PROGRESS = 0;

                    // Re-enable Prev & Next buttons
                    $("#pdf-next, #pdf-prev").removeAttr('disabled');

                    // Show the canvas and hide the page loader
                    $("#pdf-canvas").show();
                    $("#page-loader").hide();
                    $("#download-image").show();
                });
            });
        }

        // 点击上传文件按钮
        $("#upload-button").on('click', function () {
            $("#file-to-upload").trigger('click');
        });

        // 点击下载文件按钮
        $("#download-button").on('click', function () {
            $("#file-to-download").trigger('click');
        });

        // 当用户选择一个PDF文件进行下载
        $("#file-to-download").on('change', function () {
            // 判断是否为PDF
            if (['application/pdf'].indexOf($("#file-to-download").get(0).files[0].type) == -1) {
                alert('Error : Not a PDF');
                return;
            }
            downloadFileName = $("#file-to-download").get(0).files[0].name;
            downLoadFile(downloadFileName);
        });

        // 当用户选择一个PDF文件用于上传
        $("#file-to-upload").on('change', function () {
            // 判断是否为PDF文件
            if (['application/pdf'].indexOf($("#file-to-upload").get(0).files[0].type) == -1) {
                alert('Error : Not a PDF');
                return;
            }
            // 发送PDF文件的URL
            showPDF(URL.createObjectURL($("#file-to-upload").get(0).files[0]));
        });

        // 向前翻页
        $("#pdf-prev").on('click', function () {
            // 当页码不是第一页时，向前翻页
            if (parseInt(__CURRENT_PAGE) != 1)
                showPage(--__CURRENT_PAGE);
            // 如果是单页盖章
            if (mode_flag == 0) {
                for (var i = 0; i < AllsignPage.length; i++) {
                    var temp = "#selected".concat(i);
                    if (AllsignPage[i] == __CURRENT_PAGE) {
                        $(temp).show();
                    } else {
                        $(temp).hide();
                    }
                }
            } else if (mode_flag == 1) {

            } else if (mode_flag == 2) {
                if (__CURRENT_PAGE != 1) {
                    for (var i = 0; i <= PicCount; i++) {
                        var temp = "#selected".concat(i);
                        $(temp).show();
                    }
                } else {
                    for (var i = 0; i <= PicCount; i++) {
                        var temp = "#selected".concat(i);
                        $(temp).hide();
                    }
                }
            }

        });

        // 向后翻页
        $("#pdf-next").on('click', function () {
            if (__CURRENT_PAGE != __TOTAL_PAGES)
                showPage(++__CURRENT_PAGE);
            // 如果是单页盖章
            if (mode_flag == 0) {
                for (var i = 0; i < AllsignPage.length; i++) {
                    var temp = "#selected".concat(i);
                    if (AllsignPage[i] == __CURRENT_PAGE) {
                        $(temp).show();
                    } else {
                        $(temp).hide();
                    }
                }
            } else if (mode_flag == 1) {

            } else if (mode_flag == 2) {
                if (__CURRENT_PAGE != 1) {
                    for (var i = 0; i <= PicCount; i++) {
                        var temp = "#selected".concat(i);
                        $(temp).show();
                    }
                } else {
                    for (var i = 0; i <= PicCount; i++) {
                        var temp = "#selected".concat(i);
                        $(temp).hide();
                    }
                }
            }
        });

        // 跳转到指定页
        $("#jumpDoc").on('click', function () {
            tempPage = parseInt(document.getElementById("jumpPage").value);
            //符合条件就跳转，否则显示当前页
            if (tempPage >= 1 && tempPage <= __TOTAL_PAGES) {
                __CURRENT_PAGE = tempPage;
                showPage(__CURRENT_PAGE);
                // 如果是单页盖章
                if (mode_flag == 0) {
                    for (var i = 0; i < AllsignPage.length; i++) {
                        var temp = "#selected".concat(i);
                        if (AllsignPage[i] == __CURRENT_PAGE) {
                            $(temp).show();
                        } else {
                            $(temp).hide();
                        }
                    }
                } else if (mode_flag == 1) {

                } else if (mode_flag == 2) {
                    if (__CURRENT_PAGE != 1) {
                        for (var i = 0; i <= PicCount; i++) {
                            var temp = "#selected".concat(i);
                            $(temp).show();
                        }
                    } else {
                        for (var i = 0; i <= PicCount; i++) {
                            var temp = "#selected".concat(i);
                            $(temp).hide();
                        }
                    }
                }
            }
            else {
                document.getElementById("jumpPage").value = __CURRENT_PAGE;
            }

        });

        function doDrag(obj) {
            var posX;
            var posY;
            var dragable;
            var limitObj;
            var clientX, clientY, offsetLeft, offsetTop;
            if (typeof obj == "string")
                obj = document.getElementById(obj);

            limitObj = {
                _left: document.getElementById("pdf-canvas").offsetLeft,
                _top: document.getElementById("pdf-canvas").offsetTop,
                _right: document.getElementById("pdf-canvas").offsetLeft + document.getElementById("pdf-canvas").width - obj.width,
                _bottom: document.getElementById("pdf-canvas").offsetTop + document.getElementById("pdf-canvas").height - obj.height
            };

            obj.onmousedown = function (event) {
                down(event);
            };
            obj.onmouseup = function () {
                up();
            };

            function down(e) {
                e = e || window.event;
                // 记录鼠标按下时的位置及拖动元素的相对位置
                clientX = e.clientX;
                clientY = e.clientY;
                offsetLeft = obj.offsetLeft;
                offsetTop = obj.offsetTop;
                dragable = true;
                document.onmousemove = move;
            }

            function move(ev) {
                if (dragable) {
                    ev = ev || window.event;//如果是IE
                    var x = ev.clientX - clientX + offsetLeft;
                    var y = ev.clientY - clientY + offsetTop;
                    obj.style.left = Math.max(Math.min(x, limitObj._right), limitObj._left) + 'px';
                    obj.style.top = Math.max(Math.min(y, limitObj._bottom), limitObj._top) + 'px';
                    // canvas的左下角为盖章的原点
                    var PDF_origin_point_y = document.getElementById("pdf-canvas").offsetTop + document.getElementById("pdf-canvas").height;
                    var PDF_origin_point_x = document.getElementById("pdf-canvas").offsetLeft;
                    // pic左下角的坐标值
                    var pic_origin_point_y = obj.offsetTop + obj.height;
                    var pic_origin_point_x = obj.offsetLeft;
                    // 盖章点的坐标值
                    // sign_point_y = PDF_origin_point_y - pic_origin_point_y;
                    // sign_point_x = pic_origin_point_x - PDF_origin_point_x;
                    var ImgId = obj.id;
                    var number = ImgId.split("selected")[1];
                    Allsign_x[number] = pic_origin_point_x - PDF_origin_point_x;
                    Allsign_y[number] = PDF_origin_point_y - pic_origin_point_y;
                    ev.preventDefault();
                }
            }

            function up() {
                dragable = false;
            }
        }
    </script>
</div>
</body>
</html>
