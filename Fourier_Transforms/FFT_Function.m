function Coeffs = FFT_Function(P)

    no_of_harmonics = 50;

    P_freq = fft(P);

    m = length(P_freq);
    M = floor((m+1)/2);

    a0_P = P_freq(1)/m; 
    an_P = 2*real(P_freq(2:M))/m;
    afinal_P = P_freq(M+1)/m;
    bn_P = -2*imag(P_freq(2:M))/m;
    
    T = 1;
    Act_Time = linspace(0,T,100);
%     for j = 1:length(Act_Time)
%         t = Act_Time(j);
% 
%         P_recovered_temp = 0;
% 
%         P_recovered(j,1) = a0_P;
% 
%         for i = 1:no_of_harmonics-1
%             freq = 2*i*pi/T;
%             P_recovered_temp = an_P(i)*cos(freq*t)+bn_P(i)*sin(freq*t);
%             P_recovered(j,1) = P_recovered(j,1) + P_recovered_temp;
%         end
%     end
%     plot(Act_Time,P,'o',Act_Time,P_recovered);
%     pause(1)
    
    Coeffs1(1,1) = a0_P;
    Coeffs1(2:49,1) = an_P(1:48);
    Coeffs2(:,1) = bn_P(1:49);
    
    Coeffs = vertcat(Coeffs1,Coeffs2);
end

