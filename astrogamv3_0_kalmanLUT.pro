; astrogamv3_0_kalmanLUT.pro - Description
; ---------------------------------------------------------------------------------
; Computing the ASTROGAM tracker strip position and the GPS set-up
; ---------------------------------------------------------------------------------
; copyright            : (C) 2014 Valentina Fioretti
; email                : fioretti@iasfbo.inaf.it
; ----------------------------------------------
; Usage:
; astrogamv3_0_geometry
; ---------------------------------------------------------------------------------
; Notes:
; GPS theta, phi amd height set to 30, 225 and 150 cm
; Tracker geometry based on the AGILE V3.0 mass model


pro ASTROGAMV3_0_kalmanLUT

outdir = './conf/
print, 'Configuration files path: ', outdir

CheckOutDir = DIR_EXIST( outdir)
if (CheckOutDir EQ 0) then spawn,'mkdir -p ./conf'

theta_deg = 30.0d
phi_deg = 225.d
theta = theta_deg*(!PI/180.d)
phi = phi_deg*(!PI/180.d)

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
Al_t = 7.

plane_distance = Si_t + Al_t  ;mm
dist_tray = 0.   ;mm

print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '%                ASTROGAM V3.0                    %
print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '% - Number of trays:', N_tray 
print, '% - Number of strips:', N_strip
print, '% - Pitch [mm]:', pitch
print, '% - Tray side [mm]:', Tray_Side 
print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '% Tracker thicknesses:'
print, '% - Silicon thickness [mm]:', Si_t
print, '% - Al honeycomb thickness [mm]:', Al_t
print, '% ----------------------------------------------'
print, '% - Plane distance [mm]:', plane_distance
print, '% - Trays distance [mm]:', dist_tray
print, '% ----------------------------------------------'

Lower_module_t = 0.

z_start = 0.

Central_module_t = Al_t
Upper_module_t = Si_t

print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '% Tracker heights:'
print, '% - Lower module height [mm]:', Lower_module_t
print, '% - Central module height [mm]:', Central_module_t
print, '% - Upper module height [mm]:', Upper_module_t
print, '% - Tray height [mm]:', Lower_module_t + Central_module_t + Upper_module_t


TRK_t = Lower_module_t + Central_module_t + Upper_module_t
for k=1l, N_tray -1 do begin
  TRK_t = TRK_t + Lower_module_t + Central_module_t + Upper_module_t + dist_tray
endfor

z_end = TRK_t + z_start

print, '% - Tracker height [mm]:', TRK_t
print, '% - Tracker Z start [mm]:', z_start
print, '% - Tracker Z end [mm]:', z_end

pos_x = -1.
pos_y = -1.

vol_id_x_bottom = -1l
tray_id_x_bottom = -1l
Si_id_x_bottom = -1l
Strip_id_x_bottom = -1l
pos_z_x_bottom = -1.

vol_id_x_top = -1l
tray_id_x_top = -1l
Si_id_x_top = -1l
Strip_id_x_top = -1l
pos_z_x_top = -1.


; Total number of strips

Total_vol_x = N_tray*N_strip
Total_vol_y = N_tray*N_strip

Glob_vol_id_x_top = lonarr(Total_vol_x) 
Glob_pos_x_top = dblarr(Total_vol_x) 
Glob_z_x_top = dblarr(Total_vol_x) 
Glob_moth_id_x_top = lonarr(Total_vol_x) 
Glob_Strip_id_x_top = lonarr(Total_vol_x) 
Glob_Si_id_x_top = lonarr(Total_vol_x) 
Glob_tray_id_x_top = lonarr(Total_vol_x) 
Glob_plane_id_x_top = lonarr(Total_vol_x) 
Glob_energy_dep_x_top = dblarr(Total_vol_x) 

Glob_vol_id_y_top = lonarr(Total_vol_y) 
Glob_pos_y_top = dblarr(Total_vol_y) 
Glob_z_y_top = dblarr(Total_vol_y) 
Glob_moth_id_y_top = lonarr(Total_vol_y) 
Glob_Strip_id_y_top = lonarr(Total_vol_y) 
Glob_Si_id_y_top = lonarr(Total_vol_y) 
Glob_tray_id_y_top = lonarr(Total_vol_y) 
Glob_plane_id_y_top = lonarr(Total_vol_y) 
Glob_energy_dep_y_top = dblarr(Total_vol_y) 

; all strips are readout

; ----> X layer

Tray_t = Lower_module_t + Central_module_t + Upper_module_t

