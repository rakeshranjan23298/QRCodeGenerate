package mypack;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Getstatus extends HttpServlet {

    private Object conn;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession();
        try {
            String type = request.getParameter("type");

            if (type.equals("viewData")) {
                String p_name = request.getParameter("p_name");
                String p_code = request.getParameter("p_code");
                p_code=p_code.trim();
                String date_of_upload = request.getParameter("date_of_upload");
//-----------------------------------------------------------------------------------------------------------------------------

                String sub_query = "";
                if (!p_name.equalsIgnoreCase("")) {
                    if (sub_query.equalsIgnoreCase("")) {
                        sub_query = "WHERE product_name LIKE '%"+p_name+"%'";
                    } else {
                        sub_query += " AND product_name LIKE '%"+p_name +"%'";
                    }
                }
                if (!p_code.equalsIgnoreCase("")) {
                    if (sub_query.equalsIgnoreCase("")) {
                        sub_query = "WHERE product_code = '"+p_code+"'";
                    } else {
                        sub_query += " AND product_code ='"+p_code+"'";
                    }
                }
                if (!date_of_upload.equalsIgnoreCase("")) {
                    if (sub_query.equalsIgnoreCase("")) {
                        sub_query = "WHERE DATE(date_of_upload) ='"+date_of_upload+"'";
                    } else {
                        sub_query += " AND DATE(date_of_upload) ='"+date_of_upload+"'";
                    }
                }
                String query = "Select * from upload_db " + sub_query;

//---------------------------------------------------------------------------------------------------------------------------------
                try {
                    Connection conn = config2.getconnection();
                    String ip = config2.databaseip;
                    if (conn == null) {
                        out.println("Error : Could not connect to database");
                        return;
                    }

                    String url = "",product_name="",product_code="";
                    String id = "";
                    String sql0 = "";
                    PreparedStatement prest = null;
                    ResultSet rs = null;

//                  sql0 = "select * from upload_db;";
                    sql0 = query;

                    System.out.println("from customer dump == " + sql0);
                    prest = conn.prepareStatement(sql0);
                    rs = prest.executeQuery();

                    out.println("<table  width=90% height=70% style='background-color:#EA7317;text-align:center; margin-top:1%; margin: 100px;'  border=\"1\" cellspacing=\"0\" cellpadding=\"1\" >");
                    out.println("<tr style= color:white;><th>#</th><th>ID</th><th>LINK</th><th>QR CODE</th><th style='display:none;'>Product Name</th><th style='display:none;'>Product code</th></tr>");
                    int countt = 3;
                    while (rs.next()) {
                        url = rs.getString("link");
                        id = rs.getString("id");
                        product_name=rs.getString("product_name");
                        product_code=rs.getString("product_code");
                        if (countt % 2 == 1) {
                            out.println("<tr  style='background:#E9E9E9;  text-align: center;'><td><input type='checkbox' id='id_"+id+"' onclick='show(\""+id+"\")' value="+id+"></td><td>" + id + "</td><td>" + "<a id='link_" + id + "'  href=\"#\"  onclick='ViewImage(\"" + url + "\");'>" + url + "</a>" + "</td><td>" + " <button type='button' style='text-align: center; align:center; ' onclick='show1(\"" + id + "\")' ; >Generate QR Code</button> " + "</td><td id='p_name_"+id+"' style='display:none;'>"+product_name+"</td><td id='p_code_"+id+"' style='display:none;'>"+product_code+"</td></tr>");

                        } else if (countt % 2 == 0) {
                            out.println("<tr  style='background:#73BFB8;  text-align: center;'><td><input id='id_"+id+"' type='checkbox' onclick='show(\""+id+"\")' value="+id+"></td><td>" + id + "</td><td>" + "<a id='link_" + id + "'  href=\"#\"  onclick='ViewImage(\"" + url + "\");'>" + url + "</a>" + "</td><td>" + " <button type='button' style='text-align: center; align:center; ' onclick='show1(\"" + id + "\")' ; >Generate QR Code</button> " + "</td><td id='p_name_"+id+"' style='display:none;'>"+product_name+"</td><td id='p_code_"+id+"' style='display:none;'>"+product_code+"</td></tr>");
                        }
                        countt++;
                    }
                    out.println("</table>");

//                    rs.close();
//                    prest.close();
//                    conn.close(); 
                    if (rs != null) {
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
                    out.println("Exception : " + e);

                }
            } else if (type.equals("save")) {
                try {
                    Connection conn = config2.getconnection();
                    if (conn == null) {

                        out.println("Error : Could not connect to database");
                        return;
                    }

                    String url = request.getParameter("url");
                    String product_name = request.getParameter("product_name");
                    String product_code = request.getParameter("product_code");
                    String sql0 = "";

                    PreparedStatement prest = null;
                    ResultSet rs = null;
                    ResultSet rs1 = null;

                    String sql = "insert into upload_db("
                            + "link,"
                            + "product_name,"
                            + "product_code"
                            + ") "
                            + "values "
                            + " ("
                            + "'" + url + "',"
                            + "'" + product_name + "',"
                            + "'" + product_code + "'"
                            + ")";

                    System.out.println("Insert crm  : " + sql);

                    prest = conn.prepareStatement(sql);
                    prest.executeUpdate();
                    if (prest.getUpdateCount() > 0) {
                        out.println("success");
                    }

                    if (rs != null) {try {rs.close();} catch (Exception e) {}}
                    if (prest != null) {try {prest.close();} catch (Exception e) {}}
                    if (conn != null) {try {conn.close();}
                    catch (Exception e) {}
                    }
                } catch (Exception e) {out.println("Exception : " + e);}
            } else if (type.equals("deleteData")) {
                try {
                    Connection conn = config2.getconnection();
                    if (conn == null) {
                        out.println("Error : Could not connect to database");
                        return;
                    }
                    String id = request.getParameter("d_id");
                    PreparedStatement prest = null;
                    ResultSet rs = null;
                    ResultSet rs1 = null;

                    String sql = "DELETE FROM upload_db WHERE id in ("+id+")";

                    System.out.println("Insert crm  : " + sql);

                    prest = conn.prepareStatement(sql);
                    prest.executeUpdate();
                    if (prest.getUpdateCount() > 0) {
                        out.println("success");
                    }

                    if (rs != null) {try {rs.close();} catch (Exception e) {}}
                    if (prest != null) {try {prest.close();} catch (Exception e) {}}
                    if (conn != null) {try {conn.close();}
                    catch (Exception e) {}
                    }
                } catch (Exception e) {out.println("Exception : " + e);}
            }
            else 
            {
                
            }

        } catch (Exception e) {
            out.println(e);

        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(Getstatus.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(Getstatus.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
