HVite -H hmm6/hmmdefsMFCC39 -S testMFCC39.scp -i recout.mlf -w wordnet -p -70.0 -s 0 dict models0
HResults -e ??? SENT-START -e ??? SENT-END -t -I testref.mlf models0 recout.mlf
pause