%COrVID1920v2.m
%
%Some MATLAB stuff for downloading and plotting COVID-19 data.  See 
%'READ_ME.txt' for info about necessary files and such, see 'InputVars.m' 
%for input parameters
%
%Carl Andersen
%University of Alaskas Fairbanks
%csandersen@alaska.edu

%clear

%Download NYT data from Github at user prompt, else use local files
%https://github.com/nytimes/covid-19-data

options = weboptions('Timeout',Inf);

download = 0;
download  = input('Download NYT US data? Yes, enter "1" - Use local file, enter "0":  ')
if download == 1
    url = ['https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv'];
    filename1 = 'us-states.csv';
    TS_st_filename = websave(filename1,url);
end

download = 0;
download  = input('Download NYT County data? Yes, enter "1" - Use local file, enter "0":  ')
if download == 1
    url = ['https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'];
    filename2 = 'us-counties.csv';
    TS_cty_filename = websave(filename2,url);
end

%data from covid tracking for testing & hospitalization numbers
%https://covidtracking.com/
download = 0;
download  = input('Download Covidtracking testing/hospital data? Yes, enter "1" - Use local file, enter "0":  ')
if download == 1
    %US data
    url = ['https://raw.githubusercontent.com/COVID19Tracking/covid-tracking-data/master/data/us_daily.csv'];
    filename3 = 'testingUS.csv';
    HT_us_filename = websave(filename3,url);
    %State data
    url = ['https://raw.githubusercontent.com/COVID19Tracking/covid-tracking-data/master/data/states_daily_4pm_et.csv'];
    filename4 = 'testingST.csv';
    HT_st_filename = websave(filename4,url);
end
%%
%check if data was downloaded, else set local filenames
if exist('TS_st_filename')
   disp('Personal Space')
else
   TS_st_filename = 'us-states.csv';
end

if exist('TS_cty_filename')
   disp('Hey Personal Space')
else
   TS_cty_filename = 'us-counties.csv';
end

if exist('HT_us_filename')
   disp('Personal Space')
else
    HT_us_filename = 'testingUS.csv';
end

if exist('HT_st_filename')
   disp('Staaaaay Outta That Personal Space')
else
    HT_st_filename = 'testingST.csv';
end

%import NYT time series in table form
TS_st_table = readtable(TS_st_filename);
TS_cty_table = readtable(TS_cty_filename);

%import testing/hospital data in table form
HT_us_table = readtable(HT_us_filename);
%HT_st_table = readtable(HT_state_filename)

%import fips (2 & 5 digit), division, region code data
fipscode_5 = readtable('fips-county-codes.csv');
fipscode_2 = readtable('fips-codes.csv');
divcode = readtable('division-codes.csv');
regcode = readtable('region-codes.csv');

%Run InputVars.m to get plotting parameters for later
run('InputVars.m')

H_TS = height(TS_st_table);
H_HT = height(HT_us_table);
H_TS_C = height(TS_cty_table);
%H_HTS = height(HT_st_table);

%Define and fill 2D array from NYT t.s. state table
TS_st = zeros(H_TS,4);
TS_st(:,1) = datenum(TS_st_table.date);
TS_st(:,2) = TS_st_table.cases;
TS_st(:,3) = TS_st_table.deaths;
TS_st(:,4) = TS_st_table.fips;

%start/end dates and days elapsed (H_M) in serial date numbers
startdate = TS_st(1,1);
enddate = TS_st(H_TS,1);
H_M = enddate - startdate+1;

%Define 3D array for state data Master_st(row, column, page)
%row - individ. state date -> H_M elements
%column - date, cases, deaths -> 3 elements
%page - state fips code -> 78 elements
Master_st = zeros(H_M, 3, 78);

%%
%populate Master_st
for i = 1:H_TS
    f_fips = TS_st(i,4);
    date = TS_st(i,1);
    date_index = date-startdate+1;
    cases = TS_st(i,2);
    deaths = TS_st(i,3);
    Master_st(date_index,1,f_fips) = date;
    Master_st(date_index,2,f_fips) = cases;
    Master_st(date_index,3,f_fips) = deaths;   
end

