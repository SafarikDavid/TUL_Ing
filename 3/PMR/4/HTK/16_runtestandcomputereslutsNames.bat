HVite -H hmm6/hmmdefs -S testNames.scp -i recout.mlf -w wordnetNames -p -70.0 -s 0 dictNames models0
HResults -e ??? SENT-START -e ??? SENT-END -t -I testrefNames.mlf models0 recout.mlf
pause