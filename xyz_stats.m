%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRAVEHEART - Open source software for electrocardiographic and vectorcardiographic analysis
% xyz_stats.m -- Visualize statistics for each beat in the X, Y, Z leads
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

function  [svg_x, svg_y, svg_z, sai_x, sai_y, sai_z, sai_vm] = xyz_stats(n, hObject, eventdata, handles)

% n=1 -- X
% n=2 -- Y
% n=3 -- Z
% n=4 -- VM

% Arrange plots in 2 rows of 6 columns.
r = 2;
c = 6;

aps = pull_guiparams(hObject, eventdata, handles); 

beatsig = handles.beatsig_vcg;
medianvcg = handles.median_vcg;
medianbeat = handles.medianbeat;
lead = [{'X'} {'Y'} {'Z'} {'VM'}];

beats = handles.beats;
vcg = handles.vcg;

% assign current listbox beats to prior fiducial points Q, QRS, S, Tend
P = beats.P;
Q = beats.Q;
R = beats.QRS;
S =  beats.S;
Tend = beats.Tend;

sample_time = 1000/vcg.hz;

N = length(R);

for i=1:N

    if isnan(Tend(i))   
        sai_x(i) = nan;
        sai_y(i) = nan;
        sai_z(i) = nan;
        sai_vm(i) = nan;
    else
        [sai_x(i), sai_y(i), sai_z(i), sai_vm(i)] = saiqrst(vcg.X(Q(i):Tend(i)), vcg.Y(Q(i):Tend(i)), vcg.Z(Q(i):Tend(i)), vcg.VM(Q(i):Tend(i)), sample_time, aps.baseline_flag);
    end
end

for i=1:N

    if isnan(Tend(i))   
        svg_x(i) = nan;
        svg_y(i) = nan;
        svg_z(i) = nan;
    else
        svg_x(i) = sample_time*(trapz(vcg.X(Q(i):Tend(i))));
        svg_y(i) = sample_time*(trapz(vcg.Y(Q(i):Tend(i))));
        svg_z(i) = sample_time*(trapz(vcg.Z(Q(i):Tend(i))));
    end
end

switch n
    case 1
        lead_str = 'X';
        svg = svg_x;
        sai = sai_x;
    case 2
        lead_str = 'Y'; 
        svg = svg_y;
        sai = sai_y;
    case 3
        lead_str = 'Z';
        svg = svg_z;
        sai = sai_z;
    case 4
        lead_str = 'VM';
        svg = svg_z;
        sai = sai_vm;
end

% GRAPH

% Common width and height multpliers for PR, QRS, QT, SVG, SAI graphs.
mw = 0.85; mh = 0.98;
figure('name',sprintf('Lead %s Data',lead_str),'numbertitle','off');
sgtitle(sprintf('Lead %s Data',lead_str),'fontsize',14,'fontweight','bold');

pr_dur = handles.sample_time * (R - P);

% PR Duration for Each Beat
subplot(r,c,1) 
p1 = plot(pr_dur, 'color','k','linewidth',2,'displayname','PR Duration' );
hold on;
p2 = line([1 length(pr_dur)],[median(pr_dur) median(pr_dur)], 'color', 'k','linewidth',2,'linestyle','--','displayname','Median PR Dur');
p3 = line([1 length(pr_dur)],[prctile(pr_dur,25) prctile(pr_dur,25)], 'color', 'k','linewidth',1,'linestyle',':','displayname','25th-75th %-ile');
p4 = line([1 length(pr_dur)],[prctile(pr_dur,75) prctile(pr_dur,75)], 'color', 'k','linewidth',1,'linestyle',':');
legend([p1 p2 p3],'location','northeast')
xlabel('Beat #','FontWeight','bold','FontSize',12)
ylabel('PR Duration (ms)','FontWeight','bold','FontSize',12)
title('PR Duration for Each Beat')
xlim([1 length(pr_dur)])
xticks(1:1:N)
hold off;
% Get the handle to the current axes
ax = gca;
% Adjust the axes position
outerpos = ax.OuterPosition;
bottom = 0.96*outerpos(2);
left = 0.30*outerpos(1); % Smaller moves plot to left.
width = mw*outerpos(3);
height = mh*outerpos(4);
ax.OuterPosition = [left bottom width height];

qrs_dur = handles.sample_time * (S - Q);