%fill in data for states with no report that day
for i = 1:78
    f_fips = i;
    date = Master_st(1,1,f_fips);
    
    if date == 0
        Master_st(1,1,f_fips) = startdate;
    end
    
    for j = 2:H_M
        date = Master_st(j,1,f_fips);        
  
        if date == 0
            Master_st(j,1,f_fips) = Master_st(j-1,1,f_fips)+1;
            Master_st(j,2,f_fips) = Master_st(j-1,2,f_fips);
            Master_st(j,3,f_fips) = Master_st(j-1,3,f_fips);
        end
            
    end
end

%Sum up data for all US
All_st = sum(Master_st,3);
datenum_vec = All_st(:,1)/78;
All_st(:,1) = datenum_vec;

%Sum up data for Census Divisions
Division_st = zeros(H_M,3,9);

%New England
Division_st(:,:,1) = Master_st(:,:,9) + Master_st(:,:,23) + ...
    Master_st(:,:,25) + Master_st(:,:,33) + Master_st(:,:,44) ...
    + Master_st(:,:,50);
Division_st(:,1,1) = datenum_vec;

%Mid-Atlantic
Division_st(:,:,2) = Master_st(:,:,34) + Master_st(:,:,36) ...
    + Master_st(:,:,42);
Division_st(:,1,2) = datenum_vec;

%East North Central
Division_st(:,:,3) = Master_st(:,:,17) + Master_st(:,:,18) ...
    + Master_st(:,:,26) + Master_st(:,:,39) + Master_st(:,:,55);
Division_st(:,1,3) = datenum_vec;

%West North Central
Division_st(:,:,4) = Master_st(:,:,19) + Master_st(:,:,20) + ...
    Master_st(:,:,27) + Master_st(:,:,29) + Master_st(:,:,31) + ...
    Master_st(:,:,38) + Master_st(:,:,31);
Division_st(:,1,4) = datenum_vec;

%West North Central
Division_st(:,:,5) = Master_st(:,:,10) + Master_st(:,:,11) + ...
    Master_st(:,:,12) + Master_st(:,:,13) + Master_st(:,:,24) + ...
    Master_st(:,:,37) + Master_st(:,:,45) + Master_st(:,:,51) + ...
    Master_st(:,:,54);
Division_st(:,1,5) = datenum_vec;

%East South Central
Division_st(:,:,6) = Master_st(:,:,1) + Master_st(:,:,21) + ...
    Master_st(:,:,28) + Master_st(:,:,47);
Division_st(:,1,6) = datenum_vec;

%West South Central
Division_st(:,:,7) = Master_st(:,:,5) + Master_st(:,:,22) + ...
    Master_st(:,:,40) + Master_st(:,:,48);
Division_st(:,1,7) = datenum_vec;

%Mountain
Division_st(:,:,8) = Master_st(:,:,4) + Master_st(:,:,8) + ...
    Master_st(:,:,16) + Master_st(:,:,30) + Master_st(:,:,32) + ...
    Master_st(:,:,35) + Master_st(:,:,49) + Master_st(:,:,56);
Division_st(:,1,8) = datenum_vec;

%Pacific
Division_st(:,:,9) = Master_st(:,:,2) + Master_st(:,:,6) + ...
    Master_st(:,:,15) + Master_st(:,:,41) + Master_st(:,:,53);
Division_st(:,1,9) = datenum_vec;

%Sum up regions
Region_st = zeros(H_M,3,4);

%Northeast
Region_st(:,:,1) = Division_st(:,:,1) + Division_st(:,:,2);
Region_st(:,1,1) = datenum_vec;

%Midwest
Region_st(:,:,2) = Division_st(:,:,3) + Division_st(:,:,4);
Region_st(:,1,2) = datenum_vec;

%South
Region_st(:,:,3) = Division_st(:,:,5) + Division_st(:,:,6) + Division_st(:,:,7);
Region_st(:,1,3) = datenum_vec;

%West
Region_st(:,:,4) = Division_st(:,:,8) + Division_st(:,:,9);
Region_st(:,1,4) = datenum_vec;

%%
%Sum up states for custom areas.  Some parameters come from 'CustomAreas.m'
%which should have already been run by 'InputVars.m' if necessary.  
%Go there for details.

%Allocate array for summed state data, 1 page for each custom area
Areas_st = zeros(H_M,3,n_areas);

