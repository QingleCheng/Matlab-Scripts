
function [Filtered_Motion,T]=Filter_Signal_Frequency(x,dt,fmin,fmax)

%Filtered Signal Frequency (SFBMD)
%--------------------------------------------------------------------------
% This function filters the signal within a particular frequency range 
% f_min and f_max and outputs the filtered signal and time.
%
% SYNTAX
%       Filter_Signal_Frequency(x,dt,fmin,fmax)
%
% INPUT
%       [x] :      	    signal data [nx1]
%       [dt]:    		time step [1x1]
%       [fmin]:    		minimum frequency [1x1]
%       [fmax]:    		minimum frequency [1x1]
%
% OUTPUT
%       Filtered_Motion:      Filtered Signal [nx1]
%       T:     	          	  Time [nx1]
%       Plot:     	          Original and Filtered Signal
%
%
% EXAMPLE
%   - for the given signal Input_vx
%	load Input_vx.txt
%	x = Input_vx(:,2);
%	t = Input_vx(:,1);
%	dt = Input_vx(2)-Input_vx(1);
%	f_min = 1; % minimum frequency 
%	f_max = 20;  % maximum frequency   
%	Filter_Signal_Frequency (x,dt,f_min,f_max);
%
%==========================================================================
%                     2017 By: Sumeet Kumar Sinha (sumeet.kumar507@gmail.com)

	X = x(:,1);		   % Original Signal
	dT = dt;           % Time Period 
	F_s = 1/dT;        % Sampling Frequency
	L = size(X,1);     % Length of the Signal
	T = (dt:dt:L*dt)'; 

	New_L =L;
	New_X=X;
	New_T=T;

	Y = fft(New_X);
	Index_Middle = (New_L+1)/2;

	Amp  = abs(Y);
	Phase_Angle = atan(real(Y)./imag(Y));

	Pos_Amp  = Amp(1:Index_Middle);
	Pos_Phase_Angle = Phase_Angle(1:Index_Middle);
	Pos_Freq = ((0:F_s:F_s*(New_L-1)/2)/New_L)';


	%%%%%%%% Filtering Frequency %%%%%%%%%

	Index_Start  = 1+round(fmin*New_L/F_s);
	Index_End    = 1+round(fmax*New_L/F_s);

	if(Index_End>((New_L+1)/2))
		Index_End = ((New_L+1)/2);
	end

	if(Index_Start~=1)
		Pos_Amp(1:Index_Start)= 0;
		Y(1:Index_Start)=0;
		Y(end-Index_Start:end)=0;
	end

	Pos_Amp(Index_End:Index_Middle)=0;
	Y(Index_End:Index_Middle)=0;
	Y(Index_Middle:2*Index_Middle-Index_End)=0;

	%%%%%%%%% Inverse FFT %%%%%%%%%%%%%%

	figure ;
	IFFT_X = ifft(Y);
	plot(New_T,IFFT_X,'-r','linewidth',2);hold on;
	plot(New_T,New_X,'-k','linewidth',2);
	legend('filtered','original');
	title(strcat('Signal Filtered Between Frequencies [',num2str(fmin),' , ',num2str(fmax),'] Hz'));
	xlabel('Time [s]');
	ylabel('Signal Magnitude x(t)');

	Filtered_Motion = IFFT_X;
	t = New_T;

end