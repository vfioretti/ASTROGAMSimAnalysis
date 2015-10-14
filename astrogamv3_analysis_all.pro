; astrogamv3_analysis_all.pro - Description
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
; astrogamv3_analysis_all
; ---------------------------------------------------------------------------------


pro astrogamv3_analysis_all

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
cal_flag = 0
passive_flag = 0
energy_thresh = 0

read, astrogam_version, PROMPT='% - Enter ASTROGAM release (e.g. V1.4):'
read, sim_type, PROMPT='% - Enter simulation type [0 = Mono, 1 = Range, 2 = Chen, 3: Vela, 4: Crab, 4: G400]:'
read, n_files, PROMPT='% - Enter number of input files:'
read, py_list, PROMPT='% - Enter the Physics List [0 = QGSP_BERT_EMV, 100 = ARGO, 300 = FERMI, 400 = ASTROMEV]:'
read, N_in, PROMPT='% - Enter the number of emitted particles:'
read, part_type, PROMPT='% - Enter the particle type [ph = photons, mu = muons, g = geantino, p = proton]:'
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
  sim_name = 'RANGE'
endif
if (sim_type EQ 2) then begin
   sim_name = 'CHEN'
endif
if (sim_type EQ 3) then begin
   sim_name = 'VELA'
endif
if (sim_type EQ 4) then begin
   sim_name = 'CRAB'
endif
if (sim_type EQ 5) then begin
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
read, cal_flag, PROMPT='% - Is Cal present? [0 = false, 1 = true]:'
read, ac_flag, PROMPT='% - Is AC present? [0 = false, 1 = true]:'

if ((cal_flag EQ 0) AND (ac_flag EQ 0))  then dir_cal = '/OnlyTracker'
if ((cal_flag EQ 1) AND (ac_flag EQ 0)) then dir_cal = '/noAC'
if ((cal_flag EQ 0) AND (ac_flag EQ 1)) then dir_cal = '/noCAL'
if ((cal_flag EQ 1) AND (ac_flag EQ 1)) then dir_cal = ''

read, passive_flag, PROMPT='% - Is Passive present? [0 = false, 1 = true]:'
if (passive_flag EQ 0) then dir_passive = ''
if (passive_flag EQ 1) then dir_passive = '/WithPassive'

read, energy_thresh, PROMPT='% - Enter energy threshold [keV]:'

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

if (isStrip) then begin
   
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
  
  ; KALMAN.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
  default_max_cols = 1000
  KALMANL1_eventid = float(-1l)
  KALMANL1_theta = float(-1l)
  KALMANL1_phi = float(-1l)
  KALMANL1_energy = float(-1l)
  KALMANL1_plane_x = MAKE_ARRAY(default_max_cols, 1, /INTEGER, VALUE = 0)
  KALMANL1_cluster_x = MAKE_ARRAY(default_max_cols, 1, /DOUBLE, VALUE = 0)
  KALMANL1_plane_y = MAKE_ARRAY(default_max_cols, 1, /INTEGER, VALUE = 0)
  KALMANL1_cluster_y = MAKE_ARRAY(default_max_cols, 1, /DOUBLE, VALUE = 0)
  
  ; SUM.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
  SUMTRACKER_Glob_event_id_cluster = -1l
  SUMTRACKER_Glob_tray_id_cluster = -1l
  SUMTRACKER_Glob_plane_id_cluster = -1l
  SUMTRACKER_Glob_Si_id_cluster = -1l
  SUMTRACKER_Glob_zpos_cluster = -1.
  SUMTRACKER_Glob_energy_dep_cluster = -1.
  
  ; - AA_STRIP_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat
  ; ASCII Columns:
  ; - c1 = event ID
  ; - c2 = theta input
  ; - c3 = phi input
  ; - c4 = energy input
  ; - c5 = plane ID
  ; - c6 = Pos Z
  ; - c7 = X/Y flag (X = 0, Y = 1)
  ; - c8 = Strip ID
  ; - c9 = strip position (reference system center at the Silicon layer center)
  ; - c10 = energy deposition (keV)
  
  aa_strip_event_id = -1l
  aa_strip_theta_in = -1l
  aa_strip_phi_in = -1l
  aa_strip_ene_in = -1l
  aa_strip_plane_id = -1l
  aa_strip_zpos = -1.
  aa_strip_si_id = -1l
  aa_strip_strip_id = -1l
  aa_strip_pos = -1.
  aa_strip_edep = -1.
  
  ; - AA_KALMAN_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat
  ; ASCII Columns:
  ; - c1 = event ID
  ; - c2 = theta input
  ; - c3 = phi input
  ; - c4 = energy input
  ; - c5 = plane ID
  ; - c6 = Pos Z
  ; - c7 = X/Y flag (X = 0, Y = 1)
  ; - c8 = Cluster position (reference system center at the Silicon layer center)
  ; - c9 = energy deposition (keV)
  ; - c10 = number of strips composing the cluster
  
  aa_kalman_event_id = -1l
  aa_kalman_theta_in = -1l
  aa_kalman_phi_in = -1l
  aa_kalman_ene_in = -1l
  aa_kalman_plane_id = -1l
  aa_kalman_zpos = -1.
  aa_kalman_si_id = -1l
  aa_kalman_pos = -1.
  aa_kalman_edep = -1.
  aa_kalman_strip_number = -1.
  
