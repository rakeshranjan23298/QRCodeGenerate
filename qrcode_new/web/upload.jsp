<%@page import="java.sql.Connection"%>
<%@page import="mypack.config2"%>
<%@page import="java.io.File"%>
<%@page import="mypack.parser"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%ResultSet resultset = null;%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>QR Code Generate </title>
        <script src="jquery.min.js" type="text/javascript"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">        
    </head>
    <body>
        <%
            try {
                String configFilepath = "";
                session.setAttribute("cfgpath", configFilepath);
                try {
                    File f = new File(configFilepath);
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
                } catch (Exception e) {
                    out.println(e);
                }

                String msg = "";
                String callerid = "";
                String callnumber = "";
                String lrefid = "";
                String lsid = "";
                String leads = "";
                String calltype = "";

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
                <div class="col-lg-12 text-center " style="background-color: lightblue;color:black;margin-top: 5px;padding: 0px; margin-bottom: 5px;">
                    <b> QR CODE </b>
                </div>                
                <div class="col-lg-12 ">  
                    <div class="card" > 
                        <div class="card-header"><span id="span1" onclick="show_hide();" style="float: left; font-size: x-large; color: red;">[-]</span>
                            <b style="margin: 43%">Uploader</b></div>
                            <div class="card-body" id="div_1">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="form-group row">
                                        
                                        <label for="upload_file" class="required col-lg-4 col-form-label" style="padding: 2px;"> Upload File    :</label>
                                        <input type="file" class="form-control col-lg-8"  id="sortpicture" name="sortpic" accept="application/pdf, image/*"> 
                                        <input type="text"  style="display: none;" class="form-control col-lg-8" id="p_data" name="p_data">
                                    </div>  
                                    <div class="form-group row" >
                                        <button  type="button" style="margin-left: 50%; " onclick="javascript:upload_data();" class="btn btn-primary float-right">Upload</button>    
                                    </div>
                                </div>  
                                <div class="col-lg-6">
                                    <div class="form-group row">
                                        <label for="product_name" class="required col-lg-4 col-form-label">Product Name    :</label>
                                        <input type="text"  class="form-control col-lg-8" id="product_name" name="product_name">                              
                                    </div>                                      
                                    <div class="form-group row">
                                        <label for="product_code" class="required col-lg-4 col-form-label">Product Code    :</label>
                                        <input type="text"  class="form-control col-lg-8" id="product_code" name="product_code">                              
                                    </div>
                                </div>
                            </div>                              
                        </div>
                    </div>
                </div>
                <!---------------------------------------------------------     Filter  ---------------------------------------------------------------->

                <div class="col-lg-12 ">  
                    <div class="card" > 
                        <div class="card-header">
                            <span id="span2" onclick="show_hide2();" style="float: left; font-size: x-large; color: red;">[-]</span>
                            <b style="margin: 43%">Search Filter  </b>
                        </div>
                        <div class="card-body" id="div_2">
                            <div class="row">
                                <div class="col-lg-6">
                                    <div class="form-group row">
                                        <label for="p_name" class="required col-lg-4 col-form-label">Product Name    :</label>
                                        <input type="text"  class="form-control col-lg-8" id="p_name" name="p_name">   
                                    </div>  
                                    <div class="form-group row">
                                        <label for="date_of_upload" class="required col-lg-4 col-form-label"> Date Of Upload    :</label>
                                        <input type="date"  class="form-control col-lg-8" id="date_of_upload" name="date_of_upload">   
                                    </div>                                      
                                </div>  
                                <div class="col-lg-6">
                                    <div class="form-group row">
                                        <label for="p_code" class="required col-lg-4 col-form-label">Product Code    :</label>
                                        <input type="text"  class="form-control col-lg-8" id="p_code" name="p_code">                              
                                    </div>
                                    <div class="form-group row">
                                        <button  type="button" onclick="javascript:fncDelete();" style="margin-left: 50%;"  class="btn btn-danger float-right">Delete</button>                                         
                                        <button  type="button" style="margin-left:100px;" onclick="javascript:viewData();" class="btn btn-info float-right">View</button> 
                                    </div>                                    
                                </div>
                            </div>                              
                        </div>
                    </div>
                </div>                
            </div>
        </div>

        <div id="newid"></div>

        <script>
            show_hide();
            show_hide2();
        function show_hide()
        {
            $("#div_1").toggle();
            if($("#span1").html().includes("+"))
            {
               $("#span1").html("[-]");
            }else
            {
                $("#span1").html("[+]");
            }
        }
        function show_hide2()
        {
            $("#div_2").toggle();
            if($("#span2").html().includes("+"))
            {
               $("#span2").html("[-]");
            }else
            {
                $("#span2").html("[+]");
            }
        }           
            
            
            
            var upload_file = "";
            function  upload_data()
            {
                var product_name = document.getElementById("product_name").value;
                var product_code = document.getElementById("product_code").value;
                if (product_code == '' || product_name == '')
                {
                    alert("All Fields Mandatory");
                    return false;
                }
                console.log(" file uploading :-");
                var formData = new FormData();
                var filesLength = document.getElementById('sortpicture').files.length;
                if (filesLength < 1)
                {
                    alert("Please Select File To Upload");
                    return false;
                } else
                {
                    for (var i = 0; i < filesLength; i++) {
                        formData.append("file[]", document.getElementById('sortpicture').files[i]);
                    }
//                  var order_id = $("#p_data").val();
                    formData.append('product_name', product_name);
                    formData.append('product_code', product_code);
                    console.log(formData);

                    $.ajax({
                        url: 'Te',
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
                var product_name = document.getElementById("product_name").value;
                var product_code = document.getElementById("product_code").value;
                var url = param.trim();
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
                        alert(response);
                        location.reload();
//                        viewData();
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
                xmlhttp.send("type=save&url=" + url + "&product_name=" + product_name + "&product_code=" + product_code);

//                xmlhttp.open("GET", "Getstatus?type=save&url=" + url, true);
//                xmlhttp.send();
            }

            function viewData()
            {
                var p_name = document.getElementById("p_name").value;
                var p_code = document.getElementById("p_code").value;
                var date_of_upload = document.getElementById("date_of_upload").value;


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
                        console.log(response);
                        $("#newid").html(response);
//                        $(document).ready(function (){
//                            $("#example_filter").css("float","right");
//                        });
                    }
                }
                xmlhttp.open("GET", "Getstatus?type=viewData&p_name=" + p_name.trim() + "&p_code=" + p_code.trim() + " &date_of_upload= " + date_of_upload.trim(), true);
                xmlhttp.send();
            }
            var id = [];
            function show(param)
            {
                var check = $('#id_' + param).is(':checked');
                if (check) {
                    id.push(param);
                } else
                {
                    id = id.filter(function (data) {
                        return data != param;
                    });
                }
            }

            function fncDelete()
            {
                if(id=='')
                {
                    alert("Select Before Delete");
                    return false;
                }
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
                        alert(response);
                        location.reload();
                    }
                }
                xmlhttp.open("GET", "Getstatus?type=deleteData&d_id=" + id, true);
                xmlhttp.send();

            }

            function show1(param)
            {
                var link_id = "link_" + param;
                var link = document.getElementById(link_id).innerHTML;
                var p_name = document.getElementById("p_name_"+param+"").innerHTML;
                var p_code = document.getElementById("p_code_"+param+"").innerHTML;
                
//              alert("p_name in upload jsp ="+p_name+" p_code ="+p_code);
                window.open("qrGen.jsp?&link=" + link+"&p_name="+p_name+"&p_code="+p_code, "", 'width=400, height=400,menubar=no,titlebar=no,top=250px,left=350px,status=no');

            }
            function ViewImage(param)
            {
                var url = param;
                url = url.replace("'", "");
                url = url.replace("'", "");
                url = url.replace("'", "");
                url = url.replace("'", "");
                window.open("View?&link=" + url, "", 'width=1100, height=400,');

            }


        </script>
    </body>
</html>
<%  if (resultset != null) {
            try {
                resultset.close();
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
    }%>