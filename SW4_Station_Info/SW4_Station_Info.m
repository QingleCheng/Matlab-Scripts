function [Ux,Uy,Uz,Vx,Vy,Vz,Ax,Ay,Az,T,dt]=SW4_Station_Info(filepath,stationId,plotFigures)

%SW4 Station Reader (SW4_Station_Info)
%--------------------------------------------------------------------------
% Reads the SW4 station information for a given station Id and outputs the
% velocities in Vx, Vy, Vz, time T and time step dt. 
%
% SYNTAX
%       SW4_Station_Info(stationId)
%
% INPUT
%       [filepath] :        path of SW4 output folder [string]
%       [stationId] :       Id of Station [string]
%		[plotFigures] : 	Whether to plot Figures (by default is true)
%
% OUTPUT
%		Ux:				Displacement in X-direction [nx1]
%		Uy:				Displacement in Y-direction [nx1]
%		Uz:				Displacement in Z-direction [nx1]
%		Vx:				Velocity in X-direction [nx1]
%		Vy:				Velocity in Y-direction [nx1]
%		Vz:				Velocity in Z-direction [nx1]
%		Ax:				Acceleration in X-direction [nx1]
%		Ay:				Acceleration in Y-direction [nx1]
%		Az:				Acceleration in Z-direction [nx1]
%		T:				Time [nx1]
%		dt:				Time Step [1x1]
%       plot:           Plot of Vx, Vy and vz 
%
%
% EXAMPLE
% 	With E3397.x, E3397.y and E3397.z output file: SW4_Station_Info('./','E3397');
%
%==========================================================================
%                     2016 By: Sumeet Kumar Sinha (sumeet.kumar507@gmail.com)

	if nargin > 2
	  plotFiguresFlag = plotFigures;
	else
	  plotFiguresFlag = true;
	end

	Station_X = strcat(filepath,'/',stationId,'.x');
	Station_Y = strcat(filepath,'/',stationId,'.y');
	Station_Z = strcat(filepath,'/',stationId,'.z');

	[Vx, dt, lat, lon, b, e, npts, year, jday, hour, min, sec, msec, cmpaz, cmpinc, idep, stnam ]=readsac(Station_X);
	[Vy, dt, lat, lon, b, e, npts, year, jday, hour, min, sec, msec, cmpaz, cmpinc, idep, stnam ]=readsac(Station_Y);
	[Vz, dt, lat, lon, b, e, npts, year, jday, hour, min, sec, msec, cmpaz, cmpinc, idep, stnam ]=readsac(Station_Z);

	T = [0:dt:dt*npts-dt]';

	Vy = -Vy; Vz = -Vz;
	Ux = Vx*0; Uy = Vx*0; Uz = Vx*0;
	Ax = Vx*0; Ay = Vx*0; Az = Vx*0;

	for i = 2:npts
		Ax(i)= (Vx(i)-Vx(i-1))/dt;
		Ay(i)= (Vy(i)-Vy(i-1))/dt;
		Az(i)= (Vz(i)-Vz(i-1))/dt;
		Ux(i)= Ux(i-1) + Vx(i-1)*dt + 0.5*Ax(i)*dt*dt;
		Uy(i)= Uy(i-1) + Vy(i-1)*dt + 0.5*Ay(i)*dt*dt;
		Uz(i)= Uz(i-1) + Vz(i-1)*dt + 0.5*Az(i)*dt*dt;
	end


	if(plotFiguresFlag)
		figure;
		plot(T,Vx,'k-','linewidth',2); hold on;
		plot(T,Vy,'b-','linewidth',2); hold on;
		plot(T,Vz,'r-','linewidth',2); hold on;
		xlabel('Time [s]');
		ylabel('Velocity [m/s]');
		legend('V_x','V_y','V_z');
		print(strcat(stationId,'_vel_xyz'), '-dpng', '-r300'); %<-Save as PNG with 300 DPI

		figure;
		plot(T,Ux,'k-','linewidth',2); hold on;
		plot(T,Uy,'b-','linewidth',2); hold on;
		plot(T,Uz,'r-','linewidth',2); hold on;
		xlabel('Time [s]');
		ylabel('Displacement [m]');
		legend('U_x','U_y','U_z');
		print(strcat(stationId,'_disp_xyz'), '-dpng', '-r300'); %<-Save as PNG with 300 DPI

		figure;
		plot(T,Ax,'k-','linewidth',2); hold on;
		plot(T,Ay,'b-','linewidth',2); hold on;
		plot(T,Az,'r-','linewidth',2); hold on;
		xlabel('Time [s]');
		ylabel('Acceleration [m/s^2]');
		legend('A_x','A_y','A_z');
		print(strcat(stationId,'_accel_xyz'), '-dpng', '-r300'); %<-Save as PNG with 300 DPI
	end
end