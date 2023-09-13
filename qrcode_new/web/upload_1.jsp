<%-- 
    Document   : upload
    Created on : 24 May, 2023, 1:00:07 PM
    Author     : rakes
--%>
<%@page import="mypack.config2"%>


<%@page import="mypack.parser"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>QR Code Generate </title>
        <script src="jquery.min.js" type="text/javascript"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">        
    </head>
    <!--<body onload="viewData();">-->
    <body>
        <%
            try {
                String configFilepath = "";
                //String configFilepath = "E:\\drive\\Spk_Agent_Desktop\\config.xml";
                //String configFilepath = "G:\\work\\latest\\Spk_Agent_Desktop_final\\config.xml";
                session.setAttribute("cfgpath", configFilepath);
                try {
                    File f = new File(configFilepath);
                    //System.out.println(configFilepath);
                    if (f.exists()) {
                        parser k = new parser();
                        k.parse(f);
                    } else {
                        String rootPath = request.getRealPath("/");
                        f = new File(rootPath + "config.xml");
                        if (f.exists()) {
                            parser k = new parser();
                            k.parse(f);
                        } else {
                            rootPath += "\\";
                            f = new File(rootPath + "config.xml");
                            if (f.exists()) {
                                parser k = new parser();
                                k.parse(f);
                            } else {
                                out.println("Config file not found");
                            }
                        }
                    }
                } catch (Exception e) 
                {
                    out.println(e);
                }
                String msg = "";
                String callerid = "";
                String callnumber = "";
                String lrefid = "";
                String lsid = "";
                String leads = "";
                String calltype = "";
                String accountid1 = "";
                String sname = "";
                String scode = "";
                String sprice = "";
                String batchname = "";
                String batchid = "";
                String cdnd = "";
                String output = "";

                if (request.getParameterMap().containsKey("lrefid")) {
                    lrefid = request.getParameter("lrefid");
                    out.println("<input type='text' style='display:none' id='lrefid' value='" + lrefid + "'>");
                }
                if (request.getParameterMap().containsKey("transinfo")) {
                    String val = request.getParameter("transinfo");
                    if (!val.equals("")) {
                        out.println("This is the transferred call from " + val);
                    }
                }
                if (request.getParameterMap().containsKey("callerid")) {
                    callerid = request.getParameter("callerid");
                    out.println("<input type='text' style='display:none' id='leadcid' value='" + callerid + "'>");
                }
                if (request.getParameterMap().containsKey("callnumber")) {
                    callnumber = request.getParameter("callnumber");
                    out.println("<input type='text' style='display:none' id='callnumber' value='" + callnumber + "'>");
                }
                if (request.getParameterMap().containsKey("lsid")) {
                    lsid = request.getParameter("lsid");
                    out.println("<input type='text' style='display:none' id='leadsid' value='" + lsid + "'>");
                }
                if (request.getParameterMap().containsKey("leads")) {
                    leads = request.getParameter("leads");
                    out.println("<input type='text' style='display:none' id='leads' value='" + leads + "'>");
                }
                if (request.getParameterMap().containsKey("ctype")) {
                    calltype = request.getParameter("ctype");
                    out.println("<input type='text' style='display:none' id='calltype' value='" + calltype + "'>");
                }
                out.println("<input type='text' style='display:none' id='batch_name' >");
                out.println("<input type='text' style='display:none' id='batch_id' >");
                Connection conn = config2.getconnection();
                if (conn == null) {
                    out.println("Error : Could not connect to database");
                    return;
                }
                PreparedStatement prest = null;
                ResultSet rs = null;
                String output11 = "";
        %>
        <div class="container" p-0 m-0>
            <div class="row">  
                <div class="col-lg-12 text-center " style="background-color: lightblue;color:black;margin-top: 10px;padding: 10px; margin-bottom: 15px;"> QR CODE </div>
                <div class="col-lg-12 text-center"> 
                    <div class="form-group row">
                        <label for="upload_file" class="required col-lg-4 col-form-label">Upload File    :</label>
                        <!--<input type="file" class="form-control col-lg-8" onchange="upload_data();" id="sortpicture" name="sortpic" accept="application/pdf, image/*">--> 
                        <input type="file" class="form-control col-lg-8"  id="sortpicture" name="sortpic" accept="application/pdf, image/*"> 
                        <input type="text"  style="display: none;" class="form-control col-lg-8" id="p_data" name="p_data">
                    </div>                     
                </div>

                <button  type="button" style="margin-left: 50%; " onclick="javascript:upload_data();" class="btn btn-primary float-right">Upload</button>                
            </div>
        </div>
        <div id="newid"></div>

        <script>
            var upload_file = "";
            function  upload_data()
            {

                console.log(" file uploading :-");
                var formData = new FormData();
                var filesLength = document.getElementById('sortpicture').files.length;
                if (filesLength < 1)
                {

                    alert("Please Select File To Upload");
                } else
                {


                    for (var i = 0; i < filesLength; i++) {
                        formData.append("file[]", document.getElementById('sortpicture').files[i]);
                    }

                    var order_id = $("#p_data").val();
                    formData.append('p_data', order_id);
                    console.log(formData);

                    $.ajax({
                        url: 'UploadStream',
                        cache: false,
                        contentType: false,
                        processData: false,
                        data: formData,
                        type: 'post',
                        success: function (data)
                        {
                            var path_location = data;
                            upload_file = path_location;
                            console.log("after spliting address =" + upload_file);
                            fncSave(upload_file);
                        }
                    });
                }
            }

            function fncSave(param)
            {

//                var url = param;
                
                var url = param;
                url = url.replace("'", "");
                url = url.replace("'", "");
                url = url.replace("'", "");
                url = url.replace("'", "");                
                
                
                var xmlhttp = null;
                if (window.XMLHttpRequest)
                {// code for IE7+, Firefox, Chrome, Opera, Safari
                    xmlhttp = new XMLHttpRequest();
                } else
                {// code for IE6, IE5
                    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                }
                xmlhttp.onreadystatechange = function ()
                {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
                    {
                        var response = xmlhttp.responseText;
                        alert("save response =" + response);
                        viewData();
                        if (response.match("success") == "success")
                        {
//                             alert("Data saved successfully");

                        } else
                        {

                        }
                    }
                }
                        xmlhttp.open("POST", "Getstatus", true);
                        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                        xmlhttp.send("type=save&url=" + url);    
               
//                xmlhttp.open("GET", "Getstatus?type=save&url=" + url, true);
//                xmlhttp.send();
            }

            function viewData()
            {
                console.log("Viewing data");
                var xmlhttp = null;
                if (window.XMLHttpRequest)
                {
                    xmlhttp = new XMLHttpRequest();
                } else
                {
                    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                }
                xmlhttp.onreadystatechange = function ()
                {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
                    {
                        var response = xmlhttp.responseText;
                        console.log("response on get=" + response);
                        $("#newid").html(response);
//                        $(document).ready(function (){
//                            $("#example_filter").css("float","right");
//                        });

                    }
                }
                xmlhttp.open("GET", "Getstatus?type=viewData", true);
                xmlhttp.send();
            }
            function show1(param)
            {
//                window.open("QR.html");
                var link_id = "link_" + param;
                var link = document.getElementById(link_id).innerHTML;
                window.open("qrGen.jsp?&link=" + link, "", 'width=1100, height=400,');

            }
            
            
















        </script>



    </body>

    <%                  if (rs != null) {
                    try {
                        rs.close();
                    } catch (Exception e) {
                    }
                }

                if (prest != null) {
                    try {
                        prest.close();
                    } catch (Exception e) {
                    }
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (Exception e) {
                    }
                }
            } catch (Exception e) {
                out.println(e);

            }

    %>    
</html>
