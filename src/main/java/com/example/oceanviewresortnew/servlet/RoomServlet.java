package com.example.oceanviewresortnew.servlet;

import com.example.oceanviewresortnew.dao.RoomDAO;
import com.example.oceanviewresortnew.model.Room;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.*;
import java.util.List;
import java.util.UUID;

@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 10 * 1024 * 1024)
@WebServlet(name = "RoomServlet", value = "/rooms")
public class RoomServlet extends HttpServlet {
    private RoomDAO roomDAO;
    private Gson gson;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("list".equals(action)) {
            listRooms(request, response);
        } else if ("available".equals(action)) {
            listAvailableRooms(request, response);
        } else if ("view".equals(action)) {
            viewRoom(request, response);
        } else if ("byType".equals(action)) {
            getRoomsByType(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addRoom(request, response);
        } else if ("update".equals(action)) {
            updateRoom(request, response);
        } else if ("delete".equals(action)) {
            deleteRoom(request, response);
        } else if ("updateStatus".equals(action)) {
            updateRoomStatus(request, response);
        }
    }

    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Room> rooms = roomDAO.getAllRooms();
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(rooms));
        out.flush();
    }

    private void listAvailableRooms(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Room> rooms = roomDAO.getAvailableRooms();
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(rooms));
        out.flush();
    }

    private void viewRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int roomId = Integer.parseInt(request.getParameter("id"));
        Room room = roomDAO.getRoomById(roomId);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(room));
        out.flush();
    }

    private void getRoomsByType(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String roomType = request.getParameter("type");
        List<Room> rooms = roomDAO.getRoomsByType(roomType);
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(rooms));
        out.flush();
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Room room = new Room();
        room.setRoomNumber(request.getParameter("roomNumber"));
        room.setRoomType(request.getParameter("roomType"));
        room.setPricePerNight(new BigDecimal(request.getParameter("price")));
        room.setCapacity(Integer.parseInt(request.getParameter("capacity")));
        room.setDescription(request.getParameter("description"));
        room.setAmenities(request.getParameter("amenities"));
        room.setStatus("available");
        room.setImageUrl(resolveImageUrl(request));

        boolean success = roomDAO.addRoom(room);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?success=added");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?error=add_failed");
        }
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Room room = new Room();
        room.setId(Integer.parseInt(request.getParameter("id")));
        room.setRoomNumber(request.getParameter("roomNumber"));
        room.setRoomType(request.getParameter("roomType"));
        room.setPricePerNight(new BigDecimal(request.getParameter("price")));
        room.setCapacity(Integer.parseInt(request.getParameter("capacity")));
        room.setDescription(request.getParameter("description"));
        room.setAmenities(request.getParameter("amenities"));
        room.setStatus(request.getParameter("status"));

        String resolvedImage = resolveImageUrl(request);
        if (resolvedImage != null && !resolvedImage.isEmpty()) {
            room.setImageUrl(resolvedImage);
        } else {
            // keep existing image
            room.setImageUrl(request.getParameter("existingImageUrl"));
        }

        boolean success = roomDAO.updateRoom(room);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?error=update_failed");
        }
    }

    /**
     * Returns image URL: uploaded file path takes priority over typed URL.
     */
    private String resolveImageUrl(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("imageFile");
        if (filePart != null && filePart.getSize() > 0) {
            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String ext = originalName.contains(".") ? originalName.substring(originalName.lastIndexOf('.')) : ".jpg";
            String savedName = UUID.randomUUID().toString() + ext;

            String uploadDir = getServletContext().getRealPath("/images/rooms");
            File dir = new File(uploadDir);
            if (!dir.exists())
                dir.mkdirs();

            filePart.write(uploadDir + File.separator + savedName);
            return request.getContextPath() + "/images/rooms/" + savedName;
        }
        // Fall back to typed URL
        String url = request.getParameter("imageUrl");
        return (url != null) ? url.trim() : "";
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int roomId = Integer.parseInt(request.getParameter("id"));
        boolean success = roomDAO.deleteRoom(roomId);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + "}");
        out.flush();
    }

    private void updateRoomStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int roomId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        boolean success = roomDAO.updateRoomStatus(roomId, status);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{\"success\": " + success + "}");
        out.flush();
    }
}
