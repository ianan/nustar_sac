pro make_nsgrdspec,evt,grdspc,max_eng=max_eng

  ; Make a spectrum for different event grades from a NuSTAR evt previously loaded via load_nsevt.pro
  ; Should not have been filtered by filter_nsevt.pro
  ;
  ; Input
  ;   evt   - evt structure from load_nsevt.pro
  ; Output
  ;   grdspc   - the grad spectrum structure
  ;
  ; Option
  ;   max_eng   - Max energy in keV to do the spectrum up to
  ;
  ;
  ;
  ; 01-Oct-2018 IGH
  ; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ;

  ; Set a default max energy is one not given
  if (n_elements(max_eng) ne 1) then max_eng=12
  ; convert this to the PI units
  max_pi=long((max_eng-1.6)/0.04)

  ; get rid of the counts above the max_eng
  gdid=where(evt.pi le max_pi,ngd)
  evtt=evt[gdid]

  ; Want spectrum for all grades, grade 0 and grade 21-24
  hhga=histogram(evtt.pi,min=0,max=max_pi,binsize=1,locations=xhh)

  ; So that the histogram only runs in more than 2 events, if 1 manually add to spectrum
  g0id=where(evtt.grade eq 0,ng0)
  if (ng0 gt 1) then hhg0=histogram(evtt[g0id].pi,min=0,max=max_pi,binsize=1,locations=xhh) else hhg0=lonarr(n_elements(xhh))
  if (ng0 eq 1) then hhg0[evtt[g0id].pi]=1

  ; So that the histogram only runs in more than 2 events, if 1 manually add to spectrum
  g2id=where(evtt.grade ge 21 and evtt.grade le 24,ng2)
  if (ng2 gt 1) then hhg2=histogram(evtt[g2id].pi,min=0,max=max_pi,binsize=1,locations=xhh) $
  else hhg2=lonarr(n_elements(xhh))
  if (ng2 eq 1) then hhg2[evtt[g2id].pi]=1

  engs=xhh*0.04+1.6

  grdspc={engs:engs,engs_mids:engs+0.02, hhga:hhga,hhg0:hhg0,hhg2:hhg2}

end