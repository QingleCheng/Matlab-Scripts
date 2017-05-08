function SFBMD(forces,distload,len)

%Shear Force and Bending Moment Diagram (SFBMD)
%--------------------------------------------------------------------------
% Draws the Shear Force and Bending moment diagram of beams subject to 
% Concentrated loads/moments at the ends as well as uniform distributed loads 
% along the beam  in all three directions.
%
% SYNTAX
%       SFBMD(option,forces,distloads,len)
%
% INPUT
%       [forces] :      Beam End Forces and Moments [fy1,mz1,fy1,mz2]
%       [distloabd]:    Distributed loads [wy]
%       [len]:    		Length of the beam 
%
% OUTPUT
%       subplot 1:       Shear Force Diagram 
%       subplot 2:     	Bending Moment Diagram
%
% The function can be chnaged quite easily to include it in any finite element program.
%
% EXAMPLE
% 	Cantilever with distributed load; SFBMD([0,0,0,0],-1,10)
%   Cantelever load with concentrated force at the end; SFBMD([1,10,-1,0],0,10)
%
%==========================================================================
%                     2016 By: Sumeet Kumar Sinha (sumeet.kumar507@gmail.com)

    Xmin = -0.01*len;
	Xmax =  1.01*len;

	sf1 = forces(1); sf2 = forces(3);
	bm1 = forces(2); bm2 = forces(4);
	m = 1; w = distload;
	sf_label='V (N)'; bm_label='M (N)';

	syms sf_(x) bm_(x); 
	sf(x)=dsolve(diff(sf_,1)==w,sf_(0)==sf1); 
	bm(x)=dsolve(diff(bm_,1)==1*m*sf(x),bm_(0)==-bm1);
	diff(bm_,1)==1*m*sf(x);
	bm_(0)==-bm1;
	bm_(len)==bm2;

	x = linspace(0,len);

	%% Shear Force Diagram
	
	subplot(2,1,1);
 	X = [0,x,len];	Y = [0,sf(x),0]; 
 	fill(X,Y,'b','facealpha',0.15,'edgecolor','none'); hold on;
 	plot([0,x,len],[0,sf(x),0],'b','Linewidth',2);hold off;
 	refline(0,0); xlabel('x(m)'); ylabel(sf_label);
 	title('Shear Force Diagram','FontSize',12);
 	Ymin =  int64(min(Y)-1);	Ymax = int64(max(Y)+1);

 	xlim([Xmin Xmax]);
 	ylim([Ymin Ymax]);

 	%% Bending Moment Diagram

 	subplot(2,1,2)
 	X = [0,x,len];	Y = [0,-bm(x),0]; 
 	fill(X,Y,'b','facealpha',0.15,'edgecolor','none'); hold on;
 	plot([0,x,len],[0,-bm(x),0],'b','Linewidth',2);hold off;
 	refline(0,0); xlabel('x(m)'); ylabel(bm_label);
 	title('Bending Moment Diagram','FontSize',12);
 	Ymin =  int64(min(Y)-1);	Ymax = int64(max(Y)+1);

 	xlim([Xmin  Xmax]);
 	ylim([Ymin Ymax]);

end