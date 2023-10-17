HVite -H mono-2_12/hmmdefs -S testSI.scp -i recout.mlf -w wordnet -p -70.0 -s 0 dict models0
HResults -e ??? SENT-START -e ??? SENT-END -t -I testrefSI.mlf models0 recout.mlf
pause