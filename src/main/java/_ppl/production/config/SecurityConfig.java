package _ppl.production.config;

import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()

                        .requestMatchers(
                                "/",
                                "/login",
                                "/register",
                                "/error",
                                "/favicon.ico",
                                "/css/**",
                                "/js/**",
                                "/images/**",
                                "/webjars/**"
                        ).permitAll()

                        .requestMatchers(
                                "/topics",
                                "/topics/open",
                                "/topics/search",
                                "/topics/{id}"
                        ).permitAll()

                        .requestMatchers("/admin/**")
                        .hasAuthority("ADMIN")

                        .requestMatchers(
                                "/registrations/pending",
                                "/registrations/approve/**",
                                "/registrations/reject/**"
                        ).hasAuthority("ADMIN")

                        .requestMatchers(
                                "/topics/create",
                                "/topics/edit/**",
                                "/topics/delete/**",
                                "/lecturer/**"
                        ).hasAuthority("LECTURER")

                        .requestMatchers(
                                "/registrations",
                                "/registrations/register",
                                "/registrations/delete/**",
                                "/student/group",
                                "/student/group/**",
                                "/submission/**",
                                "/student/results",
                                "/student/my-topic",
                                "/student/my-topic/**"
                        ).hasAuthority("STUDENT")

                        .requestMatchers("/profile/**").authenticated()

                        .anyRequest().denyAll()
                )

                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .successHandler(authenticationSuccessHandler())
                        .failureUrl("/login?error=true")
                        .permitAll()
                )

                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout=true")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .deleteCookies("JSESSIONID")
                        .permitAll()
                )

                .csrf(csrf -> csrf.disable())

                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
                        .sessionFixation(fixation -> fixation.changeSessionId())
                )

                .exceptionHandling(exception -> exception
                        .authenticationEntryPoint(authenticationEntryPoint())
                );

        return http.build();
    }

    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return (request, response, authentication) -> {
            String target;

            if (hasAuthority(authentication, "ADMIN")) {
                target = "/admin/registration-rounds";
            } else if (hasAuthority(authentication, "LECTURER")) {
                target = "/topics";
            } else if (hasAuthority(authentication, "STUDENT")) {
                target = "/topics";
            } else {
                target = "/topics";
            }

            response.sendRedirect(request.getContextPath() + target);
        };
    }

    private boolean hasAuthority(Authentication authentication, String authority) {
        return authentication.getAuthorities().stream()
                .anyMatch(a -> authority.equals(a.getAuthority()));
    }

    @Bean
    public AuthenticationEntryPoint authenticationEntryPoint() {
        return (request, response, authException) -> {
            if (request.getRequestURI().endsWith("/login")) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            response.sendRedirect(request.getContextPath() + "/login");
        };
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
