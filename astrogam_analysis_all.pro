; astrogam_analysis_all.pro - Description
; ---------------------------------------------------------------------------------
; Compacting the THELSim ASTROGAM processed files to a unique file:
; - Tracker
; - AC
; - Calorimeter
; ---------------------------------------------------------------------------------
; Output:
; - all files are created in the same directory of the input files
; ---------> ASCII files
; - G4.RAW.KALMAN.AGILE<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
; - G4.RAW.GENERAL.AGILE<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
; - G4.DIGI.KALMAN.AGILE<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
; - G4.DIGI.GENERAL.AGILE<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
; - G4_GAMS_XPLANE_AGILE<version>_<phys>List_<sim_type>_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
; - G4_GAMS_YPLANE_AGILE<version>_<phys>List_<sim_type>_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
; - G4_GAMS_CAL_AGILE<version>_<phys>List_<sim_type>_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
; - G4_GAMS_AC_AGILE<version>_<phys>List_<sim_type>_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
; - stripx.dat
; - stripy.dat
; - ac.dat
; - calo.dat
; ---------> FITS files
; - G4.RAW.AGILE<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
; - L0.AGILE<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
; - L0.5.DIGI.AGILE<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
; - G4.AGILE<version>.AC.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
; - G4.AGILE<version>.CAL.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits 
; ---------------------------------------------------------------------------------
; copyright            : (C) 2014 Valentina Fioretti
; email                : fioretti@iasfbo.inaf.it
; ----------------------------------------------
; Usage:
; astrogam_analysis_all
; ---------------------------------------------------------------------------------


pro astrogam_analysis_all

; Variables initialization
N_in = 0UL            ;--> Number of emitted photons
part_type = ''       ; particle type
n_files = 0           ;--> Number of processed files produced by agile_dhsim_file

astrogam_version = ''
sim_type = 0
py_list = 0
ene_range = 0
ene_type = 0.
theta_type = 0
phi_type = 0
source_g = 0
ene_min = 0
ene_max = 0

read, astrogam_version, PROMPT='% - Enter ASTROGAM release (e.g. V1.4):'
read, sim_type, PROMPT='% - Enter simulation type [0 = Mono, 1 = Chen, 2: Vela, 3: Crab, 4: G400]:'
read, n_files, PROMPT='% - Enter number of input files:'
read, py_list, PROMPT='% - Enter the Physics List [0 = QGSP_BERT_EMV, 100 = ARGO, 300 = FERMI, 400 = ASTROMEV]:'
read, N_in, PROMPT='% - Enter the number of emitted photons:'
read, part_type, PROMPT='% - Enter the particle type [ph = photons, mu = muons]:'
read, ene_range, PROMPT='% - Enter energy distribution [0 = mono, 1 = range]:'
if (ene_range EQ 0) then begin
  read, ene_type, PROMPT='% - Enter energy [MeV]:'
  if (ene_type GE 1) then ene_type = strtrim(string(long(ene_type)),1)
  if (ene_type LT 1) then ene_type = STRMID(STRTRIM(STRING(ene_type),1),0,5)
endif
if (ene_range EQ 1) then begin
    read, ene_min, PROMPT='% - Enter miminum energy [MeV]:' 
    read, ene_max, PROMPT='% - Enter maximum energy [MeV]:'
    ene_type = strtrim(string(ene_min),1)+'.'+strtrim(string(ene_max),1)
endif
read, theta_type, PROMPT='% - Enter theta:'
read, phi_type, PROMPT='% - Enter phi:'
read, source_g, PROMPT='% - Enter source geometry [0 = Point, 1 = Plane]:'

if (py_list EQ 0) then begin
   py_dir = 'QGSP_BERT_EMV'
   py_name = 'QGSP_BERT_EMV'
endif
if (py_list EQ 100) then begin
   py_dir = '/100List'
   py_name = '100List'
endif
if (py_list EQ 300) then begin
   py_dir = '/300List'
   py_name = '300List'
endif
if (py_list EQ 400) then begin
   py_dir = 'ASTROMEV'
   py_name = 'ASTROMEV'
endif

if (sim_type EQ 0) then begin
   sim_name = 'MONO'
endif
if (sim_type EQ 1) then begin
   sim_name = 'CHEN'
endif
if (sim_type EQ 2) then begin
   sim_name = 'VELA'
endif
if (sim_type EQ 3) then begin
   sim_name = 'CRAB'
endif
if (sim_type EQ 4) then begin
   sim_name = 'G410'
endif

if (source_g EQ 0) then begin
 sdir = '/Point'
 sname = 'Point'
endif
if (source_g EQ 1) then begin
 sdir = '/Plane'
 sname = 'Plane'
endif

read, isStrip, PROMPT='% - Strip/Pixels activated?:'
read, repli, PROMPT='% - Strips/Pixels replicated?:'

if (astrogam_version EQ 'V1.0') then begin
    if (isStrip EQ 0) then stripDir = 'NoStrip/'
    if ((isStrip EQ 1) AND (repli EQ 0)) then stripDir = 'StripNoRepli/'
    if ((isStrip EQ 1) AND (repli EQ 1)) then stripDir = 'StripRepli/'
    
    if (isStrip EQ 0) then stripname = 'NOSTRIP'
    if ((isStrip EQ 1) AND (repli EQ 0)) then stripname = 'STRIP'
    if ((isStrip EQ 1) AND (repli EQ 1)) then stripname = 'STRIP.REPLI'
endif 
if (astrogam_version EQ 'V2.0') then begin
    if (isStrip EQ 0) then stripDir = 'NoPixel/'
    if ((isStrip EQ 1) AND (repli EQ 0)) then stripDir = 'PixelNoRepli/'
    if ((isStrip EQ 1) AND (repli EQ 1)) then stripDir = 'PixelRepli/'
    
    if (isStrip EQ 0) then stripname = 'NOPIXEL'
    if ((isStrip EQ 1) AND (repli EQ 0)) then stripname = 'PIXEL'
    if ((isStrip EQ 1) AND (repli EQ 1)) then stripname = 'PIXEL.REPLI'
endif 
if (astrogam_version EQ 'V3.0') then begin
    if (isStrip EQ 0) then stripDir = 'NoPixel/'
    if ((isStrip EQ 1) AND (repli EQ 0)) then stripDir = 'PixelNoRepli/'
    if ((isStrip EQ 1) AND (repli EQ 1)) then stripDir = 'PixelRepli/'
    
    if (isStrip EQ 0) then stripname = 'NOPIXEL'
    if ((isStrip EQ 1) AND (repli EQ 0)) then stripname = 'PIXEL'
    if ((isStrip EQ 1) AND (repli EQ 1)) then stripname = 'PIXEL.REPLI'
endif 


; Reading the FITS files

; G4.RAW.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
rawData_event_id = -1l
rawData_tray_id =  -1l
rawData_plane_id =  -1l
rawData_Strip_id_x =  -1l
rawData_Strip_id_y =  -1l
rawData_energy_dep =  -1.
rawData_ent_x =  -1.
rawData_ent_y =  -1.
rawData_ent_z =  -1.
rawData_exit_x =  -1.
rawData_exit_y =  -1.
rawData_exit_z =  -1.

; L0.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
L0TRACKER_Glob_event_id = -1l
L0TRACKER_Glob_vol_id = -1l
L0TRACKER_Glob_moth_id = -1l
L0TRACKER_Glob_tray_id = -1l
L0TRACKER_Glob_plane_id = -1l
L0TRACKER_Glob_Si_id = -1l
L0TRACKER_Glob_Strip_id = -1l
L0TRACKER_Glob_pos = -1.
L0TRACKER_Glob_zpos = -1.
L0TRACKER_Glob_energy_dep = -1.

; L0.5.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
L05TRACKER_Glob_event_id_cluster = -1l
L05TRACKER_Glob_tray_id_cluster = -1l
L05TRACKER_Glob_plane_id_cluster = -1l
L05TRACKER_Glob_Si_id_cluster = -1l
L05TRACKER_Glob_pos_cluster = -1.
L05TRACKER_Glob_zpos_cluster = -1.
L05TRACKER_Glob_energy_dep_cluster = -1.

