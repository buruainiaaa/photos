<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <title>照片自动筛选系统</title>
    <script src="jquery-3.3.1.min.js" type="text/javascript" ></script>
</head>
<body style="width: 100%;height: 100%">


<div id="drop_area" style="width: 100%;height: 100%; background-color: azure">


<#if list??>
    <#list list as l>
        <img src="/show?fileName=${l}" style="width: 200px"/>
    </#list>
</#if>

</div>
<#--<div id="preview" style="width: 500px;height: 500px;background-color: aquamarine"></div>-->




    <#--&lt;#&ndash;显示图片，一定要在img中的src发请求给controller，否则直接跳转是乱码&ndash;&gt;-->
        <#--<#if fileName??>-->
            <#---->
            <#--<#else>-->
                <#--<img src="/show" style="width: 100px"/>-->
        <#--</#if>-->
</body>
</html>