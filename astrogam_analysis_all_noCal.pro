; astrogam_analysis_all_noCal.pro - Description
; ---------------------------------------------------------------------------------
; Compacting the THELSim ASTROGAM processed files to a unique file:
; - Tracker
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
; astrogam_analysis_all_noCal
; ---------------------------------------------------------------------------------


pro astrogam_analysis_all_noCal

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



filepath = './ASTROGAM'+astrogam_version+sdir+'/theta'+strtrim(string(theta_type),1)+'/'+stripDir+py_dir+'/'+sim_name+'/'+ene_type+'MeV/'+strtrim(string(N_in),1)+part_type+'/OnlyTracker/'
print, 'LEVEL0 file path: ', filepath

for ifile=0, n_files-1 do begin

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

    KALMAN_theta = [KALMAN_theta, struct_kalman.Theta]
    KALMAN_phi = [KALMAN_phi, struct_kalman.Phi]
    KALMAN_energy = [KALMAN_energy, struct_kalman.ENERGIA]
    ;for jev = 0l, n_elements(struct_kalman.Theta)-1 do begin
      KALMAN_plane_x = [[KALMAN_plane_x], [struct_kalman.PIANI_X]]    
      KALMAN_cluster_x = [[KALMAN_cluster_x], [struct_kalman.Clusters_X]]
      KALMAN_plane_y = [[KALMAN_plane_y], [struct_kalman.PIANI_X]]
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

    
endfor



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


; L0.5.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
L05TRACKER_Glob_event_id_cluster = L05TRACKER_Glob_event_id_cluster[1:*]
L05TRACKER_Glob_tray_id_cluster = L05TRACKER_Glob_tray_id_cluster[1:*]
L05TRACKER_Glob_plane_id_cluster = L05TRACKER_Glob_plane_id_cluster[1:*]
L05TRACKER_Glob_Si_id_cluster = L05TRACKER_Glob_Si_id_cluster[1:*]
L05TRACKER_Glob_pos_cluster = L05TRACKER_Glob_pos_cluster[1:*]
L05TRACKER_Glob_zpos_cluster = L05TRACKER_Glob_zpos_cluster[1:*]
L05TRACKER_Glob_energy_dep_cluster = L05TRACKER_Glob_energy_dep_cluster[1:*]

; KALMAN.TRACKER.ASTROGAM<version>.<phys>List.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.all.fits
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
CREATE_STRUCT, KALMANTRACKER, 'TRACKERKALMAN', ['Theta', 'Phi','Energia','Piani_X','Clusters_X', 'Piani_Y', 'Clusters_Y'], 'F,F,F,I('+string_dim+'),D('+string_dim+'),I('+string_dim+'),D('+string_dim+')', DIMEN = N_ELEMENTS(KALMAN_theta)
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



end
