function KMeansSMOTE_balance(input_file, output_file, k, minority_classes)
    % Import data from Excel file
    [num, ~, ~] = xlsread(input_file);  % Read Excel file
    X = num(:, 1:end-1);  % Feature data (assuming the last column is labeled)
    y = num(:, end);  % labeled data
    % Find the sample size for each category
    class_counts = histcounts(y, unique(y)); % Obtain the sample size for each category
   % Find the sample size of the majority class (the class with the most samples)
    max_samples = max(class_counts);  
    % Create balanced data
    X_resampled = X;
    y_resampled = y;
    % Perform KMeansSMOTE oversampling on each minority class until class balance is achieved
    for i = 1:length(minority_classes)
        minority_class = minority_classes(i);
    % Obtain samples of the minority class, where minority_classes is an array with index (i)
        minority_samples = X(y == minority_class, :);
    % Extraction of current minority class sample data
        minority_count = size(minority_samples, 1);
     % Return the number of rows in the matrix minority_samples.
        if minority_count < max_samples
            % Cluster the minority sample using KMeans
            [idx, C] = kmeans(minority_samples, k);  % K clusters
         % Calculate the number of synthesized samples to be generated
            num_samples_to_generate = max_samples - minority_count;
         % List of synthesized samples
            synthetic_samples = zeros(num_samples_to_generate, size(X, 2));
         % Generate synthetic samples for each cluster
           for j = 1:k
                cluster_samples = minority_samples(idx == j, :);  % Clustered samples
                cluster_center = C(j, :);  % cluster center
          % Randomly select samples and generate composite samples
                for m = 1:floor(num_samples_to_generate /k)
                    random_sample = cluster_samples(randi(size(cluster_samples, 1)), :);
                    synthetic_sample = random_sample + randn(1, size(X, 2)) .* (cluster_center - random_sample);
                    synthetic_samples((j - 1) * floor(num_samples_to_generate / k) + m, :) = synthetic_sample;
                end
            end
                        % Add synthetic samples to the data
            X_resampled = [X_resampled; synthetic_samples];
            y_resampled = [y_resampled; repmat(minority_class, size(synthetic_samples, 1), 1)];
        end
    end
        % Write the results to an Excel file
    resampled_data = [X_resampled, y_resampled];
    balanced_sortedIDX=resampled_data(:,end);
    figure
    barh(balanced_sortedIDX)
    ylabel('number of classes-->')
    xlabel('Sampels in each class-->')
    title('Balanced data distirbution')
    writetable(array2table(resampled_data), output_file);
    disp(['Balanced data has been written to ', output_file]);
   end
%%


