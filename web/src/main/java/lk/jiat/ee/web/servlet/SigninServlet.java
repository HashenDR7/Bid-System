package lk.jiat.ee.web.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lk.jiat.ee.core.model.User;
import lk.jiat.ee.core.model.UserRepository;

import java.io.IOException;

@WebServlet("/signin")
public class SigninServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = UserRepository.findByEmail(email);
        if (user != null && user.getPassword().equals(password)) {
            request.getSession().setAttribute("user", user); // Save to session
            response.sendRedirect("product.jsp"); // Redirect to bidding/product page
        } else {
            response.sendRedirect("login.jsp?error=invalid");
        }
    }
}

