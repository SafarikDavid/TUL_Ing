HVite -H models/hmmdefs3206 -S test.scp -i recout.mlf -w outLatFile -p -22.0 -s 7.4 -t 150.0 dict models0
HResults -e ??? !ENTER -e ??? !EXIT -e ??? SILENCE -e ??? SILENCE1 -e ??? SILENCE2 -e ??? SILENCE3 -e ??? SILENCE4 -e ??? SILENCE5 -t -I testref.mlf models0 recout.mlf
pause