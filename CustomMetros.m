%CustomMetros.m
%
%Custom Metros - sum up cases across counties to create/plot one or more 
%custom metro areas.  Note that NYC Metro is a special case and entering 
%Also see READ_ME.txt & 'InputVars.m' for more info about fips & variable 
%conventions.

n_metro = 30       %Number of custom metro areas to be summed and plotted
metro_counties = zeros(n_metro,254);   %Allocate county/name arrays.
metro_name = strings(1,n_metro);       %Don't touch these.

%custom metro area 1 - NYC Metro
%put fips numbers for states to be summed in 1xN arrays.
%numbers in variable names must be consistent with n_cst_areas
%Counties to sum, using 5-digit fips codes
metro_01_counties = [36119 34003 34017 34031 36079 36087 36103 36059 ...
    34013 34039 34027 34037 34019 42103];  
metro_name(1) = 'N.Y.C. Metro';        %name in string format, change index as needed
metro_size = size(metro_01_counties,2);   %change # in area_#_counties here if needed
naughts = 254-metro_size;              %Don't touch this, either
metro_temp = padarray(metro_01_counties,[0 naughts],0,'post'); %change metro_# here too
metro_counties(1,:) = metro_temp;       % change metro_counties(#,:) as needed   

%custom metro area 2 - Boston
metro_02_counties = [25021 25023 25025 25009 25017 35015 35017];         
metro_name(2) = 'Boston';
metro_size = size(metro_02_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_02_counties,[0 naughts],0,'post');
metro_counties(2,:) = metro_temp;

%custom metro area 3 - SeaTac
metro_03_counties = [53061 53033 53053];         
metro_name(3) = 'Seattle-Tacoma';
metro_size = size(metro_03_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_03_counties,[0 naughts],0,'post');
metro_counties(3,:) = metro_temp;

%custom metro area 4 Portland, Oregon
metro_04_counties = [41005 41009 41051 41071 53011 53059];         
metro_name(4) = 'Portland, Oregon';
metro_size = size(metro_04_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_04_counties,[0 naughts],0,'post');
metro_counties(4,:) = metro_temp;

%custom metro area 5 Anchorage
metro_05_counties = [02020 02122 02150 02170 02261];         
metro_name(5) = 'Anchorage-Southcentral';
metro_size = size(metro_05_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_05_counties,[0 naughts],0,'post');
metro_counties(5,:) = metro_temp;

%custom metro area 6 - Fairbanks
metro_06_counties = [02068 02090 02240];         
metro_name(6) = 'Fairbanks-Interior';
metro_size = size(metro_06_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_06_counties,[0 naughts],0,'post');
metro_counties(6,:) = metro_temp;

%custom metro area 7 - Juneau
metro_07_counties = [02100 02110 02130 02201 02220 02232 02280];         
metro_name(7) = 'Juneau-Southeast';
metro_size = size(metro_07_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_07_counties,[0 naughts],0,'post');
metro_counties(7,:) = metro_temp;

%custom metro area 8 - Corvallis/Albany/Salem
metro_08_counties = [41003 41043 41047];         
metro_name(8) = 'Corvallis-Albany-Salem';
metro_size = size(metro_08_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_08_counties,[0 naughts],0,'post');
metro_counties(8,:) = metro_temp;

%custom_metro area 9 Providence/New Beford Metro
metro_09_counties = [44001 44003 44005 44007 44009 25005];         
metro_name(9) = 'Providence-New Bedford';
metro_size = size(metro_09_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_09_counties,[0 naughts],0,'post');
metro_counties(9,:) = metro_temp;

%custom_metro area 10 Hartford Metro
metro_10_counties = [09003 09007 09013];         
metro_name(10) = 'Hartford';
metro_size = size(metro_10_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_10_counties,[0 naughts],0,'post');
metro_counties(10,:) = metro_temp;

%custom_metro area 11 Philadelphia Metro
metro_11_counties = [10003 24015 35005 35007 35015 35033 42017 42019 ...
    42029 42045 42101];         
metro_name(11) = 'Philadelphia';
metro_size = size(metro_11_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_11_counties,[0 naughts],0,'post');
metro_counties(11,:) = metro_temp;

%custom_metro area 12 DC Metro
metro_12_counties = [11001 24009 24017 24021 24031 24033 51013 51043 ...
    51047 51059 51061 51107 51153 51157 51177 51179 51187 54037];         
metro_name(12) = 'Washington, D.C. Metro';
metro_size = size(metro_12_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_12_counties,[0 naughts],0,'post');
metro_counties(12,:) = metro_temp;

%custom metro area 13 LA Metro
metro_13_counties = [06037 06059 06111 06065 06071];         
metro_name(13) = 'Los Angeles';
metro_size = size(metro_13_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_13_counties,[0 naughts],0,'post');
metro_counties(13,:) = metro_temp;

%custom metro area 14 SF Bay
metro_14_counties = [06001 06013 06041 06055 06075 06081 06085 06095 06097];         
metro_name(14) = 'S.F. Bay Area';
metro_size = size(metro_14_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_14_counties,[0 naughts],0,'post');
metro_counties(14,:) = metro_temp;

%custom metro area 15 San Diego
metro_15_counties = [06073];         
metro_name(15) = 'San Diego';
metro_size = size(metro_15_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_15_counties,[0 naughts],0,'post');
metro_counties(15,:) = metro_temp;

%custom metro area 16 Jacksonville
metro_16_counties = [12031 12109 12019 12089 12003];         
metro_name(16) = 'Jacksonville';
metro_size = size(metro_16_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_16_counties,[0 naughts],0,'post');
metro_counties(16,:) = metro_temp;

%custom metro area 17 Miami
metro_17_counties = [12011 12086 12097];         
metro_name(17) = 'Miami';
metro_size = size(metro_17_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_17_counties,[0 naughts],0,'post');
metro_counties(17,:) = metro_temp;

%custom metro area 18 Orlando
metro_18_counties = [12069 12095 12097];         
metro_name(18) = 'Orlando';
metro_size = size(metro_18_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_18_counties,[0 naughts],0,'post');
metro_counties(18,:) = metro_temp;

%custom metro area 19 Tampa Bay
metro_19_counties = [12057 12103 12053 12101];         
metro_name(19) = 'Tampa Bay';
metro_size = size(metro_19_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_19_counties,[0 naughts],0,'post');
metro_counties(19,:) = metro_temp;

%custom metro area 20 DFW
metro_20_counties = [48085 48113 48121 48139 48231 48257 48397 48497 ...
    48439 48367 48251];         
metro_name(20) = 'Dallas-Ft. Worth';
metro_size = size(metro_20_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_20_counties,[0 naughts],0,'post');
metro_counties(20,:) = metro_temp;

%custom metro area 21 Houston
metro_21_counties = [48201 48157 48339 48039 48167 48291 48473 48071 48051];         
metro_name(21) = 'Houston';
metro_size = size(metro_21_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_21_counties,[0 naughts],0,'post');
metro_counties(21,:) = metro_temp;

%custom metro area 22
metro_22_counties = [48013 48019 48029 48091 48187 48259 48325 48493];         
metro_name(22) = 'San Antonio';
metro_size = size(metro_22_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_22_counties,[0 naughts],0,'post');
metro_counties(22,:) = metro_temp;

%custom metro area 23
metro_23_counties = [48491 48453 48209 48055 48021];         
metro_name(23) = 'Austin';
metro_size = size(metro_23_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_23_counties,[0 naughts],0,'post');
metro_counties(23,:) = metro_temp;

%custom metro area 24 - Chicago
metro_24_counties = [17031 17037 17043 17063 17089 17091 17093 17097 ... 
    17111 17197 18073 18089 18111 18127 55059];         
metro_name(24) = 'Chicago';
metro_size = size(metro_24_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_24_counties,[0 naughts],0,'post');
metro_counties(24,:) = metro_temp;

%custom metro area 25 - Detroit
metro_25_counties = [26087 26093 26099 26125 12147 12163];         
metro_name(25) = 'Detroit';
metro_size = size(metro_25_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_25_counties,[0 naughts],0,'post');
metro_counties(25,:) = metro_temp;

%custom metro area 26 - MSP
metro_26_counties = [27003 27019 27025 27037 27053 27059 27079 27095 ...
    27123 27139 27141 27143 27163 27171];         
metro_name(26) = 'Minneapolis-St. Paul';
metro_size = size(metro_26_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_26_counties,[0 naughts],0,'post');
metro_counties(26,:) = metro_temp;

%custom metro area 27 - Indianapolis
metro_27_counties = [18011 18013 18057 18063 18081 18095 18097 18109 ...
    18133 18145];         
metro_name(27) = 'Indianapolis';
metro_size = size(metro_27_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_27_counties,[0 naughts],0,'post');
metro_counties(27,:) = metro_temp;

%custom metro area 28 - Cleveland
metro_28_counties = [39035 30055 39085 39093 39103];         
metro_name(28) = 'Cleveland';
metro_size = size(metro_28_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_28_counties,[0 naughts],0,'post');
metro_counties(28,:) = metro_temp;

%custom metro area 29 - Columbus
metro_29_counties = [39041 39045 39049 39073 39089 39097 39117 39127 ...
    39129 39159];         
metro_name(29) = 'Columbus';
metro_size = size(metro_29_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_29_counties,[0 naughts],0,'post');
metro_counties(29,:) = metro_temp;

%custom metro area 30 - Cincinnati
metro_30_counties = [18029 18047 18115 21015 21023 21037 21077 21081 ...
    21117 21191 39015 39017 39025 39027 39061 39165];         
metro_name(30) = 'Cincinnati';
metro_size = size(metro_30_counties,2);   
naughts = 254-metro_size;              
metro_temp = padarray(metro_30_counties,[0 naughts],0,'post');
metro_counties(30,:) = metro_temp;

