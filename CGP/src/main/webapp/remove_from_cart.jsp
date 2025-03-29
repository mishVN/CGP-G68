<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int itemCode = Integer.parseInt(request.getParameter("itemCode"));

    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

    if (cart != null) {
        cart.remove(itemCode);
        session.setAttribute("cart", cart);
    }

    response.sendRedirect("cart.jsp");
%>