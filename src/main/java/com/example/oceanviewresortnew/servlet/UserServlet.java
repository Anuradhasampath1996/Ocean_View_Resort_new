package com.example.oceanviewresortnew.servlet;

import com.example.oceanviewresortnew.dao.UserDAO;
import com.example.oceanviewresortnew.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "UserServlet", value = "/users")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        if (!"admin".equals(role) && !"manager".equals(role) && !"receptionist".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        String action = request.getParameter("action");
        if ("searchCustomers".equals(action)) {
            String q = request.getParameter("q");
            List<User> customers = userDAO.searchCustomers(q);
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            StringBuilder sb = new StringBuilder("[");
            for (int i = 0; i < customers.size(); i++) {
                User u = customers.get(i);
                if (i > 0)
                    sb.append(",");
                sb.append("{");
                sb.append("\"id\":").append(u.getId()).append(",");
                sb.append("\"fullName\":").append(jsonQuote(u.getFullName())).append(",");
                sb.append("\"email\":").append(jsonQuote(u.getEmail())).append(",");
                sb.append("\"phone\":").append(jsonQuote(u.getPhone()));
                sb.append("}");
            }
            sb.append("]");
            out.print(sb.toString());
            out.flush();
        }
    }

    private String jsonQuote(String s) {
        if (s == null)
            return "null";
        return "\"" + s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "") + "\"";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Only admins may call this servlet
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            User u = new User();
            String role = request.getParameter("role");
            String source = request.getParameter("source");
            String redirectBase = "customer".equals(source) ? "/admin/customers.jsp" : "/admin/staff.jsp";
            // Only allow valid roles to be created via this endpoint
            if (!"manager".equals(role) && !"receptionist".equals(role) && !"admin".equals(role)
                    && !"customer".equals(role)) {
                response.sendRedirect(request.getContextPath() + redirectBase + "?error=invalid_role");
                return;
            }
            u.setEmail(request.getParameter("email") != null ? request.getParameter("email").trim() : null);
            u.setFullName(request.getParameter("fullName") != null ? request.getParameter("fullName").trim() : null);
            u.setPhone(request.getParameter("phone") != null ? request.getParameter("phone").trim() : null);
            u.setRole(role);
            if ("customer".equals(role)) {
                u.setUsername("cust_" + System.currentTimeMillis());
                u.setPassword("NoLogin_" + System.currentTimeMillis());
            } else {
                u.setUsername(
                        request.getParameter("username") != null ? request.getParameter("username").trim() : null);
                u.setPassword(request.getParameter("password"));
            }
            boolean ok = userDAO.register(u);
            response.sendRedirect(
                    request.getContextPath() + redirectBase + "?" + (ok ? "success=added" : "error=add_failed"));

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String source = request.getParameter("source");
            String redirectBase = "customer".equals(source) ? "/admin/customers.jsp" : "/admin/staff.jsp";
            User u = userDAO.getUserById(id);
            if (u == null) {
                response.sendRedirect(request.getContextPath() + redirectBase + "?error=not_found");
                return;
            }
            String role = request.getParameter("role");
            if (!"admin".equals(role) && !"manager".equals(role) && !"receptionist".equals(role)
                    && !"customer".equals(role)) {
                response.sendRedirect(request.getContextPath() + redirectBase + "?error=invalid_role");
                return;
            }
            u.setEmail(request.getParameter("email") != null ? request.getParameter("email").trim() : null);
            u.setFullName(request.getParameter("fullName") != null ? request.getParameter("fullName").trim() : null);
            u.setPhone(request.getParameter("phone") != null ? request.getParameter("phone").trim() : null);
            u.setRole(role);
            boolean ok;
            if ("customer".equals(role)) {
                ok = userDAO.updateUser(u);
            } else {
                String usernameParam = request.getParameter("username");
                if (usernameParam != null && !usernameParam.trim().isEmpty()) {
                    u.setUsername(usernameParam.trim());
                }
                String newPassword = request.getParameter("password");
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    u.setPassword(newPassword.trim());
                    ok = userDAO.updateUserWithPassword(u);
                } else {
                    ok = userDAO.updateUser(u);
                }
            }
            response.sendRedirect(
                    request.getContextPath() + redirectBase + "?" + (ok ? "success=updated" : "error=update_failed"));

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            // Prevent deleting own account
            Object sessionUserId = session.getAttribute("userId");
            if (sessionUserId != null && Integer.parseInt(sessionUserId.toString()) == id) {
                response.setContentType("application/json");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false,\"message\":\"Cannot delete your own account\"}");
                out.flush();
                return;
            }
            boolean ok = userDAO.deleteUser(id);
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print("{\"success\":" + ok + "}");
            out.flush();
        }
    }
}
