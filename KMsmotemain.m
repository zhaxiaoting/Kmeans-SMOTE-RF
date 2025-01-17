% Define Parameters
clc;
clear;
input_file = 'kmeanssmote.xlsx';  % Enter file path
output_file = 'kmeanssmotenew.xlsx';  % Output file path
k = 2;  % KMeans Number of clusters
minority_classes = [1, 2, 3, 4, 5];  % Minority class tag array
% Call KMeansSMOTE for data balancing
KMeansSMOTE_balance(input_file, output_file, k, minority_classes);
