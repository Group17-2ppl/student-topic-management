<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="container mt-4">

<h2 class="mb-4">Đề tài chờ duyệt</h2>

<c:if test="${not empty success}">
    <div class="alert alert-success">
        ${success}
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger">
        ${error}
    </div>
</c:if>

<c:choose>

    <c:when test="${empty topics}">
        <div class="alert alert-info">
            Hiện không có đề tài nào đang chờ duyệt.
        </div>
    </c:when>

    <c:otherwise>

        <div class="table-responsive">
            <table class="table table-bordered table-hover">

                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Tên đề tài</th>
                    <th>Giảng viên</th>
                    <th>Số SV tối đa</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="topic" items="${topics}">
                    <tr>

                        <td>${topic.id}</td>

                        <td>
                            ${topic.title}
                        </td>

                        <td>
                            ${topic.createdBy.user.fullName}
                        </td>

                        <td>
                            ${topic.maxStudents}
                        </td>

                        <td>
                            <span class="badge bg-warning text-dark">
                                Chờ duyệt
                            </span>
                        </td>

                        <td>

                            <form method="post"
                                  action="${pageContext.request.contextPath}/admin/topics/approve/${topic.id}"
                                  style="display:inline">

                                <button type="submit"
                                        class="btn btn-success btn-sm">
                                    Duyệt
                                </button>

                            </form>

                            <form method="post"
                                  action="${pageContext.request.contextPath}/admin/topics/reject/${topic.id}"
                                  style="display:inline">

                                <button type="submit"
                                        class="btn btn-danger btn-sm">
                                    Từ chối
                                </button>

                            </form>

                        </td>

                    </tr>
                </c:forEach>

                </tbody>

            </table>
        </div>

    </c:otherwise>

</c:choose>

</div>

<%@ include file="../../common/footer.jsp" %>
