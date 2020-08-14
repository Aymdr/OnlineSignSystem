<%--
  Created by IntelliJ IDEA.
  User: Aymdr
  Date: 2020/1/3
  Time: 10:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<tr><td>U盾ID</td><td><input type="text" value="" id="device_id" name="device_id" ></td>
    <td><button type="button"  onclick="getDeviceID()">获取id</button></td>
</tr>

<script type="text/javascript">
    function getDeviceID(){
        var uid = NT199_GetHardwareId();
        var err=NT199_GetLastError();
        var obj= document.getElementById('device_id');
        obj.value=uid;
    }

    function validate(){
        //onclick="return validate()"给submit会出现及时提示密码不一样但依旧提示插入成功的情况？
        var word1= document.getElementById("userPwd").value;
        var word2 = document.getElementById("userRePwd").value;
        if(word1 != word2){
            window.alert("两次输入的新密码不一致！");
            return false;
        }
        return true;
    }

</script>

</body>
</html>
