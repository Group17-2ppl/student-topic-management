<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>

<html lang="vi">

<head>

  <meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Quản lý đề tài sinh viên</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<style>
:root{
    --primary:#4f46e5;
    --primary-dark:#4338ca;
    --primary-soft:#eef2ff;
    --dark:#111827;
    --text:#1f2937;
    --muted:#64748b;
    --background:#f5f7fb;
    --surface:#ffffff;
    --border:#e5e7eb;
    --shadow:0 10px 30px rgba(15,23,42,.07);
}
*{box-sizing:border-box}
html,body{min-height:100%;margin:0}
body{
    min-height:100vh;
    display:flex;
    flex-direction:column;
    background:
      radial-gradient(circle at 0 0, rgba(79,70,229,.08), transparent 28%),
      radial-gradient(circle at 100% 0, rgba(14,165,233,.06), transparent 25%),
      var(--background);
    color:var(--text);
    font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Arial,sans-serif;
    line-height:1.5;
}
a{transition:all .2s ease}
.main-navbar{
    width:100%;
    flex:0 0 auto;
    padding:10px 0;
    background:linear-gradient(135deg,#111827 0%,#312e81 55%,#4f46e5 100%);
    box-shadow:0 8px 24px rgba(15,23,42,.14);
    position:relative;
    z-index:1000;
}
.brand{display:flex;align-items:center;gap:10px;color:#fff!important;text-decoration:none;font-size:18px;font-weight:750;letter-spacing:-.2px}
.brand-icon{width:40px;height:40px;display:inline-flex;align-items:center;justify-content:center;border-radius:12px;background:rgba(255,255,255,.14);box-shadow:inset 0 1px 0 rgba(255,255,255,.12);font-size:18px}
.main-navbar .navbar-nav{align-items:center;gap:3px}
.main-navbar .nav-link{color:rgba(255,255,255,.84)!important;padding:9px 12px!important;border-radius:10px;font-size:13.5px;font-weight:550}
.main-navbar .nav-link:hover,.main-navbar .nav-link.active{color:#fff!important;background:rgba(255,255,255,.12);transform:translateY(-1px)}
.user-area{display:flex;align-items:center;gap:8px}
.user-name{display:flex;align-items:center;gap:8px;max-width:210px;padding:7px 11px;border:1px solid rgba(255,255,255,.12);border-radius:10px;background:rgba(255,255,255,.08);color:#fff;font-size:13px;font-weight:550}
.user-name>span:last-child{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.user-icon{width:28px;height:28px;display:inline-flex;align-items:center;justify-content:center;flex:0 0 28px;border-radius:50%;background:rgba(255,255,255,.14);font-size:13px}
.logout-btn{padding:8px 13px;border:1px solid rgba(255,255,255,.22);border-radius:10px;background:rgba(255,255,255,.05);color:#fff;font-size:13px;font-weight:600;transition:all .2s ease}
.logout-btn:hover{background:#fff;color:#111827;transform:translateY(-1px)}
.login-btn{border:1px solid rgba(255,255,255,.24);border-radius:10px!important}
.register-btn{background:#0284c7!important;color:#fff!important;border-radius:10px!important;font-weight:700!important}
.register-btn:hover{background:#0369a1!important}
.main-content{flex:1 0 auto;width:100%;display:flex;flex-direction:column}
.content-container{width:100%;flex:1 0 auto;padding-top:30px;padding-bottom:44px}
.container>.card,.card{border:1px solid rgba(226,232,240,.9);box-shadow:var(--shadow);border-radius:16px}
.btn{border-radius:10px;font-weight:600;transition:transform .2s ease,box-shadow .2s ease,background .2s ease}
.btn:hover{transform:translateY(-1px)}
.btn-primary{background:var(--primary);border-color:var(--primary)}
.btn-primary:hover{background:var(--primary-dark);border-color:var(--primary-dark);box-shadow:0 8px 18px rgba(79,70,229,.2)}
.form-control,.form-select{border-color:#dbe1ea;border-radius:10px;min-height:44px}
.form-control:focus,.form-select:focus{border-color:#818cf8;box-shadow:0 0 0 4px rgba(99,102,241,.11)}
.alert{border:0;border-radius:12px;box-shadow:0 6px 18px rgba(15,23,42,.05)}
.table-shell{background:var(--surface);border:1px solid var(--border);border-radius:16px;box-shadow:var(--shadow);overflow:hidden}
.table{margin-bottom:0;background:#fff}
.table thead th{padding:14px 16px;border-bottom:1px solid var(--border);background:#f8fafc;color:#64748b;font-size:12px;font-weight:750;text-transform:uppercase;letter-spacing:.04em;white-space:nowrap}
.table tbody td{padding:14px 16px;border-color:#eef2f7;color:#475569;vertical-align:middle}
.table tbody tr{transition:background .15s ease}
.table tbody tr:hover{background:#f8faff}
.table-responsive{border-radius:16px}
.pagination-wrap{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:14px 16px;background:#fff;border-top:1px solid var(--border)}
.pagination-info{color:#64748b;font-size:12px;font-weight:550}
.pagination-nav{display:flex;align-items:center;gap:5px;flex-wrap:wrap;justify-content:flex-end}
.pagination-nav button{min-width:34px;height:34px;padding:0 9px;border:1px solid #e2e8f0;border-radius:9px;background:#fff;color:#475569;font-size:13px;font-weight:650}
.pagination-nav button:hover:not(:disabled){background:#f1f5f9;border-color:#cbd5e1}
.pagination-nav button.active{background:var(--primary);border-color:var(--primary);color:#fff}
.pagination-nav button:disabled{opacity:.45;cursor:not-allowed}
.empty-state{padding:48px 20px;text-align:center;color:#94a3b8}
.site-footer{margin-top:auto}
@media(max-width:991px){
  .main-navbar .navbar-collapse{padding:12px 0 8px}
  .main-navbar .navbar-nav{align-items:stretch}
  .user-area{flex-direction:column;align-items:stretch;margin-top:10px;padding-top:10px;border-top:1px solid rgba(255,255,255,.1)}
  .user-name{justify-content:center;max-width:none}
  .logout-btn{width:100%}
}
@media(max-width:767px){
  .content-container{padding-top:22px;padding-bottom:32px}
  .pagination-wrap{align-items:flex-start;flex-direction:column}
  .pagination-nav{justify-content:flex-start}
}
</style>
  
</head>

<body>

<nav class="navbar navbar-expand-lg main-navbar">

  <div class="container">

    <sec:authorize access="hasAuthority('ADMIN')">

        <a class="brand"
           href="${pageContext.request.contextPath}/admin/registration-rounds">

            <span class="brand-icon">
                📚
            </span>

            <span>
                Quản lý đề tài
            </span>

        </a>

    </sec:authorize>

    <sec:authorize access="hasAnyAuthority('LECTURER', 'STUDENT')">

        <a class="brand"
           href="${pageContext.request.contextPath}/topics">

            <span class="brand-icon">
                📚
            </span>

            <span>
                Quản lý đề tài
            </span>

        </a>

    </sec:authorize>

    <sec:authorize access="isAnonymous()">

        <a class="brand"
           href="${pageContext.request.contextPath}/">

            <span class="brand-icon">
                📚
            </span>

            <span>
                Quản lý đề tài
            </span>

        </a>

    </sec:authorize>

    <button class="navbar-toggler text-white border-0 shadow-none"
            type="button"
            data-bs-toggle="collapse"
            data-bs-target="#navbarContent"
            aria-controls="navbarContent"
            aria-expanded="false"
            aria-label="Mở menu">

        <span class="navbar-toggler-icon"
              style="filter: invert(1);">
        </span>

    </button>

    <div class="collapse navbar-collapse"
         id="navbarContent">

        <ul class="navbar-nav me-auto ms-lg-3 mb-2 mb-lg-0">

            <sec:authorize access="hasAuthority('ADMIN')">

                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/admin/registration-rounds">

                        📅 Đợt đăng ký

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/admin/topics/pending">

                        📚 Duyệt & công bố đề tài

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/registrations/pending">

                        🎓 Duyệt đăng ký SV

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/admin/assignments">

                        ⚙️ Phân công

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/admin/councils">

                        🏛️ Hội đồng

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/admin/users">

                        👥 Người dùng

                    </a>

                </li>

            </sec:authorize>

            <sec:authorize access="hasAuthority('LECTURER')">

                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/topics">

                        📋 Đề tài

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/topics/create">

                        ➕ Đề xuất đề tài

                    </a>

                </li>


                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/lecturer/registrations">

                        📝 Đăng ký hướng dẫn

                    </a>

                </li>

                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/lecturer/submissions">

                        📄 Bài nộp sinh viên

                    </a>

                </li>

                <li class="nav-item">

                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/lecturer/evaluations">

                        🧮 Chấm điểm

                    </a>

                </li>

            </sec:authorize>

            <sec:authorize access="hasAuthority('STUDENT')">

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/topics">
                        📋 Đề tài
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/student/my-topic">

                        📌 Đề tài của tôi

                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/student/group">
                        👥 Nhóm của tôi
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/registrations">
                        📌 Đề tài nhóm tôi
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link"
                       href="${pageContext.request.contextPath}/student/results">

                        📊 Kết quả

                    </a>
                </li>

            </sec:authorize>

        </ul>

        <div class="user-area">

            <sec:authorize access="isAuthenticated()">

                <div class="user-name">

                    <span class="user-icon">
                        👤
                    </span>

                    <span>
                        ${pageContext.request.userPrincipal.name}
                    </span>

                </div>


                <form action="${pageContext.request.contextPath}/logout"
                      method="post"
                      class="m-0">

                    <button type="submit"
                            class="logout-btn w-100">

                        Đăng xuất

                    </button>

                </form>

            </sec:authorize>


            <!-- ANONYMOUS -->

            <sec:authorize access="isAnonymous()">

                <a class="nav-link login-btn text-center"
                   href="${pageContext.request.contextPath}/login">

                    Đăng nhập

                </a>


                <a class="nav-link register-btn text-center"
                   href="${pageContext.request.contextPath}/register">

                    Đăng ký

                </a>

            </sec:authorize>

        </div>

    </div>

</div>
  
</nav>

<main class="main-content">

  <div class="container content-container">