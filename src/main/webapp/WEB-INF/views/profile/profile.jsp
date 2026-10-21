<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-12">

        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <h2 class="h3 fw-bold text-dark mb-0">
                Danh sách đăng ký đề tài
            </h2>
        </div>

        <div class="card border-0 shadow-sm" style="border-radius: 16px; overflow: hidden;">
            <div class="card-body p-0">

                <div class="table-responsive m-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-uppercase fs-7 text-secondary tracking-wider">
                            <tr>
                                <th class="py-3 px-4 border-bottom-0" style="width: 80px;">ID</th>
                                <th class="py-3 px-4 border-bottom-0">Sinh viên</th>
                                <th class="py-3 px-4 border-bottom-0">Đề tài</th>
                                <th class="py-3 px-4 border-bottom-0 text-center" style="width: 160px;">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="registration" items="${registrations}">
                                <tr>
                                    <td class="py-3 px-4 fw-semibold text-secondary">
                                        #${registration.id}
                                    </td>

                                    <td class="py-3 px-4 fw-medium text-dark">
                                        ${registration.student.user.fullName}
                                    </td>

                                    <td class="py-3 px-4 text-muted">
                                        ${registration.topic.title}
                                    </td>

                                    <td class="py-3 px-4 text-center">
                                        <c:choose>
                                            <c:when test="${registration.status == 'PENDING'}">
                                                <span class="badge bg-warning text-dark px-3 py-2 fw-normal" style="border-radius: 8px;">
                                                    Chờ duyệt
                                                </span>
                                            </c:when>
                                            <c:when test="${registration.status == 'APPROVED'}">
                                                <span class="badge bg-success px-3 py-2 fw-normal" style="border-radius: 8px;">
                                                    Đã duyệt
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger px-3 py-2 fw-normal" style="border-radius: 8px;">
                                                    Từ chối
                                                </span>
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

    </div>
</div>

<%@ include file="../common/footer.jsp" %>