; KALMAN.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
default_max_cols = 1000
KALMAN_eventid = float(-1l)
KALMAN_theta = float(-1l)
KALMAN_phi = float(-1l)
KALMAN_energy = float(-1l)
KALMAN_plane_x = MAKE_ARRAY(default_max_cols, 1, /INTEGER, VALUE = 0)
KALMAN_cluster_x = MAKE_ARRAY(default_max_cols, 1, /DOUBLE, VALUE = 0)
KALMAN_plane_y = MAKE_ARRAY(default_max_cols, 1, /INTEGER, VALUE = 0)
KALMAN_cluster_y = MAKE_ARRAY(default_max_cols, 1, /DOUBLE, VALUE = 0)

; SUM.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
SUMTRACKER_Glob_event_id_cluster = -1l
SUMTRACKER_Glob_tray_id_cluster = -1l
SUMTRACKER_Glob_plane_id_cluster = -1l
SUMTRACKER_Glob_Si_id_cluster = -1l
SUMTRACKER_Glob_zpos_cluster = -1.
SUMTRACKER_Glob_energy_dep_cluster = -1.

; G4.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits 
calInput_event_id_tot_cal = -1l
calInput_bar_id_tot = -1l
calInput_bar_ene_tot = -1.

; SUM.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits 
calInputSum_event_id_tot_cal = -1l
calInputSum_bar_ene_tot = -1.

; G4.AC.AGILE<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
acInput_event_id_tot_ac = -1l
acInput_AC_panel = ''
acInput_AC_subpanel = -1l
acInput_energy_dep_tot_ac = -1.

; - G4.RAW.KALMAN.AGILE<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = Silicon layer ID
    ; - c3 = x/y pos [cm]
    ; - c4 = z pos [cm]
    ; - c5 = plane ID
    ; - c6 = strip ID
    ; - c7 = energy dep [keV]

raw_kalman_event_id = -1l
raw_kalman_Si_id = -1l
raw_kalman_pos = -1.
raw_kalman_zpos = -1.
raw_kalman_plane_id = -1l
raw_kalman_strip_id = -1l
raw_kalman_edep = -1.

; - G4.RAW.GENERAL.AGILE<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = Silicon layer ID
    ; - c3 = x/y pos [cm]
    ; - c4 = z pos [cm]
    ; - c5 = tray ID
    ; - c6 = plane ID
    ; - c7 = strip ID 
    ; - c8 = energy dep [keV]    

raw_general_event_id = -1l
raw_general_Si_id = -1l
raw_general_pos = -1.
raw_general_zpos = -1.
raw_general_tray_id = -1l
raw_general_plane_id = -1l
raw_general_strip_id = -1l
raw_general_edep = -1.    

; - G4.DIGI.KALMAN.AGILE<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = Silicon layer ID
    ; - c3 = x/y pos [cm]
    ; - c4 = z pos [cm]
    ; - c5 = plane ID
    ; - c6 = strip ID
    ; - c7 = energy dep [keV]

digi_kalman_event_id = -1l
digi_kalman_Si_id = -1l
digi_kalman_pos = -1.
digi_kalman_zpos = -1.
digi_kalman_plane_id = -1l
digi_kalman_strip_id = -1l
digi_kalman_edep = -1.

; - G4.DIGI.GENERAL.AGILE<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = Silicon layer ID
    ; - c3 = x/y pos [cm]
    ; - c4 = z pos [cm]
    ; - c5 = tray ID
    ; - c6 = plane ID
    ; - c7 = strip ID 
    ; - c8 = energy dep [keV]    

digi_general_event_id = -1l
digi_general_Si_id = -1l
digi_general_pos = -1.
digi_general_zpos = -1.
digi_general_tray_id = -1l
digi_general_plane_id = -1l
digi_general_strip_id = -1l
digi_general_edep = -1.    


; - G4_GAMS_XPLANE_AGILE<version>_<phys>List_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = plane ID
    ; - c3 = readout strip ID
    ; - c4 = -999
    ; - c5 = -999
    ; - c6 = energy dep in MIP
    ; - c7 = -999    event_start = -1
    
gams_xplane_event_id = -1l
gams_xplane_plane_id = -1l
gams_xplane_readstreap_id = -1l
gams_xplane_c4 = -1l
gams_xplane_c5 = -1l
gams_xplane_edep = -1.
gams_xplane_c7 = -1l

; - G4_GAMS_YPLANE_AGILE<version>_<phys>List_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = plane ID
    ; - c3 = readout strip ID
    ; - c4 = -999
    ; - c5 = -999
    ; - c6 = energy dep in MIP
    ; - c7 = -999
    
gams_yplane_event_id = -1l
gams_yplane_plane_id = -1l
gams_yplane_readstreap_id = -1l
gams_yplane_c4 = -1l
gams_yplane_c5 = -1l
gams_yplane_edep = -1.
gams_yplane_c7 = -1l


; - G4_GAMS_CAL_AGILE<version>_<phys>List_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = bar plane 
    ; - c3 = bar id
    ; - c4 = 0
    ; - c5 = energy A
    ; - c6 = energy B

gams_cal_event_id = -1l
gams_cal_bar_plane = -1l
gams_cal_bar_id= -1l
gams_cal_c4 = -1l
gams_cal_ene_a = -1.
gams_cal_ene_b = -1.

; - G4_GAMS_AC_AGILE<version>_<phys>List_<strip>_<point>_<n_in>ph_<energy>MeV_<theta>_<phi>.all.dat
    ; ASCII Columns:
    ; - c1 = event ID
    ; - c2 = AC panel
    ; - c3 = AC subpanel
    ; - c4 = energy deposit

gams_ac_event_id = -1l
gams_ac_panel = ''
gams_ac_subpanel = -1l
gams_ac_edep = -1.

filepath = './ASTROGAM'+astrogam_version+sdir+'/theta'+strtrim(string(theta_type),1)+'/'+stripDir+py_dir+'/'+sim_name+'/'+ene_type+'MeV/'+strtrim(string(N_in),1)+part_type+'/'
print, 'LEVEL0 file path: ', filepath

for ifile=0, n_files-1 do begin

