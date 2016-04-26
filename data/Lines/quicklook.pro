pro quicklook
bin = 'velo' ;velo, velobin, or wide
lyasnr = 3

pa = 'MID'
lyaMID = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.lya.fits',1)
civMID = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.civ.fits',1)
ciiiMID = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.ciii.fits',1)
heiiMID = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.heii.fits',1)
neivMID = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.neiv.fits',1)
nvMID = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.nv.fits',1)
siivMID = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.siiv.fits',1)
oiiMID = mrdfits('red/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'.oii.fits',1)
inMID = where(lyaMID.signal/lyaMID.noise gt lyasnr,ninMID)

pa = 'A'
lyaA = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.lya.fits',1)
civA = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.civ.fits',1)
ciiiA = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.ciii.fits',1)
heiiA = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.heii.fits',1)
neivA = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.neiv.fits',1)
nvA = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.nv.fits',1)
siivA = mrdfits('blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.siiv.fits',1)
oiiA = mrdfits('red/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'.oii.fits',1)
inA = where(lyaA.signal/lyaA.noise gt lyasnr,ninA)

;make new files without header for Arthur Cox program

pa = 'MID'
struct_print, lyaMID, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.lya.nohead.dat'
struct_print, civMID, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.civ.nohead.dat'
struct_print, ciiiMID, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.ciii.nohead.dat'
struct_print, heiiMID, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.heii.nohead.dat'
struct_print, neivMID, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.neiv.nohead.dat'
struct_print, nvMID, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.nv.nohead.dat'
struct_print, siivMID, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.siiv.nohead.dat'
struct_print, oiiMID, /no_head, filename='red/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'.oii.nohead.dat'

pa = 'A'
struct_print, lyaA, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.lya.nohead.dat'
struct_print, civA, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.civ.nohead.dat'
struct_print, ciiiA, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.ciii.nohead.dat'
struct_print, heiiA, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.heii.nohead.dat'
struct_print, neivA, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.neiv.nohead.dat'
struct_print, nvA, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.nv.nohead.dat'
struct_print, siivA, /no_head, filename='blue/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'combo.siiv.nohead.dat'
struct_print, oiiA, /no_head, filename='red/'+bin+'/casdPRG1_'+pa+'_B.sky'+bin+'.oii.nohead.dat'




stop
!p.multi=[0,2,1,0,0]
;civ/ciii vs. civ/heii
makeloglogplot, inMID, civMID, heiiMID, civMID, ciiiMID 
makeloglogplot, inA, civA, heiiA, civA, ciiiA 

stop
;ciii/heii vs. oii/heii
makeloglogplot, inMID, oiiMID, heiiMID, ciiiMID, heiiMID 
makeloglogplot, inA, oiiA, heiiA, ciiiA, heiiA 

stop
end


pro makeloglogplot, in, xtopline, xbottomline, ytopline, ybottomline
device, decomposed=0
loadct, 39
x = xtopline(in).signal/xbottomline(in).signal
y = ytopline(in).signal/ybottomline(in).signal
errx = x*sqrt( (xtopline(in).noise/xtopline(in).signal)^2+(xbottomline(in).noise/xbottomline(in).signal)^2 )
erry = y*sqrt( (ytopline(in).noise/ytopline(in).signal)^2+(ybottomline(in).noise/ybottomline(in).signal)^2 )

logx = alog10(x)
logy = alog10(y)

errlogx = 0.434*errx/x
errlogy = 0.434*erry/y

colors = make_array(n_elements(in),/index)*250/float(n_elements(in)-1)

plotsym, 0, 1, /fill

plot, logx, logy, psym=8, xrange=[-3,2], yrange=[-2,2], /nodata 
oploterror, logx, logy, errlogx, errlogy, psym=3
for i=0, n_elements(in)-1 do begin
	oplot, [logx(i)], [logy(i)], psym=8, color=colors(i)
endfor

end
