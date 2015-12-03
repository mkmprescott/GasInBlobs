; Determine the line ratios of input data from fits files; calculate uncertainties of line ratios using error propogation; 
;     plot line ratios against their aperture position along slit, and write both line ratio and error data to output txt file.


; ratioanderror function takes two line signal arguments and their corresponding errors (noise).
; outputs a single array of line ratio and line ratio error, which is later split (outside of function) into two separate variables.
FUNCTION ratioanderror, signal1, noise1, signal2, noise2
    signalratio = FLTARR(N_ELEMENTS(signal1))
    signalratio = signal1 / signal2
    ratioerror = sqrt(((1/signal2)^2 * (noise1^2) + ((signal1/(signal2^2))^2 * noise2^2)))
    help, signalratio
    help, ratioerror
    RETURN, [signalratio, ratioerror]
END

FUNCTION plotlineratio, aperture, signalratio1, ratioerror1, signalratio2, ratioerror2
    !P.MULTI = [0, 1, 2]
    !Y.THICK = 3
    !X.THICK = 3
    ps_open, path2+'/line_ratio/'+names[i]+'_CIVLya'

    ploterror, aperture, signalratio1, ratioerror1, yrange=[-0.5,0.5], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) CIV/Lya', charthick=2, charsize=1
    ploterror, aperture, signalratio2, ratioerror2, yrange=[-2,2], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) HEII/CIV', charthick=2, charsize=1

    ps_close
END


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

;--------------------------------------------------------------------------------------------------------
    ;help, lya, /str
    ;
    ; Error propagation:
    ; err12 = sqrt(((df/ds1)^2 * err1^2) + ((df/ds2)^2 * err2^2))
    
; MID DATA
lyaSN = lyaMID.signal / lyaMID.noise 
keep = where(lyaSN GT 2)

civlyabothMID = ratioanderror(civMID(keep).signal, civMID(keep).noise, lyaMID(keep).signal, lyaMID(keep).noise)
civlyaMID = civlyabothMID[0:N_ELEMENTS(keep)-1]
civlyaerrMID = civlyabothMID[N_ELEMENTS(keep):-1]

oiicivbothMID = ratioanderror(oiiMID(keep).signal, oiiMID(keep).noise, civMID(keep).signal, civMID(keep).noise)
oiicivMID = oiicivbothMID[0:N_ELEMENTS(keep)-1]
oiiciverrMID = oiicivbothMID[N_ELEMENTS(keep):-1]

ciiicivbothMID = ratioanderror(ciiiMID(keep).signal, ciiiMID(keep).noise, civMID(keep).signal, civMID(keep).noise)
ciiicivMID = ciiicivbothMID[0:N_ELEMENTS(keep)-1]
ciiiciverrMID = ciiicivbothMID[N_ELEMENTS(keep):-1]

lyaheiibothMID = ratioanderror(lyaMID(keep).signal, lyaMID(keep).noise, heiiMID(keep).signal, heiiMID(keep).noise)
lyaheiiMID = lyaheiibothMID[0:N_ELEMENTS(keep)-1]
lyaheiierrMID = lyaheiibothMID[N_ELEMENTS(keep):-1]

oiiheiibothMID = ratioanderror(oiiMID(keep).signal, oiiMID(keep).noise, heiiMID(keep).signal, heiiMID(keep).noise)
oiiheiiMID = oiiheiibothMID[0:N_ELEMENTS(keep)-1]
oiiheiierrMID = oiiheiibothMID[N_ELEMENTS(keep):-1]

heiicivbothMID = ratioanderror(heiiMID(keep).signal, heiiMID(keep).noise, civMID(keep).signal, civMID(keep).noise)
heiicivMID = heiicivbothMID[0:N_ELEMENTS(keep)-1]
heiiciverrMID = heiicivbothMID[N_ELEMENTS(keep):-1]


; A DATA
lyaSNA = lyaA.signal / lyaA.noise
keepA = where(lyaSNA GT 2)

civlyabothA = ratioanderror(civA(keepA).signal, civA(keepA).noise, lyaA(keepA).signal, lyaA(keepA).noise)
civlyaA = civlyabothA[0:N_ELEMENTS(keepA)-1]
civlyaerrA = civlyabothA[N_ELEMENTS(keepA):-1]

oiicivbothA = ratioanderror(oiiA(keepA).signal, oiiA(keepA).noise, civA(keepA).signal, civA(keepA).noise)
oiicivA = oiicivbothA[0:N_ELEMENTS(keepA)-1]
oiiciverrA = oiicivbothA[N_ELEMENTS(keepA):-1]

