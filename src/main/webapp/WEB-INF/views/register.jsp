<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Quản lý đề tài</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
            * {
                box-sizing: border-box;
            }

            body {
                min-height: 100vh;
                margin: 0;
                background: radial-gradient(circle at top right, #dbeafe, transparent 35%),
                            radial-gradient(circle at bottom left, #e0e7ff, transparent 35%),
                            #f3f6fb;
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Arial, sans-serif;
                padding: 35px 15px;
            }

            .register-wrapper {
                width: 100%;
                max-width: 560px;
                margin: 0 auto;
            }

            .register-card {
                background: #ffffff;
                border: 0;
                border-radius: 20px;
                box-shadow: 0 20px 50px rgba(15, 23, 42, 0.12);
                overflow: hidden;
            }

            .register-header {
                padding: 32px 40px 25px;
                text-align: center;
                background: linear-gradient(135deg, #111827, #1e3a8a);
                color: #ffffff;
            }

            .register-icon {
                width: 58px;
                height: 58px;
                margin: 0 auto 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 15px;
                background: rgba(255, 255, 255, 0.13);
                font-size: 26px;
            }

            .register-header h1 {
                margin: 0;
                font-size: 24px;
                font-weight: 700;
            }

            .register-header p {
                margin: 8px 0 0;
                color: rgba(255, 255, 255, 0.72);
                font-size: 13px;
            }

            .register-body {
                padding: 32px 40px 30px;
            }

            .section-title {
                margin-bottom: 20px;
                color: #111827;
                font-size: 14px;
                font-weight: 700;
            }

            .form-group-custom {
                margin-bottom: 16px;
            }

            .form-label {
                display: block;
                margin-bottom: 7px;
                color: #374151;
                font-size: 13px;
                font-weight: 600;
                text-align: left;
            }

            .form-control {
                width: 100%;
                min-height: 46px;
                border: 1px solid #d1d5db;
                border-radius: 10px;
                padding: 9px 13px;
                font-size: 14px;
                transition: border-color 0.2s ease, box-shadow 0.2s ease;
            }

            .form-control:focus {
                border-color: #2563eb;
                box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
            }

            .register-submit {
                width: 100%;
                min-height: 48px;
                margin-top: 6px;
                border: 0;
                border-radius: 10px;
                background: #2563eb;
                color: #ffffff;
                font-size: 15px;
                font-weight: 600;
                transition: all 0.2s ease;
            }

            .register-submit:hover {
                background: #1d4ed8;
                transform: translateY(-1px);
                box-shadow: 0 5px 14px rgba(37, 99, 235, 0.25);
            }

            .register-footer {
                margin-top: 23px;
                text-align: center;
                color: #6b7280;
                font-size: 14px;
            }

            .register-footer a {
                color: #2563eb;
                font-weight: 600;
                text-decoration: none;
            }

            .register-footer a:hover {
                text-decoration: underline;
            }

            .alert {
                border: 0;
                border-radius: 10px;
                font-size: 13px;
            }

            @media (max-width: 576px) {
                body {
                    padding: 20px 12px;
                }
                .register-header {
                    padding: 28px 24px 22px;
                }
                .register-body {
                    padding: 27px 24px 25px;
                }
            }
        </style>
</head>
<body>

<div class="register-wrapper">
    <div class="register-card">
        <!-- HEADER -->
        <div class="register-header">
            <div class="register-icon">🎓</div>
            <h1>Đăng ký tài khoản</h1>
            <p>Tạo tài khoản để sử dụng hệ thống</p>
        </div>

        <!-- BODY -->
        <div class="register-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger mb-4">
                    ${error}
                </div>
            </c:if>

            <div class="section-title">Thông tin tài khoản</div>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <!-- USERNAME -->
                <div class="form-group-custom">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control" placeholder="Nhập tên đăng nhập" autocomplete="username" required>
                </div>

                <!-- PASSWORD -->
                <div class="form-group-custom">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" autocomplete="new-password" required>
                </div>

                <div class="section-title mt-4">Thông tin cá nhân</div>

                <!-- FULL NAME -->
                <div class="form-group-custom">
                    <label class="form-label">Họ và tên</label>
                    <input type="text" name="fullName" class="form-control" placeholder="Nhập họ và tên" required>
                </div>

                <!-- EMAIL -->
                <div class="form-group-custom">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="example@email.com" autocomplete="email" required>
                </div>

                <!-- PHONE -->
                <div class="form-group-custom">
                    <label class="form-label">Số điện thoại</label>
                    <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại" autocomplete="tel">
                </div>

                <!-- ADDRESS -->
                <div class="form-group-custom">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" name="address" class="form-control" placeholder="Nhập địa chỉ">
                </div>

                <button type="submit" class="register-submit">Tạo tài khoản</button>
            </form>

            <div class="register-footer">
                Đã có tài khoản?
                <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>