;
;    filenamedat_raw_kalman = filepath+'G4.RAW.KALMAN.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_raw_kalman, c1, c2, c3, c4, c5, c6, c7, format='(l,l,d,d,l,l,d)'
;    raw_kalman_event_id = [raw_kalman_event_id, c1]
;    raw_kalman_Si_id = [raw_kalman_Si_id, c1]
;    raw_kalman_pos = [raw_kalman_pos, c2]
;    raw_kalman_zpos = [raw_kalman_zpos, c3]
;    raw_kalman_plane_id = [raw_kalman_plane_id, c4]
;    raw_kalman_strip_id = [raw_kalman_strip_id, c5]
;    raw_kalman_edep = [raw_kalman_edep, c6]  
;
;    
;    filenamedat_raw_general = filepath+'G4.RAW.GENERAL.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_raw_general, c1, c2, c3, c4, c5, c6, c7, c8, format='(l,l,d,d,l,l,l,d)'
;    raw_general_event_id = [raw_general_event_id, c1]
;    raw_general_Si_id = [raw_general_Si_id, c2]
;    raw_general_pos = [raw_general_pos, c3]
;    raw_general_zpos = [raw_general_zpos, c4]
;    raw_general_tray_id = [raw_general_tray_id, c5]
;    raw_general_plane_id = [raw_general_plane_id, c6]
;    raw_general_strip_id = [raw_general_strip_id, c7]
;    raw_general_edep = [raw_general_edep, c8]  
;
;    filenamedat_digi_kalman = filepath+'G4.DIGI.KALMAN.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_digi_kalman, c1, c2, c3, c4, c5, c6, c7, format='(l,l,d,d,l,l,d)'
;    digi_kalman_event_id = [digi_kalman_event_id, c1]
;    digi_kalman_Si_id = [digi_kalman_Si_id, c1]
;    digi_kalman_pos = [digi_kalman_pos, c2]
;    digi_kalman_zpos = [digi_kalman_zpos, c3]
;    digi_kalman_plane_id = [digi_kalman_plane_id, c4]
;    digi_kalman_strip_id = [digi_kalman_strip_id, c5]
;    digi_kalman_edep = [digi_kalman_edep, c6]  
;    
;    filenamedat_digi_general = filepath+'G4.DIGI.GENERAL.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_digi_general, c1, c2, c3, c4, c5, c6, c7, c8, format='(l,l,d,d,l,l,l,d)'
;    digi_general_event_id = [digi_general_event_id, c1]
;    digi_general_Si_id = [digi_general_Si_id, c2]
;    digi_general_pos = [digi_general_pos, c3]
;    digi_general_zpos = [digi_general_zpos, c4]
;    digi_general_tray_id = [digi_general_tray_id, c5]
;    digi_general_plane_id = [digi_general_plane_id, c6]
;    digi_general_strip_id = [digi_general_strip_id, c7]
;    digi_general_edep = [digi_general_edep, c8]  
;    
;    filenamedat_gams_xplane = filepath+'G4_GAMS_XPLANE_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_gams_xplane, c1, c2, c3, c4, c5, c6, c7, format='(l,l,l,l,l,d,l)' 
;    gams_xplane_event_id = [gams_xplane_event_id, c1]
;    gams_xplane_plane_id = [gams_xplane_plane_id, c2]
;    gams_xplane_readstreap_id = [gams_xplane_readstreap_id, c3]
;    gams_xplane_c4 = [gams_xplane_c4, c4]
;    gams_xplane_c5 = [gams_xplane_c5, c5]
;    gams_xplane_edep = [gams_xplane_edep, c6]
;    gams_xplane_c7 = [gams_xplane_c7, c7]
;    
;    filenamedat_gams_yplane = filepath+'G4_GAMS_YPLANE_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_gams_yplane, c1, c2, c3, c4, c5, c6, c7, format='(l,l,l,l,l,d,l)' 
;    gams_yplane_event_id = [gams_yplane_event_id, c1]
;    gams_yplane_plane_id = [gams_yplane_plane_id, c2]
;    gams_yplane_readstreap_id = [gams_yplane_readstreap_id, c3]
;    gams_yplane_c4 = [gams_yplane_c4, c4]
;    gams_yplane_c5 = [gams_yplane_c5, c5]
;    gams_yplane_edep = [gams_yplane_edep, c6]
;    gams_yplane_c7 = [gams_yplane_c7, c7]
;    
;    filenamedat_gams_cal = filepath+'G4_GAMS_CAL_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_gams_cal, c1, c2, c3, c4, c5, c6, format='(l,l,l,l,d,d)' 
;    gams_cal_event_id = [gams_cal_event_id, c1]
;    gams_cal_bar_plane = [gams_cal_bar_plane, c2]
;    gams_cal_bar_id= [gams_cal_bar_id, c3]
;    gams_cal_c4 = [gams_cal_c4, c4]
;    gams_cal_ene_a = [gams_cal_ene_a, c5]
;    gams_cal_ene_b = [gams_cal_ene_b, c6]
;
;    filenamedat_gams_ac = filepath+'G4_GAMS_AC_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'   
;    readcol, filenamedat_gams_ac, c1, c2, c3, c4, format='(l,a,l,d)' 
;    gams_ac_event_id = [gams_ac_event_id, c1]
;    gams_ac_panel = [gams_ac_panel, c2]
;    gams_ac_subpanel = [gams_ac_subpanel, c3]
;    gams_ac_edep = [gams_ac_edep, c4]

    filenamefits_raw = filepath+'G4.RAW.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    print, filenamefits_raw
    struct_raw = mrdfits(filenamefits_raw,$ 
                     1, $
                     structyp = 'raw', $
                     /unsigned)

    rawData_event_id = [rawData_event_id, struct_raw.EVT_ID]
    rawData_tray_id = [rawData_tray_id, struct_raw.TRAY_ID]
    rawData_plane_id = [rawData_plane_id, struct_raw.PLANE_ID]
    rawData_Strip_id_x = [rawData_Strip_id_x, struct_raw.STRIP_ID_X]
    rawData_Strip_id_y = [rawData_Strip_id_y, struct_raw.STRIP_ID_Y]
    rawData_energy_dep = [rawData_energy_dep, struct_raw.E_DEP]
    rawData_ent_x = [rawData_ent_x, struct_raw.X_ENT]
    rawData_ent_y = [rawData_ent_y, struct_raw.Y_ENT]
    rawData_ent_z = [rawData_ent_z, struct_raw.Z_ENT]
    rawData_exit_x = [rawData_exit_x, struct_raw.X_EXIT]
    rawData_exit_y = [rawData_exit_y, struct_raw.Y_EXIT]
    rawData_exit_z = [rawData_exit_z, struct_raw.Z_EXIT]

