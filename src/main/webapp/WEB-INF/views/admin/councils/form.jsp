<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-8 col-xl-7">

    <div class="d-flex justify-content-between align-items-center mb-4">

        <div>
            <h2 class="h3 fw-bold text-dark mb-1">
                <c:choose>
                    <c:when test="${empty council.id}">
                        Tạo hội đồng
                    </c:when>
                    <c:otherwise>
                        Chỉnh sửa hội đồng
                    </c:otherwise>
                </c:choose>
            </h2>

            <p class="text-muted mb-0">
                <c:choose>
                    <c:when test="${empty council.id}">
                        Tạo hội đồng mới cho đợt đăng ký KLTN.
                    </c:when>
                    <c:otherwise>
                        Cập nhật thông tin hội đồng.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/admin/councils"
           class="btn btn-outline-secondary px-4 py-2 fw-semibold"
           style="border-radius: 10px;">
            Quay lại
        </a>

    </div>

    <div class="card border-0 shadow-sm"
         style="border-radius: 16px; overflow: hidden;">

        <div class="card-body p-4 p-md-5">

            <form method="post"
                  action="${pageContext.request.contextPath}/admin/councils${empty council.id ? '/create' : '/edit/'.concat(council.id)}">

                <div class="mb-4">

                    <label for="name"
                           class="form-label fw-semibold">
                        Tên hội đồng
                        <span class="text-danger">*</span>
                    </label>

                    <input type="text"
                           id="name"
                           name="name"
                           class="form-control"
                           value="${council.name}"
                           placeholder="Ví dụ: Hội đồng KLTN đợt 1 năm 2026"
                           maxlength="255"
                           required
                           style="border-radius: 10px; min-height: 45px;">

                    <div class="form-text">
                        Nhập tên dùng để nhận diện hội đồng.
                    </div>

                </div>

                <div class="mb-4">

                    <label for="registrationRoundId"
                           class="form-label fw-semibold">
                        Đợt đăng ký
                        <span class="text-danger">*</span>
                    </label>

                    <select id="registrationRoundId"
                            name="registrationRoundId"
                            class="form-select"
                            required
                            style="border-radius: 10px; min-height: 45px;">

                        <option value="">
                            -- Chọn đợt đăng ký --
                        </option>

                        <c:forEach var="round"
                                   items="${registrationRounds}">

                            <option value="${round.id}"
                                <c:if test="${council.registrationRound != null && council.registrationRound.id == round.id}">
                                    selected
                                </c:if>
                            >
                                ${round.name}
                            </option>

                        </c:forEach>

                    </select>

                    <div class="form-text">
                        Chỉ được tạo hội đồng cho đợt đăng ký KLTN.
                    </div>

                </div>

                <c:if test="${not empty council.id}">

                    <div class="mb-4">

                        <label class="form-label fw-semibold">
                            Trạng thái
                        </label>

                        <div>

                            <c:choose>

                                <c:when test="${council.status == 'DRAFT'}">
                                    <span class="badge bg-secondary px-3 py-2">
                                        DRAFT
                                    </span>
                                </c:when>

                                <c:when test="${council.status == 'ACTIVE'}">
                                    <span class="badge bg-success px-3 py-2">
                                        ACTIVE
                                    </span>
                                </c:when>

                                <c:when test="${council.status == 'COMPLETED'}">
                                    <span class="badge bg-primary px-3 py-2">
                                        COMPLETED
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="badge bg-light text-dark px-3 py-2">
                                        ${council.status}
                                    </span>
                                </c:otherwise>

                            </c:choose>

                        </div>

                        <div class="form-text">
                            Trạng thái hội đồng được hệ thống quản lý tự động.
                        </div>

                    </div>

                </c:if>

                <c:if test="${empty council.id}">

                    <div class="alert alert-info border-0 shadow-sm"
                         style="border-radius: 10px;">

                        <strong>Lưu ý:</strong>
                        Hội đồng mới sẽ được tạo ở trạng thái
                        <strong>DRAFT</strong>.
                        Sau khi thêm đủ thành viên và đề tài,
                        bạn có thể kích hoạt hội đồng từ trang chi tiết.

                    </div>

                </c:if>

                <div class="d-flex justify-content-end gap-2 pt-3">

                    <a href="${pageContext.request.contextPath}/admin/councils"
                       class="btn btn-outline-secondary px-4 py-2 fw-semibold"
                       style="border-radius: 10px;">
                        Hủy
                    </a>

                    <button type="submit"
                            class="btn btn-primary px-4 py-2 fw-semibold"
                            style="border-radius: 10px; min-width: 120px;">

                        <c:choose>

                            <c:when test="${empty council.id}">
                                Tạo hội đồng
                            </c:when>

                            <c:otherwise>
                                Lưu thay đổi
                            </c:otherwise>

                        </c:choose>

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

</div>

<%@ include file="../../common/footer.jsp" %>
