<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<div class="row justify-content-center">
    <div class="col-lg-12">

        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 mb-4">
            <h2 class="h3 fw-bold text-dark mb-0">
                Quản lý sinh viên
            </h2>

            <a href="${pageContext.request.contextPath}/admin/students/create"
               class="btn btn-primary px-4 py-2 fw-semibold shadow-sm"
               style="border-radius: 10px; min-height: 42px; display: inline-flex; align-items: center;">
                + Thêm sinh viên mới
            </a>
        </div>

        <div class="card border-0 shadow-sm" style="border-radius: 16px; overflow: hidden;">
            <div class="card-body p-0">

                <div class="table-responsive m-0">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light text-uppercase fs-7 text-secondary tracking-wider">
                            <tr>
                                <th class="py-3 px-4 border-bottom-0" style="width: 80px;">ID</th>
                                <th class="py-3 px-4 border-bottom-0">Mã sinh viên</th>
                                <th class="py-3 px-4 border-bottom-0">Họ tên</th>
                                <th class="py-3 px-4 border-bottom-0">Lớp</th>
                                <th class="py-3 px-4 border-bottom-0">Ngành</th>
                                <th class="py-3 px-4 border-bottom-0 text-center" style="width: 180px;">Thao tác</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="student" items="${students}">
                                <tr>
                                    <td class="py-3 px-4 fw-semibold text-secondary">
                                        #${student.id}
                                    </td>

                                    <td class="py-3 px-4 fw-medium text-dark">
                                        ${student.studentCode}
                                    </td>

                                    <td class="py-3 px-4 text-muted">
                                        ${student.user.fullName}
                                    </td>

                                    <td class="py-3 px-4 text-muted">
                                        ${student.className}
                                    </td>

                                    <td class="py-3 px-4 text-muted">
                                        ${student.major}
                                    </td>

                                    <td class="py-3 px-4 text-center">
                                        <div class="d-flex justify-content-center gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/students/edit/${student.id}"
                                               class="btn btn-sm btn-outline-warning px-3 fw-semibold"
                                               style="border-radius: 8px; display: inline-flex; align-items: center;">
                                                Sửa
                                            </a>

                                            <a href="${pageContext.request.contextPath}/admin/students/delete/${student.id}"
                                               class="btn btn-sm btn-outline-danger px-3 fw-semibold"
                                               style="border-radius: 8px; display: inline-flex; align-items: center;"
                                               onclick="return confirm('Bạn có chắc chắn muốn xóa sinh viên này?')">
                                                Xóa
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>

    </div>
</div>

<%@ include file="../../common/footer.jsp" %>