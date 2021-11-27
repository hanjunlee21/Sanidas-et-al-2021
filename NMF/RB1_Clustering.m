clear all;

maxrep = 200;

parfor replication = 1:maxrep
    matrix = readmatrix("hg38_RB1_MATRIX.tsv", 'Delimiter', '\t', 'FileType', 'text', 'OutputType', 'double').';
    opt = statset('MaxIter', 200);
    k = 5;
    disp(k*1000+replication);
    [W, H] = nnmf(matrix, k, 'Options', opt);
    
    wmat = zeros(size(matrix, 1), 1);
    hmat = zeros(size(matrix, 2), 1);
    
    for i = 1:1:size(matrix, 1)
        [~, wmat(i,1)] = max(W(i, :).');
    end
    for i = 1:1:size(matrix, 2)
        [~, hmat(i,1)] = max(H(:, i));
    end
    
    writematrix(wmat, strcat("NMF/", num2str(replication), ".TR.txt"), 'Delimiter', '\t', 'FileType', 'text');
    writematrix(hmat, strcat("NMF/", num2str(replication), ".RB.Peaks.txt"), 'Delimiter', '\t', 'FileType', 'text');
end