%sum up each custom area
for i = 1:n_areas
    area_temp = zeros(H_M,3);
    for j = 1:78
        if areas_states(i,j) ~= 0
            fips_temp = areas_states(i,j);
            area_temp = area_temp + Master_st(:,:,fips_temp);
        end
        Areas_st(:,:,i) = area_temp;
        Areas_st(:,1,i) = datenum_vec;
    end
end
%%  Read in county data

%Define and fill 2D array from NYT t.s. county table
TS_cty = zeros(H_TS_C,4);
TS_cty(:,1) = datenum(TS_cty_table.date);
TS_cty(:,2) = TS_cty_table.cases;
TS_cty(:,3) = TS_cty_table.deaths;
TS_cty(:,4) = TS_cty_table.fips;

%start/end dates and days elapsed (H_M_C) in serial date numbers
startdate_c = TS_cty(1,1);
enddate_c = TS_cty(H_TS_C,1);
H_M_C = enddate_c - startdate_c+1;

%Define 4D array for state data Master_cty(row, column, page, book)
%row - individ. county date -> H_M_C elements
%column - date, cases, deaths -> 3 elements
%page - county, indexed by 5-digit fips code

Master_cty = zeros(H_M, 3, 57000);

%populate Master_cty
%note that some entries in 'us-counties.csv' have blank entries
%for 5-digit fips #.  Disregard these data for now.
for i = 1:H_TS_C
    f_fips = TS_cty(i,4);
    fips_nan = isnan(f_fips);
    date = TS_cty(i,1);
    date_index = date-startdate_c+1;
    cases = TS_cty(i,2);
    deaths = TS_cty(i,3);
    if fips_nan == 0  
        Master_cty(date_index,1,f_fips) = date;
        Master_cty(date_index,2,f_fips) = cases;
        Master_cty(date_index,3,f_fips) = deaths;
    end
    
    %Special case for this data set, page 57000 goes to NYC
    %is_nyc1 = TS_cty_table{i,2};
    %is_nyc2 = string(is_nyc1);
    name_temp = string(TS_cty_table{i,2});
    is_nyc = strcmp(name_temp,"New York City");
    if is_nyc == 1
        %why doesn't this work?
        Master_cty(date_index,1,57000) = date;
        Master_cty(date_index,2,57000) = cases;
        Master_cty(date_index,3,57000) = deaths;
    end
  
end

%fill in data for counties with no report that day
for i = 1:57000
    f_fips = i;
    date = Master_cty(1,1,f_fips);
    
    if date == 0
        Master_cty(1,1,f_fips) = startdate_c;
    end
    
    for j = 2:H_M
        date = Master_cty(j,1,f_fips);        
  
        if date == 0
            Master_cty(j,1,f_fips) = Master_cty(j-1,1,f_fips)+1;
            Master_cty(j,2,f_fips) = Master_cty(j-1,2,f_fips);
            Master_cty(j,3,f_fips) = Master_cty(j-1,3,f_fips);
        end
            
    end
end

%%
%Sum up counties for custom metro areas.  Some parameters come from 
%'CustomMetros.m' which should have already been run by 'InputVars.m' 
%if necessary.  Go there for details.

%Allocate array for summed county data, 1 page for each custom area
Metro_cty = zeros(H_M,3,n_metro);

%sum up each custom area
for i = 1:n_metro
    area_temp = zeros(H_M,3);
    cty_n_temp = 0;
    for j = 1:254
        if metro_counties(i,j) ~= 0
            fips_temp = metro_counties(i,j);
            area_temp = area_temp + Master_cty(:,:,fips_temp);
            cty_n_temp = cty_n_temp + 1;
        end
        Metro_cty(:,:,i) = area_temp;
        date_temp = Metro_cty(:,1,i)/cty_n_temp;
        Metro_cty(:,1,i) = date_temp;
    end
end

%%Sum up county data into custom metro areas

%%
%Sort and store some of testing/hospital data at U.S. level(see descriptions)

Testing_us = zeros(H_HT,9);
Testing_us(:,2) = HT_us_table.states;
Testing_us(:,3) = HT_us_table.positive;
Testing_us(:,4) = HT_us_table.negative;
Testing_us(:,5) = HT_us_table.posNeg;
Testing_us(:,6) = HT_us_table.pending;
Testing_us(:,7) = HT_us_table.hospitalized;
Testing_us(:,8) = HT_us_table.death;
Testing_us(:,9) = HT_us_table.total;

