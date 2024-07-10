%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BRAVEHEART - Open source software for electrocardiographic and vectorcardiographic analysis
% normal_ranges.m -- Calculate normal ranges based on age, gender, BMI, race
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

function vals = normal_ranges(c_age, male, c_bmi, c_hr, white)

% Split continuous variables into groups"

% Age
age1 = round(c_age);
if age1 <= 29 
    age = 1;
elseif age1 <= 39
    age = 2;
elseif age1 <= 49
    age = 3;
elseif age1 <= 59
    age = 4;
elseif age1 <= 69
    age = 5;
else 
    age = 6;
end

% BMI
bmi1 = round(c_bmi);
if bmi1 <= 20
    bmi = 1;
elseif bmi1 <= 30
    bmi = 2;
elseif bmi1 <= 40
    bmi = 3;
elseif bmi1 <= 50
    bmi = 4;
else 
    bmi = 5;
end

% HR
hr1 = round(c_hr);
if hr1 <= 60 
    hr = 1;
elseif hr1 <= 65
    hr = 2;
elseif hr1 <= 70
    hr = 3;
elseif hr1 <= 75 
    hr = 4;
elseif hr1 <= 80
    hr = 5;
else
    hr = 6;
end



% List the fieldnames you want to use here.  Keep consistent with
% covariance matrices, beta coefficients etc
fn = [{'svg_area_mag'}...
      {'svg_area_az'}...
      {'svg_area_el'}...
      {'sai_qrst'}...
      {'sai_vm'}...
      {'svg_x'}...
      {'svg_y'}...
      {'svg_z'}...
      {'qrst_angle_area'}...
      {'qrst_angle_peak'}...   
      ];

  
  

% Covarience matrices - (name as co.{fn})
co.svg_area_mag = ...
    [11.576208,.2817471,-.57506794,.68120474,-2.1045702,.21585539,-.29528546,.0078126453,-3.4489732;...
    .2817471,.072793603,.00082783011,.0049817939,.00021851108,.0092799999,-.00031998914,-.021567872,-.27100906;...
    -.57506794,.00082783011,.14325868,-.0010045795,.0076059904,.000038608279,.012399818,-.019047743,.0097832251;...
    .68120474,.0049817939,-.0010045795,.31495968,-.0002651652,-.016678728,.00038830977,.026172811,-.69423544;...
    -2.1045702,.00021851108,.0076059904,-.0002651652,.9648096,.000010190904,-.043079183,-.0050277738,.0025823452;...
    .21585539,.0092799999,.000038608279,-.016678728,.000010190904,.062513888,-.00001492363,-.0010058808,-.21535459;...
    -.29528546,-.00031998914,.012399818,.00038830977,-.043079183,-.00001492363,.11472404,.0073627071,-.0037816039;...
    .0078126453,-.021567872,-.019047743,.026172811,-.0050277738,-.0010058808,.0073627071,.49626034,-.25488725;...
    -3.4489732,-.27100906,.0097832251,-.69423544,.0025823452,-.21535459,-.0037816039,-.25488725,3.5758748];


co.svg_area_az = ...
    [7.9217367,.19280289,-.39352584,.46615648,-1.4401822,.14771241,-.20206735,.0053462861,-2.3601735;...
    .19280289,.049813528,.00056649395,.0034091007,.00014952973,.0063504139,-.00021897237,-.01475915,-.18545471;...
    -.39352584,.00056649395,.098033614,-.00068744569,.0052048694,.000026420104,.0084853424,-.013034596,.0066947769;...
    .46615648,.0034091007,-.00068744569,.21553065,-.0001814557,-.011413451,.00026572499,.017910365,-.47507355;...
    -1.4401822,.00014952973,.0052048694,-.0001814557,.66023064,6.9737562e-06,-.029479597,-.0034405654,.0017671294;...
    .14771241,.0063504139,.000026420104,-.011413451,6.9737562e-06,.042778995,-.000010212417,-.00068833615,-.14736971;...
    -.20206735,-.00021897237,.0084853424,.00026572499,-.029479597,-.000010212417,.078507021,.0050383876,-.0025877964;...
    .0053462861,-.01475915,-.013034596,.017910365,-.0034405654,-.00068833615,.0050383876,.33959684,-.17442237;...
    -2.3601735,-.18545471,.0066947769,-.47507355,.0017671294,-.14736971,-.0025877964,-.17442237,2.4470136];


