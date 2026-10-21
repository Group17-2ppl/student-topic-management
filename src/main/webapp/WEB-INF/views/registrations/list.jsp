<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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


    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>

            <h2 class="fw-bold mb-1">
                Đề tài nhóm tôi
            </h2>

            <p class="text-muted mb-0">
                Danh sách đề tài mà nhóm của bạn đã đăng ký
            </p>

        </div>

        <a href="${pageContext.request.contextPath}/topics"
           class="btn btn-primary">

            Đăng ký đề tài

        </a>

    </div>


    <c:if test="${not hasGroup}">

        <div class="card border-0 shadow-sm">

            <div class="card-body text-center py-5">

                <div class="mb-3">
                    <span style="font-size: 48px;">👥</span>
                </div>

                <h4 class="fw-bold mb-2">
                    Bạn chưa có nhóm
                </h4>

                <p class="text-muted mb-4">
                    Bạn cần tạo hoặc tham gia một nhóm trước khi đăng ký đề tài.
                </p>

                <a href="${pageContext.request.contextPath}/student/group"
                   class="btn btn-primary">

                    Quản lý nhóm

                </a>

            </div>

        </div>

    </c:if>


    <c:if test="${hasGroup}">

        <div class="card border-0 shadow-sm mb-4"
             style="border-radius: 16px;">

            <div class="card-body">

                <div class="row align-items-center">

                    <div class="col-md-8">

                        <h5 class="fw-bold mb-2">
                            ${group.name}
                        </h5>

                        <p class="text-muted mb-1">

                            Trưởng nhóm:

                            <strong>
                                ${group.leader.user.fullName}
                            </strong>

                        </p>

                        <p class="text-muted mb-0">

                            Thành viên:

                            <strong>
                                ${group.members.size()}
                            </strong>

                            / 3

                        </p>

                    </div>

                    <div class="col-md-4 text-md-end mt-3 mt-md-0">

                        <a href="${pageContext.request.contextPath}/student/group"
                           class="btn btn-outline-primary">

                            Xem nhóm

                        </a>

                    </div>

                </div>

            </div>

        </div>


        <div class="card border-0 shadow-sm"
             style="border-radius: 16px; overflow: hidden;">

            <div class="card-body p-0">

                <div class="table-responsive">

                    <table class="table table-hover align-middle mb-0">

                        <thead class="bg-light">

                        <tr>

                            <th class="py-3 px-4"
                                style="width: 80px;">

                                ID

                            </th>

                            <th class="py-3 px-4">

                                Đề tài

                            </th>

                            <th class="py-3 px-4 text-center"
                                style="width: 160px;">

                                Trạng thái

                            </th>

                            <th class="py-3 px-4 text-center"
                                style="width: 180px;">

                                Thao tác

                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <c:choose>

                            <c:when test="${empty registrations}">

                                <tr>

                                    <td colspan="4"
                                        class="text-center py-5 text-muted">

                                        Nhóm chưa đăng ký đề tài nào.

                                    </td>

                                </tr>

                            </c:when>


                            <c:otherwise>

                                <c:forEach var="registration"
                                           items="${registrations}">

                                    <tr>

                                        <td class="py-3 px-4 fw-semibold text-secondary">

                                            #${registration.id}

                                        </td>


                                        <td class="py-3 px-4">

                                            <a href="${pageContext.request.contextPath}/topics/${registration.topic.id}"
                                               class="text-decoration-none fw-semibold">

                                                ${registration.topic.title}

                                            </a>

                                        </td>


                                        <td class="py-3 px-4 text-center">

                                            <c:choose>

                                                <c:when test="${registration.status == 'PENDING'}">

                                                    <span class="badge bg-warning text-dark px-3 py-2"
                                                          style="border-radius: 8px;">

                                                        Chờ duyệt

                                                    </span>

                                                </c:when>


                                                <c:when test="${registration.status == 'APPROVED'}">

                                                    <span class="badge bg-success px-3 py-2"
                                                          style="border-radius: 8px;">

                                                        Đã duyệt

                                                    </span>

                                                </c:when>


                                                <c:when test="${registration.status == 'REJECTED'}">

                                                    <span class="badge bg-danger px-3 py-2"
                                                          style="border-radius: 8px;">

                                                        Từ chối

                                                    </span>

                                                </c:when>


                                                <c:otherwise>

                                                    <span class="badge bg-secondary px-3 py-2"
                                                          style="border-radius: 8px;">

                                                        ${registration.status}

                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </td>


                                        <td class="py-3 px-4 text-center">

                                            <c:choose>

                                                <c:when test="${registration.status == 'PENDING' && isLeader}">

                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/registrations/delete/${registration.id}"
                                                          class="m-0">

                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-danger"
                                                                style="border-radius: 8px;">

                                                            Hủy đăng ký

                                                        </button>

                                                    </form>

                                                </c:when>


                                                <c:when test="${registration.status == 'APPROVED' && isLeader}">

                                                    <a href="${pageContext.request.contextPath}/submission/${registration.id}"
                                                       class="btn btn-sm btn-primary"
                                                       style="border-radius: 8px;">

                                                        📤 Nộp bài

                                                    </a>

                                                </c:when>


                                                <c:otherwise>

                                                    <span class="text-muted small">

                                                        Không có

                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </td>

                                    </tr>

                                </c:forEach>

                            </c:otherwise>

                        </c:choose>

                        </tbody>

                    </table>

                </div>

            </div>

        </div>

    </c:if>

</div>

<%@ include file="../common/footer.jsp" %>