%flip array & fill date column starting at datenum for 3/4/20
T_temp = flipud(Testing_us);
Testing_us = T_temp;
for i = 1:H_HT
    Testing_us(i,1) = 737853+i;
end

%%Sort and store some of testing/hospital data for state level...

%%
%See 'READ_ME.txt' & 'InputVars.m' for details on previously obtained plot
%parameters
%run('InputVars.m')

%US plot
if US_plot_on == 1    
         
    if semilog_US_on == 1
        figure
        if US_cases_on == 1
            semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Positive Cases'])
            hold on
        end
        if US_deaths_on == 1
            semilogy(All_st(:,1),All_st(:,3),'DisplayName',['Deaths'])
            hold on
        end
        if US_tests_on == 1
            semilogy(Testing_us(:,1),Testing_us(:,5),'DisplayName',...
                ['All Test Results (Pos. + Neg.)'])
            hold on
        end
        if US_hosp_on == 1
            semilogy(Testing_us(:,1),Testing_us(:,7),'DisplayName',['Hospitalized'])
        end
        datetick('x','keepticks','keeplimits')
        xlim([(startdate+t_pad_us(1)) (enddate+t_pad_us(2))])
        ylim(y_lmt_us)
        title('COrVID1920 - U.S. Data');
        xlabel('Date');
        ylabel('Known Number to Date');
        legend('Location','northwest')
        grid on
        grid minor
        hold off
    end   
    if semilog_US_on == 0
        figure
        if US_cases_on == 1
            plot(All_st(:,1),All_st(:,2),'DisplayName',['Cases'])
            hold on
        end
        if US_deaths_on == 1
            plot(All_st(:,1),All_st(:,3),'DisplayName',['Deaths'])
            hold on
        end
        if US_tests_on == 1
            plot(Testing_us(:,1),Testing_us(:,5),'DisplayName',...
                ['All Test Results (Pos. + Neg.)'])
            hold on
        end
        if US_hosp_on == 1
            plot(Testing_us(:,1),Testing_us(:,7),'DisplayName',['Hospitalized'])
        end
        datetick('x','keepticks','keeplimits')
        xlim([(startdate+t_pad_us(1)) (enddate+t_pad_us(2))])
        ylim(y_lmt_us)
        title('COrVID1920 - U.S. Data');
        xlabel('Date');
        ylabel('Known Number to Date');
        legend({'Positive Cases','Deaths'}, 'Location','northwest')
        grid on
        grid minor
        hold off
    end
    if semilog_US_on == 2
        figure('Renderer', 'painters', 'Position', [10 10 1250 500])
        %plot semilog on left of fig, linear on right
        subplot1 = subplot(1,2,1);
        if US_cases_on == 1
            semilogy(subplot1,All_st(:,1),All_st(:,2),'DisplayName',['Cases'])
            hold on
        end
        if US_deaths_on == 1
            semilogy(subplot1,All_st(:,1),All_st(:,3),'DisplayName',['Deaths'])
            hold on
        end
        if US_tests_on == 1
            semilogy(subplot1,Testing_us(:,1),Testing_us(:,5),'DisplayName',...
                ['All Test Results (Pos. + Neg.)'])
            hold on
        end
        if US_hosp_on == 1
            semilogy(subplot1,Testing_us(:,1),Testing_us(:,7),'DisplayName',['Hospitalized'])
            hold on
        end
        datetick(subplot1,'x','keepticks','keeplimits')
        grid on
        grid minor
        xlim(subplot1,[(startdate+t_pad_us(1)) (enddate+t_pad_us(2))])
        title(subplot1,'COrVID1920 - U.S. Data');
        xlabel(subplot1,'Date');
        ylabel(subplot1,'Known Number to Date');
        legend(subplot1,'Location','northwest')
        subplot2 = subplot(1,2,2);
        if US_cases_on == 1
            plot(subplot2,All_st(:,1),All_st(:,2),'DisplayName',['Cases'])
            hold on
        end
        if US_deaths_on == 1
            plot(subplot2,All_st(:,1),All_st(:,3),'DisplayName',['Deaths'])
            hold on
        end
        if US_tests_on == 1
            plot(subplot2,Testing_us(:,1),Testing_us(:,5),'DisplayName',...
                ['All Test Results (Pos. + Neg.)'])
            hold on
        end
        if US_hosp_on == 1
            plot(subplot2,Testing_us(:,1),Testing_us(:,7),'DisplayName',['Hospitalized'])
            hold on
        end
        datetick(subplot2,'x','keepticks','keeplimits')
        xlim(subplot2,[(startdate+t_pad_us(1)) (enddate+t_pad_us(2))])
        title(subplot2,'COrVID1920 - U.S. Data');
        xlabel(subplot2,'Date');
        ylabel(subplot1,'Known Number to Date');
        ylabel(subplot2,'Known Number to Date');
        legend(subplot2,'Location','northwest');
        grid on
        grid minor
        hold off
    end
