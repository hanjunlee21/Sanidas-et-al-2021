clear all;

mink = 2;
maxk = 8;

maxrep = 200;

parfor k = mink:maxk
    originalmatrix = readmatrix("hg38_RB1_MATRIX.tsv", 'Delimiter', '\t', 'FileType', 'text', 'OutputType', 'double').';
    numpeak = 1000;
    opt = statset('MaxIter', 200);
    connectivitymatrix = zeros(maxrep, numpeak*numpeak);
    for replication = 1:1:maxrep
        matrix = originalmatrix(:,randperm(size(originalmatrix,2),numpeak));
        disp(k*1000+replication);
        [W, H] = nnmf(matrix, k, 'Options', opt);
        mat = zeros(size(matrix, 2), size(matrix, 2));
        for i = 1:1:size(matrix, 2)
            for j = 1:1:size(matrix, 2)
                [~, ci] = max(H(:, i));
                [~, cj] = max(H(:, j));
                if ci == cj
                    mat(i, j) = 1;
                end
            end
        end
        connectivitymatrix(replication, :) = reshape(mat, 1, size(matrix, 2)*size(matrix, 2));
    end
    dist = pdist(connectivitymatrix);
    link = linkage(dist);
    writematrix(cophenet(link, dist), strcat("tmp/", num2str(k), ".txt"), 'Delimiter', '\t', 'FileType', 'text');
end