% QRS Duration for Each Beat
subplot(r,c,2) 
p1 = plot(qrs_dur, 'color','k','linewidth',2,'displayname','QRS Duration' );
hold on;
p2 = line([1 length(qrs_dur)],[median(qrs_dur) median(qrs_dur)], 'color', 'k','linewidth',2,'linestyle','--','displayname','Median QRS Dur');
p3 = line([1 length(qrs_dur)],[prctile(qrs_dur,25) prctile(qrs_dur,25)], 'color', 'k','linewidth',1,'linestyle',':','displayname','25th-75th %-ile');
p4 = line([1 length(qrs_dur)],[prctile(qrs_dur,75) prctile(qrs_dur,75)], 'color', 'k','linewidth',1,'linestyle',':');
legend([p1 p2 p3],'location','northeast')
xlabel('Beat #','FontWeight','bold','FontSize',12)
ylabel('QRS Duration (ms)','FontWeight','bold','FontSize',12)
title('QRS Duration for Each Beat')
xlim([1 length(qrs_dur)])
xticks(1:1:N)
hold off;
% Get the handle to the current axes
ax = gca;
% Adjust the axes position
outerpos = ax.OuterPosition;
bottom = 0.96*outerpos(2);
left = 0.97*outerpos(1);
width = mw*outerpos(3);
height = mh*outerpos(4);
ax.OuterPosition = [left bottom width height];

qt_dur = handles.sample_time * (Tend - Q);

% QT Interval for Each Beat
subplot(r,c,3) 
p1 = plot(qt_dur, 'color','m','linewidth',2,'displayname','QT Interval' );
hold on;
p2 = line([1 length(qt_dur)],[median(qt_dur) median(qt_dur)], 'color', 'm','linewidth',2,'linestyle','--','displayname','Median QT Interval');
p3 = line([1 length(qt_dur)],[prctile(qt_dur,25) prctile(qt_dur,25)], 'color', 'm','linewidth',1,'linestyle',':','displayname','25th-75th %-ile');
p4 = line([1 length(qt_dur)],[prctile(qt_dur,75) prctile(qt_dur,75)], 'color', 'm','linewidth',1,'linestyle',':');
legend([p1 p2 p3],'location','northeast')
xlabel('Beat #','FontWeight','bold','FontSize',12)
ylabel('QT Interval (ms)','FontWeight','bold','FontSize',12)
title('QT Interval for Each Beat')
xlim([1 length(qt_dur)])
xticks(1:1:N)
hold off;
% Get the handle to the current axes
ax = gca;
% Adjust the axes position
outerpos = ax.OuterPosition;
bottom = 0.96*outerpos(2);
left = 1.08*outerpos(1);
width = mw*outerpos(3);
height = mh*outerpos(4);
ax.OuterPosition = [left bottom width height];

% SVG for Each Beat in Lead
subplot(r,c,8) 
p1 = plot(svg, 'color','r','linewidth',2,'displayname',strcat('SVG',lower(lead_str)));
hold on;
p2 = line([1 length(svg)],[median(svg) median(svg)], 'color', 'r','linewidth',2,'linestyle','--','displayname',strcat('Median SVG',lower(lead_str)));
p3 = line([1 length(svg)],[prctile(svg,25) prctile(svg,25)], 'color', 'r','linewidth',1,'linestyle',':','displayname','25th-75th %-ile');
p4 = line([1 length(svg)],[prctile(svg,75) prctile(svg,75)], 'color', 'r','linewidth',1,'linestyle',':');
legend([p1 p2 p3],'location','northeast')
xlabel('Beat #','FontWeight','bold','FontSize',12)
ylabel('SVG (mV*ms)','FontWeight','bold','FontSize',12)
title(strcat('SVG for Each Beat in Lead','{ }', lead_str))
xlim([1 length(svg)])
xticks(1:1:N)
hold off;
% Get the handle to the current axes
ax = gca;
% Adjust the axes position
outerpos = ax.OuterPosition;
bottom = 1.2*outerpos(2);
left = 0.95*outerpos(1);
width = mw*outerpos(3);
height = mh*outerpos(4);
ax.OuterPosition = [left bottom width height];

