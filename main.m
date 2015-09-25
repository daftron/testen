% ===========================================================
% Main file Audiotechnik Abgab3 3 
% David Ackermann 
close all
clearvars
%% FX
% Read the audio file
filename = 'guitar.wav';
[sig, fs] = wavread(filename);
[num_sample, channel] = size(sig);
if(channel == 2)
   sig= (sig(:,1) + sig(:,2)) / 2;
end 
% sig=[1; 2; 3; 4; 5; 6; 7];
% sig=[-1; 0; -1; 0; -1; 0; -1; 0; -1; 0; -1; 0; -1];
% sig=0:1/1000:20;
%  sig(3*64:end)=[];
%  sig=zeros(1,100);


Modfreq = 100; % bzw. Lowcut frequenz noise
mode = 'sin';
% mode = 'noise';
Width = 0.001;
Delay = 0.0005;
BL = 0;
FF = 1;
FB = 0;
%% a.) Implementierung Blockschaltbild
[output_konti]  = fx_daf(sig,fs,Modfreq,Width,FF,FB,BL,mode,Delay);
% %Evaluation
sound(sig,fs)
soundsc(output_konti,fs)
%% b.) DAW Simulation blockweise Verarbeitung
blocksize = 64;
[output_daw ]= daw_daf(sig,blocksize,fs,Modfreq,Width,FF,FB,BL,mode,Delay);
% % Evaluation
soundsc(output_daw,fs)
% Fehlerfunktion Kontinuirlich vs. Blockweise
err = output_konti-output_daw;
plot(err)
title('Kontinuierliche vs. Blockweise Verarbeitung');
xlable('Samples');
ylable('Amplitude');
%% 4 Filter nach Zölzer S.71
blocksize = 512;
%% Vibrato ----------------------------------------------------------------
Modfreq = 5; % bzw. Lowcut frequenz noise
mode = 'sin';
% mode = 'noise';
Width = 0.003;
Delay = 0;
BL = 0;
FF = 1;
FB = 0;
[ fx_git_vibrato fx_vox_vibrato Fs_git Fs_vox] = evaluation(blocksize,Modfreq,Width,FF,FB,BL,mode,Delay);
wavwrite(fx_git_vibrato,Fs_git,'wav_GTR_vibrato')
wavwrite(fx_vox_vibrato,Fs_vox,'wav_VOX_vibrato')
soundsc(fx_git_vibrato,fs)
soundsc(fx_vox_vibrato,fs)
%% Flanger ----------------------------------------------------------------
Modfreq = 0.2; % bzw. Lowcut frequenz noise
mode = 'sin';
% mode = 'noise';
Width = 0.002;
Delay = 0;
BL = 0.7;
FF = 0.7;
FB = 0.7;
[ fx_git_flanger fx_vox_flanger Fs_git Fs_vox] = evaluation(blocksize,Modfreq,Width,FF,FB,BL,mode,Delay);
wavwrite(fx_git_flanger,Fs_git,'wav_GTR_flanger')
wavwrite(fx_vox_flanger,Fs_vox,'wav_VOX_flanger')
soundsc(fx_git_flanger,fs)
soundsc(fx_vox_flanger,fs)
%% (white) Chorus ----------------------------------------------------------------
Modfreq = 1; % bzw. Lowcut frequenz noise
% mode = 'sin';
mode = 'noise';
Width = 0.006;
Delay = 0.02;
BL = 0.7;
FF = 1;
% FB = 0;         % Chorus
FB = -0.7;    % White Chorus
[ fx_git_chorus fx_vox_chorus Fs_git Fs_vox] = evaluation(blocksize,Modfreq,Width,FF,FB,BL,mode,Delay);
wavwrite(fx_git_chorus,Fs_git,'wav_GTR_chorus')
wavwrite(fx_vox_chorus,Fs_vox,'wav_VOX_chorus')
soundsc(fx_git_chorus,fs)
soundsc(fx_vox_chorus,fs)
%% Doubling ----------------------------------------------------------------
Modfreq = 3; % bzw. Lowcut frequenz noise
% mode = 'sin';
mode = 'noise';
Width = 0.001;
Delay = 0.05;
BL = 0.7;
FF = 0.7;
FB = 0;
[ fx_git_doubl fx_vox_doubl Fs_git Fs_vox] = evaluation(blocksize,Modfreq,Width,FF,FB,BL,mode,Delay);
wavwrite(fx_git_doubl,Fs_git,'wav_GTR_doub')
wavwrite(fx_vox_doubl,Fs_vox,'wav_VOX_doub')
soundsc(fx_git_doubl,fs)
soundsc(fx_vox_doubl,fs)
%% c.) Morphen-----------------------------------------------------------
clearvars
blocksize = 512;
% Read the audio file
filename = 'guitar.wav';
[sig, fs] = wavread(filename);
[num_sample, channel] = size(sig);
if(channel == 2)
   sig= (sig(:,1) + sig(:,2)) / 2;
end 
sig(191990:end) =[] ;
sig=[sig;sig;sig;sig]; %Audio loopen 

%  sig=0:1/10000:20;
% sig(3*64:end)=[];
% sig=sig';

Modfreq = [0    4     0.2   1     3     ];
Width =   [0    0.003 0.002 0.006 0.001 ];
% Width =   [0    0.001 0.001 0.001 0.001 ];
Delay =   [0    0     0     0.02  0.1   ];
BL =      [0    0     0.7   0.7   0.7   ];
FF =      [1    1     0.7   1     0.7   ];
FB =      [0    0     0.7   0     0     ];
mode = {'sin', 'sin', 'sin', 'noise', 'noise'};
% mode = {'sin', 'sin', 'sin', 'sin', 'sin', 'sin'};

[fx_moroh ]= daw_morph_daf(sig,blocksize,fs,Modfreq,Width,FF,FB,BL,mode,Delay); % Evaluation
fx_moroh=fx_moroh./max(abs(fx_moroh)+0.01);
wavwrite(fx_moroh,fs,'wav_Morph')
soundsc(fx_moroh,fs)
