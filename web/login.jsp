<%--
    Created by IntelliJ IDEA.
    User: Aymdr
    Date: 2019/12/3
    Time: 20:41
    To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>兰州卓凡电子科技有限公司印章管理系统</title>
    <link href="css/login.css" rel="stylesheet" rev="stylesheet" type="text/css" media="all"/>
    <script type="text/javascript" src="js/jQuery1.7.js"></script>
    <script type="text/javascript" src="js/jquery-1.8.2.min.js"></script>
    <script type="text/javascript" src="js/jquery1.42.min.js"></script>
    <script type="text/javascript" src="js/jquery.SuperSlide.js"></script>
    <script type="text/javascript" src="js/Validform_v5.3.2_min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var $tab_li = $('#tab ul li');
            $tab_li.hover(function () {
                $(this).addClass('selected').siblings().removeClass('selected');
                var index = $tab_li.index(this);
                $('div.tab_box > div').eq(index).show().siblings().hide();
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            /*学生登录信息验证*/
            $("#name").focus(function () {
                var username = $(this).val();
                if (username == '输入用户名') {
                    $(this).val('');
                }
            });
            $("#name").focusout(function () {
                var username = $(this).val();
                if (username == '') {
                    $(this).val('输入用户名');
                }
            });
            $("#pw").focus(function () {
                var username = $(this).val();
                if (username == '输入密码') {
                    $(this).val('');
                }
            });
            $("#pw").focusout(function () {
                var username = $(this).val();
                if (username == '') {
                    $(this).val('输入密码');
                }
            });
            $("#admin-name").focus(function () {
                var username = $(this).val();
                if (username == '输入管理员帐号') {
                    $(this).val('');
                }
            });
            $("#admin-name").focusout(function () {
                var username = $(this).val();
                if (username == '') {
                    $(this).val('输入管理员帐号');
                }
            });
            $("#admin-pw").focus(function () {
                var username = $(this).val();
                if (username == '输入管理员密码') {
                    $(this).val('');
                }
            });
            $("#admin-pw").focusout(function () {
                var username = $(this).val();
                if (username == '') {
                    $(this).val('输入管理员密码');
                }
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            $(".screenbg ul li").each(function () {
                $(this).css("opacity", "0");
            });
            $(".screenbg ul li:first").css("opacity", "1");
            var index = 0;
            var t;
            var li = $(".screenbg ul li");
            var number = li.size();

            function change(index) {
                li.css("visibility", "visible");
                li.eq(index).siblings().animate({opacity: 0}, 3000);
                li.eq(index).animate({opacity: 1}, 3000);
            }

            function show() {
                index = index + 1;
                if (index <= number - 1) {
                    change(index);
                } else {
                    index = 0;
                    change(index);
                }
            }

            t = setInterval(show, 8000);
            //根据窗口宽度生成图片宽度
            var width = $(window).width();
            $(".screenbg ul img").css("width", width + "px");
        });
    </script>
</head>

<body>
<div id="tab">
    <ul class="tab_menu">
        <li class="selected">用户登录</li>
        <li>注册</li>
    </ul>
    <div class="tab_box">
        <!-- 用户登录开始 -->
        <div>
            <div class="stu_error_box"></div>
            <form id="login-form" action="login" method="post" onsubmit="return check();" class="stu_login_error">
                <div id="username">
                    <label>用户名：</label>
                    <input type="text" id="name2" name="username" value="" nullmsg="用户名不能为空！"/>
                </div>
                <div id="password">
                    <label>密&nbsp;&nbsp;&nbsp;码：</label>
                    <input type="password" id="pw" name="password" value="" nullmsg="密码不能为空！" datatype="*6-16"
                           errormsg="密码范围在6~16位之间！"/>
                </div>
                <div id="login">
                    <input type="button" value="登录" id="button1111" onclick="login()">
                </div>
            </form>
        </div>

        <!-- 注册开始-->
        <div class="hide">
            <div class="sec_error_box"></div>
            <form id="form1" action="register" method="post" class="tea_login_error" onsubmit="return validate()">
                <div id="UserId">
                    <label>用户ID：</label>
                    <input type="text" id="userID1" name="userID" value="" nullmsg="用户ID不能为空！">
                </div>
                <div id="Name">
                    <label>姓&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：</label>
                    <input type="text" id="name1" name="name" value="" nullmsg="姓名不能为空！"/>
                </div>
                <div id="UserName">
                    <label>用&nbsp;&nbsp;户&nbsp;&nbsp;名：</label>
                    <input type="text" id="username1" name="username" value="" nullmsg="用户名不能为空！">
                </div>
                <div id="Password">
                    <label>密&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;码：</label>
                    <input type="password" id="userPwd" name="userPwd" value="" placeholder="密码至少为6位！">
                </div>
                <div id="RePassword">
                    <label>确认密码：</label>
                    <input type="password" id="userRePwd" name="userRePwd">
                </div>
                <div id="Uid">
                    <label>U盾ID：</label>
                    <span>
                        <input type="text" value="5eb29fb46acb8332cbe3978306c6e50e" id="device_id" class="forbutton" name="device_id">
                        <input type="button" value="获取ID" class="forbutton" onclick="getDeviceID()">
                    </span>
                </div>
                <div id=" register1">
                    <input type="button" value="注册" id="button111" onclick="register()">
                </div>
            </form>
        </div>
    </div>
</div>
<div class="bottom">©2020 版权所属：兰州卓凡电子科技有限公司</div>
<div class="screenbg">
    <ul>

        <li><a href="javascript:;"><img src="./picture/Background.jpg"></a></li>

    </ul>
</div>
<script type="text/javascript" src="./js/NTClientJavascript.js"></script>
<script language="javascript" type="text/javascript">
    function check() {
        // 在这里将u盾的唯一的码填入前端的一个隐藏的input框，然后传入后台，在userDAO中判断与数据库中的值是否一致
        var flag1 = NT199_Find();
        if (flag1 != 0) {
            var uid = NT199_GetHardwareId();
            document.getElementById("UID").value = uid;
        }
        else {
            var err = NT199_GetLastError();
            out.print(err);
        }

        var flag = true;
        var admin = document.getElementById("name2").value;
        var password = document.getElementById("pw").value;

        if (admin.length == 0) {
            alert("请输入账号！");
            flag = false;
            return false;
        }
        if (password.length == 0) {
            alert("请输入密码！");
            flag = false;
            return false;
        }
        // if (uid.length == 0) {
        //     alert("请插入U盾！");
        //     flag = false;
        //     return false;
        // }
        if (flag == true) {
            return true;
        }
    }

</script>
<script>
    // $("#register").unbind.bind("click", function () {
    //     register();
    // });

    $("#demo_img").bind("click",function () {
        var demo_img = document.getElementById("demo_img");
        var demoInput = document.getElementById("demo_input");
        if (demoInput.type == "password") {
            demoInput.type = "text";
            demo_img.src = "./picture/invisible.png";
        }else {
            demoInput.type = "password";
            demo_img.src = "./picture/visible.png";
        }
    });

    function register() {
        if(validate()){
            var userID = $("#userID1").val();
            var name = $("#name1").val();
            var username = $("#username1").val();
            var password = $("#userPwd").val();
            var repassword = $("#userRePwd").val();
            var deviceID = $("#device_id").val();

            try{
                $.ajax({
                    async:false,
                    catch:false,
                    type: "post",
                    data: {"userID":userID,"name":name,"username": username,"password":password,"repassword":repassword,"deviceID":deviceID},
                    url: '/register',
                    dataType : 'json',
                    success: function (data){
                        if (data.result1==1){
                            alert("注册成功！")
                            window.open("/login.jsp",'_self');
                        }else {
                            alert("注册失败,请检查用户ID是否正确！")
                            window.open("/login.jsp",'_self') ;
                        }
                    },
                    error: function (e) {
                        alert("发送注册请求失败！")
                        window.open("/login.jsp",'_self') ;
                    }
                });
            }catch (e) {
                alert("注册失败！");
            }
        }
    }

    function login() {
        // var formData = new FormData($("#login-form")[0]);
        var username = $("#name2").val();
        var password = $("#pw").val();
        $.ajax({
            async: false,
            cache: false,
            type: "post",
            data:  {"username": username,"password":password},
            url: '/login',
            dataType : 'json',
            success: function (data) {
                var res = data;
                if (res.result1=="0"){
                    alert("密码或U盾错误！")
                    window.open("/login.jsp",'_self');
                }else if(res.result1=="2"){
                    window.open("/HomePage.jsp?user_name="+ username,'_self') ;
                }else{
                    window.open("/admin.jsp",'_self') ;
                }
            },
            error: function (e) {
                console.log(e)
                alert("发送登录请求失败！")
            }
        });
    }

    function login1() {
        var formData = new FormData($("#login-form1")[0]);
        $.ajax({
            async: false,
            cache: false,
            type: "post",
            data: formData,
            url: '/login',
            //dataType : 'json',
            contentType: false, //必须
            processData: false, //必须
            success: function (data) {

                // console.log('success');
            },
            error: function (e) {
                alert("登录失败！")
                // console.log(arg1 + "--" + arg2 + "--" + arg3);
            }
        });
    }

    function getDeviceID() {
        var flag = NT199_Find();
        if (flag != 0) {
            var uid = NT199_GetHardwareId();
            var obj = document.getElementById('device_id');
            obj.value = uid;
        }
        else {
            var err = NT199_GetLastError();
            alert(err);
        }
    }

    function validate(){
        var ID = document.getElementById("userID1").value;
        var name = document.getElementById("name1").value;
        var username = document.getElementById("username1").value;
        var deviceID = document.getElementById("device_id").value;
        var word1= document.getElementById("userPwd").value;
        var word2 = document.getElementById("userRePwd").value;
        if(ID==""){
            window.alert("用户ID不能为空！");
            return false;
        }
        if(name==""){
            window.alert("姓名不能为空！");
            return false;
        }
        if(username==""){
            window.alert("用户名不能为空！");
            return false;
        }
        if(deviceID==""){
            window.alert("U盾ID不能为空！");
            return false;
        }
        if(word1==""){
            window.alert("密码不能为空！");
            return false;
        }
        if(word2==""){
            window.alert("确认密码不能为空！");
            return false;
        }
        if(word1 != word2){
            window.alert("两次输入的新密码不一致！");
            return false;
        }
        if(word1.length<6){
            window.alert("密码长度至少为6位！");
            return false;
        }
        return true;
    }

</script>
</body>
<script>
    var errori = '<%=request.getParameter("err")%>';
    if (errori == 'yes') {
        alert("用户名重复，请重新注册！");
    }
</script>
</html>
