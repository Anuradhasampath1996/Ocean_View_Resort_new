package com.example.oceanviewresortnew.servlet;

import com.example.oceanviewresortnew.dao.UserDAO;
import com.example.oceanviewresortnew.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "AuthServlet", value = "/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            request.setAttribute("error", "Self-registration is disabled. Please contact your administrator.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            handleLogout(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // Redirect based on role
            String role = user.getRole();
            if ("admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else if ("manager".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/manager/dashboard.jsp");
            } else if ("receptionist".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/receptionist/dashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/customer/bookings.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
