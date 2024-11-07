%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRAVEHEART - Open source software for electrocardiographic and vectorcardiographic analysis
% beats_to_listbox.m -- Part of BRAVEHEART GUI
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


% Takes annotation output and formats for listbox in GUI

function listbox_beats = beats_to_listbox(ppeak, qon, rpeak, qoff, toff)

% pull qon_out each beat into a new row in matrx "beat" for display in listbox

beat_dim = max([length(ppeak), length(qon), length(rpeak), length(qoff), length(toff)], [], 2); %account for differences in number of fiducual points if some QRST cut off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%add padding if number of all fiducial points not same (due to cut off)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fill beats array with Qon, Rpk, Qoff, Toff values for each beat.
beats = zeros(beat_dim,5);
beats = [ppeak(:), qon(:), rpeak(:), qoff(:), toff(:)];

% Initialize cell array.
listbox_beats = cell(size(beats, 1), 1);
% Fill array row by row with 4 entries per row and space between entries.
for i = 1:size(beats, 1)
    rowStr = ''; 
    for j = 1:size(beats, 2)
        % If < 1000 add 2 leading spaces to right align value in column.
        if beats(i, j) < 1000
            rowStr = [rowStr sprintf('  %d  ', beats(i, j))];
        else
            if j == 4
                rowStr = [rowStr sprintf(' %d  ', beats(i, j))];
            else
                rowStr = [rowStr sprintf('%d  ', beats(i, j))];
            end
        end
    end
    listbox_beats{i} = rowStr; % Add the formatted row to the cell array
end
listbox_beats = strjoin(listbox_beats, '\n');
%listbox_beats = num2str(beats); % Old code


