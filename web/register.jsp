<%--&lt;%&ndash;--%>
  <%--Created by IntelliJ IDEA.--%>
  <%--User: Aymdr--%>
  <%--Date: 2019/12/15--%>
  <%--Time: 15:58--%>
  <%--To change this template use File | Settings | File Templates.--%>
<%--&ndash;%&gt;--%>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
    <%--<title>Title</title>--%>
<%--</head>--%>
<%--<body>--%>
<%--<script type="text/javascript" src="./js/NTClientJavascript.js"></script>--%>
<%--<br><br><br>--%>
<%--<h3 align = "center">注册页面</h3>--%>
<%--<hr>--%>
<%--<form align = "center" action="register" method="post" accept-charset="UTF-8" onsubmit="return validate()">--%>
    <%--<table align = "center" border="0">--%>
        <%--<tr><td>用户id</td><td><input type="text" id="userID" name="userID" ></td></tr>--%>
        <%--<tr><td>姓名</td><td><input type="text" id="name" name="name" ></td></tr>--%>
        <%--<tr><td>用户名</td><td><input type="text" id="username" name="username" ></td></tr>--%>
        <%--<tr><td>密码</td><td><input type="password" id="userPwd" name="userPwd" placeholder="密码至少为6位！"></td></tr>--%>
        <%--<tr><td>确认密码</td><td><input type="password" id="userRePwd" name="userRePwd" ></td></tr>--%>
        <%--&lt;%&ndash;按按钮以后就会自动填充u盾id&ndash;%&gt;--%>
        <%--<tr><td>U盾ID</td><td><input type="text" value="" id="device_id" name="device_id" ></td>--%>

            <%--<td><button type="button"  onclick="getDeviceID()">获取id</button></td>--%>
        <%--</tr>--%>
        <%--<tr><td align = "center" colspan="2"><input type="submit" value = "注册"  style="color:blue"></td></tr>--%>
    <%--</table>--%>

<%--</form>--%>
<%--<script type="text/javascript">--%>
    <%--function getDeviceID(){--%>
        <%--var flag=NT199_Find();--%>
        <%--if(flag!=0){--%>
            <%--var uid = NT199_GetHardwareId();--%>
            <%--var obj= document.getElementById('device_id');--%>
            <%--obj.value=uid;--%>
        <%--}--%>
        <%--else{--%>
            <%--var err=NT199_GetLastError();--%>
            <%--out.print(err);--%>
        <%--}--%>
    <%--}--%>

    <%--function validate(){--%>
        <%--var ID = document.getElementById("userID").value;--%>
        <%--var name = document.getElementById("name").value;--%>
        <%--var username = document.getElementById("username").value;--%>
        <%--var deviceID = document.getElementById("device_id").value;--%>
        <%--var word1= document.getElementById("userPwd").value;--%>
        <%--var word2 = document.getElementById("userRePwd").value;--%>
        <%--if(ID==""){--%>
            <%--document.getElementById("userID").innerHTML="用户ID不能为空！";--%>
            <%--window.alert("用户ID不能为空！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--if(name==""){--%>
            <%--document.getElementById("name").innerHTML="姓名不能为空！";--%>
            <%--window.alert("姓名不能为空！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--if(username==""){--%>
            <%--document.getElementById("username").innerHTML="用户名不能为空！";--%>
            <%--window.alert("用户名不能为空！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--if(deviceID==""){--%>
            <%--document.getElementById("device_id").innerHTML="U盾ID不能为空！";--%>
            <%--window.alert("U盾ID不能为空！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--if(word1==""){--%>
            <%--document.getElementById("userPwd").innerHTML="密码不能为空！";--%>
            <%--window.alert("密码不能为空！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--if(word2==""){--%>
            <%--document.getElementById("userRePwd").innerHTML="确认密码不能为空！";--%>
            <%--window.alert("确认密码不能为空！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--if(word1 != word2){--%>
            <%--window.alert("两次输入的新密码不一致！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--if(word1.length<6){--%>
            <%--window.alert("密码长度至少为6位！");--%>
            <%--return false;--%>
        <%--}--%>
        <%--// return true;--%>
    <%--}--%>

<%--</script>--%>

<%--</body>--%>
<%--<script>--%>
    <%--var errori ='<%=request.getParameter("err")%>';--%>
    <%--if(errori=='yes'){--%>
        <%--alert("用户名重复，请重新注册！");--%>
    <%--}--%>
<%--</script>--%>
<%--</html>--%>
