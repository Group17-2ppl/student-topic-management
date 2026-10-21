<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-12">

        <!-- ===================================================== -->
        <!-- HEADER -->
        <!-- ===================================================== -->

        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">

            <h2 class="h3 fw-bold text-dark mb-0">
                Quản lý người dùng
            </h2>

            <a href="${pageContext.request.contextPath}/admin/users/create"
               class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
               style="border-radius: 10px; min-height: 42px; display: inline-flex; align-items: center;">

                + Thêm người dùng mới

            </a>

        </div>


        <!-- ===================================================== -->
        <!-- SUCCESS MESSAGE -->
        <!-- ===================================================== -->

        <c:if test="${not empty success}">

            <div class="alert alert-success alert-dismissible fade show"
                 role="alert">

                <strong>Thành công!</strong>
                ${success}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Close">
                </button>

            </div>

        </c:if>


        <!-- ===================================================== -->
        <!-- ERROR MESSAGE -->
        <!-- ===================================================== -->

        <c:if test="${not empty error}">

            <div class="alert alert-danger alert-dismissible fade show"
                 role="alert">

                <strong>Lỗi!</strong>
                ${error}

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="alert"
                        aria-label="Close">
                </button>

            </div>

        </c:if>


        <!-- ===================================================== -->
        <!-- USER TABLE -->
        <!-- ===================================================== -->

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
                                Username
                            </th>

                            <th class="py-3 px-4 border-bottom-0">
                                Họ tên
                            </th>

                            <th class="py-3 px-4 border-bottom-0">
                                Email
                            </th>

                            <th class="py-3 px-4 border-bottom-0 text-center"
                                style="width: 140px;">
                                Vai trò
                            </th>

                            <th class="py-3 px-4 border-bottom-0 text-center"
                                style="width: 180px;">
                                Thao tác
                            </th>

                        </tr>

                        </thead>


                        <tbody>

                        <c:choose>

                            <c:when test="${empty users}">

                                <tr>

                                    <td colspan="6"
                                        class="text-center py-5 text-muted">

                                        Chưa có người dùng nào.

                                    </td>

                                </tr>

                            </c:when>


                            <c:otherwise>

                                <c:forEach
                                        var="user"
                                        items="${users}">

                                    <tr>

                                        <!-- ID -->

                                        <td class="py-3 px-4 fw-semibold text-secondary">

                                            #${user.id}

                                        </td>


                                        <!-- USERNAME -->

                                        <td class="py-3 px-4 fw-medium text-dark">

                                            ${user.username}

                                        </td>


                                        <!-- FULL NAME -->

                                        <td class="py-3 px-4 text-muted">

                                            ${user.fullName}

                                        </td>


                                        <!-- EMAIL -->

                                        <td class="py-3 px-4 text-muted">

                                            ${user.email}

                                        </td>


                                        <!-- ROLE -->

                                        <td class="py-3 px-4 text-center">

                                            <c:choose>

                                                <c:when test="${user.role == 'ADMIN'}">

                                                    <span class="badge bg-danger px-3 py-2 fw-normal"
                                                          style="border-radius: 8px;">

                                                        ADMIN

                                                    </span>

                                                </c:when>


                                                <c:when test="${user.role == 'LECTURER'}">

                                                    <span class="badge bg-primary px-3 py-2 fw-normal"
                                                          style="border-radius: 8px;">

                                                        LECTURER

                                                    </span>

                                                </c:when>


                                                <c:when test="${user.role == 'STUDENT'}">

                                                    <span class="badge bg-success px-3 py-2 fw-normal"
                                                          style="border-radius: 8px;">

                                                        STUDENT

                                                    </span>

                                                </c:when>


                                                <c:otherwise>

                                                    <span class="badge bg-secondary px-3 py-2 fw-normal"
                                                          style="border-radius: 8px;">

                                                        ${user.role}

                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

                                        </td>


                                        <!-- ACTION -->

                                        <td class="py-3 px-4 text-center">

                                            <div class="d-flex justify-content-center gap-2">

                                                <a href="${pageContext.request.contextPath}/admin/users/edit/${user.id}"
                                                   class="btn btn-sm btn-outline-warning px-3 fw-semibold"
                                                   style="border-radius: 8px; display: inline-flex; align-items: center;">

                                                    Sửa

                                                </a>


                                                <a href="${pageContext.request.contextPath}/admin/users/delete/${user.id}"
                                                   class="btn btn-sm btn-outline-danger px-3 fw-semibold"
                                                   style="border-radius: 8px; display: inline-flex; align-items: center;"
                                                   onclick="return confirm('Bạn có chắc muốn xóa người dùng này?')">

                                                    Xóa

                                                </a>

                                            </div>

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

    </div>
</div>

<%@ include file="../../common/footer.jsp" %>