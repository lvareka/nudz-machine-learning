
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
        if strcmp(dataRaw.event(i).type,'StFL')
            testingPhase = 1;
        end
       
        % Hous - subjects reports seeing the house
        if testingPhase == 1 && strcmp(dataRaw.event(i).type, 'Hous')
            countHouse = countHouse + 1;
            featureCollector.addFeature(dataRaw.event, eegData, i);
        end
        
        % Face - subjects reports seeing the face
        if testingPhase == 1 && strcmp(dataRaw.event(i).type,'Face')
            countFace = countFace + 1;
            featureCollector.addFeature(dataRaw.event, eegData, i)
        end
    end

    countHouse
    countFace
    %countHRep
    %countFRep
