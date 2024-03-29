% 11. 11. 2020, Lukas Vareka
classdef FeatureCollector < handle
   properties
      Features
      Labels
      Participant_id
      counter
   end
   methods
       function FC = FeatureCollector(nfeatures)
           FC.Features = cell(nfeatures, 1);
           FC.Labels   = cell(nfeatures, 1);
           FC.Participant_id = cell(nfeatures, 1);
           FC.counter = 1;
       end
       
       % Cuts out epoch/feature from the EEG data
       % from the curremt event location to the next level 
       % location.
       function addFeature(FC, event, eegData, i, participant_id)
          % e.g. a reported picture (house / face)
          startTime = event(i).latency;
          FC.Labels{FC.counter} = event(i).type;
          FC.Participant_id{FC.counter} = participant_id;
          % onset of another event
          % while strcmp(event(i + 1).type, 'Neut') 
          while strcmp(event(i + 1).type, 'Neut')
              i = i + 1;
          end
          % event(i + 1).type
          endTime   = event(i + 1).latency;
          feature   = eegData(:, startTime:endTime);
          FC.Features{FC.counter} = feature;
          FC.counter = FC.counter + 1;
      end
      
   end
end