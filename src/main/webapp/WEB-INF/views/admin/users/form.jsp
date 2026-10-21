<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-10">

        <div class="card border-0 shadow-sm"
             style="border-radius: 16px; overflow: hidden;">

            <div class="card-header bg-white py-4 px-4 px-md-5 border-bottom">

                <h2 class="h3 fw-bold text-dark mb-0">

                    <c:choose>

                        <c:when test="${user.id != null}">
                            Cập nhật thông tin người dùng
                        </c:when>

                        <c:otherwise>
                            Thêm người dùng mới
                        </c:otherwise>

                    </c:choose>

                </h2>

            </div>

            <div class="card-body p-4 p-md-5">

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

                <form method="post"
                      action="${pageContext.request.contextPath}/admin/users/${user.id == null ? 'create' : 'edit/'.concat(user.id)}">

                    <div class="row">

                        <!-- Username -->

                        <div class="col-md-6 mb-4">

                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">

                                Tên đăng nhập (Username)

                                <span class="text-danger">*</span>

                            </label>

                            <input type="text"
                                   name="username"
                                   value="${user.username}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="Nhập username..."
                                   required>

                        </div>

                        <div class="col-md-6 mb-4">

                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">

                                Mật khẩu (Password)

                                <c:if test="${user.id == null}">
                                    <span class="text-danger">*</span>
                                </c:if>

                            </label>

                            <input type="password"
                                   name="password"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="${user.id != null ? 'Để trống nếu không đổi mật khẩu' : 'Nhập mật khẩu...'}"
                                   <c:if test="${user.id == null}">
                                       required
                                   </c:if>>

                        </div>

                    </div>

                    <div class="row">

                        <!-- Full name -->

                        <div class="col-md-6 mb-4">

                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">

                                Họ tên đầy đủ

                            </label>

                            <input type="text"
                                   name="fullName"
                                   value="${user.fullName}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="Nhập họ tên...">

                        </div>

                        <div class="col-md-6 mb-4">

                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">

                                Địa chỉ Email

                            </label>

                            <input type="email"
                                   name="email"
                                   value="${user.email}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="name@example.com">

                        </div>

                    </div>

                    <div class="row">

                        <!-- Phone -->

                        <div class="col-md-6 mb-4">

                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">

                                Số điện thoại

                            </label>

                            <input type="text"
                                   name="phone"
                                   value="${user.phone}"
                                   class="form-control fs-6"
                                   style="border-radius: 10px; min-height: 46px;"
                                   placeholder="Nhập số điện thoại...">

                        </div>


                        <!-- Role -->

                        <div class="col-md-6 mb-4">

                            <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">

                                Vai trò hệ thống

                                <span class="text-danger">*</span>

                            </label>

                            <select name="role"
                                    id="roleSelect"
                                    class="form-select fs-6"
                                    style="border-radius: 10px; min-height: 46px;"
                                    required>

                                <option value="STUDENT"
                                        ${user.role == 'STUDENT' ? 'selected' : ''}>

                                    Sinh viên

                                </option>

                                <option value="LECTURER"
                                        ${user.role == 'LECTURER' ? 'selected' : ''}>

                                    Giảng viên

                                </option>

                                <option value="ADMIN"
                                        ${user.role == 'ADMIN' ? 'selected' : ''}>

                                    Quản trị viên

                                </option>

                            </select>

                        </div>

                    </div>

                    <div class="mb-4">

                        <label class="form-label fw-semibold text-secondary small text-uppercase tracking-wider mb-2">

                            Địa chỉ liên hệ

                        </label>

                        <input type="text"
                               name="address"
                               value="${user.address}"
                               class="form-control fs-6"
                               style="border-radius: 10px; min-height: 46px;"
                               placeholder="Nhập địa chỉ cư trú...">

                    </div>

                    <div id="studentFields"
                         class="border rounded-3 p-4 mb-4"
                         style="display: none;">

                        <div class="mb-4">
                            <h5 class="fw-bold text-dark mb-1">
                                Thông tin sinh viên
                            </h5>
                            <p class="text-muted small mb-0">
                                Tài khoản Sinh viên sẽ được liên kết tự động với hồ sơ Student.
                            </p>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-secondary">
                                    Mã sinh viên <span class="text-danger">*</span>
                                </label>
                                <input type="text"
                                       name="studentCode"
                                       id="studentCode"
                                       value="${student.studentCode}"
                                       class="form-control"
                                       style="border-radius: 10px; min-height: 46px;"
                                       placeholder="Ví dụ: SV001">
                            </div>

                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-secondary">
                                    Lớp
                                </label>
                                <input type="text"
                                       name="className"
                                       value="${student.className}"
                                       class="form-control"
                                       style="border-radius: 10px; min-height: 46px;"
                                       placeholder="Ví dụ: CNTT01">
                            </div>

                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-semibold text-secondary">
                                    Ngành
                                </label>
                                <input type="text"
                                       name="major"
                                       value="${student.major}"
                                       class="form-control"
                                       style="border-radius: 10px; min-height: 46px;"
                                       placeholder="Ví dụ: Công nghệ thông tin">
                            </div>
                        </div>
                    </div>

                    <div id="lecturerFields"
                         class="border rounded-3 p-4 mb-4"
                         style="display: none;">

                        <!-- Lecturer header -->

                        <div class="mb-4">

                            <h5 class="fw-bold text-dark mb-1">
                                Thông tin giảng viên
                            </h5>

                            <p class="text-muted small mb-0">
                                Thông tin này được sử dụng khi tài khoản có vai trò Giảng viên.
                            </p>

                        </div>

                        <div class="row">

                            <!-- Lecturer Code -->

                            <div class="col-md-6 mb-4">

                                <label class="form-label fw-semibold text-secondary">

                                    Mã giảng viên

                                    <span class="text-danger">*</span>

                                </label>

                                <input type="text"
                                       name="lecturerCode"
                                       id="lecturerCode"
                                       value="${lecturer.lecturerCode}"
                                       class="form-control"
                                       style="border-radius: 10px; min-height: 46px;"
                                       placeholder="Ví dụ: GV001">

                            </div>

                            <div class="col-md-6 mb-4">

                                <label class="form-label fw-semibold text-secondary">

                                    Chuyên môn

                                    <span class="text-danger">*</span>

                                </label>

                                <input type="text"
                                       name="specialization"
                                       id="specialization"
                                       value="${lecturer.specialization}"
                                       class="form-control"
                                       style="border-radius: 10px; min-height: 46px;"
                                       placeholder="Ví dụ: Công nghệ phần mềm">

                            </div>

                        </div>

                        <div class="mb-2">

                            <label class="form-label fw-semibold text-secondary">

                                Khoa

                                <span class="text-danger">*</span>

                            </label>

                            <select name="departmentId"
                                    id="departmentId"
                                    class="form-select"
                                    style="border-radius: 10px; min-height: 46px;">

                                <option value="">
                                    -- Chọn khoa --
                                </option>

                                <c:forEach
                                        var="department"
                                        items="${departments}">

                                    <option
                                            value="${department.id}"
                                            ${lecturer != null
                                              && lecturer.department != null
                                              && lecturer.department.id == department.id
                                              ? 'selected'
                                              : ''}>

                                        ${department.name}

                                    </option>

                                </c:forEach>

                            </select>

                        </div>

                    </div>

                    <div class="d-flex flex-wrap align-items-center gap-3 mt-4 pt-3 border-top">

                        <!-- Save -->

                        <button type="submit"
                                class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
                                style="border-radius: 10px; min-height: 44px; display: inline-flex; align-items: center;">

                            Lưu thông tin

                        </button>


                        <!-- Cancel -->

                        <a href="${pageContext.request.contextPath}/admin/users"
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

<script>

    document.addEventListener("DOMContentLoaded", function () {

        const roleSelect =
            document.getElementById("roleSelect");

        const lecturerFields =
            document.getElementById("lecturerFields");

        const studentFields =
            document.getElementById("studentFields");

        const studentCode =
            document.getElementById("studentCode");

        const lecturerCode =
            document.getElementById("lecturerCode");

        const specialization =
            document.getElementById("specialization");

        const departmentId =
            document.getElementById("departmentId");


        function toggleRoleFields() {

            const isLecturer = roleSelect.value === "LECTURER";
            const isStudent = roleSelect.value === "STUDENT";

            lecturerFields.style.display = isLecturer ? "block" : "none";
            studentFields.style.display = isStudent ? "block" : "none";

            lecturerCode.required = isLecturer;
            specialization.required = isLecturer;
            departmentId.required = isLecturer;

            studentCode.required = isStudent;
        }


        roleSelect.addEventListener(
                "change",
                toggleRoleFields
        );

        toggleRoleFields();

    });

</script>


<%@ include file="../../common/footer.jsp" %>