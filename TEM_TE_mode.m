%close all; clear all; clc;

color='k';

%substrate, SiO2
 eps0=1.9259;
	lp = [
		14.261    1072  49 
		-0.18416  1270  216 
		1.5       802.3 80 
		%9.972     462.9 30 
		0.46239   1205  78
        ]; 
%


eps_inf=15.5+0*1i; % replace with eps_inf of material
eps_parr=8; % c-axis assumed to be described by a real value

E=1:0.01:2; %Range of photon energies in eV

c=299792458; %m/s
e=1.6e-19; %C
h=4.135667662e-15; %eVs
hbar=h/2/pi;
m0=9.11e-31;
l=h*c./E;

% Oscilator parameters
gamma(1)=0.1068;
gamma(2)=0.2519;
gamma(3)=0.2584;
gamma(4)=0.2480;
gamma(5)=1.2648;
gamma(6)=1.2480;

omega(1)=1.2046;
omega(2)=0*0.5337;
omega(3)=0*2.081;
omega(4)=0*1.0608;
omega(5)=0*15.4973;
omega(6)=0*20.9515;

E_ex(1)=1.612;
E_ex(2)=1.8;
E_ex(3)=2.18;
E_ex(4)=2.6;
E_ex(5)=2.8;
E_ex(6)=3;


for i=1:size(E,2)
    
    eps=eps_inf;
    for j=1:size(E_ex,2)
        eps=eps+omega(j)./(E_ex(j).^2-E(i).^2-1i*gamma(j).*E(i));
    end
    
    nu = real(E(i).*8066); % ignore imaginary part.
    e2 = ones(size(nu)) * eps0;
    
    for z = 1: size(lp, 1)
        e2 = e2 + lp(z, 1) * lp(z, 2) * lp(z, 3)...
            ./ (lp(z, 2)^2 - nu.^2 - 1i * lp(z, 3) * nu);
    end
    
    lambda=1e9*l(i);
    
    eps_perp=eps;
    be=0:0.0001:5; %range of wavevectors
    bo=0:0.0001:5; %range of wavevectors
    d=90; %thickness nm
    e1=1;
    epsilon(i)=eps;
    m=0; %mode order

    %TM Modes
    LHS=sqrt(eps_perp./eps_parr).*sqrt(eps_parr-be.^2).*2.*pi.*d./lambda;
    
    term1=atan(sqrt(be.^2-e1).*eps_perp./(sqrt(eps_perp./eps_parr).*sqrt(eps_parr-be.^2).*e1));
    term2=atan(sqrt(be.^2-e2).*eps_perp./(sqrt(eps_perp./eps_parr).*sqrt(eps_parr-be.^2).*e2));
   
    %TE Modes
%     LHS=sqrt(eps_perp-bo.^2).*2.*pi.*d./lambda;
%     
%     term1=atan(sqrt(bo.^2-e1)./(sqrt(eps_perp-bo.^2)));
%     term2=atan(sqrt(bo.^2-e2)./(sqrt(eps_perp-bo.^2)));
    
    RHS=term1+term2+m*pi;
    
    TE=abs(LHS-RHS);
    
    idx=find(TE==min(TE));
    
    k0(i)=2*pi./l(i);
    

        wv(i)=bo(idx);
        wv_abs(i)=bo(idx)*k0(i);

    epsilon(i)=eps;

        Lp(i)=imag(eps)./(2.*real(eps).*wv_abs(i));
        Lp(i)=Lp(i)./(1-sqrt(1-(imag(eps).^2./real(eps).^2).*(eps_parr.*k0(i).^2./wv_abs(i).^2-1)));
        q2(i)=1./2./(1e4*Lp(i));
        n(i)=sqrt(epsilon(i));
end

%%
    figure
    hold on;
    plot(wv_abs,E,'k')
    hold off;
    %note wv in units of k0, wv_abs in units of cm-1. E in units of eV