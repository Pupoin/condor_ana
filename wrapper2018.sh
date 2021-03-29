##  change to sl6
# wget http://stash.osgconnect.net/+zhyuan/anaCondor/cmssw-cc6_condor  --no-check-certificate
# chmod +x cmssw-cc6_condor
# ./cmssw-cc6_condor

# Load cmssw_setup function
wget http://stash.osgconnect.net/+zhyuan/sandbox/mygz-cmssw_setup.sh --no-check-certificate
source mygz-cmssw_setup.sh 

# Setup CMSSW Base
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
source $VO_CMS_SW_DIR/cmsset_default.sh

sandbox_name="sandbox.tar"
cfgpy="cfg.py"
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/stitch_inclusive/dyjet_ptbin_updated/gridpack_265/a.py" -O ${cfgpy}
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/sandbox/sandbox-CMSSW_11_2_0_pre10-e8a8499.tar.gz" -O ${sandbox_name}

cmssw_setup ${sandbox_name}
gridpack_name="DYJetsToLL_012j_Zpt-${1}_5f_NLO_FXFX_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz"
wget --no-check-certificate --progress=bar "http://stash.osgconnect.net/+zhyuan/stitch_inclusive/dyjet_ptbin_updated/gridpack_265/${gridpack_name}"  

echo `pwd`
sed -i "s/^.*tarball.tar.xz.*$/     args = cms.vstring(\'..\/$gridpack_name\'),/" -i ${cfgpy}

seed=$(($(date +%s) +1))
sed -i "s/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=.*$/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int($seed)/" -i ${cfgpy}

cmsRun ${cfgpy}

/bin/rm -rf $gridpack_name
/bin/rm -rf cmssw-tmp
/bin/rm -rf *py
/bin/rm -rf *pyc
/bin/rm -rf $sandbox_name