end

%%
%State plots
if ST_plot_on == 1
    %find states to plot
    n_plot = size(state_plots,2);
    figure

    %plot US cases
    if ST_include_US == 1;        
        if semilog_ST_on == 1
            semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        end
        if semilog_ST_on == 0
            plot(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        end
    end
     
    %state plots
    for i = 1:n_plot
        fips = state_plots(i);
        if semilog_ST_on == 1
            hold on
            ST_name = string(fipscode_2.ABR(fips));
            semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',[ST_name])
        end
        if semilog_ST_on == 0
            hold on
            ST_name = string(fipscode_2.ABR(fips));
            plot(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',[ST_name])
        end
        datetick('x','keepticks','keeplimits')
        xlim([(startdate+t_pad_sdr(1)) (enddate+t_pad_sdr(2))])
        if semilog_ST_on == 1
            ylim(y_lmt_sdr)
        end
    end
    title('COrVID1920 - State Data');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end
%%
%Division plots
if DV_plot_on == 1
    %find divisions to plot
    n_plot = size(div_plots,2);
    figure

    %plot US cases
    if DV_include_US == 1;        
        if semilog_DV_on == 1
            semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        end
        if semilog_DV_on == 0
            plot(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        end
    end
     
    %division plots
    for i = 1:n_plot
        div = div_plots(i);
        if semilog_DV_on == 1
            hold on
            DV_name = string(divcode.Name(div));
            if i ~= 9
                if i ~= 8
                    semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',[DV_name])
                end
            end
            if i == 8
                semilogy(Division_st(:,1,div),Division_st(:,2,div),'g','DisplayName',[DV_name])
            end
            if i == 9
                semilogy(Division_st(:,1,div),Division_st(:,2,div),'k','DisplayName',[DV_name])
            end
        end
        if semilog_DV_on == 0
            hold on
            DV_name = string(divcode.ABR(div));
            plot(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',[DV_name])
        end
        datetick('x','keepticks','keeplimits')
        xlim([(startdate+t_pad_sdr(1)) (enddate+t_pad_sdr(2))])
        if semilog_DV_on == 1
            ylim(y_lmt_sdr)
        end
    end
    title('COrVID1920 - Census Division Data');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%%
%Region plots
if RG_plot_on == 1
    %find regions to plot
    n_plot = size(reg_plots,2);
    figure

    %plot US cases
    if RG_include_US == 1;        
        if semilog_RG_on == 1
            semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        end
        if semilog_RG_on == 0
            plot(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        end
    end
     
    %region plots
    for i = 1:n_plot
        reg = reg_plots(i);
        if semilog_RG_on == 1
            hold on
            RG_name = string(regcode.Name(reg));
            semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',[RG_name])
        end
        if semilog_RG_on == 0
            hold on
            RG_name = string(regcode.ABR(reg));
            plot(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',[RG_name])
        end
        datetick('x','keepticks','keeplimits')
        xlim([(startdate+t_pad_sdr(1)) (enddate+t_pad_sdr(2))])
        if semilog_RG_on == 1
            ylim(y_lmt_sdr)
        end
    end
    title('COrVID1920 - Region Data');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%Custom areas plots
if CST_plot_on == 1
    figure

    %plot US cases
    if CST_include_US == 1;        
        if semilog_CST_on == 1
            semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
            hold on
        end
        if semilog_CST_on == 0
            plot(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
            hold on
        end
    end
     
    %custom area plots
    for i = 1:n_areas
        area = i;
        if semilog_CST_on == 1
            hold on
            CST_name = areas_name(i);
            semilogy(Areas_st(:,1,i),Areas_st(:,2,i),'DisplayName',[CST_name])
        end
        if semilog_CST_on == 0
            hold on
            CST_name = areas_name(i);
            plot(Areas_st(:,1,i),Areas_st(:,2,i),'DisplayName',[CST_name])
        end
        datetick('x','keepticks','keeplimits')
        xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
        if semilog_CST_on == 1
            ylim(y_lmt_cst)
        end
    end
    title('COrVID1920 - Custom Areas');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%%
%Custom Metro Plots. Copy/pase main if statement multiple times for more
%plots

%plot 1, NYC Metro Area
if CCTY_plots_on(1) == 1
    figure
    %plot US cases
    if CCTY_include_us(1) == 1;        
        semilogy(All_st(:,1),All_st(:,2),'b','DisplayName',['U.S. Cases'])
        hold on
        semilogy(All_st(:,1),All_st(:,3),'-.b','DisplayName',['U.S. Deaths'])
        hold on
    end
    if CCTY_include_reg(1) == 1;
        reg = 1;
        semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',...
            ['Northeast Cases'])
        hold on
    end
    if CCTY_include_div(1) == 1;
        div = 2;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',...
            ['Mid-Atlantic Cases'])
        hold on
    end
    if CCTY_include_st(1) == 1;
        fips = 36;
        semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',...
            ['NY State Cases'])
        hold on
    end
    if CCTY_include_area(1) == 1;
        area = 2;
        semilogy(Areas_st(:,1,area),Areas_st(:,2,area),'r','DisplayName',...
            ['NY Tri-State Cases'])
        hold on
        semilogy(Areas_st(:,1,area),Areas_st(:,3,area),'-.r','DisplayName',...
            ['NY Tri-State Deaths'])
        hold on
    end
    %CST_name = areas_name(i);
    semilogy(Metro_cty(:,1,1),Metro_cty(:,2,1),'g','DisplayName',...
        ['NYC Metro Cases'])
    hold on
    semilogy(Metro_cty(:,1,1),Metro_cty(:,3,1),'-.g','DisplayName',...
        ['NYC Metro Deaths'])
    datetick('x','keepticks','keeplimits')
    xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
    ylim(y_lmt_cst)
    title('COrVID1920 - Greater NYC');
    xlabel('Date');
    ylabel('Known Number');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%plot 2, Pacific NW
if CCTY_plots_on(2) == 1
    figure
    %plot US cases
    if CCTY_include_us(2) == 1;        
        semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        hold on
    end
    if CCTY_include_reg(2) == 1;
        reg = 4;
        semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',['West U.S.'])
        hold on
    end
    if CCTY_include_div(2) == 1;
        div = 9;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',...
            ['Pacific'])
        hold on
    end
    if CCTY_include_st(2) == 1;
        fips = 53;
        semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',...
            ['Washington'])
        hold on
    end
    if CCTY_include_area(2) == 1;
        area = 1;
        semilogy(Areas_st(:,1,area),Areas_st(:,2,area),'DisplayName',['Pacific NW'])
        hold on
    end
    %CST_name = areas_name(i);
    semilogy(Metro_cty(:,1,3),Metro_cty(:,2,3),'DisplayName',['Seattle-Tacoma'])
    hold on
    semilogy(Metro_cty(:,1,4),Metro_cty(:,2,4),'DisplayName',['Portland, Oregon'])
    hold on
    semilogy(Metro_cty(:,1,7),Metro_cty(:,2,8),'DisplayName',['Corvallis/Albany/Salem'])
    hold on
    semilogy(Metro_cty(:,1,5),Metro_cty(:,2,5),'DisplayName',['Anchorage/Southcentral'])
    hold on
    semilogy(Metro_cty(:,1,6),Metro_cty(:,2,6),'DisplayName',['Fairbanks/Interior'])
    hold on
    semilogy(Metro_cty(:,1,7),Metro_cty(:,2,7),'k','DisplayName',['Juneau/Southeast'])
    hold on
    datetick('x','keepticks','keeplimits')
    xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
    ylim(y_lmt_cst)
    title('COrVID1920 - Pacific NW Metros');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%plot 3, Northeast Metros
if CCTY_plots_on(3) == 1
    figure
    %plot US cases
    if CCTY_include_us(3) == 1;        
        semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        hold on
    end
    if CCTY_include_reg(3) == 1;
        reg = 1;
        semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',['NE U.S.'])
        hold on
    end
    if CCTY_include_div(3) == 1;
        div = 1;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',['New England'])
        hold on
        div = 2;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',['Mid-Atlantic'])
        hold on
    end
    if CCTY_include_st(3) == 1;
        fips = 36;
        semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',...
            ['N.Y.S.'])
        hold on
    end
    if CCTY_include_area(3) == 1;
        area = 2;
        semilogy(Areas_st(:,1,area),Areas_st(:,2,area),'DisplayName',['NY Tri-State'])
        hold on
    end
    %CST_name = areas_name(i);
    semilogy(Metro_cty(:,1,2),Metro_cty(:,2,2),'DisplayName',['Boston'])
    hold on
    semilogy(Metro_cty(:,1,9),Metro_cty(:,2,9),'DisplayName',['Providence-New Bedford'])
    hold on
    semilogy(Metro_cty(:,1,10),Metro_cty(:,2,10),'DisplayName',['Hartford'])
    hold on
    semilogy(Metro_cty(:,1,1),Metro_cty(:,2,1),'DisplayName',['New York City'])
    hold on
    semilogy(Metro_cty(:,1,11),Metro_cty(:,2,11),'DisplayName',['Philadelphia'])
    hold on
    semilogy(Metro_cty(:,1,12),Metro_cty(:,2,12),'DisplayName',['Washington, D.C.'])
    hold on
    datetick('x','keepticks','keeplimits')
    xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
    ylim(y_lmt_cst)
    title('COrVID1920 - Northeast Metros');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%plot 4, California Metros
if CCTY_plots_on(4) == 1
    figure
    %plot US cases
    if CCTY_include_us(4) == 1;        
        semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        hold on
    end
    if CCTY_include_reg(4) == 1;
        reg = 4;
        semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',['West U.S.'])
        hold on
    end
    if CCTY_include_div(4) == 1;
        div = 9;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',...
            ['Pacific'])
        hold on
    end
    if CCTY_include_st(4) == 1;
        fips = 06;
        semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',...
            ['California'])
        hold on
    end
    if CCTY_include_area(4) == 1;
        area = 1;
        semilogy(Areas_st(:,1,area),Areas_st(:,2,area),'DisplayName',['Pacific NW'])
        hold on
    end
    %CST_name = areas_name(i);
    semilogy(Metro_cty(:,1,13),Metro_cty(:,2,13),'DisplayName',['LA Metro'])
    hold on
    semilogy(Metro_cty(:,1,14),Metro_cty(:,2,14),'DisplayName',['SF Bay Area'])
    hold on
    semilogy(Metro_cty(:,1,15),Metro_cty(:,2,15),'DisplayName',['San Diego'])
    hold on
    datetick('x','keepticks','keeplimits')
    xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
    ylim(y_lmt_cst)
    title('COrVID1920 - California Metros');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end


