pro ASTROGAMV3_0_conversion_efficiency

Energy = [0.511, 1, 2, 3, 5, 8, 10, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 5000, 10000]
Plane_ID = indgen(70)+1

print, plane_ID

E_sel = 0.
theta = 0

conv_energy_tot = dblarr(n_elements(Energy), n_elements(Plane_ID))
conv_energy_cum = dblarr(n_elements(Energy), n_elements(Plane_ID))

;read, E_sel, PROMPT='% - Enter the selected energy [MeV]:'
read, theta, PROMPT='% - Enter theta [deg.]:'

theta_deg = theta

theta = theta*(!PI/180.d)

; source height
h_s = 150.d  ;cm

; Global Geometry:
N_tray = 70l  
N_layer = 1l
N_strip = 2480l
pitch = 0.242   ;mm
Tray_side = 600.16  ;mm

; Tracker geometry [mm]
Si_t = 0.400
Glue_t = 0.0
K_t = 0.0
CF_t = 0.0
Conv_t = 0
Al_t = 7. 

CF_hat_t = 0.250 ;mm
Al_hat_t = 29.5 ;mm
; material density

rho_Si = 2.330   ;g/cm3
rho_CF = 1.46   ;g/cm3
rho_honey = 0.04   ;g/cm3
rho_honey_hat = 0.032   ;g/cm3

; material attenuation coefficients

;mu_Si = [8.666E-02, 6.361E-02, 3.678E-02, 2.967E-02, 2.462E-02, 2.764E-02, 2.996E-02, 3.111E-02, 3.181E-02, 3.229E-02, 3.263E-02, 3.291E-02, 3.312E-02, 3.330E-02, 3.344E-02, 3.444E-02, 3.469E-02, 3.493E-02, 3.512E-02]
;mu_CF = [1.071E-01, 7.891E-02, 4.383E-02, 3.282E-02, 2.280E-02, 1.405E-02, 1.450E-02, 1.487E-02, 1.514E-02, 1.534E-02, 1.550E-02, 1.562E-02, 1.571E-02, 1.580E-02, 1.586E-02, 1.638E-02, 1.652E-02, 1.665E-02, 1.677E-02]
;mu_honey = [8.367E-02, 6.146E-02, 3.541E-02, 2.836E-02, 2.318E-02, 2.517E-02, 2.724E-02, 2.825E-02, 2.888E-02, 2.931E-02, 2.961E-02, 2.985E-02, 3.004E-02, 3.019E-02, 3.032E-02, 3.123E-02, 3.148E-02, 3.168E-02, 3.186E-02]


mu_Si = [8.666E-02, 6.361E-02, 4.481E-02, 3.678E-02, 2.967E-02, 2.574E-02, 2.462E-02, 2.764E-02, 2.996E-02, 3.111E-02, 3.181E-02, 3.229E-02, 3.263E-02, 3.291E-02, 3.312E-02, 3.330E-02, 3.344E-02, 3.469E-02, 3.493E-02]
mu_CF = [1.071E-01, 7.891E-02, 5.499E-02, 4.383E-02, 3.282E-02, 2.547E-02, 2.280E-02, 1.405E-02, 1.450E-02, 1.487E-02, 1.514E-02, 1.534E-02, 1.550E-02, 1.562E-02, 1.571E-02, 1.580E-02, 1.586E-02, 1.652E-02, 1.665E-02]
mu_honey = [8.367E-02, 6.146E-02, 4.324E-02, 3.541E-02, 2.836E-02, 2.437E-02, 2.318E-02, 2.517E-02, 2.724E-02, 2.825E-02, 2.888E-02, 2.931E-02, 2.961E-02, 2.985E-02, 3.004E-02, 3.019E-02, 3.032E-02, 3.148E-02, 3.168E-02]

plane_distance = Si_t + Al_t   ;mm
dist_tray = 0.   ;mm


print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, 'Al honeycomb thickness [mm]:', Al_t
 
Lower_module_t = 0.

z_start = 0.

Central_module_t = Al_t
Upper_module_t = Si_t


print, 'Lower module height [mm]:', Lower_module_t
print, 'Central module height [mm]:', Central_module_t
print, 'Upper module height [mm]:', Upper_module_t
print, 'Tray height [mm]:', Lower_module_t + Central_module_t + Upper_module_t

print, 'Plane distance [mm]:', plane_distance
print, 'Tray distance [mm]:', dist_tray

TRK_t = Lower_module_t + Central_module_t + Upper_module_t

for k=1l, N_tray -1 do begin
     TRK_t = TRK_t + Lower_module_t + Central_module_t + Upper_module_t + dist_tray 
endfor
z_end = TRK_t + z_start

print, 'Tracker height [mm]:', TRK_t

print, 'Tracker Z start [mm]:', z_start
print, 'Tracker Z end [mm]:', z_end
print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

