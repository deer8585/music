<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    String keyword = (String) request.getAttribute("keyword");
    
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (totalCount == null) totalCount = 0;
    
    // 获取当前URL的查询参数（除了page参数）
    String queryString = request.getQueryString();
    String baseParams = "";
    if (queryString != null) {
        String[] params = queryString.split("&");
        StringBuilder sb = new StringBuilder();
        for (String param : params) {
            if (!param.startsWith("page=")) {
                if (sb.length() > 0) sb.append("&");
                sb.append(param);
            }
        }
        if (sb.length() > 0) {
            baseParams = "&" + sb.toString();
        }
    }
    
    // 只有超过10条数据才显示分页
    if (totalCount > 10) {
%>
<div class="pagination">
    <div class="pagination-info">
        共 <%= totalCount %> 条记录，第 <%= currentPage %> / <%= totalPages %> 页
    </div>
    <div class="pagination-buttons">
        <% if (currentPage > 1) { %>
            <a href="?page=1<%= baseParams %>" class="page-btn">首页</a>
            <a href="?page=<%= currentPage - 1 %><%= baseParams %>" class="page-btn">上一页</a>
        <% } %>
        
        <% 
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            
            for (int i = startPage; i <= endPage; i++) {
                if (i == currentPage) {
        %>
            <span class="page-btn active"><%= i %></span>
        <% 
                } else {
        %>
            <a href="?page=<%= i %><%= baseParams %>" class="page-btn"><%= i %></a>
        <% 
                }
            }
        %>
        
        <% if (currentPage < totalPages) { %>
            <a href="?page=<%= currentPage + 1 %><%= baseParams %>" class="page-btn">下一页</a>
            <a href="?page=<%= totalPages %><%= baseParams %>" class="page-btn">末页</a>
        <% } %>
    </div>
</div>

<style>
.pagination {
    margin: 30px 0 120px 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
}

.pagination-info {
    color: #666;
    font-size: 14px;
}

.pagination-buttons {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.page-btn {
    padding: 8px 15px;
    border: 1px solid #ddd;
    background: white;
    color: #333;
    text-decoration: none;
    border-radius: 4px;
    transition: all 0.3s;
    font-size: 14px;
}

.page-btn:hover {
    background: #f0f0f0;
    border-color: #999;
}

.page-btn.active {
    background: #007bff;
    color: white;
    border-color: #007bff;
    cursor: default;
}
</style>
<% } %>