co.svg_area_el = ...
    [2.9092562,.070806824,-.14452228,.17119588,-.52890664,.054247353,-.074209191,.0019634224,-.86677319;...
    .070806824,.018294008,.0002080448,.0012519916,.000054914763,.0023321884,-.000080417558,-.0054202951,-.068108208;...
    -.14452228,.0002080448,.036002826,-.00025246429,.0019114873,9.7027778e-06,.0031162405,-.0047869529,.0024586555;...
    .17119588,.0012519916,-.00025246429,.07915359,-.000066639572,-.0041915877,.00009758745,.0065775784,-.17447068;...
    -.52890664,.000054914763,.0019114873,-.000066639572,.24246958,2.5611107e-06,-.010826376,-.001263547,.00064897793;...
    .054247353,.0023321884,9.7027778e-06,-.0041915877,2.5611107e-06,.015710577,-3.7505081e-06,-.00025279133,-.054121494;...
    -.074209191,-.000080417558,.0031162405,.00009758745,-.010826376,-3.7505081e-06,.028831689,.0018503469,-.00095036777;...
    .0019634224,-.0054202951,-.0047869529,.0065775784,-.001263547,-.00025279133,.0018503469,.12471687,-.064056583;...
    -.86677319,-.068108208,.0024586555,-.17447068,.00064897793,-.054121494,-.00095036777,-.064056583,.89866525];


co.sai_qrst = ...
    [28.52,.69413298,-1.4167799,1.6782662,-5.1849742,.53179729,-.72748703,.019247809,-8.4971447;...
    .69413298,.17933969,.0020395033,.012273515,.00053834001,.022862893,-.00078834884,-.0531362,-.66767794;...
    -1.4167799,.0020395033,.35294265,-.0024749562,.01873868,.000095118208,.030549107,-.046927422,.024102675;...
    1.6782662,.012273515,-.0024749562,.77595794,-.00065328059,-.041090947,.00095666863,.064481266,-1.7103697;...
    -5.1849742,.00053834001,.01873868,-.00065328059,2.376976,.000025107063,-.10613305,-.012386795,.0063620559;...
    .53179729,.022862893,.000095118208,-.041090947,.000025107063,.15401383,-.000036766956,-.0024781623,-.53056347;...
    -.72748703,-.00078834884,.030549107,.00095666863,-.10613305,-.000036766956,.2826426,.018139308,-.009316639;...
    .019247809,-.0531362,-.046927422,.064481266,-.012386795,-.0024781623,.018139308,1.2226236,-.62795901;...
    -8.4971447,-.66767794,.024102675,-1.7103697,.0063620559,-.53056347,-.009316639,-.62795901,8.8097887];


co.sai_vm = ...
    [11.29063,.27479661,-.56088144,.66439986,-2.0526516,.21053039,-.28800097,.0076199127,-3.3638895;...
    .27479661,.070997834,.00080740813,.0048588961,.00021312057,.0090510687,-.00031209522,-.021035807,-.26432344;...
    -.56088144,.00080740813,.13972458,-.00097979722,.0074183559,.000037655838,.012093923,-.018577848,.0095418794;...
    .66439986,.0048588961,-.00097979722,.30718985,-.00025862377,-.016267275,.00037873044,.025527146,-.67710912;...
    -2.0526516,.00021312057,.0074183559,-.00025862377,.94100839,9.9395011e-06,-.04201645,-.0049037421,.0025186404;...
    .21053039,.0090510687,.000037655838,-.016267275,9.9395011e-06,.060971711,-.000014555474,-.00098106638,-.21004194;...
    -.28800097,-.00031209522,.012093923,.00037873044,-.04201645,-.000014555474,.11189387,.007181074,-.0036883145;...
    .0076199127,-.021035807,-.018577848,.025527146,-.0049037421,-.00098106638,.007181074,.48401794,-.24859935;...
    -3.3638895,-.26432344,.0095418794,-.67710912,.0025186404,-.21004194,-.0036883145,-.24859935,3.4876604];


