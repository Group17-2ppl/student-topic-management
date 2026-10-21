<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>


<div class="container mt-4 mb-5">

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
            📌 Đề tài của tôi
        </h2>

        <p class="text-muted mb-0">
            Theo dõi đề tài, nhóm, giảng viên hướng dẫn
            và bài nộp của bạn.
        </p>

    </div>


    <c:choose>

        <c:when test="${empty registration}">

            <div class="card border-0 shadow-sm"
                 style="border-radius: 16px;">

                <div class="card-body text-center py-5">

                    <div style="font-size: 52px;">
                        📚
                    </div>

                    <h4 class="fw-bold mt-3">
                        Bạn chưa có đề tài
                    </h4>

                    <p class="text-muted mb-4">
                        Hiện tại bạn chưa có đăng ký đề tài nào.
                    </p>

                    <a href="${pageContext.request.contextPath}/registrations"
                       class="btn btn-primary px-4"
                       style="border-radius: 10px;">

                        Xem đăng ký đề tài

                    </a>

                </div>

            </div>

        </c:when>

        <c:otherwise>

            <div class="card border-0 shadow-sm mb-4"
                 style="border-radius: 16px;">

                <div class="card-body p-4">


                    <div class="d-flex
                                justify-content-between
                                align-items-start
                                flex-wrap
                                gap-3">


                        <div class="flex-grow-1">

                            <div class="text-muted small mb-1">
                                Tên đề tài
                            </div>

                            <h3 class="fw-bold mb-2">

                                ${registration.topic.title}

                            </h3>

                        </div>

                        <div>

                            <c:choose>


                                <c:when test="${registration.status == 'APPROVED'}">

                                    <span class="badge bg-success px-3 py-2">

                                        ✓ Đã duyệt

                                    </span>

                                </c:when>


                                <c:when test="${registration.status == 'PENDING'}">

                                    <span class="badge
                                                 bg-warning
                                                 text-dark
                                                 px-3
                                                 py-2">

                                        ⏳ Chờ duyệt

                                    </span>

                                </c:when>


                                <c:when test="${registration.status == 'REJECTED'}">

                                    <span class="badge bg-danger px-3 py-2">

                                        ✕ Từ chối

                                    </span>

                                </c:when>


                                <c:otherwise>

                                    <span class="badge
                                                 bg-secondary
                                                 px-3
                                                 py-2">

                                        ${registration.status}

                                    </span>

                                </c:otherwise>


                            </c:choose>

                        </div>

                    </div>


                    <hr>


                    <div class="row g-4">

                        <div class="col-md-8">

                            <div class="text-muted small mb-1">
                                Mô tả đề tài
                            </div>

                            <div style="white-space: pre-line;">

                                ${registration.topic.description}

                            </div>

                        </div>


                        <!-- THÔNG TIN ĐĂNG KÝ -->

                        <div class="col-md-4">

                            <div class="text-muted small mb-1">
                                Mã đăng ký
                            </div>

                            <div class="fw-semibold mb-3">

                                #${registration.id}

                            </div>


                            <div class="text-muted small mb-1">
                                Ngày đăng ký
                            </div>

                            <div class="fw-semibold">

                                ${registration.registeredAt}

                            </div>

                        </div>


                    </div>


                </div>

            </div>

            <div class="row g-4">

                <div class="col-lg-7">

                    <div class="card
                                border-0
                                shadow-sm
                                h-100"
                         style="border-radius: 16px;
                                overflow: hidden;">


                        <div class="card-header
                                    bg-white
                                    border-0
                                    p-4">

                            <h5 class="fw-bold mb-1">

                                👥 Nhóm

                            </h5>

                            <p class="text-muted mb-0">

                                Thông tin nhóm thực hiện đề tài.

                            </p>

                        </div>


                        <div class="card-body pt-0">


                            <c:if test="${not empty registration.group}">

                                <div class="p-3
                                            mb-3
                                            rounded-3
                                            bg-light">

                                    <div class="text-muted small">
                                        Tên nhóm
                                    </div>

                                    <div class="fw-bold fs-5">

                                        ${registration.group.name}

                                    </div>

                                </div>

                            </c:if>


                            <div class="table-responsive">

                                <table class="table
                                              table-hover
                                              align-middle
                                              mb-0">


                                    <thead>

                                    <tr>

                                        <th>
                                            Sinh viên
                                        </th>

                                        <th>
                                            MSSV
                                        </th>

                                        <th>
                                            Vai trò
                                        </th>

                                    </tr>

                                    </thead>


                                    <tbody>


                                    <c:forEach var="member"
                                               items="${members}">


                                        <tr>


                                            <td>

                                                <div class="fw-semibold">

                                                    ${member.student.user.fullName}

                                                </div>

                                                <div class="small text-muted">

                                                    ${member.student.user.email}

                                                </div>

                                            </td>


                                            <td>

                                                ${member.student.studentCode}

                                            </td>


                                            <td>

                                                <c:choose>


                                                    <c:when test="${member.role == 'LEADER'}">

                                                        <span class="badge
                                                                     bg-primary
                                                                     px-3
                                                                     py-2">

                                                            👑 Trưởng nhóm

                                                        </span>

                                                    </c:when>


                                                    <c:otherwise>

                                                        <span class="badge
                                                                     bg-secondary
                                                                     px-3
                                                                     py-2">

                                                            Thành viên

                                                        </span>

                                                    </c:otherwise>


                                                </c:choose>

                                            </td>


                                        </tr>


                                    </c:forEach>


                                    <c:if test="${empty members}">

                                        <tr>

                                            <td colspan="3"
                                                class="text-center
                                                       text-muted
                                                       py-4">

                                                Chưa có thông tin thành viên.

                                            </td>

                                        </tr>

                                    </c:if>


                                    </tbody>

                                </table>

                            </div>


                        </div>

                    </div>

                </div>

                <div class="col-lg-5">

                    <div class="card
                                border-0
                                shadow-sm
                                h-100"
                         style="border-radius: 16px;">


                        <div class="card-body p-4">


                            <h5 class="fw-bold mb-1">

                                👨‍🏫 Giảng viên hướng dẫn

                            </h5>


                            <p class="text-muted mb-4">

                                Giảng viên được phân công
                                cho đề tài.

                            </p>


                            <c:choose>


                                <c:when test="${not empty supervisors}">


                                    <c:forEach var="assignment"
                                               items="${supervisors}">


                                        <div class="d-flex
                                                    align-items-center
                                                    gap-3
                                                    border
                                                    rounded-3
                                                    p-3
                                                    mb-3">


                                            <div style="font-size: 30px;">

                                                👨‍🏫

                                            </div>


                                            <div>

                                                <div class="fw-bold">

                                                    ${assignment.lecturer.user.fullName}

                                                </div>


                                                <div class="small text-muted">

                                                    Mã GV:
                                                    ${assignment.lecturer.lecturerCode}

                                                </div>


                                                <c:if test="${not empty assignment.lecturer.specialization}">

                                                    <div class="small text-muted">

                                                        ${assignment.lecturer.specialization}

                                                    </div>

                                                </c:if>


                                            </div>


                                        </div>


                                    </c:forEach>


                                </c:when>


                                <c:otherwise>


                                    <div class="text-center py-4">


                                        <div style="font-size: 42px;">

                                            👨‍🏫

                                        </div>


                                        <div class="fw-semibold mt-2">

                                            Chưa phân công

                                        </div>


                                        <div class="text-muted small">

                                            Đề tài chưa có
                                            giảng viên hướng dẫn.

                                        </div>


                                    </div>


                                </c:otherwise>


                            </c:choose>


                        </div>

                    </div>

                </div>


            </div>

            <div class="card
                        border-0
                        shadow-sm
                        mt-4"
                 style="border-radius: 16px;">


                <div class="card-header
                            bg-white
                            border-0
                            p-4">


                    <h5 class="fw-bold mb-1">

                        📄 Bài đã nộp

                    </h5>


                    <p class="text-muted mb-0">

                        Thông tin bài báo cáo của nhóm.

                    </p>


                </div>


                <div class="card-body pt-0">


                    <c:choose>

                        <c:when test="${not empty submission}">


                            <div class="row
                                        align-items-center
                                        g-3
                                        p-3
                                        rounded-3
                                        bg-light">


                                <div class="col-md-7">

                                    <div class="text-muted small">

                                        Tên file

                                    </div>

                                    <div class="fw-semibold text-break">

                                        📎 ${submission.fileName}

                                    </div>

                                </div>


                                <div class="col-md-3">

                                    <div class="text-muted small">

                                        Thời gian nộp

                                    </div>

                                    <div class="fw-semibold">

                                        ${submission.submittedAt}

                                    </div>

                                </div>


                                <div class="col-md-2 text-md-end">

                                    <a href="${pageContext.request.contextPath}/student/my-topic/download/${submission.id}"
                                       class="btn btn-primary w-100"
                                       style="border-radius: 10px;">

                                        ⬇ Tải bài

                                    </a>

                                </div>


                            </div>


                        </c:when>

                        <c:otherwise>


                            <div class="text-center py-4">


                                <div style="font-size: 42px;">

                                    📄

                                </div>


                                <div class="fw-semibold mt-2">

                                    Chưa có bài nộp

                                </div>


                                <div class="text-muted small mb-3">

                                    Nhóm chưa nộp báo cáo
                                    cho đề tài này.

                                </div>

                                <c:if test="${registration.group.leader.id == student.id}">

                                    <a href="${pageContext.request.contextPath}/submission/${registration.id}"
                                       class="btn btn-outline-primary"
                                       style="border-radius: 10px;">

                                        📤 Nộp bài

                                    </a>

                                </c:if>


                            </div>


                        </c:otherwise>


                    </c:choose>


                </div>

            </div>


        </c:otherwise>


    </c:choose>


</div>


<%@ include file="../common/footer.jsp" %>