ciiicivbothA = ratioanderror(ciiiA(keepA).signal, ciiiA(keepA).noise, civA(keepA).signal, civA(keepA).noise)
ciiicivA = ciiicivbothA[0:N_ELEMENTS(keepA)-1]
ciiiciverrA = ciiicivbothA[N_ELEMENTS(keepA):-1]

lyaheiibothA = ratioanderror(lyaA(keepA).signal, lyaA(keepA).noise, heiiA(keepA).signal, heiiA(keepA).noise)
lyaheiiA = lyaheiibothA[0:N_ELEMENTS(keepA)-1]
lyaheiierrA = lyaheiibothA[N_ELEMENTS(keepA):-1]

oiiheiibothA = ratioanderror(oiiA(keepA).signal, oiiA(keepA).noise, heiiA(keepA).signal, heiiA(keepA).noise)
oiiheiiA = oiiheiibothA[0:N_ELEMENTS(keepA)-1]
oiiheiierrA = oiiheiibothA[N_ELEMENTS(keepA):-1]

heiicivbothA = ratioanderror(heiiA(keepA).signal, heiiA(keepA).noise, civA(keepA).signal, civA(keepA).noise)
heiicivA = heiicivbothA[0:N_ELEMENTS(keepA)-1]
heiiciverrA = heiicivbothA[N_ELEMENTS(keepA):-1]


; Define arrays for corresponding lines for printing to txt file forloop
;lya = [lyaMID, lyaA]
;civlya=[civlyaMID,civlyaA]
;civlyaerr=[civlyaerrMID,civlyaerrA]
;oiiciv=[oiicivMID,oiicivA]
;oiiciverr=[oiiciverrMID,oiiciverrA]
;ciiiciv=[ciiicivMID,ciiicivA]
;ciiiciverr=[ciiiciverrMID,ciiiciverrA]
;lyaheii=[lyaheiiMID,lyaheiiA]
;lyaheiierr=[lyaheiierrMID,lyaheiierrA]
;oiiheii=[oiiheiiMID,oiiheiiA]
;oiiheiierr=[oiiheiierrMID,oiiheiierrA]
;heiiciv=[heiicivMID,heiicivA]
;heiiciverr=[heiiciverrMID,heiiciverrA]
;names=['MID','A']
keep = (where((lyaSN GT 2) AND (lyaMID.ap GT 59) AND (lyaMID.ap LT 101)))
keepA = (where((lyaSNA GT 2) AND (lyaA.ap GT 59) AND (lyaA.ap LT 101)))
;keeponly = [keep, keepA]

; forloop to print line ratios and line ratio errors to 2 txt files: MID and A data separately
; ***** getting an error at keeponly[i] . . . IDL isn't happy with it for some reason? *****
;for i=0,N_ELEMENTS(names)-1 do begin
;    openw,1,'/home/users/berdis/Documents/Research/txtfiles/line_ratio/'+names[i]+'datatable.txt'
;    printf,1,'  Aperture    CIV-Lya     CIV-Lya error    Lya-HeII     Lya-HeII error    OII-CIV    OII-CIV error     OII-HeII    OII-HeII error    CIII-CIV    CIII-CIV error'
;    printf,1,'---------------------------------------------------------------------------------------------------------------------------------------------------------------'
;    for j=0,n_elements(lya[i](keeponly[i]).ap)-1 do begin
;        printf,1,(lya[i](keeponly[i]).ap)[j], (civlya[i](keeponly[i]))[j], (civlyaerr[i](keeponly[i]))[j], (lyaheii[i](keeponly[i]))[j], (lyaheiierr[i](keeponly[i]))[j], (oiiciv[i](keeponly[i]))[j], (oiiciverr[i](keeponly[i]))[j], (oiiheii[i](keeponly[i]))[j], (oiiheiierr[i](keeponly[i]))[j], (ciiiciv[i](keeponly[i]))[j], (ciiiciverr[i](keeponly[i]))[j], (heiiciv[i](keeponly[i]))[j], (heiiciverr[i](keeponly[i]))[j], FORMAT='(I,F,F,F,F,F,F,F,F,F,F,F,F)'
;    endfor
;    close,1
;endfor



; ***** Will try instead two separate writes for the MID and A data, since the above forloop is having an issue with keeponly[i] *****
; MID DATA
openw,1,'/home/users/berdis/Documents/Research/txtfiles/line_ratio/MID_datatable.txt'
printf,1,'  Aperture        CIV-Lya         CIV-Lya error        Lya-HeII         Lya-HeII error        OII-CIV        OII-CIV error         OII-HeII        OII-HeII error        CIII-CIV        CIII-CIV error'
printf,1,'---------------------------------------------------------------------------------------------------------------------------------------------------------------'
for j=0,n_elements(lyaMID(keep).ap)-1 do begin
  printf,1,(lyaMID(keep).ap)[j], (civlyaMID(keep))[j], (civlyaerrMID(keep))[j], (lyaheiiMID(keep))[j], (lyaheiierrMID(keep))[j], (oiicivMID(keep))[j], (oiiciverrMID(keep))[j], (oiiheiiMID(keep))[j], (oiiheiierrMID(keep))[j], (ciiicivMID(keep))[j], (ciiiciverrMID(keep))[j], (heiicivMID(keep))[j], (heiiciverrMID(keep))[j], FORMAT='(I,F,F,F,F,F,F,F,F,F,F,F,F)'
