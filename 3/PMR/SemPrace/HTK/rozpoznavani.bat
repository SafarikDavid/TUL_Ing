HVite -H models/hmmdefs1606 -S test.scp -i recout.mlf -w outLatFile -p -15.0 -s 0.52 -t 500.0 dict models0
HResults -e ??? !ENTER -e ??? !EXIT -e ??? SILENCE -e ??? SILENCE1 -e ??? SILENCE2 -e ??? SILENCE3 -e ??? SILENCE4 -e ??? SILENCE5 -t -I testref.mlf models0 recout.mlf
pause