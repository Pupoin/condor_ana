exit_on_error() {
    result=$1
    code=$2
    message=$3

    if [ $1 != 0 ]; then
        echo $3
        exit $2
    fi
}

#### FRAMEWORK SANDBOX SETUP ####
# Load cmssw_setup function
wget http://stash.osgconnect.net/+zhyuan/anaCondor/cmssw_setup.sh
source cmssw_setup.sh

# Setup CMSSW Base
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh

cfgpy="SMP-RunIIFall18wmLHEGS-00138_1_cfg.py"
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/anaCondor/${cfgpy}"  || exit_on_error $? 150 "Could not download sandbox1."

# Download sandbox, replace it when you have different sandbox_name
#sandbox_name1="sandbox-CMSSW_10_2_6-e33be22.tar.bz2"
sandbox_name2="sandbox-CMSSW_10_2_18-441666a.tar.bz2"
# sandbox_name3="sandbox-CMSSW_10_6_1-441666a.tar.bz2"
# Change to your own http
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/anaCondor/${sandbox_name2}"  || exit_on_error $? 150 "Could not download sandbox1."

pushd .
# Setup framework from sandbox
cmssw_setup $sandbox_name2 || exit_on_error $? 151 "Could not unpack sandbox"
popd
# http://stash.osgconnect.net/+zhyuan/stitch_inclusive/mg265/
#http://stash.osgconnect.net/+zhyuan/stitch_inclusive/dyjetNLO/mg265/dyellell2j_5f_NLO_FXFX_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz
gridpack_name="dyellell$1_5f_NLO_FXFX_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz"
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/stitch_inclusive/dyjetNLO/mg265/${gridpack_name}"  || exit_on_error $? 150 "Could not download gridpack."

echo `pwd`
sed -i "s/^.*tarball.tar.xz.*$/     args = cms.vstring(\'..\/$gridpack_name\'),/" -i ${cfgpy}

seed=$(($(date +%s) +1))
sed -i "s/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int(.*)$/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int($seed)/" -i ${cfgpy}

cmsRun ${cfgpy}

# clean
/bin/rm -rf $gridpack_name
/bin/rm -rf cmssw-tmp
/bin/rm -rf *pyc
/bin/rm -rf ${cfgpy}
/bin/rm -rf $sandbox_name2
