<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <title>照片自动筛选系统</title>
</head>
<body>
<h1 >照片自动筛选系统</h1>
<form action="fileUpload" method="post" enctype="multipart/form-data">
    <p><label for="files" style="background-color: burlywood">选&nbsp;&nbsp;&nbsp;&nbsp;择</label>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <input style="display: none" type="file"  id="files"  multiple="" accept="*/*"  name="fileName"/><input type="submit" value="自动筛选"/></p>
        筛选数量:<input name="count" type="text">
</form>

<#if list??>
    <#list list as l>
        <img src="/show?fileName=${l}" style="width: 200px"/>
    </#list>
</#if>


    <#--&lt;#&ndash;显示图片，一定要在img中的src发请求给controller，否则直接跳转是乱码&ndash;&gt;-->
        <#--<#if fileName??>-->
            <#---->
            <#--<#else>-->
                <#--<img src="/show" style="width: 100px"/>-->
        <#--</#if>-->
</body>
</html>