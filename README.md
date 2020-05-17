# condor_wjets
# How to use
```
mkdir Wjets
cd Wjets
git clone https://github.com/phy-guanzh/condor_wjets.git
cd condor_wjets
mkdir log
python build_submit.py
rm build_submit.py
chmod 777 wrapper*.sh
python submit_jobs.py
```
