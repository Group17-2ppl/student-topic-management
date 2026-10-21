<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="container-fluid px-0">

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm border-0" role="alert" style="border-radius:14px;">
            <strong>Thành công!</strong> ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm border-0" role="alert" style="border-radius:14px;">
            <strong>Không thể đăng ký:</strong> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
        <div>
            <h2 class="fw-bold text-dark mb-1">Đăng ký hướng dẫn</h2>
            <p class="text-muted mb-0">Chọn đề tài đã có sinh viên được duyệt để đăng ký làm giảng viên hướng dẫn.</p>
        </div>
        <span class="badge bg-primary-subtle text-primary px-3 py-2" style="border-radius:10px;">
            👨‍🏫 ${lecturer.lecturerCode}
        </span>
    </div>

    <div class="card border-0 shadow-sm mb-4" style="border-radius:18px;">
        <div class="card-body p-4">
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="rounded-3 bg-primary-subtle text-primary d-flex align-items-center justify-content-center" style="width:46px;height:46px;font-size:22px;">📚</div>
                <div>
                    <h5 class="fw-bold mb-1">Đề tài đang chờ đăng ký hướng dẫn</h5>
                    <div class="text-muted small">Mỗi đề tài tối đa 2 GVHD theo quy định phân công hiện tại.</div>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty topics}">
                    <div class="text-center py-5">
                        <div style="font-size:48px;">📭</div>
                        <h5 class="fw-bold mt-3">Chưa có đề tài phù hợp</h5>
                        <p class="text-muted mb-0">Hiện chưa có đề tài công bố nào có sinh viên được duyệt đăng ký.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Đề tài</th>
                                <th>Bộ môn</th>
                                <th>Người đề xuất</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="topic" items="${topics}" varStatus="st">
                                <c:set var="myGuidance" value="false" />
                                <c:set var="guidanceCount" value="0" />
                                <c:forEach var="assignment" items="${topic.assignments}">
                                    <c:if test="${assignment.role == 'GVHD'}">
                                        <c:set var="guidanceCount" value="${guidanceCount + 1}" />
                                        <c:if test="${assignment.lecturer.id == lecturer.id}">
                                            <c:set var="myGuidance" value="true" />
                                        </c:if>
                                    </c:if>
                                </c:forEach>
                                <tr>
                                    <td>${st.index + 1}</td>
                                    <td>
                                        <div class="fw-semibold">${topic.title}</div>
                                        <div class="small text-muted">Đề tài #${topic.id}</div>
                                    </td>
                                    <td>${topic.department.name}</td>
                                    <td>${topic.createdBy.user.fullName}</td>
                                    <td>
                                        <span class="badge bg-success-subtle text-success px-3 py-2" style="border-radius:8px;">Đang mở</span>
                                        <span class="small text-muted ms-1">${guidanceCount}/2 GVHD</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${myGuidance}">
                                                <span class="badge bg-primary px-3 py-2" style="border-radius:9px;">✓ Đã đăng ký</span>
                                            </c:when>
                                            <c:when test="${guidanceCount >= 2}">
                                                <span class="badge bg-secondary px-3 py-2" style="border-radius:9px;">Đã đủ GVHD</span>
                                            </c:when>
                                            <c:otherwise>
                                                <form method="post" action="${pageContext.request.contextPath}/lecturer/registrations/register" class="d-inline">
                                                    <input type="hidden" name="topicId" value="${topic.id}">
                                                    <button type="submit" class="btn btn-primary btn-sm fw-semibold px-3" style="border-radius:9px;">
                                                        Đăng ký GVHD
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="card border-0 shadow-sm" style="border-radius:18px;">
        <div class="card-body p-4">
            <h5 class="fw-bold mb-3">Đề tài tôi đang hướng dẫn</h5>
            <c:choose>
                <c:when test="${empty assignments}">
                    <p class="text-muted mb-0">Bạn chưa đăng ký hướng dẫn đề tài nào.</p>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Đề tài</th>
                                <th>Vai trò</th>
                                <th>Thời gian đăng ký</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="assignment" items="${assignments}" varStatus="st">
                                <tr>
                                    <td>${st.index + 1}</td>
                                    <td>
                                        <div class="fw-semibold">${assignment.topic.title}</div>
                                        <div class="small text-muted">Đề tài #${assignment.topic.id}</div>
                                    </td>
                                    <td><span class="badge bg-primary px-3 py-2" style="border-radius:8px;">${assignment.role}</span></td>
                                    <td>${assignment.assignedAt}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<%@ include file="../../common/footer.jsp" %>
