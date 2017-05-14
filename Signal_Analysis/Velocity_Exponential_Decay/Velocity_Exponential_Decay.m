
function [Filtered_u,Filtered_v,Filtered_a,T]=Velocity_Exponential_Decay(v,dt,t_decay,exp_k,plotFigures)

%Signal Exponential Decay
%--------------------------------------------------------------------------
% This function exponentialy decays the signal from a given time t_decay
% and exponential constant k using function exp(-exp_k*(t-t_decay)) and 
% outputs and the new signal and time.
%
% SYNTAX
%       Fourier_Amplitude(x,dt,t_decay,exp_k)
%
% INPUT
%       [v] :      	    	veolocity signal data [nx1]
%       [dt]:    			time step [1x1]
%       [t_decay]:    		decay start time [1x1]
%       [exp_k]:    		exponential coefficient k [1x1]
%		[plotFigures] : 	Whether to plot Figures (by default is true)
%
% OUTPUT
%       Filtered_u:     Filtered Displacment [nx1]
%       Filtered_v:     Filtered Velocity [nx1]
%       Filtered_a:     Filtered Acceleration [nx1]
%
%
% EXAMPLE
%   - for the given signal Input_vx
%	load Input_vx.txt
%	x = Input_vx(:,2);
%	t = Input_vx(:,1);
%	dt = Input_vx(2)-Input_vx(1);
%	t_decay = 30; % sec
%	exp_k   = 1;  % constant  
%	Velocity_Exponential_Decay (x,dt,t_decay,exp_k);
%
%==========================================================================
%                     2017 By: Sumeet Kumar Sinha (sumeet.kumar507@gmail.com)

	if nargin > 4
	  plotFiguresFlag = plotFigures;
	else
	  plotFiguresFlag = true;
	end

	Original_v= v(:,1);		   % Original velocity Signal
	dT = dt;                   % Time Period 
	L = size(Original_v,1);    % Size of the Signal
	T = (0:dt:(L-1)*dt)';      % Time of the Signal
	Total_Time = (L-1)*dt;     % total time of the signal

	Original_u = Original_v*0; % original displacement
	Original_a = Original_v*0; % original acceleration 

	Filtered_u = Original_v*0; % filtered displacement
	Filtered_v = Original_v;   % filtered velocity 
	Filtered_a = Original_a*0; % filtered acceleration

	for i = 2:L
		Original_a(i)= (Original_v(i)-Original_v(i-1))/dt;
		Original_u(i)= Original_u(i-1) + Original_v(i-1)*dt + 0.5*Original_a(i)*dt*dt;
	end

	I_decay=  round(t_decay/dt+1);
	I_end  =  L;

	for i=I_decay:I_end
		Filtered_v(i)= Filtered_v(i)*exp(-exp_k*((i-1)*dt-t_decay));
	end

	for i = 2:L
		Filtered_a(i)= (Filtered_v(i)-Filtered_v(i-1))/dt;
		Filtered_u(i)= Filtered_u(i-1) + Filtered_v(i-1)*dt + 0.5*Filtered_a(i)*dt*dt;
	end

	if(plotFiguresFlag)
		figure;
		plot(T,Original_v,'-k','LineWidth',2); hold on;
		plot(T,Filtered_v,'-r','LineWidth',2);
		legend('original','filtered');
		title(strcat('Exponential Decay factor exp^{(-',num2str(exp_k),'*(t-',num2str(t_decay),'))}') );
		xlabel('Time [s]');
		ylabel('Velocity [m/s]');

		figure;
		plot(T,Original_a,'-k','LineWidth',2); hold on;
		plot(T,Filtered_a,'-r','LineWidth',2);
		legend('original','filtered');
		title(strcat('Exponential Decay factor exp^{(-',num2str(exp_k),'*(t-',num2str(t_decay),'))}') );
		xlabel('Time [s]');
		ylabel('Acceleration [m/s^2]');

		figure;
		plot(T,Original_u,'-k','LineWidth',2); hold on;
		plot(T,Filtered_u,'-r','LineWidth',2);
		legend('original','filtered');
		title(strcat('Exponential Decay factor exp^{(-',num2str(exp_k),'*(t-',num2str(t_decay),'))}') );
		xlabel('Time [s]');
		ylabel('Displacement [m]');
	end

end