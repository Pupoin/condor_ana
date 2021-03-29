import os

if __name__ == "__main__":
    wrapper_version={
        'wrapper2018.sh':'myroot.root',
    }
    _year='wrapper2018.sh'

    params = [
        '0To50',
        '50To100',
        '100To250',
        '250To400',
        '400To600',
        '650Toinf',
        'incl',
        ]

    for ipar,param in enumerate(params):
        # 1D cards
        int_process=param
        with open('submit_{0}.jdl'.format(int_process),'w') as outfile:
            outfile.write("Universe = vanilla\n")
            outfile.write("Executable = {0}\n".format(_year))
            outfile.write("arguments = {0}\n".format(int_process))
            outfile.write("request_cpus = 4\n")
            #outfile.write("request_memory = 6 Gb\n")
            #outfile.write("request_disk = 8 Gb\n")
            outfile.write("requirements = (OpSysAndVer =?= \"SLCern7\" || OpSysAndVer =?= \"SL7\" || OpSysAndVer =?= \"RedHat7\" || OpSysMajorVer == 7)\n")            
            outfile.write("should_transfer_files = YES\n")
            #outfile.write("transfer_input_files = /etc/ciconnect/templates/cmssw_setup.sh\n")
            outfile.write("Error = log/{0}.err_$(Cluster)_$(Process)\n".format(int_process))
            outfile.write("Output = log/{0}.out_$(Cluster)_$(Process)\n".format(int_process))
            outfile.write("Log = log/{0}.log_$(Cluster)\n".format(int_process))
            outfile.write("transfer_output_remaps = \"{0} = root/{1}_$(Cluster)_$(Process).root\"\n".format(wrapper_version[_year],int_process))
            outfile.write("when_to_transfer_output = ON_EXIT\n")
            outfile.write("Queue 2\n")
        #os.system("curl http://stash.osgconnect.net/+jiexiao/wrapper_events.sh -o wrapper_{0}.sh".format(int_process))
