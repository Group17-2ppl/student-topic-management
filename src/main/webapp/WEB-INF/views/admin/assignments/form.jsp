<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="container py-4">

    <h2 class="mb-4">Phân công giảng viên</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            ${error}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/assignments/create"
          method="post">

        <div class="mb-3">

            <label class="form-label">
                Đề tài
            </label>

            <select name="topicId"
                    class="form-select"
                    required>

                <option value="">
                    -- Chọn đề tài --
                </option>

                <c:forEach var="topic" items="${topics}">

                    <option value="${topic.id}">
                        ${topic.title}
                    </option>

                </c:forEach>

            </select>

        </div>

        <div class="mb-3">

            <label class="form-label">
                Giảng viên
            </label>

            <select name="lecturerId"
                    class="form-select"
                    required>

                <option value="">
                    -- Chọn giảng viên --
                </option>

                <c:forEach var="lecturer" items="${lecturers}">

                    <option value="${lecturer.id}">
                        ${lecturer.user.fullName}
                    </option>

                </c:forEach>

            </select>

        </div>

        <div class="mb-3">

            <label class="form-label">
                Vai trò
            </label>

            <select name="role"
                    class="form-select"
                    required>

                <option value="">
                    -- Chọn vai trò --
                </option>

                <option value="GVHD">
                    GVHD - Giảng viên hướng dẫn
                </option>

                <option value="GVPB">
                    GVPB - Giảng viên phản biện
                </option>

            </select>

        </div>

        <button type="submit"
                class="btn btn-primary">
            Phân công
        </button>

        <a href="${pageContext.request.contextPath}/admin/assignments"
           class="btn btn-secondary">
            Quay lại
        </a>

    </form>

</div>

<%@ include file="../../common/footer.jsp" %>