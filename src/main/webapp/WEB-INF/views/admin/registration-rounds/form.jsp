<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="container mt-4">

<h2 class="mb-4">
    <c:choose>
        <c:when test="${registrationRound.id == null}">
            Tạo đợt đăng ký
        </c:when>
        <c:otherwise>
            Chỉnh sửa đợt đăng ký
        </c:otherwise>
    </c:choose>
</h2>

<form method="post">

    <div class="mb-3">
        <label class="form-label">
            Tên đợt đăng ký
        </label>

        <input type="text"
               name="name"
               class="form-control"
               value="${registrationRound.name}"
               required>
    </div>

    <div class="mb-3">
        <label class="form-label">
            Loại đợt đăng ký
        </label>

        <select name="type"
                id="type"
                class="form-select"
                required>

            <option value="">
                -- Chọn loại --
            </option>

            <option value="MON_HOC"
                    ${registrationRound.type == 'MON_HOC' ? 'selected' : ''}>
                Môn học
            </option>

            <option value="NCKH"
                    ${registrationRound.type == 'NCKH' ? 'selected' : ''}>
                Nghiên cứu khoa học
            </option>

            <option value="TLCN"
                    ${registrationRound.type == 'TLCN' ? 'selected' : ''}>
                Tiểu luận chuyên ngành
            </option>

            <option value="KLTN"
                    ${registrationRound.type == 'KLTN' ? 'selected' : ''}>
                Khóa luận tốt nghiệp
            </option>

        </select>
    </div>

    <div class="mb-3">
        <label class="form-label">
            Mô tả
        </label>

        <textarea name="description"
                  class="form-control"
                  rows="4">${registrationRound.description}</textarea>
    </div>

    <div class="row">

        <div class="col-md-6 mb-3">
            <label class="form-label">
                Bắt đầu nhận đề tài
            </label>

            <input type="datetime-local"
                   name="topicStartAt"
                   class="form-control"
                   value="${registrationRound.topicStartAt}"
                   required>
        </div>

        <div class="col-md-6 mb-3">
            <label class="form-label">
                Kết thúc nhận đề tài
            </label>

            <input type="datetime-local"
                   name="topicEndAt"
                   class="form-control"
                   value="${registrationRound.topicEndAt}"
                   required>
        </div>

    </div>

    <div class="row">

        <div class="col-md-6 mb-3">
            <label class="form-label">
                Bắt đầu đăng ký
            </label>

            <input type="datetime-local"
                   name="registrationStartAt"
                   class="form-control"
                   value="${registrationRound.registrationStartAt}"
                   required>
        </div>

        <div class="col-md-6 mb-3">
            <label class="form-label">
                Kết thúc đăng ký
            </label>

            <input type="datetime-local"
                   name="registrationEndAt"
                   class="form-control"
                   value="${registrationRound.registrationEndAt}"
                   required>
        </div>

    </div>

    <div id="gvpbField"
         class="mb-3"
         style="display:none;">

        <label class="form-label">
            Hạn GVPB chấm
        </label>

        <input type="datetime-local"
               name="gvpbDeadlineAt"
               id="gvpbDeadlineAt"
               class="form-control"
               value="${registrationRound.gvpbDeadlineAt}">

        <div class="form-text">
            Chỉ áp dụng cho TLCN và KLTN.
        </div>

    </div>

    <div id="councilField"
         class="mb-3"
         style="display:none;">

        <label class="form-label">
            Ngày hội đồng
        </label>

        <input type="datetime-local"
               name="councilDateAt"
               id="councilDateAt"
               class="form-control"
               value="${registrationRound.councilDateAt}">

        <div class="form-text">
            Chỉ áp dụng cho KLTN.
        </div>

    </div>

    <div class="mt-3">

        <button type="submit"
                class="btn btn-primary">
            Lưu
        </button>

        <a href="${pageContext.request.contextPath}/admin/registration-rounds"
           class="btn btn-secondary">
            Hủy
        </a>

    </div>

</form>

</div>

<script>

function updateSpecialFields() {

    const type = document.getElementById("type").value;

    const gvpbField =
        document.getElementById("gvpbField");

    const councilField =
        document.getElementById("councilField");

    const gvpbInput =
        document.getElementById("gvpbDeadlineAt");

    const councilInput =
        document.getElementById("councilDateAt");

    if (type === "TLCN" || type === "KLTN") {

        gvpbField.style.display = "block";
        gvpbInput.required = true;

    } else {

        gvpbField.style.display = "none";
        gvpbInput.required = false;
        gvpbInput.value = "";
    }

    if (type === "KLTN") {

        councilField.style.display = "block";
        councilInput.required = true;

    } else {

        councilField.style.display = "none";
        councilInput.required = false;
        councilInput.value = "";
    }
}

document.getElementById("type")
        .addEventListener("change", updateSpecialFields);

updateSpecialFields();

</script>

<%@ include file="../../common/footer.jsp" %>