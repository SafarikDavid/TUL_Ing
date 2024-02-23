# Podklady pro předmět PLI

Úlohy jsou připravené ve formě jupyter notebooků jazyka Python 3.x.

## Instalace

Nejjednodušší cesta, jak vše zprovoznit na vlastním počítači s Windows 10 či Linuxem je:

1. Instalace: [64-bitová 3.9 verze distribuce Miniconda](https://docs.conda.io/en/latest/miniconda.html)
	- Při instalaci nevolte přidání spustitelných skriptů Anacondy do standardních cest. Po instalaci spusťte Anaconda Prompt a zadejte příkaz conda init, aby bylo možné ji používat i z běžného příkazového řádku (cmd.exe). V opačném případě bude pro práci vždy nutné spouštět Anaconda Prompt, která všechny potřebné cesty již obsahuje.
	- Neinstalujte do adresáře obsahujícího v cestě slova s diakritikou.
2. Vytvoření prostředí pro předmět PLI v běžné příkazové řádce: conda create -n pli python=3.9
3. Aktivace vytvořeného prostředí: conda activate pli
4. Instalace modulů:
   - jako conda balíky příkazem `pip install <balik>`,
   - pip install torch
   - pip install notebook   
   - pip install numpy   
5. Spuštění jupyter notebooku v příkazové řádce: jupyter notebook (v případě problémů: python -n notebook)

## Podmínky zápočtu

- Pro získání zápočtu je nutné samostatně vypracovat a odevzdat v uvedeném termínu všechny úlohy nebo jejich části, které nejsou označeny jako bonusové.
- Za vypracování bonusových úloh nebo bonusových částí povinných úloh je možné získat plusové body ke zkoušce. Ty mohou významně zlepšit výslednou známku.
- **Neodevzdání úlohy v termínu stejně jako zcela či z podstatné části zkopírovaná úloha má za následek ztrátu nároku na zápočet.

## Jednotlivá cvičení

### 1. Úvod a regulární výrazy
- **deadline: 27.2.2024 7:59**

### 2. Hledání nejlépe asociovaných dvojic slov pomocí bodové vzájemné informace
- **deadline: 5.3.2024 7:59**

### 3. Výpočet unigramového a bigramového modelu
- Neopakujte vlastní kód: v notebooku vytvořte funkce, které volejte vícekrát pro jednotlivé vstupní korpusy nebo věty
- **deadline: 12.3.2023 7:59**

### 4. Vyhlazování bigramového modelu metodou Witten-Bell
- **deadline: 17.3.2023 7:59**

### 5. Práce s modelem Word2Vec
- **deadline: 24.3.2023 7:59**

## Semestrální práce
- Zadaní je v souboru Semestrální_práce.pdf
- **deadline: 25.4.2023 7:59**