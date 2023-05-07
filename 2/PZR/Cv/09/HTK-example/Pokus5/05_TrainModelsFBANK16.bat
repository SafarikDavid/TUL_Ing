HERest -C TrainConfig-FBANK16 -I train.mlf -t 250.0 150.0 1000.0 -S trainFBANK16.scp -H hmm0/hmmdefsFBANK16 -M hmm1 models0
HERest -C TrainConfig-FBANK16 -I train.mlf -t 250.0 150.0 1000.0 -S trainFBANK16.scp -H hmm1/hmmdefsFBANK16 -M hmm2 models0
HERest -C TrainConfig-FBANK16 -I train.mlf -t 250.0 150.0 1000.0 -S trainFBANK16.scp -H hmm2/hmmdefsFBANK16 -M hmm3 models0
HERest -C TrainConfig-FBANK16 -I train.mlf -t 250.0 150.0 1000.0 -S trainFBANK16.scp -H hmm3/hmmdefsFBANK16 -M hmm4 models0
HERest -C TrainConfig-FBANK16 -I train.mlf -t 250.0 150.0 1000.0 -S trainFBANK16.scp -H hmm4/hmmdefsFBANK16 -M hmm5 models0
HERest -C TrainConfig-FBANK16 -I train.mlf -t 250.0 150.0 1000.0 -S trainFBANK16.scp -H hmm5/hmmdefsFBANK16 -M hmm6 models0
pause