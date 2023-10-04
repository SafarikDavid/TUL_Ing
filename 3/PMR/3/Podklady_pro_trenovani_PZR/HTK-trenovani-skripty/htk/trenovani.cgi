#!/usr/bin/perl
use strict;
use locale;
use FILE::PATH;
use FILE::FIND;
use File::Basename;
use File::Copy;

#Poznamka: script je napsan pro jazyk PERL. Je nutne mit nainstalovan PERL i HTK - pripadne je nutne udelat upravy a volat primo EXE soubory

#prepinace pro vyber jednotlivych kroku
my $k0 = 1; # priprava dat: vytvoreni MLF
my $k1 = 1; # krok 1 parametrizace ANO/NE
my $k3 = 1; # krok 2-3 prototyp a HCOMPV ANO/NE
my $k4 = 1; # krok 4 rozkopirovani prototype ANO/NE
my $k5 = 1; # krok 5, HREST ANO/NE


my $rootDir = 'c:/htk';    		#vychozi adresar

my $audioDir = "$rootDir/data";		#adresar s audio daty a prepisy *.wav a *.lab - data by mela byt v podadresarich (pripadne upravit script nacitani v k0)

my $alphabetFile = "$rootDir/alphabet48.abc";   #soubor s abecedou pro HTK
my $monophonesLst = "$rootDir/monophones.lst";	#soubor se seznamem samotnych hlasek ve formatu HTK

my $parDir = "$rootDir/mfcc";
my $protDir = "$rootDir/prot";
my $hmmDir = "$rootDir/hmm";

my $wavExt = ".wav";	#pripona audio souboru

my $hcopyConf = "$rootDir/param.cfg";
my $hcopyParLst = "$parDir/mfcc.lst";

my $hcompvConf = "$protDir/config";
my $hcompvDataLst = "$protDir/prot.lst"; 	#seznam pro hcompv
my $hcompvPrototype = "$protDir/prot"; 		#soubor s prototype
my $hcompvProtOutDir = "$hmmDir/hmm"; 		#adresar s vystupnim prototype
my $hcompvProtOut = "$hmmDir/prot";     	#vystup z hcompv s prototype
my $hcompvVFloorOut = "$hmmDir/vFloors";     	#vystup z hcompv s vektorem rozptylu

my $herestConf = "$hmmDir/config";

my $herestMlfLst = "$hmmDir/phones.mlf";	#seznam phones0




my $hmmdefs = "$hcompvProtOutDir.0/hmmdefs"; 	#pocatecni definice pro hlasky
my $hmmmacro = "$hcompvProtOutDir.0/macros"; 	#makro pro hmm