for t=0l, N_tray-1 do begin
      
      LowerModulePos_z = t*(dist_tray + Tray_t) + (Lower_module_t/2.)

      UpperModulePos_z = t*(dist_tray + Tray_t) + Lower_module_t + Central_module_t + (Upper_module_t/2.)      
      pos_z_x_top = UpperModulePos_z -(Upper_module_t/2.) + Si_t/2.
      pos_z_y_top = UpperModulePos_z -(Upper_module_t/2.) + Si_t/2.

      
      ;print, pos_z_x
      copyM = 1000000l + 1000000l*t
      for s=0l, N_strip-1 do begin

        Glob_moth_id_x_top[(t)*N_strip + s] = (copyM + 90000l)
        Glob_tray_id_x_top[(t)*N_strip + s] = t+1
        Glob_plane_id_x_top[(t)*N_strip + s] = N_tray - t
        Glob_Si_id_x_top[(t)*N_strip + s] = 0
        Glob_Strip_id_x_top[(t)*N_strip + s] = s
        Glob_energy_dep_x_top[(t)*N_strip + s] = 0.
        Glob_vol_id_x_top[(t)*N_strip + s] = s

        Strip_pos_x_top = (pitch/2.) + (pitch*s)
        Glob_pos_x_top[(t)*N_strip + s] = Strip_pos_x_top/10.  ;cm
        Glob_z_x_top[(t)*N_strip + s] = pos_z_x_top/10.

        Glob_moth_id_y_top[(t)*N_strip + s] = (copyM + 90000l)
        Glob_tray_id_y_top[(t)*N_strip + s] = t+1
        Glob_plane_id_y_top[(t)*N_strip + s] = N_tray - t
        Glob_Si_id_y_top[(t)*N_strip + s] = 1
        Glob_Strip_id_y_top[(t)*N_strip + s] = s
        Glob_energy_dep_y_top[(t)*N_strip + s] = 0.
        Glob_vol_id_y_top[(t)*N_strip + s] =  s

        Strip_pos_y_top = (pitch/2.) + (pitch*s)
        Glob_pos_y_top[(t)*N_strip + s] = Strip_pos_y_top/10.  ;cm
        Glob_z_y_top[(t)*N_strip + s] = pos_z_y_top/10.
      endfor
 endfor
 

CREATE_STRUCT, KALMANXTop, 'KALMANXTop', ['VOLUME_ID', 'MOTHER_ID', 'TRAY_ID', 'PLANE_ID','TRK_FLAG', 'STRIP_ID', 'XPOS', 'ZPOS','E_DEP'], 'J,J,I,I,I,J,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(Glob_vol_id_x_top)
KALMANXTop.VOLUME_ID = Glob_vol_id_x_Top
KALMANXTop.MOTHER_ID = Glob_moth_id_x_Top
KALMANXTop.TRAY_ID = Glob_tray_id_x_Top
KALMANXTop.PLANE_ID = Glob_plane_id_x_Top
KALMANXTop.TRK_FLAG = Glob_Si_id_x_Top
KALMANXTop.STRIP_ID = Glob_Strip_id_x_Top
KALMANXTop.XPOS = Glob_pos_x_Top
KALMANXTop.ZPOS = Glob_z_x_Top
KALMANXTop.E_DEP = Glob_energy_dep_x_Top

HDR_XGRID_Top = ['Creator          = Valentina Fioretti', $
                 'ASTROGAM release    = V3.0']

MWRFITS, KALMANXTop, './conf/KALMAN.XTOP.ASTROGAMV3.0.TRACKER.FITS', HDR_XGRID_Top, /CREATE

CREATE_STRUCT, KALMANYTop, 'KALMANYTop', ['VOLUME_ID', 'MOTHER_ID', 'TRAY_ID', 'PLANE_ID','TRK_FLAG', 'STRIP_ID', 'YPOS', 'ZPOS','E_DEP'], 'J,J,I,I,I,J,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(Glob_vol_id_y_top)
KALMANYTop.VOLUME_ID = Glob_vol_id_y_Top
KALMANYTop.MOTHER_ID = Glob_moth_id_y_Top
KALMANYTop.TRAY_ID = Glob_tray_id_y_Top
KALMANYTop.PLANE_ID = Glob_plane_id_y_Top
KALMANYTop.TRK_FLAG = Glob_Si_id_y_Top
KALMANYTop.STRIP_ID = Glob_Strip_id_y_Top
KALMANYTop.YPOS = Glob_pos_y_Top
KALMANYTop.ZPOS = Glob_z_y_Top
KALMANYTop.E_DEP = Glob_energy_dep_y_Top

HDR_YGRID_Top = ['Creator          = Valentina Fioretti', $
                 'ASTROGAM release    = V3.0']

MWRFITS, KALMANYTop, './conf/KALMAN.YTOP.ASTROGAMV3.0.TRACKER.FITS', HDR_YGRID_Top, /CREATE

print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '% Output FITS files with X and Y strip positions'
print, '% - ARCH.XSTRIP.BOTTOM.ASTROGAMV1.0.TRACKER.FITS'
print, '% - ARCH.YSTRIP.BOTTOM.ASTROGAMV1.0.TRACKER.FITS'
print, '% - ARCH.XSTRIP.TOP.ASTROGAMV1.0.TRACKER.FITS'
print, '% - ARCH.YSTRIP.TOP.ASTROGAMV1.0.TRACKER.FITS'

print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
print, '% GPS Set-up for the point source position:'
print, '% - theta [deg.]:', theta_deg
print, '% - phi [deg.]:', phi_deg
print, '% - source height [cm]:', h_s
print, '% ----------------------------------------------'

; tracker height
h_t = z_end/10. ; cm

; source height respect to tracker
h_r = h_s - h_t

; source distance from (0,0)
radius = h_r*tan(theta)
x_s = ((cos(phi))*radius)
y_s = ((sin(phi))*radius)


P_x = -sin(theta)*cos(phi)
P_y = -sin(theta)*sin(phi)
P_z = -cos(theta)

print, '% Source position:'
print, '% - X [cm]:', x_s
print, '% - Y [cm]:', y_s
print, '% - Z [cm]:', h_s
print, '% - Source direction:'
print, '% - P_x:', P_x
print, '% - P_y:', P_y
print, '% - P_z:', P_z
print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

end
