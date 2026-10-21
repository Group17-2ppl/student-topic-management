<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>

<div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">

<h2 class="h3 fw-bold text-dark mb-0">
    Danh sách đề tài
</h2>

<div class="d-flex flex-wrap gap-2">

    <c:if test="${pageContext.request.isUserInRole('LECTURER')}">

        <a href="${pageContext.request.contextPath}/topics/create"
           class="btn btn-primary fw-semibold px-3 py-2 shadow-sm"
           style="border-radius: 10px; min-height: 42px;">
            + Đề xuất đề tài
        </a>

    </c:if>

    <a href="${pageContext.request.contextPath}/topics/open"
       class="btn btn-outline-success fw-semibold px-3 py-2 shadow-sm"
       style="border-radius: 10px; min-height: 42px;">
        ✨ Đề tài đang mở
    </a>

</div>


</div>

<c:if test="${not empty success}">


<div class="alert alert-success alert-dismissible fade show shadow-sm"
     role="alert">

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
     role="alert">

    ${error}

    <button type="button"
            class="btn-close"
            data-bs-dismiss="alert"
            aria-label="Close">
    </button>

</div>


</c:if>

<form method="get"
      action="${pageContext.request.contextPath}/topics/search"
      class="row g-3 mb-5">


<div class="col-md-10">

    <input type="text"
           name="keyword"
           value="${keyword}"
           class="form-control fs-6 shadow-sm"
           style="border-radius: 10px; min-height: 48px;"
           placeholder="Nhập tên đề tài cần tìm...">

</div>

<div class="col-md-2">

    <button type="submit"
            class="btn btn-primary w-100 fw-semibold shadow-sm"
            style="border-radius: 10px; min-height: 48px;">
        Tìm kiếm
    </button>

</div>


</form>

<div class="row g-4">


<c:choose>

    <c:when test="${empty topics}">

        <div class="col-12">

            <div class="alert alert-info shadow-sm">
                Hiện chưa có đề tài nào đang mở.
            </div>

        </div>

    </c:when>

    <c:otherwise>

        <c:forEach var="topic" items="${topics}">

            <div class="col-md-4">

                <div class="card h-100 border-0 shadow-sm"
                     style="border-radius: 16px;
                            transition: transform 0.2s ease,
                            box-shadow 0.2s ease;">

                    <div class="card-body p-4 d-flex flex-column">

                        <h5 class="card-title fw-bold text-dark mb-3"
                            style="font-size: 18px; line-height: 1.4;">

                            ${topic.title}

                        </h5>

                        <p class="card-text text-muted small mb-3"
                           style="line-height: 1.6;
                                  display: -webkit-box;
                                  -webkit-line-clamp: 3;
                                  -webkit-box-orient: vertical;
                                  overflow: hidden;">

                            ${topic.description}

                        </p>

                        <c:if test="${not empty topic.department}">

                            <div class="small text-secondary mb-3">
                                Khoa / Bộ môn:
                                <strong class="text-dark">
                                    ${topic.department.name}
                                </strong>
                            </div>

                        </c:if>

                        <div class="mt-auto pt-2">

                            <div class="d-flex align-items-center justify-content-between mb-3 bg-light rounded-3 px-3 py-2">

                                <span class="text-secondary small fw-medium">

                                    Tối đa:

                                    <strong class="text-dark">
                                        ${topic.maxStudents} SV
                                    </strong>

                                </span>

                                <c:choose>

                                    <c:when test="${topic.status == 'OPEN'}">

                                        <span class="badge bg-success px-2 py-1 fw-normal"
                                              style="border-radius: 6px;">
                                            Đang mở
                                        </span>

                                    </c:when>

                                    <c:when test="${topic.status == 'PENDING'}">

                                        <span class="badge bg-warning text-dark px-2 py-1 fw-normal"
                                              style="border-radius: 6px;">
                                            Chờ duyệt
                                        </span>

                                    </c:when>

                                    <c:when test="${topic.status == 'APPROVED'}">

                                        <span class="badge bg-primary px-2 py-1 fw-normal"
                                              style="border-radius: 6px;">
                                            Đã duyệt
                                        </span>

                                    </c:when>

                                    <c:otherwise>

                                        <span class="badge bg-secondary px-2 py-1 fw-normal"
                                              style="border-radius: 6px;">
                                            ${topic.status}
                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </div>

                            <a href="${pageContext.request.contextPath}/topics/${topic.id}"
                               class="btn btn-outline-primary w-100 fw-semibold shadow-sm"
                               style="border-radius: 10px;
                                      min-height: 42px;
                                      display: inline-flex;
                                      align-items: center;
                                      justify-content: center;">

                                Xem chi tiết →

                            </a>

                        </div>

                    </div>

                </div>

            </div>

        </c:forEach>

    </c:otherwise>

</c:choose>

</div>

<%@ include file="../common/footer.jsp" %>