;    filenamefits_l0 = filepath+'L0.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+'ph.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'  
;    struct_l0 = mrdfits(filenamefits_l0,$ 
;                     1, $
;                     structyp = 'l0', $
;                     /unsigned)
;
;    L0TRACKERGLOBAL_Glob_event_id_test = [L0TRACKERGLOBAL_Glob_event_id_test, struct_l0.EVT_ID]
;    L0TRACKERGLOBAL_Glob_vol_id_test = [L0TRACKERGLOBAL_Glob_vol_id_test, struct_l0.VOLUME_ID]
;    L0TRACKERGLOBAL_Glob_moth_id_test = [L0TRACKERGLOBAL_Glob_moth_id_test, struct_l0.MOTHER_ID]
;    L0TRACKERGLOBAL_Glob_tray_id_test = [L0TRACKERGLOBAL_Glob_tray_id_test, struct_l0.TRAY_ID]
;    L0TRACKERGLOBAL_Glob_plane_id_test = [L0TRACKERGLOBAL_Glob_plane_id_test, struct_l0.PLANE_ID]
;    L0TRACKERGLOBAL_Glob_Si_id_test = [L0TRACKERGLOBAL_Glob_Si_id_test, struct_l0.TRK_FLAG]    
;    L0TRACKERGLOBAL_Glob_Strip_id_test = [L0TRACKERGLOBAL_Glob_Strip_id_test, struct_l0.STRIP_ID]
;    L0TRACKERGLOBAL_Glob_Strip_type_test = [L0TRACKERGLOBAL_Glob_Strip_type_test, struct_l0.STRIP_TYPE]
;    L0TRACKERGLOBAL_Glob_pos_test = [L0TRACKERGLOBAL_Glob_pos_test, struct_l0.POS]
;    L0TRACKERGLOBAL_Glob_zpos_test = [L0TRACKERGLOBAL_Glob_zpos_test, struct_l0.ZPOS]
;    L0TRACKERGLOBAL_Glob_energy_dep_test = [L0TRACKERGLOBAL_Glob_energy_dep_test, struct_l0.E_DEP]

    filenamefits_l0 = filepath+'L0.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    struct_l0 = mrdfits(filenamefits_l0,$ 
                     1, $
                     structyp = 'l0', $
                     /unsigned)

    L0TRACKER_Glob_event_id = [L0TRACKER_Glob_event_id, struct_l0.EVT_ID]
    L0TRACKER_Glob_vol_id = [L0TRACKER_Glob_vol_id, struct_l0.VOLUME_ID]
    L0TRACKER_Glob_moth_id = [L0TRACKER_Glob_moth_id, struct_l0.MOTHER_ID]
    L0TRACKER_Glob_tray_id = [L0TRACKER_Glob_tray_id, struct_l0.TRAY_ID]
    L0TRACKER_Glob_plane_id = [L0TRACKER_Glob_plane_id, struct_l0.PLANE_ID]
    L0TRACKER_Glob_Si_id = [L0TRACKER_Glob_Si_id, struct_l0.TRK_FLAG]    
    L0TRACKER_Glob_Strip_id = [L0TRACKER_Glob_Strip_id, struct_l0.STRIP_ID]    
    L0TRACKER_Glob_pos = [L0TRACKER_Glob_pos, struct_l0.POS]
    L0TRACKER_Glob_zpos = [L0TRACKER_Glob_zpos, struct_l0.ZPOS]
    L0TRACKER_Glob_energy_dep = [L0TRACKER_Glob_energy_dep, struct_l0.E_DEP]

    filenamefits_l05 = filepath+'L0.5.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    struct_l05 = mrdfits(filenamefits_l05,$ 
                     1, $
                     structyp = 'l05', $
                     /unsigned)

    L05TRACKER_Glob_event_id_cluster = [L05TRACKER_Glob_event_id_cluster, struct_l05.EVT_ID]
    L05TRACKER_Glob_tray_id_cluster = [L05TRACKER_Glob_tray_id_cluster, struct_l05.TRAY_ID]
    L05TRACKER_Glob_plane_id_cluster = [L05TRACKER_Glob_plane_id_cluster, struct_l05.PLANE_ID]
    L05TRACKER_Glob_Si_id_cluster = [L05TRACKER_Glob_Si_id_cluster, struct_l05.TRK_FLAG]    
    L05TRACKER_Glob_pos_cluster = [L05TRACKER_Glob_pos_cluster, struct_l05.POS]
    L05TRACKER_Glob_zpos_cluster = [L05TRACKER_Glob_zpos_cluster, struct_l05.ZPOS]
    L05TRACKER_Glob_energy_dep_cluster = [L05TRACKER_Glob_energy_dep_cluster, struct_l05.E_DEP]

    filenamefits_kalman = filepath+'KALMAN.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    struct_kalman = mrdfits(filenamefits_kalman,$ 
                     1, $
                     structyp = 'kalman', $
                     /unsigned)

    KALMAN_eventid = [KALMAN_eventid, struct_kalman.Event_ID]
    KALMAN_theta = [KALMAN_theta, struct_kalman.Theta]
    KALMAN_phi = [KALMAN_phi, struct_kalman.Phi]
    KALMAN_energy = [KALMAN_energy, struct_kalman.ENERGIA]
    ;for jev = 0l, n_elements(struct_kalman.Theta)-1 do begin
      KALMAN_plane_x = [[KALMAN_plane_x], [struct_kalman.PIANI_X]]    
      KALMAN_cluster_x = [[KALMAN_cluster_x], [struct_kalman.Clusters_X]]
      KALMAN_plane_y = [[KALMAN_plane_y], [struct_kalman.PIANI_Y]]
      KALMAN_cluster_y = [[KALMAN_cluster_y], [struct_kalman.Clusters_Y]]
    ;endfor
    filenamefits_sum = filepath+'SUM.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    struct_sum = mrdfits(filenamefits_sum,$ 
                     1, $
                     structyp = 'sum_tracker', $
                     /unsigned)

    SUMTRACKER_Glob_event_id_cluster = [SUMTRACKER_Glob_event_id_cluster, struct_SUM.EVT_ID]
    SUMTRACKER_Glob_tray_id_cluster = [SUMTRACKER_Glob_tray_id_cluster, struct_SUM.TRAY_ID]
    SUMTRACKER_Glob_plane_id_cluster = [SUMTRACKER_Glob_plane_id_cluster, struct_SUM.PLANE_ID]
    SUMTRACKER_Glob_Si_id_cluster = [SUMTRACKER_Glob_Si_id_cluster, struct_SUM.TRK_FLAG]    
    SUMTRACKER_Glob_zpos_cluster = [SUMTRACKER_Glob_zpos_cluster, struct_SUM.ZPOS]
    SUMTRACKER_Glob_energy_dep_cluster = [SUMTRACKER_Glob_energy_dep_cluster, struct_SUM.E_DEP]


    filenamefits_cal = filepath+'G4.CAL.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    print, filenamefits_cal
    struct_cal = mrdfits(filenamefits_cal,$ 
                     1, $
                     structyp = 'cal', $
                     /unsigned)

    calInput_event_id_tot_cal = [calInput_event_id_tot_cal, struct_cal.EVT_ID]
    calInput_bar_id_tot = [calInput_bar_id_tot, struct_cal.BAR_ID]
    calInput_bar_ene_tot = [calInput_bar_ene_tot, struct_cal.BAR_ENERGY]
 
 
    filenamefits_cal_sum = filepath+'SUM.CAL.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    struct_calsum = mrdfits(filenamefits_cal_sum,$ 
                     1, $
                     structyp = 'calsum', $
                     /unsigned)

    calInputSum_event_id_tot_cal = [calInput_event_id_tot_cal, struct_calsum.EVT_ID]
    calInputSum_bar_ene_tot = [calInput_bar_ene_tot, struct_calsum.BAR_ENERGY]
       
;    filenamefits_ac = filepath+'G4.AC.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
;    struct_ac = mrdfits(filenamefits_ac,$ 
;                     1, $
;                     structyp = 'ac', $
;                     /unsigned)
;
;    acInput_event_id_tot_ac = [acInput_event_id_tot_ac, struct_ac.EVT_ID]
;    acInput_AC_panel = [acInput_AC_panel, struct_ac.AC_PANEL]
;    acInput_AC_subpanel = [acInput_AC_subpanel, struct_ac.AC_SUBPANEL]
;    acInput_energy_dep_tot_ac = [acInput_energy_dep_tot_ac, struct_ac.E_DEP]
    
endfor

