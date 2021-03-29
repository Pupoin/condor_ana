import os

if __name__ == "__main__":
    params = [
        ('20', '0To50'),
        ('21', '50To100'),
        ('23', '100To250'),
        ('24', '250To400'),
        ('28', '400To600'),
        ('30', '650Toinf'),
        ('70', 'incl'),
    ]

    # loop over parameters to be restricted
    for ipar,param in enumerate(params):
        # 1D cards
        process='submit_'+ params[ipar][1]+'.jdl'
        os.system('condor_submit {0}'.format(process))
        
