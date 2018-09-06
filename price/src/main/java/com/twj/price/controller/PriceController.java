package com.twj.price.controller;

import com.twj.price.utils.FileUtils;

import freemarker.template.utility.DateUtil;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.WebUtils;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class PriceController {

    private final ResourceLoader resourceLoader;

    @Autowired
    public PriceController(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    @Value("${web.upload-path}")
    private String path;

    String string="11";

    /**
     * 跳转到文件上传页面
     * @return
     */
    @RequestMapping("/")
    public String toUpload(){
        return "test";
    }

    /**
     * 跳转到文件上传页面
     * @return
     */
    @RequestMapping("info")
    public String show(HttpServletRequest request, ServletResponse response,String date,Map<String, Object> map){
        String pathBak="";
        ArrayList<String> files = new ArrayList<String>();
        if(!StringUtils.isEmpty(date)){
            map.put("date",date);
            pathBak=path+date+System.getProperty("file.separator");
        }else{
            Date time=new Date();
            SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyyMMdd");
            String s=simpleDateFormat.format(time);
            pathBak=path+s+System.getProperty("file.separator");
        }
        File file = new File(pathBak);
        File[] tempList = file.listFiles();
        if(file==null||tempList==null||tempList.length<=0){
            map.put("list",null);
            map.put("count",0);
            return "info";
        }
        for (int i = 0; i < tempList.length; i++) {
            if (tempList[i].isFile()) {
                files.add(tempList[i].getName());
            }
            if (tempList[i].isDirectory()) {
            }
        }
        map.put("list",files);
        map.put("count",files.size());
        return "info";
    }

    /**
     *
     * @param files 要上传的文件
     * @return
     */
    @RequestMapping("fileUpload")
    public String upload(@RequestParam("fileName") MultipartFile [] files,@RequestParam("count")Integer count, Map<String, Object> map){
        String pathBak="";
        Date time=new Date();
        SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyyMMdd");
        String s=simpleDateFormat.format(time);
        pathBak=path+s+System.getProperty("file.separator");

        // 上传成功或者失败的提示
        String msg = "";

        List<String> list=new ArrayList<>();
        for (MultipartFile img : files) {
            if (FileUtils.upload(img, pathBak, img.getOriginalFilename())){
                // 上传成功，给出页面提示
                list.add(img.getOriginalFilename());
            }else {
                msg = "上传失败！";
            }
        }
        map.put("list",list);
        map.put("count",count);

        // 显示图片
//        map.put("msg", msg);
//
        return "forward:/";
    }

    /**
     *
     * @param
     * @return
     */
    @RequestMapping("tuozhuai")
    public String tuozhuai(HttpServletRequest request, ServletResponse response, Map<String, Object> map) throws FileUploadException {
        String pathBak="";
        Date time=new Date();
        SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyyMMdd");
        String s=simpleDateFormat.format(time);
        pathBak=path+s+System.getProperty("file.separator");

        String contentType = request.getContentType();
        List<MultipartFile> files = null;
        if (contentType != null && contentType.toLowerCase().startsWith("multipart/")) {
            MultipartHttpServletRequest multipartRequest =
                    WebUtils.getNativeRequest(request, MultipartHttpServletRequest.class);
            files = multipartRequest.getFiles("fileName");
        }

        List<String> list = new ArrayList<>();
        for (MultipartFile img : files) {
            if (FileUtils.upload(img, pathBak, img.getOriginalFilename())) {
                // 上传成功，给出页面提示
                list.add(img.getOriginalFilename());
            } else {
//                msg = "上传失败！";
            }
        }
        map.put("list", list);
        map.put("count", list.size());
        return "forward:/";
    }

    /**
     * 显示单张图片
     * @return
     */
    @RequestMapping("show")
    public ResponseEntity showPhotos(String fileName,String date){
        String pathBak="";
        if(!StringUtils.isEmpty(date)){
            pathBak=path+date+System.getProperty("file.separator");
        }else{
            Date time=new Date();
            SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyyMMdd");
            String s=simpleDateFormat.format(time);
            pathBak=path+s+System.getProperty("file.separator");
        }


        try {
            // 由于是读取本机的文件，file是一定要加上的， path是在application配置文件中的路径
            return ResponseEntity.ok(resourceLoader.getResource("file:" + pathBak + fileName));
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }


    @RequestMapping("/test")
    @ResponseBody
    public String test(String str){
        return str+"Hello World!!!";
    }


    @RequestMapping("/freemarker")
    public String freemarker(Map<String, Object> map){
        map.put("name", "Joe");
        map.put("sex", 1);    //sex:性别，1：男；0：女；

        // 模拟数据
        List<Map<String, Object>> friends = new ArrayList<Map<String, Object>>();
        Map<String, Object> friend = new HashMap<String, Object>();
        friend.put("name", "xbq");
        friend.put("age", 22);
        friends.add(friend);
        friend = new HashMap<String, Object>();
        friend.put("name", "July");
        friend.put("age", 18);
        friends.add(friend);
        map.put("friends", friends);
        return "freemarker";
    }


}