; -----> ASCII files
;
;raw_kalman_event_id = raw_kalman_event_id[1:*]
;raw_kalman_Si_id = raw_kalman_Si_id[1:*]
;raw_kalman_pos = raw_kalman_pos[1:*]
;raw_kalman_zpos = raw_kalman_zpos[1:*]
;raw_kalman_plane_id = raw_kalman_plane_id[1:*]
;raw_kalman_strip_id = raw_kalman_strip_id[1:*]
;raw_kalman_edep = raw_kalman_edep[1:*]    
;
;openw,lun,filepath+'G4.RAW.KALMAN.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = Silicon layer ID
;; - c2 = x/y pos [cm]
;; - c3 = z pos [cm]
;; - c4 = plane ID
;; - c5 = strip ID
;; - c6 = energy dep [keV]
;
;event_start = -1
;j=0l
;while (1) do begin
;    where_event_eq = where(raw_kalman_event_id EQ raw_kalman_event_id(j))
;    raw_kalman_Si_id_temp = raw_kalman_Si_id(where_event_eq)
;    raw_kalman_pos_temp = raw_kalman_pos(where_event_eq)
;    raw_general_zpos_temp  = raw_general_zpos(where_event_eq)
;    raw_kalman_plane_id_temp  = raw_kalman_plane_id(where_event_eq)
;    raw_kalman_strip_id_temp = raw_kalman_strip_id(where_event_eq)
;    raw_kalman_edep_temp = raw_kalman_edep(where_event_eq)
;
;    printf, lun, '; Event:', raw_kalman_event_id(j)
;    printf, lun, '; ', theta_type, phi_type, ene_type   
;    
;    for r=0l, n_elements(raw_kalman_Si_id_temp)-1 do begin
;          printf, lun, raw_kalman_Si_id_temp(r), raw_kalman_pos_temp(r), raw_general_zpos_temp(r), raw_kalman_plane_id_temp(r), raw_kalman_strip_id_temp(r), raw_kalman_edep_temp(r), format='(I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,F10.5)'
;    endfor
;    N_event_eq = n_elements(where_event_eq)
;    if where_event_eq(N_event_eq-1) LT (n_elements(raw_kalman_event_id)-1) then begin
;      j = where_event_eq(N_event_eq-1)+1
;    endif else break
;endwhile
;
;Free_lun, lun
;
;raw_general_event_id = raw_general_event_id[1:*]
;raw_general_Si_id = raw_general_Si_id[1:*]
;raw_general_pos = raw_general_pos[1:*]
;raw_general_zpos = raw_general_zpos[1:*]
;raw_general_tray_id = raw_general_tray_id[1:*]
;raw_general_plane_id = raw_general_plane_id[1:*]
;raw_general_strip_id = raw_general_strip_id[1:*]
;raw_general_edep = raw_general_edep[1:*]    
;
;openw,lun,filepath+'G4.RAW.GENERAL.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = event ID
;; - c2 = Silicon layer ID
;; - c3 = x/y pos [cm]
;; - c4 = z pos [cm]
;; - c5 = tray ID
;; - c6 = plane ID
;; - c7 = strip ID 
;; - c8 = energy dep [keV]    
;
;event_start = -1
;j=0l
;while (1) do begin
;    where_event_eq = where(raw_general_event_id EQ raw_general_event_id(j))
;    raw_general_Si_id_temp = raw_general_Si_id(where_event_eq)
;    raw_general_pos_temp = raw_general_pos(where_event_eq)
;    raw_general_zpos_temp  = raw_general_zpos(where_event_eq)
;    raw_general_tray_id_temp  = raw_general_tray_id(where_event_eq)
;    raw_general_plane_id_temp = raw_general_plane_id(where_event_eq)    
;    raw_general_strip_id_temp = raw_general_strip_id(where_event_eq)
;    raw_general_edep_temp = raw_general_edep(where_event_eq)
;
;    for r=0l, n_elements(raw_general_Si_id_temp)-1 do begin
;         printf, lun, raw_general_event_id(j), raw_general_Si_id_temp(r), raw_general_pos_temp(r), raw_general_zpos_temp(r), raw_general_tray_id_temp(r), raw_general_plane_id_temp(r), raw_general_strip_id_temp(r), raw_general_edep_temp(r), format='(I5,2x,I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,I5,2x,F10.5)'
;    endfor
;    
;    N_event_eq = n_elements(where_event_eq)
;    if where_event_eq(N_event_eq-1) LT (n_elements(raw_general_event_id)-1) then begin
;      j = where_event_eq(N_event_eq-1)+1
;    endif else break
;endwhile
;
;Free_lun, lun
;
;
;digi_kalman_event_id = digi_kalman_event_id[1:*]
;digi_kalman_Si_id = digi_kalman_Si_id[1:*]
;digi_kalman_pos = digi_kalman_pos[1:*]
;digi_kalman_zpos = digi_kalman_zpos[1:*]
;digi_kalman_plane_id = digi_kalman_plane_id[1:*]
;digi_kalman_strip_id = digi_kalman_strip_id[1:*]
;digi_kalman_edep = digi_kalman_edep[1:*]    
;
;openw,lun,filepath+'G4.DIGI.KALMAN.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = Silicon layer ID
;; - c2 = x/y pos [cm]
;; - c3 = z pos [cm]
;; - c4 = plane ID
;; - c5 = strip ID
;; - c6 = energy dep [keV]
;
;event_start = -1
;j=0l
;while (1) do begin
;    where_event_eq = where(digi_kalman_event_id EQ digi_kalman_event_id(j))
;    digi_kalman_Si_id_temp = digi_kalman_Si_id(where_event_eq)
;    digi_kalman_pos_temp = digi_kalman_pos(where_event_eq)
;    digi_general_zpos_temp  = digi_general_zpos(where_event_eq)
;    digi_kalman_plane_id_temp  = digi_kalman_plane_id(where_event_eq)
;    digi_kalman_strip_id_temp = digi_kalman_strip_id(where_event_eq)
;    digi_kalman_edep_temp = digi_kalman_edep(where_event_eq)
;
;    printf, lun, '; Event:', digi_kalman_event_id(j)
;    printf, lun, '; ', theta_type, phi_type, ene_type   
;    
;    for r=0l, n_elements(digi_kalman_Si_id_temp)-1 do begin
;          printf, lun, digi_kalman_Si_id_temp(r), digi_kalman_pos_temp(r), digi_general_zpos_temp(r), digi_kalman_plane_id_temp(r), digi_kalman_strip_id_temp(r), digi_kalman_edep_temp(r), format='(I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,F10.5)'
;    endfor
;    N_event_eq = n_elements(where_event_eq)
;    if where_event_eq(N_event_eq-1) LT (n_elements(digi_kalman_event_id)-1) then begin
;      j = where_event_eq(N_event_eq-1)+1
;    endif else break
;endwhile
;
;Free_lun, lun
;
;digi_general_event_id = digi_general_event_id[1:*]
;digi_general_Si_id = digi_general_Si_id[1:*]
;digi_general_pos = digi_general_pos[1:*]
;digi_general_zpos = digi_general_zpos[1:*]
;digi_general_tray_id = digi_general_tray_id[1:*]
;digi_general_plane_id = digi_general_plane_id[1:*]
;digi_general_strip_id = digi_general_strip_id[1:*]
;digi_general_edep = digi_general_edep[1:*]    
;
;openw,lun,filepath+'G4.DIGI.GENERAL.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = event ID
;; - c2 = Silicon layer ID
;; - c3 = x/y pos [cm]
;; - c4 = z pos [cm]
;; - c5 = tray ID
;; - c6 = plane ID
;; - c7 = strip ID 
;; - c8 = energy dep [keV]    
;
;event_start = -1
;j=0l
;while (1) do begin
;    where_event_eq = where(digi_general_event_id EQ digi_general_event_id(j))
;    digi_general_Si_id_temp = digi_general_Si_id(where_event_eq)
;    digi_general_pos_temp = digi_general_pos(where_event_eq)
;    digi_general_zpos_temp  = digi_general_zpos(where_event_eq)
;    digi_general_tray_id_temp  = digi_general_tray_id(where_event_eq)
;    digi_general_plane_id_temp = digi_general_plane_id(where_event_eq)    
;    digi_general_strip_id_temp = digi_general_strip_id(where_event_eq)
;    digi_general_edep_temp = digi_general_edep(where_event_eq)
;
;    for r=0l, n_elements(digi_general_Si_id_temp)-1 do begin
;         printf, lun, digi_general_event_id(j), digi_general_Si_id_temp(r), digi_general_pos_temp(r), digi_general_zpos_temp(r), digi_general_tray_id_temp(r), digi_general_plane_id_temp(r), digi_general_strip_id_temp(r), digi_general_edep_temp(r), format='(I5,2x,I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,I5,2x,F10.5)'
;    endfor
;    
;    N_event_eq = n_elements(where_event_eq)
;    if where_event_eq(N_event_eq-1) LT (n_elements(digi_general_event_id)-1) then begin
;      j = where_event_eq(N_event_eq-1)+1
;    endif else break
;endwhile
;
;Free_lun, lun
;
;gams_xplane_event_id = gams_xplane_event_id[1:*]
;gams_xplane_plane_id = gams_xplane_plane_id[1:*]
;gams_xplane_readstreap_id = gams_xplane_readstreap_id[1:*]
;gams_xplane_c4 = gams_xplane_c4[1:*]
;gams_xplane_c5 = gams_xplane_c5[1:*]
;gams_xplane_edep = gams_xplane_edep[1:*]
;gams_xplane_c7 = gams_xplane_c7[1:*]
;
;
;openw,lun,filepath+'G4_GAMS_XPLANE_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = event ID
;; - c2 = plane ID
;; - c3 = readout strip ID
;; - c4 = -999
;; - c5 = -999
;; - c6 = energy dep in MIP
;; - c7 = -999    event_start = -1
;j=0l
;while (1) do begin
;    where_event_eq = where(gams_xplane_event_id EQ gams_xplane_event_id(j))
;    gams_xplane_plane_id_temp = gams_xplane_plane_id(where_event_eq)
;    gams_xplane_readstreap_id_temp = gams_xplane_readstreap_id(where_event_eq)
;    gams_xplane_c4_temp  = gams_xplane_c4(where_event_eq)
;    gams_xplane_c5_temp  = gams_xplane_c5(where_event_eq)
;    gams_xplane_edep_temp = gams_xplane_edep(where_event_eq)    
;    gams_xplane_c7_temp = gams_xplane_c7(where_event_eq)    
;    
;    for r=0l, n_elements(gams_xplane_plane_id_temp)-1 do begin
;        printf, lun, gams_xplane_event_id(j), gams_xplane_plane_id_temp(r), gams_xplane_readstreap_id_temp(r), gams_xplane_c4_temp(r), gams_xplane_c5_temp(r), gams_xplane_edep_temp(r), gams_xplane_c7_temp(r), format='(I5,I5,I5,I5,I5,F10.5,I5)'        
;    endfor
;
;    N_event_eq = n_elements(where_event_eq)
;    if where_event_eq(N_event_eq-1) LT (n_elements(gams_xplane_event_id)-1) then begin
;      j = where_event_eq(N_event_eq-1)+1
;    endif else break
;endwhile
;
;Free_lun, lun
;
;spawn,'cp '+filepath+'G4_GAMS_XPLANE_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat '+filepath+'stripx.dat'
;
;gams_yplane_event_id = gams_yplane_event_id[1:*]
;gams_yplane_plane_id = gams_yplane_plane_id[1:*]
;gams_yplane_readstreap_id = gams_yplane_readstreap_id[1:*]
;gams_yplane_c4 = gams_yplane_c4[1:*]
;gams_yplane_c5 = gams_yplane_c5[1:*]
;gams_yplane_edep = gams_yplane_edep[1:*]
;gams_yplane_c7 = gams_yplane_c7[1:*]
;
;openw,lun,filepath+'G4_GAMS_YPLANE_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = event ID
;; - c2 = plane ID
;; - c3 = readout strip ID
;; - c4 = -999
;; - c5 = -999
;; - c6 = energy dep in MIP
;; - c7 = -999    event_start = -1
;j=0l
;while (1) do begin
;    where_event_eq = where(gams_yplane_event_id EQ gams_yplane_event_id(j))
;    gams_yplane_plane_id_temp = gams_yplane_plane_id(where_event_eq)
;    gams_yplane_readstreap_id_temp = gams_yplane_readstreap_id(where_event_eq)
;    gams_yplane_c4_temp  = gams_yplane_c4(where_event_eq)
;    gams_yplane_c5_temp  = gams_yplane_c5(where_event_eq)
;    gams_yplane_edep_temp = gams_yplane_edep(where_event_eq)    
;    gams_yplane_c7_temp = gams_yplane_c7(where_event_eq)    
;    
;    for r=0l, n_elements(gams_yplane_plane_id_temp)-1 do begin
;        printf, lun, gams_yplane_event_id(j), gams_yplane_plane_id_temp(r), gams_yplane_readstreap_id_temp(r), gams_yplane_c4_temp(r), gams_yplane_c5_temp(r), gams_yplane_edep_temp(r), gams_yplane_c7_temp(r), format='(I5,I5,I5,I5,I5,F10.5,I5)'        
;    endfor
;
;    N_event_eq = n_elements(where_event_eq)
;    if where_event_eq(N_event_eq-1) LT (n_elements(gams_yplane_event_id)-1) then begin
;      j = where_event_eq(N_event_eq-1)+1
;    endif else break
;endwhile
;
;Free_lun, lun
;spawn,'cp '+filepath+'G4_GAMS_YPLANE_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat '+filepath+'stripy.dat'
;
;
;gams_cal_event_id = gams_cal_event_id[1:*]
;gams_cal_bar_plane = gams_cal_bar_plane[1:*]
;gams_cal_bar_id = gams_cal_bar_id[1:*]
;gams_cal_c4 = gams_cal_c4[1:*]
;gams_cal_ene_a = gams_cal_ene_a[1:*]
;gams_cal_ene_b = gams_cal_ene_b[1:*]
;
;    
;openw,lun,filepath+'G4_GAMS_CAL_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = event ID
;; - c2 = bar plane 
;; - c3 = bar_id
;; - c4 = 0
;; - c5 = energy A
;; - c6 = energy B
;
;j=0l
;while (1) do begin
;    printf, lun, gams_cal_event_id(j), gams_cal_bar_plane(j), gams_cal_bar_id(j), gams_cal_c4(j), gams_cal_ene_a(j),gams_cal_ene_b(j)
;
;    if (j LT (n_elements(gams_cal_event_id)-1)) then begin
;      j = j+1
;    endif else break
;endwhile
;
;Free_lun, lun
;spawn,'cp '+filepath+'G4_GAMS_CAL_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat '+filepath+'calo.dat'
;
;
;gams_ac_event_id = gams_ac_event_id[1:*]
;gams_ac_panel = gams_ac_panel[1:*]
;gams_ac_subpanel = gams_ac_subpanel[1:*]
;gams_ac_edep = gams_ac_edep[1:*]
;
;openw,lun,filepath+'G4_GAMS_AC_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat',/get_lun
;; ASCII Columns:
;; - c1 = event ID
;; - c2 = AC panel
;; - c3 = AC subpanel
;; - c4 = energy deposit
;
;j=0l
;while (1) do begin
;    printf, lun, gams_ac_event_id(j),gams_ac_panel(j), gams_ac_subpanel(j), gams_ac_edep(j), format='(I,2x,A,2x,I,2x,F20.15)'
;
;    if (j LT (n_elements(gams_ac_event_id)-1)) then begin
;      j = j+1
;    endif else break
;endwhile
;
;Free_lun, lun
;spawn,'cp '+filepath+'G4_GAMS_AC_AGILE'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.all.dat '+filepath+'ac.dat'
;


