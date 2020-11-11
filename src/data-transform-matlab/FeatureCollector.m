% 11. 11. 2020, Lukas Vareka
classdef FeatureCollector < handle
   properties
      Features
      Labels
      counter
   end
   methods
       function FC = FeatureCollector(nfeatures)
           FC.Features = cell(nfeatures, 1);
           FC.Labels   = cell(nfeatures, 1);
           FC.counter = 1;
       end
       
       % Cuts out epoch/feature from the EEG data
       % from the curremt event location to the next level 
       % location.
       function addFeature(FC, event, eegData, i)
          % e.g. a reported picture (house / face)
          startTime = event(i).latency;
          % onset of another event
          endTime   = event(i + 1).latency;
          feature   = eegData(:, startTime:endTime);
          FC.Features{FC.counter} = feature;
          FC.Labels{FC.counter} = event(i).type;
          FC.counter = FC.counter + 1;
      end
      
   end
end