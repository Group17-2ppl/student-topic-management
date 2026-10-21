<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-10">

    <div class="card border-0 shadow-sm"
         style="border-radius: 16px; overflow: hidden;">

        <div class="card-header bg-white py-4 px-4 px-md-5 border-bottom">
            <h2 class="h3 fw-bold text-dark mb-0">
                ${topic.id == null ? 'Đề xuất đề tài' : 'Chỉnh sửa đề tài'}
            </h2>
        </div>

        <div class="card-body p-4 p-md-5">

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ${success}
                </div>
            </c:if>

            <form method="post"
                  action="${pageContext.request.contextPath}/topics/${topic.id == null ? 'create' : 'edit/'.concat(topic.id)}">

                <div class="mb-4">

                    <label class="form-label fw-semibold text-secondary small text-uppercase mb-2">
                        Tên đề tài <span class="text-danger">*</span>
                    </label>

                    <input type="text"
                           name="title"
                           value="${topic.title}"
                           class="form-control form-control-lg fs-6"
                           style="border-radius: 10px; min-height: 48px;"
                           placeholder="Nhập tên đề tài..."
                           required>

                </div>

                <div class="mb-4">

                    <label class="form-label fw-semibold text-secondary small text-uppercase mb-2">
                        Mô tả <span class="text-danger">*</span>
                    </label>

                    <textarea name="description"
                              rows="5"
                              class="form-control fs-6"
                              style="border-radius: 10px;"
                              placeholder="Nhập mô tả chi tiết đề tài..."
                              required>${topic.description}</textarea>

                </div>

                <div class="row">

                    <div class="${empty topic.id ? 'col-md-4' : 'col-md-6'} mb-4">

                        <label class="form-label fw-semibold text-secondary small text-uppercase mb-2">
                            Số sinh viên tối đa <span class="text-danger">*</span>
                        </label>

                        <input type="number"
                               name="maxStudents"
                               value="${topic.maxStudents}"
                               min="1"
                               class="form-control fs-6"
                               style="border-radius: 10px; min-height: 46px;"
                               required>

                    </div>

                    <div class="${empty topic.id ? 'col-md-4' : 'col-md-6'} mb-4">

                        <label class="form-label fw-semibold text-secondary small text-uppercase mb-2">
                            Khoa / Bộ môn <span class="text-danger">*</span>
                        </label>

                        <c:choose>

                            <c:when test="${not empty departments}">

                                <select name="departmentId"
                                        class="form-select fs-6"
                                        style="border-radius: 10px; min-height: 46px;"
                                        required>

                                    <option value="">
                                        -- Chọn khoa / bộ môn --
                                    </option>

                                    <c:forEach var="department"
                                               items="${departments}">

                                        <option value="${department.id}"
                                                ${not empty topic.department && topic.department.id == department.id ? 'selected' : ''}>
                                            ${department.name}
                                        </option>

                                    </c:forEach>

                                </select>

                            </c:when>

                            <c:otherwise>

                                <div class="alert alert-warning mb-0">
                                    Chưa có khoa / bộ môn nào trong hệ thống.
                                </div>

                            </c:otherwise>

                        </c:choose>

                    </div>

                    <c:if test="${empty topic.id}">

                        <div class="col-md-4 mb-4">

                            <label class="form-label fw-semibold text-secondary small text-uppercase mb-2">
                                Đợt đăng ký <span class="text-danger">*</span>
                            </label>

                            <c:choose>

                                <c:when test="${not empty registrationRounds}">

                                    <select name="registrationRoundId"
                                            class="form-select fs-6"
                                            style="border-radius: 10px; min-height: 46px;"
                                            required>

                                        <option value="">
                                            -- Chọn đợt đăng ký --
                                        </option>

                                        <c:forEach var="round"
                                                   items="${registrationRounds}">

                                            <option value="${round.id}">
                                                ${round.name}
                                            </option>

                                        </c:forEach>

                                    </select>

                                    <div class="form-text">
                                        Chỉ hiển thị các đợt đang nhận đề tài.
                                    </div>

                                </c:when>

                                <c:otherwise>

                                    <div class="alert alert-warning mb-0">
                                        Hiện tại chưa có đợt đăng ký nào đang nhận đề tài.
                                    </div>

                                </c:otherwise>

                            </c:choose>

                        </div>

                    </c:if>

                </div>

                <c:if test="${not empty topic.id}">

                    <div class="mb-4">

                        <label class="form-label fw-semibold text-secondary small text-uppercase mb-2">
                            Trạng thái hiện tại
                        </label>

                        <input type="text"
                               value="${topic.status}"
                               class="form-control fs-6"
                               style="border-radius: 10px; min-height: 46px;"
                               readonly>

                    </div>

                </c:if>

                <div class="d-flex flex-wrap align-items-center gap-3 mt-4 pt-2 border-top">

                    <c:if test="${empty topic.id and not empty registrationRounds and not empty departments}">

                        <button type="submit"
                                class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
                                style="border-radius: 10px; min-height: 44px;">
                            Đề xuất đề tài
                        </button>

                    </c:if>

                    <c:if test="${not empty topic.id}">

                        <button type="submit"
                                class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
                                style="border-radius: 10px; min-height: 44px;">
                            Lưu thay đổi
                        </button>

                    </c:if>

                    <a href="${pageContext.request.contextPath}/topics"
                       class="btn btn-light border px-4 py-2 fw-semibold text-secondary shadow-sm"
                       style="border-radius: 10px; min-height: 44px;">
                        Hủy bỏ
                    </a>

                </div>

            </form>

        </div>

    </div>

</div>

</div>

<%@ include file="../common/footer.jsp" %>
