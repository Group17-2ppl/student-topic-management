<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

</div>
</main>

<footer class="site-footer">
    <div class="container py-4">
        <div class="row gy-3 align-items-center">
            <div class="col-md-7">
                <div class="footer-title">📚 Quản lý đề tài sinh viên</div>
                <p class="footer-description">Hệ thống hỗ trợ quản lý, đăng ký và theo dõi đề tài sinh viên.</p>
            </div>
            <div class="col-md-5 text-md-end">
                <div class="footer-section-title">Liên kết nhanh</div>
                <div class="footer-links justify-content-md-end">
                    <a href="${pageContext.request.contextPath}/topics">Đề tài</a>
                    <a href="${pageContext.request.contextPath}/registrations">Đăng ký đề tài</a>
                </div>
            </div>
        </div>
        <hr class="footer-divider">
        <div class="footer-bottom">
            <span>© 2026 Quản lý đề tài sinh viên</span>
            <span>Spring Boot · JSP · MySQL</span>
        </div>
    </div>
</footer>

<style>
.site-footer{width:100%;flex:0 0 auto;background:linear-gradient(135deg,#0f172a,#1e1b4b);color:#fff}
.footer-title{font-size:16px;font-weight:750;margin-bottom:5px}.footer-description{margin:0;color:#94a3b8;font-size:12.5px}
.footer-section-title{margin-bottom:8px;font-size:13px;font-weight:700}.footer-links{display:flex;gap:18px;flex-wrap:wrap}.footer-links a{color:#a5b4fc;text-decoration:none;font-size:12.5px}.footer-links a:hover{color:#fff}
.footer-divider{margin:18px 0 12px;border:0;border-top:1px solid rgba(255,255,255,.1)}.footer-bottom{display:flex;justify-content:space-between;gap:12px;color:#64748b;font-size:11.5px}
@media(max-width:767px){.footer-bottom{flex-direction:column;gap:4px}.footer-links{justify-content:flex-start}}
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function () {
    'use strict';
    const PAGE_SIZE = 10;

    function setupPagination(table) {
        if (!table || table.dataset.paginationReady === 'true' || table.classList.contains('no-pagination')) return;
        const tbody = table.tBodies && table.tBodies[0];
        if (!tbody) return;
        const rows = Array.from(tbody.rows);
        if (rows.length <= PAGE_SIZE) return;

        table.dataset.paginationReady = 'true';
        const wrapper = table.closest('.table-responsive') || table.parentElement;
        const card = wrapper.closest('.card, .table-shell') || wrapper.parentElement;
        const pager = document.createElement('div');
        pager.className = 'pagination-wrap';
        const info = document.createElement('div');
        info.className = 'pagination-info';
        const nav = document.createElement('div');
        nav.className = 'pagination-nav';
        pager.appendChild(info);
        pager.appendChild(nav);

        (card || wrapper).appendChild(pager);

        let page = 1;
        const totalPages = Math.ceil(rows.length / PAGE_SIZE);

        function render() {
            const start = (page - 1) * PAGE_SIZE;
            const end = Math.min(start + PAGE_SIZE, rows.length);
            rows.forEach((row, index) => row.style.display = index >= start && index < end ? '' : 'none');
            info.textContent = 'Hiển thị ' + (start + 1) + '–' + end + ' / ' + rows.length + ' dòng';
            nav.innerHTML = '';

            const prev = document.createElement('button');
            prev.type = 'button'; prev.textContent = '‹'; prev.title = 'Trang trước'; prev.disabled = page === 1;
            prev.addEventListener('click', () => { if (page > 1) { page--; render(); } });
            nav.appendChild(prev);

            const maxButtons = 5;
            let from = Math.max(1, page - 2), to = Math.min(totalPages, from + maxButtons - 1);
            from = Math.max(1, to - maxButtons + 1);
            for (let i = from; i <= to; i++) {
                const btn = document.createElement('button');
                btn.type = 'button'; btn.textContent = i;
                if (i === page) btn.classList.add('active');
                btn.addEventListener('click', () => { page = i; render(); });
                nav.appendChild(btn);
            }

            const next = document.createElement('button');
            next.type = 'button'; next.textContent = '›'; next.title = 'Trang sau'; next.disabled = page === totalPages;
            next.addEventListener('click', () => { if (page < totalPages) { page++; render(); } });
            nav.appendChild(next);
        }
        render();
    }

    function init() {
        document.querySelectorAll('table').forEach(setupPagination);
    }

    if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
    else init();
})();
</script>

</body>
</html>