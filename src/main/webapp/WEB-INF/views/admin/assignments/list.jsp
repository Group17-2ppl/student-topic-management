<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-12">

        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm"
                 role="alert"
                 style="border-radius: 12px;">
                <strong>Thành công!</strong>
                ${success}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Close">
                </button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm"
                 role="alert"
                 style="border-radius: 12px;">
                <strong>Lỗi!</strong>
                ${error}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Close">
                </button>
            </div>
        </c:if>

        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">

            <h2 class="h3 fw-bold text-dark mb-0">
                Phân công giảng viên
            </h2>

            <a href="${pageContext.request.contextPath}/admin/assignments/create"
               class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
               style="border-radius: 10px; min-height: 42px; display: inline-flex; align-items: center;">
                + Phân công mới
            </a>

        </div>

        <div class="card border-0 shadow-sm"
             style="border-radius: 16px; overflow: hidden;">

            <div class="card-body p-0">

                <div class="table-responsive m-0">

                    <table class="table table-hover align-middle mb-0">

                        <thead class="bg-light text-uppercase fs-7 text-secondary tracking-wider">

                            <tr>

                                <th class="py-3 px-4 border-bottom-0"
                                    style="width: 80px;">
                                    ID
                                </th>

                                <th class="py-3 px-4 border-bottom-0">
                                    Đề tài
                                </th>

                                <th class="py-3 px-4 border-bottom-0">
                                    Giảng viên
                                </th>

                                <th class="py-3 px-4 border-bottom-0 text-center"
                                    style="width: 180px;">
                                    Vai trò
                                </th>

                                <th class="py-3 px-4 border-bottom-0 text-center"
                                    style="width: 140px;">
                                    Thao tác
                                </th>

                            </tr>

                        </thead>

                        <tbody>

                            <c:forEach var="assignment" items="${assignments}">

                                <tr>

                                    <td class="py-3 px-4 fw-semibold text-secondary">
                                        #${assignment.id}
                                    </td>

                                    <td class="py-3 px-4 fw-medium text-dark">
                                        ${assignment.topic.title}
                                    </td>

                                    <td class="py-3 px-4 text-muted">
                                        ${assignment.lecturer.user.fullName}
                                    </td>

                                    <td class="py-3 px-4 text-center">

                                        <c:choose>

                                            <c:when test="${assignment.role == 'GVHD'}">

                                                <span class="badge bg-primary">
                                                    GVHD
                                                </span>

                                            </c:when>

                                            <c:when test="${assignment.role == 'GVPB'}">

                                                <span class="badge bg-secondary">
                                                    GVPB
                                                </span>

                                            </c:when>

                                            <c:otherwise>

                                                <span class="badge bg-light text-dark">
                                                    ${assignment.role}
                                                </span>

                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                    <td class="py-3 px-4 text-center">

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/admin/assignments/delete/${assignment.id}"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa phân công này?');">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-danger px-3 fw-semibold"
                                                    style="border-radius: 8px; display: inline-flex; align-items: center;">
                                                Xóa
                                            </button>

                                        </form>

                                    </td>

                                </tr>

                            </c:forEach>

                            <c:if test="${empty assignments}">

                                <tr>

                                    <td colspan="5"
                                        class="text-center py-5 text-muted">

                                        Chưa có phân công giảng viên nào.

                                    </td>

                                </tr>

                            </c:if>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

    </div>
</div>

<%@ include file="../../common/footer.jsp" %>