co.svg_x = ...
    [8.1207151,.19764572,-.40341043,.4778654,-1.4763567,.15142265,-.20714287,.005480574,-2.4194562;...
    .19764572,.051064745,.00058072316,.0034947305,.00015328561,.0065099238,-.00022447252,-.015129872,-.19011296;...
    -.40341043,.00058072316,.10049602,-.00070471293,.0053356057,.000027083724,.0086984774,-.013361999,.0068629365;...
    .4778654,.0034947305,-.00070471293,.22094436,-.00018601351,-.011700135,.00027239948,.018360239,-.48700646;...
    -1.4763567,.00015328561,.0053356057,-.00018601351,.67681432,7.1489235e-06,-.030220065,-.0035269856,.0018115161;...
    .15142265,.0065099238,.000027083724,-.011700135,7.1489235e-06,.043853518,-.000010468932,-.0007056258,-.15107134;...
    -.20714287,-.00022447252,.0086984774,.00027239948,-.030220065,-.000010468932,.080478959,.0051649422,-.0026527969;...
    .005480574,-.015129872,-.013361999,.018360239,-.0035269856,-.0007056258,.0051649422,.34812683,-.1788035;...
    -2.4194562,-.19011296,.0068629365,-.48700646,.0018115161,-.15107134,-.0026527969,-.1788035,2.5084777];


co.svg_y = ...
    [5.8064094,.14131908,-.28844333,.34167951,-1.0556129,.10826902,-.14810966,.0039186766,-1.7299404;...
    .14131908,.036511909,.00041522409,.0024987746,.00010960107,.0046546743,-.00016050057,-.010818041,-.13593307;...
    -.28844333,.00041522409,.071855873,-.00050387828,.0038150225,.00001936519,.0062195165,-.0095539903,.0049070823;...
    .34167951,.0024987746,-.00050387828,.15797788,-.0001330019,-.0083657373,.00019476892,.013127792,-.34821549;...
    -1.0556129,.00010960107,.0038150225,-.0001330019,.48393041,5.1115667e-06,-.021607712,-.0025218374,.001295256;...
    .10826902,.0046546743,.00001936519,-.0083657373,5.1115667e-06,.031355795,-7.4854133e-06,-.00050453097,-.10801783;...
    -.14810966,-.00016050057,.0062195165,.00019476892,-.021607712,-7.4854133e-06,.05754343,.003692996,-.0018967817;...
    .0039186766,-.010818041,-.0095539903,.013127792,-.0025218374,-.00050453097,.003692996,.2489149,-.12784667;...
    -1.7299404,-.13593307,.0049070823,-.34821549,.001295256,-.10801783,-.0018967817,-.12784667,1.7935919];


co.svg_z = ...
    [5.3285265,.12968816,-.26470369,.31355843,-.96873325,.099358201,-.13591984,.0035961594,-1.5875618;...
    .12968816,.033506885,.00038105008,.002293119,.00010058062,.0042715822,-.00014729095,-.0099276882,-.12474543;...
    -.26470369,.00038105008,.065941945,-.00046240777,.0035010362,.000017771385,.0057076341,-.0087676728,.0045032166;...
    .31355843,.002293119,-.00046240777,.1449759,-.00012205551,-.0076772156,.00017873892,.012047341,-.31955647;...
    -.96873325,.00010058062,.0035010362,-.00012205551,.44410169,4.6908713e-06,-.01982934,-.0023142835,.0011886531;...
    .099358201,.0042715822,.000017771385,-.0076772156,4.6908713e-06,.028775131,-6.8693444e-06,-.00046300676,-.099127688;...
    -.13591984,-.00014729095,.0057076341,.00017873892,-.01982934,-6.8693444e-06,.052807454,.0033890528,-.0017406717;...
    .0035961594,-.0099276882,-.0087676728,.012047341,-.0023142835,-.00046300676,.0033890528,.22842856,-.11732455;...
    -1.5875618,-.12474543,.0045032166,-.31955647,.0011886531,-.099127688,-.0017406717,-.11732455,1.6459745];

