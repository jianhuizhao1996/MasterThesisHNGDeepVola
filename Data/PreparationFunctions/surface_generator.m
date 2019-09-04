function surface = surface_generator(year,stock_ind,Strikes,Maturity,path,bound,plot,vecormat,saver)
% Function smooths a volatility surface of data points to a given grid 
% Input: 
%   year:       int             -   year of data 
%   stock_ind:  str             -   IndexName (SP500,NASDAQ100,DJIA30)
%   Strikes,Maturity: double    -   Vector of Strikes/Maturities
%   path:       str             -   local path of data '/Users/User/Documents/GitHub/SeminarOptions/Data/Datasets'
%   bound:      double 2x1      -   bounds for minimal Volume and Open Interest
%   plot:       logical         -   show surface plot
%   vecormat:   logical         -   output as vector or matrix
%   saver:      logical         -   save out as .mat-file
% Output:
%   surface data
%   optional: .mat-file,surfaceplot
% (c) Henrik Brautmeier, Lukas Wuertenberger 2019

path_ = strcat(path,'/',stock_ind,'/','Calls',num2str(year),'.mat');
load(path_,'TradingDaysToMaturity','ImpliedVolatilityoftheOption','Moneyness','Volume','OpenInterestfortheOption');
data = [TradingDaysToMaturity,1./Moneyness,ImpliedVolatilityoftheOption,Volume,OpenInterestfortheOption];
data = data(data(:,5)>=bound(1) &data(:,4)>=bound(1),1:3);
x = data(:,1);
y = data(:,2);
z = data(:,3);
[X,Y] = meshgrid(Maturity,Strikes);
surface_data = griddata(x,y,z,X,Y);

if vecormat
    surface = reshape(surface_data,[1,length(Maturity)*length(Strikes)]);
    if saver
        name = strcat('surface',num2str(year),stock_ind);
        save(name,'surface')
    end
else 
    surface = surface_data;
    if saver
        name = strcat('surface',num2str(year),stock_ind);
        save(name,'surface')
    end
end
if plot 
    figure('Name','RealData')
    scatter3(x,y,z,'filled')
    title(strcat('Scatterplot: Calls of',stock_ind,'in ',num2str(year)))
    figure
    surf(X,Y,surface_data)
end