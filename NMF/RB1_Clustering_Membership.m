clear all;

maxrep = 200;

files = ["RB.Peaks";"TR"];

for i = 1:size(files,1)
    matrix = readmatrix(strcat(files(i,1),".tsv"),'Delimiter','\t','FileType','text','OutputType','double');
    m = mode(matrix, 2);
    score = zeros(size(matrix,1),1);
    for j = 1:size(matrix,1)
        score(j,1) = sum(matrix(j,:).'==m(j,1))/maxrep;
    end
    writematrix([m,score],strcat(files(i,1),".Membership.tsv"), 'Delimiter','\t','FileType','text');
    disp(files(i,1));
end
