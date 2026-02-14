package com.example.oceanviewresortnew.servlet;

import com.example.oceanviewresortnew.dao.RoomDAO;
import com.example.oceanviewresortnew.model.Room;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

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
        room.setImageUrl(request.getParameter("imageUrl"));
        room.setStatus("available");

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
        room.setImageUrl(request.getParameter("imageUrl"));
        room.setStatus(request.getParameter("status"));

        boolean success = roomDAO.updateRoom(room);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?success=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?error=update_failed");
        }
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
