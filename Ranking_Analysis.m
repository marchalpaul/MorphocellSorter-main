clear;
clc;
close all;


%% Get manual ranking tables
% Get manual rankings
[rankFile, rankPath] = uigetfile('../../*.xls*', 'Select the file containing the manual rankings');
manualRankings = readtable(fullfile(rankPath, rankFile));
    
% Ranking tables of nbMicroglia microglia
[algoRankFile, algoRankPath] = uigetfile('../outputs/*.xls*', 'Select the file containing the algorithm rankings');
testedRankings = readtable(fullfile(algoRankPath, algoRankFile));
nbMicroglia=size(testedRankings(:, 2), 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% to test manual ranking UI of Python %%%%%%%
testedRankings=testedRankings(:,[1,5]);                                     % TO BE REMOVED
testedRankings.Properties.VariableNames=[{'rank'},{'microglia'}];           % TO BE REMOVED
for i=1:nbMicroglia
    testedRankings.microglia{i} = testedRankings.microglia{i}(1:end-4);     % TO BE REMOVED 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% Loop on all algorithm rankings
for n = 2:size(testedRankings, 2)
    % Loop on all manual rankings
    for m = 2:size(manualRankings, 2)
        manualRankingsN = zeros(nbMicroglia, 1);
        manualRankingsReverseN = zeros(nbMicroglia, 1);
        deltaRanks = zeros(nbMicroglia, 1);
        deltaReverseRanks = zeros(nbMicroglia, 1);
        % Loop on all ranks
        for l = 1:nbMicroglia
            % Find index in normal order
            foundIdx = find(string(manualRankings{:, m}) == string(testedRankings{l, n}));
            
            % Find index in reverse order
            foundReverseIdx = find(flip(string(manualRankings{:, m})) == string(testedRankings{l, n}));

            % Compute absolute difference
            deltaRanks(l) = abs(l - foundIdx);
            manualRankingsN(l) = foundIdx;
            deltaReverseRanks(l) = abs(l - foundReverseIdx);
            manualRankingsReverseN(l) = foundReverseIdx;
        end

        % Take the differences of the best order
        if mean(deltaRanks) <= mean(deltaReverseRanks)
            deltaRankings(n-1).R(:, m-1) = deltaRanks;
            manualRankingsRanks(n-1).R(:, m-1) = manualRankingsN;
        else
            deltaRankings(n-1).R(:, m-1) = deltaReverseRanks;
            manualRankingsRanks(n-1).R(:, m-1) = manualRankingsReverseN;
        end
    end
    mean(deltaRankings(1).R(:, 1))
    mean(deltaRankings(1).R(:, 2))
end


    % Loop on all manual rankings


        % Loop on all ranks
        for l = 1:nbMicroglia
            % Find index in normal order
            foundIdx = find(string(manualRankings{:, 2}) ==string(manualRankings{l, 3}));
            
            % Find index in reverse order
            foundReverseIdx = find(flip(string(manualRankings{:, 2}) == string(manualRankings{l, 3})));

            % Compute absolute difference
            deltaRanks(l) = abs(l - foundIdx);
            manualRankingsN(l) = foundIdx;
            deltaReverseRanks(l) = abs(l - foundReverseIdx);
            manualRankingsReverseN(l) = foundReverseIdx;
        end

        % Take the differences of the best order
        if mean(deltaRanks) <= mean(deltaReverseRanks)
            deltaRankings2(1).R(:, 1) = deltaRanks;
            manualRankingsRanks2(1).R(:, 1) = manualRankingsN;
        else
            deltaRankings2(1).R(:,1) = deltaReverseRanks;
            manualRankingsRanks(1).R(:,1) = manualRankingsReverseN;
        end

%     mean(deltaRankings2(1).R(:, 1))


%% Plots
% [row, col] = Find_Plot_Dimension(size(testedRankings, 2)-1);

row = 3;
col = 3;
idxFig = 1;
% figure;
% 
% % Loop on all manual rankings
% for m = 2:size(manualRankings, 2)
%     % Loop on all algorithm rankings
%     for n = 2:size(testedRankings, 2)
% %         subplot(row, col, n-1);
% %         subplot(row, col, idxFig);
% %         idxFig = idxFig + 1;
%         % Plot rank differences
%         p = plot(1:size(testedRankings, 1), deltaRankings(n-1).R(:, m-1), 'LineWidth', 1);
%         hold on;
%         % Plot mean vertical line
%         plot([0, size(testedRankings, 1)], [mean(deltaRankings(n-1).R(:, m-1)), mean(deltaRankings(n-1).R(:, m-1))], '--r', 'LineWidth', 1);
%         % Plot mean+std vertical line
%         plot([0, size(testedRankings, 1)], [mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1)), ...
%             mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1))], '-.g', 'LineWidth', 1);
%         % Plot mean-std vertical line
%         plot([0, size(testedRankings, 1)], [mean(deltaRankings(n-1).R(:, m-1))-std(deltaRankings(n-1).R(:, m-1)), ...
%             mean(deltaRankings(n-1).R(:, m-1))-std(deltaRankings(n-1).R(:, m-1))], '-.g', 'LineWidth', 1);
% %         title(testedRankings.Properties.VariableNames(:, n), 'Interpreter', 'latex', 'FontSize', 16);
%         title(['Absolute Rank Difference with ' char(manualRankings.Properties.VariableNames(m))], 'Interpreter', 'latex', 'FontSize', 16);
%         xlabel("Algorithm Rank", 'Interpreter', 'latex', 'FontSize', 14);
%         ylabel("Absolute Rank Difference", 'Interpreter', 'latex', 'FontSize', 14);
%         xlim([0 size(testedRankings(:, 2), 1)]);
%         ylim(xlim);
%         legend("Difference", "mean", "mean+std", "mean-std");
%         grid on;
%     end
% end

