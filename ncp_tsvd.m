function [FF, PP] = ncp_tsvd(candidates)

[tlist, TC, G] = linear_system();
disp(size(TC));
NCPx = zeros(size(candidates));
NCPy = zeros(size(candidates));
cs = size(candidates);
cs = cs(2);
FF = zeros(cs, 241, 1);
PP = zeros(cs, 241, 1);

for r = 1: cs
  h = tsvd(candidates(r));
  r_ = ( TC - G * h );
  [p_, F] = periodogram( r_, hamming ( length( r_ ) ), length( r_ ), 1 ) ;
  %sz = size(F);
  %fprintf('Size of p_ %d rows by %d columns\n', sz(1), sz(2));
  %disp(candidates(r));
  %plot3(F, candidates(r) * ones(size(F)), p_);
  %disp(size(F));
  %disp(size(FF));
  FF(r, :) = F;
  PP(r, :) = p_;
 
  q = floor ( length( r_ ) / 2 );
  c_ = zeros (q,1);

  p_sum = 0;
  for i = 2 : q+1
    p_sum = p_sum + p_(i);
  end
  c_white_ = zeros(q,1);
  for i = 1 : q
    c_white_(i) = i / q;
  end

  for i = 1 : q
    for j = 1 : i
      c_(i) = c_(i) + ( p_(j+1) / p_sum );  
    end
  end

  NCPx(r) = candidates(r);
  NCPy(r) = ( c_ - c_white_ )' * ( c_ - c_white_ );
end

figure;
plot(NCPx, NCPy, 'LineWidth', 2);
hold on;
[minValue, minIndex] = min(NCPy);
best_param = NCPx(minIndex);
plot(best_param, minValue, 'o', 'MarkerSize', 20, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red');
label = sprintf('(%0.0f, %0.2f)', best_param, minValue); % Format the label with 2 decimal places
verticalOffset = 5;
text(17, minValue + verticalOffset, label, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 32, 'Color', 'red');
hold off;
ylabel('Deviation from ideal noises', 'FontSize', 24);
xlabel('Value of r', 'FontSize', 24);
title('Prediction Errors vs. Ideal Noises', 'FontSize', 26);
set(gca, 'FontSize', 24);
filename = 'ncp_deviation';
exportgraphics(gcf, [filename '.png'], 'Resolution', 300, 'BackgroundColor', 'none');

%colors = pink(2 * cs);
%for r = 1:cs
%    plot3(FF(1, :), candidates(r) * ones(size(FF(1, :))), PP(r, :), 'LineWidth', 1, 'Color', colors(r, :));
%    hold on;
%end

%plot(NCPx, NCPy);
%hold off;
%set(gca, 'ZScale', 'log');
%xlabel('Frequency', 'FontSize', 24);
%ylabel('r', 'FontSize', 24);
%xlim([0, 0.5]);
%ylim([1, 70]);
%zlabel('Power spectral density', 'FontSize', 24);
%set(gca, 'FontSize', 24);
%title('NCP Plots for Different r in TSVD', 'FontSize', 26);





end