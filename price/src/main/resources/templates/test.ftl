<!DOCTYPE html>
<head>
    <meta charset="UTF-8" />
    <title>照片自动筛选系统</title>
    <script src="jquery-3.3.1.min.js" type="text/javascript" ></script>
    <script type="text/javascript">
        $(function(){
            //阻止浏览器默认行。
            $(document).on({
                dragleave:function(e){    //拖离
                    e.preventDefault();
                },
                drop:function(e){  //拖后放
                    e.preventDefault();
                },
                dragenter:function(e){    //拖进
                    e.preventDefault();
                },
                dragover:function(e){    //拖来拖去
                    e.preventDefault();
                }
            });
            var box = document.getElementById('drop_area'); //拖拽区域
            box.addEventListener("drop",function(e){
                e.preventDefault(); //取消默认浏览器拖拽效果
                var fileList = e.dataTransfer.files; //获取文件对象
                //检测是否是拖拽文件到页面的操作
                if(fileList.length == 0){
                    return false;
                }
                //检测文件是不是图片
//                if(fileList[0].type.indexOf('image') === -1){
//                    alert("您拖的不是图片！");
//                    return false;
//                }

                //拖拉图片到浏览器，可以实现预览功能
//                var img = window.URL.createObjectURL(fileList[0]);
//                var filename = fileList[0].name; //图片名称
//                var filesize = Math.floor((fileList[0].size)/1024);
//                if(filesize>500){
//                    alert("上传大小不能超过500K.");
//                    return false;
//                }
//                var str = "<img src='"+img+"'><p>图片名称："+filename+"</p><p>大小："+filesize+"KB</p>";
//                $("#preview").html(str);

                //上传
                xhr = new XMLHttpRequest();
                xhr.open("post", "tuozhuai", true);
                xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");

                var fd = new FormData();
                for(var i=0;i<fileList.length;i++){
                fd.append('fileName', fileList[i]);
                }
                xhr.send(fd);
                alert("稍后！");
            },false);
        });

        setTimeout(function(){
            document.getElementsByTagName('body')[0].style.height = window.innerHeight+'px';
        },20);
    </script>

</head>
<body style="width: 100%;height: 100%">


<div id="drop_area" style="width: 100%;height: 100%; background-color: azure">


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