; -----> FITS files
; G4.RAW.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
rawData_event_id = rawData_event_id[1:*]
rawData_tray_id =  rawData_tray_id[1:*]
rawData_plane_id =  rawData_plane_id[1:*]
rawData_Strip_id_x =  rawData_Strip_id_x[1:*]
rawData_Strip_id_y =  rawData_Strip_id_y[1:*]
rawData_energy_dep =  rawData_energy_dep[1:*]
rawData_ent_x =  rawData_ent_x[1:*]
rawData_ent_y =  rawData_ent_y[1:*]
rawData_ent_z =  rawData_ent_z[1:*]
rawData_exit_x =  rawData_exit_x[1:*]
rawData_exit_y =  rawData_exit_y[1:*]
rawData_exit_z = rawData_exit_z[1:*]

; L0.AGILE<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
;L0TRACKERGLOBAL_Glob_event_id_test = L0TRACKERGLOBAL_Glob_event_id_test[1:*]
;L0TRACKERGLOBAL_Glob_vol_id_test = L0TRACKERGLOBAL_Glob_vol_id_test[1:*]
;L0TRACKERGLOBAL_Glob_moth_id_test = L0TRACKERGLOBAL_Glob_moth_id_test[1:*]
;L0TRACKERGLOBAL_Glob_tray_id_test = L0TRACKERGLOBAL_Glob_tray_id_test[1:*]
;L0TRACKERGLOBAL_Glob_plane_id_test = L0TRACKERGLOBAL_Glob_plane_id_test[1:*]
;L0TRACKERGLOBAL_Glob_Si_id_test = L0TRACKERGLOBAL_Glob_Si_id_test[1:*]
;L0TRACKERGLOBAL_Glob_Strip_id_test = L0TRACKERGLOBAL_Glob_Strip_id_test[1:*]
;L0TRACKERGLOBAL_Glob_Strip_type_test = L0TRACKERGLOBAL_Glob_Strip_type_test[1:*]
;L0TRACKERGLOBAL_Glob_pos_test = L0TRACKERGLOBAL_Glob_pos_test[1:*]
;L0TRACKERGLOBAL_Glob_zpos_test = L0TRACKERGLOBAL_Glob_zpos_test[1:*]
;L0TRACKERGLOBAL_Glob_energy_dep_test = L0TRACKERGLOBAL_Glob_energy_dep_test[1:*]


