function aic(regName, candidates)

[tlist, TC, G] = linear_system();
n = 480; % num of observations
numOfCandidates = size(candidates);
numOfCandidates = numOfCandidates(2);
aics = zeros(1, numOfCandidates);

for i = 1:numOfCandidates
    candidate = candidates(i);
    if regName == "tsvd"
        [h, Q] = tsvd(candidate);
    elseif regName == "tr"
        [h, Q] = tr(candidate);
    elseif regName == "mle_tsvd"
        [h, Q] = mle_tsvd(candidate);
    else
        [h, Q] = mle(candidate);
    end

    TCPredicted = G * h;
    sse = norm(TC - TCPredicted)^2;
    aic = 2 * trace(Q) + n * log(sse);
    aics(i) = aic;
end

[minValue, minIndex] = min(aics);
bestParam = candidates(minIndex);
fprintf('Best parameter is %0.2e; best value is %0.2e.\n', bestParam, minValue);

end