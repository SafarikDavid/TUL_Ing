clc; clear all; close all;

Fs = 16000;

do_path = "misc/do.wav";
nastupiste_path = "misc/nastupiste.wav";
odjizdi_path = "misc/odjizdi.wav";
z_path = "misc/z.wav";
ze_path = "misc/ze.wav";
vlaky_paths = ["vlak/osobni_vlak.wav", "vlak/rychlik.wav", "vlak/rychlik_vyssi_kvality.wav", "vlak/spesny_vlak.wav"];
mesta_paths = ["mesto/brna.wav", "mesto/decina.wav", "mesto/hradce_kralove.wav", "mesto/liberce.wav", "mesto/plzne.wav", "mesto/prahy.wav", "mesto/usti_nad_labem.wav",];
cislo_nastupiste_paths = ["cislo_nastupiste/1.wav", "cislo_nastupiste/2.wav", "cislo_nastupiste/3.wav", "cislo_nastupiste/4.wav", "cislo_nastupiste/5.wav", "cislo_nastupiste/6.wav", "cislo_nastupiste/7.wav", "cislo_nastupiste/8.wav", "cislo_nastupiste/9.wav"];

vlak_index = randi(length(vlaky_paths));
mesto_index = randi(length(mesta_paths));
nastupiste_index = randi(length(cislo_nastupiste_paths));

wav_vlak = loadwav(vlaky_paths(vlak_index));
wav_do = loadwav(do_path);
wav_mesto = loadwav(mesta_paths(mesto_index));
wav_odjizdi = loadwav(odjizdi_path);
wav_cislo_nastupiste = loadwav(cislo_nastupiste_paths(nastupiste_index));
wav_nastupiste = loadwav(nastupiste_path);
wav_z = loadwav(z_path);
if ismember(nastupiste_index, [3 4 6 7])
    wav_z = loadwav(ze_path);
end

wav_final = [wav_vlak; wav_do; wav_mesto; wav_odjizdi; wav_z; wav_cislo_nastupiste; wav_nastupiste];
soundsc(wav_final, Fs)

function wav = loadwav(path)
    [wav, ~] = audioread(path);
end