endif else begin
  
   ; - AA_FAKE_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat
  ; ASCII Columns:
  ; - c1 = event ID
  ; - c2 = theta input
  ; - c3 = phi input
  ; - c4 = energy input
  ; - c5 = plane ID
  ; - c6 = Pos Z
  ; - c7 = X/Y flag (X = 0, Y = 1)
  ; - c8 = Cluster position (reference system center at the Silicon layer center)
  ; - c9 = energy deposition (keV)
  ; - c10 = number of strips composing the cluster
  
  aa_fake_event_id = -1l
  aa_fake_theta_in = -1l
  aa_fake_phi_in = -1l
  aa_fake_ene_in = -1l
  aa_fake_plane_id = -1l
  aa_fake_zpos = -1.
  aa_fake_si_id = -1l
  aa_fake_pos = -1.
  aa_fake_edep = -1.
  aa_fake_strip_number = -1.
   
endelse


; G4.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
calInput_event_id_tot_cal = -1l
calInput_bar_id_tot = -1l
calInput_bar_ene_tot = -1.

; SUM.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
calInputSum_event_id_tot_cal = -1l
calInputSum_bar_ene_tot = -1.

; G4.AC.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
acInput_event_id_tot_ac = -1l
acInput_AC_panel = ''
acInput_AC_subpanel = -1l
acInput_energy_dep_tot_ac = -1.

filepath = './ASTROGAM'+astrogam_version+sdir+'/theta'+strtrim(string(theta_type),1)+'/'+stripDir+py_dir+'/'+sim_name+'/'+ene_type+'MeV/'+strtrim(string(N_in),1)+part_type+dir_cal+dir_passive+'/'+strtrim(string(energy_thresh),1)+'keV/'
print, 'LEVEL0 file path: ', filepath

