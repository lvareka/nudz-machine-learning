% Count stimuli and
% store etracted epochs
% Input:
% - dataRaw - preprocessed data with events
% - featureCollector - handle to feature (epoch) collecting class
% Output:
% - countXYZ - number of XYZ events in all datasets
% 11. 11. 2020, Lukas Vareka
function [countHouse, countFace, countHRep, countFRep] = countStimuli(dataRaw, featureCollector)

    countHouse = 0;
    countFace = 0;
    countHRep = 0;
    countFRep = 0;
    dataRaw = dataRaw{1, 1};
    eegData = dataRaw.trial{1, 1};
    for i=1:length(dataRaw.event)
       % if strcmp(EEG.event(i).type,'SFix')
       %     break;
       % end
        if strcmp(dataRaw.event(i).type, 'Hous')
            if strcmp(dataRaw.event(i - 1).type, 'HRep')
                countHouse = countHouse + 1;
                featureCollector.addFeature(dataRaw.event, eegData, i)
                
            end
        end
        if strcmp(dataRaw.event(i).type,'Face')
            if strcmp(dataRaw.event(i - 1).type, 'FRep')
                countFace = countFace + 1;
                featureCollector.addFeature(dataRaw.event, eegData, i)
            end
        end
        if strcmp(dataRaw.event(i).type, 'HRep')
            countHRep = countHRep + 1;
        end
        if strcmp(dataRaw.event(i).type,'FRep')
            countFRep = countFRep + 1;
        end
    end

    %countHouse
    %countFace
    %countHRep
    %countFRep
