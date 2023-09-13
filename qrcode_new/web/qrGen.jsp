<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
    <head>
        <title>Cross-Browser QRCode generator for Javascript</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no" />
        <script type="text/javascript" src="jquery.min.js"></script>
        <script type="text/javascript" src="qrcode.js"></script>
        <script type="text/javascript" src="JsBarcode.all.min.js"></script>


        <script>
            var gen_link = '<%= request.getParameter("link")%>';
            var p_name = '<%= request.getParameter("p_name")%>';
            var p_code = '<%= request.getParameter("p_code")%>';
//            alert("p_name = "+p_name+" p_code ="+p_code);
            
            var download_link = window.location.href;
            download_link = download_link.replace("qrGen.jsp", "View")
            console.log(download_link);


            console.log("in generate QRCODE " + gen_link);





            function printDiv(divName) {
                var printContents = document.getElementById("qrcode").innerHTML;
                var printContents2 = document.getElementById("text1").value;
                
                var originalContents = document.body.innerHTML;

                document.body.innerHTML = printContents2+printContents;

                window.print();

//                document.body.innerHTML = originalContents;
            }
        </script>
    </head>
    <body>

        <center>


            <input id="text1"  type="text" value="http://jindo.dev.naver.com/collie" style="width:80%;margin-bottom: 15px;" /><br />
            <div id="qrcode"  margin-top:15px;"></div>

            <!--<div  style="margin-top: 130px;"> </div>-->
            <button  type="button" style="margin-top: 10%;" onclick="window.printDiv();" class="btn btn-primary float-right">Print</button>
            <!--<svg id="barcode"></svg>-->
        </center>	
        <script>
            var qrcode = new QRCode(document.getElementById("qrcode"), {
                width: 250,
                height: 250
            });

            function makeCode() {
                var elText = document.getElementById("text1");

                if (!elText.value) {
                    alert("Input a text");
                    elText.focus();
                    return;
                }
                var display_text="Product Name = "+p_name+" ||  Product Code = "+p_code;
                document.getElementById("text1").value = display_text;
                qrcode.makeCode(download_link);
            }

            makeCode();

            $("#text").
                    on("blur", function () {
                        makeCode();
                    }).
                    on("keydown", function (e) {
                        if (e.keyCode == 13) {
                            makeCode();
                        }
                    });


        </script>
    </body>