endfor
close,1

; A DATA
openw,1,'/home/users/berdis/Documents/Research/txtfiles/line_ratio/A_datatable.txt'
printf,1,'  Aperture        CIV-Lya         CIV-Lya error        Lya-HeII         Lya-HeII error        OII-CIV        OII-CIV error         OII-HeII        OII-HeII error        CIII-CIV        CIII-CIV error'
printf,1,'---------------------------------------------------------------------------------------------------------------------------------------------------------------'
for j=0,n_elements(lyaA(keepA).ap)-1 do begin
  printf,1,(lyaA(keepA).ap)[j], (civlyaA(keepA))[j], (civlyaerrA(keepA))[j], (lyaheiiA(keepA))[j], (lyaheiierrA(keepA))[j], (oiicivA(keepA))[j], (oiiciverrA(keepA))[j], (oiiheiiA(keepA))[j], (oiiheiierrA(keepA))[j], (ciiicivA(keepA))[j], (ciiiciverrA(keepA))[j], (heiicivA(keepA))[j], (heiiciverrA(keepA))[j], FORMAT='(I,F,F,F,F,F,F,F,F,F,F,F,F)'
endfor
close,1


;print, ratioanderror(oiiMID(keep).signal, civMID(keep).signal, oiiMID(keep).noise, civMID(keep).noise)
;print, ratioanderror(ciiiMID(keep).signal, civMID(keep).signal, ciiiMID(keep).noise, civMID(keep).noise)
;print, ratioanderror(lyaMID(keep).signal, heiiMID(keep).signal, lyaMID(keep).noise, heiiMID(keep).noise)
;print, ratioanderror(oiiMID(keep).signal, heiiMID(keep).signal, oiiMID(keep).noise, heiiMID(keep).noise)
;print, ratioanderror(heiiMID(keep).signal, civMID(keep).signal, heiiMID(keep).noise, civMID(keep).noise)

;print, ratioanderror(civA(keep).signal, lyaA(keep).signal, civA(keep).noise, lyaA(keep).noise)
;print, ratioanderror(oiiA(keep).signal, civA(keep).signal, oiiA(keep).noise, civA(keep).noise)
;print, ratioanderror(ciiiA(keep).signal, civA(keep).signal, ciiiA(keep).noise, civA(keep).noise)
;print, ratioanderror(lyaA(keep).signal, heiiA(keep).signal, lyaA(keep).noise, heiiA(keep).noise)
;print, ratioanderror(oiiA(keep).signal, heiiA(keep).signal, oiiA(keep).noise, heiiA(keep).noise)
;print, ratioanderror(heiiA(keep).signal, civA(keep).signal, heiiA(keep).noise, civA(keep).noise)

; OLD METHOD
;-------------------------------------------------------------------------------------------------------------------------------------------------
;    civlya = FLTARR(141)
;    civlyaerr = FLTARR(141)

;    civlya(keep) = civ(keep)[i].signal / lya(keep)[i].signal
;    civlyaerr(keep) = sqrt(((1/lya(keep)[i].signal)^2 * civ(keep)[i].noise^2) + ((-civ(keep)[i].signal/(lya(keep)[i].signal^2))^2 * lya(keep)[i].noise^2))
;--------------------------------------------------------------------------------------------------------------------------------------------------
;    oiiciv = FLTARR(141)
;    oiiciverr = FLTARR(141)

;    oiiciv(keep) = oii[i](keep).signal / civ[i](keep).signal
;    oiiciverr(keep) = sqrt(((1/civ[i](keep).signal)^2 * oii[i](keep).noise^2) + ((-oii[i](keep).signal/(civ[i](keep).signal^2))^2 * civ[i](keep).noise^2)) 
;--------------------------------------------------------------------------------------------------------------------------------------------------    
;    ciiiciv = FLTARR(141)
;    ciiiciverr = FLTARR(141)

;    ciiiciv(keep) = ciii[i](keep).signal / civ[i](keep).signal
;    ciiiciverr(keep) = sqrt(((1/civ[i](keep).signal)^2 * ciii[i](keep).noise^2) + ((-ciii[i](keep).signal/(civ[i](keep).signal^2))^2 * civ[i](keep).noise^2))       
;--------------------------------------------------------------------------------------------------------------------------------------------------  
;    lyaheii = FLTARR(141)
;    lyaheiierr = FLTARR(141)

