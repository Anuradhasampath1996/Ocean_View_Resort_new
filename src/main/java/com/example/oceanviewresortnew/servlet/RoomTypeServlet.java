package com.example.oceanviewresortnew.servlet;

import com.example.oceanviewresortnew.dao.RoomTypeDAO;
import com.example.oceanviewresortnew.model.RoomType;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "RoomTypeServlet", value = "/room-types")
public class RoomTypeServlet extends HttpServlet {
    private RoomTypeDAO roomTypeDAO;
    private Gson gson;

    @Override
    public void init() {
        roomTypeDAO = new RoomTypeDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Return all room types as JSON (used by dropdowns)
        List<RoomType> types = roomTypeDAO.getAllRoomTypes();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(types));
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            RoomType rt = new RoomType();
            rt.setName(request.getParameter("name").trim().toLowerCase().replace(" ", "_"));
            rt.setDisplayName(request.getParameter("displayName").trim());
            boolean added = roomTypeDAO.addRoomType(rt);
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?tab=types&"
                    + (added ? "success=type_added" : "error=add_failed"));

        } else if ("update".equals(action)) {
            RoomType rt = new RoomType();
            rt.setId(Integer.parseInt(request.getParameter("id")));
            rt.setName(request.getParameter("name").trim().toLowerCase().replace(" ", "_"));
            rt.setDisplayName(request.getParameter("displayName").trim());
            boolean updated = roomTypeDAO.updateRoomType(rt);
            response.sendRedirect(request.getContextPath() + "/admin/rooms.jsp?tab=types&"
                    + (updated ? "success=type_updated" : "error=update_failed"));

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean ok = roomTypeDAO.deleteRoomType(id);
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":" + ok + "}");
            out.flush();
        }
    }
}