%Plot 5, Florida Metros
if CCTY_plots_on(5) == 1
    figure
    %plot US cases
    if CCTY_include_us(5) == 1;        
        semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        hold on
    end
    if CCTY_include_reg(5) == 1;
        reg = 3;
        semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',['South U.S.'])
        hold on
    end
    if CCTY_include_div(5) == 1;
        div = 5;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',...
            ['South Atlantic'])
        hold on
    end
    if CCTY_include_st(5) == 1;
        fips = 12;
        semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',...
            ['Florida'])
        hold on
    end
    if CCTY_include_area(5) == 1;
        area = 1;
        semilogy(Areas_st(:,1,area),Areas_st(:,2,area),'DisplayName',['Pacific NW'])
        hold on
    end
    %CST_name = areas_name(i);
    semilogy(Metro_cty(:,1,16),Metro_cty(:,2,16),'DisplayName',['Jacksonville'])
    hold on
    semilogy(Metro_cty(:,1,17),Metro_cty(:,2,17),'DisplayName',['Miami Metro'])
    hold on
    semilogy(Metro_cty(:,1,18),Metro_cty(:,2,18),'DisplayName',['Orlando'])
    hold on
    semilogy(Metro_cty(:,1,19),Metro_cty(:,2,19),'DisplayName',['Tampa Bay'])
    hold on
    datetick('x','keepticks','keeplimits')
    xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
    ylim(y_lmt_cst)
    title('COrVID1920 - Florida Metros');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%Plot 6, Texas Metros
