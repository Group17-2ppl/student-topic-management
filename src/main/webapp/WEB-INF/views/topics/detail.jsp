<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>

<div class="container mt-4">

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

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Chi tiết đề tài</h2>

    <a href="${pageContext.request.contextPath}/topics"
       class="btn btn-secondary">
        ← Quay lại
    </a>
</div>

<div class="card shadow-sm">
    <div class="card-body">

        <h3 class="card-title mb-3">
            ${topic.title}
        </h3>

        <hr>

        <div class="row mb-3">
            <div class="col-md-4">
                <strong>Mã đề tài:</strong>
            </div>

            <div class="col-md-8">
                ${topic.id}
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <strong>Mô tả:</strong>
            </div>

            <div class="col-md-8">
                <c:choose>
                    <c:when test="${not empty topic.description}">
                        ${topic.description}
                    </c:when>

                    <c:otherwise>
                        <span class="text-muted">
                            Chưa có mô tả
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <strong>Số sinh viên tối đa:</strong>
            </div>

            <div class="col-md-8">
                ${topic.maxStudents} SV
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <strong>Khoa / Bộ môn:</strong>
            </div>

            <div class="col-md-8">
                <c:choose>
                    <c:when test="${not empty topic.department}">
                        ${topic.department.name}
                    </c:when>

                    <c:otherwise>
                        <span class="text-muted">
                            Chưa xác định
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <strong>Trạng thái:</strong>
            </div>

            <div class="col-md-8">

                <c:choose>

                    <c:when test="${topic.status == 'PENDING'}">
                        <span class="badge bg-warning text-dark">
                            Chờ duyệt
                        </span>
                    </c:when>

                    <c:when test="${topic.status == 'APPROVED'}">
                        <span class="badge bg-primary">
                            Đã duyệt
                        </span>
                    </c:when>

                    <c:when test="${topic.status == 'OPEN'}">
                        <span class="badge bg-success">
                            Đang mở
                        </span>
                    </c:when>

                    <c:when test="${topic.status == 'REJECTED'}">
                        <span class="badge bg-danger">
                            Bị từ chối
                        </span>
                    </c:when>

                    <c:otherwise>
                        <span class="badge bg-secondary">
                            ${topic.status}
                        </span>
                    </c:otherwise>

                </c:choose>

            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <strong>Giảng viên đề xuất:</strong>
            </div>

            <div class="col-md-8">
                <c:choose>
                    <c:when test="${not empty topic.createdBy}">
                        ${topic.createdBy.user.fullName}
                    </c:when>

                    <c:otherwise>
                        <span class="text-muted">
                            Chưa xác định
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <strong>Đợt đăng ký:</strong>
            </div>

            <div class="col-md-8">
                <c:choose>
                    <c:when test="${not empty topic.registrationRound}">
                        ${topic.registrationRound.name}
                    </c:when>

                    <c:otherwise>
                        <span class="text-muted">
                            Chưa xác định
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <hr>

        <c:if test="${topic.status == 'OPEN'}">

            <div class="mt-3">

                <form action="${pageContext.request.contextPath}/registrations/register"
                      method="post">

                    <input type="hidden"
                           name="topicId"
                           value="${topic.id}">

                    <button type="submit"
                            class="btn btn-primary">
                        Đăng ký đề tài
                    </button>

                </form>

            </div>

        </c:if>

    </div>
</div>

</div>

<%@ include file="../common/footer.jsp" %>