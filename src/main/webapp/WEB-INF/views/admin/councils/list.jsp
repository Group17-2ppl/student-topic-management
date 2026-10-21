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
                Quản lý hội đồng
            </h2>

            <a href="${pageContext.request.contextPath}/admin/councils/create"
               class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
               style="border-radius: 10px; min-height: 42px; display: inline-flex; align-items: center;">
                + Tạo hội đồng
            </a>

        </div>

        <div class="card border-0 shadow-sm"
             style="border-radius: 16px; overflow: hidden;">

            <div class="card-body p-0">

                <div class="table-responsive m-0">

                    <table class="table table-hover align-middle mb-0">

                        <thead class="bg-light text-uppercase fs-7 text-secondary">

                            <tr>

                                <th class="py-3 px-4 border-bottom-0"
                                    style="width: 80px;">
                                    ID
                                </th>

                                <th class="py-3 px-4 border-bottom-0">
                                    Tên hội đồng
                                </th>

                                <th class="py-3 px-4 border-bottom-0">
                                    Đợt đăng ký
                                </th>

                                <th class="py-3 px-4 border-bottom-0 text-center"
                                    style="width: 160px;">
                                    Trạng thái
                                </th>

                                <th class="py-3 px-4 border-bottom-0 text-center"
                                    style="width: 260px;">
                                    Thao tác
                                </th>

                            </tr>

                        </thead>

                        <tbody>

                            <c:forEach var="council" items="${councils}">

                                <tr>

                                    <td class="py-3 px-4 fw-semibold text-secondary">
                                        #${council.id}
                                    </td>

                                    <td class="py-3 px-4 fw-semibold text-dark">
                                        ${council.name}
                                    </td>

                                    <td class="py-3 px-4 text-muted">
                                        ${council.registrationRound.name}
                                    </td>

                                    <td class="py-3 px-4 text-center">

                                        <c:choose>

                                            <c:when test="${council.status == 'DRAFT'}">
                                                <span class="badge bg-secondary">
                                                    DRAFT
                                                </span>
                                            </c:when>

                                            <c:when test="${council.status == 'ACTIVE'}">
                                                <span class="badge bg-success">
                                                    ACTIVE
                                                </span>
                                            </c:when>

                                            <c:when test="${council.status == 'COMPLETED'}">
                                                <span class="badge bg-primary">
                                                    COMPLETED
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge bg-light text-dark">
                                                    ${council.status}
                                                </span>
                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                    <td class="py-3 px-4 text-center">

                                        <div class="d-flex justify-content-center align-items-center gap-2">

                                            <a href="${pageContext.request.contextPath}/admin/councils/${council.id}"
                                               class="btn btn-sm btn-outline-primary px-3 fw-semibold"
                                               style="border-radius: 8px;">
                                                Chi tiết
                                            </a>

                                            <c:if test="${council.status == 'DRAFT'}">

                                                <a href="${pageContext.request.contextPath}/admin/councils/edit/${council.id}"
                                                   class="btn btn-sm btn-outline-secondary px-3 fw-semibold"
                                                   style="border-radius: 8px;">
                                                    Sửa
                                                </a>

                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/councils/delete/${council.id}"
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa hội đồng này?');"
                                                      class="m-0">

                                                    <button type="submit"
                                                            class="btn btn-sm btn-outline-danger px-3 fw-semibold"
                                                            style="border-radius: 8px;">
                                                        Xóa
                                                    </button>

                                                </form>

                                            </c:if>

                                        </div>

                                    </td>

                                </tr>

                            </c:forEach>

                            <c:if test="${empty councils}">

                                <tr>

                                    <td colspan="5"
                                        class="text-center py-5 text-muted">
                                        Chưa có hội đồng nào.
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
