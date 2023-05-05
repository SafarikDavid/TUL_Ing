function [cep_coeff, mel_fbank] = computeFrameMFCC(frame, N, M, Fs)
    % vypo��t� N p��znak� Fbank a M p��znak� MFCC pro jeden frame �e�i 
    % typick� hodnoty N=26, M=12, Fs=16000, frame 25 ms
    m_low=0;                %spodn� limit mel-stupnice
    m_top=f2mel(Fs/2);      %horn� limit mel-stupnice
    mdiv=(m_top-m_low)/(N-1);   % rozd�len� na N p�sem v mel stupnici
    xm=m_low:mdiv:m_top;  % st�edn� frekvence ka�d�ho p�sma
    xf=mel2f(xm); % st�edn� frekvence p�eveden� zp�t na Hertze
    xq = floor((length(frame)/2 + 1)*xf/(Fs/2));
    S=fft(frame); % v�po�et FFT pro sign�l ve frame
    S=abs(2*(S.*S)/length(S)); % v�po�et energie (kvadr�tu) ka�d� slo�ky
    S=S(1:length(S)/2); % v�b�r prvn� poloviny hodnot 
    F=[1:length(S)]*(Fs/2)/length(S);  % v�d�len� po�tem vzork�
    x1=zeros(1,N);
    for xi=1:N    % cyklus pro v�echna p�sma
        band=spread_mel(xf,xi,length(S),Fs/2); % troj�heln�kov� funkce
        x1(xi)=sum(band.*S');   % v�po�et energie v p�smu
    end
    x=log(x1);   % v�po�et logaritmu energie v�ech p�sem
    mel_fbank = x;  % mel-spektr. p��znaky spo��t�ny
    cep_coeff=zeros(1,M);
    for xc=1:M   % disktr�tn� kosinov� transformace
        cep_coeff(xc)=sqrt(2/N)*sum(x.*cos(pi*xc*([1:N]-0.5)/N));
end