if CCTY_plots_on(6) == 1
    figure
    %plot US cases
    if CCTY_include_us(6) == 1;        
        semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        hold on
    end
    if CCTY_include_reg(6) == 1;
        reg = 3;
        semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',['South U.S.'])
        hold on
    end
    if CCTY_include_div(6) == 1;
        div = 7;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',...
            ['West South Central U.S.'])
        hold on
    end
    if CCTY_include_st(6) == 1;
        fips = 48;
        semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',...
            ['Texas'])
        hold on
    end
    if CCTY_include_area(6) == 1;
        area = 1;
        semilogy(Areas_st(:,1,area),Areas_st(:,2,area),'DisplayName',['Pacific NW'])
        hold on
    end
    %CST_name = areas_name(i);
    semilogy(Metro_cty(:,1,20),Metro_cty(:,2,20),'DisplayName',['Dallas-Ft. Worth'])
    hold on
    semilogy(Metro_cty(:,1,21),Metro_cty(:,2,21),'DisplayName',['Houston Metro'])
    hold on
    semilogy(Metro_cty(:,1,22),Metro_cty(:,2,22),'DisplayName',['San Antonio'])
    hold on
    semilogy(Metro_cty(:,1,23),Metro_cty(:,2,23),'DisplayName',['Austin Metro'])
    hold on
    xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
    ylim(y_lmt_cst)
    datetick('x','keepticks','keeplimits')
    title('COrVID1920 - Texas Metros');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%Plot 7, Midwest Metros
