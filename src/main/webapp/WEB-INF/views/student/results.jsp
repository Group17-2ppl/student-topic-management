<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>

<div class="container mt-4">

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show"
             role="alert">

            ${success}

            <button type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>
    </c:if>


    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show"
             role="alert">

            ${error}

            <button type="button"
                    class="btn-close"
                    data-bs-dismiss="alert">
            </button>

        </div>
    </c:if>


    <div class="mb-4">

        <h2 class="fw-bold mb-1">
            📊 Kết quả đề tài
        </h2>

        <p class="text-muted mb-0">
            Kết quả chỉ được hiển thị sau khi nhà trường công bố.
        </p>

    </div>


    <c:choose>

        <c:when test="${empty results}">

            <div class="card border-0 shadow-sm"
                 style="border-radius: 16px;">

                <div class="card-body text-center py-5">

                    <div style="font-size: 48px;">
                        📊
                    </div>

                    <h4 class="fw-bold mt-3">
                        Chưa có kết quả
                    </h4>

                    <p class="text-muted mb-0">
                        Hiện tại chưa có kết quả đề tài nào được công bố.
                    </p>

                </div>

            </div>

        </c:when>


        <c:otherwise>

            <div class="card border-0 shadow-sm"
                 style="border-radius: 16px; overflow: hidden;">

                <div class="card-body p-0">

                    <div class="table-responsive">

                        <table class="table table-hover align-middle mb-0">

                            <thead class="bg-light">

                            <tr>

                                <th class="py-3 px-4">
                                    Đề tài
                                </th>

                                <th class="py-3 px-4">
                                    Nhóm
                                </th>

                                <th class="py-3 px-4 text-center">
                                    Điểm
                                </th>

                                <th class="py-3 px-4 text-center">
                                    Trạng thái
                                </th>

                                <th class="py-3 px-4 text-center">
                                    Ngày công bố
                                </th>

                            </tr>

                            </thead>


                            <tbody>

                            <c:forEach
                                    var="result"
                                    items="${results}">

                                <tr>

                                    <td class="py-3 px-4">

                                        <div class="fw-semibold">

                                            ${result.topic.title}

                                        </div>

                                        <small class="text-muted">

                                            ${result.topic.department.name}

                                        </small>

                                    </td>


                                    <td class="py-3 px-4">

                                        <c:forEach
                                                var="registration"
                                                items="${registrations}">

                                            <c:if test="${registration.topic.id == result.topic.id}">

                                                ${registration.group.name}

                                            </c:if>

                                        </c:forEach>

                                    </td>


                                    <td class="py-3 px-4 text-center">

                                        <span class="fs-5 fw-bold">

                                            ${result.finalScore}

                                        </span>

                                        <span class="text-muted">
                                            / 10
                                        </span>

                                    </td>


                                    <td class="py-3 px-4 text-center">

                                        <span class="badge bg-success px-3 py-2"
                                              style="border-radius: 8px;">

                                            Đã công bố

                                        </span>

                                    </td>


                                    <td class="py-3 px-4 text-center">

                                        <c:choose>

                                            <c:when test="${not empty result.publishedAt}">

                                                ${result.publishedAt}

                                            </c:when>

                                            <c:otherwise>

                                                -

                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                </tr>

                            </c:forEach>

                            </tbody>

                        </table>

                    </div>

                </div>

            </div>

        </c:otherwise>

    </c:choose>

</div>

<%@ include file="../common/footer.jsp" %>