for ifile=0, n_files-1 do begin

  if (isStrip) then begin
    
    filenamedat_aa_strip = filepath+'AA_STRIP_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'
    readcol, filenamedat_aa_strip, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, format='(l,l,l,l,l,f,l,l,f,f)'
    print, filenamedat_aa_strip
    
    aa_strip_event_id = [aa_strip_event_id, c1]
    aa_strip_theta_in = [aa_strip_theta_in, c2]
    aa_strip_phi_in = [aa_strip_phi_in, c3]
    aa_strip_ene_in = [aa_strip_ene_in, c4]
    aa_strip_plane_id = [aa_strip_plane_id, c5]
    aa_strip_zpos = [aa_strip_zpos, c6]
    aa_strip_si_id = [aa_strip_si_id, c7]
    aa_strip_strip_id = [aa_strip_strip_id, c8]
    aa_strip_pos = [aa_strip_pos, c9]
    aa_strip_edep = [aa_strip_edep, c10]

    filenamedat_aa_kalman = filepath+'AA_KALMAN_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'
    readcol, filenamedat_aa_kalman, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, format='(l,l,l,l,l,f,l,f,f,l)'
    print, filenamedat_aa_kalman
    
    aa_kalman_event_id = [aa_kalman_event_id, c1]
    aa_kalman_theta_in = [aa_kalman_theta_in, c2]
    aa_kalman_phi_in = [aa_kalman_phi_in, c3]
    aa_kalman_ene_in = [aa_kalman_ene_in, c4]
    aa_kalman_plane_id = [aa_kalman_plane_id, c5]
    aa_kalman_zpos = [aa_kalman_zpos, c6]
    aa_kalman_si_id = [aa_kalman_si_id, c7]
    aa_kalman_pos = [aa_kalman_pos, c8]
    aa_kalman_edep = [aa_kalman_edep, c9]
    aa_kalman_strip_number = [aa_kalman_strip_number, c10]        

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
    KALMAN_plane_x = [[KALMAN_plane_x], [struct_kalman.PIANI_X]]    
    KALMAN_cluster_x = [[KALMAN_cluster_x], [struct_kalman.Clusters_X]]
    KALMAN_plane_y = [[KALMAN_plane_y], [struct_kalman.PIANI_Y]]
    KALMAN_cluster_y = [[KALMAN_cluster_y], [struct_kalman.Clusters_Y]]

    filenamefits_kalmanl1 = filepath+'KALMAN.L1.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
    print, filenamefits_kalmanl1
    struct_kalmanl1 = mrdfits(filenamefits_kalmanl1,$ 
                     1, $
                     structyp = 'kalmanl1', $
                     /unsigned)

    print, struct_kalmanl1.Event_ID
    KALMANL1_eventid = [KALMANL1_eventid, struct_kalmanl1.Event_ID]
    KALMANL1_theta = [KALMANL1_theta, struct_kalmanl1.Theta]
    KALMANL1_phi = [KALMANL1_phi, struct_kalmanl1.Phi]
    KALMANL1_energy = [KALMANL1_energy, struct_kalmanl1.ENERGIA]
    KALMANL1_plane_x = [[KALMANL1_plane_x], [struct_kalmanl1.PIANI_X]]    
    KALMANL1_cluster_x = [[KALMANL1_cluster_x], [struct_kalmanl1.Clusters_X]]
    KALMANL1_plane_y = [[KALMANL1_plane_y], [struct_kalmanl1.PIANI_Y]]
    KALMANL1_cluster_y = [[KALMANL1_cluster_y], [struct_kalmanl1.Clusters_Y]]

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
    
    endif else begin
      filenamedat_aa_fake = filepath+'AA_FAKE_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat'
      readcol, filenamedat_aa_fake, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, format='(l,l,l,l,l,f,l,f,f,l)'
      print, filenamedat_aa_fake

      aa_fake_event_id = [aa_fake_event_id, c1]
      aa_fake_theta_in = [aa_fake_theta_in, c2]
      aa_fake_phi_in = [aa_fake_phi_in, c3]
      aa_fake_ene_in = [aa_fake_ene_in, c4]
      aa_fake_plane_id = [aa_fake_plane_id, c5]
      aa_fake_zpos = [aa_fake_zpos, c6]
      aa_fake_si_id = [aa_fake_si_id, c7]
      aa_fake_pos = [aa_fake_pos, c8]
      aa_fake_edep = [aa_fake_edep, c9]
      aa_fake_strip_number = [aa_fake_strip_number, c10]
     
    endelse

    if (cal_flag EQ 1) then begin
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
    endif     
    if (ac_flag EQ 1) then begin
      filenamefits_ac = filepath+'G4.AC.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits'   
      struct_ac = mrdfits(filenamefits_ac,$ 
                       1, $
                       structyp = 'ac', $
                       /unsigned)
  
      acInput_event_id_tot_ac = [acInput_event_id_tot_ac, struct_ac.EVT_ID]
      acInput_AC_panel = [acInput_AC_panel, struct_ac.AC_PANEL]
      acInput_AC_subpanel = [acInput_AC_subpanel, struct_ac.AC_SUBPANEL]
      acInput_energy_dep_tot_ac = [acInput_energy_dep_tot_ac, struct_ac.E_DEP]
    endif
endfor

