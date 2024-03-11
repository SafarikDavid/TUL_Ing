# Zde se nastavují proměnné pro název Conda prostředí a Jupyter kernelu
# Používejte pouze znaky v lower case!!

KERNEL_NAME="pli"
ENV_NAME="pli"

# Přechod do domovského adresáře uživatele
cd $HOME

# Vytvoření složek pro Conda prostředí a dočasné soubory, pokud ještě neexistují
mkdir -p envs
mkdir -p temp

# Nastavení proměnné prostředí pro dočasné soubory
export TMPDIR=/storage/brno2/home/$USER/temp

# Přidání Mambaforge k dostupným modulům
module add mambaforge

# Vytvoření nového Conda prostředí s Python, IPython Kernel, Jupyter, Torch, ...
mamba create -y --prefix /storage/brno2/home/$USER/envs/$ENV_NAME python ipykernel transformers tqdm scikit-learn matplotlib jupyter pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia

echo "env created"

# Přidání modulu IPython Kernel
module add py-ipykernel

# Instalace Jupyter kernelu pro uživatele. Nastavuje se název kernelu a zobrazovaný název.
python3 -m ipykernel install --user --name $KERNEL_NAME --display-name $KERNEL_NAME

echo "IPython kernel installed"

# Nastavení cesty k souboru, který bude obsahovat skript pro spuštění kernelu
filename="/storage/brno2/home/${USER}/.local/share/jupyter/kernels/${KERNEL_NAME}/start_kernel.sh"

echo "filename"

# Příprava skriptu pro spuštění kernelu
script_text='#!/bin/bash'

# Skript pro aktivaci Conda prostředí a spuštění IPython kernelu s předanými argumenty
script_text+="
module add mambaforge
mamba activate /storage/brno2/home/${USER}/envs/${ENV_NAME}
module add py-ipykernel
exec python \"\$@\"
"

# Zápis skriptu do souboru
echo "$script_text" > "$filename"

# Nastavení spustitelných práv pro skript
chmod a+x /storage/brno2/home/$USER/.local/share/jupyter/kernels/$KERNEL_NAME/start_kernel.sh

# Úprava souboru kernel.json pro použití připraveného skriptu při spouštění kernelu
sed -i "3s|\"[^\"]*\"|\"$filename\"|" /storage/brno2/home/$USER/.local/share/jupyter/kernels/$KERNEL_NAME/kernel.json

echo -e "###### OnDemand nastaveno ######\nPro aktivaci prostředí použijte:\nmamba activate \e[32m/storage/brno2/home/${USER}/envs/$ENV_NAME\e[0m"
