<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-12">

        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <h2 class="h3 fw-bold text-dark mb-0">
                Yêu cầu đăng ký chờ duyệt
            </h2>
        </div>

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
                                    Nhóm
                                </th>

                                <th class="py-3 px-4 border-bottom-0">
                                    Trưởng nhóm
                                </th>

                                <th class="py-3 px-4 border-bottom-0">
                                    Đề tài
                                </th>

                                <th class="py-3 px-4 border-bottom-0 text-center"
                                    style="width: 200px;">
                                    Thao tác
                                </th>

                            </tr>
                        </thead>

                        <tbody>

                            <c:choose>

                                <c:when test="${empty registrations}">

                                    <tr>
                                        <td colspan="5"
                                            class="text-center py-5 text-muted">

                                            Không có yêu cầu đăng ký nào đang chờ duyệt.

                                        </td>
                                    </tr>

                                </c:when>

                                <c:otherwise>

                                    <c:forEach
                                            var="registration"
                                            items="${registrations}">

                                        <tr>

                                            <!-- ID -->
                                            <td class="py-3 px-4 fw-semibold text-secondary">
                                                #${registration.id}
                                            </td>

                                            <!-- NHÓM -->
                                            <td class="py-3 px-4 fw-medium text-dark">
                                                ${registration.group.name}
                                            </td>

                                            <!-- TRƯỞNG NHÓM -->
                                            <td class="py-3 px-4 fw-medium text-dark">
                                                ${registration.group.leader.user.fullName}
                                            </td>

                                            <!-- ĐỀ TÀI -->
                                            <td class="py-3 px-4 text-muted">
                                                ${registration.topic.title}
                                            </td>

                                            <!-- THAO TÁC -->
                                            <td class="py-3 px-4 text-center">

                                                <div class="d-flex justify-content-center gap-2">

                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/registrations/approve/${registration.id}"
                                                          class="m-0">

                                                        <button
                                                                type="submit"
                                                                class="btn btn-sm btn-outline-success px-3 fw-semibold"
                                                                style="border-radius: 8px; display: inline-flex; align-items: center;">

                                                            Duyệt

                                                        </button>

                                                    </form>


                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/registrations/reject/${registration.id}"
                                                          class="m-0">

                                                        <button
                                                                type="submit"
                                                                class="btn btn-sm btn-outline-danger px-3 fw-semibold"
                                                                style="border-radius: 8px; display: inline-flex; align-items: center;">

                                                            Từ chối

                                                        </button>

                                                    </form>

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