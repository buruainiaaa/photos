<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>uploadFile</title>
    <script src="http://lib04.xesimg.com/lib/jQuery/1.11.1/jquery.min.js?1514549590"></script>
    <style type="text/css">

        .upload-default {
            border: 1px dashed red;
        }
        .upload-default.upload_drag_hover{
            border: 1px dashed green;
        }
        input{
            appearance: textfield;
            -moz-appearance: textfield;
            -webkit-appearance: textfield;
        }
        input[type="number"]::-webkit-inner-spin-button {
            -webkit-appearance: none;
        }
        input[type="number"]::-webkit-outer-spin-button {
            -webkit-appearance: none;
        }

    </style>
</head>
<body>
<input type="number" min="1" max="10000" step="1">
<input title="点击选择多个文件" id="h5Input1" multiple="" accept="*/*" type="file" name="html5uploader">
<input title="点击选择文件夹" id="h5Input2" multiple="multiple" webkitdirectory="" directory accept="*/*" type="file" name="html5uploader" >
<input title="点击选择单个文件" id="h5Input3"  accept="*/*" type="file" name="file" webkitRelativePath>
<div id="fileDragArea" style="float: left;width: 300px;height: 300px;" class="upload-default">或者将图片拖到此处</div>
</body>
</html>
<script type="text/javascript">
    window.onload = function (){
        document.getElementById('h5Input2').addEventListener('change', function (ev) {
            console.log(ev)
            //预览，主要是文件转换为base64，或者blob，或者canvas
            //file -> base64
            // file为前面获得的
            console.log(document.getElementById('h5Input2').files[0])
            var file = ev.target.files[0]
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = new Image;
                img.src = this.result;  // this.result 为base64
                //console.log(this.result)
                // 加到dom
            };
            reader.readAsDataURL(file);

            //file -> blob

            // file为前面获得的
            var url = window.URL.createObjectURL(file);
            var img = new Image;
            img.src = url;
            //console.log(img)
            // 加到dom
            console.log(file)
            // 上传 需要用到FormData模拟表单数据 或直接form上传
            // var formData = new FormData();
            // formData.append('resourceId', '');
            // // formData.append('file', '');
            // // formData.append('filename', file)
            // formData.append("file", file);
            // var xhr = new XMLHttpRequest();
            // //上传文件进度条
            // xhr.upload.addEventListener("progress", function(e){
            //   console.log('9999')
            //   if (e.total > 0) {
            //     console.log('----进度-----')
            //     console.log(e.loaded, e.total)
            //       e.percent = Math.round(e.loaded / e.total * 100);
            //       console.log( e.percent)
            //       console.log('----进度-----')
            //   }
            // }, false);
            // var url = 'http://courseware.xesv5.com/api/OnlineEdit/upload'
            // xhr.open('post', url, true);
            // xhr.onload = function () {
            //   console.log(4566666)
            // }
            // xhr.send(formData);
            /*********************************************尝试分片，创建多个上传的xhr对象****************************************/
            var bytesPerPiece = 1024 * 1024; // 每个文件切片大小定为1MB
            var totalPieces;
            var blob = file;
            var start = 0;
            var end;
            var index = 0;
            var filesize = blob.size;
            var filename = blob.name;

            //计算文件切片总数
            totalPieces = Math.ceil(filesize / bytesPerPiece);
            while(start < filesize) {
                //判断是否是最后一片文件，如果是最后一篇就说明整个文件已经上传完成
                if (index == totalPieces) {
                    console.log('整个文件上传完成');
                    return false;
                }
                end = start + bytesPerPiece;
                if(end > filesize) {
                    end = filesize;
                }
                var chunk = blob.slice(start,end);//切割文件
                var sliceIndex = index;
                var formData = new FormData();
                formData.append("file", chunk, filename);
                formData.append("total", totalPieces);  //总片数
                formData.append("index", sliceIndex);   //当前是第几片
                var xhr = new XMLHttpRequest();
                //上传文件进度条
                xhr.upload.addEventListener("progress", function(e){
                    if (e.total > 0) {
                        console.log('----进度-----')
                        //e.percent = Math.round(e.loaded / e.total * 100);
                        //(e.loaded当前片文件上传的上传的进度 start是前面分片已经上传完成的文件大小
                        e.percent = 100*(e.loaded+start)/file.size;
                        if(e.pecent > 100){
                            e.percent = 100;
                        }
                        console.log( e.percent)
                        console.log('----进度-----')
                    }
                }, false);
                var url = 'http://courseware.xesv5.com/api/OnlineEdit/upload'
                xhr.open('post', url, true);
                console.log(5)
                xhr.onload = function () {
                    console.log(45)
                }
                xhr.send(formData);
                start = end;
                index++;
            }

            /*********************************************尝试分片****************************************/
        })
    }
    var dragDrop = document.getElementById('fileDragArea');

    //拖拽上传文件
    dragDrop.addEventListener("dragover", function(e) {
        e.stopPropagation();
        //必须阻止默认事件
        e.preventDefault();
        $(this).addClass("upload_drag_hover");
    }, false);
    dragDrop.addEventListener("dragleave", function(e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).removeClass("upload_drag_hover");
    }, false);
    dragDrop.addEventListener("drop", function(e) {
        e.stopPropagation();
        e.preventDefault();
        //取消鼠标经过样式
        $(this).removeClass("upload_drag_hover");
        //获取文件列表对象和文件相对路径
        var files = e.target.files || e.dataTransfer.files;
        var dragDrop = document.getElementById('fileDragArea')
        var items = e.dataTransfer.items
        console.log(items.length)
        for (var i = 0; i < items.length; i++) {
            var item = items[i].webkitGetAsEntry();
            console.log(item)
            if (item) {
                //判断是否为文件夹
                if (item.isDirectory) {
                    traverseFileTree(item)
                } else {
                    //  this.$alert('只支持上传文件夹', '提示', {
                    //      confirmButtonText: '确定'
                    // })
                }
            }
        }

    }, false);
    function traverseFileTree (item, path) {
        path = path || ''
        if (item.isFile) {
            // Get file
            item.file((file) => {
                let obj = {
                    file: file,
                    path: path + file.name
                }
            })
        } else if (item.isDirectory) {
            // Get folder contents
            var dirReader = item.createReader()
            readDir (dirReader, item, path)
        }
    }
    function readDir (dirReader, item, path) {
        dirReader.readEntries((entries) => {
            console.log(entries.length)
        if (entries.length) {
            let obj = {
                name: item.name,
                process: 0,
                total: entries.length
            }
            for (let i = 0; i < entries.length; i++) {
                console.log(entries[i])
                traverseFileTree(entries[i], path + item.name + '/')
            }
            // entries长度不为0，继续调用解析，直至长度为0。因为chrome浏览器只支持一次解析100个
            readDir(dirReader, item, path)
        }
    },function (e) {
            console.log(e)
        })
    }

    dragDrop.addEventListener("dragend", function(e) {
        console.log(9999999999999999999999)
        console.log(e)
    })
</script>