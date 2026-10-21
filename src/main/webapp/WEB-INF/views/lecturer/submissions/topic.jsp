<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">

    <div class="col-lg-11">

        <div class="mb-4">

            <a href="${pageContext.request.contextPath}/lecturer/submissions"
               class="text-decoration-none">

                ← Quay lại danh sách đề tài

            </a>

        </div>


        <c:choose>

            <c:when test="${not empty topic}">

                <div class="card border-0 shadow-sm mb-4"
                     style="border-radius: 16px;">

                    <div class="card-body p-4">

                        <div class="text-muted small mb-1">
                            Đề tài
                        </div>

                        <h3 class="fw-bold mb-2">
                            ${topic.title}
                        </h3>

                        <p class="text-muted mb-0">
                            ${topic.description}
                        </p>

                    </div>

                </div>

            </c:when>

            <c:otherwise>

                <div class="alert alert-info">
                    Đề tài hiện chưa có nhóm được duyệt đăng ký.
                </div>

            </c:otherwise>

        </c:choose>

        <c:forEach
                var="registration"
                items="${registrations}">

            <div class="card border-0 shadow-sm mb-4"
                 style="border-radius: 16px;">

                <div class="card-header bg-white border-0 p-4">

                    <div class="d-flex justify-content-between
                                align-items-center
                                flex-wrap gap-3">

                        <div>

                            <div class="text-muted small">
                                Nhóm sinh viên
                            </div>

                            <h5 class="fw-bold mb-0">
                                ${registration.group.name}
                            </h5>

                        </div>


                        <span class="badge bg-success px-3 py-2">
                            Đã duyệt
                        </span>

                    </div>

                </div>


                <div class="card-body pt-0">

                    <!-- ========================= -->
                    <!-- TRƯỞNG NHÓM -->
                    <!-- ========================= -->

                    <div class="mb-3">

                        <div class="text-muted small">
                            Trưởng nhóm
                        </div>

                        <div class="fw-semibold">

                            ${registration.group.leader.user.fullName}

                        </div>

                        <div class="small text-muted">

                            MSSV:
                            ${registration.group.leader.studentCode}

                        </div>

                    </div>

                    <div class="mb-4">

                        <div class="text-muted small mb-2">
                            Thành viên nhóm
                        </div>

                        <c:forEach
                                var="member"
                                items="${registration.group.members}">

                            <div class="d-flex
                                        justify-content-between
                                        align-items-center
                                        border-bottom
                                        py-2">

                                <div>

                                    <div class="fw-semibold">
                                        ${member.student.user.fullName}
                                    </div>

                                    <div class="small text-muted">
                                        ${member.student.studentCode}
                                    </div>

                                </div>


                                <c:choose>

                                    <c:when test="${member.role == 'LEADER'}">

                                        <span class="badge bg-primary">
                                            Trưởng nhóm
                                        </span>

                                    </c:when>

                                    <c:otherwise>

                                        <span class="badge bg-secondary">
                                            Thành viên
                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </div>

                        </c:forEach>

                    </div>

                    <div>

                        <div class="text-muted small mb-2">
                            Bài báo cáo
                        </div>


                        <c:choose>

                            <c:when test="${not empty registration.submission}">

                                <div class="border rounded-3 p-3">

                                    <div class="d-flex
                                                justify-content-between
                                                align-items-center
                                                flex-wrap gap-3">

                                        <div>

                                            <div class="fw-semibold">

                                                📄
                                                ${registration.submission.fileName}

                                            </div>

                                            <div class="small text-muted">

                                                Nộp lúc:
                                                ${registration.submission.submittedAt}

                                            </div>

                                            <c:if test="${not empty registration.submission.description}">

                                                <div class="small text-muted mt-1">

                                                    ${registration.submission.description}

                                                </div>

                                            </c:if>

                                        </div>


                                        <a href="${pageContext.request.contextPath}/lecturer/submissions/download/${registration.submission.id}"
                                           class="btn btn-primary btn-sm px-3"
                                           style="border-radius: 8px;">

                                            ⬇ Tải bài

                                        </a>

                                    </div>

                                </div>

                            </c:when>


                            <c:otherwise>

                                <div class="alert alert-secondary mb-0">

                                    Sinh viên chưa nộp bài báo cáo.

                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

            </div>

        </c:forEach>

    </div>

</div>

<%@ include file="../../common/footer.jsp" %>