for j=0l, n_elements(Energy)-1 do begin

     print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
     print, 'Energy [MeV]:', Energy[j]
     print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
     ;E_pos = where(Energy EQ E_sel)
     E_pos = j

     ; Fraction of the converted photons = 1 - I/I_0 = 1 - exp(-(mu*rho*t))
 
     conv_CF_hat = 1. - exp(-(mu_CF[E_pos])*rho_CF*((CF_hat_t/cos(theta))/10.))
     conv_honey_hat = 1. - exp(-(mu_honey[E_pos])*rho_honey_hat*((Al_hat_t/cos(theta))/10.))
 
     conv_CF = 1. - exp(-(mu_CF[E_pos])*rho_CF*((CF_t/cos(theta))/10.))
     conv_honey = 1. - exp(-(mu_honey[E_pos])*rho_honey*((Al_t/cos(theta))/10.))
     conv_Si = 1. - exp(-(mu_Si[E_pos])*rho_Si*(1.*(Si_t/cos(theta))/10.))

     print, 'Hat Carbon Fiber conversion efficiency:', conv_CF_hat 
     print, 'Hat Al Honeycomb conversion efficiency:', conv_honey_hat 
     print, 'Carbon Fiber conversion efficiency:', conv_CF 
     print, 'Al Honeycomb conversion efficiency:', conv_honey 
     print, 'Silicon conversion efficiency:', conv_Si 
     print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'


     ; Conversion fraction for each additional tray
     conv_tot = dblarr(N_tray)

     ; Conversion fraction for tray less then the element
     conv_lesstray_tot = dblarr(N_tray)

     conv_hat = conv_CF_hat + (1. - conv_CF_hat)*conv_honey_hat + (1. - conv_CF_hat)*(1. - conv_honey_hat)*conv_CF_hat

     print, 'Hat conversion efficiency:', conv_hat 
     print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

     for k=0, N_tray-1 do begin
        if (k EQ 0) then begin
            conv_tot(k) = (1. - conv_hat)*(conv_Si + (1. - conv_Si)*conv_honey)   
        endif else begin
            conv_tot[k] = conv_tot[k-1] + (1. - conv_tot[k-1])*(conv_Si + (1. - conv_Si)*conv_honey)   
        endelse
     endfor


     print, 'Total conversion fraction for each tray:', conv_tot

 ;    conv_lesstray_tot = total(conv_tot, /cumulative)

 ;    print, 'cumulative conversion fraction for each tray:', conv_lesstray_tot
     
     conv_energy_tot[j, *] = conv_tot
 ;    conv_energy_cum[j, *] = conv_lesstray_tot
     

endfor

CREATE_STRUCT, ASTROGAMV3_0_conv, 'A1_3conv_cum', ['PLANE_ID', 'E0_511', 'E1', 'E2', 'E3', 'E5', 'E10', 'E8', 'E100', 'E200','E300', 'E400', 'E500', 'E600', 'E700', 'E800', 'E900', 'E1000', 'E5000', 'E10000'], 'I,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(Plane_ID)
ASTROGAMV3_0_conv.PLANE_ID = Plane_ID
for k=0l, n_elements(Plane_ID)-1 do begin
 ASTROGAMV3_0_conv[k].E0_511 = conv_energy_tot[0, k]
 ASTROGAMV3_0_conv[k].E1 = conv_energy_tot[1, k]
 ASTROGAMV3_0_conv[k].E2 = conv_energy_tot[2, k]
 ASTROGAMV3_0_conv[k].E3 = conv_energy_tot[3, k]
 ASTROGAMV3_0_conv[k].E5 = conv_energy_tot[4, k]
 ASTROGAMV3_0_conv[k].E8 = conv_energy_tot[5, k]
 ASTROGAMV3_0_conv[k].E10 = conv_energy_tot[6, k]
 ASTROGAMV3_0_conv[k].E100 = conv_energy_tot[7, k]
 ASTROGAMV3_0_conv[k].E200 = conv_energy_tot[8, k]
 ASTROGAMV3_0_conv[k].E300 = conv_energy_tot[9, k]
 ASTROGAMV3_0_conv[k].E400 = conv_energy_tot[10, k]
 ASTROGAMV3_0_conv[k].E500 = conv_energy_tot[11, k]
 ASTROGAMV3_0_conv[k].E600 = conv_energy_tot[12, k]
 ASTROGAMV3_0_conv[k].E700 = conv_energy_tot[13, k]
 ASTROGAMV3_0_conv[k].E800 = conv_energy_tot[14, k]
 ASTROGAMV3_0_conv[k].E900 = conv_energy_tot[15, k]
 ASTROGAMV3_0_conv[k].E1000 = conv_energy_tot[16, k]
 ASTROGAMV3_0_conv[k].E5000 = conv_energy_tot[17, k]
 ASTROGAMV3_0_conv[k].E10000 = conv_energy_tot[18, k]
endfor

HDR_CUM = ['Creator          = Valentina Fioretti', $
           'ASTROGAM release    = V3.0']

MWRFITS, ASTROGAMV3_0_conv, 'CONVERSION.ASTROGAMV3.0.CUMULATIVE.'+strmid(strtrim(string(theta_deg),1),0,3)+'DEG.FITS', HDR_CUM, /CREATE


end
