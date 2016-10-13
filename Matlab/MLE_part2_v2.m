
function[ll] = likelihood_half(x,para)
%%
global R S SRH1 SRH2 X1 X2 Z1 Z2 X1_cons;
global Nobs lenf leng;

% read variables from x- these are to be optimised
bhat = x(1:lenf+1);
lnsigtheta = x(end-1);
lnsige = x(end);
sigtheta = exp(lnsigtheta);
sige = exp(lnsige);
% read variables from para - these are static and just pass through the
% function - fhat and ghat 
fhat = para(1:lenf);
ghat1 = para(lenf+1:lenf+leng);
ghat2 = para(lenf+leng+1:lenf+2*leng);
ghat3 = para(lenf+2*leng+1:lenf+3*leng);
ghat4 = para(lenf+3*leng+1:lenf+4*leng);

%%
Theta_temp = zeros(Nobs,4);

Theta_temp(:,1)= (1+sige)*norminv(S) +X1_cons*bhat' - Z2*ghat1';
Theta_temp(:,2)= (1+sige)*norminv(S) +X1_cons*bhat' - Z2*ghat2';
Theta_temp(:,3)= (1+sige)*norminv(S) +X1_cons*bhat' - Z2*ghat3';
Theta_temp(:,4)= (1+sige)*norminv(S) +X1_cons*bhat' - Z2*ghat4';

THETA = dot(Theta_temp, R,2 ); %treat each row as vector for dot product
%%
llSRH1_temp = zeros(Nobs,5);
llSRH2_temp = zeros(Nobs,5);

llSRH1_temp(:,1)=normcdf( (Z1*ghat1') - (X1*fhat') );
llSRH1_temp(:,2)=normcdf(Z1*ghat2' - X1*fhat') - normcdf(Z1*ghat1' - X1*fhat');
llSRH1_temp(:,3)=normcdf(Z1*ghat3' - X1*fhat') - normcdf(Z1*ghat2' - X1*fhat');
llSRH1_temp(:,4)=normcdf(Z1*ghat4' - X1*fhat') - normcdf(Z1*ghat3' - X1*fhat');
llSRH1_temp(:,5)=1 - normcdf(Z1*ghat4' - X1*fhat');

llSRH2_temp(:,1)=normcdf(Z2*ghat1' - X2*fhat');
llSRH2_temp(:,2)=normcdf(Z2*ghat2' - X2*fhat') - normcdf(Z2*ghat1' - X2*fhat');
llSRH2_temp(:,3)=normcdf(Z2*ghat3' - X2*fhat') - normcdf(Z2*ghat2' - X2*fhat');
llSRH2_temp(:,4)=normcdf(Z2*ghat4' - X2*fhat') - normcdf(Z2*ghat3' - X2*fhat');
llSRH2_temp(:,5)=1 - normcdf(Z2*ghat4' - X2*fhat');
%%
llSRH1 = dot(llSRH1_temp,SRH1,2);
llSRH2 = dot(llSRH2_temp,SRH2,2);

llfg = normpdf(X2*fhat' - X1_cons*bhat',0,sige);
lltheta = normpdf(THETA,0,sigtheta);
total = log(llfg) + log(lltheta) + log(llSRH1) + log(llSRH2);

ll = total;