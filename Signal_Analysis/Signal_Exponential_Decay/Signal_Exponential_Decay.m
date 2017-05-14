
function [Decayed_Signal,T]=Signal_Exponential_Decay(x,dt,t_decay,exp_k)

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
%       [x] :      	    signal data [nx1]
%       [dt]:    		time step [1x1]
%       [t_decay]:    	decay start time [1x1]
%       [exp_k]:    	exponential coefficient k [1x1]
%
% OUTPUT
%       Decayed_Signal:       Decayed Signal [nx1]
%       T:     	              Time [nx1]
%       Plot:     	          Original and Decayed Signal
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
%	Signal_Exponential_Decay (x,dt,t_decay,exp_k);
%
%==========================================================================
%                     2017 By: Sumeet Kumar Sinha (sumeet.kumar507@gmail.com)


	New_X = x(:,1);		     % Signal
	dT = dt;                 % Time Period 
	L = size(New_X,1);       % Size of the Signal
	T = (0:dt:(L-1)*dt)';    % Time of the Signal
	Total_Time = (L-1)*dt;   % total time of the signal

	I_decay=  round(t_decay/dt+1);
	I_end  =  L;

	for i=I_decay:I_end
		New_X(i)= New_X(i)*exp(-exp_k*((i-1)*dt-t_decay));
	end

	% figure;
	plot(T,x,'-k','LineWidth',2); hold on;
	plot(T,New_X,'-r','LineWidth',2);
	legend('original','filtered');
	title(strcat('Exponential Decay factor exp^{(-',num2str(exp_k),'*(t-',num2str(t_decay),'))}') );
	xlabel('Time [s]');
	ylabel('Signal Magnitude x(t)');

	Decayed_Signal = New_X;

end