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
# Load cmssw_setup function, be care, add scram b -j 10 to this cmssw_setup.sh 
wget http://stash.osgconnect.net/+zhyuan/cfg_nanogen/cmssw_setup.sh -O cmssw_setup.sh
source cmssw_setup.sh

# Setup CMSSW Base
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh

cfg_file="cfg.py"
wget --no-check-certificate "http://stash.osgconnect.net/+zhyuan/cfg_nanogen/2.py"  -O ${cfg_file}|| exit_on_error $? 150 "Could not download cfg file."

# http://stash.osgconnect.net/+zhyuan/cfg_nanogen/sandbox-CMSSW_11_2_0_pre7-ead378f.tar.bz2
sandbox_name="sandbox.tar.bz2"
wget --no-check-certificate  "http://stash.osgconnect.net/+zhyuan/cfg_nanogen/sandbox-CMSSW_11_2_0_pre7-ead378f.tar.bz2" -O ${sandbox_name} || exit_on_error $? 150 "Could not download sandbox."

#Setup framework from sandbox
cmssw_setup $sandbox_name || exit_on_error $? 151 "Could not unpack sandbox"

gridpack_name="dyellell${1}_5f_NLO_FXFX_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz"
# gridpack_name="dyellell0j_5f_NLO_FXFX_slc6_amd64_gcc630_CMSSW_9_3_16_tarball.tar.xz"
wget --no-check-certificate  "http://stash.osgconnect.net/+zhyuan/stitch_inclusive/dyjetNLO/mg265/${gridpack_name}"    || exit_on_error $? 150 "Could not download gridpack."


sed -i "s/^.*tarball.tar.xz.*$/     args = cms.vstring(\'..\/$gridpack_name\'),/" -i ${cfg_file}

seed=$(($(date +%s) +1))
sed -i "s/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int(.*)$/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int($seed)/" -i ${cfg_file}
cmsRun ${cfg_file}

/bin/rm -rf $gridpack_name
/bin/rm -rf cmssw-tmp
# # clean
# /bin/rm -rf *py
/bin/rm -rf *pyc
/bin/rm -rf $sandbox_name

