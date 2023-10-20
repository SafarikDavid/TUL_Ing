HVite -H mono-32_8/hmmdefs -S test.scp -i recout.mlf -w wordnet -p -140.0 -s 1 dict models0
HResults -e ??? SENT-START -e ??? SENT-END -t -I testref.mlf models0 recout.mlf
pause