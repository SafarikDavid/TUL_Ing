HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S trainMFCC39.scp -H hmm0/hmmdefsMFCC39 -M hmm1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S trainMFCC39.scp -H hmm1/hmmdefsMFCC39 -M hmm2 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S trainMFCC39.scp -H hmm2/hmmdefsMFCC39 -M hmm3 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S trainMFCC39.scp -H hmm3/hmmdefsMFCC39 -M hmm4 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S trainMFCC39.scp -H hmm4/hmmdefsMFCC39 -M hmm5 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S trainMFCC39.scp -H hmm5/hmmdefsMFCC39 -M hmm6 models0
pause