<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-10">

        <div class="card border-0 shadow-sm" style="border-radius: 16px; overflow: hidden;">

            <div class="card-header bg-white py-4 px-4 px-md-5 border-bottom">
                <h2 class="h3 fw-bold text-dark mb-0">
                    <c:choose>
                        <c:when test="${lecturer.id != null}">
                            Cập nhật thông tin giảng viên
                        </c:when>
                        <c:otherwise>
                            Thêm giảng viên mới
                        </c:otherwise>
                    </c:choose>
                </h2>
            </div>

            <div class="card-body p-4 p-md-5">

                <form method="post"
                      action="${pageContext.request.contextPath}/admin/lecturers/${lecturer.id == null ? 'create' : 'edit/'.concat(lecturer.id)}">

                    <div class="mb-4">
                        <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">
                            Tài khoản liên kết <span class="text-danger">*</span>
                        </label>
                        <select name="userId"
                                class="form-select fs-6"
                                style="border-radius: 10px; min-height: 46px;"
                                required>

                            <option value="">
                                -- Chọn tài khoản --
                            </option>

                            <c:forEach var="user" items="${users}">

                                <option value="${user.id}"
                                        ${lecturer.user.id == user.id ? 'selected' : ''}>

                                    ${user.username} - ${user.fullName}

                                </option>

                            </c:forEach>

                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">
                                Mã giảng viên <span class="text-danger">*</span>
                            </label>
                            <input type="text"
                                   name="lecturerCode"
                                   value="${lecturer.lecturerCode}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="Nhập mã giảng viên..."
                                   required>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">
                                Khoa
                            </label>
                            <input type="text"
                                   name="department"
                                   value="${lecturer.department}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="Nhập tên khoa...">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">
                            Chuyên môn
                        </label>
                        <input type="text"
                               name="specialization"
                               value="${lecturer.specialization}"
                               class="form-control fs-6"
                               style="border-radius: 10px; min-height: 46px;"
                               placeholder="Nhập lĩnh vực chuyên môn...">
                    </div>

                    <div class="d-flex flex-wrap align-items-center gap-3 mt-4 pt-3 border-top">
                        <button type="submit"
                                class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
                                style="border-radius: 10px; min-height: 44px; display: inline-flex; align-items: center;">
                            Lưu thông tin
                        </button>

                        <a href="${pageContext.request.contextPath}/admin/lecturers"
                           class="btn btn-light border px-4 py-2 fw-semibold text-secondary shadow-sm"
                           style="border-radius: 10px; min-height: 44px; display: inline-flex; align-items: center;">
                            Hủy bỏ
                        </a>
                    </div>

                </form>

            </div>
        </div>

    </div>
</div>

<%@ include file="../../common/footer.jsp" %>