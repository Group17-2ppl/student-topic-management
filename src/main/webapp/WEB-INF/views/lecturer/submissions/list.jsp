<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">

    <div class="col-lg-11">

        <c:if test="${not empty success}">

            <div class="alert alert-success alert-dismissible fade show"
                 role="alert"
                 style="border-radius: 12px;">

                <strong>Thành công!</strong>
                ${success}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert">
                </button>

            </div>

        </c:if>


        <c:if test="${not empty error}">

            <div class="alert alert-danger alert-dismissible fade show"
                 role="alert"
                 style="border-radius: 12px;">

                <strong>Lỗi!</strong>
                ${error}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert">
                </button>

            </div>

        </c:if>

        <div class="mb-4">

            <h2 class="fw-bold text-dark mb-1">
                Bài nộp sinh viên
            </h2>

            <p class="text-muted mb-0">
                Danh sách các đề tài bạn được phân công hướng dẫn hoặc phản biện.
            </p>

        </div>

        <c:choose>

            <c:when test="${empty assignments}">

                <div class="card border-0 shadow-sm"
                     style="border-radius: 16px;">

                    <div class="card-body p-5 text-center">

                        <div style="font-size: 50px;">
                            📄
                        </div>

                        <h4 class="fw-bold mt-3">
                            Chưa có đề tài được phân công
                        </h4>

                        <p class="text-muted mb-0">
                            Hiện tại bạn chưa được phân công đề tài nào.
                        </p>

                    </div>

                </div>

            </c:when>


            <c:otherwise>

                <div class="card border-0 shadow-sm"
                     style="border-radius: 16px;
                            overflow: hidden;">

                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0">

                            <thead class="bg-light">

                            <tr>

                                <th class="px-4 py-3">
                                    #
                                </th>

                                <th class="px-4 py-3">
                                    Đề tài
                                </th>

                                <th class="px-4 py-3">
                                    Vai trò
                                </th>

                                <th class="px-4 py-3 text-center">
                                    Thao tác
                                </th>

                            </tr>

                            </thead>


                            <tbody>

                            <c:forEach
                                    var="assignment"
                                    items="${assignments}"
                                    varStatus="status">

                                <tr>

                                    <td class="px-4 py-3">
                                        ${status.index + 1}
                                    </td>


                                    <td class="px-4 py-3">

                                        <div class="fw-semibold">
                                            ${assignment.topic.title}
                                        </div>

                                        <div class="small text-muted">
                                            Đề tài #${assignment.topic.id}
                                        </div>

                                    </td>


                                    <td class="px-4 py-3">

                                        <c:choose>

                                            <c:when test="${assignment.role == 'GVHD'}">

                                                <span class="badge bg-primary px-3 py-2">
                                                    GVHD
                                                </span>

                                            </c:when>

                                            <c:when test="${assignment.role == 'GVPB'}">

                                                <span class="badge bg-warning text-dark px-3 py-2">
                                                    GVPB
                                                </span>

                                            </c:when>

                                            <c:otherwise>

                                                <span class="badge bg-secondary px-3 py-2">
                                                    ${assignment.role}
                                                </span>

                                            </c:otherwise>

                                        </c:choose>

                                    </td>


                                    <td class="px-4 py-3 text-center">

                                        <a href="${pageContext.request.contextPath}/lecturer/submissions/topic/${assignment.topic.id}"
                                           class="btn btn-sm btn-primary px-3"
                                           style="border-radius: 8px;">

                                            Xem bài nộp

                                        </a>

                                    </td>

                                </tr>

                            </c:forEach>

                            </tbody>

                        </table>

                    </div>

                </div>

            </c:otherwise>

        </c:choose>

    </div>

</div>

<%@ include file="../../common/footer.jsp" %>