if (isStrip) then begin
    
  ; -----> ASCII files
  
  aa_strip_event_id = aa_strip_event_id[1:*]
  aa_strip_theta_in = aa_strip_theta_in[1:*]
  aa_strip_phi_in = aa_strip_phi_in[1:*]
  aa_strip_ene_in = aa_strip_ene_in[1:*]
  aa_strip_plane_id = aa_strip_plane_id[1:*]
  aa_strip_zpos = aa_strip_zpos[1:*]
  aa_strip_strip_id = aa_strip_strip_id[1:*]
  aa_strip_si_id = aa_strip_si_id[1:*]
  aa_strip_pos = aa_strip_pos[1:*]
  aa_strip_edep = aa_strip_edep[1:*]
  
  aa_kalman_event_id = aa_kalman_event_id[1:*]
  aa_kalman_theta_in = aa_kalman_theta_in[1:*]
  aa_kalman_phi_in = aa_kalman_phi_in[1:*]
  aa_kalman_ene_in = aa_kalman_ene_in[1:*]
  aa_kalman_plane_id = aa_kalman_plane_id[1:*]
  aa_kalman_zpos = aa_kalman_zpos[1:*]
  aa_kalman_si_id = aa_kalman_si_id[1:*]
  aa_kalman_pos = aa_kalman_pos[1:*]
  aa_kalman_edep = aa_kalman_edep[1:*] 
  aa_kalman_strip_number = aa_kalman_strip_number[1:*]
  
  openw,lun,filepath+'AA_STRIP_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'_all.dat',/get_lun
  ; ASCII Columns:
  ; - c1 = event ID
  ; - c2 = theta input
  ; - c3 = phi input
  ; - c4 = energy input
  ; - c5 = plane ID
  ; - c6 = Pos Z
  ; - c7 = X/Y flag (X = 0, Y = 1)
  ; - c8 = Strip ID
  ; - c9 = strip position (reference system center at the Silicon layer center)
  ; - c10 = energy deposition (keV)
  
  for r=0l, n_elements(aa_strip_event_id)-1 do begin
    printf, lun, aa_strip_event_id(r), aa_strip_theta_in(r), aa_strip_phi_in(r), aa_strip_ene_in(r), aa_strip_plane_id(r), aa_strip_zpos(r), aa_strip_si_id(r), aa_strip_strip_id(r), aa_strip_pos(r), aa_strip_edep(r), format='(I5,I5,I5,I5,I5,F10.5,I5,I5,F10.5,F10.5)'
  endfor
  
  openw,lun,filepath+'AA_KALMAN_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'_all.dat',/get_lun
  ; ASCII Columns:
  ; - c1 = event ID
  ; - c2 = theta input
  ; - c3 = phi input
  ; - c4 = energy input
  ; - c5 = plane ID
  ; - c6 = Pos Z
  ; - c7 = X/Y flag (X = 0, Y = 1)
  ; - c8 = Cluster position (reference system center at the Silicon layer center)
  ; - c9 = energy deposition (keV)
  ; - c10 = number of strips composing the cluster
  
  for r=0l, n_elements(aa_kalman_event_id)-1 do begin
      printf, lun, aa_kalman_event_id(r), aa_kalman_theta_in(r), aa_kalman_phi_in(r), aa_kalman_ene_in(r), aa_kalman_plane_id(r), aa_kalman_zpos(r), aa_kalman_si_id(r), aa_kalman_pos(r), aa_kalman_edep(r), aa_kalman_strip_number(r), format='(I5,I5,I5,I7,I5,F10.5,I5,F10.5,F10.5,I5)'
  endfor
  
  Free_lun, lun
  
  
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
  
  ; KALMANL1.TRACKER.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
  KALMANL1_eventid = KALMANL1_eventid[1:*]
  KALMANL1_theta = KALMANL1_theta[1:*]
  KALMANL1_phi = KALMANL1_phi[1:*]
  KALMANL1_energy = KALMANL1_energy[1:*]
  KALMANL1_plane_x = KALMANL1_plane_x[*, 1:*]  
  KALMANL1_cluster_x = KALMANL1_cluster_x[*, 1:*]
  KALMANL1_plane_y = KALMANL1_plane_y[*, 1:*]
  KALMANL1_cluster_y = KALMANL1_cluster_y[*, 1:*]
  
  ; SUM.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
  SUMTRACKER_Glob_event_id_cluster = SUMTRACKER_Glob_event_id_cluster[1:*]
  SUMTRACKER_Glob_tray_id_cluster = SUMTRACKER_Glob_tray_id_cluster[1:*]
  SUMTRACKER_Glob_plane_id_cluster = SUMTRACKER_Glob_plane_id_cluster[1:*]
  SUMTRACKER_Glob_Si_id_cluster = SUMTRACKER_Glob_Si_id_cluster[1:*]
  SUMTRACKER_Glob_zpos_cluster = SUMTRACKER_Glob_zpos_cluster[1:*]
  SUMTRACKER_Glob_energy_dep_cluster = SUMTRACKER_Glob_energy_dep_cluster[1:*]
