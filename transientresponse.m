% Transient_Response_Water_fixed_withSecondDataset.m
filename = 'Mini Lab 2 Data (All Parts).xlsx';

% First dataset
sheet1 = '2.4 WATER Transient';
range1 = 'B20:C394';   

% Second dataset 
sheet2 = '2.4 AIR Transient';
range2 = 'B20:C394';   

% Check file exists
if ~isfile(filename)
    error('File not found: %s. Use full path or change current folder.', filename);
end

% Helper to read and return numeric/datetime time (x) and numeric y
function [xOut,yOut] = readXY(fname, sht, rng)
    T = readtable(fname, 'Sheet', sht, 'Range', rng);
    if width(T) < 2
        error('Range %s on sheet %s did not return two columns.', rng, sht);
    end
    x = T{:,1};
    y = T{:,2};
    % Convert x to datetime if it's text/string
    if iscell(x) || isstring(x)
        try
            x = datetime(x);
        catch
            % try numeric conversion
            num = str2double(x);
            if all(~isnan(num))
                x = num;
            else
                error('Unable to convert x-values in %s to datetime or numeric.', rng);
            end
        end
    end
    % Remove missing/NaN rows
    valid = ~(ismissing(x) | isnan(x) | ismissing(y) | isnan(y));
    xOut = x(valid);
    yOut = y(valid);
end

% Read datasets
[x1,y1] = readXY(filename, sheet1, range1);
[x2,y2] = readXY(filename, sheet2, range2);

% Plot both on same axes
figure;
plot(x1, y1, '-o', 'LineWidth', 1.2, 'DisplayName', 'Water');
hold on;
plot(x2, y2, '--s', 'LineWidth', 1.2, 'DisplayName', 'Air');
hold off;
grid on;
xlabel('Time');
ylabel('Reference Temperature');
title('Reference Temperature vs Time');
legend('Location','best');
% Transient_Response_Water_fixed_withSecondDataset.m
