% Parameters
L = 1;                % Period length
N = 50;               % Number of Fourier modes
x = linspace(0, L, 100); % Spatial points
t = linspace(0, 0.2, 50); % Time points (evolving)

% Initial condition: Define f(x) (initial temperature distribution)
f = @(x) (x > 0 & x <= L/2) .* 1 + (x > L/2 & x <= L) .* (-1); % Example initial condition

% Compute Fourier coefficients
f_coeff = zeros(1, 2*N+1); % Store coefficients for n = -N to N
for n = -N:N
    integrand = @(y) f(y) .* exp(-2*pi*1i*n*y); % Fourier coefficient formula
    f_coeff(n+N+1) = integral(integrand, 0, L); % Store coefficients
end

% Compute u(x, t)
u_xt = zeros(length(t), length(x)); % Initialize solution matrix
for ti = 1:length(t)
    u_t = zeros(1, length(x)); % Solution at time t
    for n = -N:N
        % Contribution of each Fourier mode
        mode = f_coeff(n+N+1) * exp(-2*pi^2*n^2*t(ti)) .* exp(2*pi*1i*n*x);
        u_t = u_t + real(mode); % Add real part of mode
    end
    u_xt(ti, :) = u_t; % Store solution at time t
end

% Plot 3D graph
[X, T] = meshgrid(x, t); % Create grid for plotting
figure;
surf(X, T, u_xt, 'EdgeColor', 'none'); % Surface plot
colormap jet; % Set color map
xlabel('Space (x)', 'FontSize', 12);
ylabel('Time (t)', 'FontSize', 12);
zlabel('Temperature (u)', 'FontSize', 12);
title('Heat Equation Solution u(x, t)', 'FontSize', 14);
colorbar; % Add color bar
view(3); % Set 3D view