if CCTY_plots_on(7) == 1
    figure
    %plot US cases
    if CCTY_include_us(7) == 1;        
        semilogy(All_st(:,1),All_st(:,2),'DisplayName',['Total U.S.'])
        hold on
    end
    if CCTY_include_reg(7) == 1;
        reg = 2;
        semilogy(Region_st(:,1,reg),Region_st(:,2,reg),'DisplayName',['Midwest U.S.'])
        hold on
    end
    if CCTY_include_div(7) == 1;
        div = 3;
        semilogy(Division_st(:,1,div),Division_st(:,2,div),'DisplayName',...
            ['East North Central U.S.'])
        hold on
    end
    if CCTY_include_st(7) == 1;
        fips = 39;
        semilogy(Master_st(:,1,fips),Master_st(:,2,fips),'DisplayName',...
            ['Ohio'])
        hold on
    end
    if CCTY_include_area(7) == 1;
        area = 2;
        semilogy(Areas_st(:,1,area),Areas_st(:,2,area),'DisplayName',['NYC Metro'])
        hold on
    end
    %CST_name = areas_name(i);
    semilogy(Metro_cty(:,1,24),Metro_cty(:,2,24),'DisplayName',['Chicago'])
    hold on
    semilogy(Metro_cty(:,1,25),Metro_cty(:,2,25),'DisplayName',['Detroit'])
    hold on
    semilogy(Metro_cty(:,1,26),Metro_cty(:,2,26),'DisplayName', ...
        ['Minneapolis-St. Paul'])
    hold on
    semilogy(Metro_cty(:,1,27),Metro_cty(:,2,27),'DisplayName',['Indianapolis'])
    hold on
    semilogy(Metro_cty(:,1,28),Metro_cty(:,2,28),'DisplayName',['Cleveland'])
    hold on
    semilogy(Metro_cty(:,1,29),Metro_cty(:,2,29),'DisplayName',['Columbus'])
    hold on
    semilogy(Metro_cty(:,1,30),Metro_cty(:,2,30),'DisplayName',['Cincinnati'])
    hold on
    datetick('x','keepticks','keeplimits')
    xlim([(startdate+t_pad_cst(1)) (enddate+t_pad_cst(2))])
    ylim(y_lmt_cst)
    title('COrVID1920 - Midwest Metros');
    xlabel('Date');
    ylabel('Cases');
    legend('Location','northwest')
    grid on
    grid minor
    hold off   
end

%Chocolate Microscopes?