L0TRACKER_Glob_event_id = L0TRACKER_Glob_event_id[1:*]
L0TRACKER_Glob_vol_id = L0TRACKER_Glob_vol_id[1:*]
L0TRACKER_Glob_moth_id = L0TRACKER_Glob_moth_id[1:*]
L0TRACKER_Glob_tray_id = L0TRACKER_Glob_tray_id[1:*]
L0TRACKER_Glob_plane_id = L0TRACKER_Glob_plane_id[1:*]
L0TRACKER_Glob_Si_id = L0TRACKER_Glob_Si_id[1:*]
L0TRACKER_Glob_Strip_id = L0TRACKER_Glob_Strip_id[1:*]
L0TRACKER_Glob_pos = L0TRACKER_Glob_pos[1:*]
L0TRACKER_Glob_zpos = L0TRACKER_Glob_zpos[1:*]
L0TRACKER_Glob_energy_dep = L0TRACKER_Glob_energy_dep[1:*]

; L0.5.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
L05TRACKER_Glob_event_id_cluster = L05TRACKER_Glob_event_id_cluster[1:*]
L05TRACKER_Glob_tray_id_cluster = L05TRACKER_Glob_tray_id_cluster[1:*]
L05TRACKER_Glob_plane_id_cluster = L05TRACKER_Glob_plane_id_cluster[1:*]
L05TRACKER_Glob_Si_id_cluster = L05TRACKER_Glob_Si_id_cluster[1:*]
L05TRACKER_Glob_pos_cluster = L05TRACKER_Glob_pos_cluster[1:*]
L05TRACKER_Glob_zpos_cluster = L05TRACKER_Glob_zpos_cluster[1:*]
L05TRACKER_Glob_energy_dep_cluster = L05TRACKER_Glob_energy_dep_cluster[1:*]

; KALMAN.TRACKER.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
KALMAN_eventid = KALMAN_eventid[1:*]
KALMAN_theta = KALMAN_theta[1:*]
KALMAN_phi = KALMAN_phi[1:*]
KALMAN_energy = KALMAN_energy[1:*]
KALMAN_plane_x = KALMAN_plane_x[*, 1:*]  
KALMAN_cluster_x = KALMAN_cluster_x[*, 1:*]
KALMAN_plane_y = KALMAN_plane_y[*, 1:*]
KALMAN_cluster_y = KALMAN_cluster_y[*, 1:*]

; SUM.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
SUMTRACKER_Glob_event_id_cluster = SUMTRACKER_Glob_event_id_cluster[1:*]
SUMTRACKER_Glob_tray_id_cluster = SUMTRACKER_Glob_tray_id_cluster[1:*]
SUMTRACKER_Glob_plane_id_cluster = SUMTRACKER_Glob_plane_id_cluster[1:*]
SUMTRACKER_Glob_Si_id_cluster = SUMTRACKER_Glob_Si_id_cluster[1:*]
SUMTRACKER_Glob_zpos_cluster = SUMTRACKER_Glob_zpos_cluster[1:*]
SUMTRACKER_Glob_energy_dep_cluster = SUMTRACKER_Glob_energy_dep_cluster[1:*]

; G4.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits 
calInput_event_id_tot_cal = calInput_event_id_tot_cal[1:*]
calInput_bar_id_tot = calInput_bar_id_tot[1:*]
calInput_bar_ene_tot = calInput_bar_ene_tot[1:*]

; SUM.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits 
calInputSum_event_id_tot_cal = calInputSum_event_id_tot_cal[1:*]
calInputSum_bar_ene_tot = calInputSum_bar_ene_tot[1:*]

; G4.AC.AGILE<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
;acInput_event_id_tot_ac = acInput_event_id_tot_ac[1:*]
;acInput_AC_panel = acInput_AC_panel[1:*]
;acInput_AC_subpanel = acInput_AC_subpanel[1:*]
;acInput_energy_dep_tot_ac = acInput_energy_dep_tot_ac[1:*]


CREATE_STRUCT, rawData, 'rawData', ['EVT_ID', 'TRAY_ID', 'PLANE_ID', 'STRIP_ID_X', 'STRIP_ID_Y', 'E_DEP', 'X_ENT', 'Y_ENT', 'Z_ENT', 'X_EXIT', 'Y_EXIT', 'Z_EXIT'], $
'I,I,I,I,I,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5', DIMEN = n_elements(rawData_event_id)
rawData.EVT_ID = rawData_event_id
rawData.TRAY_ID = rawData_tray_id
rawData.PLANE_ID = rawData_plane_id
rawData.STRIP_ID_X = rawData_Strip_id_x
rawData.STRIP_ID_Y = rawData_Strip_id_y
rawData.E_DEP = rawData_energy_dep
rawData.X_ENT = rawData_ent_x
rawData.Y_ENT = rawData_ent_y
rawData.Z_ENT = rawData_ent_z
rawData.X_EXIT = rawData_exit_x
rawData.Y_EXIT = rawData_exit_y
rawData.Z_EXIT = rawData_exit_z


hdr_rawData = ['COMMENT  ASTROGAM '+astrogam_version+' Geant4 simulation', $
               'N_in     = '+strtrim(string(N_in),1), $
               'Energy     = '+ene_type, $
               'Theta     = '+strtrim(string(theta_type),1), $
               'Phi     = '+strtrim(string(phi_type),1), $
               'Position unit = cm', $
               'Energy unit = keV']

MWRFITS, rawData, filepath+'G4.RAW.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.fits', hdr_rawData, /create

;
;CREATE_STRUCT, L0TRACKERGLOBAL, 'GLOBALTRACKERL0', ['EVT_ID', 'VOLUME_ID', 'MOTHER_ID', 'TRAY_ID', 'PLANE_ID','TRK_FLAG', 'STRIP_ID', 'STRIP_TYPE', 'POS', 'ZPOS','E_DEP'], 'I,J,J,I,I,I,J,J,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(L0TRACKERGLOBAL_Glob_event_id_test)
;L0TRACKERGLOBAL.EVT_ID = L0TRACKERGLOBAL_Glob_event_id_test
;L0TRACKERGLOBAL.VOLUME_ID = L0TRACKERGLOBAL_Glob_vol_id_test
;L0TRACKERGLOBAL.MOTHER_ID = L0TRACKERGLOBAL_Glob_moth_id_test
;L0TRACKERGLOBAL.TRAY_ID = L0TRACKERGLOBAL_Glob_tray_id_test
;L0TRACKERGLOBAL.PLANE_ID = L0TRACKERGLOBAL_Glob_plane_id_test
;L0TRACKERGLOBAL.TRK_FLAG = L0TRACKERGLOBAL_Glob_Si_id_test
;L0TRACKERGLOBAL.STRIP_ID = L0TRACKERGLOBAL_Glob_Strip_id_test
;L0TRACKERGLOBAL.STRIP_TYPE = L0TRACKERGLOBAL_Glob_Strip_type_test
;L0TRACKERGLOBAL.POS = L0TRACKERGLOBAL_Glob_pos_test
;L0TRACKERGLOBAL.ZPOS = L0TRACKERGLOBAL_Glob_zpos_test
;L0TRACKERGLOBAL.E_DEP = L0TRACKERGLOBAL_Glob_energy_dep_test
;
;HDR_L0GLOBAL = ['Creator          = Valentina Fioretti', $
;          'BoGEMMS release  = AGILE '+astrogam_version, $
;          'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
;          'ENERGY           = '+ene_type+'   /Simulated input energy', $
;          'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
;          'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
;          'ENERGY UNIT      = KEV']
;
;
;MWRFITS, L0TRACKERGLOBAL, filepath+'L0.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+'ph.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.all.fits', HDR_L0GLOBAL, /CREATE
;