#nacteni abecedy pro HTK ze souboru a vytvoreni seznamu "monophones"
my %alphabet; #hash - klic ceky znak, hodnota znak pro HTK
open(MYALPHABETFILE, "<$alphabetFile" )or die "Can't read alphabet";
open (MYMONOPHONES,">$monophonesLst") or die "Can't creat monophonesLst";
my @lines = <MYALPHABETFILE>;
#foreach my $line (@lines)
for(my $i=1; $i<$#lines+1; $i++)
{
   my $line = $lines[$i];
   my @znaky = split(' ',$line);
   $alphabet{$znaky[$#znaky-1]} = $znaky[$#znaky];
   printf("$znaky[$#znaky-1] $znaky[$#znaky]\n");
   print(MYMONOPHONES "$znaky[$#znaky]\n");
}
close(MYMONOPHONES);
close(MYALPHABETFILE);
###

if ($k0!=0)
{

####parametrizace ZACATEK
#vytvoreni seznamu souboru pro parametrizaci: "jmeno souboru.wav" "jmeno parametrizovaneho souboru.mfcc"
open(MYFILE, ">$hcopyParLst" )or die "Can't write audio list";


#vytvoreni seznamu parametrizovanych souboru pro hcompv v dalsim kroku: "jmeno parametrizovaneho souboru.mfcc"
open (MYFILE2, ">$hcompvDataLst" )or die "Can't write proto list";


#vytvoreni souboru MLF z *.lab souboru pro HEREST, alternativne lze zkopirovat pro kazdy parametrizovany soubor jeho .lab prepis do stejneho adresare se stejnym jmenem
open (MYFILE3, ">$herestMlfLst" )or die "Can't write MLF file";
print(MYFILE3 "#!MLF!#\n");


my @files = <$audioDir/*>;
foreach my $file (@files) {
  my @subFiles = <$file/*$wavExt>;


  foreach my $subFile (@subFiles)
  {
       (my $base, my $path, my $type) = fileparse($subFile,"$wavExt");

  	print MYFILE "$subFile $parDir/$base.mfcc \n";
        print MYFILE2 "$parDir/$base.mfcc \n";
  }
  @subFiles = <$file/*.lab>;
  foreach my $subFile (@subFiles)
  {
        (my $base, my $path, my $type) = fileparse($subFile,'.lab');
         my $pPath = "$parDir/$base.lab";

         #zkopirovani souboru *.lab k parametrizovanym souborum, pokud neni vytvaren *.MLF
         #copy($subFile, $pPath) or die "File cannot be copied.";

         print MYFILE3 "\"$pPath\"\n";
         open (MYLABFILE, "<$subFile")or die "can't read .lab file: $subFile";
         my @lins=<MYLABFILE>;
         for (my $i=0;$i<$#lins+1;$i++)
         {
             print MYFILE3 "$lins[$i]";
         }
         close(MYLABFILE);
         print MYFILE3 ".\n";
  }

}
close (MYFILE);
close (MYFILE2);
close (MYFILE3);
}

#parametrizace popmoci HCOPY  (1)
if ($k1!=0)
{
    system("HCOPY -C $hcopyConf -S $hcopyParLst");
}

####parametrizace KONEC

####prototyp ZACATEK

#!!!!!!! (2) rucne definovat jak ma vypadat prototyp, soubor: $hcompvPrototype !!!!!!!!!!!!!!!


# (3) vytvoreni prvotniho odhadu modelu na zaklade dat
if ($k3!=0)
{
    system("HCOMPV -C $hcompvConf -f 0.01 -m -S $hcompvDataLst -M $hmmDir $hcompvPrototype");
}
####prototyp KONEC


#rozkopirovani prototype pro jednotlive hlasky + vytvoreni makro souboru
if ($k4!=0)
{
    my $dir = "$hcompvProtOutDir.0";
    unless (-d $dir)
    {
    	mkdir $dir or die "Can't create directory $dir";
    }

   open(MYFILE, "<$hcompvProtOut" )or die "Can't read data";

   open(MYOUTPUT, ">$hmmdefs") or die "Can't write hmmdefs";

   #vytvoreni souboru pro definici parametru jednotlivych hlasek z prototype
   my(@lines) = <MYFILE>;
   foreach my $value (sort values %alphabet)
   {
        #print(MYOUTPUT "~h $alphabet{$value}\n");
        print(MYOUTPUT "~h \"$value\"\n");
        for(my $i=4; $i<$#lines+1; $i++)
	{
      	    print(MYOUTPUT "$lines[$i]");
            #$pProt+=".$lines[$i]";
        }
        print(MYOUTPUT "\n");
   }
   close (MYFILE);
   close (MYOUTPUT);
   #vytvoreni souboru macros ze souboru vfloors
   open(MYOUTPUT, ">$hmmmacro") or die "Can't write hmmmacro";
   print(MYOUTPUT "~o <MFCC_0_D_A> <VecSize> 39\n");  #zkontrolovat nastaveni modelu!!
   #prepsani VFloors souboru
   open(MYFILE, "<$hcompvVFloorOut" )or die "Can't read VFloors";
   @lines = <MYFILE>;
   for(my $i=0; $i<$#lines+1; $i++)
   {
        print(MYOUTPUT "$lines[$i]");
   }
   close(MYFILE);
   close(MYOUTPUT);
}


###trenovani modelu HEREST, lze menit pocet itaraci podle potreby
if ($k5!=0)
{
    my $pocetIteraci = 5;
    for (my $krok=1; $krok<=$pocetIteraci ; $krok++)
    {
       my $pKrok = $krok - 1;
       my $pDir = "$hcompvProtOutDir.$krok";
       unless (-d $pDir)
       {
          mkdir $pDir or die "Can't create directory $pDir";
       }
       print "$hcompvProtOutDir.$krok\n";
       system("HEREST -C $herestConf -I $herestMlfLst -S $hcompvDataLst -H $hcompvProtOutDir.$pKrok/macros -H $hcompvProtOutDir.$pKrok/hmmdefs -M $hcompvProtOutDir.$krok $monophonesLst");
       #bez MLF
       #system("HEREST -C $herestConf -S $hcompvDataLst -H $hcompvProtOutDir.$pKrok/macros -H $hcompvProtOutDir.$pKrok/hmmdefs -M $hcompvProtOutDir.$krok $monophonesLst");
    }

}

die "ok";