% figure()
%         p = plot(1:size(testedRankings, 1), deltaRankings(1).R(:,1), 'LineWidth', 1);
%         hold on;
%         % Plot mean vertical line
%         plot([0, size(testedRankings, 1)], [mean(deltaRankings(1).R(:, 1)), mean(deltaRankings(1).R(:, 1))], '--r', 'LineWidth', 1);
%         % Plot mean+std vertical line
% %         plot([0, size(testedRankings, 1)], [mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1)), ...
% %             mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1))], '-.g', 'LineWidth', 1);
% %         % Plot mean-std vertical line
% %         plot([0, size(testedRankings, 1)], [mean(deltaRankings(n-1).R(:, m-1))-std(deltaRankings(n-1).R(:, m-1)), ...
% %             mean(deltaRankings(n-1).R(:, m-1))-std(deltaRankings(n-1).R(:, m-1))], '-.g', 'LineWidth', 1);
% %         title(testedRankings.Properties.VariableNames(:, n), 'Interpreter', 'latex', 'FontSize', 16);
%         xlabel("Cellules classees automatiquement", 'FontSize', 14);
%         ylabel("Difference de rang absolue classement automatique et expert 1", 'FontSize', 14);
%         xlim([0 size(testedRankings(:, 2), 1)]);
%         ylim(xlim);
%         legend("Différence", "Moyenne");
%         grid on;
        
% figure
%                 p = plot(1:size(testedRankings, 1), deltaRankings(1).R(:,2), 'LineWidth', 1);
%         hold on;
%         % Plot mean vertical line
%         plot([0, size(testedRankings, 1)], [mean(deltaRankings(1).R(:, 2)), mean(deltaRankings(1).R(:, 2))], '--r', 'LineWidth', 1);
%         % Plot mean+std vertical line
% %         plot([0, size(testedRankings, 1)], [mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1)), ...
% %             mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1))], '-.g', 'LineWidth', 1);
% %         % Plot mean-std vertical line
% %         plot([0, size(testedRankings, 1)], [mean(deltaRankings(n-1).R(:, m-1))-std(deltaRankings(n-1).R(:, m-1)), ...
% %             mean(deltaRankings(n-1).R(:, m-1))-std(deltaRankings(n-1).R(:, m-1))], '-.g', 'LineWidth', 1);
% %         title(testedRankings.Properties.VariableNames(:, n), 'Interpreter', 'latex', 'FontSize', 16);
%         xlabel("Cellules classees automatiquement", 'FontSize', 14);
%         ylabel("Difference de rang absolue classement automatique et expert 2", 'FontSize', 14);
%         xlim([0 size(testedRankings(:, 2), 1)]);
%         ylim(xlim);
%         legend("Différence", "Moyenne");
%         grid on;

