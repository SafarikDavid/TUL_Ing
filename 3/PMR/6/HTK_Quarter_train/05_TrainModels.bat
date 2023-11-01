HHEd -H hmm0\hmmdefs -M mono-2_0 com2mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_1/stats -S train.scp -H mono-2_0/hmmdefs -M mono-2_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-2_2/stats -S train.scp -H mono-2_1/hmmdefs -M mono-2_2 models0

HHEd -H mono-2_2\hmmdefs -M mono-4_0 com4mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_1/stats -S train.scp -H mono-4_0/hmmdefs -M mono-4_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-4_2/stats -S train.scp -H mono-4_1/hmmdefs -M mono-4_2 models0

HHEd -H mono-4_2\hmmdefs -M mono-8_0 com8mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_1/stats -S train.scp -H mono-8_0/hmmdefs -M mono-8_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-8_2/stats -S train.scp -H mono-8_1/hmmdefs -M mono-8_2 models0

HHEd -H mono-8_2\hmmdefs -M mono-16_0 com16mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_1/stats -S train.scp -H mono-16_0/hmmdefs -M mono-16_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-16_2/stats -S train.scp -H mono-16_1/hmmdefs -M mono-16_2 models0

HHEd -H mono-16_2\hmmdefs -M mono-32_0 com32mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_1/stats -S train.scp -H mono-32_0/hmmdefs -M mono-32_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-32_2/stats -S train.scp -H mono-32_1/hmmdefs -M mono-32_2 models0

HHEd -H mono-32_2\hmmdefs -M mono-64_0 com32mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-64_1/stats -S train.scp -H mono-64_0/hmmdefs -M mono-64_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-64_2/stats -S train.scp -H mono-64_1/hmmdefs -M mono-64_2 models0

HHEd -H mono-64_2\hmmdefs -M mono-128_0 com32mix models0 
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-128_1/stats -S train.scp -H mono-128_0/hmmdefs -M mono-128_1 models0
HERest -C TrainConfig-MFCC39 -I train.mlf -t 250.0 150.0 1000.0 -s mono-128_2/stats -S train.scp -H mono-128_1/hmmdefs -M mono-128_2 models0