CREATE_STRUCT, L0TRACKER, 'TRACKERL0', ['EVT_ID', 'VOLUME_ID', 'MOTHER_ID', 'TRAY_ID','PLANE_ID','TRK_FLAG', 'STRIP_ID', 'POS', 'ZPOS','E_DEP'], 'J,J,J,I,I,I,J,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(L0TRACKER_Glob_event_id)
L0TRACKER.EVT_ID = L0TRACKER_Glob_event_id
L0TRACKER.VOLUME_ID = L0TRACKER_Glob_vol_id
L0TRACKER.MOTHER_ID = L0TRACKER_Glob_moth_id
L0TRACKER.TRAY_ID = L0TRACKER_Glob_tray_id
L0TRACKER.PLANE_ID = L0TRACKER_Glob_plane_id
L0TRACKER.TRK_FLAG = L0TRACKER_Glob_Si_id
L0TRACKER.STRIP_ID = L0TRACKER_Glob_Strip_id
L0TRACKER.POS = L0TRACKER_Glob_pos
L0TRACKER.ZPOS = L0TRACKER_Glob_zpos
L0TRACKER.E_DEP = L0TRACKER_Glob_energy_dep

HDR_L0 = ['Creator          = Valentina Fioretti', $
          'THELSim release  = ASTROGAM '+astrogam_version, $
          'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
          'ENERGY           = '+ene_type+'   /Simulated input energy', $
          'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
          'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
          'ENERGY UNIT      = KEV']


MWRFITS, L0TRACKER, filepath+'L0.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.all.fits', HDR_L0, /CREATE


CREATE_STRUCT, L05TRACKER, 'TRACKERL05', ['EVT_ID', 'TRAY_ID','PLANE_ID','TRK_FLAG', 'POS', 'ZPOS','E_DEP'], 'J,I,I,I,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(L05TRACKER_Glob_event_id_cluster)
L05TRACKER.EVT_ID = L05TRACKER_Glob_event_id_cluster
L05TRACKER.TRAY_ID = L05TRACKER_Glob_tray_id_cluster
L05TRACKER.PLANE_ID = L05TRACKER_Glob_plane_id_cluster
L05TRACKER.TRK_FLAG = L05TRACKER_Glob_Si_id_cluster
L05TRACKER.POS = L05TRACKER_Glob_pos_cluster
L05TRACKER.ZPOS = L05TRACKER_Glob_zpos_cluster
L05TRACKER.E_DEP = L05TRACKER_Glob_energy_dep_cluster

HDR_L05 = ['Creator          = Valentina Fioretti', $
          'THELSim release  = ASTROGAM '+astrogam_version, $
          'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
          'ENERGY           = '+ene_type+'   /Simulated input energy', $
          'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
          'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
          'ENERGY UNIT      = KEV']


MWRFITS, L05TRACKER, filepath+'L0.5.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.all.fits', HDR_L05, /CREATE

string_dim = string(default_max_cols) 
CREATE_STRUCT, KALMANTRACKER, 'TRACKERKALMAN', ['Event_ID', 'Theta', 'Phi','Energia','Piani_X','Clusters_X', 'Piani_Y', 'Clusters_Y'],'J,F,F,F,I('+string_dim+'),D('+string_dim+'),I('+string_dim+'),D('+string_dim+')', DIMEN = N_ELEMENTS(KALMAN_theta)
KALMANTRACKER.Event_id = KALMAN_eventid
KALMANTRACKER.Theta = KALMAN_theta
KALMANTRACKER.Phi = KALMAN_phi
KALMANTRACKER.Energia = KALMAN_energy
KALMANTRACKER.Piani_X = KALMAN_plane_x
KALMANTRACKER.Clusters_X = KALMAN_cluster_x
KALMANTRACKER.Piani_Y = KALMAN_plane_y
KALMANTRACKER.Clusters_Y = KALMAN_cluster_y


HDR_KALMAN = ['Creator          = Valentina Fioretti', $
          'THELSim release  = ASTROGAM '+astrogam_version, $
          'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
          'ENERGY           = '+ene_type+'   /Simulated input energy', $
          'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
          'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle']


MWRFITS, KALMANTRACKER, filepath+'KALMAN.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.all.fits', HDR_KALMAN, /CREATE



CREATE_STRUCT, SUMTRACKER, 'TRACKERSUM', ['EVT_ID', 'TRAY_ID','PLANE_ID','TRK_FLAG','ZPOS','E_DEP'], 'J,I,I,I,F20.5,F20.5', DIMEN = N_ELEMENTS(SUMTRACKER_Glob_event_id_cluster)
SUMTRACKER.EVT_ID = SUMTRACKER_Glob_event_id_cluster
SUMTRACKER.TRAY_ID = SUMTRACKER_Glob_tray_id_cluster
SUMTRACKER.PLANE_ID = SUMTRACKER_Glob_plane_id_cluster
SUMTRACKER.TRK_FLAG = SUMTRACKER_Glob_Si_id_cluster
SUMTRACKER.ZPOS = SUMTRACKER_Glob_zpos_cluster
SUMTRACKER.E_DEP = SUMTRACKER_Glob_energy_dep_cluster

HDR_SUM = ['Creator          = Valentina Fioretti', $
          'THELSim release  = ASTROGAM '+astrogam_version, $
          'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
          'ENERGY           = '+ene_type+'   /Simulated input energy', $
          'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
          'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
          'ENERGY UNIT      = KEV']


MWRFITS, SUMTRACKER, filepath+'SUM.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.all.fits', HDR_SUM, /CREATE

CREATE_STRUCT, calInput, 'input_cal_dhsim', ['EVT_ID','BAR_ID', 'BAR_ENERGY'], $
'I,I,F20.15', DIMEN = n_elements(calInput_event_id_tot_cal)
calInput.EVT_ID = calInput_event_id_tot_cal
calInput.BAR_ID = calInput_bar_id_tot
calInput.BAR_ENERGY = calInput_bar_ene_tot


hdr_calInput = ['COMMENT  ASTROGAM V2.0 Geant4 simulation', $
               'N_in     = '+strtrim(string(N_in),1), $
               'Energy     = '+ene_type, $
               'Theta     = '+strtrim(string(theta_type),1), $
               'Phi     = '+strtrim(string(phi_type),1), $
               'Energy unit = GeV']

MWRFITS, calInput, filepath+'G4.CAL.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.fits', hdr_calInput, /create

CREATE_STRUCT, calInputSum, 'input_cal', ['EVT_ID','BAR_ENERGY'], $
'I,F20.15', DIMEN = n_elements(calInputSum_event_id_tot_cal)
calInputSum.EVT_ID = calInputSum_event_id_tot_cal
calInputSum.BAR_ENERGY = calInputSum_bar_ene_tot


hdr_calInputSum = ['COMMENT  ASTROGAM V2.0 Geant4 simulation', $
               'N_in     = '+strtrim(string(N_in),1), $
               'Energy     = '+ene_type, $
               'Theta     = '+strtrim(string(theta_type),1), $
               'Phi     = '+strtrim(string(phi_type),1), $
               'Energy unit = GeV']

MWRFITS, calInputSum, filepath+'SUM.CAL.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.fits', hdr_calInputSum, /create

;CREATE_STRUCT, acInput, 'input_ac_dhsim', ['EVT_ID', 'AC_PANEL', 'AC_SUBPANEL', 'E_DEP'], $
;'I,A,I,F20.15', DIMEN = n_elements(acInput_event_id_tot_ac)
;acInput.EVT_ID = acInput_event_id_tot_ac
;acInput.AC_PANEL = acInput_AC_panel
;acInput.AC_SUBPANEL = acInput_AC_subpanel
;acInput.E_DEP = acInput_energy_dep_tot_ac
;
;
;hdr_acInput = ['COMMENT  AGILE V2.0 Geant4 simulation', $
;               'N_in     = '+strtrim(string(N_in),1), $
;               'Energy     = '+ene_type, $
;               'Theta     = '+strtrim(string(theta_type),1), $
;               'Phi     = '+strtrim(string(phi_type),1), $
;               'Energy unit = GeV']
;
;MWRFITS, acInput, filepath+'G4.AC.AGILE'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.fits', hdr_acInput, /create




end
