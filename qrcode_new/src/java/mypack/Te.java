package mypack;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFilePermissions;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class Te extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "image_upload";
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3;  // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40; // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
    {
        PrintWriter out = response.getWriter();
        if (!ServletFileUpload.isMultipartContent(request)) {
            PrintWriter writer = response.getWriter();
            writer.println("Error: Form must has enctype=multipart/form-data.");
            writer.flush();
            return;
        }

        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE);
//      ------------------------              new Code to create Folder by date name            ---------------------------------------------------

        Calendar calender = Calendar.getInstance();
        Date d = new Date();
        int year = calender.get(calender.YEAR);
        String Folder1 = "complaints";
        String Folder2 = String.valueOf(year);

        int month = calender.get(calender.MONTH);
        month = month + 1;
        String Folder3 = String.valueOf(month);

//      ------------------------              End of New Code            ---------------------------------------------------        
//        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
        String applicationPath = getServletContext().getRealPath("");

        // ------------------------------------------------       for windows   -------------------------------------------------------------------------------------------
//        applicationPath = "E:\\";
//        String uploadFilePath1 = applicationPath +  Folder1;
//        String uploadFilePath2 = applicationPath + Folder1 + "\\" + Folder2;
//        String uploadFilePath3 = applicationPath + Folder1 + "\\" + Folder2 + "\\" + Folder3;
//
//        File uploadDir1 = new File(uploadFilePath1);
//        File uploadDir2 = new File(uploadFilePath2);
//        File uploadDir3 = new File(uploadFilePath3);
// ------------------------------------------------       for linux   -------------------------------------------------------------------------------------------
        applicationPath = "/home/project";
        String uploadFilePath1 = applicationPath + "/" + Folder1;
        String uploadFilePath2 = applicationPath + "/" + Folder1 + "/" + Folder2;
        String uploadFilePath3 = applicationPath + "/" + Folder1 + "/" + Folder2 + "/" + Folder3;
        File uploadDir1 = new File(uploadFilePath1);
        File uploadDir2 = new File(uploadFilePath2);
        File uploadDir3 = new File(uploadFilePath3);



        System.out.println("upsrtc:  upload file name= " + uploadFilePath3 + " new directory name =" + uploadDir3);

        try {
            if (!uploadDir1.exists()) {
                uploadDir1.mkdir();
                uploadDir2.mkdir();
                uploadDir3.mkdir();
            } else if (!uploadDir2.exists()) {
                uploadDir2.mkdir();
                uploadDir3.mkdir();
            } else if (!uploadDir3.exists()) {
                uploadDir3.mkdir();
            }

        } catch (Exception e) {
            System.out.println("upsrtc: exception in folder creating");
            e.printStackTrace();
        }

        try {
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = (List<FileItem>) upload.parseRequest(request);
            String product_name="",product_code="",fileName1 = "";
            if (formItems != null && formItems.size() > 0) 
            {
                for (FileItem item : formItems) {
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();

                        fileName1 += fileName;
                        String extension = fileName.substring(fileName.lastIndexOf("."));                 //fileName.lastIndexOf(".");
                        String filePath = uploadFilePath3 + File.separator + (fileName.replaceAll("[^a-zA-Z0-9]", "")).concat(extension);
                        System.out.println("filepath===>" + filePath);

                        String path = uploadFilePath3;
                        String f_name = fileName;

                        File storeFile = new File(filePath);
                        System.out.println("upsrtc: file path =" + filePath);

//                        out.println(path+"$"+f_name);
                        out.println(filePath);
                        item.write(storeFile);

                        boolean exists = storeFile.exists();
                        if (exists == true) {
                            storeFile.setExecutable(true);
                            storeFile.setReadable(true);
                            storeFile.setWritable(false);
                        }

                    }
//                    else {
//                        String fieldname = item.getFieldName();
//                        String fieldvalue = item.getString();
//                        if (fieldname.equals("product_name")) {
//                            product_name=fieldname;
//                        } else if (fieldname.equals("product_code")) 
//                        {
//                            product_code=fieldname;
//                        }
//                        out.println(fieldname);
//                        out.println(fieldvalue);
//                    }
                }
            }
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }
        //sql query
        
        
        
        
        
        
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
        processRequest(request, response);
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
        processRequest(request, response);
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