%         figure
%                 p = plot(1:size(testedRankings, 1), deltaRankings2(1).R(:,1), 'LineWidth', 1);
%         hold on;
%         % Plot mean vertical line
%         plot([0, size(testedRankings, 1)], [mean(deltaRankings2(1).R(:, 1)), mean(deltaRankings2(1).R(:, 1))], '--r', 'LineWidth', 1);
%         xlabel("Cellules classées par l'expert 1", 'FontSize', 14);
%         ylabel("Difference de rang absolue classement expert 1 et expert 2", 'FontSize', 14);
%         xlim([0 size(testedRankings(:, 2), 1)]);
%         ylim(xlim);
%         legend("Différence", "Moyenne");
%         grid on;
%% Manual Rankings Comparison
% n choose 2 table for 2 by 2 comparison
% deltaManualRankings = zeros(size(manualRankings, 1), nchoosek(size(manualRankings, 2)-1, 2));
idxComp = 1;
% Loop on all manual rankings
for n = 2:size(manualRankings, 2)
    % Loop on all following manual rankings
    for m = n:size(manualRankings, 2)
        deltaManualRanks = zeros(size(manualRankings, 1), 1);
        for l = 1:size(manualRankings, 1)
            % Find index
            foundIdx = find(string(manualRankings{:, m}) == string(manualRankings{l, n}));
            % Compute difference
            deltaManualRanks(l) = abs(l - foundIdx);
        end
        deltaManualRankings(:, idxComp) = deltaManualRanks;
        idxComp = idxComp + 1;
    end
end

idxComp = 1;
% % Loop on all manual rankings
% for n = 2:size(manualRankings, 2)
%     % Loop on all following manual rankings
%     for m = n:size(manualRankings, 2)
%         figure;
%         subplot(row, col, idxFig);
%         idxFig = idxFig + 1;
%         % Plot rank differences
%         p = plot(1:size(manualRankings, 1), deltaManualRankings(:, idxComp), 'LineWidth', 1);
%         hold on;
%         % Plot mean vertical line
%         plot([0, size(manualRankings, 1)], [mean(deltaManualRankings(:, idxComp)), mean(deltaManualRankings(:, idxComp))], '--r', 'LineWidth', 1);
%         % Plot mean+std vertical line
%         plot([0, size(manualRankings, 1)], [mean(deltaManualRankings(:, idxComp))+std(deltaManualRankings(:, idxComp)), ...
%             mean(deltaManualRankings(:, idxComp))+std(deltaManualRankings(:, idxComp))], '-.g', 'LineWidth', 1);
%         % Plot mean-std vertical line
%         plot([0, size(manualRankings, 1)], [mean(deltaManualRankings(:, idxComp))-std(deltaManualRankings(:, idxComp)), ...
%             mean(deltaManualRankings(:, idxComp))-std(deltaManualRankings(:, idxComp))], '-.g', 'LineWidth', 1);
%         title(['Absolute Rank Difference between ' ...
%             char(manualRankings.Properties.VariableNames(n)) ' and ' char(manualRankings.Properties.VariableNames(m))], ...
%             'Interpreter', 'latex', 'FontSize', 16);
%         xlabel([char(manualRankings.Properties.VariableNames(n)) ' Rank'], 'Interpreter', 'latex', 'FontSize', 14);
%         ylabel('Absolute Rank Difference', 'Interpreter', 'latex', 'FontSize', 14);
%         xlim([0 size(manualRankings(:, 2), 1)]);
%         ylim(xlim);
%         legend("", "mean", "mean+std", "mean-std");
%         grid on;
%         idxComp = idxComp + 1;
%     end
% end


