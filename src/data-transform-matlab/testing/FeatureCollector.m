% 11. 11. 2020, Lukas Vareka
classdef FeatureCollector < handle
   properties
      Features
      Labels
      counter
      Participant_id
   end
   methods
       function FC = FeatureCollector(nfeatures)
           FC.Features = cell(nfeatures, 1);
           FC.Labels   = cell(nfeatures, 1);
           FC.counter = 1;
           FC.Participant_id = cell(nfeatures, 1);
       end
       
       % Cuts out epoch/feature from the EEG data
       % from the current event location to the next level 
       % location.
       function addFeature(FC, event, eegData, i, participant_id)
          % e.g. a reported picture (house / face)
          startTime = event(i).latency;
          currentLabel = event(i).type;
          % onset of another event
          % while strcmp(event(i + 1).type, 'Neut') 
          while i < size(event, 2) && ~strcmp(event(i + 1).type, 'Neut') 
              i = i + 1;
          end
          % event(i + 1).type
          
          if i + 1 <= size(event, 2)
          
            endTime   = event(i + 1).latency;
            feature   = eegData(:, startTime:endTime);
            FC.Labels{FC.counter} = currentLabel;
            FC.Features{FC.counter} = feature;
            FC.Participant_id{FC.counter} = participant_id;
            FC.counter = FC.counter + 1;
          end
      end
      
   end
end