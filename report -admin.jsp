<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql., java.util., java.text.SimpleDateFormat, java.io.IOException, com.itextpdf.text., com.itextpdf.text.pdf., org.apache.poi.ss.usermodel., org.apache.poi.xssf.usermodel." %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier Service Report Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --danger: #f72585;
            --warning: #f8961e;
            --info: #4895ef;
            --light: #f8f9fa;
            --dark: #212529;
            --white: #ffffff;
            --gray: #6c757d;
            --border-radius: 0.375rem;
            --box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: var(--dark);
            line-height: 1.6;
        }
        
        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .dashboard {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
        }
        
        .dashboard-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: var(--white);
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .dashboard-title {
            font-size: 1.75rem;
            font-weight: 600;
        }
        
        .dashboard-actions {
            display: flex;
            gap: 1rem;
        }
        
        .card {
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            min-width: 200px;
        }
        
        label {
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--gray);
            font-size: 0.875rem;
        }
        
        input, select {
            padding: 0.75rem;
            border: 1px solid #ced4da;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }
        
        input:focus, select:focus {
            outline: 0;
            border-color: var(--primary);
            box-shadow: 0 0 0 0.2rem rgba(67, 97, 238, 0.25);
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
            text-align: center;
            white-space: nowrap;
            vertical-align: middle;
            user-select: none;
            border: 1px solid transparent;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            line-height: 1.5;
            border-radius: var(--border-radius);
            transition: all 0.15s ease-in-out;
            cursor: pointer;
            gap: 0.5rem;
        }
        
        .btn-primary {
            color: var(--white);
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .btn-primary:hover {
            background-color: var(--secondary);
            border-color: var(--secondary);
        }
        
        .btn-success {
            color: var(--white);
            background-color: var(--success);
            border-color: var(--success);
        }
        
        .btn-success:hover {
            background-color: #3aa8d8;
            border-color: #3aa8d8;
        }
        
        .btn-danger {
            color: var(--white);
            background-color: var(--danger);
            border-color: var(--danger);
        }
        
        .btn-danger:hover {
            background-color: #e5177a;
            border-color: #e5177a;
        }
        
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 1rem 0;
            font-size: 0.9rem;
        }
        
        thead {
            background-color: var(--primary);
            color: var(--white);
        }
        
        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        
        th {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
        }
        
        tbody tr {
            transition: background-color 0.15s ease;
        }
        
        tbody tr:hover {
            background-color: rgba(67, 97, 238, 0.05);
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            border-radius: 50rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-align: center;
            white-space: nowrap;
        }
        
        .status-delivered {
            background-color: rgba(40, 167, 69, 0.1);
            color: #28a745;
        }
        
        .status-pending {
            background-color: rgba(253, 126, 20, 0.1);
            color: #fd7e14;
        }
        
        .status-returned {
            background-color: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }
        
        .summary-card {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .summary-item {
            flex: 1;
            min-width: 200px;
            background: var(--white);
            border-radius: var(--border-radius);
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
        }
        
        .summary-title {
            font-size: 0.875rem;
            color: var(--gray);
            margin-bottom: 0.5rem;
        }
        
        .summary-value {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--dark);
        }
        
        .summary-change {
            display: flex;
            align-items: center;
            font-size: 0.75rem;
            margin-top: 0.5rem;
        }
        
        .change-up {
            color: #28a745;
        }
        
        .change-down {
            color: #dc3545;
        }
        
        .pagination {
            display: flex;
            justify-content: flex-end;
            margin-top: 1rem;
            gap: 0.5rem;
        }
        
        .page-item {
            display: inline-flex;
        }
        
        .page-link {
            padding: 0.5rem 0.75rem;
            border: 1px solid #dee2e6;
            color: var(--primary);
            background-color: var(--white);
            border-radius: var(--border-radius);
        }
        
        .page-link:hover {
            background-color: #e9ecef;
        }
        
        .page-link.active {
            color: var(--white);
            background-color: var(--primary);
            border-color: var(--primary);
        }
        
        .loading {
            display: none;
            text-align: center;
            padding: 1rem;
        }
        
        .loading-spinner {
            border: 4px solid rgba(0, 0, 0, 0.1);
            border-radius: 50%;
            border-top: 4px solid var(--primary);
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 1rem;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            background-color: var(--white);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            z-index: 1000;
            transform: translateX(200%);
            transition: transform 0.3s ease;
        }
        
        .notification.show {
            transform: translateX(0);
        }
        
        .notification-success {
            border-left: 4px solid #28a745;
        }
        
        .notification-error {
            border-left: 4px solid #dc3545;
        }
        
        @media (max-width: 768px) {
            .filter-section {
                flex-direction: column;
                align-items: stretch;
            }
            
            .form-group {
                min-width: 100%;
            }
            
            .dashboard-actions {
                flex-direction: column;
                width: 100%;
                margin-top: 1rem;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="dashboard">
        <div class="dashboard-header">
            <div class="dashboard-title">
                <i class="fas fa-truck mr-2"></i> Courier Service Report
             
            </div>
            <div class="dashboard-actions">
                <button class="btn btn-success" onclick="exportToExcel()">
                    <i class="fas fa-file-excel"></i> Export to Excel
                </button>
                <button class="btn btn-danger" onclick="exportToPDF()">
                    <i class="fas fa-file-pdf"></i> Export to PDF
                </button>
            </div>
        </div>
        
        <div class="card">
            <h3 class="card-title">Report Filters</h3>
            <div class="filter-section">
                <div class="form-group">
                    <label for="fromDate">From Date</label>
                    <input type="date" id="fromDate" class="form-control">
                </div>
                <div class="form-group">
                    <label for="toDate">To Date</label>
                    <input type="date" id="toDate" class="form-control">
                </div>
                <div class="form-group">
                    <label for="status">Status</label>
                    <select id="status" class="form-control">
                        <option value="">All Statuses</option>
                        <option value="Delivered">Delivered</option>
                        <option value="Pending">Pending</option>
                        <option value="Returned">Returned</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="courierType">Courier Type</label>
                    <select id="courierType" class="form-control">
                        <option value="">All Types</option>
                        <option value="Express">Express</option>
                        <option value="Standard">Standard</option>
                        <option value="Overnight">Overnight</option>
                    </select>
                </div>
                <div class="form-group" style="align-self: flex-end;">
                    <button class="btn btn-primary" onclick="filterReport()">
                        <i class="fas fa-filter"></i> Apply Filters
                    </button>
                </div>
            </div>
        </div>
        
        <div class="card">
            <h3 class="card-title">Summary Overview</h3>
            <div class="summary-card" id="summaryStats">
                <!-- Summary stats will be loaded here -->
            </div>
        </div>
        
        <div class="card">
            <div class="loading" id="loadingIndicator">
                <div class="loading-spinner"></div>
                <p>Loading data...</p>
            </div>
            <div class="table-container">
                <table id="reportTable">
                    <thead>
                        <tr>
                            <th>Tracking #</th>
                            <th>Customer</th>
                            <th>Courier Type</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Amount</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="reportData">
                        <!-- Data will be loaded here -->
                    </tbody>
                </table>
            </div>
            
            <div class="pagination" id="paginationControls">
                <!-- Pagination will be loaded here -->
            </div>
        </div>
    </div>
</div>

<div id="notification" class="notification">
    <i class="fas fa-check-circle"></i>
    <span id="notificationMessage">Operation completed successfully</span>
</div>

<script>
    // Global variables
    let currentPage = 1;
    const itemsPerPage = 10;
    let totalItems = 0;
    let currentFilters = {};
    
    // Initialize the page when DOM is loaded
    document.addEventListener('DOMContentLoaded', function() {
        // Set default dates (last 30 days)
        const today = new Date();
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(today.getDate() - 30);
        
        document.getElementById('fromDate').valueAsDate = thirtyDaysAgo;
        document.getElementById('toDate').valueAsDate = today;
        
        // Load initial data
        loadReportData();
        loadSummaryStats();
    });
    
    // Function to show notification
    function showNotification(message, isSuccess = true) {
        const notification = document.getElementById('notification');
        const notificationMessage = document.getElementById('notificationMessage');
        
        notification.className = isSuccess ? 'notification notification-success' : 'notification notification-error';
        notificationMessage.textContent = message;
        
        notification.classList.add('show');
        
        setTimeout(() => {
            notification.classList.remove('show');
        }, 3000);
    }
    
    // Function to show loading indicator
    function showLoading(show) {
        document.getElementById('loadingIndicator').style.display = show ? 'block' : 'none';
    }
    
    // Function to load report data with AJAX
    function loadReportData(page = 1) {
        showLoading(true);
        currentPage = page;
        
        const fromDate = document.getElementById('fromDate').value;
        const toDate = document.getElementById('toDate').value;
        const status = document.getElementById('status').value;
        const courierType = document.getElementById('courierType').value;
        
        currentFilters = { fromDate, toDate, status, courierType };
        
        // In a real application, this would be an AJAX call to the server
        // For this example, we'll simulate it with a timeout
        setTimeout(() => {
            // Simulate AJAX response
            const xhr = new XMLHttpRequest();
            xhr.open('GET', getReportData.jsp?fromDate=${fromDate}&toDate=${toDate}&status=${status}&courierType=${courierType}&page=${page}&itemsPerPage=${itemsPerPage}, true);
            
            xhr.onload = function() {
                showLoading(false);
                if (xhr.status === 200) {
                    try {
                        const response = JSON.parse(xhr.responseText);
                        renderReportData(response.data);
                        totalItems = response.totalCount;
                        renderPagination();
                    } catch (e) {
                        console.error('Error parsing response:', e);
                        showNotification('Error loading data', false);
                    }
                } else {
                    showNotification('Error loading data: ' + xhr.statusText, false);
                }
            };
            
            xhr.onerror = function() {
                showLoading(false);
                showNotification('Network error occurred', false);
            };
            
            xhr.send();
        }, 500);
    }
    
    // Function to render report data in the table
    function renderReportData(data) {
        const tbody = document.getElementById('reportData');
        tbody.innerHTML = '';
        
        if (data.length === 0) {
            tbody.innerHTML = '<tr><td colspan="7" class="text-center">No records found</td></tr>';
            return;
        }
        
        data.forEach(item => {
            const row = document.createElement('tr');
            
            // Determine status class
            let statusClass = '';
            switch(item.status) {
                case 'Delivered': statusClass = 'status-delivered'; break;
                case 'Pending': statusClass = 'status-pending'; break;
                case 'Returned': statusClass = 'status-returned'; break;
            }
            
            row.innerHTML = `
                <td>${item.tracking_number}</td>
                <td>${item.customer_name}</td>
                <td>${item.courier_type}</td>
                <td>${formatDate(item.date)}</td>
                <td><span class="status-badge ${statusClass}">${item.status}</span></td>
                <td>$${item.amount.toFixed(2)}</td>
                <td>
                    <button class="btn btn-sm" onclick="viewDetails('${item.tracking_number}')">
                        <i class="fas fa-eye"></i> View
                    </button>
                </td>
            `;
            
            tbody.appendChild(row);
        });
    }
    
    // Function to load summary statistics
    function loadSummaryStats() {
        const fromDate = document.getElementById('fromDate').value;
        const toDate = document.getElementById('toDate').value;
        const status = document.getElementById('status').value;
        const courierType = document.getElementById('courierType').value;
        
        // In a real application, this would be an AJAX call
        // For this example, we'll simulate it with mock data
        setTimeout(() => {
            document.getElementById('summaryStats').innerHTML = `
                <div class="summary-item">
                    <span class="summary-title">Total Shipments</span>
                    <span class="summary-value">1,248</span>
                    <span class="summary-change change-up">
                        <i class="fas fa-arrow-up"></i> 12.5% from last month
                    </span>
                </div>
                <div class="summary-item">
                    <span class="summary-title">Delivered</span>
                    <span class="summary-value">1,042</span>
                    <span class="summary-change change-up">
                        <i class="fas fa-arrow-up"></i> 8.3% from last month
                    </span>
                </div>
                <div class="summary-item">
                    <span class="summary-title">Pending</span>
                    <span class="summary-value">156</span>
                    <span class="summary-change change-down">
                        <i class="fas fa-arrow-down"></i> 3.2% from last month
                    </span>
                </div>
                <div class="summary-item">
                    <span class="summary-title">Revenue</span>
                    <span class="summary-value">$24,850</span>
                    <span class="summary-change change-up">
                        <i class="fas fa-arrow-up"></i> 15.7% from last month
                    </span>
                </div>
            `;
        }, 300);
    }
    
    // Function to render pagination controls
    function renderPagination() {
        const pagination = document.getElementById('paginationControls');
        const totalPages = Math.ceil(totalItems / itemsPerPage);
        
        if (totalPages <= 1) {
            pagination.innerHTML = '';
            return;
        }
        
        let html = '';
        
        // Previous button
        html += `
            <div class="page-item">
                <a href="#" class="page-link ${currentPage === 1 ? 'disabled' : ''}" 
                   onclick="${currentPage === 1 ? 'return false;' : changePage(${currentPage - 1})}">
                    <i class="fas fa-angle-left"></i>
                </a>
            </div>
        `;
        
        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            html += `
                <div class="page-item">
                    <a href="#" class="page-link ${currentPage === i ? 'active' : ''}" 
                       onclick="changePage(${i})">${i}</a>
                </div>
            `;
        }
        
        // Next button
        html += `
            <div class="page-item">
                <a href="#" class="page-link ${currentPage === totalPages ? 'disabled' : ''}" 
                   onclick="${currentPage === totalPages ? 'return false;' : changePage(${currentPage + 1})}">
                    <i class="fas fa-angle-right"></i>
                </a>
            </div>
        `;
        
        pagination.innerHTML = html;
    }
    
    // Function to change page
    function changePage(page) {
        if (page === currentPage) return;
        loadReportData(page);
    }
    
    // Function to filter report
    function filterReport() {
        loadReportData(1); // Always reset to page 1 when filtering
        loadSummaryStats();
    }
    
    // Function to view details
    function viewDetails(trackingNumber) {
        // In a real application, this would open a modal or navigate to a details page
        showNotification(Viewing details for tracking #${trackingNumber});
        console.log(View details for tracking #${trackingNumber});
    }
    
    // Function to export to PDF
    function exportToPDF() {
        showLoading(true);
        
        const fromDate = document.getElementById('fromDate').value;
        const toDate = document.getElementById('toDate').value;
        const status = document.getElementById('status').value;
        const courierType = document.getElementById('courierType').value;
        
        // In a real application, this would make a request to a server-side PDF generator
        setTimeout(() => {
            showLoading(false);
            showNotification('PDF export started. Check your downloads.');
            
            // Simulate PDF download
            console.log(Exporting to PDF with filters:, { fromDate, toDate, status, courierType });
            
            // In a real implementation, you would:
            // window.location.href = generatePdf.jsp?fromDate=${fromDate}&toDate=${toDate}&status=${status}&courierType=${courierType};
        }, 1000);
    }
    
    // Function to export to Excel
    function exportToExcel() {
        showLoading(true);
        
        const fromDate = document.getElementById('fromDate').value;
        const toDate = document.getElementById('toDate').value;
        const status = document.getElementById('status').value;
        const courierType = document.getElementById('courierType').value;
        
        // In a real application, this would make a request to a server-side Excel generator
        setTimeout(() => {
            showLoading(false);
            showNotification('Excel export started. Check your downloads.');
            
            // Simulate Excel download
            console.log(Exporting to Excel with filters:, { fromDate, toDate, status, courierType });
            
            // In a real implementation, you would:
            // window.location.href = generateExcel.jsp?fromDate=${fromDate}&toDate=${toDate}&status=${status}&courierType=${courierType};
        }, 1000);
    }
    
    // Utility function to format date
    function formatDate(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
    }
</script>
</body>
</html>
