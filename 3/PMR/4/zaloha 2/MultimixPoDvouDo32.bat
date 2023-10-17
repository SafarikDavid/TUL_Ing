HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/hmmdefs -M hmm1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/hmmdefs -M hmm2 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/hmmdefs -M hmm3 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm3/hmmdefs -M hmm4 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm4/hmmdefs -M hmm5 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm5/hmmdefs -M hmm6 models0

HHEd -H hmm6\hmmdefs -M mono-2_0 com2mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_1/stats -S train.scp -H mono-2_0/hmmdefs -M mono-2_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_2/stats -S train.scp -H mono-2_1/hmmdefs -M mono-2_2 models0

HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_2/stats -S train.scp -H mono-2_2/hmmdefs -M mono-2_3 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_4/stats -S train.scp -H mono-2_3/hmmdefs -M mono-2_4 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_5/stats -S train.scp -H mono-2_4/hmmdefs -M mono-2_5 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_6/stats -S train.scp -H mono-2_5/hmmdefs -M mono-2_6 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_7/stats -S train.scp -H mono-2_6/hmmdefs -M mono-2_7 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_8/stats -S train.scp -H mono-2_7/hmmdefs -M mono-2_8 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_9/stats -S train.scp -H mono-2_8/hmmdefs -M mono-2_9 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_10/stats -S train.scp -H mono-2_9/hmmdefs -M mono-2_10 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_11/stats -S train.scp -H mono-2_10/hmmdefs -M mono-2_11 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_12/stats -S train.scp -H mono-2_11/hmmdefs -M mono-2_12 models0

HHEd -H mono-2_12\hmmdefs -M mono-4_0 com4mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_1/stats -S train.scp -H mono-4_0/hmmdefs -M mono-4_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_2/stats -S train.scp -H mono-4_1/hmmdefs -M mono-4_2 models0

HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_2/stats -S train.scp -H mono-4_2/hmmdefs -M mono-4_3 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_4/stats -S train.scp -H mono-4_3/hmmdefs -M mono-4_4 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_5/stats -S train.scp -H mono-4_4/hmmdefs -M mono-4_5 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_6/stats -S train.scp -H mono-4_5/hmmdefs -M mono-4_6 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_7/stats -S train.scp -H mono-4_6/hmmdefs -M mono-4_7 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_8/stats -S train.scp -H mono-4_7/hmmdefs -M mono-4_8 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_9/stats -S train.scp -H mono-4_8/hmmdefs -M mono-4_9 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_10/stats -S train.scp -H mono-4_9/hmmdefs -M mono-4_10 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_11/stats -S train.scp -H mono-4_10/hmmdefs -M mono-4_11 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_12/stats -S train.scp -H mono-4_11/hmmdefs -M mono-4_12 models0

HHEd -H mono-4_12\hmmdefs -M mono-8_0 com8mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_1/stats -S train.scp -H mono-8_0/hmmdefs -M mono-8_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_2/stats -S train.scp -H mono-8_1/hmmdefs -M mono-8_2 models0

HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_2/stats -S train.scp -H mono-8_2/hmmdefs -M mono-8_3 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_4/stats -S train.scp -H mono-8_3/hmmdefs -M mono-8_4 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_5/stats -S train.scp -H mono-8_4/hmmdefs -M mono-8_5 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_6/stats -S train.scp -H mono-8_5/hmmdefs -M mono-8_6 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_7/stats -S train.scp -H mono-8_6/hmmdefs -M mono-8_7 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_8/stats -S train.scp -H mono-8_7/hmmdefs -M mono-8_8 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_9/stats -S train.scp -H mono-8_8/hmmdefs -M mono-8_9 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_10/stats -S train.scp -H mono-8_9/hmmdefs -M mono-8_10 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_11/stats -S train.scp -H mono-8_10/hmmdefs -M mono-8_11 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_12/stats -S train.scp -H mono-8_11/hmmdefs -M mono-8_12 models0

HHEd -H mono-8_12\hmmdefs -M mono-16_0 com16mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_1/stats -S train.scp -H mono-16_0/hmmdefs -M mono-16_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_2/stats -S train.scp -H mono-16_1/hmmdefs -M mono-16_2 models0

HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_2/stats -S train.scp -H mono-16_2/hmmdefs -M mono-16_3 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_4/stats -S train.scp -H mono-16_3/hmmdefs -M mono-16_4 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_5/stats -S train.scp -H mono-16_4/hmmdefs -M mono-16_5 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_6/stats -S train.scp -H mono-16_5/hmmdefs -M mono-16_6 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_7/stats -S train.scp -H mono-16_6/hmmdefs -M mono-16_7 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_8/stats -S train.scp -H mono-16_7/hmmdefs -M mono-16_8 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_9/stats -S train.scp -H mono-16_8/hmmdefs -M mono-16_9 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_10/stats -S train.scp -H mono-16_9/hmmdefs -M mono-16_10 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_11/stats -S train.scp -H mono-16_10/hmmdefs -M mono-16_11 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_12/stats -S train.scp -H mono-16_11/hmmdefs -M mono-16_12 models0

HHEd -H mono-16_12\hmmdefs -M mono-32_0 com32mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_1/stats -S train.scp -H mono-32_0/hmmdefs -M mono-32_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_2/stats -S train.scp -H mono-32_1/hmmdefs -M mono-32_2 models0

HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_2/stats -S train.scp -H mono-32_2/hmmdefs -M mono-32_3 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_4/stats -S train.scp -H mono-32_3/hmmdefs -M mono-32_4 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_5/stats -S train.scp -H mono-32_4/hmmdefs -M mono-32_5 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_6/stats -S train.scp -H mono-32_5/hmmdefs -M mono-32_6 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_7/stats -S train.scp -H mono-32_6/hmmdefs -M mono-32_7 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_8/stats -S train.scp -H mono-32_7/hmmdefs -M mono-32_8 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_9/stats -S train.scp -H mono-32_8/hmmdefs -M mono-32_9 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_10/stats -S train.scp -H mono-32_9/hmmdefs -M mono-32_10 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_11/stats -S train.scp -H mono-32_10/hmmdefs -M mono-32_11 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_12/stats -S train.scp -H mono-32_11/hmmdefs -M mono-32_12 models0
