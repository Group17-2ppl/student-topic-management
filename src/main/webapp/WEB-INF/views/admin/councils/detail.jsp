<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">

   
<div class="col-lg-12">


    <!-- ========================= -->
    <!-- SUCCESS -->
    <!-- ========================= -->

    <c:if test="${not empty success}">

        <div class="alert alert-success alert-dismissible fade show shadow-sm"
             role="alert"
             style="border-radius: 12px;">

            <strong>Thành công!</strong>
            ${success}

            <button type="button"
                    class="btn-close"
                    data-bs-dismiss="alert"
                    aria-label="Close">
            </button>

        </div>

    </c:if>


    <!-- ========================= -->
    <!-- ERROR -->
    <!-- ========================= -->

    <c:if test="${not empty error}">

        <div class="alert alert-danger alert-dismissible fade show shadow-sm"
             role="alert"
             style="border-radius: 12px;">

            <strong>Lỗi!</strong>
            ${error}

            <button type="button"
                    class="btn-close"
                    data-bs-dismiss="alert"
                    aria-label="Close">
            </button>

        </div>

    </c:if>


    <!-- ========================= -->
    <!-- PAGE HEADER -->
    <!-- ========================= -->

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">

        <div>

            <h2 class="h3 fw-bold text-dark mb-1">
                ${council.name}
            </h2>

            <p class="text-muted mb-0">
                Chi tiết hội đồng
            </p>

        </div>


        <div class="d-flex align-items-center gap-2">

            <a href="${pageContext.request.contextPath}/admin/councils"
               class="btn btn-outline-secondary px-4 py-2 fw-semibold"
               style="border-radius: 10px;">

                Quay lại

            </a>


            <c:if test="${council.status == 'DRAFT'}">

                <a href="${pageContext.request.contextPath}/admin/councils/edit/${council.id}"
                   class="btn btn-outline-primary px-4 py-2 fw-semibold"
                   style="border-radius: 10px;">

                    Sửa

                </a>

            </c:if>

        </div>

    </div>


    <!-- ========================= -->
    <!-- COUNCIL INFORMATION -->
    <!-- ========================= -->

    <div class="card border-0 shadow-sm mb-4"
         style="border-radius: 16px;">

        <div class="card-body p-4">

            <div class="row g-4">


                <!-- ID -->

                <div class="col-md-4">

                    <div class="text-muted small mb-1">
                        ID hội đồng
                    </div>

                    <div class="fw-semibold text-dark">
                        #${council.id}
                    </div>

                </div>


                <!-- REGISTRATION ROUND -->

                <div class="col-md-4">

                    <div class="text-muted small mb-1">
                        Đợt đăng ký
                    </div>

                    <div class="fw-semibold text-dark">
                        ${council.registrationRound.name}
                    </div>

                </div>


                <!-- STATUS -->

                <div class="col-md-4">

                    <div class="text-muted small mb-1">
                        Trạng thái
                    </div>

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

                </div>

            </div>

        </div>

    </div>


    <!-- ========================= -->
    <!-- COUNCIL MEMBERS -->
    <!-- ========================= -->

    <div class="card border-0 shadow-sm mb-4"
         style="border-radius: 16px; overflow: hidden;">

        <div class="card-header bg-white border-0 p-4">

            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">

                <div>

                    <h5 class="fw-bold text-dark mb-1">
                        Thành viên hội đồng
                    </h5>

                    <p class="text-muted mb-0">
                        Quản lý chủ tịch, thư ký và thành viên hội đồng.
                    </p>

                </div>


                <span class="badge bg-light text-dark px-3 py-2">
                    ${members.size()} thành viên
                </span>

            </div>

        </div>


        <div class="card-body p-0">


            <!-- ADD MEMBER -->

            <c:if test="${council.status == 'DRAFT'}">

                <div class="p-4 border-bottom bg-light">

                    <form method="post"
                          action="${pageContext.request.contextPath}/admin/councils/${council.id}/members/add">

                        <div class="row g-3 align-items-end">


                            <div class="col-md-6">

                                <label for="lecturerId"
                                       class="form-label fw-semibold">

                                    Giảng viên

                                </label>

                                <select id="lecturerId"
                                        name="lecturerId"
                                        class="form-select"
                                        required
                                        style="border-radius: 10px;">

                                    <option value="">
                                        -- Chọn giảng viên --
                                    </option>

                                    <c:forEach var="lecturer"
                                               items="${lecturers}">

                                        <option value="${lecturer.id}">

                                            ${lecturer.user.fullName}
                                            (${lecturer.lecturerCode})

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <label for="role"
                                       class="form-label fw-semibold">

                                    Vai trò

                                </label>

                                <select id="role"
                                        name="role"
                                        class="form-select"
                                        required
                                        style="border-radius: 10px;">

                                    <option value="">
                                        -- Chọn vai trò --
                                    </option>

                                    <option value="PRESIDENT">
                                        Chủ tịch
                                    </option>

                                    <option value="SECRETARY">
                                        Thư ký
                                    </option>

                                    <option value="MEMBER">
                                        Thành viên
                                    </option>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <button type="submit"
                                        class="btn btn-primary w-100 fw-semibold"
                                        style="border-radius: 10px; min-height: 40px;">

                                    + Thêm thành viên

                                </button>

                            </div>

                        </div>

                    </form>

                </div>

            </c:if>


            <!-- MEMBERS TABLE -->

            <div class="table-responsive">

                <table class="table table-hover align-middle mb-0">

                    <thead class="bg-light">

                    <tr>

                        <th class="py-3 px-4"
                            style="width: 80px;">

                            ID

                        </th>

                        <th class="py-3 px-4">
                            Giảng viên
                        </th>

                        <th class="py-3 px-4">
                            Vai trò
                        </th>

                        <c:if test="${council.status == 'DRAFT'}">

                            <th class="py-3 px-4 text-center"
                                style="width: 120px;">

                                Thao tác

                            </th>

                        </c:if>

                    </tr>

                    </thead>


                    <tbody>

                    <c:forEach var="member"
                               items="${members}">

                        <tr>


                            <td class="py-3 px-4 text-secondary fw-semibold">

                                #${member.id}

                            </td>


                            <td class="py-3 px-4">

                                <div class="fw-semibold text-dark">

                                    ${member.lecturer.user.fullName}

                                </div>

                                <div class="small text-muted">

                                    ${member.lecturer.lecturerCode}

                                </div>

                                <c:if test="${not empty member.lecturer.user.email}">

                                    <div class="small text-muted">

                                        ${member.lecturer.user.email}

                                    </div>

                                </c:if>

                            </td>


                            <td class="py-3 px-4">

                                <c:choose>

                                    <c:when test="${member.role == 'PRESIDENT'}">

                                        <span class="badge bg-danger px-3 py-2">
                                            Chủ tịch
                                        </span>

                                    </c:when>


                                    <c:when test="${member.role == 'SECRETARY'}">

                                        <span class="badge bg-warning text-dark px-3 py-2">
                                            Thư ký
                                        </span>

                                    </c:when>


                                    <c:when test="${member.role == 'MEMBER'}">

                                        <span class="badge bg-secondary px-3 py-2">
                                            Thành viên
                                        </span>

                                    </c:when>


                                    <c:otherwise>

                                        <span class="badge bg-light text-dark px-3 py-2">
                                            ${member.role}
                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </td>


                            <c:if test="${council.status == 'DRAFT'}">

                                <td class="py-3 px-4 text-center">

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/admin/councils/members/delete/${member.id}"
                                          onsubmit="return confirm('Bạn có chắc chắn muốn xóa thành viên này khỏi hội đồng?');"
                                          class="m-0">

                                        <input type="hidden"
                                               name="councilId"
                                               value="${council.id}">

                                        <button type="submit"
                                                class="btn btn-sm btn-outline-danger px-3 fw-semibold"
                                                style="border-radius: 8px;">

                                            Xóa

                                        </button>

                                    </form>

                                </td>

                            </c:if>

                        </tr>

                    </c:forEach>


                    <c:if test="${empty members}">

                        <tr>

                            <td colspan="${council.status == 'DRAFT' ? 4 : 3}"
                                class="text-center py-5 text-muted">

                                Chưa có thành viên nào.

                            </td>

                        </tr>

                    </c:if>

                    </tbody>

                </table>

            </div>

        </div>

    </div>


    <!-- ========================= -->
    <!-- COUNCIL TOPICS -->
    <!-- ========================= -->

    <div class="card border-0 shadow-sm mb-4"
         style="border-radius: 16px; overflow: hidden;">

        <div class="card-header bg-white border-0 p-4">

            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">

                <div>

                    <h5 class="fw-bold text-dark mb-1">
                        Đề tài trong hội đồng
                    </h5>

                    <p class="text-muted mb-0">
                        Các đề tài được phân công cho hội đồng.
                    </p>

                </div>


                <span class="badge bg-light text-dark px-3 py-2">

                    ${topics.size()} đề tài

                </span>

            </div>

        </div>


        <div class="card-body p-0">


            <!-- ADD TOPIC -->

            <c:if test="${council.status == 'DRAFT'}">

                <div class="p-4 border-bottom bg-light">

                    <form method="post"
                          action="${pageContext.request.contextPath}/admin/councils/${council.id}/topics/add">

                        <div class="row g-3 align-items-end">


                            <div class="col-md-9">

                                <label for="topicId"
                                       class="form-label fw-semibold">

                                    Đề tài

                                </label>

                                <select id="topicId"
                                        name="topicId"
                                        class="form-select"
                                        required
                                        style="border-radius: 10px;">

                                    <option value="">
                                        -- Chọn đề tài --
                                    </option>

                                    <c:forEach var="topic"
                                               items="${openTopics}">

                                        <option value="${topic.id}">

                                            ${topic.title}

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>


                            <div class="col-md-3">

                                <button type="submit"
                                        class="btn btn-primary w-100 fw-semibold"
                                        style="border-radius: 10px; min-height: 40px;">

                                    + Thêm đề tài

                                </button>

                            </div>

                        </div>

                    </form>

                </div>

            </c:if>


            <!-- TOPICS TABLE -->

            <div class="table-responsive">

                <table class="table table-hover align-middle mb-0">

                    <thead class="bg-light">

                    <tr>

                        <th class="py-3 px-4"
                            style="width: 70px;">

                            ID

                        </th>

                        <th class="py-3 px-4">

                            Tên đề tài

                        </th>

                        <th class="py-3 px-4">

                            Trạng thái đề tài

                        </th>

                        <th class="py-3 px-4">

                            Kết quả

                        </th>

                        <th class="py-3 px-4 text-center">

                            Điểm cuối

                        </th>

                        <th class="py-3 px-4 text-center">

                            Thao tác

                        </th>

                    </tr>

                    </thead>


                    <tbody>


                    <c:forEach var="councilTopic"
                               items="${topics}">

                        <tr>


                            <!-- ID -->

                            <td class="py-3 px-4 text-secondary fw-semibold">

                                #${councilTopic.id}

                            </td>


                            <!-- TITLE -->

                            <td class="py-3 px-4">

                                <div class="fw-semibold text-dark">

                                    ${councilTopic.topic.title}

                                </div>

                            </td>


                            <!-- TOPIC STATUS -->

                            <td class="py-3 px-4">

                                <c:choose>

                                    <c:when test="${councilTopic.topic.status == 'OPEN'}">

                                        <span class="badge bg-success px-3 py-2">

                                            OPEN

                                        </span>

                                    </c:when>


                                    <c:otherwise>

                                        <span class="badge bg-secondary px-3 py-2">

                                            ${councilTopic.topic.status}

                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </td>


                            <!-- RESULT STATUS -->

                            <td class="py-3 px-4">

                                <c:choose>

                                    <c:when test="${councilTopic.resultStatus == 'DRAFT'}">

                                        <span class="badge bg-secondary px-3 py-2">

                                            Chưa đủ điểm

                                        </span>

                                    </c:when>


                                    <c:when test="${councilTopic.resultStatus == 'READY'}">

                                        <span class="badge bg-warning text-dark px-3 py-2">

                                            Sẵn sàng công bố

                                        </span>

                                    </c:when>


                                    <c:when test="${councilTopic.resultStatus == 'PUBLISHED'}">

                                        <span class="badge bg-success px-3 py-2">

                                            Đã công bố

                                        </span>

                                    </c:when>


                                    <c:otherwise>

                                        <span class="badge bg-light text-dark px-3 py-2">

                                            ${councilTopic.resultStatus}

                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </td>


                            <!-- FINAL SCORE -->

                            <td class="py-3 px-4 text-center">

                                <c:choose>

                                    <c:when test="${not empty councilTopic.finalScore}">

                                        <strong class="fs-5">

                                            ${councilTopic.finalScore}

                                        </strong>

                                        <span class="text-muted">

                                            / 10

                                        </span>

                                    </c:when>


                                    <c:otherwise>

                                        <span class="text-muted">

                                            Chưa có

                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </td>


                            <!-- ACTION -->

                            <td class="py-3 px-4 text-center">

                                <div class="d-flex flex-wrap justify-content-center gap-2">


                                    <!-- DELETE TOPIC -->

                                    <c:if test="${council.status == 'DRAFT'}">

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/admin/councils/topics/delete/${councilTopic.id}"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa đề tài này khỏi hội đồng?');"
                                              class="m-0">

                                            <input type="hidden"
                                                   name="councilId"
                                                   value="${council.id}">

                                            <button type="submit"
                                                    class="btn btn-sm btn-outline-danger px-3 fw-semibold"
                                                    style="border-radius: 8px;">

                                                Xóa

                                            </button>

                                        </form>

                                    </c:if>


                                    <!-- PUBLISH -->

                                    <c:if test="${councilTopic.resultStatus == 'READY'}">

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/admin/evaluations/publish/${councilTopic.id}"
                                              onsubmit="return confirm('Bạn có chắc chắn muốn công bố kết quả của đề tài này?');"
                                              class="m-0">

                                            <button type="submit"
                                                    class="btn btn-sm btn-success px-3 fw-semibold"
                                                    style="border-radius: 8px;">

                                                📢 Công bố

                                            </button>

                                        </form>

                                    </c:if>


                                    <!-- PUBLISHED -->

                                    <c:if test="${councilTopic.resultStatus == 'PUBLISHED'}">

                                        <span class="badge bg-success px-3 py-2">

                                            ✓ Đã công bố

                                        </span>

                                    </c:if>

                                </div>

                            </td>

                        </tr>

                    </c:forEach>


                    <!-- EMPTY -->

                    <c:if test="${empty topics}">

                        <tr>

                            <td colspan="6"
                                class="text-center py-5 text-muted">

                                Chưa có đề tài nào.

                            </td>

                        </tr>

                    </c:if>


                    </tbody>

                </table>

            </div>

        </div>

    </div>


    <!-- ========================= -->
    <!-- COUNCIL STATUS -->
    <!-- ========================= -->

    <div class="card border-0 shadow-sm mb-5"
         style="border-radius: 16px;">

        <div class="card-body p-4">

            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">


                <div>

                    <h5 class="fw-bold text-dark mb-1">

                        Quản lý trạng thái

                    </h5>

                    <p class="text-muted mb-0">

                        Thay đổi trạng thái của hội đồng theo quy trình.

                    </p>

                </div>


                <div class="d-flex flex-wrap align-items-center gap-2">


                    <!-- ACTIVATE -->

                    <c:if test="${council.status == 'DRAFT'}">

                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/councils/activate/${council.id}"
                              onsubmit="return confirm('Bạn có chắc chắn muốn kích hoạt hội đồng này?');"
                              class="m-0">

                            <button type="submit"
                                    class="btn btn-success px-4 py-2 fw-semibold"
                                    style="border-radius: 10px;">

                                Kích hoạt hội đồng

                            </button>

                        </form>

                    </c:if>


                    <!-- COMPLETE -->

                    <c:if test="${council.status == 'ACTIVE'}">

                        <form method="post"
                              action="${pageContext.request.contextPath}/admin/councils/complete/${council.id}"
                              onsubmit="return confirm('Bạn có chắc chắn muốn hoàn thành hội đồng này?');"
                              class="m-0">

                            <button type="submit"
                                    class="btn btn-primary px-4 py-2 fw-semibold"
                                    style="border-radius: 10px;">

                                Hoàn thành hội đồng

                            </button>

                        </form>

                    </c:if>


                    <!-- COMPLETED -->

                    <c:if test="${council.status == 'COMPLETED'}">

                        <span class="badge bg-primary px-4 py-3">

                            Hội đồng đã hoàn thành

                        </span>

                    </c:if>

                </div>

            </div>

        </div>

    </div>


</div>

</div>

<%@ include file="../../common/footer.jsp" %>
