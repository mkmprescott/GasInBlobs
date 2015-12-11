;
; ********************************** Jodi Berdis **********************************
; **************************** Completed December 2015 ****************************
; Determine the line ratios of input spectroscopy data from fits files. 
; Calculate uncertainties of line ratios using error propogation. 
; Plot line ratios against their aperture position along the slit.
; Write both line ratio and error data to output txt file.
; *********************************************************************************

; RATIOANDERROR FUNCTION
; ----------------------
; Takes two line signal arguments and their corresponding errors (noise).
; Outputs a single array of line ratio and line ratio error, which is later 
; split (outside of function) into two separate variables.
FUNCTION ratioanderror, signal1, noise1, signal2, noise2
    signalratio = FLTARR(N_ELEMENTS(signal1))
    signalratio = signal1 / signal2
    ratioerror = sqrt(((1./signal2)^2. * (noise1^2.) + ((signal1/(signal2^2.))^2. * noise2^2.)))
    RETURN, [signalratio, ratioerror]
END

; PLOTLINERATIO FUNCTION
; ----------------------
; Takes a slit name (MID, A, etc.), aperture numbers, and two sets of 
; signal ratios and errors (including names of signal ratios) to be plotted
; on a 1X2 PostScript plot file.
; *** Requires the STSci '10 Aug 1994 2.3 Fen Tamanaha' version of ps_open, 
;     and the STSci '28 Apr 1994 2.2 Fen Tamanaha' version of ps_close. ***
; If desired, variables for y-axis ranges may be added to fine-tune plot windows
FUNCTION plotlineratio, slitname, aperture, signalratio1, ratioerror1, rationame1, signalratio2, ratioerror2, rationame2
    path = '/home/users/berdis/Documents/Research/txtfiles'
    !P.MULTI = [0, 1, 2]
    !Y.THICK = 3
    !X.THICK = 3
    ps_open, path+'/line_ratio/'+slitname+'_'+rationame1+'_'+rationame2

    ploterror, aperture, signalratio1, ratioerror1, yrange=[-10,10], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal)'+rationame1, charthick=2, charsize=1
    ploterror, aperture, signalratio2, ratioerror2, yrange=[-10,10], xrange=[60,100], xtitle='Position (Aperture Number)', ytitle='Flux (signal)'+rationame2, charthick=2, charsize=1

    ps_close
END

;------------------------------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------------------------------

pro lya_lineratio

path1 = '/home/vega-data/mkpresco/LABspectroscopy'
path2 = '/home/users/berdis/Documents/Research/txtfiles'

; Compare line ratios for: OII/HeII; CIII/CIV; Lya/HeII; OII/CIV; CIV/Lya; HeII/CIV
; MID data
heiiMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.heii.fits', 1)  ; '1' is the 1st extension, in other words, the header of the fits file
ciiiMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.ciii.fits', 1)
civMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.civ.fits', 1)
lyaMID = mrdfits(path1+'/blue/Lines/casdPRG1_MID_B.skyvelocombo.lya.fits', 1)
oiiMID = mrdfits(path1+'/red/Lines/casdPRG1_MID_B.skyvelo.oii.fits', 1)

; A data
heiiA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.heii.fits', 1)
ciiiA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.ciii.fits', 1)
civA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.civ.fits', 1)
lyaA = mrdfits(path1+'/blue/Lines/casdPRG1_A_B.skyvelocombo.lya.fits', 1)
oiiA = mrdfits(path1+'/red/Lines/casdPRG1_A_B.skyvelo.oii.fits', 1)

;--------------------------------------------------------------------------------------------------------
;help, lya, /str
; Error propagation:
; err12 = sqrt(((df/ds1)^2 * err1^2) + ((df/ds2)^2 * err2^2))

; MID DATA
; Ratioanderror input values: signal1, noise1, signal2, noise2
civlyabothMID = ratioanderror(civMID.signal, civMID.noise, lyaMID.signal, lyaMID.noise)
civlyaMID = civlyabothMID[0:N_ELEMENTS(civMID.signal)-1]          ; Splits the ratioanderror returned array into two
civlyaerrMID = civlyabothMID[N_ELEMENTS(civMID.signal):-1]        ;     variables: signalratio and signalratioerror

