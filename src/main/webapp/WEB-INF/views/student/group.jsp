<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>

<div class="row justify-content-center">

    <div class="col-lg-10">

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
                Nhóm của tôi
            </h2>

            <p class="text-muted mb-0">
                Quản lý nhóm sinh viên và thành viên.
            </p>

        </div>


        <!-- CHƯA CÓ NHÓM -->

        <c:if test="${not hasGroup}">

            <div class="card border-0 shadow-sm"
                 style="border-radius: 16px;">

                <div class="card-body p-5 text-center">

                    <div style="font-size: 50px;">
                        👥
                    </div>

                    <h4 class="fw-bold mt-3">
                        Bạn chưa có nhóm
                    </h4>

                    <p class="text-muted">
                        Hãy tạo nhóm để bắt đầu đăng ký đề tài.
                    </p>

                    <form method="post"
                          action="${pageContext.request.contextPath}/student/group/create"
                          class="mt-4">

                        <div class="row justify-content-center">

                            <div class="col-md-7">

                                <input type="text"
                                       name="groupName"
                                       class="form-control"
                                       placeholder="Nhập tên nhóm"
                                       maxlength="100"
                                       required
                                       style="border-radius: 10px;">

                            </div>

                        </div>

                        <button type="submit"
                                class="btn btn-primary mt-3 px-4 fw-semibold"
                                style="border-radius: 10px;">

                            + Tạo nhóm

                        </button>

                    </form>

                </div>

            </div>

        </c:if>


        <!-- ĐÃ CÓ NHÓM -->

        <c:if test="${hasGroup}">

            <div class="card border-0 shadow-sm mb-4"
                 style="border-radius: 16px;">

                <div class="card-body p-4">

                    <div class="d-flex justify-content-between
                                align-items-center
                                flex-wrap gap-3">

                        <div>

                            <div class="text-muted small">
                                Tên nhóm
                            </div>

                            <h3 class="fw-bold mb-0">
                                ${group.name}
                            </h3>

                        </div>

                        <div>

                            <span class="badge bg-primary px-3 py-2">
                                ${members.size()} / 3 thành viên
                            </span>

                        </div>

                    </div>

                    <hr>

                    <div class="text-muted small">
                        Trưởng nhóm
                    </div>

                    <div class="fw-semibold">
                        ${group.leader.user.fullName}
                    </div>

                    <div class="small text-muted">
                        ${group.leader.studentCode}
                    </div>

                </div>

            </div>


            <!-- THÀNH VIÊN -->

            <div class="card border-0 shadow-sm mb-4"
                 style="border-radius: 16px;
                        overflow: hidden;">

                <div class="card-header bg-white border-0 p-4">

                    <h5 class="fw-bold mb-1">
                        Thành viên nhóm
                    </h5>

                    <p class="text-muted mb-0">
                        Nhóm tối đa 3 sinh viên.
                    </p>

                </div>

                <div class="table-responsive">

                    <table class="table table-hover mb-0">

                        <thead class="bg-light">

                        <tr>

                            <th class="px-4 py-3">
                                Sinh viên
                            </th>

                            <th class="px-4 py-3">
                                MSSV
                            </th>

                            <th class="px-4 py-3">
                                Vai trò
                            </th>

                            <c:if test="${isLeader}">
                                <th class="px-4 py-3 text-center">
                                    Thao tác
                                </th>
                            </c:if>

                        </tr>

                        </thead>

                        <tbody>

                        <c:forEach var="member"
                                   items="${members}">

                            <tr>

                                <td class="px-4 py-3">

                                    <div class="fw-semibold">
                                        ${member.student.user.fullName}
                                    </div>

                                    <div class="small text-muted">
                                        ${member.student.user.email}
                                    </div>

                                </td>

                                <td class="px-4 py-3">
                                    ${member.student.studentCode}
                                </td>

                                <td class="px-4 py-3">

                                    <c:choose>

                                        <c:when test="${member.role == 'LEADER'}">

                                            <span class="badge bg-primary px-3 py-2">
                                                Trưởng nhóm
                                            </span>

                                        </c:when>

                                        <c:otherwise>

                                            <span class="badge bg-secondary px-3 py-2">
                                                Thành viên
                                            </span>

                                        </c:otherwise>

                                    </c:choose>

                                </td>

                                <c:if test="${isLeader}">

                                    <td class="px-4 py-3 text-center">

                                        <c:if test="${member.role != 'LEADER'}">

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/student/group/members/remove"
                                                  class="m-0"
                                                  onsubmit="return confirm('Bạn có chắc muốn xóa sinh viên này khỏi nhóm?');">

                                                <input type="hidden"
                                                       name="studentId"
                                                       value="${member.student.id}">

                                                <button type="submit"
                                                        class="btn btn-sm btn-outline-danger"
                                                        style="border-radius: 8px;">

                                                    Xóa

                                                </button>

                                            </form>

                                        </c:if>

                                    </td>

                                </c:if>

                            </tr>

                        </c:forEach>

                        </tbody>

                    </table>

                </div>

            </div>


            <!-- THÊM THÀNH VIÊN -->

            <c:if test="${isLeader && members.size() < 3}">

                <div class="card border-0 shadow-sm mb-4"
                     style="border-radius: 16px;">

                    <div class="card-body p-4">

                        <h5 class="fw-bold mb-3">
                            Thêm thành viên
                        </h5>

                        <form method="post"
                              action="${pageContext.request.contextPath}/student/group/members/add">

                            <div class="row g-3 align-items-end">

                                <div class="col-md-9">

                                    <label class="form-label fw-semibold">
                                        Mã sinh viên
                                    </label>

                                    <input type="number"
                                           name="studentId"
                                           class="form-control"
                                           placeholder="Nhập ID sinh viên"
                                           required
                                           style="border-radius: 10px;">

                                </div>

                                <div class="col-md-3">

                                    <button type="submit"
                                            class="btn btn-primary w-100 fw-semibold"
                                            style="border-radius: 10px;">

                                        + Thêm

                                    </button>

                                </div>

                            </div>

                        </form>

                    </div>

                </div>

            </c:if>


            <c:if test="${isLeader}">

                <div class="text-end mb-5">

                    <form method="post"
                          action="${pageContext.request.contextPath}/student/group/delete"
                          onsubmit="return confirm('Bạn có chắc chắn muốn giải tán nhóm?');">

                        <button type="submit"
                                class="btn btn-outline-danger"
                                style="border-radius: 10px;">

                            Giải tán nhóm

                        </button>

                    </form>

                </div>

            </c:if>

        </c:if>

    </div>

</div>

<%@ include file="../common/footer.jsp" %>