;    lyaheii(keep) = lya[i](keep).signal / heii[i](keep).signal
;    lyaheiierr(keep) = sqrt(((1/heii[i](keep).signal)^2 * lya[i](keep).noise^2) + ((-lya[i](keep).signal/(heii[i](keep).signal^2))^2 * heii[i](keep).noise^2))   
;--------------------------------------------------------------------------------------------------------------------------------------------------      
;    oiiheii = FLTARR(141)
;    oiiheiierr = FLTARR(141)

;    oiiheii(keep) = oii[i](keep).signal / heii[i](keep).signal
;    oiiheiierr(keep) = sqrt(((1/heii[i](keep).signal)^2 * oii[i](keep).noise^2) + ((-oii[i](keep).signal/(heii[i](keep).signal^2))^2 * heii[i](keep).noise^2))
;--------------------------------------------------------------------------------------------------------------------------------------------------
;    heiiciv = FLTARR(141)
;    heiiciverr = FLTARR(141)

;    heiiciv(keep) = heii[i](keep).signal / civ[i](keep).signal
;    heiiciverr(keep) = sqrt(((1/civ[i](keep).signal)^2 * heii[i](keep).noise^2) + ((-heii[i](keep).signal/(civ[i](keep).signal^2))^2 * civ[i](keep).noise^2))
;    
;--------------------------------------------------------------------------------------------------------------------------

;    !P.MULTI = [0, 1, 2]
;    !Y.THICK = 3
;    !X.THICK = 3
;    ps_open, path2+'/line_ratio/'+names[i]+'_CIVLya'
;    ploterror, lya[i](keep).ap, civlya(keep), civlyaerr(keep), yrange=[-0.5,0.5], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) CIV/Lya', charthick=2, charsize=1
;    ploterror, lya[i](keep).ap, heiiciv(keep), heiiciverr(keep), yrange=[-2,2], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) HEII/CIV', charthick=2, charsize=1
;    ps_close

;    !P.MULTI = [0, 1, 2]
;    !Y.THICK = 3
;    !X.THICK = 3
;    ps_open, path2+'/line_ratio/'+names[i]+'_LyaHeII-OIICIV'
;    ploterror, lya[i](keep).ap, lyaheii(keep), lyaheiierr(keep), yrange=[0,30], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) Lya/HeII', charthick=2, charsize=1
;    ploterror, oii[i](keep).ap, oiiciv(keep), oiiciverr(keep), yrange=[-5,5], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) OII/CIV', charthick=2, charsize=1
;    ps_close

;    !P.MULTI = [0, 1, 2]
;    !Y.THICK = 3
;    !X.THICK = 3
;    ps_open, path2+'/line_ratio/'+names[i]+'_OIIHeII-CIIICIV'
;    ploterror, oii[i](keep).ap, oiiheii(keep), oiiheiierr(keep), yrange=[-5,5], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) OII/HeII', charthick=2, charsize=1
;    ploterror, lya[i](keep).ap, ciiiciv(keep), ciiiciverr(keep), yrange=[-5,5], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal) CIII/CIV', charthick=2, charsize=1
;    ps_close

;    keeponly = where((lyaSN GT 2) AND (lya.ap GT 59) AND (lya.ap LT 101))

;    openw,1,'/home/users/berdis/Documents/Research/txtfiles/line_ratio/'+names[i]+'datatable.txt'
;    printf,1,'  Aperture    CIV-Lya     CIV-Lya error    Lya-HeII     Lya-HeII error    OII-CIV    OII-CIV error     OII-HeII    OII-HeII error    CIII-CIV    CIII-CIV error'
;    printf,1,'---------------------------------------------------------------------------------------------------------------------------------------------------------------'
;    for j=0,n_elements(lya[i](keeponly).ap)-1 do begin
;      printf,1,(lya[i](keeponly).ap)[j], (civlya[i](keeponly))[j], (civlyaerr[i](keeponly))[j], (lyaheii[i](keeponly))[j], (lyaheiierr[i](keeponly))[j], (oiiciv[i](keeponly))[j], (oiiciverr[i](keeponly))[j], (oiiheii[i](keeponly))[j], (oiiheiierr[i](keeponly))[j], (ciiiciv[i](keeponly))[j], (ciiiciverr[i](keeponly))[j], (heiiciv[i](keeponly))[j], (heiiciverr[i](keeponly))[j], FORMAT='(I,F,F,F,F,F,F,F,F,F,F,F,F)'
;    endfor
;    close,1

;endfor
end