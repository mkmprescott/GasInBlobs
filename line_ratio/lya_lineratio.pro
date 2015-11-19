pro lya_lineratio

path1 = '/home/vega-data/mkpresco/LABspectroscopy'
path2 = '/home/users/berdis/Documents/Research/txtfiles'

; Compare line ratios for: OII/HeII; CIII/CIV; Lya/HeII; OII/CIV; CIVLya
; MID data
heiiMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.heii.fits', 1)  ; '1' is the 1st extension, in other words, the header of the fits file
ciiiMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.ciii.fits', 1)
civMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.civ.fits', 1)
lyaMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.lya.fits', 1)
oiiMID = mrdfits(path1+'/red/Lines/casdPRG1_MID_B.skyvelo.oii.fits', 1)

; A data
heiiA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.heii.fits', 1)  ; '1' is the 1st extension, in other words, the header of the fits file
ciiiA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.ciii.fits', 1)
civA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.civ.fits', 1)
lyaA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.lya.fits', 1)
oiiA = mrdfits(path1+'/red/Lines/casdPRG1_A_B.skyvelo.oii.fits', 1)


; Define arrays for corresponding lines for forloop
heii=[heiiMID,heiiA]
ciii=[ciiiMID,ciiiA]
civ=[civMID,civA]
lya=[lyaMID,lyaA]
oii=[oiiMID,oiiA]
names=['MID','A']
;--------------------------------------------------------------------------------------------------------

for i=0,N_ELEMENTS(heii)-1 do begin


    ;print, lya.ap
    ;help, lya, /str

    ; Error propagation:
    ; err12 = sqrt(((df/ds1)^2 * err1^2) + ((df/ds2)^2 * err2^2))

    heiiSN = heii[i].signal / heii[i].noise 
    ciiiSN = ciii[i].signal / ciii[i].noise 
    civSN = civ[i].signal / civ[i].noise 
    lyaSN = lya[i].signal / lya[i].noise 
    oiiSN = oii[i].signal / oii[i].noise 

    keep = where(lyaSN GT 2)


; Currently trying to figure out why the below won't work.....I'm guessing it's some syntax error??
    civlya = FLTARR(141)
    civlyaerr = FLTARR(141)

    civlya(keep) = civ(keep)[i].signal / lya(keep)[i].signal
    civlyaerr(keep) = sqrt(((1/lya(keep)[i].signal)^2 * civ(keep)[i].noise^2) + ((-civ(keep)[i].signal/(lya(keep)[i].signal^2))^2 * lya(keep)[i].noise^2))

;--------------------------------------------------------------------------------------------------------------------------------------------------
    oiiciv = FLTARR(141)
    oiiciverr = FLTARR(141)

    oiiciv(keep) = oii[i](keep).signal / civ[i](keep).signal
    oiiciverr(keep) = sqrt(((1/civ[i](keep).signal)^2 * oii[i](keep).noise^2) + ((-oii[i](keep).signal/(civ[i](keep).signal^2))^2 * civ[i](keep).noise^2))
    
;--------------------------------------------------------------------------------------------------------------------------------------------------    
    ciiiciv = FLTARR(141)
    ciiiciverr = FLTARR(141)

    ciiiciv(keep) = ciii[i](keep).signal / civ[i](keep).signal
    ciiiciverr(keep) = sqrt(((1/civ[i](keep).signal)^2 * ciii[i](keep).noise^2) + ((-ciii[i](keep).signal/(civ[i](keep).signal^2))^2 * civ[i](keep).noise^2))
       
;--------------------------------------------------------------------------------------------------------------------------------------------------  
    lyaheii = FLTARR(141)
    lyaheiierr = FLTARR(141)

    lyaheii(keep) = lya[i](keep).signal / heii[i](keep).signal
    lyaheiierr(keep) = sqrt(((1/heii[i](keep).signal)^2 * lya[i](keep).noise^2) + ((-lya[i](keep).signal/(heii[i](keep).signal^2))^2 * heii[i](keep).noise^2))
    
;--------------------------------------------------------------------------------------------------------------------------------------------------      
    oiiheii = FLTARR(141)
    oiiheiierr = FLTARR(141)

    oiiheii(keep) = oii[i](keep).signal / heii[i](keep).signal
    oiiheiierr(keep) = sqrt(((1/heii[i](keep).signal)^2 * oii[i](keep).noise^2) + ((-oii[i](keep).signal/(heii[i](keep).signal^2))^2 * heii[i](keep).noise^2))

;--------------------------------------------------------------------------------------------------------------------------------------------------
    heiiciv = FLTARR(141)
    heiiciverr = FLTARR(141)

    heiiciv(keep) = heii[i](keep).signal / civ[i](keep).signal
    heiiciverr(keep) = sqrt(((1/civ[i](keep).signal)^2 * heii[i](keep).noise^2) + ((-heii[i](keep).signal/(civ[i](keep).signal^2))^2 * civ[i](keep).noise^2))




