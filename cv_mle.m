function best_param = cv_mle(candidates)
    [tlist, TC, G] = linear_system();

    msize = 480;
    rng(42);
    p = randperm(msize);
    k = 10;
    p_size = msize / k;
    cand_size = size(candidates);
    cand_size = cand_size(2);
    fprintf('Candsize is %s\n', num2str(cand_size));
    errors = zeros(1, cand_size);

    for iter = 1:k
        %tlist_train = [tlist(1:(iter - 1) * p_size), tlist(iter * p_size + 1:480)]
        %tlist_test = tlist((iter - 1) * p_size + 1:iter * p_size)
        TC_train = [TC(1:(iter - 1) * p_size, :); TC(iter * p_size + 1:480, :)];
        TC_test = TC((iter - 1) * p_size + 1:iter * p_size, :);
        G_train = [G(1:(iter - 1) * p_size, :); G(iter * p_size + 1:480, :)];
        G_test = G((iter - 1) * p_size + 1:iter * p_size, :);
        for i = 1:cand_size
            candidate = candidates(i);
            h_train = mle_tsvd(candidate, tlist, TC_train, G_train);
            TC_approx = G_test * h_train;
            sse = norm(TC_approx - TC_test)^2;
            errors(i) = errors(i) + sse;
        end
    end

    errors = errors / k;
    cv_tr_fig = figure;
    semilogy(candidates, errors, 'LineWidth', 2);
    %title('Tuning TR', 'FontSize', 26);
    %xlabel(sprintf('Value of %c', char(961)), 'FontSize', 24);
    %ylabel('Mean CV error', 'FontSize', 24);
    set(gca, 'FontSize', 24);
    %xlim([0.0008, 0.0018]);
    %ylim([7800, 13000]);
    hold on;
    [minValue, minIndex] = min(errors);
    best_param = candidates(minIndex);
    fprintf('Best param is %s, best error is %f\n', num2str(best_param), minValue);
    plot(best_param, minValue, 'o', 'MarkerSize', 20, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', 'red');
    label = sprintf('(%0.2e, %0.2e)', best_param, minValue); % Format the label with 2 decimal places
    verticalOffset = 10;
    text(best_param, minValue + verticalOffset, label, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'FontSize', 32, 'Color', 'red');

    hold off;
    %exportgraphics(cv_tr_fig, 'cv_mle_tr_large.png', 'Resolution', 300);


end