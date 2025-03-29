<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    int itemCode = Integer.parseInt(request.getParameter("itemCode"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");

    if (cart == null) {
        cart = new HashMap<>();
    }

    cart.put(itemCode, cart.getOrDefault(itemCode, 0) + quantity);
    session.setAttribute("cart", cart);
%>