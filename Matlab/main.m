% Matlab master file
% MLE estimation for heterogeneity in health expectations
% takes cleaned data from STATA, run MLE sequence, prepares files for
% output
% Feiya Shao

%% load data
clear all
close all 
cd 'Q:\U\fyshao\HRS health expectations\Matlab\'

alldat = csvread('matlab_input.csv', 1,2);

global R S SRH1 SRH2 X1 X2 Z1 Z2 X1_cons;
global Nobs;
global lenf leng;

lenf=36; % number of health indicators, length of f0 vector
leng=1; % number of demographic indicators +1, length gamma vectors

%these are the raw numbers as collected from STATA
S_o = alldat(:,1); %survey response
R_o = alldat(:,2); %cutoff used in survey response

SRH1_o = alldat(:,3); %SRH in 2006
SRH2_o = alldat(:,4); %SRH in 2010

X1_o = alldat(:,5:5+lenf-1); %X, observable health indicators in 2006 
%Z1_o = alldat(:,5+lenf:5+lenf+leng-2); %demographics in 2006
X2_o = alldat(:,5+lenf+leng-1:5+lenf+leng+lenf-2); % X, observable health indicators 2010 
%Z2_o = alldat(:,5+lenf+leng+lenf-1:5+lenf+leng+lenf+leng-3); %demographics in 2010
Pworse = alldat(:,end-10:end);
Nobs=length(R_o);


R_o = dummyvar(R_o);
S_o = S_o;
SRH1_o=dummyvar(SRH1_o);
SRH2_o=dummyvar(SRH2_o);
Z1_o=[ones(Nobs,1)];
Z2_o=[ones(Nobs,1)];
X1_cons_o=[X1_o ones(Nobs,1)];
save 1_input.mat;

%% initial guesses

f0 = [-0.35967906	-0.08849354	-0.02168496	-0.26232046	-0.13822877 ...
    -0.14853863	-0.21397541	-0.23208346	-0.00943392	-0.11821774 ...
    -0.22441613	-0.35600326	-0.26148077	-0.26826835	-0.40153302	...
    -0.28997791	-0.1597751	-0.1884215	-0.1601791	-0.00941442	...
    -0.21733982	0.11815983	0.01245018	0.02653814	-0.11435523	...
    -0.01271939	-0.18183934	0.01 0.19082532	-0.03740161	-0.33131373	...
    -0.0459417	0.06167067	0.20798746	0.30336092	0.00553904];

g10 = [-1.8];

g20 = [-0.5];

g30 = [0.7];

g40 = [2];

f0 = round(f0,2);
g10 = round(g10,2);
g20 = round(g20,2);
g30 = round(g30,2);
g40 = round(g40,2);

b0 = f0 +0.01 ;
b0 = [b0 -0.1];
st0 = 0.1;
se0 = 0.1;

x10 = [f0 g10 g20 g30 g40];
x20 = [b0 st0 se0];

%% call MLE
bootnum = 1; % number of bootstraps
bootcoeff = zeros(bootnum, 2*lenf+4*leng+3);
maxit = 500;
errout = zeros(bootnum,maxit);
llout = zeros(bootnum);
tol = 5.0e-3; % tolerance to determine "convergence"

rng('default'); %restore the seed
rng(1);

for i=1:bootnum
    
%    index=fix(rand(1,Nobs)*Nobs)+1; %draw random sample for the bootstrap with N obs 
     index = 1:Nobs; %uses all obs as is.
     index = index';
    R = R_o(index,:);
    S = S_o(index,:);
    SRH1 = SRH1_o(index,:);
    SRH2 = SRH2_o(index,:);
    X1 = X1_o(index,:);
    X2 = X2_o(index,:);
    Z1 = Z1_o(index,:);
    Z2 = Z2_o(index,:);
    X1_cons = X1_cons_o(index,:);
    
    iter = 1; %reset iteration counter
    err = 0.1; %initial err. must be geq tol for code to start
    coeff1 = x10; %set initial guess, same initial guess used for all.
    coeff2 = x20;
    
    logout1 =zeros(maxit,1); %preallocate vector to store 
    errout1=zeros(maxit,1);
    logout2 =zeros(maxit,1);
    errout2=zeros(maxit,1);

    while (iter < maxit) && err >= tol 
            %part1
            lik1 = MLE_part1_v2(coeff1,coeff2);

            L1 = sum(lik1);
            si = fdjac('MLE_part1_v2',coeff1,coeff2);
            d = (si'*si)\(si'*ones(Nobs,1));


            coeff1 = (coeff1' + 0.2*d)';
            err1 = (max(max(abs(d))));

            %store Likelihood and error
            logout1(iter,1) = L1;
            errout1(iter,1) = err1;

            %part2
            lik2 = MLE_part2_v2(coeff2,coeff1);
            si = fdjac('MLE_part2_v2',coeff2,coeff1);
            d = (si'*si)\(si'*ones(Nobs,1));

            L2 = sum(lik2);
            
            coeff2 = (coeff2' + 0.2*d)';
            err2 = (max(max(abs(d))));

            %store Likelihood and error
            logout2(iter,1) = L2;
            errout2(iter,1) = err2;

            % together
            err = abs(err1 - err2);  %when the two likelihoods agree...
            iter = iter + 1;
            err=full(err);
            
            errout(i,iter) = err;
            fprintf('Bootstrap %1.0f Error at iteration %1.0f = %1.2e \n',[i iter err]);
            %fprintf('Coeff at iteration %1.0f \n',iter);
    end  
    llout(i) = L2;
    coeff = [coeff1 coeff2];
    bootcoeff(i,:) = coeff;
    
end
%% Extract point estimates and sd
% mean and sd
coeff = [ mean(bootcoeff); std(bootcoeff) ];
% only the means are used
fhat = coeff(1, 1:lenf);
g1hat = coeff(1,lenf+1:lenf+leng);
g2hat = coeff(1,lenf+leng+1:lenf+2*leng);
g3hat = coeff(1,lenf+2*leng+1:lenf+3*leng);
g4hat = coeff(1,lenf+3*leng+1:lenf+4*leng);
ghat = [g1hat; g2hat; g3hat; g4hat];

bhat = coeff(1,lenf+4*leng+1:lenf+4*leng+lenf+1);
lnsthat = coeff(1,lenf+4*leng+lenf+2);
lnsehat = coeff(1,lenf+4*leng+lenf+3);
sthat = exp(lnsthat);
sehat = exp(lnsehat);

%% generate reduced form estimates

H1 = (fhat*X1_o')';
H2 = (fhat*X2_o')';
 
Theta_temp = zeros(Nobs,4);
for i =1:4
    Theta_temp(:,i)= (1+sehat)*norminv(S_o) +X1_cons_o*bhat' - Z1_o*ghat(i,:)';
end
Theta = dot(Theta_temp, R_o,2);

%Theta = zeros(Nobs,1);
EH2 = X1_cons_o*bhat' + Theta;
EH2_2 = X1_cons_o*bhat';
%% Export to stata
id = csvread('matlab_input.csv', 1,0);
id = id(:,1:2);
dataout= [id H1 H2 EH2 EH2_2 ];
dlmwrite('matlabout_0719.csv',dataout,'delimiter',',','precision',9 )
save matlab_output_0719.mat