%% Signed Differences
% Loop on all algorithm rankings
for n = 2:size(testedRankings, 2)
    % Loop on all manual rankings
    for m = 2:size(manualRankings, 2)
        manualRankingsN = zeros(size(testedRankings(:, 2), 1), 1);
        manualRankingsReverseN = zeros(size(testedRankings(:, 2), 1), 1);
        deltaRanks = zeros(size(testedRankings(:, 2), 1), 1);
        deltaReverseRanks = zeros(size(testedRankings(:, 2), 1), 1);
        % Loop on all ranks
        for l = 1:size(testedRankings(:, 2), 1)
            % Find index in normal order
            foundIdx = find(string(manualRankings{:, m}) == string(testedRankings{l, n}));
            
            % Find index in reverse order
            foundReverseIdx = find(flip(string(manualRankings{:, m})) == string(testedRankings{l, n}));
    
            % Compute absolute difference
            deltaRanks(l) = l - foundIdx;
            deltaReverseRanks(l) = l - foundReverseIdx;
        end
    
        % Take the differences of the best order
        if mean(abs(deltaRanks)) <= mean(abs(deltaReverseRanks))
            deltaRankingsSigned(n-1).R(:, m-1) = deltaRanks;
        else
            deltaRankingsSigned(n-1).R(:, m-1) = deltaReverseRanks;
        end
    end
end

% n choose 2 table for 2 by 2 comparison
% deltaManualRankingsSigned = zeros(size(manualRankings, 1), nchoosek(size(manualRankings, 2)-1, 2));
idxComp = 1;
% Loop on all manual rankings
for n = 2:size(manualRankings, 2)
    % Loop on all following manual rankings
    for m = n+1:size(manualRankings, 2)
        deltaManualRanks = zeros(size(manualRankings, 1), 1);
        for l = 1:size(manualRankings, 1)
            % Find index
            foundIdx = find(string(manualRankings{:, m}) == string(manualRankings{l, n}));
            % Compute difference
            deltaManualRanks(l) = l - foundIdx;
        end
        deltaManualRankingsSigned(:, idxComp) = deltaManualRanks;
        idxComp = idxComp + 1;
    end
end