endif else begin
  
  ; -----> ASCII files


  aa_fake_event_id = aa_fake_event_id[1:*]
  aa_fake_theta_in = aa_fake_theta_in[1:*]
  aa_fake_phi_in = aa_fake_phi_in[1:*]
  aa_fake_ene_in = aa_fake_ene_in[1:*]
  aa_fake_plane_id = aa_fake_plane_id[1:*]
  aa_fake_zpos = aa_fake_zpos[1:*]
  aa_fake_si_id = aa_fake_si_id[1:*]
  aa_fake_pos = aa_fake_pos[1:*]
  aa_fake_edep = aa_fake_edep[1:*]
  aa_fake_strip_number = aa_fake_strip_number[1:*]


  openw,lun,filepath+'AA_FAKE_ASTROGAM'+astrogam_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+part_type+'_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'_all.dat',/get_lun
  ; ASCII Columns:
  ; - c1 = event ID
  ; - c2 = theta input
  ; - c3 = phi input
  ; - c4 = energy input
  ; - c5 = plane ID
  ; - c6 = Pos Z
  ; - c7 = X/Y flag (X = 0, Y = 1)
  ; - c8 = Cluster position (reference system center at the Silicon layer center)
  ; - c9 = energy deposition (keV)
  ; - c10 = number of strips composing the cluster

  for r=0l, n_elements(aa_fake_event_id)-1 do begin
    printf, lun, aa_fake_event_id(r), aa_fake_theta_in(r), aa_fake_phi_in(r), aa_fake_ene_in(r), aa_fake_plane_id(r), aa_fake_zpos(r), aa_fake_si_id(r), aa_fake_pos(r), aa_fake_edep(r), aa_fake_strip_number(r), format='(I5,I5,I5,I7,I5,F10.5,I5,F10.5,F10.5,I5)'
  endfor

  Free_lun, lun

  
endelse

if (cal_flag EQ 1) then begin
  ; G4.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits 
  calInput_event_id_tot_cal = calInput_event_id_tot_cal[1:*]
  calInput_bar_id_tot = calInput_bar_id_tot[1:*]
  calInput_bar_ene_tot = calInput_bar_ene_tot[1:*]
  
  ; SUM.CAL.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits 
  calInputSum_event_id_tot_cal = calInputSum_event_id_tot_cal[1:*]
  calInputSum_bar_ene_tot = calInputSum_bar_ene_tot[1:*]
endif
if (ac_flag EQ 1) then begin
  ; G4.AC.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
  acInput_event_id_tot_ac = acInput_event_id_tot_ac[1:*]
  acInput_AC_panel = acInput_AC_panel[1:*]
  acInput_AC_subpanel = acInput_AC_subpanel[1:*]
  acInput_energy_dep_tot_ac = acInput_energy_dep_tot_ac[1:*]
endif

if (isStrip) then begin
  
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
  
  
  string_dim = string(default_max_cols) 
  CREATE_STRUCT, KALMANTRIGGER, 'TRIGGERKALMAN', ['Event_ID', 'Theta', 'Phi','Energia','Piani_X','Clusters_X', 'Piani_Y', 'Clusters_Y'],'J,F,F,F,I('+string_dim+'),D('+string_dim+'),I('+string_dim+'),D('+string_dim+')', DIMEN = N_ELEMENTS(KALMANL1_theta)
  KALMANTRIGGER.Event_id = KALMANL1_eventid
  KALMANTRIGGER.Theta = KALMANL1_theta
  KALMANTRIGGER.Phi = KALMANL1_phi
  KALMANTRIGGER.Energia = KALMANL1_energy
  KALMANTRIGGER.Piani_X = KALMANL1_plane_x
  KALMANTRIGGER.Clusters_X = KALMANL1_cluster_x
  KALMANTRIGGER.Piani_Y = KALMANL1_plane_y
  KALMANTRIGGER.Clusters_Y = KALMANL1_cluster_y
  
  HDR_KALMANTRIGGER = ['Creator          = Valentina Fioretti', $
            'THELSim release  = ASTROGAM '+astrogam_version, $
            'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
            'ENERGY           = '+ene_type+'   /Simulated input energy', $
            'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
            'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle']
  
  
  MWRFITS, KALMANTRIGGER, filepath+'KALMAN.L1.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.all.fits', HDR_KALMANTRIGGER, /CREATE
  
  
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
endif 
if (cal_flag EQ 1) then begin
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

endif
if (ac_flag EQ 1) then begin
  CREATE_STRUCT, acInput, 'input_ac_dhsim', ['EVT_ID', 'AC_PANEL', 'AC_SUBPANEL', 'E_DEP'], $
  'I,A,I,F20.15', DIMEN = n_elements(acInput_event_id_tot_ac)
  acInput.EVT_ID = acInput_event_id_tot_ac
  acInput.AC_PANEL = acInput_AC_panel
  acInput.AC_SUBPANEL = acInput_AC_subpanel
  acInput.E_DEP = acInput_energy_dep_tot_ac
  
  
  hdr_acInput = ['COMMENT  ASTROGAM V'+astrogam_version+' Geant4 simulation', $
                 'N_in     = '+strtrim(string(N_in),1), $
                 'Energy     = '+ene_type, $
                 'Theta     = '+strtrim(string(theta_type),1), $
                 'Phi     = '+strtrim(string(phi_type),1), $
                 'Energy unit = GeV']
  
  MWRFITS, acInput, filepath+'G4.AC.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.all.fits', hdr_acInput, /create
endif



end
