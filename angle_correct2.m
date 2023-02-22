% Input q in units of inverse microns
% q_ac returned by the code is in units of wavenumbers (cm-1)
% Note: the code only considers q values up to 5 cm-1.
%
% angle_f represents the edge w.r.t the angle of incident radiation (0
% degrees for parallel, 90 for perp as defined in F. Hu. Nature Photonics 11, 357 (2017) 
% note that in the neaspec the radiation is ~60 off normal
% view
%
% Equations are taken from A. Sternbach et al., Nat. Comm 11, 3567 (2020)
%
% lambda0 is the incident wavelength of probe radiation, units of nm
%
% Written by Aaron Sternbach

function [q_ac,l_ac,q_air,l_air]=angle_correct2(q,angle_f,lambda0)

alpha=deg2rad(30);
theta=deg2rad(90+angle_f);
%theta=deg2rad(angle_f);

q_pk=0.01:0.0001:25;
lamda_pk=2e2*pi./q_pk; 
beta=asin(lamda_pk./lambda0.*cos(alpha).*cos(theta));
l_meas=lamda_pk./(1./cos(beta)-lamda_pk./lambda0.*(cos(alpha).*sin(theta+beta))./cos(beta));
q_meas=1./(1e-3.*l_meas);

dv_p=abs(q_meas-q);
idx_p=find(dv_p==min(dv_p));
q_ac=q_pk(idx_p);
l_ac=lamda_pk(idx_p);

%for the air mode
%lambda_air=lambda0/(1/cos(beta)-cos(alpha)sin(beta-theta)/cos(beta))
%where beta=asin*cons(alpha)*cos(theta)
%q_air=1/lambda_air
beta0=asin(cos(alpha)*cos(theta));
l_air=lambda0/(1/cos(beta0)-cos(alpha)*sin(beta0-theta)/cos(beta0));
q_air=1/(2*pi*1e-3*l_air); %to convert also to um from nm

end