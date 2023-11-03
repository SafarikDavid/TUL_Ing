HVite -H mono-2_2/hmmdefs -S test.scp -i recout.mlf -w wordnet -p -70.0 -s 0 dict models0
HResults -t -I testref.mlf models0 recout.mlf
pause