oiicivbothMID = ratioanderror(oiiMID.signal, oiiMID.noise, civMID.signal, civMID.noise)
oiicivMID = oiicivbothMID[0:N_ELEMENTS(oiiMID.signal)-1]
oiiciverrMID = oiicivbothMID[N_ELEMENTS(oiiMID.signal):-1]

ciiicivbothMID = ratioanderror(ciiiMID.signal, ciiiMID.noise, civMID.signal, civMID.noise)
ciiicivMID = ciiicivbothMID[0:N_ELEMENTS(ciiiMID.signal)-1]
ciiiciverrMID = ciiicivbothMID[N_ELEMENTS(ciiiMID.signal):-1]

lyaheiibothMID = ratioanderror(lyaMID.signal, lyaMID.noise, heiiMID.signal, heiiMID.noise)
lyaheiiMID = lyaheiibothMID[0:N_ELEMENTS(lyaMID.signal)-1]
lyaheiierrMID = lyaheiibothMID[N_ELEMENTS(lyaMID.signal):-1]

oiiheiibothMID = ratioanderror(oiiMID.signal, oiiMID.noise, heiiMID.signal, heiiMID.noise)
oiiheiiMID = oiiheiibothMID[0:N_ELEMENTS(oiiMID.signal)-1]
oiiheiierrMID = oiiheiibothMID[N_ELEMENTS(oiiMID.signal):-1]

heiicivbothMID = ratioanderror(heiiMID.signal, heiiMID.noise, civMID.signal, civMID.noise)
heiicivMID = heiicivbothMID[0:N_ELEMENTS(heiiMID.signal)-1]
heiiciverrMID = heiicivbothMID[N_ELEMENTS(heiiMID.signal):-1]


; A DATA
civlyabothA = ratioanderror(civA.signal, civA.noise, lyaA.signal, lyaA.noise)
civlyaA = civlyabothA[0:N_ELEMENTS(civA.signal)-1]
civlyaerrA = civlyabothA[N_ELEMENTS(civA.signal):-1]

oiicivbothA = ratioanderror(oiiA.signal, oiiA.noise, civA.signal, civA.noise)
oiicivA = oiicivbothA[0:N_ELEMENTS(oiiA.signal)-1]
oiiciverrA = oiicivbothA[N_ELEMENTS(oiiA.signal):-1]

ciiicivbothA = ratioanderror(ciiiA.signal, ciiiA.noise, civA.signal, civA.noise)
ciiicivA = ciiicivbothA[0:N_ELEMENTS(ciiiA.signal)-1]
ciiiciverrA = ciiicivbothA[N_ELEMENTS(ciiiA.signal):-1]

lyaheiibothA = ratioanderror(lyaA.signal, lyaA.noise, heiiA.signal, heiiA.noise)
lyaheiiA = lyaheiibothA[0:N_ELEMENTS(lyaA.signal)-1]
lyaheiierrA = lyaheiibothA[N_ELEMENTS(lyaA.signal):-1]

oiiheiibothA = ratioanderror(oiiA.signal, oiiA.noise, heiiA.signal, heiiA.noise)
oiiheiiA = oiiheiibothA[0:N_ELEMENTS(oiiA.signal)-1]
oiiheiierrA = oiiheiibothA[N_ELEMENTS(oiiA.signal):-1]

heiicivbothA = ratioanderror(heiiA.signal, heiiA.noise, civA.signal, civA.noise)
heiicivA = heiicivbothA[0:N_ELEMENTS(heiiA.signal)-1]
heiiciverrA = heiicivbothA[N_ELEMENTS(heiiA.signal):-1]
;-----------------------------------------------------------------------------------------------------------------------------

; Keep only the data associated with a Lya Signal-To-Noise ratio greater than 2,
;   and aperture numbers between 60 and 100
lyaSN = lyaMID.signal / lyaMID.noise
lyaSNA = lyaA.signal / lyaA.noise
keep = (where((lyaSN GT 2) AND (lyaMID.ap GE 60) AND (lyaMID.ap LE 100)))  ; keep MID data
keepA = (where((lyaSNA GT 2) AND (lyaA.ap GE 60) AND (lyaA.ap LE 100)))    ; keep A data


