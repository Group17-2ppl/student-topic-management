<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<style>
.evaluations-page{max-width:1180px;margin:0 auto}
.evaluations-hero{background:linear-gradient(135deg,#111827,#312e81 55%,#4f46e5);color:#fff;border-radius:20px;padding:28px 30px;box-shadow:0 16px 38px rgba(15,23,42,.14);margin-bottom:24px}
.evaluations-hero .eyebrow{font-size:11px;font-weight:800;letter-spacing:.12em;opacity:.72;margin-bottom:7px}
.evaluations-hero h2{margin:0 0 6px;font-weight:800;letter-spacing:-.025em}
.evaluations-hero p{margin:0;color:rgba(255,255,255,.72)}
.evaluation-count{display:inline-flex;align-items:center;gap:7px;padding:9px 13px;border:1px solid rgba(255,255,255,.18);border-radius:12px;background:rgba(255,255,255,.1);font-weight:700}
.evaluations-card{background:#fff;border:1px solid #e5e7eb;border-radius:18px;box-shadow:0 10px 30px rgba(15,23,42,.07);overflow:hidden}
.evaluations-table thead th{background:#f8fafc;color:#64748b;border-bottom:1px solid #e5e7eb;font-size:11px;text-transform:uppercase;letter-spacing:.05em;padding:14px 16px}
.evaluations-table tbody td{padding:16px;border-color:#eef2f7}
.evaluations-table tbody tr:hover{background:#f8faff}
.topic-name{font-weight:750;color:#111827;line-height:1.4}
.council-name{color:#475569;font-size:13px}
.empty-evaluations{padding:68px 24px;text-align:center}
.empty-icon{width:64px;height:64px;margin:0 auto 16px;border-radius:18px;display:flex;align-items:center;justify-content:center;background:#eef2ff;font-size:28px}
.empty-evaluations h5{font-weight:800;color:#1e293b;margin-bottom:7px}
.empty-evaluations p{max-width:560px;margin:0 auto;color:#64748b}
.evaluations-page .status-badge{display:inline-flex;align-items:center;padding:7px 10px;border-radius:999px;font-size:11px;font-weight:800}
.evaluations-page .status-draft{background:#f1f5f9;color:#475569}.evaluations-page .status-ready{background:#fef3c7;color:#92400e}.evaluations-page .status-published{background:#dcfce7;color:#166534}
@media(max-width:767px){.evaluations-hero{padding:21px}.evaluation-count{margin-top:8px}.evaluations-table{min-width:760px}.empty-evaluations{padding:50px 18px}}
</style>

<div class="container py-4 evaluations-page">
    <div class="evaluations-hero d-flex flex-wrap justify-content-between align-items-center gap-3">
        <div>
            <div class="eyebrow">PHẢN BIỆN & CHẤM ĐIỂM</div>
            <h2>Đánh giá đề tài</h2>
            <p>Các đề tài bạn được phân công phản biện và nhập điểm.</p>
        </div>
        <div class="evaluation-count">📋 ${topics.size()} đề tài</div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="evaluations-card">
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty topics}">
                    <div class="empty-evaluations">
                        <div class="empty-icon">📋</div>
                        <h5>Chưa có đề tài được phân công</h5>
                        <p>Khi hội đồng phân công đề tài cho bạn, danh sách sẽ xuất hiện tại đây.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table id="evaluationTable" class="table table-hover align-middle mb-0 evaluations-table">
                            <thead class="table-light">
                            <tr>
                                <th class="ps-4" style="width:60px">#</th>
                                <th>Đề tài</th>
                                <th>Hội đồng</th>
                                <th>Trạng thái</th>
                                <th>Điểm cuối</th>
                                <th class="text-end pe-4">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="ct" items="${topics}" varStatus="status">
                                <tr>
                                    <td class="ps-4 text-muted row-number">${status.index + 1}</td>
                                    <td>
                                        <div class="fw-semibold">${ct.topic.title}</div>
                                    </td>
                                    <td>${ct.council.name}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${ct.resultStatus == 'DRAFT'}"><span class="badge text-bg-secondary">Chưa hoàn tất</span></c:when>
                                            <c:when test="${ct.resultStatus == 'READY'}"><span class="badge text-bg-warning">Đã đủ điểm</span></c:when>
                                            <c:when test="${ct.resultStatus == 'PUBLISHED'}"><span class="badge text-bg-success">Đã công bố</span></c:when>
                                            <c:otherwise><span class="badge text-bg-light">${ct.resultStatus}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty ct.finalScore}"><strong>${ct.finalScore}</strong>/10</c:when>
                                            <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end pe-4">
                                        <a href="${pageContext.request.contextPath}/lecturer/evaluations/topic/${ct.id}" class="btn btn-primary btn-sm px-3">
                                            Chấm điểm
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div id="evaluationPagination" class="d-flex justify-content-between align-items-center px-4 py-3 border-top"></div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<script>
(function () {
    const table = document.getElementById('evaluationTable');
    const pagination = document.getElementById('evaluationPagination');
    if (!table || !pagination) return;

    const rows = Array.from(table.querySelectorAll('tbody tr'));
    const pageSize = 10;
    let page = 1;
    const totalPages = Math.max(1, Math.ceil(rows.length / pageSize));

    function render() {
        const start = (page - 1) * pageSize;
        rows.forEach((row, i) => row.style.display = i >= start && i < start + pageSize ? '' : 'none');
        pagination.innerHTML = '';
        const info = document.createElement('span');
        info.className = 'text-muted small';
        info.textContent = 'Trang ' + page + '/' + totalPages + ' · ' + rows.length + ' đề tài';
        const nav = document.createElement('div');
        nav.className = 'btn-group';
        const prev = document.createElement('button');
        prev.className = 'btn btn-outline-secondary btn-sm';
        prev.textContent = '‹ Trước';
        prev.disabled = page === 1;
        prev.onclick = () => { if (page > 1) { page--; render(); } };
        const next = document.createElement('button');
        next.className = 'btn btn-outline-secondary btn-sm';
        next.textContent = 'Sau ›';
        next.disabled = page === totalPages;
        next.onclick = () => { if (page < totalPages) { page++; render(); } };
        nav.append(prev, next);
        pagination.append(info, nav);
    }
    render();
})();
</script>

<%@ include file="../../common/footer.jsp" %>