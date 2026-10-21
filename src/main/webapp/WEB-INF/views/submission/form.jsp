<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
           uri="jakarta.tags.core" %>

<%@ include file="../common/header.jsp" %>

<div class="container mt-4">

    <div class="card shadow-sm">

        <div class="card-header">
            <h4 class="mb-0">📤 Nộp bài đề tài</h4>
        </div>

        <div class="card-body">

            <div class="mb-4">

                <h5>
                    ${registration.topic.title}
                </h5>

                <p class="mb-1">
                    <strong>Nhóm:</strong>
                    ${registration.group.name}
                </p>

                <p class="mb-1">
                    <strong>Trưởng nhóm:</strong>
                    ${registration.group.leader.user.fullName}
                </p>

                <p class="mb-0">
                    <strong>Trạng thái đăng ký:</strong>

                    <span class="badge bg-success">
                        Đã duyệt
                    </span>
                </p>

            </div>

            <c:if test="${not empty submission}">

                <div class="alert alert-info">

                    <strong>Bài nộp hiện tại:</strong>

                    <br>

                    ${submission.fileName}

                    <br>

                    <small>
                        Nộp lúc:
                        ${submission.submittedAt}
                    </small>

                </div>

            </c:if>

            <form
                    method="post"
                    action="${pageContext.request.contextPath}/submission/${registration.id}"
                    enctype="multipart/form-data">

                <div class="mb-3">

                    <label class="form-label">
                        File bài nộp
                    </label>

                    <input
                            type="file"
                            name="file"
                            class="form-control"
                            required>

                    <div class="form-text">
                        Chọn file bài báo cáo / bài nộp của nhóm.
                    </div>

                </div>

                <div class="mb-3">

                    <label class="form-label">
                        Mô tả
                    </label>

                    <textarea
                            name="description"
                            class="form-control"
                            rows="4"
                            placeholder="Mô tả ngắn về bài nộp...">${submission.description}</textarea>

                </div>

                <div class="d-flex gap-2">

                    <button
                            type="submit"
                            class="btn btn-primary">
                        📤
                        <c:choose>
                            <c:when test="${empty submission}">
                                Nộp bài
                            </c:when>
                            <c:otherwise>
                                Cập nhật bài nộp
                            </c:otherwise>
                        </c:choose>
                    </button>

                    <a
                            href="${pageContext.request.contextPath}/registrations"
                            class="btn btn-secondary">
                        Quay lại
                    </a>

                </div>

            </form>

        </div>

    </div>

</div>

<%@ include file="../common/footer.jsp" %>