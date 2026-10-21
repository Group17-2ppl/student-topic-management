<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="../../common/header.jsp" %>

<style>
/* ===== Lecturer evaluation detail ===== */
.evaluation-page,
.evaluation-page *{box-sizing:border-box}
.evaluation-page{max-width:1180px!important;margin:0 auto!important;padding:30px 20px 48px!important;color:#1f2937!important;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif!important}
.evaluation-page .evaluation-hero{display:flex!important;justify-content:space-between!important;align-items:center!important;gap:20px!important;margin:0 0 24px!important;padding:28px 30px!important;border-radius:22px!important;background:linear-gradient(135deg,#111827 0%,#312e81 58%,#4f46e5 100%)!important;color:#fff!important;box-shadow:0 18px 45px rgba(15,23,42,.16)!important}
.evaluation-page .evaluation-eyebrow{margin:0 0 7px!important;font-size:11px!important;font-weight:800!important;letter-spacing:.16em!important;color:rgba(255,255,255,.68)!important}
.evaluation-page .evaluation-title{margin:0 0 7px!important;font-size:30px!important;line-height:1.15!important;font-weight:800!important;letter-spacing:-.03em!important;color:#fff!important}
.evaluation-page .evaluation-subtitle{margin:0!important;font-size:14px!important;color:rgba(255,255,255,.76)!important}
.evaluation-page .back-btn{display:inline-flex!important;align-items:center!important;justify-content:center!important;padding:10px 16px!important;border:1px solid rgba(255,255,255,.25)!important;border-radius:11px!important;background:rgba(255,255,255,.10)!important;color:#fff!important;text-decoration:none!important;font-size:13px!important;font-weight:700!important;white-space:nowrap!important}
.evaluation-page .back-btn:hover{background:rgba(255,255,255,.18)!important;color:#fff!important;transform:translateY(-1px)!important}
.evaluation-page .flash{margin:0 0 18px!important;padding:13px 16px!important;border-radius:12px!important;font-size:13px!important}
.evaluation-page .flash-success{background:#ecfdf5!important;color:#047857!important;border:1px solid #a7f3d0!important}
.evaluation-page .flash-error{background:#fef2f2!important;color:#b91c1c!important;border:1px solid #fecaca!important}
.evaluation-page .evaluation-grid{display:grid!important;grid-template-columns:minmax(0,1.35fr) minmax(320px,.85fr)!important;gap:22px!important;align-items:start!important}
.evaluation-page .evaluation-card{overflow:hidden!important;background:#fff!important;border:1px solid #e5e7eb!important;border-radius:18px!important;box-shadow:0 10px 30px rgba(15,23,42,.07)!important}
.evaluation-page .evaluation-card+.evaluation-card{margin-top:22px!important}
.evaluation-page .card-head{display:flex!important;align-items:center!important;justify-content:space-between!important;gap:12px!important;padding:18px 21px!important;border-bottom:1px solid #eef2f7!important;background:#fff!important}
.evaluation-page .card-head h3{margin:0!important;font-size:16px!important;font-weight:800!important;color:#111827!important}
.evaluation-page .card-body{padding:22px!important}
.evaluation-page .topic-label{margin-bottom:7px!important;font-size:11px!important;font-weight:800!important;letter-spacing:.10em!important;color:#94a3b8!important}
.evaluation-page .topic-title{margin:0 0 6px!important;font-size:24px!important;line-height:1.3!important;font-weight:800!important;color:#111827!important}
.evaluation-page .topic-council{font-size:14px!important;color:#64748b!important}
.evaluation-page .info-row{display:grid!important;grid-template-columns:1fr 1fr!important;gap:16px!important;margin-top:20px!important;padding-top:20px!important;border-top:1px solid #eef2f7!important}
.evaluation-page .info-label{margin-bottom:7px!important;font-size:12px!important;font-weight:700!important;color:#94a3b8!important}
.evaluation-page .role-chip{display:inline-flex!important;align-items:center!important;padding:7px 12px!important;border-radius:999px!important;background:#eef2ff!important;color:#4338ca!important;font-size:12px!important;font-weight:800!important}
.evaluation-page .final-score{font-size:24px!important;font-weight:850!important;color:#4f46e5!important}
.evaluation-page .status-badge{display:inline-flex!important;align-items:center!important;padding:7px 11px!important;border-radius:999px!important;font-size:11px!important;font-weight:800!important;white-space:nowrap!important}
.evaluation-page .status-draft{background:#f1f5f9!important;color:#475569!important}
.evaluation-page .status-ready{background:#fef3c7!important;color:#92400e!important}
.evaluation-page .status-published{background:#dcfce7!important;color:#166534!important}
.evaluation-page .field{margin-bottom:19px!important}
.evaluation-page .field:last-child{margin-bottom:0!important}
.evaluation-page .field-label{display:block!important;margin:0 0 8px!important;font-size:13px!important;font-weight:750!important;color:#334155!important}
.evaluation-page .required{color:#dc2626!important}
.evaluation-page .score-input-wrap{display:flex!important;align-items:stretch!important}
.evaluation-page .score-input{width:100%!important;min-height:50px!important;padding:11px 14px!important;border:1px solid #dbe1ea!important;border-right:0!important;border-radius:11px 0 0 11px!important;outline:none!important;background:#fff!important;font-size:17px!important;font-weight:650!important;color:#111827!important}
.evaluation-page .score-input:focus{border-color:#818cf8!important;box-shadow:0 0 0 4px rgba(99,102,241,.11)!important}
.evaluation-page .score-unit{display:flex!important;align-items:center!important;padding:0 15px!important;border:1px solid #dbe1ea!important;border-radius:0 11px 11px 0!important;background:#f8fafc!important;color:#64748b!important;font-size:13px!important;font-weight:700!important}
.evaluation-page .field-help{margin-top:7px!important;font-size:11px!important;color:#94a3b8!important}
.evaluation-page .comment-input{display:block!important;width:100%!important;min-height:145px!important;padding:12px 14px!important;border:1px solid #dbe1ea!important;border-radius:11px!important;outline:none!important;resize:vertical!important;font:inherit!important;font-size:13px!important;color:#334155!important;background:#fff!important}
.evaluation-page .comment-input:focus{border-color:#818cf8!important;box-shadow:0 0 0 4px rgba(99,102,241,.11)!important}
.evaluation-page .save-btn{display:inline-flex!important;align-items:center!important;justify-content:center!important;padding:11px 18px!important;border:0!important;border-radius:11px!important;background:#4f46e5!important;color:#fff!important;font-size:13px!important;font-weight:750!important;cursor:pointer!important;box-shadow:0 7px 16px rgba(79,70,229,.20)!important}
.evaluation-page .save-btn:hover{background:#4338ca!important;transform:translateY(-1px)!important}
.evaluation-page .empty-review{padding:36px 15px!important;text-align:center!important;color:#94a3b8!important;font-size:13px!important}
.evaluation-page .review-item{padding:15px!important;margin-bottom:12px!important;border:1px solid #e5e7eb!important;border-radius:14px!important;background:#fff!important}
.evaluation-page .review-item:last-child{margin-bottom:0!important}
.evaluation-page .review-top{display:flex!important;justify-content:space-between!important;align-items:flex-start!important;gap:12px!important}
.evaluation-page .review-name{font-size:13px!important;font-weight:750!important;color:#1f2937!important}
.evaluation-page .review-role{margin-top:3px!important;font-size:11px!important;color:#94a3b8!important}
.evaluation-page .review-score{font-size:16px!important;font-weight:850!important;color:#4f46e5!important;white-space:nowrap!important}
.evaluation-page .review-comment{margin-top:10px!important;padding:10px 12px!important;border-radius:10px!important;background:#f8fafc!important;color:#475569!important;font-size:12px!important;line-height:1.6!important}
@media(max-width:900px){.evaluation-page .evaluation-grid{grid-template-columns:1fr!important}}
@media(max-width:600px){.evaluation-page{padding:20px 14px 34px!important}.evaluation-page .evaluation-hero{padding:21px!important;align-items:flex-start!important;flex-direction:column!important}.evaluation-page .evaluation-title{font-size:25px!important}.evaluation-page .back-btn{width:100%!important}.evaluation-page .card-body{padding:17px!important}.evaluation-page .info-row{grid-template-columns:1fr!important}.evaluation-page .topic-title{font-size:21px!important}}
</style>

<div class="evaluation-page">
    <section class="evaluation-hero">
        <div>
            <div class="evaluation-eyebrow">PHẢN BIỆN</div>
            <h1 class="evaluation-title">Đánh giá đề tài</h1>
            <p class="evaluation-subtitle">Nhập điểm và nhận xét của bạn cho đề tài được phân công.</p>
        </div>
        <a class="back-btn" href="${pageContext.request.contextPath}/lecturer/evaluations">← Danh sách</a>
    </section>

    <c:if test="${not empty success}"><div class="flash flash-success">${success}</div></c:if>
    <c:if test="${not empty error}"><div class="flash flash-error">${error}</div></c:if>

    <div class="evaluation-grid">
        <div>
            <section class="evaluation-card">
                <div class="card-body">
                    <div class="topic-label">ĐỀ TÀI</div>
                    <h2 class="topic-title">${councilTopic.topic.title}</h2>
                    <div class="topic-council">Hội đồng: ${councilTopic.council.name}</div>

                    <div style="margin-top:14px!important">
                        <c:choose>
                            <c:when test="${councilTopic.resultStatus == 'PUBLISHED'}"><span class="status-badge status-published">Đã công bố</span></c:when>
                            <c:when test="${councilTopic.resultStatus == 'READY'}"><span class="status-badge status-ready">Đã đủ điểm</span></c:when>
                            <c:otherwise><span class="status-badge status-draft">Chưa hoàn tất</span></c:otherwise>
                        </c:choose>
                    </div>

                    <div class="info-row">
                        <div>
                            <div class="info-label">Vai trò</div>
                            <span class="role-chip">
                                <c:choose>
                                    <c:when test="${member.role == 'PRESIDENT'}">Chủ tịch</c:when>
                                    <c:when test="${member.role == 'SECRETARY'}">Thư ký</c:when>
                                    <c:when test="${member.role == 'MEMBER'}">Thành viên</c:when>
                                    <c:otherwise>${member.role}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div>
                            <div class="info-label">Điểm cuối cùng</div>
                            <div class="final-score">${not empty councilTopic.finalScore ? councilTopic.finalScore : 'Chưa có'}</div>
                        </div>
                    </div>
                </div>
            </section>

            <c:if test="${councilTopic.resultStatus != 'PUBLISHED'}">
                <section class="evaluation-card">
                    <div class="card-head"><h3>Nhập đánh giá</h3></div>
                    <div class="card-body">
                        <form method="post" action="${pageContext.request.contextPath}/lecturer/evaluations/save">
                            <input type="hidden" name="councilTopicId" value="${councilTopic.id}">
                            <div class="field">
                                <label class="field-label" for="score">Điểm <span class="required">*</span></label>
                                <div class="score-input-wrap">
                                    <input id="score" class="score-input" type="number" name="score" min="0" max="10" step="0.01" value="${evaluation.score}" required>
                                    <span class="score-unit">/ 10</span>
                                </div>
                                <div class="field-help">Nhập điểm từ 0 đến 10, tối đa 2 chữ số thập phân.</div>
                            </div>
                            <div class="field">
                                <label class="field-label" for="comment">Nhận xét</label>
                                <textarea id="comment" class="comment-input" name="comment" maxlength="2000" placeholder="Nhập nhận xét về đề tài...">${evaluation.comment}</textarea>
                            </div>
                            <button class="save-btn" type="submit">Lưu đánh giá</button>
                        </form>
                    </div>
                </section>
            </c:if>
        </div>

        <section class="evaluation-card">
            <div class="card-head"><h3>Đánh giá của hội đồng</h3></div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${empty evaluations}">
                        <div class="empty-review">Chưa có thành viên nào nhập điểm.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${evaluations}">
                            <div class="review-item">
                                <div class="review-top">
                                    <div>
                                        <div class="review-name">${item.councilMember.lecturer.user.fullName}</div>
                                        <div class="review-role">${item.councilMember.role}</div>
                                    </div>
                                    <div class="review-score">${item.score}/10</div>
                                </div>
                                <div class="review-comment">${empty item.comment ? 'Không có nhận xét.' : item.comment}</div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>
</div>

<%@ include file="../../common/footer.jsp" %>