<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-10">

        <div class="card border-0 shadow-sm" style="border-radius: 16px; overflow: hidden;">

            <div class="card-header bg-white py-4 px-4 px-md-5 border-bottom">
                <h2 class="h3 fw-bold text-dark mb-0">
                    Thông tin sinh viên
                </h2>
            </div>

            <div class="card-body p-4 p-md-5">

                <form method="post"
                      action="${pageContext.request.contextPath}/admin/students/${student.id == null ? 'create' : 'edit/'.concat(student.id)}">

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
                                        ${student.user.id == user.id ? 'selected' : ''}>

                                    ${user.username} - ${user.fullName}

                                </option>

                            </c:forEach>

                        </select>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">
                                Mã sinh viên <span class="text-danger">*</span>
                            </label>
                            <input type="text"
                                   name="studentCode"
                                   value="${student.studentCode}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="Nhập mã sinh viên..."
                                   required>
                        </div>

                        <div class="col-md-6 mb-4">
                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">
                                Lớp sinh hoạt
                            </label>
                            <input type="text"
                                   name="className"
                                   value="${student.className}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="Nhập tên lớp...">
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">
                            Ngành học
                        </label>
                        <input type="text"
                               name="major"
                               value="${student.major}"
                               class="form-control fs-6"
                               style="border-radius: 10px; min-height: 46px;"
                               placeholder="Nhập chuyên ngành...">
                    </div>

                    <div class="d-flex flex-wrap align-items-center gap-3 mt-4 pt-3 border-top">
                        <button type="submit"
                                class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
                                style="border-radius: 10px; min-height: 44px; display: inline-flex; align-items: center;">
                            Lưu thông tin
                        </button>

                        <a href="${pageContext.request.contextPath}/admin/students"
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