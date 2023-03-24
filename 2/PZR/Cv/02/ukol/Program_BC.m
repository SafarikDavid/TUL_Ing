clc; clear all; close all;

paths = readlines("paths.txt");
pocet_nahravek = length(paths);

pocet_vzorku_v_segmentu = 400;
frame_len = 160;

play_long_audio = false;

for i = 1:pocet_nahravek
    close all;

    [x, Fs] = audioread(paths(i), "native");
    x_len = length(x);
    
%     plot original signal
    figure(1)
    subplot(4,1,1)
    t = 0:1/Fs:x_len/Fs - 1/Fs;
    plot(t, x)
    title(paths(i))

%     play original audio
    if play_long_audio == true
        player = audioplayer(x,Fs);
        player.playblocking;
    end

%     add noise
    x = x + (randi(3, 32000, 1, 'int16') -2);
%     filter
    xf = filter([1 -0.97], 1, x);
    
%     plot signal after filter
    subplot(4,1,2)
    t = 0:1/Fs:x_len/Fs - 1/Fs;
    plot(t, xf)
    title("After filter")

%     play audio after filter and noise
    if play_long_audio == true
        soundsc(xf, Fs)
        pause(2)
    end

%     doplneni o nuly kvuli velikosti framu
    xf = [xf; zeros(pocet_vzorku_v_segmentu, 1)];
    
%     segmentace a vypocet energie a zcr
    frames = [];
    energy = [];
    zcr = [];
    for frame_start = 1:frame_len:x_len
        segment = xf(frame_start:frame_start+pocet_vzorku_v_segmentu-1);
        frames = [frames segment];
        energy = [energy log(dot(segment, segment))];
        zcr_temp = 0;
        for j = 2:length(segment)
            zcr_temp = zcr_temp + abs(sign(segment(j)) - sign(segment(j-1)));
        end
        zcr = [zcr zcr_temp/(2*(pocet_vzorku_v_segmentu-1))];
    end

%     hledani prumeru energie
    k_extremas = 5;
    min_energy_frames = mink(energy, k_extremas);
    mean_min_energy = mean(min_energy_frames);

    max_energy_frames = maxk(energy, k_extremas);
    mean_max_energy = mean(max_energy_frames);

    procento_prahu = 0.9;
    prah_energie = abs(mean_max_energy - mean_min_energy) * procento_prahu;

%     hledani zacatku a konce slova
    start_command = 1;
    end_command = length(energy);
    while (energy(start_command)) < prah_energie
        start_command = start_command + 1;
    end
    while (energy(end_command)) < prah_energie
        end_command = end_command - 1;
    end

%     vyriznuti slova
    vyrez = xf(frame_len*(start_command-1)+1:frame_len*end_command);

%     prehrani vyrezu
    soundsc(vyrez, Fs)

%     vykresleni svislych car do plotu signalu po filtru
    hold on
    xline(start_command*frame_len/Fs)
    xline(end_command*frame_len/Fs)

%     plot energie
    subplot(4,1,3)
    plot(energy)
    title('energie')
    hold on
    xline(start_command)
    xline(end_command)

%     plot zcr
    subplot(4,1,4)
    plot(zcr)
    title('zcr')
    hold on
    xline(start_command)
    xline(end_command)

%     pozdrzeni programu
    w = waitforbuttonpress;
end