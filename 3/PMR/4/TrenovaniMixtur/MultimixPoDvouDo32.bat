HHEd -H mono\hmmdefs -M mono-2_0 com2mix monophones 
HERest -C config -t 250.0 150.0 1000.0 -s mono-2_1/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-2_0/hmmdefs -M mono-2_1 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-2_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-2_1/hmmdefs -M mono-2_2 monophones

HHEd -H mono-2_2\hmmdefs -M mono-4_0 com4mix monophones 
HERest -C config -t 250.0 150.0 1000.0 -s mono-4_1/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_0/hmmdefs -M mono-4_1 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-4_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_1/hmmdefs -M mono-4_2 monophones

rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_2/hmmdefs -M mono-4_3 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_4/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_3/hmmdefs -M mono-4_4 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_5/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_4/hmmdefs -M mono-4_5 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_6/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_5/hmmdefs -M mono-4_6 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_7/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_6/hmmdefs -M mono-4_7 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_8/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_7/hmmdefs -M mono-4_8 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_9/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_8/hmmdefs -M mono-4_9 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_10/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_9/hmmdefs -M mono-4_10 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_11/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_10/hmmdefs -M mono-4_11 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-4_12/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-4_11/hmmdefs -M mono-4_12 monophones

HHEd -H mono-4_2\hmmdefs -M mono-8_0 com8mix monophones 
HERest -C config -t 250.0 150.0 1000.0 -s mono-8_1/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-8_0/hmmdefs -M mono-8_1 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-8_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-8_1/hmmdefs -M mono-8_2 monophones

HHEd -H mono-8_2\hmmdefs -M mono-16_0 com16mix monophones 
HERest -C config -t 250.0 150.0 1000.0 -s mono-16_1/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_0/hmmdefs -M mono-16_1 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-16_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_1/hmmdefs -M mono-16_2 monophones

rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_2/hmmdefs -M mono-16_3 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_4/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_3/hmmdefs -M mono-16_4 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_5/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_4/hmmdefs -M mono-16_5 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_6/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_5/hmmdefs -M mono-16_6 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_7/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_6/hmmdefs -M mono-16_7 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_8/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_7/hmmdefs -M mono-16_8 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_9/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_8/hmmdefs -M mono-16_9 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_10/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_9/hmmdefs -M mono-16_10 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_11/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_10/hmmdefs -M mono-16_11 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-16_12/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-16_11/hmmdefs -M mono-16_12 monophones

HHEd -H mono-16_2\hmmdefs -M mono-32_0 com32mix monophones 
HERest -C config -t 250.0 150.0 1000.0 -s mono-32_1/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_0/hmmdefs -M mono-32_1 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-32_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_1/hmmdefs -M mono-32_2 monophones

rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_2/hmmdefs -M mono-32_3 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_4/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_3/hmmdefs -M mono-32_4 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_5/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_4/hmmdefs -M mono-32_5 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_6/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_5/hmmdefs -M mono-32_6 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_7/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_6/hmmdefs -M mono-32_7 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_8/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_7/hmmdefs -M mono-32_8 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_9/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_8/hmmdefs -M mono-32_9 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_10/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_9/hmmdefs -M mono-32_10 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_11/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_10/hmmdefs -M mono-32_11 monophones
rem HERest -C config -t 250.0 150.0 1000.0 -s mono-32_12/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-32_11/hmmdefs -M mono-32_12 monophones


HERest -C config -t 250.0 150.0 1000.0 -s mono-128_2/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_2/hmmdefs -M mono-128_3 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_4/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_3/hmmdefs -M mono-128_4 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_5/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_4/hmmdefs -M mono-128_5 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_6/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_5/hmmdefs -M mono-128_6 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_7/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_6/hmmdefs -M mono-128_7 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_8/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_7/hmmdefs -M mono-128_8 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_9/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_8/hmmdefs -M mono-128_9 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_10/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_9/hmmdefs -M mono-128_10 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_11/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_10/hmmdefs -M mono-128_11 monophones
HERest -C config -t 250.0 150.0 1000.0 -s mono-128_12/stats -S lists\tul-telefony_a_ruchy -H macros -H mono-128_11/hmmdefs -M mono-128_12 monophones