% SAI for Each Beat in Lead
subplot(r,c,9) 
p1 = plot(sai, 'color','b','linewidth',2,'displayname',strcat('SAI',lower(lead_str)));
hold on;
p2 = line([1 length(sai)],[median(sai) median(sai)], 'color', 'b','linewidth',2,'linestyle','--','displayname',strcat('Median SAI',lower(lead_str)));
p3 = line([1 length(sai)],[prctile(sai,25) prctile(sai,25)], 'color', 'b','linewidth',1,'linestyle',':','displayname','25th-75th %-ile');
p4 = line([1 length(sai)],[prctile(sai,75) prctile(sai,75)], 'color', 'b','linewidth',1,'linestyle',':');
legend([p1 p2 p3],'location','northeast')
xlabel('Beat #','FontWeight','bold','FontSize',12)
ylabel('SAI (mV*ms)','FontWeight','bold','FontSize',12)
title(strcat('SAI for Each Beat in Lead','{ }', lead_str))
xlim([1 length(sai)])
xticks(1:1:N)
hold off;
% Get the handle to the current axes
ax = gca;
% Adjust the axes position
outerpos = ax.OuterPosition;
bottom = 1.2*outerpos(2);
left = 1.08*outerpos(1);
width = 0.85*outerpos(3);
height = 0.98*outerpos(4);
ax.OuterPosition = [left bottom width height];

% Main large plot on right showing Median Beat Lead X,Y,Z or VM. 
subplot(r,c,[4 5 6 10 11 12]) % Use 4 slots on the right for this bigger plot of the Median Beat Lead
hold on;
p1 = plot(medianvcg.(lead{n}),'linewidth',3,'color','[0 0.8 0]','displayname',sprintf('Median Beat Lead %s',string(lead{n})));

p2 = plot(beatsig.(lead{n})(1,:),'linestyle',':','color','k','displayname','Individual Beats');
for j = 2:size(beatsig.(lead{n}),1)
    plot(beatsig.(lead{n})(j,:),'linestyle',':','color','k');
end

pz = line([0 length(medianvcg.(lead{n}))],[0 0],'linestyle','-','color','k','displayname','Zero Voltge');

yL = ylim;
pq = line([medianbeat.Q medianbeat.Q],[yL(1) yL(2)],'linestyle','--','color','k','displayname','QRS on','linewidth',2);
ps = line([medianbeat.S medianbeat.S],[yL(1) yL(2)],'linestyle','--','color','b','displayname','QRS off','linewidth',2);
pt = line([medianbeat.Tend medianbeat.Tend],[yL(1) yL(2)],'linestyle','--','color','r','displayname','Toff','linewidth',2);
aqua = [1. 0. 1.];
marker = 'd';
if ~isnan(medianbeat.P)
    x = int32(medianbeat.P);
   	pm = plot(x, medianvcg.(lead{n})(x),marker,'color',aqua,'MarkerSize', 6, 'LineWidth', 2, 'displayname','P, R, T Peak');
end
if ~isnan(medianbeat.QRS)
    x = int32(medianbeat.QRS);
	plot(x, medianvcg.(lead{n})(x),marker,'color',aqua,'MarkerSize', 6, 'LineWidth', 2);
end
if ~isnan(medianbeat.T)
    x = int32(medianbeat.T);
	plot(x, medianvcg.(lead{n})(x),marker,'color',aqua,'MarkerSize', 6, 'LineWidth', 2);
end

if n ~= 4
    text(medianbeat.S+5, min(medianvcg.(lead{n})),sprintf('Cross Correlation = %0.3f',round(handles.correlation_test.(lead{n}),3)),'FontWeight','bold','FontSize',12);
end

xlim([0 length(medianvcg.(lead{n}))])
legend([p1 p2 pz pq ps pt pm],'location','northeast')

xlabel('Samples','FontWeight','bold','FontSize',12);
ylabel('mV','FontWeight','bold','FontSize',12)
title(sprintf('Median Beat Lead %s',string(lead{n})));

set(gcf, 'Position', [0, 0, 1600, 700])  % set figure size
% Get the handle to the current axes
ax = gca;
% Adjust the axes position
outerpos = ax.OuterPosition;
bottom = outerpos(2); % At bottom limit already. Cannot go lower.
left = 1.02*outerpos(1);
width = 1.15*outerpos(3);
height = 0.98*outerpos(4);
ax.OuterPosition = [left bottom width height];

% Increase font size on mac due to pc/mac font differences
    if ismac
        fontsize(gcf,scale=1.25)
    end

end


