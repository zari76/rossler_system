clc; clear; close all
myfontsize = 20;
figure('WindowState','maximized');

t = tiledlayout(2,2,'TileSpacing','tight');

ax1 = nexttile;
load("SA_num.mat")
yyaxis lef
scatter(x_num, y_num, 12, 'b', 'filled', 'DisplayName', 'Bifurcation', ...
    'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1)
% ylabel('$x_{\max}(t)$', 'Interpreter', 'latex')
load("SA_LLE.mat")
hold on
yyaxis right
plot(b_values, LLE_vs_b, '-r', 'LineWidth', 2, 'DisplayName', 'LLE');
% ylabel('LLE')
hold off
title(ax1,'(a)')
ax1.XLim = ([0 5]);
ax1.FontSize = myfontsize;
ax1.FontWeight = 'bold';
ax1.YAxis(1).Color = 'b';   % Left axis blue
ax1.YAxis(2).Color = 'r';   % Right axis red
grid minor

ax2 = nexttile;
load("SNA_num.mat")
yyaxis left
scatter(x_num, y_num, 12, 'b', 'filled', 'DisplayName', 'Bifurcation', ...
    'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1)
% ylabel('$x_{\max}(t)$', 'Interpreter', 'latex')
load("SNA_LLE.mat")
hold on
yyaxis right
plot(b_values, LLE_vs_b, '-r', 'LineWidth', 2, 'DisplayName', 'LLE');
% ylabel('LLE')
hold off
title(ax2,'(b)')
ax2.XLim = ([0 5]);
ax2.FontSize = myfontsize;
ax2.FontWeight = 'bold';
ax2.YAxis(1).Color = 'b';   % Left axis blue
ax2.YAxis(2).Color = 'r';   % Right axis red
grid minor

ax3 = nexttile;
load("NSA_num.mat")
yyaxis left
scatter(x_num, y_num, 12, 'b', 'filled', 'DisplayName', 'Bifurcation', ...
    'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1)
% ylabel('$x_{\max}(t)$', 'Interpreter', 'latex')
load("NSA_LLE.mat")
hold on
yyaxis right
plot(b_values, LLE_vs_b, '-r', 'LineWidth', 2, 'DisplayName', 'LLE');
ylim(ax3, ([-0.05 0.1]))
% ylabel('LLE')
hold off
title(ax3,'(c)')
ax3.XLim = ([0 5]);
ax3.FontSize = myfontsize;
ax3.FontWeight = 'bold';
ax3.YAxis(1).Color = 'b';   % Left axis blue
ax3.YAxis(2).Color = 'r';   % Right axis red
grid minor

ax4 = nexttile;
load("NSNA_num.mat")
yyaxis left
scatter(x_num, y_num, 12, 'b', 'filled', 'DisplayName', 'Bifurcation', ...
    'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1)
% ylabel('$x_{\max}(t)$', 'Interpreter', 'latex')
load("NSNA_LLE.mat")
hold on
yyaxis right
plot(b_values, LLE_vs_b, '-r', 'LineWidth', 2, 'DisplayName', 'LLE');
% ylabel('LLE')
hold off
title(ax4,'(d)')
ax4.XLim = ([0 5]);
ax4.FontSize = myfontsize;
ax4.FontWeight = 'bold';
ax4.YAxis(1).Color = 'b';   % Left axis blue
ax4.YAxis(2).Color = 'r';   % Right axis red
grid minor

xlabel(t, '$b$', 'Interpreter', 'latex',...
    'FontSize', 28, 'FontWeight', 'bold');

ylabel(t, '$x_{\max}(t)$', 'Interpreter', 'latex',...
    'FontSize', 28, 'FontWeight', 'bold', 'Color','b');

% Common RIGHT y-axis label
annotation('textbox', [0.997 0.5 0.03 0.1], ...
    'String', 'LLE', ...
    'Interpreter', 'latex', ...
    'FontSize', 28, ...
    'Color','r',...
    'FontWeight', 'bold', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', ...
    'Rotation', 90);
