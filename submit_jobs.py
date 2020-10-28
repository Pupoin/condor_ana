import os

if __name__ == "__main__":
    params = [
        # ('21', '70to100'),
        # ('24', '100to200'),
        # ('25', '200to400'),
        # ('28', '400to600'),
        # #('30', 'cHB'),
        ('32', '0j'),
        ('45', '1j'),
        ('46', '2j'),
        ('47', '012j'),
    ]

    # loop over parameters to be restricted
    for ipar,param in enumerate(params):
        # 1D cards
        process='submit_'+ params[ipar][1]+'.jdl'
        os.system('condor_submit {0}'.format(process))
        
