<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Quản lý đề tài</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
            * {
                box-sizing: border-box;
            }

            body {
                min-height: 100vh;
                margin: 0;
                background: radial-gradient(circle at top left, #dbeafe, transparent 35%),
                            radial-gradient(circle at bottom right, #e0e7ff, transparent 35%),
                            #f3f6fb;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 30px 15px;
            }

            .login-wrapper {
                width: 100%;
                max-width: 430px;
            }

            .login-card {
                background: #ffffff;
                border: 0;
                border-radius: 20px;
                box-shadow: 0 20px 50px rgba(15, 23, 42, 0.12);
                overflow: hidden;
            }

            .login-header {
                padding: 34px 40px 26px;
                text-align: center;
                background: linear-gradient(135deg, #111827, #1e3a8a);
                color: #ffffff;
            }

            .login-icon {
                width: 62px;
                height: 62px;
                margin: 0 auto 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 16px;
                background: rgba(255, 255, 255, 0.13);
                font-size: 28px;
            }

            .login-header h1 {
                margin: 0;
                font-size: 24px;
                font-weight: 700;
            }

            .login-header p {
                margin: 8px 0 0;
                color: rgba(255, 255, 255, 0.72);
                font-size: 13px;
            }

            .login-body {
                padding: 34px 40px 32px;
            }

            .form-group-custom {
                margin-bottom: 16px;
            }

            .form-label {
                display: block;
                font-size: 14px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 7px;
                text-align: left;
            }

            .form-control {
                width: 100%;
                min-height: 48px;
                border: 1px solid #d1d5db;
                border-radius: 10px;
                padding: 10px 14px;
                font-size: 14px;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
            }

            .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
            }

            .login-submit {
                width: 100%;
                min-height: 48px;
                border: 0;
                border-radius: 10px;
                background: #2563eb;
                color: #ffffff;
                font-size: 15px;
                font-weight: 600;
                transition: all 0.2s ease;
                margin-top: 8px;
            }

            .login-submit:hover {
                background: #1d4ed8;
                transform: translateY(-1px);
                box-shadow: 0 5px 14px rgba(37, 99, 235, 0.25);
            }

            .login-footer {
                text-align: center;
                margin-top: 24px;
                color: #6b7280;
                font-size: 14px;
            }

            .login-footer a {
                color: #2563eb;
                font-weight: 600;
                text-decoration: none;
            }

            .login-footer a:hover {
                text-decoration: underline;
            }

            .back-link {
                display: block;
                margin-top: 16px;
                text-align: center;
                color: #6b7280 !important;
                font-size: 13px;
                font-weight: 500 !important;
                text-decoration: none !important;
            }

            .back-link:hover {
                color: #2563eb !important;
            }

            .alert {
                border: 0;
                border-radius: 10px;
                font-size: 13px;
                line-height: 1.5;
            }

            @media (max-width: 480px) {
                body {
                    padding: 20px 12px;
                }
                .login-header {
                    padding: 28px 24px 22px;
                }
                .login-body {
                    padding: 28px 24px 25px;
                }
            }
        </style>
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">
        <!-- HEADER -->
        <div class="login-header">
            <div class="login-icon">🔐</div>
            <h1>Đăng nhập</h1>
            <p>Hệ thống quản lý đề tài sinh viên</p>
        </div>

        <!-- BODY -->
        <div class="login-body">
            <!-- REGISTER SUCCESS -->
            <c:if test="${param.registered}">
                <div class="alert alert-success mb-4">
                    Đăng ký tài khoản thành công. Vui lòng đăng nhập để tiếp tục.
                </div>
            </c:if>

            <!-- LOGIN ERROR -->
            <c:if test="${param.error}">
                <div class="alert alert-danger mb-4">
                    Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng kiểm tra lại.
                </div>
            </c:if>

            <!-- LOGOUT SUCCESS -->
            <c:if test="${param.logout}">
                <div class="alert alert-success mb-4">
                    Bạn đã đăng xuất thành công.
                </div>
            </c:if>

            <!-- FORM -->
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group-custom">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control" placeholder="Nhập tên đăng nhập" autocomplete="username" required>
                </div>

                <div class="form-group-custom">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" autocomplete="current-password" required>
                </div>

                <button type="submit" class="login-submit">Đăng nhập</button>
            </form>

            <!-- LINKS -->
            <div class="login-footer">
                Chưa có tài khoản?
                <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                <a class="back-link" href="${pageContext.request.contextPath}/topics">← Quay lại danh sách đề tài</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>