%% Noise
% sumStd = zeros(1, size(testedRankings, 2)-1);
% mu = zeros(1, size(testedRankings, 2)-1);
% % Loop on all manual rankings
% for m = 2:size(manualRankings, 2)
%     % Loop on all algorithm rankings
%     for n = 2:size(testedRankings, 2)
%         % Compute sum of square std
%         sumStd(n-1) = sumStd(n-1) + std(deltaRankings(n-1).R(:, m-1))^2;
%     end
% end
% for n = 2:size(testedRankings, 2)
%     % Compute noise index ?
%     mu(n-1) = sqrt(sumStd(n-1))/(size(manualRankings, 2)-1);
% end
% 
% 
% % %% Histograms
% binWidth = 1;
% % Loop on all manual rankings
% for m = 2:size(manualRankings, 2)
%     % Loop on all algorithm rankings
%     for n = 2:size(testedRankings, 2)
%         figure;
%         % Plot rank difference normalized histogram
%         h = histogram(deltaRankings(n-1).R(:, m-1), 'Normalization', 'probability', 'BinWidth', binWidth);
%         hold on;
%         title(['Absolute Rank Difference Histogram with ' ...
%             char(manualRankings.Properties.VariableNames(m))], 'Interpreter', 'latex', 'FontSize', 16);
% %         title([char(testedRankings.Properties.VariableNames(n)) ': Rank Difference Histogram with ' ...
% %             char(manualRankings.Properties.VariableNames(m))], 'Interpreter', 'latex', 'FontSize', 16);
%         xlabel("Absolute Rank Difference", 'Interpreter', 'latex', 'FontSize', 14);
%         ylabel("Relative Frequency", 'Interpreter', 'latex', 'FontSize', 14);
%         grid on;
%         xlim([0 60]);
%         ylim([0 0.105]);
%         % Find 95 percentil
%         prctil95 = find(cumsum(h.Values) >= 0.95, 1);
%         hist95(n-1).R(m-1) = h.BinEdges(prctil95);
%         % Plot 95 percentil vertical line
%         plot([hist95(n-1).R(m-1) hist95(n-1).R(m-1)], ylim, ':m', 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5);
%         % Plot mean vertical line
%         plot([mean(deltaRankings(n-1).R(:, m-1)) mean(deltaRankings(n-1).R(:, m-1))], ylim, '--r', 'LineWidth', 1);
%         % Plot mean+std vertical line
%         plot([mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1)) ...
%             mean(deltaRankings(n-1).R(:, m-1))+std(deltaRankings(n-1).R(:, m-1))], ylim, '-.g', 'LineWidth', 1);
%         legend("", "95%", "mean", "mean+std");
%     end
% end
% % 
% idxComp = 1;
% % Loop on all manual rankings
% for m = 2:size(manualRankings, 2)
%     % Loop on all other manual rankings
%     for n = m+1:size(manualRankings, 2)
%         figure;
%         % Plot rank difference normalized histogram
%         h = histogram(deltaManualRankings(:, idxComp), 'Normalization', 'probability', 'BinWidth', binWidth);
%         hold on;
%         title(['Absolute Rank Difference Histogram between ' ...
%             char(manualRankings.Properties.VariableNames(m)) ' and ' char(manualRankings.Properties.VariableNames(n))], ...
%             'Interpreter', 'latex', 'FontSize', 16);
% %         title([char(testedRankings.Properties.VariableNames(n)) ': Rank Difference Histogram with ' ...
% %             char(manualRankings.Properties.VariableNames(m))], 'Interpreter', 'latex', 'FontSize', 16);
%         xlabel("Absolute Rank Difference", 'Interpreter', 'latex', 'FontSize', 14);
%         ylabel("Relative Frequency", 'Interpreter', 'latex', 'FontSize', 14);
%         grid on;
%         xlim([0 60]);
%         ylim([0 0.105]);
%         % Find 95 percentil
%         prctil95 = find(cumsum(h.Values) >= 0.95, 1);
%         hist95(n-1).R(m-1) = h.BinEdges(prctil95);
%         % Plot 95 percentil vertical line
%         plot([hist95(n-1).R(m-1) hist95(n-1).R(m-1)], ylim, ':m', 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5);
%         % Plot mean vertical line
%         plot([mean(deltaManualRankings(:, idxComp)) mean(deltaManualRankings(:, idxComp))], ylim, '--r', 'LineWidth', 1);
%         % Plot mean+std vertical line
%         plot([mean(deltaManualRankings(:, idxComp))+std(deltaManualRankings(:, idxComp)) ...
%             mean(deltaManualRankings(:, idxComp))+std(deltaManualRankings(:, idxComp))], ylim, '-.g', 'LineWidth', 1);
%         legend("", "95%", "mean", "mean+std");
%     end
%     idxComp = idxComp + 1;
% end
% % 

