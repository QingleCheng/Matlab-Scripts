function NewmarkSb (tm,acc,ky)

%Newmark Sliding Block Analysis (NewmarkSb)
%--------------------------------------------------------------------------
% Newmark Sliding Block analysis is a popular method in geotechnical engineering
% to calculate displacments assuiming rigid plastic behaviour under dynamic loading
%
% SYNTAX
%       NewmarkSb (time,acc,ky)
%
% INPUT
%       [tm] :      	time data [nx1]
%       [acc]:    		Acceleration data in units of g [nx1]
%       [ky]:    		yield acceleration in units of g [1x1]
%
% OUTPUT
%       subplot 1:      Input Acceleration Time History (Base Acceleration)
%       subplot 2:     	Absolute Acceleration of the block
%       subplot 3:     	Relative Acceleration of the block
%       subplot 4:     	Relative Velocity of the block
%       subplot 5:     	Relative Displacement of the block
%
%
% EXAMPLE
%   - for a square pulse 
%	tm   = [[0:0.0001:0.5],[0.5+0.0001:0.0001:0.7],[0.7+0.0001:0.0001:2]];
%	acc  = [linspace(0,0,(0.5/0.0001)),linspace(0.5,0.5,(0.2/0.0001)+1),linspace(0,0,(1.3/0.0001))];
%   ky = 0.2;
%   NewmarkSb (tm,acc,ky);
%
%==========================================================================
%                     2016 By: Sumeet Kumar Sinha (sumeet.kumar507@gmail.com)

yield_acc = ky; 	% yield acceleration
g         = 9.81;   % gravity constant

total_time_steps = length(acc);

abs_acc = [0];		% total acceleration
rel_acc = [0];		% relative acceleration
rel_vel = [0];		% relative velocity
rel_dis = [0];		% relative displacement
time    = [0];		% time

for i=2:total_time_steps

	time(i) = tm(i);
	delt = time(i)-time(i-1);

	abs_acc(i)   = yield_acc;
	rel_acc(i)   = acc(i)-yield_acc;
	rel_vel(i)   = rel_vel(i-1) + 0.5*g*(rel_acc(i-1)+rel_acc(i))*delt;

	if(rel_vel(i)<0)
		abs_acc(i)=0;
		rel_vel(i)=0;
		rel_acc(i)=0;
	end

	rel_dis(i)	 = rel_dis(i-1) + rel_vel(i-1)*delt +(2*rel_acc(i-1)+rel_acc(i))*delt*delt/6;  % Intergrating displacement to 3rd order
		
end

figure(1);
subplot(3,2,1);
plot(time,acc,'-k','LineWidth',2);
grid on;grid minor;
xlabel('Time [s]');
ylabel('Input Acceleration of Base (a_{base}) [g]');
title ('Given Acceleration Time History');

subplot(3,2,2);
plot(time,abs_acc,'-k','LineWidth',2);
grid on;grid minor;
xlabel('Time [s]');
ylabel('Absolute Acceleration of Block (a_{block}) [g]');
title ('Absolute Acceleration of Block');

subplot(3,2,3);
plot(time,rel_acc,'-k','LineWidth',2);
grid on;grid minor;
xlabel('Time [s]');
ylabel('Relative Acceleration of Block (a_{rel}) [g]');
title ('Relative Acceleration of Block');

subplot(3,2,4);
plot(time,rel_vel,'-k','LineWidth',2);
grid on;grid minor;
xlabel('Time [s]');
ylabel('Relative Velocity of Block (v_{rel}) [m/s]');
title ('Relative Velocity of Block ');

subplot(3,2,[5 6]);
plot(time,rel_dis,'-k','LineWidth',2);
grid on;grid minor;
xlabel('Time [s]');
ylabel('Relative Displacement of Block (\delta_{rel}) [m]');
title ('Relative Displacement of Block ');