; PLOTTING
; Plotlineratio input values: slitname, aperture, signalratio1, ratioerror1, rationame1, signalratio2, ratioerror2, rationame2
plotcivlya_oiicivMID = plotlineratio('MID', lyaMID(keep).ap, civlyaMID(keep), civlyaerrMID(keep), 'CIV-Lya', lyaheiiMID(keep), lyaheiierrMID(keep), 'Lya-HeII')
plotcivlya_oiicivMID = plotlineratio('MID', oiiMID(keep).ap, oiicivMID(keep), oiiciverrMID(keep), 'OII-CIV', oiiheiiMID(keep), oiiheiierrMID(keep), 'OII-HeII')
plotcivlya_oiicivMID = plotlineratio('MID', lyaMID(keep).ap, ciiicivMID(keep), ciiiciverrMID(keep), 'CIII-CIV', heiicivMID(keep), heiiciverrMID(keep), 'HeII-CIV')

plotcivlya_oiicivMID = plotlineratio('A', lyaMID(keep).ap, civlyaMID(keep), civlyaerrMID(keep), 'CIV-Lya', lyaheiiMID(keep), lyaheiierrMID(keep), 'Lya-HeII')
plotcivlya_oiicivMID = plotlineratio('A', oiiMID(keep).ap, oiicivMID(keep), oiiciverrMID(keep), 'OII-CIV', oiiheiiMID(keep), oiiheiierrMID(keep), 'OII-HeII')
plotcivlya_oiicivMID = plotlineratio('A', lyaMID(keep).ap, ciiicivMID(keep), ciiiciverrMID(keep), 'CIII-CIV', heiicivMID(keep), heiiciverrMID(keep), 'HeII-CIV')


; Forloops to print aperture numbers, line ratios, and line ratio errors to 2 txt files: MID and A data separately
; MID DATA
openw,1,path2+'/line_ratio/MID_datatable.txt'
printf,1,'  Aperture          CIV-Lya              CIV-Lya error             Lya-HeII               Lya-HeII error              OII-CIV               OII-CIV error               OII-HeII               OII-HeII error              CIII-CIV               CIII-CIV error              HeII-CIV               HeII-CIV error'
printf,1,'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
for j=0,n_elements(lyaMID(keep).ap)-1 do begin
  printf,1,(lyaMID(keep[j]).ap), (civlyaMID(keep[j])), (civlyaerrMID(keep[j])), (lyaheiiMID(keep[j])), (lyaheiierrMID(keep[j])), (oiicivMID(keep[j])), (oiiciverrMID(keep[j])), (oiiheiiMID(keep[j])), (oiiheiierrMID(keep[j])), (ciiicivMID(keep[j])), (ciiiciverrMID(keep[j])), (heiicivMID(keep[j])), (heiiciverrMID(keep[j])), FORMAT='(I,F,F,F,F,F,F,F,F,F,F,F,F)'
endfor
close,1

; A DATA
openw,1,path2+'/line_ratio/A_datatable.txt'
printf,1,'  Aperture          CIV-Lya              CIV-Lya error             Lya-HeII               Lya-HeII error              OII-CIV               OII-CIV error               OII-HeII               OII-HeII error              CIII-CIV               CIII-CIV error              HeII-CIV               HeII-CIV error'
printf,1,'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
for j=0,n_elements(lyaA(keepA).ap)-1 do begin
  printf,1,(lyaA(keepA).ap)[j], (civlyaA(keepA))[j], (civlyaerrA(keepA))[j], (lyaheiiA(keepA))[j], (lyaheiierrA(keepA))[j], (oiicivA(keepA))[j], (oiiciverrA(keepA))[j], (oiiheiiA(keepA))[j], (oiiheiierrA(keepA))[j], (ciiicivA(keepA))[j], (ciiiciverrA(keepA))[j], (heiicivA(keepA))[j], (heiiciverrA(keepA))[j], FORMAT='(I,F,F,F,F,F,F,F,F,F,F,F,F)'
endfor
close,1


end