%% Signed Histograms
binWidth = 1;
% Loop on all manual rankings
% for m = 2:size(manualRankings, 2)
%     % Loop on all algorithm rankings
%     for n = 2:size(testedRankings, 2)
%         figure;
% %         subplot(row, col, idxFig);
%         idxFig = idxFig + 1;
%         % Plot signed rank difference normalized histogram
%         h = histogram(deltaRankingsSigned(n-1).R(:, m-1), 'Normalization', 'probability', 'BinWidth', binWidth,'HandleVisibility','off');
%         hold on;
%         title('Difference between manual and automated rankings', 'Interpreter', 'latex', 'FontSize', 16);
% %         title([char(testedRankings.Properties.VariableNames(n)) ': Rank Difference Histogram with ' ...
% %             char(manualRankings.Properties.VariableNames(m))], 'Interpreter', 'latex', 'FontSize', 16);
%         xlabel("Rank Difference", 'Interpreter', 'latex', 'FontSize', 14);
%         ylabel("Relative Frequency", 'Interpreter', 'latex', 'FontSize', 14);
%         grid on;
%         xlim([-200 200]);
%         ylim([0 0.08]);
%         % Find 97.5 percentil
%         prctil975 = find(cumsum(h.Values) >= 0.975, 1);
%         hist975(n-1).R(m-1) = h.BinEdges(prctil975);
%         % Plot 97.5 percentil vertical line
% %         plot([hist975(n-1).R(m-1) hist975(n-1).R(m-1)], ylim, ':m', 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5);
%         % Find 2.5 percentil
%         prctil025 = find(cumsum(h.Values) >= 0.025, 1);
%         hist025(n-1).R(m-1) = h.BinEdges(prctil025);
%         % Plot 2.5 percentil vertical line
% %         plot([hist025(n-1).R(m-1) hist025(n-1).R(m-1)], ylim, ':m', 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5);
% %         % Plot mean vertical line
% %         plot([mean(deltaRankingsSigned(n-1).R(:, m-1)) mean(deltaRankingsSigned(n-1).R(:, m-1))], ylim, '--r', 'LineWidth', 1);
% %         % Plot mean+std vertical line
% %         plot([mean(deltaRankingsSigned(n-1).R(:, m-1))+std(deltaRankingsSigned(n-1).R(:, m-1)) ...
% %             mean(deltaRankingsSigned(n-1).R(:, m-1))+std(deltaRankingsSigned(n-1).R(:, m-1))], ylim, '-.g', 'LineWidth', 1);
% %         % Plot mean-std vertical line
% %         plot([mean(deltaRankingsSigned(n-1).R(:, m-1))-std(deltaRankingsSigned(n-1).R(:, m-1)) ...
% %             mean(deltaRankingsSigned(n-1).R(:, m-1))-std(deltaRankingsSigned(n-1).R(:, m-1))], ylim, '-.g', 'LineWidth', 1);
% %         legend("97.5%", "2.5%", "mean", "mean+std", "mean-std");
%     end
% end


  figure;
%         subplot(row, col, idxFig);
        idxFig = idxFig + 1;
        % Plot signed rank difference normalized histogram
        h = histogram(deltaRankingsSigned(1).R(:, 1), 'Normalization', 'probability', 'BinWidth', binWidth,'HandleVisibility','off');
        hold on;
        xlabel('Différence rangs classements  automatique et expert 1', 'FontSize', 14);
        ylabel("Fréquence relative", 'FontSize', 14);
        grid on;
        xlim([-200 200]);
        ylim([0 0.08]);
        
          figure;
%         subplot(row, col, idxFig);
        idxFig = idxFig + 1;
        % Plot signed rank difference normalized histogram
        h = histogram(deltaRankingsSigned(1).R(:, 2), 'Normalization', 'probability', 'BinWidth', binWidth,'HandleVisibility','off');
        hold on;
        xlabel('Différence rangs classements  automatique et expert 2', 'FontSize', 14);
        ylabel("Fréquence relative", 'FontSize', 14);
        grid on;
        xlim([-200 200]);
        ylim([0 0.08]);