% If using quantile regression don't need covariance matrix - set to NaN to
% allow automatation based on fieldnames
co.qrst_angle_area = nan;
co.qrst_angle_peak = nan;   



% Beta values - name as b.{fn}
b.svg_area_mag = [38.956894,-3.4813516,-6.3153849,-.44348246,-5.9761524,-3.5411637,-6.2343812,-2.1312437,81.185043];
b.svg_area_az = [-23.343624,-.41728416,.22937952,3.0252025,6.4067001,1.2895213,1.0315948,.76632118,-9.9992952];
b.svg_area_el = [5.0798693,1.0138142,1.5156453,.85528189,.6908471,.20319526,-.32649627,.29313734,49.675583];
b.sai_qrst = [84.80442,-4.0725646,-11.311937,-.86309487,-12.042465,-5.0527554,-8.5148506,-1.3322045,147.46112];
b.sai_vm = [51.224781,-2.6136467,-7.0044708,-.39629233,-6.6887465,-3.2003117,-5.4938025,-1.00413,95.074677];
b.svg_x = [29.784565,-2.4342337,-4.5117497,.28912577,-3.2786264,-2.7615664,-5.0985417,-1.3738728,61.120914];
b.svg_y = [14.77791,-2.7108247,-4.4720597,-1.0042875,-4.0626445,-2.1012347,-2.6840453,-1.5666251,50.607204];
b.svg_z = [-29.848412,-.33165121,1.2167892,2.6165483,5.7908072,.8812688,2.1223681,.82491279,-8.90063];

b_low.qrst_angle_peak = [4.6298013,.13807175,-.66595805,.063598759,-.31955284,-.012963356,.18818152,.62606257,2.5822346];
b_high.qrst_angle_peak = [-16.891396,4.311192,7.8889771,.29495314,24.354176,1.4474102,.18334539,-5.3909993,38.537228];

b_low.qrst_angle_area = [.24014921,.68294394,.80061013,.79680556,.70224619,-.27929562,.85452497,.93673283,3.8892212];
b_high.qrst_angle_area = [8.5189571,5.8696146,.41666466,-3.0313382,3.3459749,.70359379,4.5893188,6.5590425,71.252556];



% RMSE - name as RMSE.{fn}
RMSE.svg_area_mag = 18.062859;
RMSE.svg_area_az = 14.942165;
RMSE.svg_area_el = 9.0551222;
RMSE.sai_qrst = 28.351634;
RMSE.sai_vm = 17.838668;
RMSE.svg_x = 15.12866;
RMSE.svg_y = 12.792551;
RMSE.svg_z = 12.254819;
RMSE.qrst_angle_area = nan;
RMSE.qrst_angle_peak = nan;


% Value for CI
Talpha = 1.961;     % 1.961 corresponds to 95% CI
                    % 2.054 corresponds to 96% CI

% Regression values
x = [male, age*(1-male), age*male, bmi*(1-male), bmi*male, hr*(1-male), hr*male, white, 1]; 



for i = 1:length(fn)
    
    if ~isnan(co.(fn{i}))
    
        est.(fn{i}) = dot(b.(fn{i}),x);    
        stderrp2.(fn{i}) = dot(x, x*co.(fn{i}));
        stderrf.(fn{i}) = sqrt(RMSE.(fn{i})*RMSE.(fn{i}) + stderrp2.(fn{i}));    
        nml_low.(fn{i}) = est.(fn{i})-(Talpha*stderrf.(fn{i}));
        nml_high.(fn{i}) = est.(fn{i})+(Talpha*stderrf.(fn{i}));
    
    else
        nml_low.(fn{i}) = dot(b_low.(fn{i}),x);
        nml_high.(fn{i}) = dot(b_high.(fn{i}),x);
        
    end
end


vals.low = nml_low;
vals.high = nml_high;
vals.est = est;
