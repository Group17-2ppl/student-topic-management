<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="container mt-4">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Quản lý đợt đăng ký</h2>

    <a href="${pageContext.request.contextPath}/admin/registration-rounds/create"
       class="btn btn-primary">
        + Tạo đợt đăng ký
    </a>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">
        ${success}
    </div>
</c:if>

<c:if test="${not empty error}">
    <div class="alert alert-danger">
        ${error}
    </div>
</c:if>

<c:choose>

    <c:when test="${empty rounds}">
        <div class="alert alert-info">
            Chưa có đợt đăng ký nào.
        </div>
    </c:when>

    <c:otherwise>

        <div class="table-responsive">

            <table class="table table-bordered table-hover">

                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Tên đợt</th>
                    <th>Loại</th>
                    <th>Bắt đầu nhận đề tài</th>
                    <th>Kết thúc nhận đề tài</th>
                    <th>Bắt đầu đăng ký</th>
                    <th>Kết thúc đăng ký</th>
                    <th>Hạn GVPB</th>
                    <th>Ngày hội đồng</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>

                <c:forEach var="round" items="${rounds}">

                    <tr>

                        <td>${round.id}</td>

                        <td>${round.name}</td>

                        <td>
                            <c:choose>

                                <c:when test="${round.type == 'MON_HOC'}">
                                    Môn học
                                </c:when>

                                <c:when test="${round.type == 'NCKH'}">
                                    Nghiên cứu khoa học
                                </c:when>

                                <c:when test="${round.type == 'TLCN'}">
                                    Tiểu luận chuyên ngành
                                </c:when>

                                <c:when test="${round.type == 'KLTN'}">
                                    Khóa luận tốt nghiệp
                                </c:when>

                                <c:otherwise>
                                    ${round.type}
                                </c:otherwise>

                            </c:choose>
                        </td>

                        <td>${round.topicStartAt}</td>

                        <td>${round.topicEndAt}</td>

                        <td>${round.registrationStartAt}</td>

                        <td>${round.registrationEndAt}</td>

                        <td>
                            <c:choose>

                                <c:when test="${not empty round.gvpbDeadlineAt}">
                                    ${round.gvpbDeadlineAt}
                                </c:when>

                                <c:otherwise>
                                    -
                                </c:otherwise>

                            </c:choose>
                        </td>

                        <td>
                            <c:choose>

                                <c:when test="${not empty round.councilDateAt}">
                                    ${round.councilDateAt}
                                </c:when>

                                <c:otherwise>
                                    -
                                </c:otherwise>

                            </c:choose>
                        </td>

                        <td>

                            <c:choose>

                                <c:when test="${round.status == 'DRAFT'}">
                                    <span class="badge bg-secondary">
                                        Nháp
                                    </span>
                                </c:when>

                                <c:when test="${round.status == 'TOPIC_SUBMISSION'}">
                                    <span class="badge bg-primary">
                                        Nhận đề tài
                                    </span>
                                </c:when>

                                <c:when test="${round.status == 'TOPIC_REVIEW'}">
                                    <span class="badge bg-warning text-dark">
                                        Duyệt đề tài
                                    </span>
                                </c:when>

                                <c:when test="${round.status == 'STUDENT_REGISTRATION'}">
                                    <span class="badge bg-success">
                                        Sinh viên đăng ký
                                    </span>
                                </c:when>

                                <c:when test="${round.status == 'CLOSED'}">
                                    <span class="badge bg-dark">
                                        Đã đóng
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    ${round.status}
                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <a href="${pageContext.request.contextPath}/admin/registration-rounds/edit/${round.id}"
                               class="btn btn-warning btn-sm mb-1">
                                Sửa
                            </a>

                            <c:if test="${round.status == 'DRAFT'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/registration-rounds/open-topic-submission/${round.id}"
                                      style="display:inline">

                                    <button type="submit"
                                            class="btn btn-primary btn-sm mb-1">
                                        Mở nhận đề tài
                                    </button>

                                </form>

                            </c:if>

                            <c:if test="${round.status == 'TOPIC_SUBMISSION'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/registration-rounds/open-topic-review/${round.id}"
                                      style="display:inline">

                                    <button type="submit"
                                            class="btn btn-warning btn-sm mb-1">
                                        Duyệt đề tài
                                    </button>

                                </form>

                            </c:if>

                            <c:if test="${round.status == 'TOPIC_REVIEW'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/registration-rounds/publish/${round.id}"
                                      style="display:inline">

                                    <button type="submit"
                                            class="btn btn-success btn-sm mb-1">
                                        Công bố đề tài
                                    </button>

                                </form>

                            </c:if>

                            <c:if test="${round.status != 'CLOSED'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/registration-rounds/close/${round.id}"
                                      style="display:inline">

                                    <button type="submit"
                                            class="btn btn-secondary btn-sm mb-1">
                                        Đóng đợt
                                    </button>

                                </form>

                            </c:if>

                            <c:if test="${round.status == 'DRAFT'}">

                                <form method="post"
                                      action="${pageContext.request.contextPath}/admin/registration-rounds/delete/${round.id}"
                                      style="display:inline"
                                      onsubmit="return confirm('Bạn có chắc muốn xóa đợt này?');">

                                    <button type="submit"
                                            class="btn btn-danger btn-sm mb-1">
                                        Xóa
                                    </button>

                                </form>

                            </c:if>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

    </c:otherwise>

</c:choose>

</div>

<%@ include file="../../common/footer.jsp" %>