idxComp = 1;
% % Loop on all manual rankings
% for m = 2:size(manualRankings, 2)
%     % Loop on all other manual rankings
%     for n = m+1:size(manualRankings, 2)
%         figure;
% %         subplot(row, col, idxFig);
%         idxFig = idxFig + 1;
%         % Plot signed rank difference normalized histogram
%         h = histogram(deltaManualRankingsSigned(:, idxComp), 'Normalization', 'probability', 'BinWidth', binWidth,'HandleVisibility','off');
%         hold on;
% %         title(['Rank Difference Histogram between ' ...
% %             char(manualRankings.Properties.VariableNames(m)) ' and ' char(manualRankings.Properties.VariableNames(n))], ...
% %             'Interpreter', 'latex', 'FontSize', 16);
% %         title([char(testedRankings.Properties.VariableNames(n)) ': Rank Difference Histogram with ' ...
% %             char(manualRankings.Properties.VariableNames(m))], 'Interpreter', 'latex', 'FontSize', 16);
%         xlabel('Différence rangs classements des experts 1 et 2', 'FontSize', 14);
%         ylabel("Fréquence relative", 'FontSize', 14);
%         grid on;
%         xlim([-200 200]);
%         ylim([0 0.08]);
%         % Find 97.5 percentil
%         prctil975 = find(cumsum(h.Values) >= 0.975, 1);
%         hist975(n-1).R(m-1) = h.BinEdges(prctil975);
%         % Plot 97.5 percentil vertical line
% %         plot([hist975(n-1).R(m-1) hist975(n-1).R(m-1)], ylim, ':m', 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5);
%         % Find 2.5 percentil
%         prctil025 = find(cumsum(h.Values) >= 0.025, 1);
%         hist025(n-1).R(m-1) = h.BinEdges(prctil025);
%         % Plot 2.5 percentil vertical line
% %         plot([hist025(n-1).R(m-1) hist025(n-1).R(m-1)], ylim, ':m', 'Color', [0.4660 0.6740 0.1880], 'LineWidth', 1.5);
%         % Plot mean vertical line
% %         plot([mean(deltaManualRankingsSigned(:, idxComp)) mean(deltaManualRankingsSigned(:, idxComp))], ylim, '--r', 'LineWidth', 1);
%         % Plot mean+std vertical line
% %         plot([mean(deltaManualRankingsSigned(:, idxComp))+std(deltaManualRankingsSigned(:, idxComp)) ...
% %             mean(deltaManualRankingsSigned(:, idxComp))+std(deltaManualRankingsSigned(:, idxComp))], ylim, '-.g', 'LineWidth', 1);
%         % Plot mean-std vertical line
% %         plot([mean(deltaManualRankingsSigned(:, idxComp))-std(deltaManualRankingsSigned(:, idxComp)) ...
% %             mean(deltaManualRankingsSigned(:, idxComp))-std(deltaManualRankingsSigned(:, idxComp))], ylim, '-.g', 'LineWidth', 1);
% %         legend( "97.5%", "2.5%", "mean", "mean+std", "mean-std");
%     end
%     idxComp = idxComp + 1;
% end


%% Correlations
% Loop on all manual rankings
% for n = 1:size(manualRankingsRanks, 2)
%     for m = 1:size(manualRankingsRanks(n).R, 2)
%         figure;
% %         subplot(row, col, idxFig);
%         idxFig = idxFig + 1;
%         plot(1:nbMicroglia, manualRankingsRanks(n).R(:, m), '+');
%         hold on;
%         xlabel("Algorithm Rank", 'Interpreter', 'latex', 'FontSize', 14);
%         ylabel([char(manualRankings.Properties.VariableNames(m+1)) ' Rank'], 'Interpreter', 'latex', 'FontSize', 14);
% 
%         title(['Rank correlation with manual ranking, R = ' num2str(corr(2,1))], 'Interpreter', 'latex', 'FontSize', 16);
%         grid on;
% %         p = polyfit(1:nbMicroglia, manualRankingsRanks(n).R(:, m), 1); % MATLAB 2022a
%         p = polyfit(1:nbMicroglia, manualRankingsRanks(n).R(:, m)', 1); % MATLAB 2018a
%         f = polyval(p, 1:nbMicroglia);
%         plot(1:nbMicroglia, f, 'r--', 'LineWidth', 1);
% 
%     end
% end
%     test=corr(1:nbMicroglia, manualRankingsRanks(n).R(:, m)','Type','Kendall')


[corrKendall_Exp2,pval_Exp2k] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 2),'Type','Kendall');
[corrPearson_Exp2,pval_Exp2p] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 2),'Type','Spearman');
[corrKendall_Exp1,pval_Exp1k] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 1),'Type','Kendall');
[corrPearson_Exp1,pval_Exp1p] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 1),'Type','Spearman');
[corrKendall_Exp1Exp2,pval_Exp12k] = corr(manualRankingsRanks(1).R(:, 2), manualRankingsRanks(1).R(:, 1),'Type','Kendall');
[corrPearson_Exp1Exp2,pval_Exp12p] = corr(manualRankingsRanks(1).R(:, 2), manualRankingsRanks(1).R(:, 1),'Type','Spearman');


    figure;
