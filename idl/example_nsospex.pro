pro example_nsospex

  ; Examples of using the sswidl/ospex code with NuSTAR pha/arf/rmfs
  ;
  ; 14-May-2018 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Location and name of some NuSTAR data
  msdir='~/OneDrive - University of Glasgow/work/ns_data/simple_idl/testxout/'
  fname='nu20110114001A06_chu23_S_cl_grade0_sr'

  ; Single thermal fit, output file and plot
  ospex_ns_fvth,dir=msdir, fname=fname,fout='test1',fiter=[2,6];,de=de

  ; Load the save file in and then plot it
  restore, file='fitvth_test1.dat'
  plotp_ospex_ns_fvth, fit_out,xlim=[2,8],ylim=[1,3e3],outname='test1d'

  ; Single thermal fit, output file and plot, with rebinning to dE=0.2
  ospex_ns_fvth,dir=msdir, fname=fname,fout='test2',fiter=[2,6],de=0.2
    


  stop
end