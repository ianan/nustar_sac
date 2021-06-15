"""A script to create custom GTI files from an existing one"""
# Taken from https://github.com/KriSun95/krispy/ ?


import datetime
from astropy.io import fits

def make_gti(gti_file, save_name, good_time_interval):
    """Create a new GTI file with your own start and stop time.

    Parameters
    ----------
    gti_file : str
            The original GTI file for the NuSTAR observation. E.g., gti_file="./nu80414201001B06_gti.fits".

    save_name : str
            The name of your new GTI file. E.g., save_name = "./new_gti.fits"

    good_time_interval : [str, str]
            A list made of 2 string with the start and stop time for your good time interval.
            E.g., good_time_interval = ['2018-09-09 09:13:36', '2018-09-09 09:17:00'] will produce
            a new GTI file with data START='2018-09-09 09:13:36' and STOP='2018-09-09 09:17:00'.

    Returns
    -------
    None.

    Example
    -------
    gtiFile = "./nu80414201001B06_gti.fits"
    saveName = "./new_gti.fits"
    goodTimeInterval = ['2018-09-09 09:13:36', '2018-09-09 09:17:00']

    make_gti(gtiFile, saveName, goodTimeInterval)
    """

    # NuSTAR counts from
    nu_rel = datetime.datetime.strptime("2010-01-01", "%Y-%m-%d")
    nu_rel = nu_rel.replace(tzinfo=datetime.timezone.utc)

    # custom GTI
    time1 = datetime.datetime.strptime(good_time_interval[0], "%Y-%m-%d %H:%M:%S")
    time1 = time1.replace(tzinfo=datetime.timezone.utc)
    time2 = datetime.datetime.strptime(good_time_interval[1], "%Y-%m-%d %H:%M:%S")
    time2 = time2.replace(tzinfo=datetime.timezone.utc)

    # now open the file, change the start and stop times and save to new file without changing original
    with fits.open(gti_file) as hdulist:

        # print(hdulist[1].columns) # comment this back in to double check titles of data
        # print(hdulist[1].data) # comment this back in to double check data

        # it turns out changing TSTART and TSTOP in hdulist[1].header does nothing, need to change the actual data
        hdulist[1].data["START"] = (time1 - nu_rel).total_seconds() # replaces this hdu with the new time
        hdulist[1].data["STOP"] = (time2 - nu_rel).total_seconds()

        print(hdulist[1].data["START"])
        print(hdulist[1].data["STOP"])

        hdulist.writeto(save_name, overwrite=True) # saves the edited file, original stays as is.
        #overwrite=True overwrites save_name file if it's there, not original GTI file


if __name__=="__main__":
    gtiFile = "./nu80414201001B06_gti.fits"
    saveName = "./new_gti.fits"
    goodTimeInterval = ['2018-09-09 09:13:36', '2018-09-09 09:17:00']

    make_gti(gtiFile, saveName, goodTimeInterval)