;---------------------------------------------------------------------------------------------------------
; Old method of using SNR for each spectral line, rather than all with Lya SNR
;for i=0, N_ELEMENTS(civSN)-1 do begin
  ; OII/HeII
;  if oiiSN[i] GT 2 OR  civSN[i] GT 2 then begin
;    oiiciv[i] = oii[i].signal / civ[i].signal
;    oiiciverr[i] = sqrt(((1/civ[i].signal)^2 * oii[i].noise^2) + ((-oii[i].signal/(civ[i].signal^2))^2 * civ[i].noise^2))
;  endif else begin
;    oiiciv[i] = '-NAN'
;    oiiciverr[i] = '-NAN'
;  endelse
;endfor


; Older method of using all data, regardless of SNR
; Lya/HeII
;lyaheii = lya.signal / heii.signal
;lyaheiierr = sqrt(((1/heii.signal)^2 * lya.noise^2) + ((-lya.signal/(heii.signal^2))^2 * heii.noise^2))

; CIII/CIV
;ciiiciv = ciii.signal / civ.signal
;ciiiciverr = sqrt(((1/civ.signal)^2 * ciii.noise^2) + ((-ciii.signal/(civ.signal^2))^2 * civ.noise^2))

; OII/CIV
;oiiciv = oii.signal / civ.signal
;oiiciverr = sqrt(((1/civ.signal)^2 * oii.noise^2) + ((-oii.signal/(civ.signal^2))^2 * civ.noise^2))

; CIV/Lya
;civlya = civ.signal / lya.signal
;civlyaerr = sqrt(((1/lya.signal)^2 * civ.noise^2) + ((-civ.signal/(lya.signal^2))^2 * lya.noise^2))

;--------------------------------------------------------------------------------------------------------


    !P.MULTI = [0, 1, 2]
    !Y.THICK = 3
    !X.THICK = 3
    ps_open, path2+'/line_ratio/'+names[i]+'_CIVLya'

    ploterror, lya[i](keep).ap, civlya(keep), civlyaerr(keep), yrange=[-2,2], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) CIV/Lya', charthick=2, charsize=1
    ploterror, lya[i](keep).ap, heiiciv(keep), heiiciverr(keep), yrange=[-2,2], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) HEII/CIV', charthick=2, charsize=1

    ps_close



    !P.MULTI = [0, 1, 2]
    !Y.THICK = 3
    !X.THICK = 3
    ps_open, path2+'/line_ratio/'+names[i]+'_LyaHeII-OIICIV'

    ploterror, lya[i](keep).ap, lyaheii(keep), lyaheiierr(keep), yrange=[-20,30], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) Lya/HeII', charthick=2, charsize=1
    ploterror, oii[i](keep).ap, oiiciv(keep), oiiciverr(keep), yrange=[-20,20], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) OII/CIV', charthick=2, charsize=1

    ps_close



    !P.MULTI = [0, 1, 2]
    !Y.THICK = 3
    !X.THICK = 3
    ps_open, path2+'/line_ratio/'+names[i]+'_OIIHeII-CIIICIV'

    ploterror, oii[i](keep).ap, oiiheii(keep), oiiheiierr(keep), yrange=[-20,20], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) OII/HeII', charthick=2, charsize=1
    ploterror, lya[i](keep).ap, ciiiciv(keep), ciiiciverr(keep), yrange=[-20,20], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) CIII/CIV', charthick=2, charsize=1

    ps_close



    keeponly = where((lyaSN GT 2) AND (lya.ap GT 57) AND (lya.ap LT 101))
    print, keeponly

    openw,1,'/home/users/berdis/Documents/Research/txtfiles/line_ratio/'+names[i]+'datatable.txt'
    printf,1,'  Aperture    CIV-Lya     CIV-Lya error    Lya-HeII     Lya-HeII error    OII-CIV    OII-CIV error     OII-HeII    OII-HeII error    CIII-CIV    CIII-CIV error'
    printf,1,'---------------------------------------------------------------------------------------------------------------------------------------------------------------'
    for j=0,n_elements(lya[i](keeponly).ap)-1 do begin
      printf,1,(lya[i](keeponly).ap)[j], (civlya[i](keeponly))[j], (civlyaerr[i](keeponly))[j], (lyaheii[i](keeponly))[j], (lyaheiierr[i](keeponly))[j], (oiiciv[i](keeponly))[j], (oiiciverr[i](keeponly))[j], (oiiheii[i](keeponly))[j], (oiiheiierr[i](keeponly))[j], (ciiiciv[i](keeponly))[j], (ciiiciverr[i](keeponly))[j], (heiiciv[i](keeponly))[j], (heiiciverr[i](keeponly))[j], FORMAT='(I,F,F,F,F,F,F,F,F,F,F,F,F)'
    endfor

    close,1


endfor
end