%     subplot(row, col, idxFig);
    idxFig = idxFig + 1;
    plot(manualRankingsRanks(1).R(:, 1), manualRankingsRanks(1).R(:, 2), 'x');
    hold on;
    xlabel('Rangs classement Expert 2', 'FontSize', 14);
    ylabel('Rangs classement Expert 1', 'FontSize', 14);
    grid on;
    p = polyfit(manualRankingsRanks(1).R(:, 1), manualRankingsRanks(1).R(:, 2), 1);
    f = polyval(p, 1:nbMicroglia);
    plot(1:nbMicroglia, f, 'r--', 'LineWidth', 1);
    title(['Spearman R=' num2str(corrPearson_Exp1Exp2) ' ; Kendall R=' num2str(corrKendall_Exp1Exp2)]);

        figure;
%         subplot(row, col, idxFig);
        idxFig = idxFig + 1;
        plot(1:nbMicroglia, manualRankingsRanks(1).R(:, 1), 'x');
        hold on;
        xlabel('Rangs classement automatique', 'FontSize', 14);
        ylabel('Rangs classement Expert 1', 'FontSize', 14);
        grid on;
%         p = polyfit(1:nbMicroglia, manualRankingsRanks(n).R(:, m), 1); % MATLAB 2022a
        p = polyfit(1:nbMicroglia, manualRankingsRanks(1).R(:, 1)', 1); % MATLAB 2018a
        f = polyval(p, 1:nbMicroglia);
        plot(1:nbMicroglia, f, 'r--', 'LineWidth', 1);
        title(['Spearman R=' num2str(corrPearson_Exp1) ' ; Kendall R=' num2str(corrKendall_Exp1)]);
        
        figure;
%         subplot(row, col, idxFig);
        idxFig = idxFig + 1;
        plot(1:nbMicroglia, manualRankingsRanks(1).R(:, 2), 'x');
        hold on;
        xlabel('Rangs classement automatique', 'FontSize', 14);
        ylabel('Rangs classement Expert 2', 'FontSize', 14);
        grid on;
%         p = polyfit(1:nbMicroglia, manualRankingsRanks(n).R(:, m), 1); % MATLAB 2022a
        p = polyfit(1:nbMicroglia, manualRankingsRanks(1).R(:, 2)', 1); % MATLAB 2018a
        f = polyval(p, 1:nbMicroglia);
        plot(1:nbMicroglia, f, 'r--', 'LineWidth', 1);
        title(['Spearman R=' num2str(corrPearson_Exp2) ' ; Kendall R=' num2str(corrKendall_Exp2)]);

        


% FolderName = 'E:\DATA\DATA Axioscan Scanner\Alzheimer_Serge_brains\8_PR2\results';   % Your destination folder
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% for iFig = 1:length(FigList)
%   FigHandle = FigList(iFig);
%   FigName   = ['Fig' num2str(iFig)];
% %   savefig(FigHandle, fullfile(FolderName, [FigName '.fig']));
%   saveas(FigHandle, fullfile(FolderName,  [FigName '.png']));
% %   saveas(FigHandle,filename,formattype)
% end



[corrKendall_Exp2,pval_Exp2k] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 2),'Type','Kendall')
[corrPearson_Exp2,pval_Exp2p] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 2),'Type','Spearman')
[corrKendall_Exp1,pval_Exp1k] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 1),'Type','Kendall')
[corrPearson_Exp1,pval_Exp1p] = corr((1:nbMicroglia)', manualRankingsRanks(1).R(:, 1),'Type','Spearman')
[corrKendall_Exp1Exp2,pval_Exp12k] = corr(manualRankingsRanks(1).R(:, 2), manualRankingsRanks(1).R(:, 1),'Type','Kendall')
[corrPearson_Exp1Exp2,pval_Exp12p] = corr(manualRankingsRanks(1).R(:, 2), manualRankingsRanks(1).R(:, 1),'Type','Spearman')

%% Save all open figures in the saving file
savingPath=uigetdir;
FigList = findobj(allchild(0),'flat','Type','figure');
for iFig = 1:length(FigList)
 FigHandle = FigList(iFig);
 FigName =['Fig' num2str(iFig)];
 saveas(FigHandle, fullfile(savingPath,[FigName '.png']));
 saveas(FigHandle, fullfile(savingPath,[FigName '.fig']));
end

