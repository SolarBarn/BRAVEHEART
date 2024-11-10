%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRAVEHEART - Open source software for electrocardiographic and vectorcardiographic analysis
% load_ecg.m -- Load BIDMC and Prucka format ECGs
% Copyright 2016-2024 Hans F. Stabenau and Jonathan W. Waks
% 
% Source code/executables: https://github.com/BIVectors/BRAVEHEART
% Contact: braveheart.ecg@gmail.com
% 
% BRAVEHEART is free software: you can redistribute it and/or modify it under the terms of the GNU 
% General Public License as published by the Free Software Foundation, either version 3 of the License, 
% or (at your option) any later version.
%
% BRAVEHEART is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along with this program. 
% If not, see <https://www.gnu.org/licenses/>.
%
% This software is for research purposes only and is not intended to diagnose or treat any disease.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%% LOAD ECG FUNCTION %%%
%%%%%%%%%%%%%%%%%%%%%%%%%

function [I, II, III, avR, avL, avF, V1, V2, V3, V4, V5, V6] =...
    load_rdt(filename, unitspermv)

% shouldn't pass hObject around to subroutines
% handles = guidata(hObject);

 fid = fopen(filename, 'rb');  % Open the file in binary read mode
  if fid == -1
      error('read_packed_ecg_data: Couldn''t open %s', filename);
  end

  try
    ecg_data = fread(fid, [12, Inf], 'int16'); % Read as 12-column int16
    ecg_data = ecg_data'; % Transpose

    % Assign to individual lead arrays and scale
    % divide each lead by x units per 1 mV (1 mv = 409.6 units)
    I = ecg_data(:, 1) / unitspermv; 
    II = ecg_data(:, 2) / unitspermv;
    III = ecg_data(:, 3) / unitspermv;
    avR = ecg_data(:, 4) / unitspermv;
    avL = ecg_data(:, 5) / unitspermv; 
    avF = ecg_data(:, 6) / unitspermv;
    V1 = ecg_data(:, 7) / unitspermv;
    V2 = ecg_data(:, 8) / unitspermv;
    V3 = ecg_data(:, 9) / unitspermv;
    V4 = ecg_data(:, 10) / unitspermv;
    V5 = ecg_data(:, 11) / unitspermv;
    V6 = ecg_data(:, 12) / unitspermv; 
  catch ME
    fclose(fid);
    rethrow(ME);
  end
  fclose(fid);
end

