exit_on_error() {
    result=$1
    code=$2
    message=$3

    if [ $1 != 0 ]; then
        echo $3
        exit $2
    fi
}

##  change to sl6
wget http://stash.osgconnect.net/+zhyuan/anaCondor/cmssw-cc6_condor  --no-check-certificate
chmod +x cmssw-cc6_condor
./cmssw-cc6_condor
echo "hasdfasdfadfadf"
# Load cmssw_setup function
wget http://stash.osgconnect.net/+zhyuan/anaCondor/cmssw_setup.sh --no-check-certificate
source cmssw_setup.sh

echo "2hasdfasdfadfadf"
# Setup CMSSW Base
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh


wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/anaCondor/SMP-RunIIFall18wmLHEGS-00059_1_cfg.py"  || exit_on_error $? 150 "Could not download sandbox1."
#cmsrel CMSSW_10_2_18
#cd CMSSW_10_2_18/src
#cmsenv
#cd -
# Download sandbox, replace it when you have different sandbox_name
#sandbox_name1="sandbox-CMSSW_10_2_6-e33be22.tar.bz2"
sandbox_name2="sandbox-CMSSW_10_2_18-441666a.tar.bz2"
# sandbox_name3="sandbox-CMSSW_10_6_1-441666a.tar.bz2"
# Change to your own http
# wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zguan/Wjets/condor/${sandbox_name1}"  || exit_on_error $? 150 "Could not download sandbox1."
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/anaCondor/${sandbox_name2}"  || exit_on_error $? 150 "Could not download sandbox1."

pushd .
# Setup framework from sandbox
cmssw_setup $sandbox_name2 || exit_on_error $? 151 "Could not unpack sandbox"
popd
gridpack_name="DYJets_HT-$1_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz"
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/stitch_inclusive/mg265/${gridpack_name}"  || exit_on_error $? 150 "Could not download gridpack."

echo `pwd`
sed -i "s/^.*tarball.tar.xz.*$/     args = cms.vstring(\'..\/$gridpack_name\'),/" -i SMP-RunIIFall18wmLHEGS-00059_1_cfg.py

seed=$(($(date +%s) +1))
sed -i "s/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int(.*)$/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int($seed)/" -i SMP-RunIIFall18wmLHEGS-00059_1_cfg.py

cmsRun SMP-RunIIFall18wmLHEGS-00059_1_cfg.py
/bin/rm -rf $gridpack_name
#cmsRun SMP-RunIIAutumn18DRPremix-00048_1_cfg.py
#/bin/rm -rf SMP-RunIIFall18wmLHEGS-00059_inLHE.root SMP-RunIIFall18wmLHEGS-00059.root
#cmsRun SMP-RunIIAutumn18DRPremix-00048_2_cfg.py
#/bin/rm -rf SMP-RunIIAutumn18DRPremix-00048_step1.root
#cmsRun SMP-RunIIAutumn18MiniAOD-00048_1_cfg.py
#/bin/rm -rf SMP-RunIIAutumn18DRPremix-00048.root
/bin/rm -rf cmssw-tmp
# Setup framework from sandbox
#pushd .
#cmssw_setup $sandbox_name2 || exit_on_error $? 151 "Could not unpack sandbox"
#popd
#cmsRun SMP-RunIIAutumn18NanoAODv6-00019_1_cfg.py
#/bin/rm -rf SMP-RunIIAutumn18MiniAOD-00048.root
# clean
/bin/rm -rf *py
/bin/rm -rf *pyc
#/bin/rm -rf $sandbox_name1
/bin/rm -rf $sandbox_name2
