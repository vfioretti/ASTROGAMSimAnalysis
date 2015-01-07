; astrogam_analysis_file.pro - Description
; ---------------------------------------------------------------------------------
; Processing the THELSIM ASTROGAM simulation:
; - Tracker
; - AC
; - Calorimeter
; ---------------------------------------------------------------------------------
; Output:
; - all files are created in a self-descripted subdirectory of the current directory. If the directory is not present it is created by the IDL script.
; ---------> FITS files
; - G4.RAW.ASTROGAM<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.<file>.fits
; - L0.5.ASTROGAM<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.<file>.fits
; - KALMAN.ASTROGAM<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.<file>.fits
; - G4.AC.ASTROGAM<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.<file>.fits
; - G4.CAL.ASTROGAM<version>.<phys>List.<sim_type>.<strip>.<point>.<n_in>ph.<energy>MeV.<theta>.<phi>.<file>.fits 
; ----------------------------------------------------------------------------------
; copyright            : (C) 2014 Valentina Fioretti
; email                : fioretti@iasfbo.inaf.it
; ----------------------------------------------
; Usage:
; astrogam_analysis_file
; ---------------------------------------------------------------------------------
; Notes:
; Each THELSIM FITS files individually processed


pro astrogam_analysis_file


; Variables initialization
N_in = 0UL            ;--> Number of emitted photons
part_type = ''       ; particle type
n_fits = 0           ;--> Number of FITS files produced by the simulation

astrogam_version = ''
sim_type = 0
py_list = 0
ene_range = 0
ene_type = 0.
ene_min = 0
ene_max = 0
theta_type = 0
phi_type = 0
source_g = 0
ene_min = 0
ene_max = 0

read, astrogam_version, PROMPT='% - Enter ASTROGAM release (e.g. V1.4):'
read, sim_type, PROMPT='% - Enter simulation type [0 = Mono, 1 = Chen, 2: Vela, 3: Crab, 4: G400]:'
read, py_list, PROMPT='% - Enter the Physics List [0 = QGSP_BERT_EMV, 100 = ARGO, 300 = FERMI, 400 = ASTROMEV]:'
read, N_in, PROMPT='% - Enter the number of emitted particles:'
read, part_type, PROMPT='% - Enter the particle type [ph = photons, mu = muons]:'
read, n_fits, PROMPT='% - Enter number of FITS files:'
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
   py_dir = '100List'
   py_name = '100List'
endif
if (py_list EQ 300) then begin
   py_dir = '300List'
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
; setting specific agile version variables 
if (astrogam_version EQ 'V1.0') then begin
    ; --------> volume ID
    
    tracker_xbottom_vol_start = 1000000
    tracker_ybottom_vol_start = 1100000
    tracker_xtop_vol_start = 1090000
    tracker_ytop_vol_start = 1190000

    tracker_bottom_vol_start = tracker_xbottom_vol_start

    tracker_top_bot_diff = 90000
    tracker_xy_diff = 100000
    cal_vol_start = 50000
    cal_vol_end = 64399
    ;ac_vol_start = 301
    ;ac_vol_end = 350
 
    ;panel_S = [301, 302, 303]
    ;panel_D = [311, 312, 313]
    ;panel_F = [321, 322, 323]
    ;panel_B = [331, 332, 333]
    ;panel_top = 340
        
    ; --------> design
    N_tray = 40l
    N_plane = N_tray*2
    N_strip = 2480l
    tray_side = 60.016 ;cm

    bar_side = 0.5  ; cm  (side of calorimeter bars)
    n_bars = 120*120  ; number of calorimeter bars
    
    ; --------> processing
    ; accoppiamento capacitivo
    ;acap = [0.035, 0.045, 0.095, 0.115, 0.38, 1., 0.38, 0.115, 0.095, 0.045, 0.035]  
    ; tracker energy threshold (0.25 MIP)
    E_th = 20.  ; keV 
    
    E_th_cal = 40. ; keV
  
    ; calorimeter bar attenuation for diods A and B
    ;att_a_x = [0.0281,0.0285,0.0281,0.0269,0.0238,0.0268,0.0274,0.0296,0.0272,0.0348,0.0276,0.0243, 0.0312,0.0287,0.0261]  
    ;att_b_x = [0.0256,0.0286,0.0294,0.0259,0.0235,0.0264,0.0276,0.0295,0.0223,0.0352,0.0293,0.0256,0.0290,0.0289,0.0266]    
    ;att_a_y = [0.0298,0.0281,0.0278,0.0301,0.0296,0.0242,0.0300,0.0294,0.0228,0.0319,0.0290,0.0304,0.0274,0.0282,0.0267]
    ;att_b_y = [0.0279,0.0254,0.0319,0.0260,0.0310,0.0253,0.0289,0.0268,0.0231,0.0319,0.0252,0.0242,0.0246,0.0258,0.0268]
    
endif 

; setting specific agile version variables 
if (astrogam_version EQ 'V2.0') then begin
    ; --------> volume ID
    tracker_bottom_vol_start = 1000000
    tracker_xbottom_vol_start = tracker_bottom_vol_start
    tracker_top_vol_start = 1090000

    tracker_top_bot_diff = 90000
    cal_vol_start = 50000
    cal_vol_end = 64399
    ;ac_vol_start = 301
    ;ac_vol_end = 350
 
    ;panel_S = [301, 302, 303]
    ;panel_D = [311, 312, 313]
    ;panel_F = [321, 322, 323]
    ;panel_B = [331, 332, 333]
    ;panel_top = 340
        
    ; --------> design
    N_tray = 40l
    N_plane = N_tray*2
    N_strip = 2480l
    tray_side = 60.016 ;cm

    bar_side = 0.5  ; cm  (side of calorimeter bars)
    n_bars = 120*120  ; number of calorimeter bars
    
    ; --------> processing
    ; accoppiamento capacitivo
    ;acap = [0.035, 0.045, 0.095, 0.115, 0.38, 1., 0.38, 0.115, 0.095, 0.045, 0.035]  
    ; tracker energy threshold (0.25 MIP)
    E_th = 20.  ; keV 
    
    E_th_cal = 40. ; keV
  
    ; calorimeter bar attenuation for diods A and B
    ;att_a_x = [0.0281,0.0285,0.0281,0.0269,0.0238,0.0268,0.0274,0.0296,0.0272,0.0348,0.0276,0.0243, 0.0312,0.0287,0.0261]  
    ;att_b_x = [0.0256,0.0286,0.0294,0.0259,0.0235,0.0264,0.0276,0.0295,0.0223,0.0352,0.0293,0.0256,0.0290,0.0289,0.0266]    
    ;att_a_y = [0.0298,0.0281,0.0278,0.0301,0.0296,0.0242,0.0300,0.0294,0.0228,0.0319,0.0290,0.0304,0.0274,0.0282,0.0267]
    ;att_b_y = [0.0279,0.0254,0.0319,0.0260,0.0310,0.0253,0.0289,0.0268,0.0231,0.0319,0.0252,0.0242,0.0246,0.0258,0.0268]
    
endif 

; setting specific agile version variables 
if (astrogam_version EQ 'V3.0') then begin
    ; --------> volume ID
    tracker_top_vol_start = 1090000
    tracker_bottom_vol_start = 1000000
    tracker_top_bot_diff = 90000
    
    cal_vol_start = 50000
    cal_vol_end = 64399

    ;ac_vol_start = 301
    ;ac_vol_end = 350
 
    ;panel_S = [301, 302, 303]
    ;panel_D = [311, 312, 313]
    ;panel_F = [321, 322, 323]
    ;panel_B = [331, 332, 333]
    ;panel_top = 340
        
    ; --------> design
    N_tray = 70l
    N_plane = N_tray*1
    N_strip = 2480l
    tray_side = 60.016 ;cm

    bar_side = 0.5  ; cm  (side of calorimeter bars)
    n_bars = 120*120  ; number of calorimeter bars
    
    ; --------> processing
    ; accoppiamento capacitivo
    ;acap = [0.035, 0.045, 0.095, 0.115, 0.38, 1., 0.38, 0.115, 0.095, 0.045, 0.035]  
    ; tracker energy threshold (0.25 MIP)
    E_th = 20.  ; keV 
    
    E_th_cal = 40. ; keV
  
    ; calorimeter bar attenuation for diods A and B
    ;att_a_x = [0.0281,0.0285,0.0281,0.0269,0.0238,0.0268,0.0274,0.0296,0.0272,0.0348,0.0276,0.0243, 0.0312,0.0287,0.0261]  
    ;att_b_x = [0.0256,0.0286,0.0294,0.0259,0.0235,0.0264,0.0276,0.0295,0.0223,0.0352,0.0293,0.0256,0.0290,0.0289,0.0266]    
    ;att_a_y = [0.0298,0.0281,0.0278,0.0301,0.0296,0.0242,0.0300,0.0294,0.0228,0.0319,0.0290,0.0304,0.0274,0.0282,0.0267]
    ;att_b_y = [0.0279,0.0254,0.0319,0.0260,0.0310,0.0253,0.0289,0.0268,0.0231,0.0319,0.0252,0.0242,0.0246,0.0258,0.0268]
    
endif 

run_path = GETENV('BGRUNS')

filepath = run_path + '/ASTROGAM'+astrogam_version+sdir+'/theta'+strtrim(string(theta_type),1)+'/'+stripDir+py_dir+'/'+ene_type+'MeV.'+sim_name+'.'+strtrim(string(theta_type),1)+'theta.'+strtrim(string(N_in),1)+part_type
print, 'ASTROGAM simulation path: ', filepath

outdir = './ASTROGAM'+astrogam_version+sdir+'/theta'+strtrim(string(theta_type),1)+'/'+stripDir+py_dir+'/'+sim_name+'/'+ene_type+'MeV/'+strtrim(string(N_in),1)+part_type
print, 'ASTROGAM outdir path: ', outdir

CheckOutDir = DIR_EXIST( outdir)
if (CheckOutDir EQ 0) then spawn,'mkdir -p ./ASTROGAM'+astrogam_version+sdir+'/theta'+strtrim(string(theta_type),1)+'/'+stripDir+py_dir+'/'+sim_name+'/'+ene_type+'MeV/'+strtrim(string(N_in),1)+part_type


for ifile=0, n_fits-1 do begin
    print, 'Reading the THELSIM file.....', ifile+1

    ; Tracker
    event_id = -1l
    vol_id = -1l
    moth_id = -1l
    energy_dep = -1.

    ent_x = -1.
    ent_y = -1.
    ent_z = -1.
    exit_x = -1.
    exit_y = -1.
    exit_z = -1.

    theta_ent = -1.
    phi_ent = -1.

    theta_exit = -1.
    phi_exit = -1.
    
    ; Calorimeter
    event_id_cal = -1l
    vol_id_cal = -1l
    moth_id_cal = -1l
    energy_dep_cal = -1.
    
    ent_x_cal = -1.
    ent_y_cal = -1.
    ent_z_cal = -1.
    exit_x_cal = -1.
    exit_y_cal = -1.
    exit_z_cal = -1.
    
    theta_ent_cal = -1.
    phi_ent_cal = -1.
    
    theta_exit_cal = -1.
    phi_exit_cal = -1.

    ; AC    
;    event_id_ac = -1l
;    vol_id_ac = -1l
;    moth_id_ac = -1l
;    energy_dep_ac = -1.
;    
;    ent_x_ac = -1.
;    ent_y_ac = -1.
;    ent_z_ac = -1.
;    exit_x_ac = -1.
;    exit_y_ac = -1.
;    exit_z_ac = -1.
;    
;    theta_ent_ac = -1.
;    phi_ent_ac = -1.
;    
;    theta_exit_ac = -1.
;    phi_exit_ac = -1.

    filename = filepath+'/xyz.'+strtrim(string(ifile), 1)+'.fits.gz'
    struct = mrdfits(filename,$ 
                     1, $
                     structyp = 'astrogam', $
                     /unsigned)

    for k=0l, n_elements(struct)-1l do begin 
    
    ; Reading the tracker (events with E > 0)                
     if ((struct(k).VOLUME_ID GE tracker_bottom_vol_start) or (struct(k).MOTHER_ID GE tracker_bottom_vol_start)) then begin
      if (struct(k).E_DEP GT 0.d) then begin        

         event_id = [event_id, struct(k).EVT_ID] 
         vol_id = [vol_id, struct(k).VOLUME_ID] 
         moth_id = [moth_id, struct(k).MOTHER_ID]
         energy_dep = [energy_dep, struct(k).E_DEP] 
        
         ent_x = [ent_x, struct(k).X_ENT]  
         ent_y = [ent_y, struct(k).Y_ENT]  
         ent_z = [ent_z, struct(k).Z_ENT]  
         exit_x = [exit_x, struct(k).X_EXIT]  
         exit_y = [exit_y, struct(k).Y_EXIT]  
         exit_z = [exit_z, struct(k).Z_EXIT]  
        
         theta_ent = [theta_ent, (180./!PI)*acos(-(struct(k).MDZ_ENT))]
         phi_ent = [phi_ent, (180./!PI)*atan((struct(k).MDY_ENT)/(struct(k).MDX_ENT))]

         theta_exit = [theta_exit, (180./!PI)*acos(-(struct(k).MDZ_EXIT))]
         phi_exit = [phi_exit, (180./!PI)*atan((struct(k).MDY_EXIT)/(struct(k).MDX_EXIT))]        
         
      endif
     endif
     ; Reading the calorimeter
     if ((struct(k).VOLUME_ID GE cal_vol_start) AND (struct(k).VOLUME_ID LE cal_vol_end)) then begin
      if (struct(k).E_DEP GT 0.d) then begin        
         event_id_cal = [event_id_cal, struct(k).EVT_ID] 
         vol_id_cal = [vol_id_cal, struct(k).VOLUME_ID] 
         moth_id_cal = [moth_id_cal, struct(k).MOTHER_ID]
         energy_dep_cal = [energy_dep_cal, struct(k).E_DEP] 
        
         ent_x_cal = [ent_x_cal, struct(k).X_ENT]  
         ent_y_cal = [ent_y_cal, struct(k).Y_ENT]  
         ent_z_cal = [ent_z_cal, struct(k).Z_ENT]  
         exit_x_cal = [exit_x_cal, struct(k).X_EXIT]  
         exit_y_cal = [exit_y_cal, struct(k).Y_EXIT]  
         exit_z_cal = [exit_z_cal, struct(k).Z_EXIT]  
        
         theta_ent_cal = [theta_ent_cal, (180./!PI)*acos(-(struct(k).MDZ_ENT))]
         phi_ent_cal = [phi_ent_cal, (180./!PI)*atan((struct(k).MDY_ENT)/(struct(k).MDX_ENT))]

         theta_exit_cal = [theta_exit_cal, (180./!PI)*acos(-(struct(k).MDZ_EXIT))]
         phi_exit_cal = [phi_exit_cal, (180./!PI)*atan((struct(k).MDY_EXIT)/(struct(k).MDX_EXIT))]        
      endif
     endif
;     if ((struct(k).VOLUME_ID GE ac_vol_start) AND (struct(k).VOLUME_ID LE ac_vol_end)) then begin
;      if (struct(k).E_DEP GT 0.d) then begin        
;         event_id_ac = [event_id_ac, struct(k).EVT_ID] 
;         vol_id_ac = [vol_id_ac, struct(k).VOLUME_ID] 
;         if (isStrip EQ 1) then moth_id_ac = [moth_id_ac, struct(k).MOTHER_ID] else moth_id_ac = [moth_id_ac, 0]
;         energy_dep_ac = [energy_dep_ac, struct(k).E_DEP] 
;        
;         ent_x_ac = [ent_x_ac, struct(k).X_ENT]  
;         ent_y_ac = [ent_y_ac, struct(k).Y_ENT]  
;         ent_z_ac = [ent_z_ac, struct(k).Z_ENT]  
;         exit_x_ac = [exit_x_ac, struct(k).X_EXIT]  
;         exit_y_ac = [exit_y_ac, struct(k).Y_EXIT]  
;         exit_z_ac = [exit_z_ac, struct(k).Z_EXIT]  
;        
;         theta_ent_ac = [theta_ent_ac, (180./!PI)*acos(-(struct(k).MDZ_ENT))]
;         phi_ent_ac = [phi_ent_ac, (180./!PI)*atan((struct(k).MDY_ENT)/(struct(k).MDX_ENT))]
;
;         theta_exit_ac = [theta_exit_ac, (180./!PI)*acos(-(struct(k).MDZ_EXIT))]
;         phi_exit_ac = [phi_exit_ac, (180./!PI)*atan((struct(k).MDY_EXIT)/(struct(k).MDX_EXIT))]        
;      endif
;     endif
     
    endfor
 
    ; Tracker (removing fake starting value)
    event_id = event_id[1:*]
    vol_id = vol_id[1:*]
    moth_id = moth_id[1:*]
    energy_dep = energy_dep[1:*]

    ent_x = (ent_x[1:*])/10.
    ent_y = (ent_y[1:*])/10.
    ent_z = (ent_z[1:*])/10.
    exit_x = (exit_x[1:*])/10.
    exit_y = (exit_y[1:*])/10.
    exit_z = (exit_z[1:*])/10.

    theta_ent = theta_ent[1:*]
    phi_ent = phi_ent[1:*]

    theta_exit = theta_exit[1:*]
    phi_exit = phi_exit[1:*]

    ; Calorimeter (removing fake starting value)
    event_id_cal = event_id_cal[1:*]
    vol_id_cal = vol_id_cal[1:*]
    moth_id_cal = moth_id_cal[1:*]
    energy_dep_cal = energy_dep_cal[1:*]

    ent_x_cal = (ent_x_cal[1:*])/10.
    ent_y_cal = (ent_y_cal[1:*])/10.
    ent_z_cal = (ent_z_cal[1:*])/10.
    exit_x_cal = (exit_x_cal[1:*])/10.
    exit_y_cal = (exit_y_cal[1:*])/10.
    exit_z_cal = (exit_z_cal[1:*])/10.

    theta_ent_cal = theta_ent_cal[1:*]
    phi_ent_cal = phi_ent_cal[1:*]

    theta_exit_cal = theta_exit_cal[1:*]
    phi_exit_cal = phi_exit_cal[1:*]

    ; AC (removing fake starting value)
;    event_id_ac = event_id_ac[1:*]
;    vol_id_ac = vol_id_ac[1:*]
;    moth_id_ac = moth_id_ac[1:*]
;    energy_dep_ac = energy_dep_ac[1:*]
;
;    ent_x_ac = (ent_x_ac[1:*])/10.
;    ent_y_ac = (ent_y_ac[1:*])/10.
;    ent_z_ac = (ent_z_ac[1:*])/10.
;    exit_x_ac = (exit_x_ac[1:*])/10.
;    exit_y_ac = (exit_y_ac[1:*])/10.
;    exit_z_ac = (exit_z_ac[1:*])/10.
;
;    theta_ent_ac = theta_ent_ac[1:*]
;    phi_ent_ac = phi_ent_ac[1:*]
;
;    theta_exit_ac = theta_exit_ac[1:*]
;    phi_exit_ac = phi_exit_ac[1:*]

    ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ;                             Processing the tracker 
    ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    if ((astrogam_version EQ 'V1.0') or (astrogam_version EQ 'V2.0')) then begin
        ; From Tracker volume ID to strip and tray ID
        Strip_id = dblarr(n_elements(vol_id))
        Si_id = intarr(n_elements(vol_id)) 
        tray_id = intarr(n_elements(vol_id))
        
        ; Si_id = Si layer flag description:
        ; - 0 = X 
        ; - 1 = Y 
        ; - 2 = X top
        ; - 3 = Y top
    
        ; Conversion from tray ID (starting from bottom) to plane ID (starting from the top)   
        plane_id = intarr(n_elements(2*tray_id))
    
    
        for j=0l, n_elements(vol_id)-1 do begin
    
         if (isStrip EQ 0) then begin   ;--------> STRIP = 0
            div_type = vol_id(j) mod tracker_xbottom_vol_start
           if (div_type EQ 0) then begin
               Si_id(j) = 0 
               tray_id(j) = (vol_id(j))/tracker_xbottom_vol_start 
               invert_tray_id = (N_tray - tray_id(j))+1
               plane_id(j) = 2*invert_tray_id
           endif 
           if (((vol_id(j) - tracker_xy_diff) mod tracker_xbottom_vol_start) EQ 0) then begin
               Si_id(j) = 1
               tray_id(j) = (vol_id(j)-tracker_xy_diff)/tracker_xbottom_vol_start
               invert_tray_id = (N_tray - tray_id(j))+1
                plane_id(j) = 2*invert_tray_id
               
           endif
           if (((vol_id(j) - tracker_top_bot_diff) mod tracker_xbottom_vol_start) EQ 0) then begin
                Si_id(j) = 2
                tray_id(j) = (vol_id(j)-tracker_top_bot_diff)/tracker_xbottom_vol_start
                invert_tray_id = (N_tray - tray_id(j))+1
                plane_id(j) = (2*invert_tray_id)-1
           endif
           if (((vol_id(j) - (tracker_xy_diff + tracker_top_bot_diff)) mod tracker_xbottom_vol_start) EQ 0) then begin
                Si_id(j) = 3
                tray_id(j) = (vol_id(j)-(tracker_xy_diff + tracker_top_bot_diff))/tracker_xbottom_vol_start
                invert_tray_id = (N_tray - tray_id(j))+1
                plane_id(j) = (2*invert_tray_id)-1            
           endif
           Strip_id(j) = 0
          
          endif else begin  ;--------> STRIP = 1
            if (repli EQ 0) then begin
               tray_id(j) = vol_id(j)/tracker_xbottom_vol_start
               invert_tray_id = (N_tray - tray_id(j))+1
               vol_id_temp = vol_id(j) - (tracker_xbottom_vol_start*tray_id(j)) ; removing 1000000xn_tray
               if (astrogam_version EQ "V1.0") then begin
                     if (vol_id_temp LT N_strip) then begin  
                        Si_id(j) = 0 
                        Strip_id(j) = vol_id_temp   
                        plane_id(j) = 2*invert_tray_id 
                     endif
                     if ((vol_id_temp GE tracker_xy_diff) and (vol_id_temp LT (tracker_xy_diff + N_strip))) then begin
                        Si_id(j) = 1
                        Strip_id(j) = vol_id_temp - tracker_xy_diff     
                        plane_id(j) = 2*invert_tray_id 
                     endif
                     if ((vol_id_temp GE (tracker_top_bot_diff)) and (vol_id_temp LT (tracker_top_bot_diff + N_strip))) then begin
                        Si_id(j) = 2
                        Strip_id(j) = vol_id_temp - tracker_top_bot_diff   
                        plane_id(j) = (2*invert_tray_id) - 1 
                     endif
                     if ((vol_id_temp GE (tracker_xy_diff + tracker_top_bot_diff)) and (vol_id_temp LT (tracker_xy_diff + tracker_top_bot_diff + N_strip))) then begin
                        Si_id(j) = 3
                        Strip_id(j) = vol_id_temp - (tracker_xy_diff + tracker_top_bot_diff)     
                        plane_id(j) = (2*invert_tray_id) - 1 
                     endif
               endif
            endif
            if (repli EQ 1) then begin
               tray_id(j) = moth_id(j)/tracker_xbottom_vol_start
               invert_tray_id = (N_tray - tray_id(j))+1
               vol_id_temp = vol_id(j) - (tracker_xbottom_vol_start*tray_id(j)) ; removing 1000000xn_tray
               if (astrogam_version EQ "V1.0") then begin
                     if (vol_id_temp LT N_strip) then begin  
                        Si_id(j) = 0 
                        Strip_id(j) = vol_id_temp   
                        plane_id(j) = 2*invert_tray_id 
                     endif
                     if ((vol_id_temp GE tracker_xy_diff) and (vol_id_temp LT (tracker_xy_diff + N_strip))) then begin
                        Si_id(j) = 1
                        Strip_id(j) = vol_id_temp - tracker_xy_diff     
                        plane_id(j) = 2*invert_tray_id 
                     endif
                     if ((vol_id_temp GE (tracker_top_bot_diff)) and (vol_id_temp LT (tracker_top_bot_diff + N_strip))) then begin
                        Si_id(j) = 2
                        Strip_id(j) = vol_id_temp - tracker_top_bot_diff   
                        plane_id(j) = (2*invert_tray_id) - 1 
                     endif
                     if ((vol_id_temp GE (tracker_xy_diff + tracker_top_bot_diff)) and (vol_id_temp LT (tracker_xy_diff + tracker_top_bot_diff + N_strip))) then begin
                        Si_id(j) = 3
                        Strip_id(j) = vol_id_temp - (tracker_xy_diff + tracker_top_bot_diff)     
                        plane_id(j) = (2*invert_tray_id) - 1 
                     endif
               endif
               if (astrogam_version EQ "V2.0") then begin
                     if (vol_id_temp LT N_strip) then begin  
                        Si_id(j) = [0,1] 
                        Strip_id(j) = vol_id_temp    
                        plane_id(j) = 2*invert_tray_id 
                     endif
                     if ((vol_id_temp GE tracker_xy_diff) and (vol_id_temp LT (tracker_xy_diff + N_strip))) then begin
                        Si_id(j) = 1
                        Strip_id(j) = vol_id_temp - tracker_xy_diff     
                        plane_id(j) = 2*invert_tray_id 
                     endif
                     if ((vol_id_temp GE (tracker_top_bot_diff)) and (vol_id_temp LT (tracker_top_bot_diff + N_strip))) then begin
                        Si_id(j) = 2
                        Strip_id(j) = vol_id_temp - tracker_top_bot_diff   
                        plane_id(j) = (2*invert_tray_id) - 1 
                     endif
                     if ((vol_id_temp GE (tracker_xy_diff + tracker_top_bot_diff)) and (vol_id_temp LT (tracker_xy_diff + tracker_top_bot_diff + N_strip))) then begin
                        Si_id(j) = 3
                        Strip_id(j) = vol_id_temp - (tracker_xy_diff + tracker_top_bot_diff)     
                        plane_id(j) = (2*invert_tray_id) - 1 
                     endif
               endif
            endif      
           endelse
        endfor
    endif
    if (astrogam_version EQ 'V3.0') then begin
         ; From Tracker volume ID to strip and tray ID
        Strip_id_x = intarr(n_elements(vol_id))
        Strip_id_y = intarr(n_elements(vol_id))
        tray_id = intarr(n_elements(vol_id))
        
        ; Si_id = Si layer flag description:
        ; - 0 = X 
        ; - 1 = Y 
    
        ; Conversion from tray ID (starting from bottom) to plane ID (starting from the top)   
        plane_id = intarr(n_elements(tray_id))
    
        for j=0l, n_elements(vol_id)-1 do begin
          if (isStrip EQ 1) then begin  ;--------> PIXEL = 1
            if (repli EQ 1) then begin ;--------> REPLI = 1 
               Strip_id_y(j) = vol_id(j)
               tray_id(j) = moth_id(j)/tracker_bottom_vol_start
               invert_tray_id = (N_tray - tray_id(j))+1
               vol_id_temp = moth_id(j) - (tracker_bottom_vol_start*tray_id(j) + tracker_top_bot_diff) ; removing 1000000xn_tray + 90000
               Strip_id_x(j) = vol_id_temp
               plane_id(j) = invert_tray_id
            endif      
           endif
        endfor
    endif
    
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '                             Tracker   '
    print, '           Saving the Tracker raw hits (fits and .dat)      '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
    if ((astrogam_version EQ 'V1.0') or (astrogam_version EQ 'V2.0')) then begin
    
    CREATE_STRUCT, rawData, 'rawData', ['EVT_ID', 'TRK_FLAG', 'TRAY_ID', 'PLANE_ID', 'STRIP_ID', 'E_DEP', 'X_ENT', 'Y_ENT', 'Z_ENT', 'X_EXIT', 'Y_EXIT', 'Z_EXIT'], $
    'I,I,I,I,I,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5', DIMEN = n_elements(event_id)
    rawData.EVT_ID = event_id
    rawData.TRK_FLAG = Si_id
    rawData.TRAY_ID = tray_id
    rawData.PLANE_ID = plane_id
    rawData.STRIP_ID = Strip_id
    rawData.E_DEP = energy_dep
    rawData.X_ENT = ent_x
    rawData.Y_ENT = ent_y
    rawData.Z_ENT = ent_z
    rawData.X_EXIT = exit_x
    rawData.Y_EXIT = exit_y
    rawData.Z_EXIT = exit_z
    
    
    hdr_rawData = ['COMMENT  ASTROGAM '+astrogam_version+' Geant4 simulation', $
                   'N_in     = '+strtrim(string(N_in),1), $
                   'Energy     = '+ene_type, $
                   'Theta     = '+strtrim(string(theta_type),1), $
                   'Phi     = '+strtrim(string(phi_type),1), $
                   'Position unit = cm', $
                   'Energy unit = keV']
    
    MWRFITS, rawData, outdir+'/G4.RAW.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', hdr_rawData, /create
    

    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '                            Tracker   '
    print, '                  Summing the Tracker energy                '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
    N_trig = 0l
    
    event_id_tot = -1l
    vol_id_tot = -1l
    moth_id_tot = -1l
    Strip_id_tot = -1l
    Si_id_tot = -1l
    tray_id_tot = -1l
    plane_id_tot = -1l
    energy_dep_tot = -1.
    
    event_array = -1l
    
    if (isStrip EQ 0) then begin
     j=0l
     while (1) do begin
        where_event_eq = where(event_id EQ event_id(j))

        vol_id_temp = vol_id(where_event_eq) 
        moth_id_temp = moth_id(where_event_eq) 
        Strip_id_temp = Strip_id(where_event_eq) 
        Si_id_temp = Si_id(where_event_eq) 
        tray_id_temp = tray_id(where_event_eq) 
        plane_id_temp = plane_id(where_event_eq) 
        energy_dep_temp = energy_dep(where_event_eq) 
            
        r = 0l
        count = 0l
        while(1) do begin
           where_vol_eq = where(vol_id_temp EQ vol_id_temp(r), complement = where_other_vol)
           e_dep_temp = total(energy_dep_temp(where_vol_eq))
           if (e_dep_temp GE E_th) then begin
            energy_dep_tot = [energy_dep_tot, e_dep_temp]
            event_id_tot = [event_id_tot, event_id(j)]
            vol_id_tot = [vol_id_tot, vol_id_temp(r)]
            moth_id_tot = [moth_id_tot, moth_id_temp(r)]
            Strip_id_tot = [Strip_id_tot, Strip_id_temp(r)]
            Si_id_tot = [Si_id_tot, Si_id_temp(r)]
            tray_id_tot = [tray_id_tot, tray_id_temp(r)]
            plane_id_tot = [plane_id_tot, plane_id_temp(r)]
            if (count EQ 0) then begin
               N_trig = N_trig + 1
               event_array = [event_array, event_id(j)]
            endif
            count = count + 1
           endif
           if (where_other_vol(0) NE -1) then begin
              vol_id_temp = vol_id_temp(where_other_vol)
              moth_id_temp = moth_id_temp(where_other_vol)
              Strip_id_temp = Strip_id_temp(where_other_vol)
              Si_id_temp = Si_id_temp(where_other_vol)
              tray_id_temp = tray_id_temp(where_other_vol)
              plane_id_temp = plane_id_temp(where_other_vol)
              energy_dep_temp = energy_dep_temp(where_other_vol)
            endif else break
        endwhile
            
        N_event_eq = n_elements(where_event_eq)
        if where_event_eq(N_event_eq-1) LT (n_elements(event_id)-1) then begin
          j = where_event_eq(N_event_eq-1)+1
        endif else break
     endwhile
    endif else begin
      j=0l
      while (1) do begin
         where_event_eq = where(event_id EQ event_id(j))

    
         vol_id_temp = vol_id(where_event_eq) 
         moth_id_temp = moth_id(where_event_eq) 
         Strip_id_temp = Strip_id(where_event_eq) 
         Si_id_temp = Si_id(where_event_eq) 
         tray_id_temp = tray_id(where_event_eq) 
         plane_id_temp = plane_id(where_event_eq) 
         energy_dep_temp = energy_dep(where_event_eq) 
        
         r = 0l
         count = 0l
         while(1) do begin
            where_vol_eq = where(vol_id_temp EQ vol_id_temp(r), complement = where_other_vol)
            e_dep_temp = total(energy_dep_temp(where_vol_eq))
            if (e_dep_temp GE E_th) then begin           
              event_id_tot = [event_id_tot, event_id(j)]
              vol_id_tot = [vol_id_tot, vol_id_temp(r)]
              moth_id_tot = [moth_id_tot, moth_id_temp(r)]
              Strip_id_tot = [Strip_id_tot, Strip_id_temp(r)]
              Si_id_tot = [Si_id_tot, Si_id_temp(r)]
              tray_id_tot = [tray_id_tot, tray_id_temp(r)]
              plane_id_tot = [plane_id_tot, plane_id_temp(r)]
              energy_dep_tot = [energy_dep_tot, e_dep_temp]
              if (count EQ 0) then begin
               N_trig = N_trig + 1
               event_array = [event_array, event_id(j)]
              endif
              count = count + 1
            endif
            if (where_other_vol(0) NE -1) then begin
              vol_id_temp = vol_id_temp(where_other_vol)
              moth_id_temp = moth_id_temp(where_other_vol)
              Strip_id_temp = Strip_id_temp(where_other_vol)
              Si_id_temp = Si_id_temp(where_other_vol)
              tray_id_temp = tray_id_temp(where_other_vol)
              plane_id_temp = plane_id_temp(where_other_vol)
              energy_dep_temp = energy_dep_temp(where_other_vol)
            endif else break
         endwhile
        
         N_event_eq = n_elements(where_event_eq)
         if where_event_eq(N_event_eq-1) LT (n_elements(event_id)-1) then begin
           j = where_event_eq(N_event_eq-1)+1
         endif else break
      endwhile
    endelse
    
    
    if (n_elements(event_id_tot) GT 1) then begin
      event_id_tot = event_id_tot[1:*]
      vol_id_tot = vol_id_tot[1:*]
      moth_id_tot = moth_id_tot[1:*]
      Strip_id_tot = Strip_id_tot[1:*]
      Si_id_tot = Si_id_tot[1:*]
      tray_id_tot = tray_id_tot[1:*]
      plane_id_tot = plane_id_tot[1:*]
      energy_dep_tot = energy_dep_tot[1:*]
      event_array = event_array[1:*]
    endif
    
endif

if (astrogam_version EQ 'V3.0') then begin
    
    CREATE_STRUCT, rawData, 'rawData', ['EVT_ID', 'VOL_ID', 'MOTH_ID', 'TRAY_ID', 'PLANE_ID', 'STRIP_ID_X', 'STRIP_ID_Y', 'E_DEP', 'X_ENT', 'Y_ENT', 'Z_ENT', 'X_EXIT', 'Y_EXIT', 'Z_EXIT'], $
    'I,I,J,I,I,I,I,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5,F20.5', DIMEN = n_elements(event_id)
    rawData.EVT_ID = event_id
    rawData.VOL_ID = vol_id
    rawData.MOTH_ID = moth_id
    rawData.TRAY_ID = tray_id
    rawData.PLANE_ID = plane_id
    rawData.STRIP_ID_X = Strip_id_x
    rawData.STRIP_ID_Y = Strip_id_y
    rawData.E_DEP = energy_dep
    rawData.X_ENT = ent_x
    rawData.Y_ENT = ent_y
    rawData.Z_ENT = ent_z
    rawData.X_EXIT = exit_x
    rawData.Y_EXIT = exit_y
    rawData.Z_EXIT = exit_z
    
    
    hdr_rawData = ['COMMENT  ASTROGAM '+astrogam_version+' Geant4 simulation', $
                   'N_in     = '+strtrim(string(N_in),1), $
                   'Energy     = '+ene_type, $
                   'Theta     = '+strtrim(string(theta_type),1), $
                   'Phi     = '+strtrim(string(phi_type),1), $
                   'Position unit = cm', $
                   'Energy unit = keV']
    
    MWRFITS, rawData, outdir+'/G4.RAW.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', hdr_rawData, /create
    

    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '                            Tracker   '
    print, '                  Summing the Tracker energy                '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
    N_trig = 0l
    
    event_id_tot = -1l
    vol_id_tot = -1l
    moth_id_tot = -1l
    Strip_id_x_tot = -1l
    Strip_id_y_tot = -1l
    tray_id_tot = -1l
    plane_id_tot = -1l
    energy_dep_tot = -1.
    
    if (isStrip EQ 1) then begin
      j=0l
      while (1) do begin
         where_event_eq = where(event_id EQ event_id(j))
         
         vol_id_temp = vol_id(where_event_eq) 
         moth_id_temp = moth_id(where_event_eq) 
         Strip_id_x_temp = Strip_id_x(where_event_eq) 
         Strip_id_y_temp = Strip_id_y(where_event_eq) 
         tray_id_temp = tray_id(where_event_eq) 
         plane_id_temp = plane_id(where_event_eq) 
         energy_dep_temp = energy_dep(where_event_eq) 
        
         r = 0l
         while(1) do begin
            where_vol_eq = where(((vol_id_temp EQ vol_id_temp(r)) and (moth_id_temp EQ moth_id_temp(r))), complement = where_other_vol) 
            e_dep_temp = total(energy_dep_temp(where_vol_eq))           
            event_id_tot = [event_id_tot, event_id(j)]
            vol_id_tot = [vol_id_tot, vol_id_temp(r)]
            moth_id_tot = [moth_id_tot, moth_id_temp(r)]
            Strip_id_x_tot = [Strip_id_x_tot, Strip_id_x_temp(r)]
            Strip_id_y_tot = [Strip_id_y_tot, Strip_id_y_temp(r)]
            tray_id_tot = [tray_id_tot, tray_id_temp(r)]
            plane_id_tot = [plane_id_tot, plane_id_temp(r)]
            energy_dep_tot = [energy_dep_tot, e_dep_temp]
            
            if (where_other_vol(0) NE -1) then begin
              vol_id_temp = vol_id_temp(where_other_vol)
              moth_id_temp = moth_id_temp(where_other_vol)
              Strip_id_x_temp = Strip_id_x_temp(where_other_vol)
              Strip_id_y_temp = Strip_id_y_temp(where_other_vol)
              tray_id_temp = tray_id_temp(where_other_vol)
              plane_id_temp = plane_id_temp(where_other_vol)
              energy_dep_temp = energy_dep_temp(where_other_vol)
            endif else break
         endwhile
        
         N_event_eq = n_elements(where_event_eq)
         if where_event_eq(N_event_eq-1) LT (n_elements(event_id)-1) then begin
           j = where_event_eq(N_event_eq-1)+1
         endif else break
      endwhile
    endif
    
    
    if (n_elements(event_id_tot) GT 1) then begin
      event_id_tot = event_id_tot[1:*]
      vol_id_tot = vol_id_tot[1:*]
      moth_id_tot = moth_id_tot[1:*]
      Strip_id_x_tot = Strip_id_x_tot[1:*]
      Strip_id_y_tot = Strip_id_y_tot[1:*]
      tray_id_tot = tray_id_tot[1:*]
      plane_id_tot = plane_id_tot[1:*]
      energy_dep_tot = energy_dep_tot[1:*]
    endif
    
    event_id_tot_temp = lonarr(2*n_elements(event_id_tot))
    vol_id_tot_temp = lonarr(2*n_elements(event_id_tot))
    moth_id_tot_temp = lonarr(2*n_elements(event_id_tot))
    Strip_id_tot_temp = lonarr(2*n_elements(event_id_tot))
    Si_id_tot_temp = lonarr(2*n_elements(event_id_tot))
    tray_id_tot_temp = lonarr(2*n_elements(event_id_tot))
    plane_id_tot_temp = lonarr(2*n_elements(event_id_tot))
    energy_dep_tot_temp = dblarr(2*n_elements(event_id_tot))
    
    for jev = 0l, n_elements(event_id_tot) - 1 do begin
        ev_index = jev*2 
        event_id_tot_temp[ev_index] = event_id_tot[jev]
        event_id_tot_temp[ev_index+1] = event_id_tot[jev]
        vol_id_tot_temp[ev_index] = Strip_id_x_tot[jev]  
        vol_id_tot_temp[ev_index+1] = Strip_id_y_tot[jev]
        moth_id_tot_temp[ev_index] = moth_id_tot[jev] - Strip_id_x_tot[jev]
        moth_id_tot_temp[ev_index+1] = moth_id_tot[jev] - Strip_id_x_tot[jev]  
        Strip_id_tot_temp[ev_index] = Strip_id_x_tot[jev]  
        Strip_id_tot_temp[ev_index+1] = Strip_id_y_tot[jev]
        Si_id_tot_temp[ev_index] = 0
        Si_id_tot_temp[ev_index+1] = 1
        tray_id_tot_temp[ev_index] = tray_id_tot[jev]
        tray_id_tot_temp[ev_index+1] = tray_id_tot[jev]
        plane_id_tot_temp[ev_index] = plane_id_tot[jev]
        plane_id_tot_temp[ev_index+1] = plane_id_tot[jev]
        energy_dep_tot_temp[ev_index] = energy_dep_tot[jev]/2.
        energy_dep_tot_temp[ev_index+1] = energy_dep_tot[jev]/2.
    endfor

    
    event_id_tot = -1l
    vol_id_tot = -1l
    moth_id_tot = -1l
    Strip_id_tot = -1l
    Si_id_tot = -1l
    tray_id_tot = -1l
    plane_id_tot = -1l
    energy_dep_tot = -1.
    
    
    ;
    ; Summing the energy along the strip
    ;
    
    j=0l
    while (1) do begin
         where_event_eq = where(event_id_tot_temp EQ event_id_tot_temp(j))
         
         vol_id_temp = vol_id_tot_temp(where_event_eq) 
         moth_id_temp = moth_id_tot_temp(where_event_eq) 
         Strip_id_temp = Strip_id_tot_temp(where_event_eq) 
         Si_id_temp = Si_id_tot_temp(where_event_eq) 
         tray_id_temp = tray_id_tot_temp(where_event_eq) 
         plane_id_temp = plane_id_tot_temp(where_event_eq) 
         energy_dep_temp = energy_dep_tot_temp(where_event_eq)  
        
         r = 0l
         while(1) do begin
            where_vol_eq = where(((vol_id_temp EQ vol_id_temp(r)) and (moth_id_temp EQ moth_id_temp(r))), complement = where_other_vol)
            e_dep_temp = total(energy_dep_temp(where_vol_eq))           
            event_id_tot = [event_id_tot, event_id_tot_temp(j)]
            vol_id_tot = [vol_id_tot, vol_id_temp(r)]
            moth_id_tot = [moth_id_tot, moth_id_temp(r)]
            Strip_id_tot = [Strip_id_tot, Strip_id_temp(r)]
            Si_id_tot = [Si_id_tot, Si_id_temp(r)]
            tray_id_tot = [tray_id_tot, tray_id_temp(r)]
            plane_id_tot = [plane_id_tot, plane_id_temp(r)]
            energy_dep_tot = [energy_dep_tot, e_dep_temp]
            
            if (where_other_vol(0) NE -1) then begin
              vol_id_temp = vol_id_temp(where_other_vol)
              moth_id_temp = moth_id_temp(where_other_vol)
              Strip_id_temp = Strip_id_temp(where_other_vol)
              Si_id_temp = Si_id_temp(where_other_vol)
              tray_id_temp = tray_id_temp(where_other_vol)
              plane_id_temp = plane_id_temp(where_other_vol)
              energy_dep_temp = energy_dep_temp(where_other_vol)
            endif else break
         endwhile
        
         N_event_eq = n_elements(where_event_eq)
         if where_event_eq(N_event_eq-1) LT (n_elements(event_id_tot_temp)-1) then begin
           j = where_event_eq(N_event_eq-1)+1
         endif else break
      endwhile
 
     if (n_elements(event_id_tot) GT 1) then begin
      event_id_tot = event_id_tot[1:*]
      vol_id_tot = vol_id_tot[1:*]
      moth_id_tot = moth_id_tot[1:*]
      Strip_id_tot = Strip_id_tot[1:*]
      Si_id_tot = Si_id_tot[1:*]
      tray_id_tot = tray_id_tot[1:*]
      plane_id_tot = plane_id_tot[1:*]
      energy_dep_tot = energy_dep_tot[1:*] 
     endif 

     
     ; apply the energy thresold
     
     where_eth = where(energy_dep_tot GE E_th)
     event_id_tot = event_id_tot[where_eth]
     vol_id_tot = vol_id_tot[where_eth]
     moth_id_tot = moth_id_tot[where_eth]
     Strip_id_tot = Strip_id_tot[where_eth]
     Si_id_tot = Si_id_tot[where_eth]
     tray_id_tot = tray_id_tot[where_eth]
     plane_id_tot = plane_id_tot[where_eth]
     energy_dep_tot = energy_dep_tot[where_eth] 
     
     N_trig = n_elements(uniq(event_id_tot))
     event_array = event_id_tot(uniq(event_id_tot))
 
    CREATE_STRUCT, testData, 'testData', ['EVT_ID', 'TRK_FLAG', 'TRAY_ID', 'PLANE_ID', 'STRIP_ID', 'E_DEP'], $
    'I,I,I,I,I,F20.5', DIMEN = n_elements(event_id_tot)
    testData.EVT_ID = event_id_tot
    testData.TRK_FLAG = Si_id_tot
    testData.TRAY_ID = tray_id_tot
    testData.PLANE_ID = plane_id_tot
    testData.STRIP_ID = Strip_id_tot
    testData.E_DEP = energy_dep_tot

    
    
    hdr_testData = ['COMMENT  ASTROGAM '+astrogam_version+' Geant4 simulation', $
                   'N_in     = '+strtrim(string(N_in),1), $
                   'Energy     = '+ene_type, $
                   'Theta     = '+strtrim(string(theta_type),1), $
                   'Phi     = '+strtrim(string(phi_type),1), $
                   'Position unit = cm', $
                   'Energy unit = keV']
    
    MWRFITS, testData, outdir+'/G4.TEST.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', hdr_testData, /create

     
endif
    
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '                      Tracker   '
    print, '      Build the Tracker real height          '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
    if ((astrogam_version EQ 'V1.0') or (astrogam_version EQ 'V2.0')) then begin
          ; Total number of strips
      
          Total_vol_x_bottom = (N_tray)*N_strip
          Total_vol_y_bottom = (N_tray)*N_strip  
          Total_vol_x_top = (N_tray)*N_strip
          Total_vol_y_top = (N_tray)*N_strip
          
          print, 'Number of tracker triggered events:', N_trig
          
          Glob_event_id_x_bottom = lonarr(Total_vol_x_bottom, N_trig) 
          Glob_vol_id_x_bottom = lonarr(Total_vol_x_bottom, N_trig) 
          Glob_moth_id_x_bottom = lonarr(Total_vol_x_bottom, N_trig) 
          Glob_Strip_id_x_bottom = lonarr(Total_vol_x_bottom, N_trig) 
          Glob_Si_id_x_bottom = lonarr(Total_vol_x_bottom, N_trig) 
          Glob_tray_id_x_bottom = lonarr(Total_vol_x_bottom, N_trig) 
          Glob_plane_id_x_bottom = lonarr(Total_vol_x_bottom, N_trig) 
          Glob_xpos_x_bottom = dblarr(Total_vol_x_bottom, N_trig) 
          Glob_zpos_x_bottom = dblarr(Total_vol_x_bottom, N_trig) 
          Glob_energy_dep_x_bottom = dblarr(Total_vol_x_bottom, N_trig) 
          
          Glob_event_id_y_bottom = lonarr(Total_vol_y_bottom, N_trig) 
          Glob_vol_id_y_bottom = lonarr(Total_vol_y_bottom, N_trig) 
          Glob_moth_id_y_bottom = lonarr(Total_vol_y_bottom, N_trig) 
          Glob_Strip_id_y_bottom = lonarr(Total_vol_y_bottom, N_trig) 
          Glob_Si_id_y_bottom = lonarr(Total_vol_y_bottom, N_trig) 
          Glob_tray_id_y_bottom = lonarr(Total_vol_y_bottom, N_trig) 
          Glob_plane_id_y_bottom = lonarr(Total_vol_y_bottom, N_trig) 
          Glob_ypos_y_bottom = dblarr(Total_vol_y_bottom, N_trig) 
          Glob_zpos_y_bottom = dblarr(Total_vol_y_bottom, N_trig) 
          Glob_energy_dep_y_bottom = dblarr(Total_vol_y_bottom, N_trig) 
       
          Glob_event_id_x_top = lonarr(Total_vol_x_top, N_trig) 
          Glob_vol_id_x_top = lonarr(Total_vol_x_top, N_trig) 
          Glob_moth_id_x_top = lonarr(Total_vol_x_top, N_trig) 
          Glob_Strip_id_x_top = lonarr(Total_vol_x_top, N_trig) 
          Glob_Si_id_x_top = lonarr(Total_vol_x_top, N_trig) 
          Glob_tray_id_x_top = lonarr(Total_vol_x_top, N_trig) 
          Glob_plane_id_x_top = lonarr(Total_vol_x_top, N_trig) 
          Glob_xpos_x_top = dblarr(Total_vol_x_top, N_trig) 
          Glob_zpos_x_top = dblarr(Total_vol_x_top, N_trig) 
          Glob_energy_dep_x_top = dblarr(Total_vol_x_top, N_trig) 
          
          Glob_event_id_y_top = lonarr(Total_vol_y_top, N_trig) 
          Glob_vol_id_y_top = lonarr(Total_vol_y_top, N_trig) 
          Glob_moth_id_y_top = lonarr(Total_vol_y_top, N_trig) 
          Glob_Strip_id_y_top = lonarr(Total_vol_y_top, N_trig) 
          Glob_Si_id_y_top = lonarr(Total_vol_y_top, N_trig) 
          Glob_tray_id_y_top = lonarr(Total_vol_y_top, N_trig) 
          Glob_plane_id_y_top = lonarr(Total_vol_y_top, N_trig) 
          Glob_ypos_y_top = dblarr(Total_vol_y_top, N_trig) 
          Glob_zpos_y_top = dblarr(Total_vol_y_top, N_trig) 
          Glob_energy_dep_y_top = dblarr(Total_vol_y_top, N_trig) 
             
          filename_x_bottom = './conf/ARCH.XSTRIP.BOTTOM.ASTROGAM'+astrogam_version+'.TRACKER.FITS'
          filename_y_bottom = './conf/ARCH.YSTRIP.BOTTOM.ASTROGAM'+astrogam_version+'.TRACKER.FITS'
          filename_x_top = './conf/ARCH.XSTRIP.TOP.ASTROGAM'+astrogam_version+'.TRACKER.FITS'
          filename_y_top = './conf/ARCH.YSTRIP.TOP.ASTROGAM'+astrogam_version+'.TRACKER.FITS'
          
          struct_x_bottom = mrdfits(filename_x_bottom,$ 
                                 1, $
                                 structyp = 'astrogam_xbot', $
                                 /unsigned)
          
          struct_y_bottom = mrdfits(filename_y_bottom,$ 
                                 1, $
                                 structyp = 'astrogam_ybot', $
                                 /unsigned)
      
          struct_x_top = mrdfits(filename_x_top,$ 
                                 1, $
                                 structyp = 'astrogam_xtop', $
                                 /unsigned)
          
          struct_y_top = mrdfits(filename_y_top,$ 
                                 1, $
                                 structyp = 'astrogam_ytop', $
                                 /unsigned)
                                     
          Arch_vol_id_x_bottom = struct_x_bottom.VOLUME_ID
          Arch_moth_id_x_bottom = struct_x_bottom.MOTHER_ID
          Arch_Strip_id_x_bottom = struct_x_bottom.STRIP_ID 
          Arch_Si_id_x_bottom = struct_x_bottom.TRK_FLAG
          Arch_tray_id_x_bottom = struct_x_bottom.TRAY_ID 
          Arch_plane_id_x_bottom = struct_x_bottom.PLANE_ID 
          Arch_xpos_x_bottom = struct_x_bottom.XPOS 
          Arch_zpos_x_bottom = struct_x_bottom.ZPOS 
          Arch_energy_dep_x_bottom = struct_x_bottom.E_DEP 
          
          Arch_vol_id_y_bottom = struct_y_bottom.VOLUME_ID
          Arch_moth_id_y_bottom = struct_y_bottom.MOTHER_ID
          Arch_Strip_id_y_bottom = struct_y_bottom.STRIP_ID 
          Arch_Si_id_y_bottom = struct_y_bottom.TRK_FLAG
          Arch_tray_id_y_bottom = struct_y_bottom.TRAY_ID 
          Arch_plane_id_y_bottom = struct_y_bottom.PLANE_ID 
          Arch_ypos_y_bottom = struct_y_bottom.YPOS 
          Arch_zpos_y_bottom = struct_y_bottom.ZPOS 
          Arch_energy_dep_y_bottom = struct_y_bottom.E_DEP 
          
          Arch_vol_id_x_top = struct_x_top.VOLUME_ID
          Arch_moth_id_x_top = struct_x_top.MOTHER_ID
          Arch_Strip_id_x_top = struct_x_top.STRIP_ID 
          Arch_Si_id_x_top = struct_x_top.TRK_FLAG
          Arch_tray_id_x_top = struct_x_top.TRAY_ID 
          Arch_plane_id_x_top = struct_x_top.PLANE_ID 
          Arch_xpos_x_top = struct_x_top.XPOS 
          Arch_zpos_x_top = struct_x_top.ZPOS 
          Arch_energy_dep_x_top = struct_x_top.E_DEP 
          
          Arch_vol_id_y_top = struct_y_top.VOLUME_ID
          Arch_moth_id_y_top = struct_y_top.MOTHER_ID
          Arch_Strip_id_y_top = struct_y_top.STRIP_ID 
          Arch_Si_id_y_top = struct_y_top.TRK_FLAG
          Arch_tray_id_y_top = struct_y_top.TRAY_ID 
          Arch_plane_id_y_top = struct_y_top.PLANE_ID 
          Arch_ypos_y_top = struct_y_top.YPOS 
          Arch_zpos_y_top = struct_y_top.ZPOS 
          Arch_energy_dep_y_top = struct_y_top.E_DEP    
          
          for i=0, N_trig-1 do begin
          
              Glob_vol_id_x_bottom[*,i] = Arch_vol_id_x_bottom
              Glob_moth_id_x_bottom[*,i] = Arch_moth_id_x_bottom
              Glob_Strip_id_x_bottom[*,i] = Arch_Strip_id_x_bottom
              Glob_Si_id_x_bottom[*,i] = Arch_Si_id_x_bottom
              Glob_tray_id_x_bottom[*,i] = Arch_tray_id_x_bottom 
              Glob_plane_id_x_bottom[*,i] = Arch_plane_id_x_bottom 
              Glob_xpos_x_bottom[*,i] = Arch_xpos_x_bottom 
              Glob_zpos_x_bottom[*,i] = Arch_zpos_x_bottom
              Glob_energy_dep_x_bottom[*,i] = Arch_energy_dep_x_bottom
          
              Glob_vol_id_y_bottom[*,i] = Arch_vol_id_y_bottom
              Glob_moth_id_y_bottom[*,i] = Arch_moth_id_y_bottom
              Glob_Strip_id_y_bottom[*,i] = Arch_Strip_id_y_bottom
              Glob_Si_id_y_bottom[*,i] = Arch_Si_id_y_bottom
              Glob_tray_id_y_bottom[*,i] = Arch_tray_id_y_bottom 
              Glob_plane_id_y_bottom[*,i] = Arch_plane_id_y_bottom 
              Glob_ypos_y_bottom[*,i] = Arch_ypos_y_bottom 
              Glob_zpos_y_bottom[*,i] = Arch_zpos_y_bottom 
              Glob_energy_dep_y_bottom[*,i] = Arch_energy_dep_y_bottom 
      
              Glob_vol_id_x_top[*,i] = Arch_vol_id_x_top
              Glob_moth_id_x_top[*,i] = Arch_moth_id_x_top
              Glob_Strip_id_x_top[*,i] = Arch_Strip_id_x_top
              Glob_Si_id_x_top[*,i] = Arch_Si_id_x_top
              Glob_tray_id_x_top[*,i] = Arch_tray_id_x_top 
              Glob_plane_id_x_top[*,i] = Arch_plane_id_x_top 
              Glob_xpos_x_top[*,i] = Arch_xpos_x_top 
              Glob_zpos_x_top[*,i] = Arch_zpos_x_top
              Glob_energy_dep_x_top[*,i] = Arch_energy_dep_x_top
          
              Glob_vol_id_y_top[*,i] = Arch_vol_id_y_top
              Glob_moth_id_y_top[*,i] = Arch_moth_id_y_top
              Glob_Strip_id_y_top[*,i] = Arch_Strip_id_y_top
              Glob_Si_id_y_top[*,i] = Arch_Si_id_y_top
              Glob_tray_id_y_top[*,i] = Arch_tray_id_y_top 
              Glob_plane_id_y_top[*,i] = Arch_plane_id_y_top 
              Glob_ypos_y_top[*,i] = Arch_ypos_y_top 
              Glob_zpos_y_top[*,i] = Arch_zpos_y_top 
              Glob_energy_dep_y_top[*,i] = Arch_energy_dep_y_top     
          
          endfor
          
          
           j=0l
           N_ev =0l
           while (1) do begin
              where_event_eq = where(event_id_tot EQ event_id_tot(j))
              
              event_id_temp = event_id_tot(where_event_eq)
              vol_id_temp = vol_id_tot(where_event_eq) 
              moth_id_temp = moth_id_tot(where_event_eq) 
              Strip_id_temp = Strip_id_tot(where_event_eq) 
              Si_id_temp = Si_id_tot(where_event_eq) 
              tray_id_temp = tray_id_tot(where_event_eq) 
              plane_id_temp = plane_id_tot(where_event_eq) 
              energy_dep_temp = energy_dep_tot(where_event_eq) 
          
              vol_sort_arr = sort(vol_id_temp)
              
              vol_id_temp = vol_id_temp[vol_sort_arr]
              moth_id_temp = moth_id_temp[vol_sort_arr]
              Strip_id_temp = Strip_id_temp[vol_sort_arr]
              Si_id_temp = Si_id_temp[vol_sort_arr]
              tray_id_temp = tray_id_temp[vol_sort_arr]
              plane_id_temp = plane_id_temp[vol_sort_arr]
              energy_dep_temp = energy_dep_temp[vol_sort_arr]
          
              for z=0l, Total_vol_x_bottom -1 do begin
                where_hit_x_bottom = where(vol_id_temp EQ Glob_vol_id_x_bottom(z, N_ev))
                if (where_hit_x_bottom(0) NE -1) then Glob_energy_dep_x_bottom(z, N_ev) = energy_dep_temp(where_hit_x_bottom)
                where_hit_y_bottom = where(vol_id_temp EQ Glob_vol_id_y_bottom(z, N_ev))
                if (where_hit_y_bottom(0) NE -1) then Glob_energy_dep_y_bottom(z, N_ev) = energy_dep_temp(where_hit_y_bottom)
                where_hit_x_top = where(vol_id_temp EQ Glob_vol_id_x_top(z, N_ev))
                if (where_hit_x_top(0) NE -1) then Glob_energy_dep_x_top(z, N_ev) = energy_dep_temp(where_hit_x_top)
                where_hit_y_top = where(vol_id_temp EQ Glob_vol_id_y_top(z, N_ev))
                if (where_hit_y_top(0) NE -1) then Glob_energy_dep_y_top(z, N_ev) = energy_dep_temp(where_hit_y_top)
              endfor
               
              N_event_eq = n_elements(where_event_eq)
              if where_event_eq(N_event_eq-1) LT (n_elements(event_id_tot)-1) then begin
                j = where_event_eq(N_event_eq-1)+1
                N_ev = N_ev + 1
              endif else break
           endwhile
      
      
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
          print, '                      Tracker   '
          print, '       L0.5 - cluster baricenter '
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
           
          
          Glob_event_id_x_bottom_cluster = -1l 
          Glob_Si_id_x_bottom_cluster = -1l 
          Glob_tray_id_x_bottom_cluster = -1l
          Glob_plane_id_x_bottom_cluster = -1l 
          Glob_xpos_x_bottom_cluster = -1.
          Glob_zpos_x_bottom_cluster = -1.
          Glob_energy_dep_x_bottom_cluster = -1. 
          
          Glob_event_id_y_bottom_cluster = -1l 
          Glob_Si_id_y_bottom_cluster = -1l 
          Glob_tray_id_y_bottom_cluster = -1l 
          Glob_plane_id_y_bottom_cluster = -1l
          Glob_ypos_y_bottom_cluster = -1. 
          Glob_zpos_y_bottom_cluster = -1.
          Glob_energy_dep_y_bottom_cluster = -1. 
                    
          Glob_event_id_x_top_cluster = -1l 
          Glob_Si_id_x_top_cluster = -1l 
          Glob_tray_id_x_top_cluster = -1l
          Glob_plane_id_x_top_cluster = -1l 
          Glob_xpos_x_top_cluster = -1.
          Glob_zpos_x_top_cluster = -1.
          Glob_energy_dep_x_top_cluster = -1. 
          
          Glob_event_id_y_top_cluster = -1l 
          Glob_Si_id_y_top_cluster = -1l 
          Glob_tray_id_y_top_cluster = -1l 
          Glob_plane_id_y_top_cluster = -1l
          Glob_ypos_y_top_cluster = -1. 
          Glob_zpos_y_top_cluster = -1.
          Glob_energy_dep_y_top_cluster = -1. 
          
          for k=0l, N_trig-1 do begin
           
      
           N_start = 0l
           j=0l
           while (1) do begin
              where_tray_eq_x_bottom = where(Glob_tray_id_x_bottom(*, k) EQ Glob_tray_id_x_bottom(j, k))
              
                  Glob_vol_id_x_bottom_tray = Glob_vol_id_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_moth_id_x_bottom_tray = Glob_moth_id_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_Strip_id_x_bottom_tray = Glob_Strip_id_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_Si_id_x_bottom_tray = Glob_Si_id_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_tray_id_x_bottom_tray = Glob_tray_id_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_plane_id_x_bottom_tray = Glob_plane_id_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_xpos_x_bottom_tray = Glob_xpos_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_zpos_x_bottom_tray = Glob_zpos_x_bottom[where_tray_eq_x_bottom, k]
                  Glob_energy_dep_x_bottom_tray = Glob_energy_dep_x_bottom[where_tray_eq_x_bottom, k]
                  
                  where_layer_x_bottom = where((Glob_Si_id_x_bottom_tray EQ 0) and (Glob_energy_dep_x_bottom_tray GT 0.))
                  if (where_layer_x_bottom(0) NE -1) then begin
                    Glob_vol_id_x_bottom_tray = Glob_vol_id_x_bottom_tray[where_layer_x_bottom]
                    Glob_moth_id_x_bottom_tray = Glob_moth_id_x_bottom_tray[where_layer_x_bottom]
                    Glob_Strip_id_x_bottom_tray = Glob_Strip_id_x_bottom_tray[where_layer_x_bottom]
                    Glob_Si_id_x_bottom_tray = Glob_Si_id_x_bottom_tray[where_layer_x_bottom]
                    Glob_tray_id_x_bottom_tray = Glob_tray_id_x_bottom_tray[where_layer_x_bottom]
                    Glob_plane_id_x_bottom_tray = Glob_plane_id_x_bottom_tray[where_layer_x_bottom]
                    Glob_xpos_x_bottom_tray = Glob_xpos_x_bottom_tray[where_layer_x_bottom]
                    Glob_zpos_x_bottom_tray = Glob_zpos_x_bottom_tray[where_layer_x_bottom]
                    Glob_energy_dep_x_bottom_tray = Glob_energy_dep_x_bottom_tray[where_layer_x_bottom] 
              
                    e_cluster_temp = Glob_energy_dep_x_bottom_tray(0)
                    wx_cluster_temp = Glob_xpos_x_bottom_tray(0)*Glob_energy_dep_x_bottom_tray(0)
                    if (n_elements(Glob_Strip_id_x_bottom_tray) EQ 1) then begin
                       Glob_event_id_x_bottom_cluster = [Glob_event_id_x_bottom_cluster, k]
                       Glob_Si_id_x_bottom_cluster = [Glob_Si_id_x_bottom_cluster, Glob_Si_id_x_bottom_tray]
                       Glob_tray_id_x_bottom_cluster = [Glob_tray_id_x_bottom_cluster, Glob_tray_id_x_bottom_tray]
                       Glob_plane_id_x_bottom_cluster = [Glob_plane_id_x_bottom_cluster, Glob_plane_id_x_bottom_tray]
                       Glob_zpos_x_bottom_cluster = [Glob_zpos_x_bottom_cluster, Glob_zpos_x_bottom_tray]
                       Glob_energy_dep_x_bottom_cluster = [Glob_energy_dep_x_bottom_cluster, total(e_cluster_temp)]
                       Glob_xpos_x_bottom_cluster = [Glob_xpos_x_bottom_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]         
                    endif else begin
                    ;print, 'Glob_Strip_id_x_bottom_tray', Glob_Strip_id_x_bottom_tray
                    for jc=0l, n_elements(Glob_Strip_id_x_bottom_tray) -2 do begin
                       if (Glob_Strip_id_x_bottom_tray(jc+1) EQ (Glob_Strip_id_x_bottom_tray(jc)+1)) then begin
                          e_cluster_temp = [e_cluster_temp, Glob_energy_dep_x_bottom_tray(jc+1)]
                          wx_cluster_temp = [wx_cluster_temp, Glob_xpos_x_bottom_tray(jc + 1)*Glob_energy_dep_x_bottom_tray(jc+1)]
                          if (jc EQ (n_elements(Glob_Strip_id_x_bottom_tray)-2)) then begin
                               Glob_event_id_x_bottom_cluster = [Glob_event_id_x_bottom_cluster, k]
                               Glob_Si_id_x_bottom_cluster = [Glob_Si_id_x_bottom_cluster, Glob_Si_id_x_bottom_tray(jc)]
                               Glob_tray_id_x_bottom_cluster = [Glob_tray_id_x_bottom_cluster, Glob_tray_id_x_bottom_tray(jc)]
                               Glob_plane_id_x_bottom_cluster = [Glob_plane_id_x_bottom_cluster, Glob_plane_id_x_bottom_tray(jc)]
                               Glob_zpos_x_bottom_cluster = [Glob_zpos_x_bottom_cluster, Glob_zpos_x_bottom_tray(jc)]
                               Glob_energy_dep_x_bottom_cluster = [Glob_energy_dep_x_bottom_cluster, total(e_cluster_temp)]
                               Glob_xpos_x_bottom_cluster = [Glob_xpos_x_bottom_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                          endif
                       endif else begin
                            Glob_event_id_x_bottom_cluster = [Glob_event_id_x_bottom_cluster, k]
                            Glob_Si_id_x_bottom_cluster = [Glob_Si_id_x_bottom_cluster, Glob_Si_id_x_bottom_tray(jc)]
                            Glob_tray_id_x_bottom_cluster = [Glob_tray_id_x_bottom_cluster, Glob_tray_id_x_bottom_tray(jc)]
                            Glob_plane_id_x_bottom_cluster = [Glob_plane_id_x_bottom_cluster, Glob_plane_id_x_bottom_tray(jc)]
                            Glob_zpos_x_bottom_cluster = [Glob_zpos_x_bottom_cluster, Glob_zpos_x_bottom_tray(jc)]
                            Glob_energy_dep_x_bottom_cluster = [Glob_energy_dep_x_bottom_cluster, total(e_cluster_temp)]
                            e_cluster_temp = Glob_energy_dep_x_bottom_tray(jc+1)
                            Glob_xpos_x_bottom_cluster = [Glob_xpos_x_bottom_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                            wx_cluster_temp = Glob_xpos_x_bottom_tray(jc+1)*Glob_energy_dep_x_bottom_tray(jc+1)
                            if (jc EQ (n_elements(Glob_Strip_id_x_bottom_tray)-2)) then begin
                               Glob_event_id_x_bottom_cluster = [Glob_event_id_x_bottom_cluster, k]
                               Glob_Si_id_x_bottom_cluster = [Glob_Si_id_x_bottom_cluster, Glob_Si_id_x_bottom_tray(jc+1)]
                               Glob_tray_id_x_bottom_cluster = [Glob_tray_id_x_bottom_cluster, Glob_tray_id_x_bottom_tray(jc+1)]
                               Glob_plane_id_x_bottom_cluster = [Glob_plane_id_x_bottom_cluster, Glob_plane_id_x_bottom_tray(jc+1)]
                               Glob_zpos_x_bottom_cluster = [Glob_zpos_x_bottom_cluster, Glob_zpos_x_bottom_tray(jc+1)]
                               Glob_energy_dep_x_bottom_cluster = [Glob_energy_dep_x_bottom_cluster, Glob_energy_dep_x_bottom_tray(jc+1)]
                               Glob_xpos_x_bottom_cluster = [Glob_xpos_x_bottom_cluster, Glob_xpos_x_bottom_tray(jc +1)]
                            endif
                        endelse
                     endfor
                   endelse       
                  endif
      
                 
              N_tray_eq_x = n_elements(where_tray_eq_x_bottom)
              if where_tray_eq_x_bottom(N_tray_eq_x-1) LT (n_elements(Glob_tray_id_x_bottom(*,k))-1) then begin
                j = where_tray_eq_x_bottom(N_tray_eq_x-1)+1
              endif else break
           endwhile
          
          endfor
          
          Glob_event_id_x_bottom_cluster = Glob_event_id_x_bottom_cluster[1:*]  
          Glob_Si_id_x_bottom_cluster = Glob_Si_id_x_bottom_cluster[1:*]  
          Glob_tray_id_x_bottom_cluster = Glob_tray_id_x_bottom_cluster[1:*]
          Glob_plane_id_x_bottom_cluster = Glob_plane_id_x_bottom_cluster[1:*] 
          Glob_xpos_x_bottom_cluster = Glob_xpos_x_bottom_cluster[1:*]
          Glob_zpos_x_bottom_cluster = Glob_zpos_x_bottom_cluster[1:*]
          Glob_energy_dep_x_bottom_cluster = Glob_energy_dep_x_bottom_cluster[1:*] 
      
      
          for k=0l, N_trig-1 do begin
          
           N_start = 0l
           j=0l
           while (1) do begin
              where_tray_eq_y_bottom = where(Glob_tray_id_y_bottom(*, k) EQ Glob_tray_id_y_bottom(j, k))
              
              Glob_vol_id_y_bottom_tray = Glob_vol_id_y_bottom[where_tray_eq_y_bottom, k]
              Glob_moth_id_y_bottom_tray = Glob_moth_id_y_bottom[where_tray_eq_y_bottom, k]
              Glob_Strip_id_y_bottom_tray = Glob_Strip_id_y_bottom[where_tray_eq_y_bottom, k]
              Glob_Si_id_y_bottom_tray = Glob_Si_id_y_bottom[where_tray_eq_y_bottom, k]
              Glob_tray_id_y_bottom_tray = Glob_tray_id_y_bottom[where_tray_eq_y_bottom, k]
              Glob_plane_id_y_bottom_tray = Glob_plane_id_y_bottom[where_tray_eq_y_bottom, k]
              Glob_ypos_y_bottom_tray = Glob_ypos_y_bottom[where_tray_eq_y_bottom, k]
              Glob_zpos_y_bottom_tray = Glob_zpos_y_bottom[where_tray_eq_y_bottom, k]
              Glob_energy_dep_y_bottom_tray = Glob_energy_dep_y_bottom[where_tray_eq_y_bottom, k]
              
              where_layer_y_bottom = where((Glob_Si_id_y_bottom_tray EQ 1) and (Glob_energy_dep_y_bottom_tray GT 0.))
              if (where_layer_y_bottom(0) NE -1) then begin
                Glob_vol_id_y_bottom_tray = Glob_vol_id_y_bottom_tray[where_layer_y_bottom]
                Glob_moth_id_y_bottom_tray = Glob_moth_id_y_bottom_tray[where_layer_y_bottom]
                Glob_Strip_id_y_bottom_tray = Glob_Strip_id_y_bottom_tray[where_layer_y_bottom]
                Glob_Si_id_y_bottom_tray = Glob_Si_id_y_bottom_tray[where_layer_y_bottom]
                Glob_tray_id_y_bottom_tray = Glob_tray_id_y_bottom_tray[where_layer_y_bottom]
                Glob_plane_id_y_bottom_tray = Glob_plane_id_y_bottom_tray[where_layer_y_bottom]
                Glob_ypos_y_bottom_tray = Glob_ypos_y_bottom_tray[where_layer_y_bottom]
                Glob_zpos_y_bottom_tray = Glob_zpos_y_bottom_tray[where_layer_y_bottom]
                Glob_energy_dep_y_bottom_tray = Glob_energy_dep_y_bottom_tray[where_layer_y_bottom] 
          
                e_cluster_temp = Glob_energy_dep_y_bottom_tray(0)
                wy_cluster_temp = Glob_ypos_y_bottom_tray(0)*Glob_energy_dep_y_bottom_tray(0)
                if (n_elements(Glob_Strip_id_y_bottom_tray) EQ 1) then begin
                    Glob_event_id_y_bottom_cluster = [Glob_event_id_y_bottom_cluster, k]
                    Glob_Si_id_y_bottom_cluster = [Glob_Si_id_y_bottom_cluster, Glob_Si_id_y_bottom_tray]
                    Glob_tray_id_y_bottom_cluster = [Glob_tray_id_y_bottom_cluster, Glob_tray_id_y_bottom_tray]
                    Glob_plane_id_y_bottom_cluster = [Glob_plane_id_y_bottom_cluster, Glob_plane_id_y_bottom_tray]
                    Glob_zpos_y_bottom_cluster = [Glob_zpos_y_bottom_cluster, Glob_zpos_y_bottom_tray]
                    Glob_energy_dep_y_bottom_cluster = [Glob_energy_dep_y_bottom_cluster, total(e_cluster_temp)]
                    Glob_ypos_y_bottom_cluster = [Glob_ypos_y_bottom_cluster, total(wy_cluster_temp)/total(e_cluster_temp)]         
                endif else begin
                  for jc=0l, n_elements(Glob_Strip_id_y_bottom_tray) -2 do begin
                   if (Glob_Strip_id_y_bottom_tray(jc+1) EQ (Glob_Strip_id_y_bottom_tray(jc)+1)) then begin
                      e_cluster_temp = [e_cluster_temp, Glob_energy_dep_y_bottom_tray(jc+1)]
                      wy_cluster_temp = [wy_cluster_temp, Glob_ypos_y_bottom_tray(jc + 1)*Glob_energy_dep_y_bottom_tray(jc+1)]
                      if (jc EQ (n_elements(Glob_Strip_id_y_bottom_tray)-2)) then begin
                          Glob_event_id_y_bottom_cluster = [Glob_event_id_y_bottom_cluster, k]
                          Glob_Si_id_y_bottom_cluster = [Glob_Si_id_y_bottom_cluster, Glob_Si_id_y_bottom_tray(jc)]
                          Glob_tray_id_y_bottom_cluster = [Glob_tray_id_y_bottom_cluster, Glob_tray_id_y_bottom_tray(jc)]
                          Glob_plane_id_y_bottom_cluster = [Glob_plane_id_y_bottom_cluster, Glob_plane_id_y_bottom_tray(jc)]
                          Glob_zpos_y_bottom_cluster = [Glob_zpos_y_bottom_cluster, Glob_zpos_y_bottom_tray(jc)]
                          Glob_energy_dep_y_bottom_cluster = [Glob_energy_dep_y_bottom_cluster, total(e_cluster_temp)]
                          Glob_ypos_y_bottom_cluster = [Glob_ypos_y_bottom_cluster, total(wy_cluster_temp)/total(e_cluster_temp)]
                      endif
                   endif else begin
                        Glob_event_id_y_bottom_cluster = [Glob_event_id_y_bottom_cluster, k]
                        Glob_Si_id_y_bottom_cluster = [Glob_Si_id_y_bottom_cluster, Glob_Si_id_y_bottom_tray(jc)]
                        Glob_tray_id_y_bottom_cluster = [Glob_tray_id_y_bottom_cluster, Glob_tray_id_y_bottom_tray(jc)]
                        Glob_plane_id_y_bottom_cluster = [Glob_plane_id_y_bottom_cluster, Glob_plane_id_y_bottom_tray(jc)]
                        Glob_zpos_y_bottom_cluster = [Glob_zpos_y_bottom_cluster, Glob_zpos_y_bottom_tray(jc)]
                        Glob_energy_dep_y_bottom_cluster = [Glob_energy_dep_y_bottom_cluster, total(e_cluster_temp)]
                        e_cluster_temp = Glob_energy_dep_y_bottom_tray(jc+1)
                        Glob_ypos_y_bottom_cluster = [Glob_ypos_y_bottom_cluster, total(wy_cluster_temp)/total(e_cluster_temp)]
                        wy_cluster_temp = Glob_ypos_y_bottom_tray(jc+1)*Glob_energy_dep_y_bottom_tray(jc+1)
                        if (jc EQ (n_elements(Glob_Strip_id_y_bottom_tray)-2)) then begin
                           Glob_event_id_y_bottom_cluster = [Glob_event_id_y_bottom_cluster, k]
                           Glob_Si_id_y_bottom_cluster = [Glob_Si_id_y_bottom_cluster, Glob_Si_id_y_bottom_tray(jc+1)]
                           Glob_tray_id_y_bottom_cluster = [Glob_tray_id_y_bottom_cluster, Glob_tray_id_y_bottom_tray(jc+1)]
                           Glob_plane_id_y_bottom_cluster = [Glob_plane_id_y_bottom_cluster, Glob_plane_id_y_bottom_tray(jc+1)]
                           Glob_zpos_y_bottom_cluster = [Glob_zpos_y_bottom_cluster, Glob_zpos_y_bottom_tray(jc+1)]
                           Glob_energy_dep_y_bottom_cluster = [Glob_energy_dep_y_bottom_cluster, Glob_energy_dep_y_bottom_tray(jc+1)]
                           Glob_ypos_y_bottom_cluster = [Glob_ypos_y_bottom_cluster, Glob_ypos_y_bottom_tray(jc +1)]
                        endif
                    endelse
                 endfor
                endelse
              endif
                 
              N_tray_eq_x = n_elements(where_tray_eq_y_bottom)
              if where_tray_eq_y_bottom(N_tray_eq_x-1) LT (n_elements(Glob_tray_id_y_bottom(*,k))-1) then begin
                j = where_tray_eq_y_bottom(N_tray_eq_x-1)+1
              endif else break
           endwhile
          
          endfor
          
          Glob_event_id_y_bottom_cluster = Glob_event_id_y_bottom_cluster[1:*]  
          Glob_Si_id_y_bottom_cluster = Glob_Si_id_y_bottom_cluster[1:*]  
          Glob_tray_id_y_bottom_cluster = Glob_tray_id_y_bottom_cluster[1:*]
          Glob_plane_id_y_bottom_cluster = Glob_plane_id_y_bottom_cluster[1:*] 
          Glob_ypos_y_bottom_cluster = Glob_ypos_y_bottom_cluster[1:*]
          Glob_zpos_y_bottom_cluster = Glob_zpos_y_bottom_cluster[1:*]
          Glob_energy_dep_y_bottom_cluster = Glob_energy_dep_y_bottom_cluster[1:*] 
      
          for k=0l, N_trig-1 do begin
          
           N_start = 0l
           j=0l
           while (1) do begin
              where_tray_eq_x_top = where(Glob_tray_id_x_top(*, k) EQ Glob_tray_id_x_top(j, k))
              
              Glob_vol_id_x_top_tray = Glob_vol_id_x_top[where_tray_eq_x_top, k]
              Glob_moth_id_x_top_tray = Glob_moth_id_x_top[where_tray_eq_x_top, k]
              Glob_Strip_id_x_top_tray = Glob_Strip_id_x_top[where_tray_eq_x_top, k]
              Glob_Si_id_x_top_tray = Glob_Si_id_x_top[where_tray_eq_x_top, k]
              Glob_tray_id_x_top_tray = Glob_tray_id_x_top[where_tray_eq_x_top, k]
              Glob_plane_id_x_top_tray = Glob_plane_id_x_top[where_tray_eq_x_top, k]
              Glob_xpos_x_top_tray = Glob_xpos_x_top[where_tray_eq_x_top, k]
              Glob_zpos_x_top_tray = Glob_zpos_x_top[where_tray_eq_x_top, k]
              Glob_energy_dep_x_top_tray = Glob_energy_dep_x_top[where_tray_eq_x_top, k]
              
              where_layer_x_top = where((Glob_Si_id_x_top_tray EQ 2) and (Glob_energy_dep_x_top_tray GT 0.))
              if (where_layer_x_top(0) NE -1) then begin
                Glob_vol_id_x_top_tray = Glob_vol_id_x_top_tray[where_layer_x_top]
                Glob_moth_id_x_top_tray = Glob_moth_id_x_top_tray[where_layer_x_top]
                Glob_Strip_id_x_top_tray = Glob_Strip_id_x_top_tray[where_layer_x_top]
                Glob_Si_id_x_top_tray = Glob_Si_id_x_top_tray[where_layer_x_top]
                Glob_tray_id_x_top_tray = Glob_tray_id_x_top_tray[where_layer_x_top]
                Glob_plane_id_x_top_tray = Glob_plane_id_x_top_tray[where_layer_x_top]
                Glob_xpos_x_top_tray = Glob_xpos_x_top_tray[where_layer_x_top]
                Glob_zpos_x_top_tray = Glob_zpos_x_top_tray[where_layer_x_top]
                Glob_energy_dep_x_top_tray = Glob_energy_dep_x_top_tray[where_layer_x_top] 
          
                e_cluster_temp = Glob_energy_dep_x_top_tray(0)
                wx_cluster_temp = Glob_xpos_x_top_tray(0)*Glob_energy_dep_x_top_tray(0)
                if (n_elements(Glob_Strip_id_x_top_tray) EQ 1) then begin
                    Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                    Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray]
                    Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray]
                    Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray]
                    Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray]
                    Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, total(e_cluster_temp)]
                    Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]         
                endif else begin
                 for jc=0l, n_elements(Glob_Strip_id_x_top_tray) -2 do begin
                   if (Glob_Strip_id_x_top_tray(jc+1) EQ (Glob_Strip_id_x_top_tray(jc)+1)) then begin
                      e_cluster_temp = [e_cluster_temp, Glob_energy_dep_x_top_tray(jc+1)]
                      wx_cluster_temp = [wx_cluster_temp, Glob_xpos_x_top_tray(jc + 1)*Glob_energy_dep_x_top_tray(jc+1)]
                      if (jc EQ (n_elements(Glob_Strip_id_x_top_tray)-2)) then begin
                               Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                               Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray(jc)]
                               Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray(jc)]
                               Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray(jc)]
                               Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray(jc)]
                               Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, total(e_cluster_temp)]
                               Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                      endif             
                      endif else begin
                        Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                        Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray(jc)]
                        Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray(jc)]
                        Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray(jc)]
                        Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray(jc)]
                        Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, total(e_cluster_temp)]
                        e_cluster_temp = Glob_energy_dep_x_top_tray(jc+1)
                        Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                        wx_cluster_temp = Glob_xpos_x_top_tray(jc+1)*Glob_energy_dep_x_top_tray(jc+1)
                        if (jc EQ (n_elements(Glob_Strip_id_x_top_tray)-2)) then begin
                           Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                           Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray(jc+1)]
                           Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray(jc+1)]
                           Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray(jc+1)]
                           Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray(jc+1)]
                           Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, Glob_energy_dep_x_top_tray(jc+1)]
                           Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, Glob_xpos_x_top_tray(jc +1)]
                        endif
                    endelse
                 endfor
               endelse    
              endif
                 
              N_tray_eq_x = n_elements(where_tray_eq_x_top)
              if where_tray_eq_x_top(N_tray_eq_x-1) LT (n_elements(Glob_tray_id_x_top(*,k))-1) then begin
                j = where_tray_eq_x_top(N_tray_eq_x-1)+1
              endif else break
           endwhile
          
          endfor
          
          Glob_event_id_x_top_cluster = Glob_event_id_x_top_cluster[1:*]  
          Glob_Si_id_x_top_cluster = Glob_Si_id_x_top_cluster[1:*]  
          Glob_tray_id_x_top_cluster = Glob_tray_id_x_top_cluster[1:*]
          Glob_plane_id_x_top_cluster = Glob_plane_id_x_top_cluster[1:*] 
          Glob_xpos_x_top_cluster = Glob_xpos_x_top_cluster[1:*]
          Glob_zpos_x_top_cluster = Glob_zpos_x_top_cluster[1:*]
          Glob_energy_dep_x_top_cluster = Glob_energy_dep_x_top_cluster[1:*] 
      
          for k=0l, N_trig-1 do begin
          
           N_start = 0l
           j=0l
           while (1) do begin
              where_tray_eq_y_top = where(Glob_tray_id_y_top(*, k) EQ Glob_tray_id_y_top(j, k))
              
              Glob_vol_id_y_top_tray = Glob_vol_id_y_top[where_tray_eq_y_top, k]
              Glob_moth_id_y_top_tray = Glob_moth_id_y_top[where_tray_eq_y_top, k]
              Glob_Strip_id_y_top_tray = Glob_Strip_id_y_top[where_tray_eq_y_top, k]
              Glob_Si_id_y_top_tray = Glob_Si_id_y_top[where_tray_eq_y_top, k]
              Glob_tray_id_y_top_tray = Glob_tray_id_y_top[where_tray_eq_y_top, k]
              Glob_plane_id_y_top_tray = Glob_plane_id_y_top[where_tray_eq_y_top, k]
              Glob_ypos_y_top_tray = Glob_ypos_y_top[where_tray_eq_y_top, k]
              Glob_zpos_y_top_tray = Glob_zpos_y_top[where_tray_eq_y_top, k]
              Glob_energy_dep_y_top_tray = Glob_energy_dep_y_top[where_tray_eq_y_top, k]
              
              where_layer_y_top = where((Glob_Si_id_y_top_tray EQ 3) and (Glob_energy_dep_y_top_tray GT 0.))
              if (where_layer_y_top(0) NE -1) then begin
                Glob_vol_id_y_top_tray = Glob_vol_id_y_top_tray[where_layer_y_top]
                Glob_moth_id_y_top_tray = Glob_moth_id_y_top_tray[where_layer_y_top]
                Glob_Strip_id_y_top_tray = Glob_Strip_id_y_top_tray[where_layer_y_top]
                Glob_Si_id_y_top_tray = Glob_Si_id_y_top_tray[where_layer_y_top]
                Glob_tray_id_y_top_tray = Glob_tray_id_y_top_tray[where_layer_y_top]
                Glob_plane_id_y_top_tray = Glob_plane_id_y_top_tray[where_layer_y_top]
                Glob_ypos_y_top_tray = Glob_ypos_y_top_tray[where_layer_y_top]
                Glob_zpos_y_top_tray = Glob_zpos_y_top_tray[where_layer_y_top]
                Glob_energy_dep_y_top_tray = Glob_energy_dep_y_top_tray[where_layer_y_top] 
          
                e_cluster_temp = Glob_energy_dep_y_top_tray(0)
                wy_cluster_temp = Glob_ypos_y_top_tray(0)*Glob_energy_dep_y_top_tray(0)
                if (n_elements(Glob_Strip_id_y_top_tray) EQ 1) then begin
                    Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                    Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray]
                    Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray]
                    Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray]
                    Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray]
                    Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, total(e_cluster_temp)]
                    Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, total(wy_cluster_temp)/total(e_cluster_temp)]         
                endif else begin          
                for jc=0l, n_elements(Glob_Strip_id_y_top_tray) -2 do begin
                   if (Glob_Strip_id_y_top_tray(jc+1) EQ (Glob_Strip_id_y_top_tray(jc)+1)) then begin
                      e_cluster_temp = [e_cluster_temp, Glob_energy_dep_y_top_tray(jc+1)]
                      wy_cluster_temp = [wy_cluster_temp, Glob_ypos_y_top_tray(jc + 1)*Glob_energy_dep_y_top_tray(jc+1)]
                      if (jc EQ (n_elements(Glob_Strip_id_y_top_tray)-2)) then begin
                               Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                               Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray(jc)]
                               Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray(jc)]
                               Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray(jc)]
                               Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray(jc)]
                               Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, total(e_cluster_temp)]
                               Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, total(wy_cluster_temp)/total(e_cluster_temp)]
                      endif             
                      endif else begin
                        Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                        Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray(jc)]
                        Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray(jc)]
                        Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray(jc)]
                        Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray(jc)]
                        Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, total(e_cluster_temp)]
                        e_cluster_temp = Glob_energy_dep_y_top_tray(jc+1)
                        Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, total(wy_cluster_temp)/total(e_cluster_temp)]
                        wy_cluster_temp = Glob_ypos_y_top_tray(jc+1)*Glob_energy_dep_y_top_tray(jc+1)
                        if (jc EQ (n_elements(Glob_Strip_id_y_top_tray)-2)) then begin
                           Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                           Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray(jc+1)]
                           Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray(jc+1)]
                           Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray(jc+1)]
                           Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray(jc+1)]
                           Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, Glob_energy_dep_y_top_tray(jc+1)]
                           Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, Glob_ypos_y_top_tray(jc +1)]
                        endif
                    endelse
                 endfor
                endelse      
              endif
                 
              N_tray_eq_x = n_elements(where_tray_eq_y_top)
              if where_tray_eq_y_top(N_tray_eq_x-1) LT (n_elements(Glob_tray_id_y_top(*,k))-1) then begin
                j = where_tray_eq_y_top(N_tray_eq_x-1)+1
              endif else break
           endwhile
          
          endfor
          
          Glob_event_id_y_top_cluster = Glob_event_id_y_top_cluster[1:*]  
          Glob_Si_id_y_top_cluster = Glob_Si_id_y_top_cluster[1:*]  
          Glob_tray_id_y_top_cluster = Glob_tray_id_y_top_cluster[1:*]
          Glob_plane_id_y_top_cluster = Glob_plane_id_y_top_cluster[1:*] 
          Glob_ypos_y_top_cluster = Glob_ypos_y_top_cluster[1:*]
          Glob_zpos_y_top_cluster = Glob_zpos_y_top_cluster[1:*]
          Glob_energy_dep_y_top_cluster = Glob_energy_dep_y_top_cluster[1:*] 
      
          
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
          print, '                      Tracker   '
          print, '             L0 - X-Y layers merging '
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'    
          
          
          Glob_event_id_cluster = -1l 
          Glob_Si_id_cluster = -1l 
          Glob_tray_id_cluster = -1l 
          Glob_plane_id_cluster = -1l 
          Glob_pos_cluster = -1.
          Glob_zpos_cluster = -1. 
          Glob_energy_dep_cluster = -1.
          
      
          for j=0l, N_trig -1 do begin
             
             where_cluster_x_top = where(Glob_event_id_x_top_cluster EQ j)
          
             if (where_cluster_x_top(0) NE -1) then begin
             
               Glob_Si_id_cluster_temp = Glob_Si_id_x_top_cluster[where_cluster_x_top]
               Glob_tray_id_cluster_temp = Glob_tray_id_x_top_cluster[where_cluster_x_top]
               Glob_plane_id_cluster_temp = Glob_plane_id_x_top_cluster[where_cluster_x_top]
               Glob_pos_cluster_temp = Glob_xpos_x_top_cluster[where_cluster_x_top]
               Glob_zpos_cluster_temp = Glob_zpos_x_top_cluster[where_cluster_x_top]
               Glob_energy_dep_cluster_temp = Glob_energy_dep_x_top_cluster[where_cluster_x_top]
                      
               where_cluster_y_top = where(Glob_event_id_y_top_cluster EQ j)      
               if (where_cluster_y_top(0) NE -1) then begin
                 Glob_Si_id_cluster_temp = [Glob_Si_id_cluster_temp, Glob_Si_id_y_top_cluster[where_cluster_y_top]]
                 Glob_tray_id_cluster_temp = [Glob_tray_id_cluster_temp, Glob_tray_id_y_top_cluster[where_cluster_y_top]]
                 Glob_plane_id_cluster_temp = [Glob_plane_id_cluster_temp, Glob_plane_id_y_top_cluster[where_cluster_y_top]]
                 Glob_pos_cluster_temp = [Glob_pos_cluster_temp, Glob_ypos_y_top_cluster[where_cluster_y_top]]
                 Glob_zpos_cluster_temp = [Glob_zpos_cluster_temp, Glob_zpos_y_top_cluster[where_cluster_y_top]]
                 Glob_energy_dep_cluster_temp = [Glob_energy_dep_cluster_temp, Glob_energy_dep_y_top_cluster[where_cluster_y_top]]
               endif    
      
               where_cluster_x_bottom = where(Glob_event_id_x_bottom_cluster EQ j)      
               if (where_cluster_x_bottom(0) NE -1) then begin
                 Glob_Si_id_cluster_temp = [Glob_Si_id_cluster_temp, Glob_Si_id_x_bottom_cluster[where_cluster_x_bottom]]
                 Glob_tray_id_cluster_temp = [Glob_tray_id_cluster_temp, Glob_tray_id_x_bottom_cluster[where_cluster_x_bottom]]
                 Glob_plane_id_cluster_temp = [Glob_plane_id_cluster_temp, Glob_plane_id_x_bottom_cluster[where_cluster_x_bottom]]
                 Glob_pos_cluster_temp = [Glob_pos_cluster_temp, Glob_xpos_x_bottom_cluster[where_cluster_x_bottom]]
                 Glob_zpos_cluster_temp = [Glob_zpos_cluster_temp, Glob_zpos_x_bottom_cluster[where_cluster_x_bottom]]
                 Glob_energy_dep_cluster_temp = [Glob_energy_dep_cluster_temp, Glob_energy_dep_x_bottom_cluster[where_cluster_x_bottom]]
               endif    
       
               where_cluster_y_bottom = where(Glob_event_id_y_bottom_cluster EQ j)      
               if (where_cluster_y_bottom(0) NE -1) then begin
                 Glob_Si_id_cluster_temp = [Glob_Si_id_cluster_temp, Glob_Si_id_y_bottom_cluster[where_cluster_y_bottom]]
                 Glob_tray_id_cluster_temp = [Glob_tray_id_cluster_temp, Glob_tray_id_y_bottom_cluster[where_cluster_y_bottom]]
                 Glob_plane_id_cluster_temp = [Glob_plane_id_cluster_temp, Glob_plane_id_y_bottom_cluster[where_cluster_y_bottom]]
                 Glob_pos_cluster_temp = [Glob_pos_cluster_temp, Glob_ypos_y_bottom_cluster[where_cluster_y_bottom]]
                 Glob_zpos_cluster_temp = [Glob_zpos_cluster_temp, Glob_zpos_y_bottom_cluster[where_cluster_y_bottom]]
                 Glob_energy_dep_cluster_temp = [Glob_energy_dep_cluster_temp, Glob_energy_dep_y_bottom_cluster[where_cluster_y_bottom]]
               endif     
               
             endif else begin
                  where_cluster_y_top = where(Glob_event_id_y_top_cluster EQ j)
                  if (where_cluster_y_top(0) NE -1) then begin 
                     Glob_Si_id_cluster_temp = Glob_Si_id_y_top_cluster[where_cluster_y_top]
                     Glob_tray_id_cluster_temp = Glob_tray_id_y_top_cluster[where_cluster_y_top]
                     Glob_plane_id_cluster_temp = Glob_plane_id_y_top_cluster[where_cluster_y_top]
                     Glob_pos_cluster_temp = Glob_ypos_y_top_cluster[where_cluster_y_top]
                     Glob_zpos_cluster_temp = Glob_zpos_y_top_cluster[where_cluster_y_top]
                     Glob_energy_dep_cluster_temp = Glob_energy_dep_y_top_cluster[where_cluster_y_top]
      
                     where_cluster_x_bottom = where(Glob_event_id_x_bottom_cluster EQ j)      
                     if (where_cluster_x_bottom(0) NE -1) then begin
                       Glob_Si_id_cluster_temp = [Glob_Si_id_cluster_temp, Glob_Si_id_x_bottom_cluster[where_cluster_x_bottom]]
                       Glob_tray_id_cluster_temp = [Glob_tray_id_cluster_temp, Glob_tray_id_x_bottom_cluster[where_cluster_x_bottom]]
                       Glob_plane_id_cluster_temp = [Glob_plane_id_cluster_temp, Glob_plane_id_x_bottom_cluster[where_cluster_x_bottom]]
                       Glob_pos_cluster_temp = [Glob_pos_cluster_temp, Glob_xpos_x_bottom_cluster[where_cluster_x_bottom]]
                       Glob_zpos_cluster_temp = [Glob_zpos_cluster_temp, Glob_zpos_x_bottom_cluster[where_cluster_x_bottom]]
                       Glob_energy_dep_cluster_temp = [Glob_energy_dep_cluster_temp, Glob_energy_dep_x_bottom_cluster[where_cluster_x_bottom]]
                     endif    
             
                     where_cluster_y_bottom = where(Glob_event_id_y_bottom_cluster EQ j)      
                     if (where_cluster_y_bottom(0) NE -1) then begin
                       Glob_Si_id_cluster_temp = [Glob_Si_id_cluster_temp, Glob_Si_id_y_bottom_cluster[where_cluster_y_bottom]]
                       Glob_tray_id_cluster_temp = [Glob_tray_id_cluster_temp, Glob_tray_id_y_bottom_cluster[where_cluster_y_bottom]]
                       Glob_plane_id_cluster_temp = [Glob_plane_id_cluster_temp, Glob_plane_id_y_bottom_cluster[where_cluster_y_bottom]]
                       Glob_pos_cluster_temp = [Glob_pos_cluster_temp, Glob_ypos_y_bottom_cluster[where_cluster_y_bottom]]
                       Glob_zpos_cluster_temp = [Glob_zpos_cluster_temp, Glob_zpos_y_bottom_cluster[where_cluster_y_bottom]]
                       Glob_energy_dep_cluster_temp = [Glob_energy_dep_cluster_temp, Glob_energy_dep_y_bottom_cluster[where_cluster_y_bottom]]
                     endif     
      
                  endif else begin
                    where_cluster_x_bottom = where(Glob_event_id_x_bottom_cluster EQ j)
                    if (where_cluster_x_bottom(0) NE -1) then begin
                         Glob_Si_id_cluster_temp = Glob_Si_id_x_bottom_cluster[where_cluster_x_bottom]
                         Glob_tray_id_cluster_temp = Glob_tray_id_x_bottom_cluster[where_cluster_x_bottom]
                         Glob_plane_id_cluster_temp = Glob_plane_id_x_bottom_cluster[where_cluster_x_bottom]
                         Glob_pos_cluster_temp = Glob_xpos_x_bottom_cluster[where_cluster_x_bottom]
                         Glob_zpos_cluster_temp = Glob_zpos_x_bottom_cluster[where_cluster_x_bottom]
                         Glob_energy_dep_cluster_temp = Glob_energy_dep_x_bottom_cluster[where_cluster_x_bottom]
                    
                         where_cluster_y_bottom = where(Glob_event_id_y_bottom_cluster EQ j)      
                         if (where_cluster_y_bottom(0) NE -1) then begin
                           Glob_Si_id_cluster_temp = [Glob_Si_id_cluster_temp, Glob_Si_id_y_bottom_cluster[where_cluster_y_bottom]]
                           Glob_tray_id_cluster_temp = [Glob_tray_id_cluster_temp, Glob_tray_id_y_bottom_cluster[where_cluster_y_bottom]]
                           Glob_plane_id_cluster_temp = [Glob_plane_id_cluster_temp, Glob_plane_id_y_bottom_cluster[where_cluster_y_bottom]]
                           Glob_pos_cluster_temp = [Glob_pos_cluster_temp, Glob_ypos_y_bottom_cluster[where_cluster_y_bottom]]
                           Glob_zpos_cluster_temp = [Glob_zpos_cluster_temp, Glob_zpos_y_bottom_cluster[where_cluster_y_bottom]]
                           Glob_energy_dep_cluster_temp = [Glob_energy_dep_cluster_temp, Glob_energy_dep_y_bottom_cluster[where_cluster_y_bottom]]
                         endif     
                    
                    endif else begin
                      where_cluster_y_bottom = where(Glob_event_id_y_bottom_cluster EQ j)
                      if (where_cluster_y_bottom(0) NE -1) then begin
                           Glob_Si_id_cluster_temp = Glob_Si_id_y_bottom_cluster[where_cluster_y_bottom]
                           Glob_tray_id_cluster_temp = Glob_tray_id_y_bottom_cluster[where_cluster_y_bottom]
                           Glob_plane_id_cluster_temp = Glob_plane_id_y_bottom_cluster[where_cluster_y_bottom]
                           Glob_pos_cluster_temp = Glob_ypos_y_bottom_cluster[where_cluster_y_bottom]
                           Glob_zpos_cluster_temp = Glob_zpos_y_bottom_cluster[where_cluster_y_bottom]
                           Glob_energy_dep_cluster_temp = Glob_energy_dep_y_bottom_cluster[where_cluster_y_bottom]                           
                      endif
                    endelse
                  endelse
             endelse
                    
             tray_sort_arr = sort(Glob_tray_id_cluster_temp)
              
             Glob_Si_id_cluster_temp = Glob_Si_id_cluster_temp[reverse(tray_sort_arr)]
             Glob_tray_id_cluster_temp = Glob_tray_id_cluster_temp[reverse(tray_sort_arr)]
             Glob_plane_id_cluster_temp = Glob_plane_id_cluster_temp[reverse(tray_sort_arr)]
             Glob_pos_cluster_temp = Glob_pos_cluster_temp[reverse(tray_sort_arr)]
             Glob_zpos_cluster_temp = Glob_zpos_cluster_temp[reverse(tray_sort_arr)]
             Glob_energy_dep_cluster_temp = Glob_energy_dep_cluster_temp[reverse(tray_sort_arr)]
          
             Si_id_intray = -1l
             tray_id_intray = -1l
             plane_id_intray = -1l
             pos_intray = -1.
             zpos_intray = -1.
             energy_dep_intray = -1.
                 
              intray = 0l
              while(1) do begin
                 where_tray_eq = where(Glob_tray_id_cluster_temp EQ Glob_tray_id_cluster_temp(intray), complement = where_other_tray)
                 
                 Si_id_extract = Glob_Si_id_cluster_temp[where_tray_eq]
                 tray_id_extract = Glob_tray_id_cluster_temp[where_tray_eq]
                 plane_id_extract = Glob_plane_id_cluster_temp[where_tray_eq]
                 pos_extract = Glob_pos_cluster_temp[where_tray_eq]
                 zpos_extract = Glob_zpos_cluster_temp[where_tray_eq]
                 energy_dep_extract = Glob_energy_dep_cluster_temp[where_tray_eq]
                 
                 where_Xtop = where(Si_id_extract EQ 2)
                 if (where_Xtop(0) NE -1) then begin
                   Si_id_intray = [Si_id_intray, Si_id_extract[where_Xtop]]
                   tray_id_intray = [tray_id_intray, tray_id_extract[where_Xtop]]
                   plane_id_intray = [plane_id_intray, plane_id_extract[where_Xtop]]
                   pos_intray = [pos_intray, pos_extract[where_Xtop]]
                   zpos_intray = [zpos_intray, zpos_extract[where_Xtop]]
                   energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_Xtop]]         
                 endif
                 where_Ytop = where(Si_id_extract EQ 3)
                 if (where_Ytop(0) NE -1) then begin
                   Si_id_intray = [Si_id_intray, Si_id_extract[where_Ytop]]
                   tray_id_intray = [tray_id_intray, tray_id_extract[where_Ytop]]
                   plane_id_intray = [plane_id_intray, plane_id_extract[where_Ytop]]
                   pos_intray = [pos_intray, pos_extract[where_Ytop]]
                   zpos_intray = [zpos_intray, zpos_extract[where_Ytop]]
                   energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_Ytop]]         
                 endif
                 where_Xbottom = where(Si_id_extract EQ 0)
                 if (where_Xbottom(0) NE -1) then begin
                   Si_id_intray = [Si_id_intray, Si_id_extract[where_Xbottom]]
                   tray_id_intray = [tray_id_intray, tray_id_extract[where_Xbottom]]
                   plane_id_intray = [plane_id_intray, plane_id_extract[where_Xbottom]]
                   pos_intray = [pos_intray, pos_extract[where_Xbottom]]
                   zpos_intray = [zpos_intray, zpos_extract[where_Xbottom]]
                   energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_Xbottom]]         
                 endif
                 where_Ybottom = where(Si_id_extract EQ 1)
                 if (where_Ybottom(0) NE -1) then begin
                   Si_id_intray = [Si_id_intray, Si_id_extract[where_Ybottom]]
                   tray_id_intray = [tray_id_intray, tray_id_extract[where_Ybottom]]
                   plane_id_intray = [plane_id_intray, plane_id_extract[where_Ybottom]]
                   pos_intray = [pos_intray, pos_extract[where_Ybottom]]
                   zpos_intray = [zpos_intray, zpos_extract[where_Ybottom]]
                   energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_Ybottom]]         
                 endif           
      
               N_tray_eq = n_elements(where_tray_eq)
               if where_tray_eq(N_tray_eq-1) LT (n_elements(Glob_tray_id_cluster_temp)-1) then begin
                intray = where_tray_eq(N_tray_eq-1)+1
               endif else break
              endwhile
              
              Si_id_temp = Si_id_intray[1:*]
              tray_id_temp = tray_id_intray[1:*]
              plane_id_temp = plane_id_intray[1:*]
              pos_temp = pos_intray[1:*]
              zpos_temp = zpos_intray[1:*]
              energy_dep_temp = energy_dep_intray[1:*]
              
              event_id_temp = lonarr(n_elements(Si_id_temp))
              for k=0l, n_elements(Si_id_temp)-1 do begin
               event_id_temp(k) = event_array(j)
              endfor
              
              Glob_event_id_cluster = [Glob_event_id_cluster, event_id_temp]
              Glob_Si_id_cluster = [Glob_Si_id_cluster, Si_id_temp]
              Glob_tray_id_cluster = [Glob_tray_id_cluster, tray_id_temp]
              Glob_plane_id_cluster = [Glob_plane_id_cluster, plane_id_temp]
              Glob_pos_cluster = [Glob_pos_cluster, pos_temp]
              Glob_zpos_cluster = [Glob_zpos_cluster, zpos_temp]
              Glob_energy_dep_cluster = [Glob_energy_dep_cluster, energy_dep_temp]
          
          endfor
          
          Glob_event_id_cluster = Glob_event_id_cluster[1:*]
          Glob_Si_id_cluster =  Glob_Si_id_cluster[1:*]
          Glob_tray_id_cluster =  Glob_tray_id_cluster[1:*]
          Glob_plane_id_cluster =  Glob_plane_id_cluster[1:*]
          Glob_pos_cluster = Glob_pos_cluster[1:*]
          Glob_zpos_cluster = Glob_zpos_cluster[1:*]
          Glob_energy_dep_cluster = Glob_energy_dep_cluster[1:*]
          
          
          ; Level 0.5 = energy summed, MIP threshold applied, strip position used 
          
          CREATE_STRUCT, L05TRACKER, 'TRACKERL05', ['EVT_ID', 'TRAY_ID','PLANE_ID','TRK_FLAG','POS', 'ZPOS','E_DEP'], 'J,I,I,I,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(Glob_event_id_cluster)
          L05TRACKER.EVT_ID = Glob_event_id_cluster
          L05TRACKER.TRAY_ID = Glob_tray_id_cluster
          L05TRACKER.PLANE_ID = Glob_plane_id_cluster
          L05TRACKER.TRK_FLAG = Glob_Si_id_cluster
          L05TRACKER.POS = Glob_pos_cluster
          L05TRACKER.ZPOS = Glob_zpos_cluster
          L05TRACKER.E_DEP = Glob_energy_dep_cluster
          
          HDR_L05GLOBAL = ['Creator          = Valentina Fioretti', $
                    'THELSIM release  = ASTROGAM '+astrogam_version, $
                    'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
                    'N_TRIG           = '+STRTRIM(STRING(N_TRIG),1)+'   /Number of triggering events', $
                    'ENERGY           = '+ene_type+'   /Simulated input energy', $
                    'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
                    'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
                    'ENERGY UNIT      = KEV']
          
          
          MWRFITS, L05TRACKER, outdir+'/L0.5.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', HDR_L05GLOBAL, /CREATE
      
          
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
          print, '                      Summing all the volumes '
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
      
          
          ; cluster X and Y arrays for the GAMS input
         
          check_N_trig = 0
          max_arraydim_x = 0
          max_arraydim_y = 0
          
          eventid_kalman = fltarr(N_trig)
	  theta_kalman = fltarr(N_trig)
          phi_kalman = fltarr(N_trig)
          energy_kalman = fltarr(N_trig)
          
          default_max_cols = 1000
          cluster_x_array = MAKE_ARRAY(default_max_cols, N_trig, /DOUBLE, VALUE = 0)
          cluster_y_array = MAKE_ARRAY(default_max_cols, N_trig, /DOUBLE, VALUE = 0)
          plane_x_array = MAKE_ARRAY(default_max_cols, N_trig, /INTEGER, VALUE = 0)
          plane_y_array = MAKE_ARRAY(default_max_cols, N_trig, /INTEGER, VALUE = 0)
          
          
          Glob_event_id_sum = -1l
          Glob_Si_id_sum = -1l
          Glob_tray_id_sum= -1l
          Glob_plane_id_sum = -1l
          Glob_zpos_sum = -1.
          Glob_energy_dep_sum = -1.  
          
          j=0l
          while (1) do begin
              
              where_event_eq = where(Glob_event_id_cluster EQ Glob_event_id_cluster(j))
              ;print, 'where_event_eq', where_event_eq
              
              where_clusterx = where((Glob_Si_id_cluster(where_event_eq) EQ 2) or (Glob_Si_id_cluster(where_event_eq) EQ 0))
              if (n_elements(where_clusterx) GT max_arraydim_x) then max_arraydim_x = n_elements(where_clusterx)
              temp_planex = intarr(n_elements(where_clusterx))
              temp_clusterx = dblarr(n_elements(where_clusterx))
              
              ;print, 'max_arraydim_x', max_arraydim_x
              ;print, 'where_clusterx', where_clusterx
              
              where_clustery = where((Glob_Si_id_cluster(where_event_eq) EQ 3) or (Glob_Si_id_cluster(where_event_eq) EQ 1))
              if (n_elements(where_clustery) GT max_arraydim_y) then max_arraydim_y = n_elements(where_clustery)
              temp_planey = intarr(n_elements(where_clustery))
              temp_clustery = dblarr(n_elements(where_clustery))
      
              counterx = 0
              countery = 0
              
              event_id_temp = Glob_event_id_cluster(where_event_eq)
              Si_id_temp = Glob_Si_id_cluster(where_event_eq) 
              tray_id_temp = Glob_tray_id_cluster(where_event_eq) 
              plane_id_temp = Glob_plane_id_cluster(where_event_eq) 
              pos_temp = Glob_pos_cluster(where_event_eq) 
              zpos_temp = Glob_zpos_cluster(where_event_eq) 
              energy_dep_temp = Glob_energy_dep_cluster(where_event_eq) 
          
              r=0
              while (1) do begin
                  where_tray_eq = where(tray_id_temp EQ tray_id_temp(r))
                  
                  event_id_temp_tray = event_id_temp(where_tray_eq)
                  tray_id_temp_tray = tray_id_temp(where_tray_eq)
                  Si_id_temp_tray = Si_id_temp(where_tray_eq) 
                  plane_id_temp_tray = plane_id_temp(where_tray_eq)
                  pos_temp_tray = pos_temp(where_tray_eq)
                  zpos_temp_tray = zpos_temp(where_tray_eq)
                  energy_dep_temp_tray = energy_dep_temp(where_tray_eq)     
      
                  t=0
                  while (1) do begin
                       
                       where_plane_eq = where(plane_id_temp_tray EQ plane_id_temp_tray(t))
                       event_id_temp_plane = event_id_temp_tray(where_plane_eq)
                       tray_id_temp_plane = tray_id_temp_tray(where_plane_eq)
                       Si_id_temp_plane = Si_id_temp_tray(where_plane_eq) 
                       plane_id_temp_plane = plane_id_temp_tray(where_plane_eq)
                       pos_temp_plane = pos_temp_tray(where_plane_eq)
                       zpos_temp_plane = zpos_temp_tray(where_plane_eq)
                       energy_dep_temp_plane = energy_dep_temp_tray(where_plane_eq)     
                       
                       
                       last = 0
                       while (1) do begin
                           where_si_eq = where(Si_id_temp_plane EQ Si_id_temp_plane(last))
                           
			   print, 'Event ID: ', Glob_event_id_cluster(j)
			   print, 'Same Si id:', Si_id_temp_plane(last)
			   
                           temp_samesi = pos_temp_plane(where_si_eq)
			   print, 'temp_samesi: ', temp_si 
                           ; GAMS array 
                           if ((Si_id_temp_plane(last) EQ 2) or (Si_id_temp_plane(last) EQ 0)) then begin
                              for jel = 0l, n_elements(temp_samesi)-1 do begin
                                    temp_planex[jel + counterx] = plane_id_temp_tray(t)
                                    temp_clusterx[jel + counterx] = temp_samesi(jel) + (tray_side/2.)
                              endfor
                              counterx = counterx + n_elements(temp_samesi)
                           endif
                           if ((Si_id_temp_plane(last) EQ 3) or (Si_id_temp_plane(last) EQ 1)) then begin
                              for jel = 0l, n_elements(temp_samesi)-1 do begin
                                    temp_planey[jel + countery] = plane_id_temp_tray(t)
                                    temp_clustery[jel + countery] = temp_samesi(jel) + (tray_side/2.)
                              endfor
                              countery = countery + n_elements(temp_samesi)
                           endif
                           
                                           
                           Glob_event_id_sum = [Glob_event_id_sum, Glob_event_id_cluster(j)]                
                           Glob_Si_id_sum = [Glob_Si_id_sum, Si_id_temp_plane(last)]
                           Glob_tray_id_sum = [Glob_tray_id_sum, tray_id_temp(r)]
                           Glob_plane_id_sum = [Glob_plane_id_sum, plane_id_temp_tray(t)]
                           Glob_zpos_sum = [Glob_zpos_sum, zpos_temp_plane(last)]
                           Glob_energy_dep_sum = [Glob_energy_dep_sum, total(energy_dep_temp_plane(where_si_eq))]
                           
                           N_si_eq = n_elements(where_si_eq)
                           if where_si_eq(N_si_eq-1) LT (n_elements(Si_id_temp_plane)-1) then begin
                             last = where_si_eq(N_si_eq-1)+1
                           endif else break
                       endwhile
                       
                       N_plane_eq = n_elements(where_plane_eq)
                       if where_plane_eq(N_plane_eq-1) LT (n_elements(plane_id_temp_tray)-1) then begin
                         t = where_plane_eq(N_plane_eq-1)+1
                       endif else break
                  endwhile
      
                  for jcol = 0, n_elements(temp_planex) -1 do begin 
                      plane_x_array[jcol, check_N_trig] = temp_planex[jcol]
                      cluster_x_array[jcol, check_N_trig] = temp_clusterx[jcol]
                  endfor
                  for jcol = 0, n_elements(temp_planey) -1 do begin 
                      plane_y_array[jcol, check_N_trig] = temp_planey[jcol]
                      cluster_y_array[jcol, check_N_trig] = temp_clustery[jcol]
                  endfor
                  
                  
                  N_tray_eq = n_elements(where_tray_eq)
                  if where_tray_eq(N_tray_eq-1) LT (n_elements(tray_id_temp)-1) then begin
                    r = where_tray_eq(N_tray_eq-1)+1
                  endif else break      
              endwhile
              
              eventid_kalman(check_N_trig) = Glob_event_id_cluster(j)
              theta_kalman(check_N_trig) = theta_type
              phi_kalman(check_N_trig) = phi_type
              energy_kalman(check_N_trig) = ene_type
              
              check_N_trig = check_N_trig + 1
              
              N_event_eq = n_elements(where_event_eq)
              if where_event_eq(N_event_eq-1) LT (n_elements(Glob_event_id_cluster)-1) then begin
                j = where_event_eq(N_event_eq-1)+1
              endif else break
          endwhile
          
          max_cols = 0
          if (max_arraydim_x GT max_arraydim_y) then max_cols = max_arraydim_x
          if (max_arraydim_y GT max_arraydim_x) then max_cols = max_arraydim_y
      
          print, 'Max number of cols: ', max_cols
      
      ;    keepcols = indgen(max_cols)    
      ;    plane_x_array = plane_x_array[keepcols, *]
      ;    cluster_x_array = cluster_x_array[keepcols, *]    
      ;    plane_y_array = plane_y_array[keepcols, *]
      ;    cluster_y_array = cluster_y_array[keepcols, *]
          
          string_dim = string(default_max_cols)    
          CREATE_STRUCT, KALMANTRACKER, 'TRACKERKALMAN', ['Event_ID', 'Theta', 'Phi','Energia','Piani_X','Clusters_X', 'Piani_Y', 'Clusters_Y'], 'J,F,F,F,I('+string_dim+'),D('+string_dim+'),I('+string_dim+'),D('+string_dim+')', DIMEN = N_ELEMENTS(theta_kalman)
      
          KALMANTRACKER.Event_ID = eventid_kalman
          KALMANTRACKER.Theta = float(theta_kalman)
          KALMANTRACKER.Phi = float(phi_kalman)
          KALMANTRACKER.Energia = float(energy_kalman)
          KALMANTRACKER.Piani_X = plane_x_array
          KALMANTRACKER.Clusters_X = cluster_x_array
          KALMANTRACKER.Piani_Y = plane_y_array
          KALMANTRACKER.Clusters_Y = cluster_y_array
         
               
          HDR_KALMAN = ['Creator          = Valentina Fioretti (INAF/IASF Bologna)', $
                    'THELSIM release  = ASTROGAM '+astrogam_version, $
                    'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
                    'N_TRIG           = '+STRTRIM(STRING(N_TRIG),1)+'   /Number of triggering events', $
                    'ENERGY           = '+ene_type+'   /Simulated input energy', $
                    'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
                    'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle']
          
          
          MWRFITS, KALMANTRACKER, outdir+'/KALMAN.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', HDR_KALMAN, /CREATE
          
          
          Glob_event_id_sum = Glob_event_id_sum[1:*]
          Glob_Si_id_sum =  Glob_Si_id_sum[1:*]
          Glob_tray_id_sum =  Glob_tray_id_sum[1:*]
          Glob_plane_id_sum =  Glob_plane_id_sum[1:*]
          Glob_zpos_sum = Glob_zpos_sum[1:*]
          Glob_energy_dep_sum = Glob_energy_dep_sum[1:*]
          
          
          CREATE_STRUCT, SUMTRACKER, 'TRACKERSUM', ['EVT_ID', 'TRAY_ID','PLANE_ID','TRK_FLAG','ZPOS','E_DEP'], 'J,I,I,I,F20.5,F20.5', DIMEN = N_ELEMENTS(Glob_event_id_sum)
          SUMTRACKER.EVT_ID = Glob_event_id_sum
          SUMTRACKER.TRAY_ID = Glob_tray_id_sum
          SUMTRACKER.PLANE_ID = Glob_plane_id_sum
          SUMTRACKER.TRK_FLAG = Glob_Si_id_sum
          SUMTRACKER.ZPOS = Glob_zpos_sum
          SUMTRACKER.E_DEP = Glob_energy_dep_sum
          
          HDR_SUM = ['Creator          = Valentina Fioretti', $
                    'THELSIM release  = ASTROGAM '+astrogam_version, $
                    'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
                    'N_TRIG           = '+STRTRIM(STRING(N_TRIG),1)+'   /Number of triggering events', $
                    'ENERGY           = '+ene_type+'   /Simulated input energy', $
                    'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
                    'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
                    'ENERGY UNIT      = KEV']
          
          
          MWRFITS, SUMTRACKER, outdir+'/SUM.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', HDR_SUM, /CREATE
          
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
          print, '                      Tracker   '
          print, '            Saving the Kalman input file   '
          print, '                    DIGI = yes '
          print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
          
      ;    
      ;    openw,lun,outdir+'/G4.DIGI.KALMAN.AGILE'+agile_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat',/get_lun
      ;    ; ASCII Columns:
      ;    ; - c1 = event ID
      ;    ; - c2 = Silicon layer ID
      ;    ; - c3 = x/y pos [cm]
      ;    ; - c4 = z pos [cm]
      ;    ; - c5 = plane ID
      ;    ; - c6 = strip ID
      ;    ; - c7 = energy dep [keV]
      ; 
      ;    event_start = -1
      ;    j=0l
      ;    while (1) do begin
      ;        where_event_eq = where(Glob_event_id_acap EQ Glob_event_id_acap(j))
      ;        Glob_Si_id_acap_temp = Glob_Si_id_acap(where_event_eq)
      ;        Glob_Strip_id_acap_temp = Glob_Strip_id_acap(where_event_eq)
      ;        Glob_tray_id_acap_temp  = Glob_tray_id_acap(where_event_eq)
      ;        Glob_plane_id_acap_temp  = Glob_plane_id_acap(where_event_eq)
      ;        Glob_energy_dep_acap_temp = Glob_energy_dep_acap(where_event_eq)    
      ;        Glob_pos_acap_temp = Glob_pos_acap(where_event_eq)
      ;        Glob_zpos_acap_temp = Glob_zpos_acap(where_event_eq)
      ;    
      ;        ;printf, lun, '; Event:', Glob_event_id_acap(j)
      ;        ;printf, lun, '; ', theta_type, phi_type, ene_type   
      ;        
      ;        
      ;        where_x = where(Glob_Si_id_acap_temp EQ 0)
      ;        if (where_x(0) NE -1) then begin
      ;         for r=0l, n_elements(where_x)-1 do begin
      ;            printf, lun, Glob_event_id_acap(j), Glob_Si_id_acap_temp(where_x(r)), Glob_pos_acap_temp(where_x(r)), Glob_zpos_acap_temp(where_x(r)), Glob_plane_id_acap_temp(where_x(r)), Glob_Strip_id_acap_temp(where_x(r)), Glob_energy_dep_acap_temp(where_x(r)), format='(I5,2x,I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,F10.5)'
      ;            
      ;         endfor
      ;        endif
      ;        where_y = where(Glob_Si_id_acap_temp EQ 1)    
      ;        if (where_y(0) NE -1) then begin
      ;         for r=0l, n_elements(where_y)-1 do begin
      ;            printf, lun, Glob_event_id_acap(j), Glob_Si_id_acap_temp(where_y(r)), Glob_pos_acap_temp(where_y(r)), Glob_zpos_acap_temp(where_y(r)), Glob_plane_id_acap_temp(where_y(r)), Glob_Strip_id_acap_temp(where_y(r)), Glob_energy_dep_acap_temp(where_y(r)), format='(I5,2x,I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,F10.5)'
      ;            
      ;         endfor
      ;        endif
      ;        N_event_eq = n_elements(where_event_eq)
      ;        if where_event_eq(N_event_eq-1) LT (n_elements(Glob_event_id_acap)-1) then begin
      ;          j = where_event_eq(N_event_eq-1)+1
      ;        endif else break
      ;    endwhile
      ;    
      ;    Free_lun, lun
      ;    
      ;    openw,lun,outdir+'/G4.DIGI.GENERAL.AGILE'+agile_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat',/get_lun
      ;    ; ASCII Columns:
      ;    ; - c1 = event ID
      ;    ; - c2 = Silicon layer ID
      ;    ; - c3 = x/y pos [cm]
      ;    ; - c4 = z pos [cm]
      ;    ; - c5 = tray ID
      ;    ; - c6 = plane ID
      ;    ; - c7 = strip ID 
      ;    ; - c8 = energy dep [keV]    
      ;  
      ;    event_start = -1
      ;    j=0l
      ;    while (1) do begin
      ;        where_event_eq = where(Glob_event_id_acap EQ Glob_event_id_acap(j))
      ;        Glob_Si_id_acap_temp = Glob_Si_id_acap(where_event_eq)
      ;        Glob_Strip_id_acap_temp = Glob_Strip_id_acap(where_event_eq)
      ;        Glob_tray_id_acap_temp  = Glob_tray_id_acap(where_event_eq)
      ;        Glob_plane_id_acap_temp  = Glob_plane_id_acap(where_event_eq)
      ;        Glob_energy_dep_acap_temp = Glob_energy_dep_acap(where_event_eq)    
      ;        Glob_pos_acap_temp = Glob_pos_acap(where_event_eq)
      ;        Glob_zpos_acap_temp = Glob_zpos_acap(where_event_eq)
      ;    
      ;        
      ;        where_x = where(Glob_Si_id_acap_temp EQ 0)
      ;        if (where_x(0) NE -1) then begin
      ;         for r=0l, n_elements(where_x)-1 do begin
      ;            printf, lun, Glob_event_id_acap(j), Glob_Si_id_acap_temp(where_x(r)), Glob_pos_acap_temp(where_x(r)), Glob_zpos_acap_temp(where_x(r)), Glob_tray_id_acap_temp(where_x(r)), Glob_plane_id_acap_temp(where_x(r)), Glob_Strip_id_acap_temp(where_x(r)), Glob_energy_dep_acap_temp(where_x(r)), format='(I5,2x,I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,I5,2x,F10.5)'
      ;            
      ;         endfor
      ;        endif
      ;        where_y = where(Glob_Si_id_acap_temp EQ 1)    
      ;        if (where_y(0) NE -1) then begin
      ;         for r=0l, n_elements(where_y)-1 do begin
      ;            printf, lun, Glob_event_id_acap(j), Glob_Si_id_acap_temp(where_y(r)), Glob_pos_acap_temp(where_y(r)), Glob_zpos_acap_temp(where_y(r)), Glob_tray_id_acap_temp(where_y(r)), Glob_plane_id_acap_temp(where_y(r)), Glob_Strip_id_acap_temp(where_y(r)), Glob_energy_dep_acap_temp(where_y(r)), format='(I5,2x,I5,2x,F10.5,2x,F10.5,2x,I5,2x,I5,2x,I5,2x,F10.5)'
      ;            
      ;         endfor
      ;        endif
      ;        N_event_eq = n_elements(where_event_eq)
      ;        if where_event_eq(N_event_eq-1) LT (n_elements(Glob_event_id_acap)-1) then begin
      ;          j = where_event_eq(N_event_eq-1)+1
      ;        endif else break
      ;    endwhile
      ;    
      ;    Free_lun, lun
      ;    
      ;    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
      ;    print, '                      Tracker   '
      ;    print, '            Saving the DHSim input file   '
      ;    print, '                    DIGI = yes '
      ;    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
      ;    
      ;    
      ;    openw,lun,outdir+'/G4_GAMS_YPLANE_AGILE'+agile_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat',/get_lun
      ;    ; ASCII Columns:
      ;    ; - c1 = event ID
      ;    ; - c2 = plane ID
      ;    ; - c3 = readout strip ID
      ;    ; - c4 = -999
      ;    ; - c5 = -999
      ;    ; - c6 = energy dep in MIP
      ;    ; - c7 = -999
      ;      
      ;    event_start = -1
      ;    j=0l
      ;    while (1) do begin
      ;        where_event_eq = where(Glob_event_id_acap EQ Glob_event_id_acap(j))
      ;        Glob_Si_id_acap_temp = Glob_Si_id_acap(where_event_eq)
      ;        Glob_Strip_id_acap_temp = Glob_Strip_id_acap(where_event_eq)
      ;        Glob_tray_id_acap_temp  = Glob_tray_id_acap(where_event_eq)
      ;        Glob_plane_id_acap_temp  = Glob_plane_id_acap(where_event_eq)
      ;        Glob_energy_dep_acap_temp = Glob_energy_dep_acap(where_event_eq)    
      ;        Glob_pos_acap_temp = Glob_pos_acap(where_event_eq)
      ;        Glob_zpos_acap_temp = Glob_zpos_acap(where_event_eq)
      ;        
      ;        ; The strip readout id changed from 0 - 3071 range to 0 - 1536
      ;        Glob_Strip_readout_id_acap_temp = Glob_Strip_id_acap_temp/2
      ;        ; The energy deposit is converted to MIP
      ;        Glob_energy_dep_mip_acap_temp = Glob_energy_dep_acap_temp/108.
      ;        where_x = where(Glob_Si_id_acap_temp EQ 0)
      ;        ; The event id starts from 1 (1 added in the file writing)
      ;        ; The Strip ID starts from 1 (1 added in the file writing)
      ;        if (where_x(0) NE -1) then begin
      ;         for r=0l, n_elements(where_x)-1 do begin
      ;            printf, lun, (Glob_event_id_acap(j)+1), Glob_plane_id_acap_temp(where_x(r)), (Glob_Strip_readout_id_acap_temp(where_x(r)) + 1), -999, -999, Glob_energy_dep_mip_acap_temp(where_x(r)), -999, format='(I5,I5,I5,I5,I5,F10.5,I5)'
      ;            
      ;         endfor
      ;        endif
      ;        N_event_eq = n_elements(where_event_eq)
      ;        if where_event_eq(N_event_eq-1) LT (n_elements(Glob_event_id_acap)-1) then begin
      ;          j = where_event_eq(N_event_eq-1)+1
      ;        endif else break
      ;    endwhile
      ;    
      ;    Free_lun, lun
      ;    
      ;    openw,lun,outdir+'/G4_GAMS_XPLANE_AGILE'+agile_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat',/get_lun
      ;    ; ASCII Columns:
      ;    ; - c1 = event ID
      ;    ; - c2 = plane ID
      ;    ; - c3 = readout strip ID
      ;    ; - c4 = -999
      ;    ; - c5 = -999
      ;    ; - c6 = energy dep in MIP
      ;    ; - c7 = -999    
      ;    
      ;    event_start = -1
      ;    j=0l
      ;    while (1) do begin
      ;        where_event_eq = where(Glob_event_id_acap EQ Glob_event_id_acap(j))
      ;        Glob_Si_id_acap_temp = Glob_Si_id_acap(where_event_eq)
      ;        Glob_Strip_id_acap_temp = Glob_Strip_id_acap(where_event_eq)
      ;        Glob_tray_id_acap_temp  = Glob_tray_id_acap(where_event_eq)
      ;        Glob_plane_id_acap_temp  = Glob_plane_id_acap(where_event_eq)
      ;        Glob_energy_dep_acap_temp = Glob_energy_dep_acap(where_event_eq)    
      ;        Glob_pos_acap_temp = Glob_pos_acap(where_event_eq)
      ;        Glob_zpos_acap_temp = Glob_zpos_acap(where_event_eq)
      ;    
      ;        ; The strip readout id changed from 0 - 3071 range to 0 - 1535
      ;        Glob_Strip_readout_id_acap_temp = Glob_Strip_id_acap_temp/2
      ;        ; The energy deposit is converted to MIP
      ;        Glob_energy_dep_mip_acap_temp = Glob_energy_dep_acap_temp/108.
      ;        
      ;        ; Inverting the Yv strip value to obtain the Xk value
      ;        Glob_Strip_GAMS_id_acap_temp = lonarr(n_elements(Glob_Strip_readout_id_acap_temp))
      ;        for jstrip=0, n_elements(Glob_Strip_readout_id_acap_temp)-1 do begin
      ;            Glob_Strip_GAMS_id_acap_temp(jstrip) = ((N_strip/2)-1) - Glob_Strip_readout_id_acap_temp(jstrip)   
      ;        endfor
      ;        
      ;        ; The event id starts from 1 (1 added in the file writing)
      ;        ; The Strip ID starts from 1 (1 added in the file writing)  
      ;        where_y = where(Glob_Si_id_acap_temp EQ 1)    
      ;        if (where_y(0) NE -1) then begin
      ;         for r=0l, n_elements(where_y)-1 do begin
      ;            printf, lun, (Glob_event_id_acap(j)+1), Glob_plane_id_acap_temp(where_y(r)), (Glob_Strip_GAMS_id_acap_temp(where_y(r)) + 1), -999, -999, Glob_energy_dep_mip_acap_temp(where_y(r)), -999, format='(I5,I5,I5,I5,I5,F10.5,I5)'
      ;            
      ;         endfor
      ;        endif
      ;        N_event_eq = n_elements(where_event_eq)
      ;        if where_event_eq(N_event_eq-1) LT (n_elements(Glob_event_id_acap)-1) then begin
      ;          j = where_event_eq(N_event_eq-1)+1
      ;        endif else break
      ;    endwhile
      ;    
      ;    Free_lun, lun
      ;
      ;
endif
if (astrogam_version EQ 'V3.0') then begin
      
        ; Total number of strips
        Total_vol_x_top = (N_tray)*N_strip
        Total_vol_y_top = (N_tray)*N_strip
        
        print, 'Number of tracker triggered events:', N_trig
     
        Glob_event_id_x_top = lonarr(Total_vol_x_top, N_trig) 
        Glob_vol_id_x_top = lonarr(Total_vol_x_top, N_trig) 
        Glob_moth_id_x_top = lonarr(Total_vol_x_top, N_trig) 
        Glob_Strip_id_x_top = lonarr(Total_vol_x_top, N_trig) 
        Glob_Si_id_x_top = lonarr(Total_vol_x_top, N_trig) 
        Glob_tray_id_x_top = lonarr(Total_vol_x_top, N_trig) 
        Glob_plane_id_x_top = lonarr(Total_vol_x_top, N_trig) 
        Glob_xpos_x_top = dblarr(Total_vol_x_top, N_trig) 
        Glob_zpos_x_top = dblarr(Total_vol_x_top, N_trig) 
        Glob_energy_dep_x_top = dblarr(Total_vol_x_top, N_trig) 
        
        Glob_event_id_y_top = lonarr(Total_vol_y_top, N_trig) 
        Glob_vol_id_y_top = lonarr(Total_vol_y_top, N_trig) 
        Glob_moth_id_y_top = lonarr(Total_vol_y_top, N_trig) 
        Glob_Strip_id_y_top = lonarr(Total_vol_y_top, N_trig) 
        Glob_Si_id_y_top = lonarr(Total_vol_y_top, N_trig) 
        Glob_tray_id_y_top = lonarr(Total_vol_y_top, N_trig) 
        Glob_plane_id_y_top = lonarr(Total_vol_y_top, N_trig) 
        Glob_ypos_y_top = dblarr(Total_vol_y_top, N_trig) 
        Glob_zpos_y_top = dblarr(Total_vol_y_top, N_trig) 
        Glob_energy_dep_y_top = dblarr(Total_vol_y_top, N_trig) 

        filename_x_top = './conf/ARCH.XSTRIP.TOP.ASTROGAM'+astrogam_version+'.TRACKER.FITS'
        filename_y_top = './conf/ARCH.YSTRIP.TOP.ASTROGAM'+astrogam_version+'.TRACKER.FITS'
    
        struct_x_top = mrdfits(filename_x_top,$ 
                               1, $
                               structyp = 'astrogam_xtop', $
                               /unsigned)
        
        struct_y_top = mrdfits(filename_y_top,$ 
                               1, $
                               structyp = 'astrogam_ytop', $
                               /unsigned)
        
        Arch_vol_id_x_top = struct_x_top.VOLUME_ID
        Arch_moth_id_x_top = struct_x_top.MOTHER_ID
        Arch_Strip_id_x_top = struct_x_top.STRIP_ID 
        Arch_Si_id_x_top = struct_x_top.TRK_FLAG
        Arch_tray_id_x_top = struct_x_top.TRAY_ID 
        Arch_plane_id_x_top = struct_x_top.PLANE_ID 
        Arch_xpos_x_top = struct_x_top.XPOS 
        Arch_zpos_x_top = struct_x_top.ZPOS 
        Arch_energy_dep_x_top = struct_x_top.E_DEP 
        
        Arch_vol_id_y_top = struct_y_top.VOLUME_ID
        Arch_moth_id_y_top = struct_y_top.MOTHER_ID
        Arch_Strip_id_y_top = struct_y_top.STRIP_ID 
        Arch_Si_id_y_top = struct_y_top.TRK_FLAG
        Arch_tray_id_y_top = struct_y_top.TRAY_ID 
        Arch_plane_id_y_top = struct_y_top.PLANE_ID 
        Arch_ypos_y_top = struct_y_top.YPOS 
        Arch_zpos_y_top = struct_y_top.ZPOS 
        Arch_energy_dep_y_top = struct_y_top.E_DEP    
        
        for i=0, N_trig-1 do begin
    
            Glob_vol_id_x_top[*,i] = Arch_vol_id_x_top
            Glob_moth_id_x_top[*,i] = Arch_moth_id_x_top
            Glob_Strip_id_x_top[*,i] = Arch_Strip_id_x_top
            Glob_Si_id_x_top[*,i] = Arch_Si_id_x_top
            Glob_tray_id_x_top[*,i] = Arch_tray_id_x_top 
            Glob_plane_id_x_top[*,i] = Arch_plane_id_x_top 
            Glob_xpos_x_top[*,i] = Arch_xpos_x_top 
            Glob_zpos_x_top[*,i] = Arch_zpos_x_top
            Glob_energy_dep_x_top[*,i] = Arch_energy_dep_x_top
        
            Glob_vol_id_y_top[*,i] = Arch_vol_id_y_top
            Glob_moth_id_y_top[*,i] = Arch_moth_id_y_top
            Glob_Strip_id_y_top[*,i] = Arch_Strip_id_y_top
            Glob_Si_id_y_top[*,i] = Arch_Si_id_y_top
            Glob_tray_id_y_top[*,i] = Arch_tray_id_y_top 
            Glob_plane_id_y_top[*,i] = Arch_plane_id_y_top 
            Glob_ypos_y_top[*,i] = Arch_ypos_y_top 
            Glob_zpos_y_top[*,i] = Arch_zpos_y_top 
            Glob_energy_dep_y_top[*,i] = Arch_energy_dep_y_top     
        
        endfor
        
        
         j=0l
         N_ev =0l
         while (1) do begin
            where_event_eq = where(event_id_tot EQ event_id_tot(j))
            
            event_id_temp = event_id_tot(where_event_eq)
            vol_id_temp = vol_id_tot(where_event_eq) 
            moth_id_temp = moth_id_tot(where_event_eq) 
            Strip_id_temp = Strip_id_tot(where_event_eq) 
            Si_id_temp = Si_id_tot(where_event_eq) 
            tray_id_temp = tray_id_tot(where_event_eq) 
            plane_id_temp = plane_id_tot(where_event_eq) 
            energy_dep_temp = energy_dep_tot(where_event_eq) 
        
            vol_sort_arr = sort(vol_id_temp)
            
            vol_id_temp = vol_id_temp[vol_sort_arr]
            moth_id_temp = moth_id_temp[vol_sort_arr]
            Strip_id_temp = Strip_id_temp[vol_sort_arr]
            Si_id_temp = Si_id_temp[vol_sort_arr]
            tray_id_temp = tray_id_temp[vol_sort_arr]
            plane_id_temp = plane_id_temp[vol_sort_arr]
            energy_dep_temp = energy_dep_temp[vol_sort_arr]
  
            for z=0l, Total_vol_x_top -1 do begin
              where_hit_x_top = where((Si_id_temp EQ 0) and (vol_id_temp EQ Glob_vol_id_x_top(z, N_ev)) and (moth_id_temp EQ Glob_moth_id_x_top(z, N_ev)))
              ;print, event_id_tot(j)
              ;print, where_hit_x_top
              ;print, energy_dep_temp(where_hit_x_top)
              if (where_hit_x_top(0) NE -1) then Glob_energy_dep_x_top(z, N_ev) = energy_dep_temp(where_hit_x_top)
              where_hit_y_top = where((Si_id_temp EQ 1) and (vol_id_temp EQ Glob_vol_id_y_top(z, N_ev)) and (moth_id_temp EQ Glob_moth_id_y_top(z, N_ev)))
              if (where_hit_y_top(0) NE -1) then Glob_energy_dep_y_top(z, N_ev) = energy_dep_temp(where_hit_y_top)
            endfor
             
            N_event_eq = n_elements(where_event_eq)
            if where_event_eq(N_event_eq-1) LT (n_elements(event_id_tot)-1) then begin
              j = where_event_eq(N_event_eq-1)+1
              N_ev = N_ev + 1
            endif else break
         endwhile
    

        print, 'N_ev: ', N_ev
	
	    
    
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '                      Tracker   '
    print, '              Build the LEVEL 0 output            '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
            
    Glob_event_id_test = -1l 
    Glob_vol_id_test = -1l 
    Glob_moth_id_test = -1l 
    Glob_Strip_id_test = -1l 
    Glob_Si_id_test = -1l 
    Glob_tray_id_test = -1l 
    Glob_plane_id_test = -1l 
    Glob_pos_test = -1.
    Glob_zpos_test = -1. 
    Glob_energy_dep_test = -1.
    
    
    for j=0l, N_trig -1 do begin
       
       where_test_x = where(Glob_energy_dep_x_top[*,j] GT 0.)
    
       if (where_test_x(0) NE -1) then begin
         Glob_vol_id_x_test_temp = Glob_vol_id_x_top[where_test_x,j]
         Glob_moth_id_x_test_temp = Glob_moth_id_x_top[where_test_x,j]
         Glob_Strip_id_x_test_temp = Glob_Strip_id_x_top[where_test_x,j]
         Glob_Si_id_x_test_temp = Glob_Si_id_x_top[where_test_x,j]
         Glob_tray_id_x_test_temp = Glob_tray_id_x_top[where_test_x,j]
         Glob_plane_id_x_test_temp = Glob_plane_id_x_top[where_test_x,j]
         Glob_xpos_x_test_temp = Glob_xpos_x_top[where_test_x,j]
         Glob_zpos_x_test_temp = Glob_zpos_x_top[where_test_x,j]
         Glob_energy_dep_x_test_temp = Glob_energy_dep_x_top[where_test_x,j]
       endif
    
    
       where_test_y = where(Glob_energy_dep_y_top[*,j] GT 0.)
     
       if (where_test_y(0) NE -1) then begin
         Glob_vol_id_y_test_temp = Glob_vol_id_y_top[where_test_y,j]
         Glob_moth_id_y_test_temp = Glob_moth_id_y_top[where_test_y,j]
         Glob_Strip_id_y_test_temp = Glob_Strip_id_y_top[where_test_y,j]
         Glob_Si_id_y_test_temp = Glob_Si_id_y_top[where_test_y,j]
         Glob_tray_id_y_test_temp = Glob_tray_id_y_top[where_test_y,j]
         Glob_plane_id_y_test_temp = Glob_plane_id_y_top[where_test_y,j]
         Glob_ypos_y_test_temp = Glob_ypos_y_top[where_test_y,j]
         Glob_zpos_y_test_temp = Glob_zpos_y_top[where_test_y,j]
         Glob_energy_dep_y_test_temp = Glob_energy_dep_y_top[where_test_y,j]
       endif
    
       if ((where_test_y(0) NE -1) AND (where_test_x(0) NE -1)) then begin
        Glob_vol_id_test_temp = [Glob_vol_id_y_test_temp, Glob_vol_id_x_test_temp]
        Glob_moth_id_test_temp = [Glob_moth_id_y_test_temp, Glob_moth_id_x_test_temp]
        Glob_Strip_id_test_temp = [Glob_Strip_id_y_test_temp, Glob_Strip_id_x_test_temp]
        Glob_Si_id_test_temp = [Glob_Si_id_y_test_temp, Glob_Si_id_x_test_temp]
        Glob_tray_id_test_temp = [Glob_tray_id_y_test_temp, Glob_tray_id_x_test_temp]
        Glob_plane_id_test_temp = [Glob_plane_id_y_test_temp, Glob_plane_id_x_test_temp]
        Glob_pos_test_temp = [Glob_ypos_y_test_temp, Glob_xpos_x_test_temp]
        Glob_zpos_test_temp = [Glob_zpos_y_test_temp, Glob_zpos_x_test_temp]
        Glob_energy_dep_test_temp = [Glob_energy_dep_y_test_temp, Glob_energy_dep_x_test_temp]
       endif else begin
        if ((where_test_y(0) NE -1) AND (where_test_x(0) EQ -1)) then begin
         Glob_vol_id_test_temp = Glob_vol_id_y_test_temp
         Glob_moth_id_test_temp = Glob_moth_id_y_test_temp
         Glob_Strip_id_test_temp = Glob_Strip_id_y_test_temp
         Glob_Si_id_test_temp = Glob_Si_id_y_test_temp
         Glob_tray_id_test_temp = Glob_tray_id_y_test_temp
         Glob_plane_id_test_temp = Glob_plane_id_y_test_temp
         Glob_pos_test_temp = Glob_ypos_y_test_temp
         Glob_zpos_test_temp = Glob_zpos_y_test_temp
         Glob_energy_dep_test_temp = Glob_energy_dep_y_test_temp
        endif else begin
         if ((where_test_y(0) EQ -1) AND (where_test_x(0) NE -1)) then begin
          Glob_vol_id_test_temp = Glob_vol_id_x_test_temp
          Glob_moth_id_test_temp = Glob_moth_id_x_test_temp
          Glob_Strip_id_test_temp = Glob_Strip_id_x_test_temp
          Glob_Si_id_test_temp = Glob_Si_id_x_test_temp
          Glob_tray_id_test_temp = Glob_tray_id_x_test_temp
          Glob_plane_id_test_temp = Glob_plane_id_x_test_temp
          Glob_pos_test_temp = Glob_xpos_x_test_temp
          Glob_zpos_test_temp = Glob_zpos_x_test_temp
          Glob_energy_dep_test_temp = Glob_energy_dep_x_test_temp
         endif
        endelse
       endelse   
       
       tray_sort_arr = sort(Glob_tray_id_test_temp)
        
       Glob_vol_id_test_temp = Glob_vol_id_test_temp[reverse(tray_sort_arr)]
       Glob_moth_id_test_temp = Glob_moth_id_test_temp[reverse(tray_sort_arr)]
       Glob_Strip_id_test_temp = Glob_Strip_id_test_temp[reverse(tray_sort_arr)]
       Glob_Si_id_test_temp = Glob_Si_id_test_temp[reverse(tray_sort_arr)]
       Glob_tray_id_test_temp = Glob_tray_id_test_temp[reverse(tray_sort_arr)]
       Glob_plane_id_test_temp = Glob_plane_id_test_temp[reverse(tray_sort_arr)]
       Glob_pos_test_temp = Glob_pos_test_temp[reverse(tray_sort_arr)]
       Glob_zpos_test_temp = Glob_zpos_test_temp[reverse(tray_sort_arr)]
       Glob_energy_dep_test_temp = Glob_energy_dep_test_temp[reverse(tray_sort_arr)]
    
       vol_id_intray = -1l
       moth_id_intray = -1l
       Strip_id_intray = -1l
       Si_id_intray = -1l
       tray_id_intray = -1l
       plane_id_intray = -1l
       pos_intray = -1.
       zpos_intray = -1.
       energy_dep_intray = -1.
           
        intray = 0l
        while(1) do begin
           where_tray_eq = where(Glob_tray_id_test_temp EQ Glob_tray_id_test_temp(intray), complement = where_other_tray)
           
           vol_id_extract = Glob_vol_id_test_temp[where_tray_eq]
           moth_id_extract = Glob_moth_id_test_temp[where_tray_eq]
           Strip_id_extract = Glob_Strip_id_test_temp[where_tray_eq]
           Si_id_extract = Glob_Si_id_test_temp[where_tray_eq]
           tray_id_extract = Glob_tray_id_test_temp[where_tray_eq]
           plane_id_extract = Glob_plane_id_test_temp[where_tray_eq]
           pos_extract = Glob_pos_test_temp[where_tray_eq]
           zpos_extract = Glob_zpos_test_temp[where_tray_eq]
           energy_dep_extract = Glob_energy_dep_test_temp[where_tray_eq]
           
           where_Y = where(Si_id_extract EQ 1)
           if (where_Y(0) NE -1) then begin
             vol_id_intray = [vol_id_intray, vol_id_extract[where_Y]]
             moth_id_intray = [moth_id_intray, moth_id_extract[where_Y]]
             Strip_id_intray = [Strip_id_intray, Strip_id_extract[where_Y]]
             Si_id_intray = [Si_id_intray, Si_id_extract[where_Y]]
             tray_id_intray = [tray_id_intray, tray_id_extract[where_Y]]
             plane_id_intray = [plane_id_intray, plane_id_extract[where_Y]]
             pos_intray = [pos_intray, pos_extract[where_Y]]
             zpos_intray = [zpos_intray, zpos_extract[where_Y]]
             energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_Y]]         
           endif
           where_X = where(Si_id_extract EQ 0)
           if (where_X(0) NE -1) then begin
             vol_id_intray = [vol_id_intray, vol_id_extract[where_X]]
             moth_id_intray = [moth_id_intray, moth_id_extract[where_X]]
             Strip_id_intray = [Strip_id_intray, Strip_id_extract[where_X]]
             Si_id_intray = [Si_id_intray, Si_id_extract[where_X]]
             tray_id_intray = [tray_id_intray, tray_id_extract[where_X]]
             plane_id_intray = [plane_id_intray, plane_id_extract[where_X]]
             pos_intray = [pos_intray, pos_extract[where_X]]
             zpos_intray = [zpos_intray, zpos_extract[where_X]]
             energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_X]]         
           endif
         N_tray_eq = n_elements(where_tray_eq)
         if where_tray_eq(N_tray_eq-1) LT (n_elements(Glob_tray_id_test_temp)-1) then begin
          intray = where_tray_eq(N_tray_eq-1)+1
         endif else break
        endwhile
        
       
        vol_id_temp = vol_id_intray[1:*]
        moth_id_temp = moth_id_intray[1:*]
        Strip_id_temp = Strip_id_intray[1:*]
        Si_id_temp = Si_id_intray[1:*]
        tray_id_temp = tray_id_intray[1:*]
        plane_id_temp = plane_id_intray[1:*]
        pos_temp = pos_intray[1:*]
        zpos_temp = zpos_intray[1:*]
        energy_dep_temp = energy_dep_intray[1:*]
        
        event_id_temp = lonarr(n_elements(vol_id_temp))
        for k=0l, n_elements(vol_id_temp)-1 do begin
         event_id_temp(k) = event_array(j)
        endfor
        
        Glob_event_id_test = [Glob_event_id_test, event_id_temp]
        Glob_vol_id_test = [Glob_vol_id_test, vol_id_temp]
        Glob_moth_id_test= [Glob_moth_id_test, moth_id_temp] 
        Glob_Strip_id_test = [Glob_Strip_id_test, Strip_id_temp]
        Glob_Si_id_test = [Glob_Si_id_test, Si_id_temp]
        Glob_tray_id_test = [Glob_tray_id_test, tray_id_temp]
        Glob_plane_id_test = [Glob_plane_id_test, plane_id_temp]
        Glob_pos_test = [Glob_pos_test, pos_temp]
        Glob_zpos_test = [Glob_zpos_test, zpos_temp]
        Glob_energy_dep_test = [Glob_energy_dep_test, energy_dep_temp]
    
    endfor
    
    Glob_event_id_test = Glob_event_id_test[1:*]
    Glob_vol_id_test =  Glob_vol_id_test[1:*]
    Glob_moth_id_test =  Glob_moth_id_test[1:*]
    Glob_Strip_id_test =  Glob_Strip_id_test[1:*]
    Glob_Si_id_test =  Glob_Si_id_test[1:*]
    Glob_tray_id_test =  Glob_tray_id_test[1:*]
    Glob_plane_id_test =  Glob_plane_id_test[1:*]
    Glob_pos_test = Glob_pos_test[1:*]
    Glob_zpos_test = Glob_zpos_test[1:*]
    Glob_energy_dep_test = Glob_energy_dep_test[1:*]
    
    
    ; Level 0 = energy summed
    ; Level 0 = the events are sorted in tray, and Y before X within the same tray
    ; energy threshold applied
    
    CREATE_STRUCT, L0TRACKERGLOBAL, 'GLOBALTRACKERL0', ['EVT_ID', 'VOLUME_ID', 'MOTHER_ID', 'TRAY_ID', 'PLANE_ID','TRK_FLAG', 'STRIP_ID', 'POS', 'ZPOS','E_DEP'], 'I,J,J,I,I,I,J,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(Glob_event_id_test)
    L0TRACKERGLOBAL.EVT_ID = Glob_event_id_test
    L0TRACKERGLOBAL.VOLUME_ID = Glob_vol_id_test
    L0TRACKERGLOBAL.MOTHER_ID = Glob_moth_id_test
    L0TRACKERGLOBAL.TRAY_ID = Glob_tray_id_test
    L0TRACKERGLOBAL.PLANE_ID = Glob_plane_id_test
    L0TRACKERGLOBAL.TRK_FLAG = Glob_Si_id_test
    L0TRACKERGLOBAL.STRIP_ID = Glob_Strip_id_test
    L0TRACKERGLOBAL.POS = Glob_pos_test
    L0TRACKERGLOBAL.ZPOS = Glob_zpos_test
    L0TRACKERGLOBAL.E_DEP = Glob_energy_dep_test
    
    HDR_L0GLOBAL = ['Creator          = Valentina Fioretti', $
              'THELSIM release  = ASTROGAM '+astrogam_version, $
              'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
              'N_TRIG           = '+STRTRIM(STRING(N_TRIG),1)+'   /Number of triggering events', $
              'ENERGY           = '+ene_type+'   /Simulated input energy', $
              'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
              'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
              'ENERGY UNIT      = KEV']
    
    
    MWRFITS, L0TRACKERGLOBAL, outdir+'/L0.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', HDR_L0GLOBAL, /CREATE
    
	
	
        
        print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
        print, '                      Tracker   '
        print, '       L0.5 - cluster baricenter '
        print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
         
                  
        Glob_event_id_x_top_cluster = -1l 
        Glob_Si_id_x_top_cluster = -1l 
        Glob_tray_id_x_top_cluster = -1l
        Glob_plane_id_x_top_cluster = -1l 
        Glob_xpos_x_top_cluster = -1.
        Glob_zpos_x_top_cluster = -1.
        Glob_energy_dep_x_top_cluster = -1. 
        
        Glob_event_id_y_top_cluster = -1l 
        Glob_Si_id_y_top_cluster = -1l 
        Glob_tray_id_y_top_cluster = -1l 
        Glob_plane_id_y_top_cluster = -1l
        Glob_ypos_y_top_cluster = -1. 
        Glob_zpos_y_top_cluster = -1.
        Glob_energy_dep_y_top_cluster = -1. 
        

        print, 'N_trig: ', N_trig 
           
        for k=0l, N_trig-1 do begin
        
         N_start = 0l
         j=0l
         while (1) do begin
 
            ; sorting the planes
            sort_ascending_plane_x = sort(Glob_plane_id_x_top(*, k))
            Glob_vol_id_x_top_tray = Glob_vol_id_x_top[sort_ascending_plane_x, k]
            Glob_moth_id_x_top_tray = Glob_moth_id_x_top[sort_ascending_plane_x, k]
            Glob_Strip_id_x_top_tray = Glob_Strip_id_x_top[sort_ascending_plane_x, k]
            Glob_Si_id_x_top_tray = Glob_Si_id_x_top[sort_ascending_plane_x, k]
            Glob_tray_id_x_top_tray = Glob_tray_id_x_top[sort_ascending_plane_x, k]
            Glob_plane_id_x_top_tray = Glob_plane_id_x_top[sort_ascending_plane_x, k]
            Glob_xpos_x_top_tray = Glob_xpos_x_top[sort_ascending_plane_x, k]
            Glob_zpos_x_top_tray = Glob_zpos_x_top[sort_ascending_plane_x, k]
            Glob_energy_dep_x_top_tray = Glob_energy_dep_x_top[sort_ascending_plane_x, k]
            
            where_tray_eq_x_top = where(Glob_tray_id_x_top_tray EQ Glob_tray_id_x_top_tray(j))
            
            Glob_vol_id_x_top_tray = Glob_vol_id_x_top_tray[where_tray_eq_x_top]
            Glob_moth_id_x_top_tray = Glob_moth_id_x_top_tray[where_tray_eq_x_top]
            Glob_Strip_id_x_top_tray = Glob_Strip_id_x_top_tray[where_tray_eq_x_top]
            Glob_Si_id_x_top_tray = Glob_Si_id_x_top_tray[where_tray_eq_x_top]
            Glob_tray_id_x_top_tray = Glob_tray_id_x_top_tray[where_tray_eq_x_top]
            Glob_plane_id_x_top_tray = Glob_plane_id_x_top_tray[where_tray_eq_x_top]
            Glob_xpos_x_top_tray = Glob_xpos_x_top_tray[where_tray_eq_x_top]
            Glob_zpos_x_top_tray = Glob_zpos_x_top_tray[where_tray_eq_x_top]
            Glob_energy_dep_x_top_tray = Glob_energy_dep_x_top_tray[where_tray_eq_x_top]
            
            where_layer_x_top = where((Glob_Si_id_x_top_tray EQ 0) and (Glob_energy_dep_x_top_tray GT 0.))
            ;print, k
            ;print, where_layer_x_top
            if (where_layer_x_top(0) NE -1) then begin
              Glob_vol_id_x_top_tray = Glob_vol_id_x_top_tray[where_layer_x_top]
              Glob_moth_id_x_top_tray = Glob_moth_id_x_top_tray[where_layer_x_top]
              Glob_Strip_id_x_top_tray = Glob_Strip_id_x_top_tray[where_layer_x_top]
              Glob_Si_id_x_top_tray = Glob_Si_id_x_top_tray[where_layer_x_top]
              Glob_tray_id_x_top_tray = Glob_tray_id_x_top_tray[where_layer_x_top]
              Glob_plane_id_x_top_tray = Glob_plane_id_x_top_tray[where_layer_x_top]
              Glob_xpos_x_top_tray = Glob_xpos_x_top_tray[where_layer_x_top]
              Glob_zpos_x_top_tray = Glob_zpos_x_top_tray[where_layer_x_top]
              Glob_energy_dep_x_top_tray = Glob_energy_dep_x_top_tray[where_layer_x_top] 

              e_cluster_temp = Glob_energy_dep_x_top_tray(0)
              wx_cluster_temp = Glob_xpos_x_top_tray(0)*Glob_energy_dep_x_top_tray(0)
              
              ;print, 'k:', k
              ;print, 'n of same strip: ', n_elements(Glob_Strip_id_x_top_tray)
              
              if (n_elements(Glob_Strip_id_x_top_tray) EQ 1) then begin
                  Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                  Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray]
                  Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray]
                  Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray]
                  Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray]
                  Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, total(e_cluster_temp)]
                  Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]         
              endif else begin
               sort_strip_ascending = sort(Glob_Strip_id_x_top_tray)
               Glob_vol_id_x_top_tray = Glob_vol_id_x_top_tray[sort_strip_ascending]
               Glob_moth_id_x_top_tray = Glob_moth_id_x_top_tray[sort_strip_ascending]
               Glob_Strip_id_x_top_tray = Glob_Strip_id_x_top_tray[sort_strip_ascending]
               Glob_Si_id_x_top_tray = Glob_Si_id_x_top_tray[sort_strip_ascending]
               Glob_tray_id_x_top_tray = Glob_tray_id_x_top_tray[sort_strip_ascending]
               Glob_plane_id_x_top_tray = Glob_plane_id_x_top_tray[sort_strip_ascending]
               Glob_xpos_x_top_tray = Glob_xpos_x_top_tray[sort_strip_ascending]
               Glob_zpos_x_top_tray = Glob_zpos_x_top_tray[sort_strip_ascending]
               Glob_energy_dep_x_top_tray = Glob_energy_dep_x_top_tray[sort_strip_ascending] 
               ;print, 'plane: ', Glob_plane_id_x_top_tray(0)
               ;print, 'pos: ', Glob_xpos_x_top_tray
               ;print, 'energy: ',  Glob_energy_dep_x_top_tray
               for jc=0l, n_elements(Glob_Strip_id_x_top_tray) -2 do begin
                 if (Glob_Strip_id_x_top_tray(jc+1) EQ (Glob_Strip_id_x_top_tray(jc)+1)) then begin
                    e_cluster_temp = [e_cluster_temp, Glob_energy_dep_x_top_tray(jc+1)]
                    wx_cluster_temp = [wx_cluster_temp, Glob_xpos_x_top_tray(jc + 1)*Glob_energy_dep_x_top_tray(jc+1)]
                    if (jc EQ (n_elements(Glob_Strip_id_x_top_tray)-2)) then begin
                             Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                             Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray(jc)]
                             Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray(jc)]
                             Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray(jc)]
                             Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray(jc)]
                             Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, total(e_cluster_temp)]
                             Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                    endif             
                 endif else begin
                      Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                      Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray(jc)]
                      Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray(jc)]
                      Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray(jc)]
                      Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray(jc)]
                      Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, total(e_cluster_temp)]
                      Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                      e_cluster_temp = Glob_energy_dep_x_top_tray(jc+1)
                      wx_cluster_temp = Glob_xpos_x_top_tray(jc+1)*Glob_energy_dep_x_top_tray(jc+1)
                      if (jc EQ (n_elements(Glob_Strip_id_x_top_tray)-2)) then begin
                         Glob_event_id_x_top_cluster = [Glob_event_id_x_top_cluster, k]
                         Glob_Si_id_x_top_cluster = [Glob_Si_id_x_top_cluster, Glob_Si_id_x_top_tray(jc+1)]
                         Glob_tray_id_x_top_cluster = [Glob_tray_id_x_top_cluster, Glob_tray_id_x_top_tray(jc+1)]
                         Glob_plane_id_x_top_cluster = [Glob_plane_id_x_top_cluster, Glob_plane_id_x_top_tray(jc+1)]
                         Glob_zpos_x_top_cluster = [Glob_zpos_x_top_cluster, Glob_zpos_x_top_tray(jc+1)]
                         Glob_energy_dep_x_top_cluster = [Glob_energy_dep_x_top_cluster, Glob_energy_dep_x_top_tray(jc+1)]
                         Glob_xpos_x_top_cluster = [Glob_xpos_x_top_cluster, Glob_xpos_x_top_tray(jc +1)]
                      endif
                  endelse
               endfor
               ;print, 'Glob_xpos_x_top_cluster: ', Glob_xpos_x_top_cluster
               ;print, 'Glob_energy_dep_x_top_cluster: ', Glob_energy_dep_x_top_cluster 
             endelse    
            endif
               
            N_tray_eq_x = n_elements(where_tray_eq_x_top)
            if where_tray_eq_x_top(N_tray_eq_x-1) LT (n_elements(Glob_tray_id_x_top(*,k))-1) then begin
              j = where_tray_eq_x_top(N_tray_eq_x-1)+1
            endif else break
         endwhile
        
        endfor
        
        Glob_event_id_x_top_cluster = Glob_event_id_x_top_cluster[1:*]  
        Glob_Si_id_x_top_cluster = Glob_Si_id_x_top_cluster[1:*]  
        Glob_tray_id_x_top_cluster = Glob_tray_id_x_top_cluster[1:*]
        Glob_plane_id_x_top_cluster = Glob_plane_id_x_top_cluster[1:*] 
        Glob_xpos_x_top_cluster = Glob_xpos_x_top_cluster[1:*]
        Glob_zpos_x_top_cluster = Glob_zpos_x_top_cluster[1:*]
        Glob_energy_dep_x_top_cluster = Glob_energy_dep_x_top_cluster[1:*] 
    
    
        for k=0l, N_trig-1 do begin
        
         N_start = 0l
         j=0l
         while (1) do begin
 
            ; sorting the planes
            sort_ascending_plane_y = sort(Glob_plane_id_y_top(*, k))
            Glob_vol_id_y_top_tray = Glob_vol_id_y_top[sort_ascending_plane_y, k]
            Glob_moth_id_y_top_tray = Glob_moth_id_y_top[sort_ascending_plane_y, k]
            Glob_Strip_id_y_top_tray = Glob_Strip_id_y_top[sort_ascending_plane_y, k]
            Glob_Si_id_y_top_tray = Glob_Si_id_y_top[sort_ascending_plane_y, k]
            Glob_tray_id_y_top_tray = Glob_tray_id_y_top[sort_ascending_plane_y, k]
            Glob_plane_id_y_top_tray = Glob_plane_id_y_top[sort_ascending_plane_y, k]
            Glob_ypos_y_top_tray = Glob_ypos_y_top[sort_ascending_plane_y, k]
            Glob_zpos_y_top_tray = Glob_zpos_y_top[sort_ascending_plane_y, k]
            Glob_energy_dep_y_top_tray = Glob_energy_dep_y_top[sort_ascending_plane_y, k]
            
            where_tray_eq_y_top = where(Glob_tray_id_y_top_tray EQ Glob_tray_id_y_top_tray(j))
            
            Glob_vol_id_y_top_tray = Glob_vol_id_y_top_tray[where_tray_eq_y_top]
            Glob_moth_id_y_top_tray = Glob_moth_id_y_top_tray[where_tray_eq_y_top]
            Glob_Strip_id_y_top_tray = Glob_Strip_id_y_top_tray[where_tray_eq_y_top]
            Glob_Si_id_y_top_tray = Glob_Si_id_y_top_tray[where_tray_eq_y_top]
            Glob_tray_id_y_top_tray = Glob_tray_id_y_top_tray[where_tray_eq_y_top]
            Glob_plane_id_y_top_tray = Glob_plane_id_y_top_tray[where_tray_eq_y_top]
            Glob_ypos_y_top_tray = Glob_ypos_y_top_tray[where_tray_eq_y_top]
            Glob_zpos_y_top_tray = Glob_zpos_y_top_tray[where_tray_eq_y_top]
            Glob_energy_dep_y_top_tray = Glob_energy_dep_y_top_tray[where_tray_eq_y_top]
            
            where_layer_y_top = where((Glob_Si_id_y_top_tray EQ 1) and (Glob_energy_dep_y_top_tray GT 0.))
            ;print, k
            ;print, where_layer_y_top
            if (where_layer_y_top(0) NE -1) then begin
              Glob_vol_id_y_top_tray = Glob_vol_id_y_top_tray[where_layer_y_top]
              Glob_moth_id_y_top_tray = Glob_moth_id_y_top_tray[where_layer_y_top]
              Glob_Strip_id_y_top_tray = Glob_Strip_id_y_top_tray[where_layer_y_top]
              Glob_Si_id_y_top_tray = Glob_Si_id_y_top_tray[where_layer_y_top]
              Glob_tray_id_y_top_tray = Glob_tray_id_y_top_tray[where_layer_y_top]
              Glob_plane_id_y_top_tray = Glob_plane_id_y_top_tray[where_layer_y_top]
              Glob_ypos_y_top_tray = Glob_ypos_y_top_tray[where_layer_y_top]
              Glob_zpos_y_top_tray = Glob_zpos_y_top_tray[where_layer_y_top]
              Glob_energy_dep_y_top_tray = Glob_energy_dep_y_top_tray[where_layer_y_top] 

              e_cluster_temp = Glob_energy_dep_y_top_tray(0)
              wx_cluster_temp = Glob_ypos_y_top_tray(0)*Glob_energy_dep_y_top_tray(0)
              
              ;print, 'k:', k
              ;print, 'n of same strip: ', n_elements(Glob_Strip_id_y_top_tray)
              
              if (n_elements(Glob_Strip_id_y_top_tray) EQ 1) then begin
                  Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                  Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray]
                  Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray]
                  Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray]
                  Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray]
                  Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, total(e_cluster_temp)]
                  Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]         
              endif else begin
               sort_strip_ascending = sort(Glob_Strip_id_y_top_tray)
               Glob_vol_id_y_top_tray = Glob_vol_id_y_top_tray[sort_strip_ascending]
               Glob_moth_id_y_top_tray = Glob_moth_id_y_top_tray[sort_strip_ascending]
               Glob_Strip_id_y_top_tray = Glob_Strip_id_y_top_tray[sort_strip_ascending]
               Glob_Si_id_y_top_tray = Glob_Si_id_y_top_tray[sort_strip_ascending]
               Glob_tray_id_y_top_tray = Glob_tray_id_y_top_tray[sort_strip_ascending]
               Glob_plane_id_y_top_tray = Glob_plane_id_y_top_tray[sort_strip_ascending]
               Glob_ypos_y_top_tray = Glob_ypos_y_top_tray[sort_strip_ascending]
               Glob_zpos_y_top_tray = Glob_zpos_y_top_tray[sort_strip_ascending]
               Glob_energy_dep_y_top_tray = Glob_energy_dep_y_top_tray[sort_strip_ascending] 
               ;print, 'plane: ', Glob_plane_id_y_top_tray(0)
               ;print, 'pos: ', Glob_ypos_y_top_tray
               ;print, 'energy: ',  Glob_energy_dep_y_top_tray
               for jc=0l, n_elements(Glob_Strip_id_y_top_tray) -2 do begin
                 if (Glob_Strip_id_y_top_tray(jc+1) EQ (Glob_Strip_id_y_top_tray(jc)+1)) then begin
                    e_cluster_temp = [e_cluster_temp, Glob_energy_dep_y_top_tray(jc+1)]
                    wx_cluster_temp = [wx_cluster_temp, Glob_ypos_y_top_tray(jc + 1)*Glob_energy_dep_y_top_tray(jc+1)]
                    if (jc EQ (n_elements(Glob_Strip_id_y_top_tray)-2)) then begin
                             Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                             Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray(jc)]
                             Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray(jc)]
                             Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray(jc)]
                             Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray(jc)]
                             Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, total(e_cluster_temp)]
                             Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                    endif             
                 endif else begin
                      Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                      Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray(jc)]
                      Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray(jc)]
                      Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray(jc)]
                      Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray(jc)]
                      Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, total(e_cluster_temp)]
                      Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, total(wx_cluster_temp)/total(e_cluster_temp)]
                      e_cluster_temp = Glob_energy_dep_y_top_tray(jc+1)
                      wx_cluster_temp = Glob_ypos_y_top_tray(jc+1)*Glob_energy_dep_y_top_tray(jc+1)
                      if (jc EQ (n_elements(Glob_Strip_id_y_top_tray)-2)) then begin
                         Glob_event_id_y_top_cluster = [Glob_event_id_y_top_cluster, k]
                         Glob_Si_id_y_top_cluster = [Glob_Si_id_y_top_cluster, Glob_Si_id_y_top_tray(jc+1)]
                         Glob_tray_id_y_top_cluster = [Glob_tray_id_y_top_cluster, Glob_tray_id_y_top_tray(jc+1)]
                         Glob_plane_id_y_top_cluster = [Glob_plane_id_y_top_cluster, Glob_plane_id_y_top_tray(jc+1)]
                         Glob_zpos_y_top_cluster = [Glob_zpos_y_top_cluster, Glob_zpos_y_top_tray(jc+1)]
                         Glob_energy_dep_y_top_cluster = [Glob_energy_dep_y_top_cluster, Glob_energy_dep_y_top_tray(jc+1)]
                         Glob_ypos_y_top_cluster = [Glob_ypos_y_top_cluster, Glob_ypos_y_top_tray(jc +1)]
                      endif
                  endelse
               endfor
               ;print, 'Glob_ypos_y_top_cluster: ', Glob_ypos_y_top_cluster
               ;print, 'Glob_energy_dep_y_top_cluster: ', Glob_energy_dep_y_top_cluster 
             endelse    
            endif
               
            N_tray_eq_y = n_elements(where_tray_eq_y_top)
            if where_tray_eq_y_top(N_tray_eq_y-1) LT (n_elements(Glob_tray_id_y_top(*,k))-1) then begin
              j = where_tray_eq_y_top(N_tray_eq_y-1)+1
            endif else break
         endwhile
        
        endfor
        
        Glob_event_id_y_top_cluster = Glob_event_id_y_top_cluster[1:*]  
        Glob_Si_id_y_top_cluster = Glob_Si_id_y_top_cluster[1:*]  
        Glob_tray_id_y_top_cluster = Glob_tray_id_y_top_cluster[1:*]
        Glob_plane_id_y_top_cluster = Glob_plane_id_y_top_cluster[1:*] 
        Glob_ypos_y_top_cluster = Glob_ypos_y_top_cluster[1:*]
        Glob_zpos_y_top_cluster = Glob_zpos_y_top_cluster[1:*]
        Glob_energy_dep_y_top_cluster = Glob_energy_dep_y_top_cluster[1:*]     

        
        print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
        print, '                      Tracker   '
        print, '             L0 - X-Y layers merging '
        print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'    
        
        
        Glob_event_id_cluster = -1l 
        Glob_Si_id_cluster = -1l 
        Glob_tray_id_cluster = -1l 
        Glob_plane_id_cluster = -1l 
        Glob_pos_cluster = -1.
        Glob_zpos_cluster = -1. 
        Glob_energy_dep_cluster = -1.
        
        for j=0l, N_trig -1 do begin
           
           where_cluster_x_top = where(Glob_event_id_x_top_cluster EQ j)
           ;print, j
           ;print, Glob_event_id_x_top_cluster(where_cluster_x_top)
           if (where_cluster_x_top(0) NE -1) then begin
           
             Glob_Si_id_cluster_temp = Glob_Si_id_x_top_cluster[where_cluster_x_top]
             Glob_tray_id_cluster_temp = Glob_tray_id_x_top_cluster[where_cluster_x_top]
             Glob_plane_id_cluster_temp = Glob_plane_id_x_top_cluster[where_cluster_x_top]
             Glob_pos_cluster_temp = Glob_xpos_x_top_cluster[where_cluster_x_top]
             Glob_zpos_cluster_temp = Glob_zpos_x_top_cluster[where_cluster_x_top]
             Glob_energy_dep_cluster_temp = Glob_energy_dep_x_top_cluster[where_cluster_x_top]
                    
             where_cluster_y_top = where(Glob_event_id_y_top_cluster EQ j)      
             if (where_cluster_y_top(0) NE -1) then begin
               Glob_Si_id_cluster_temp = [Glob_Si_id_cluster_temp, Glob_Si_id_y_top_cluster[where_cluster_y_top]]
               Glob_tray_id_cluster_temp = [Glob_tray_id_cluster_temp, Glob_tray_id_y_top_cluster[where_cluster_y_top]]
               Glob_plane_id_cluster_temp = [Glob_plane_id_cluster_temp, Glob_plane_id_y_top_cluster[where_cluster_y_top]]
               Glob_pos_cluster_temp = [Glob_pos_cluster_temp, Glob_ypos_y_top_cluster[where_cluster_y_top]]
               Glob_zpos_cluster_temp = [Glob_zpos_cluster_temp, Glob_zpos_y_top_cluster[where_cluster_y_top]]
               Glob_energy_dep_cluster_temp = [Glob_energy_dep_cluster_temp, Glob_energy_dep_y_top_cluster[where_cluster_y_top]]
             endif    
             
           endif else begin
                where_cluster_y_top = where(Glob_event_id_y_top_cluster EQ j)
                if (where_cluster_y_top(0) NE -1) then begin 
                   Glob_Si_id_cluster_temp = Glob_Si_id_y_top_cluster[where_cluster_y_top]
                   Glob_tray_id_cluster_temp = Glob_tray_id_y_top_cluster[where_cluster_y_top]
                   Glob_plane_id_cluster_temp = Glob_plane_id_y_top_cluster[where_cluster_y_top]
                   Glob_pos_cluster_temp = Glob_ypos_y_top_cluster[where_cluster_y_top]
                   Glob_zpos_cluster_temp = Glob_zpos_y_top_cluster[where_cluster_y_top]
                   Glob_energy_dep_cluster_temp = Glob_energy_dep_y_top_cluster[where_cluster_y_top]
    
                endif
           endelse
                  
           tray_sort_arr = sort(Glob_tray_id_cluster_temp)
            
           Glob_Si_id_cluster_temp = Glob_Si_id_cluster_temp[reverse(tray_sort_arr)]
           Glob_tray_id_cluster_temp = Glob_tray_id_cluster_temp[reverse(tray_sort_arr)]
           Glob_plane_id_cluster_temp = Glob_plane_id_cluster_temp[reverse(tray_sort_arr)]
           Glob_pos_cluster_temp = Glob_pos_cluster_temp[reverse(tray_sort_arr)]
           Glob_zpos_cluster_temp = Glob_zpos_cluster_temp[reverse(tray_sort_arr)]
           Glob_energy_dep_cluster_temp = Glob_energy_dep_cluster_temp[reverse(tray_sort_arr)]
        
           ;print, Glob_energy_dep_cluster_temp
           
           Si_id_intray = -1l
           tray_id_intray = -1l
           plane_id_intray = -1l
           pos_intray = -1.
           zpos_intray = -1.
           energy_dep_intray = -1.
               
            intray = 0l
            while(1) do begin
               where_tray_eq = where(Glob_tray_id_cluster_temp EQ Glob_tray_id_cluster_temp(intray), complement = where_other_tray)
               
               Si_id_extract = Glob_Si_id_cluster_temp[where_tray_eq]
               tray_id_extract = Glob_tray_id_cluster_temp[where_tray_eq]
               plane_id_extract = Glob_plane_id_cluster_temp[where_tray_eq]
               pos_extract = Glob_pos_cluster_temp[where_tray_eq]
               zpos_extract = Glob_zpos_cluster_temp[where_tray_eq]
               energy_dep_extract = Glob_energy_dep_cluster_temp[where_tray_eq]
               
               where_Xtop = where(Si_id_extract EQ 0)
               if (where_Xtop(0) NE -1) then begin
                 Si_id_intray = [Si_id_intray, Si_id_extract[where_Xtop]]
                 tray_id_intray = [tray_id_intray, tray_id_extract[where_Xtop]]
                 plane_id_intray = [plane_id_intray, plane_id_extract[where_Xtop]]
                 pos_intray = [pos_intray, pos_extract[where_Xtop]]
                 zpos_intray = [zpos_intray, zpos_extract[where_Xtop]]
                 energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_Xtop]]         
               endif
               where_Ytop = where(Si_id_extract EQ 1)
               if (where_Ytop(0) NE -1) then begin
                 Si_id_intray = [Si_id_intray, Si_id_extract[where_Ytop]]
                 tray_id_intray = [tray_id_intray, tray_id_extract[where_Ytop]]
                 plane_id_intray = [plane_id_intray, plane_id_extract[where_Ytop]]
                 pos_intray = [pos_intray, pos_extract[where_Ytop]]
                 zpos_intray = [zpos_intray, zpos_extract[where_Ytop]]
                 energy_dep_intray = [energy_dep_intray, energy_dep_extract[where_Ytop]]         
               endif

             N_tray_eq = n_elements(where_tray_eq)
             if where_tray_eq(N_tray_eq-1) LT (n_elements(Glob_tray_id_cluster_temp)-1) then begin
              intray = where_tray_eq(N_tray_eq-1)+1
             endif else break
            endwhile
            
            Si_id_temp = Si_id_intray[1:*]
            tray_id_temp = tray_id_intray[1:*]
            plane_id_temp = plane_id_intray[1:*]
            pos_temp = pos_intray[1:*]
            zpos_temp = zpos_intray[1:*]
            energy_dep_temp = energy_dep_intray[1:*]
            
            event_id_temp = lonarr(n_elements(Si_id_temp))
            for k=0l, n_elements(Si_id_temp)-1 do begin
             event_id_temp(k) = event_array(j)
            endfor
            
            Glob_event_id_cluster = [Glob_event_id_cluster, event_id_temp]
            Glob_Si_id_cluster = [Glob_Si_id_cluster, Si_id_temp]
            Glob_tray_id_cluster = [Glob_tray_id_cluster, tray_id_temp]
            Glob_plane_id_cluster = [Glob_plane_id_cluster, plane_id_temp]
            Glob_pos_cluster = [Glob_pos_cluster, pos_temp]
            Glob_zpos_cluster = [Glob_zpos_cluster, zpos_temp]
            Glob_energy_dep_cluster = [Glob_energy_dep_cluster, energy_dep_temp]
        
        endfor
        
        Glob_event_id_cluster = Glob_event_id_cluster[1:*]
        Glob_Si_id_cluster =  Glob_Si_id_cluster[1:*]
        Glob_tray_id_cluster =  Glob_tray_id_cluster[1:*]
        Glob_plane_id_cluster =  Glob_plane_id_cluster[1:*]
        Glob_pos_cluster = Glob_pos_cluster[1:*]
        Glob_zpos_cluster = Glob_zpos_cluster[1:*]
        Glob_energy_dep_cluster = Glob_energy_dep_cluster[1:*]
        
        
        ; Level 0.5 = energy summed, MIP threshold applied, strip position used 
        
        CREATE_STRUCT, L05TRACKER, 'TRACKERL05', ['EVT_ID', 'TRAY_ID','PLANE_ID','TRK_FLAG','POS', 'ZPOS','E_DEP'], 'J,I,I,I,F20.5,F20.5,F20.5', DIMEN = N_ELEMENTS(Glob_event_id_cluster)
        L05TRACKER.EVT_ID = Glob_event_id_cluster
        L05TRACKER.TRAY_ID = Glob_tray_id_cluster
        L05TRACKER.PLANE_ID = Glob_plane_id_cluster
        L05TRACKER.TRK_FLAG = Glob_Si_id_cluster
        L05TRACKER.POS = Glob_pos_cluster
        L05TRACKER.ZPOS = Glob_zpos_cluster
        L05TRACKER.E_DEP = Glob_energy_dep_cluster
        
        HDR_L05GLOBAL = ['Creator          = Valentina Fioretti', $
                  'THELSIM release  = ASTROGAM '+astrogam_version, $
                  'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
                  'N_TRIG           = '+STRTRIM(STRING(N_TRIG),1)+'   /Number of triggering events', $
                  'ENERGY           = '+ene_type+'   /Simulated input energy', $
                  'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
                  'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
                  'ENERGY UNIT      = KEV']
        
        
        MWRFITS, L05TRACKER, outdir+'/L0.5.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', HDR_L05GLOBAL, /CREATE
    
        
        print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
        print, '                      Summing all the volumes '
        print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
        
        ; cluster X and Y arrays for the GAMS input
       
        check_N_trig = 0
        max_arraydim_x = 0
        max_arraydim_y = 0
        
        eventid_kalman = fltarr(N_trig)
	theta_kalman = fltarr(N_trig)
        phi_kalman = fltarr(N_trig)
        energy_kalman = fltarr(N_trig)
        
        default_max_cols = 1000
        cluster_x_array = MAKE_ARRAY(default_max_cols, N_trig, /DOUBLE, VALUE = 0)
        cluster_y_array = MAKE_ARRAY(default_max_cols, N_trig, /DOUBLE, VALUE = 0)
        plane_x_array = MAKE_ARRAY(default_max_cols, N_trig, /INTEGER, VALUE = 0)
        plane_y_array = MAKE_ARRAY(default_max_cols, N_trig, /INTEGER, VALUE = 0)
        
        
        Glob_event_id_sum = -1l
        Glob_Si_id_sum = -1l
        Glob_tray_id_sum= -1l
        Glob_plane_id_sum = -1l
        Glob_zpos_sum = -1.
        Glob_energy_dep_sum = -1.  
        
        j=0l
        while (1) do begin
            
            where_event_eq = where(Glob_event_id_cluster EQ Glob_event_id_cluster(j))
            ;print, 'where_event_eq', where_event_eq
            
            where_clusterx = where((Glob_Si_id_cluster(where_event_eq) EQ 2) or (Glob_Si_id_cluster(where_event_eq) EQ 0))
            if (n_elements(where_clusterx) GT max_arraydim_x) then max_arraydim_x = n_elements(where_clusterx)
            temp_planex = intarr(n_elements(where_clusterx))
            temp_clusterx = dblarr(n_elements(where_clusterx))
            
            ;print, 'max_arraydim_x', max_arraydim_x
            ;print, 'where_clusterx', where_clusterx
            
            where_clustery = where((Glob_Si_id_cluster(where_event_eq) EQ 3) or (Glob_Si_id_cluster(where_event_eq) EQ 1))
            if (n_elements(where_clustery) GT max_arraydim_y) then max_arraydim_y = n_elements(where_clustery)
            temp_planey = intarr(n_elements(where_clustery))
            temp_clustery = dblarr(n_elements(where_clustery))
    
            counterx = 0
            countery = 0
            
            event_id_temp = Glob_event_id_cluster(where_event_eq)
            Si_id_temp = Glob_Si_id_cluster(where_event_eq) 
            tray_id_temp = Glob_tray_id_cluster(where_event_eq) 
            plane_id_temp = Glob_plane_id_cluster(where_event_eq) 
            pos_temp = Glob_pos_cluster(where_event_eq) 
            zpos_temp = Glob_zpos_cluster(where_event_eq) 
            energy_dep_temp = Glob_energy_dep_cluster(where_event_eq) 
        
            r=0
            while (1) do begin
                where_tray_eq = where(tray_id_temp EQ tray_id_temp(r))
                
                event_id_temp_tray = event_id_temp(where_tray_eq)
                tray_id_temp_tray = tray_id_temp(where_tray_eq)
                Si_id_temp_tray = Si_id_temp(where_tray_eq) 
                plane_id_temp_tray = plane_id_temp(where_tray_eq)
                pos_temp_tray = pos_temp(where_tray_eq)
                zpos_temp_tray = zpos_temp(where_tray_eq)
                energy_dep_temp_tray = energy_dep_temp(where_tray_eq)     
    
                t=0
                while (1) do begin
                     
                     where_plane_eq = where(plane_id_temp_tray EQ plane_id_temp_tray(t))
                     event_id_temp_plane = event_id_temp_tray(where_plane_eq)
                     tray_id_temp_plane = tray_id_temp_tray(where_plane_eq)
                     Si_id_temp_plane = Si_id_temp_tray(where_plane_eq) 
                     plane_id_temp_plane = plane_id_temp_tray(where_plane_eq)
                     pos_temp_plane = pos_temp_tray(where_plane_eq)
                     zpos_temp_plane = zpos_temp_tray(where_plane_eq)
                     energy_dep_temp_plane = energy_dep_temp_tray(where_plane_eq)     
                     
                     
                     last = 0
                     while (1) do begin
                         where_si_eq = where(Si_id_temp_plane EQ Si_id_temp_plane(last))
                         
			 
                         temp_samesi = pos_temp_plane(where_si_eq)
                         ; GAMS array 
                         if ((Si_id_temp_plane(last) EQ 2) or (Si_id_temp_plane(last) EQ 0)) then begin
                            for jel = 0l, n_elements(temp_samesi)-1 do begin
                                  temp_planex[jel + counterx] = plane_id_temp_tray(t)
                                  temp_clusterx[jel + counterx] = temp_samesi(jel) + (tray_side/2.)
                            endfor
                            counterx = counterx + n_elements(temp_samesi)
                         endif
                         if ((Si_id_temp_plane(last) EQ 3) or (Si_id_temp_plane(last) EQ 1)) then begin
                            for jel = 0l, n_elements(temp_samesi)-1 do begin
                                  temp_planey[jel + countery] = plane_id_temp_tray(t)
                                  temp_clustery[jel + countery] = temp_samesi(jel) + (tray_side/2.)
                            endfor
                            countery = countery + n_elements(temp_samesi)
                         endif
                         
                                         
                         Glob_event_id_sum = [Glob_event_id_sum, Glob_event_id_cluster(j)]                
                         Glob_Si_id_sum = [Glob_Si_id_sum, Si_id_temp_plane(last)]
                         Glob_tray_id_sum = [Glob_tray_id_sum, tray_id_temp(r)]
                         Glob_plane_id_sum = [Glob_plane_id_sum, plane_id_temp_tray(t)]
                         Glob_zpos_sum = [Glob_zpos_sum, zpos_temp_plane(last)]
                         Glob_energy_dep_sum = [Glob_energy_dep_sum, total(energy_dep_temp_plane(where_si_eq))]
                         
                         N_si_eq = n_elements(where_si_eq)
                         if where_si_eq(N_si_eq-1) LT (n_elements(Si_id_temp_plane)-1) then begin
                           last = where_si_eq(N_si_eq-1)+1
                         endif else break
                     endwhile
                     
                     N_plane_eq = n_elements(where_plane_eq)
                     if where_plane_eq(N_plane_eq-1) LT (n_elements(plane_id_temp_tray)-1) then begin
                       t = where_plane_eq(N_plane_eq-1)+1
                     endif else break
                endwhile
    

                
                
                N_tray_eq = n_elements(where_tray_eq)
                if where_tray_eq(N_tray_eq-1) LT (n_elements(tray_id_temp)-1) then begin
                  r = where_tray_eq(N_tray_eq-1)+1
                endif else break      
            endwhile
			 
           for jcol = 0, n_elements(temp_planex) -1 do begin 
                    plane_x_array[jcol, check_N_trig] = temp_planex[jcol]
                    cluster_x_array[jcol, check_N_trig] = temp_clusterx[jcol]
           endfor
           for jcol = 0, n_elements(temp_planey) -1 do begin 
                    plane_y_array[jcol, check_N_trig] = temp_planey[jcol]
                    cluster_y_array[jcol, check_N_trig] = temp_clustery[jcol]
            endfor
            
            eventid_kalman(check_N_trig) = Glob_event_id_cluster(j)
	    theta_kalman(check_N_trig) = theta_type
            phi_kalman(check_N_trig) = phi_type
            energy_kalman(check_N_trig) = ene_type
            
            check_N_trig = check_N_trig + 1
            
            N_event_eq = n_elements(where_event_eq)
            if where_event_eq(N_event_eq-1) LT (n_elements(Glob_event_id_cluster)-1) then begin
              j = where_event_eq(N_event_eq-1)+1
            endif else break
        endwhile
        
        max_cols = 0
        if (max_arraydim_x GT max_arraydim_y) then max_cols = max_arraydim_x
        if (max_arraydim_y GT max_arraydim_x) then max_cols = max_arraydim_y
    
        print, 'Max number of cols: ', max_cols
    
    ;    keepcols = indgen(max_cols)    
    ;    plane_x_array = plane_x_array[keepcols, *]
    ;    cluster_x_array = cluster_x_array[keepcols, *]    
    ;    plane_y_array = plane_y_array[keepcols, *]
    ;    cluster_y_array = cluster_y_array[keepcols, *]
        
        string_dim = string(default_max_cols)    
        CREATE_STRUCT, KALMANTRACKER, 'TRACKERKALMAN', ['Event_ID', 'Theta', 'Phi','Energia','Piani_X','Clusters_X', 'Piani_Y','Clusters_Y'], 'J,F,F,F,I('+string_dim+'),D('+string_dim+'),I('+string_dim+'),D('+string_dim+')', DIMEN = N_ELEMENTS(theta_kalman)
    
        KALMANTRACKER.Event_ID = float(eventid_kalman)
	KALMANTRACKER.Theta = float(theta_kalman)
        KALMANTRACKER.Phi = float(phi_kalman)
        KALMANTRACKER.Energia = float(energy_kalman)
        KALMANTRACKER.Piani_X = plane_x_array
        KALMANTRACKER.Clusters_X = cluster_x_array
        KALMANTRACKER.Piani_Y = plane_y_array
        KALMANTRACKER.Clusters_Y = cluster_y_array
       
             
        HDR_KALMAN = ['Creator          = Valentina Fioretti (INAF/IASF Bologna)', $
                  'THELSIM release  = ASTROGAM '+astrogam_version, $
                  'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
                  'N_TRIG           = '+STRTRIM(STRING(N_TRIG),1)+'   /Number of triggering events', $
                  'ENERGY           = '+ene_type+'   /Simulated input energy', $
                  'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
                  'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle']
        
        
        MWRFITS, KALMANTRACKER, outdir+'/KALMAN.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', HDR_KALMAN, /CREATE
        
        
        Glob_event_id_sum = Glob_event_id_sum[1:*]
        Glob_Si_id_sum =  Glob_Si_id_sum[1:*]
        Glob_tray_id_sum =  Glob_tray_id_sum[1:*]
        Glob_plane_id_sum =  Glob_plane_id_sum[1:*]
        Glob_zpos_sum = Glob_zpos_sum[1:*]
        Glob_energy_dep_sum = Glob_energy_dep_sum[1:*]
        
        
        CREATE_STRUCT, SUMTRACKER, 'TRACKERSUM', ['EVT_ID', 'TRAY_ID','PLANE_ID','TRK_FLAG','ZPOS','E_DEP'], 'J,I,I,I,F20.5,F20.5', DIMEN = N_ELEMENTS(Glob_event_id_sum)
        SUMTRACKER.EVT_ID = Glob_event_id_sum
        SUMTRACKER.TRAY_ID = Glob_tray_id_sum
        SUMTRACKER.PLANE_ID = Glob_plane_id_sum
        SUMTRACKER.TRK_FLAG = Glob_Si_id_sum
        SUMTRACKER.ZPOS = Glob_zpos_sum
        SUMTRACKER.E_DEP = Glob_energy_dep_sum
        
        HDR_SUM = ['Creator          = Valentina Fioretti', $
                  'THELSIM release  = ASTROGAM '+astrogam_version, $
                  'N_IN             = '+STRTRIM(STRING(N_IN),1)+'   /Number of simulated particles', $
                  'N_TRIG           = '+STRTRIM(STRING(N_TRIG),1)+'   /Number of triggering events', $
                  'ENERGY           = '+ene_type+'   /Simulated input energy', $
                  'THETA            = '+STRTRIM(STRING(THETA_TYPE),1)+'   /Simulated input theta angle', $
                  'PHI              = '+STRTRIM(STRING(PHI_TYPE),1)+'   /Simulated input phi angle', $
                  'ENERGY UNIT      = KEV']
        
        
        MWRFITS, SUMTRACKER, outdir+'/SUM.TRACKER.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+STRMID(STRTRIM(STRING(N_IN),1),0,10)+part_type+'.'+ene_type+'MeV.'+STRMID(STRTRIM(STRING(THETA_TYPE),1),0,10)+'.'+STRMID(STRTRIM(STRING(PHI_TYPE),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', HDR_SUM, /CREATE


endif


    ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ;                             Processing the calorimeter 
    ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '          Calorimeter Bar Energy attenuation                '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

    bar_ene = energy_dep_cal
    
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '                   Calorimeter                '
    print, '              Applying the minimum cut                '
    print, '                Summing the energy                '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
    N_trig_cal = 0l
    
    event_id_tot_cal = -1l
    vol_id_tot_cal = -1l
    moth_id_tot_cal = -1l
    bar_id_tot = -1l
    bar_ene_tot = -1.
    
    j=0l
    while (1) do begin
        where_event_eq = where(event_id_cal EQ event_id_cal(j))
        
        N_trig_cal = N_trig_cal + 1
        
        vol_id_temp_cal = vol_id_cal(where_event_eq) 
        moth_id_temp_cal = moth_id_cal(where_event_eq) 
        bar_ene_temp = bar_ene(where_event_eq)
            
        r = 0l
        while(1) do begin
           where_vol_eq = where(vol_id_temp_cal EQ vol_id_temp_cal(r), complement = where_other_vol)
           bar_ene_tot_temp = total(bar_ene_temp(where_vol_eq))
           if (bar_ene_tot_temp GE E_th_cal) then begin
             event_id_tot_cal = [event_id_tot_cal, event_id_cal(j)]
             vol_id_tot_cal = [vol_id_tot_cal, vol_id_temp_cal(r)]
             bar_id_tot = [bar_id_tot, vol_id_temp_cal(r) - cal_vol_start]
             moth_id_tot_cal = [moth_id_tot_cal, moth_id_temp_cal(r)]
             bar_ene_tot = [bar_ene_tot, total(bar_ene_temp(where_vol_eq))]
           endif
           if (where_other_vol(0) NE -1) then begin
             vol_id_temp_cal = vol_id_temp_cal(where_other_vol)
             moth_id_temp_cal = moth_id_temp_cal(where_other_vol)
             bar_ene_temp = bar_ene_temp(where_other_vol)
           endif else break
        endwhile
            
        N_event_eq = n_elements(where_event_eq)
        if where_event_eq(N_event_eq-1) LT (n_elements(event_id_cal)-1) then begin
          j = where_event_eq(N_event_eq-1)+1
        endif else break
    endwhile
    
    
    if (n_elements(event_id_tot_cal) GT 1) then begin
      event_id_tot_cal = event_id_tot_cal[1:*]
      vol_id_tot_cal = vol_id_tot_cal[1:*]
      bar_id_tot = bar_id_tot[1:*]
      moth_id_tot_cal = moth_id_tot_cal[1:*]
      bar_ene_tot = bar_ene_tot[1:*]
    endif
    
        
    CREATE_STRUCT, calInput, 'input_cal_astrogam', ['EVT_ID', 'BAR_ID', 'BAR_ENERGY'], $
    'I,I,F20.15', DIMEN = n_elements(event_id_tot_cal)
    calInput.EVT_ID = event_id_tot_cal 
    calInput.BAR_ID = bar_id_tot
    calInput.BAR_ENERGY = bar_ene_tot
    
    
    hdr_calInput = ['COMMENT  ASTROGAM V'+astrogam_version+' Geant4 simulation', $
                   'N_in     = '+strtrim(string(N_in),1), $
                   'Energy     = '+ene_type, $
                   'Theta     = '+strtrim(string(theta_type),1), $
                   'Phi     = '+strtrim(string(phi_type),1), $
                   'Energy unit = GeV']
    
    MWRFITS, calInput, outdir+'/G4.CAL.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', hdr_calInput, /create

    event_id_tot_cal_sum = -1l
    bar_ene_tot_sum = -1.
    
    j=0l
    while (1) do begin
        where_event_eq = where(event_id_tot_cal EQ event_id_tot_cal(j))
        
        event_id_tot_cal_sum = [event_id_tot_cal_sum, event_id_tot_cal(j)]
        bar_ene_tot_sum = [bar_ene_tot_sum, total(bar_ene_tot(where_event_eq))]
        
        N_event_eq = n_elements(where_event_eq)
        if where_event_eq(N_event_eq-1) LT (n_elements(event_id_tot_cal)-1) then begin
          j = where_event_eq(N_event_eq-1)+1
        endif else break
    endwhile

    event_id_tot_cal_sum = event_id_tot_cal_sum[1:*]
    bar_ene_tot_sum = bar_ene_tot_sum[1:*]

    CREATE_STRUCT, calInputSum, 'input_cal_sum', ['EVT_ID','BAR_ENERGY'], $
    'I,F20.15', DIMEN = n_elements(event_id_tot_cal_sum)
    calInputSum.EVT_ID = event_id_tot_cal_sum 
    calInputSum.BAR_ENERGY = bar_ene_tot_sum
    
    
    hdr_calInputSum = ['COMMENT  ASTROGAM V'+astrogam_version+' Geant4 simulation', $
                   'N_in     = '+strtrim(string(N_in),1), $
                   'Energy     = '+ene_type, $
                   'Theta     = '+strtrim(string(theta_type),1), $
                   'Phi     = '+strtrim(string(phi_type),1), $
                   'Energy unit = GeV']
    
    MWRFITS, calInput, outdir+'/SUM.CAL.ASTROGAM'+astrogam_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+part_type+'.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', hdr_calInputSum, /create

    
;    openw,lun,outdir+'/G4_GAMS_CAL_AGILE'+agile_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat',/get_lun
;    ; ASCII Columns:
;    ; - c1 = event ID
;    ; - c2 = bar plane 
;    ; - c3 = bar_id
;    ; - c4 = 0
;    ; - c5 = energy A
;    ; - c6 = energy B
;    
;    ; Invert the BAR id to fit with the GAMS system
;    ; BoGEMMS XBARv gives the inverted GAMS YBARk
;    ; BoGEMMS YBARv gives the GAMS XBARk
;    
;    
;    gams_bar_plane_tot = intarr(n_elements(bar_plane_tot))
;    gams_bar_id_tot = intarr(n_elements(bar_id_tot))
;    for jcal=0, n_elements(event_id_tot_cal)-1 do begin
;        if (bar_plane_tot(jcal) EQ 1) then begin
;           gams_bar_plane_tot(jcal) = 1
;           ; bar id starts from 1
;           gams_bar_id_tot(jcal) = bar_id_tot(jcal)
;        endif
;        if (bar_plane_tot(jcal) EQ 2) then begin
;           gams_bar_plane_tot(jcal) = 2
;           gams_bar_id_tot(jcal) = bar_id_tot(jcal)
;        endif
;    endfor
;    
;    
;    j=0l
;    while (1) do begin
;        printf, lun, (event_id_tot_cal(j)+1), gams_bar_plane_tot(j), gams_bar_id_tot(j), 0, ene_a_tot(j),ene_b_tot(j);, format='(I5,2x,I5,2x,I5,2x,I5,2x,F10.10,2x,F10.10)'
;
;        if (j LT (n_elements(event_id_tot_cal)-1)) then begin
;          j = j+1
;        endif else break
;    endwhile
;    
;    Free_lun, lun


    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print, '                          AC'
    print, '                  Summing the energy                '
    print, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    
;    N_trig_ac = 0l
;    
;    event_id_tot_ac = -1l
;    vol_id_tot_ac = -1l
;    moth_id_tot_ac = -1l
;    energy_dep_tot_ac = -1.
;    
;    j=0l
;    while (1) do begin
;        where_event_eq = where(event_id_ac EQ event_id_ac(j))
;        
;        N_trig_ac = N_trig_ac + 1
;        
;        vol_id_temp_ac = vol_id_ac(where_event_eq) 
;        moth_id_temp_ac = moth_id_ac(where_event_eq) 
;        energy_dep_temp_ac = energy_dep_ac(where_event_eq) 
;            
;        r = 0l
;        while(1) do begin
;           where_vol_eq = where(vol_id_temp_ac EQ vol_id_temp_ac(r), complement = where_other_vol)
;           event_id_tot_ac = [event_id_tot_ac, event_id_ac(j)]
;           vol_id_tot_ac = [vol_id_tot_ac, vol_id_temp_ac(r)]
;           moth_id_tot_ac = [moth_id_tot_ac, moth_id_temp_ac(r)]
;           energy_dep_tot_ac = [energy_dep_tot_ac, total(energy_dep_temp_ac(where_vol_eq))]
;           if (where_other_vol(0) NE -1) then begin
;             vol_id_temp_ac = vol_id_temp_ac(where_other_vol)
;             moth_id_temp_ac = moth_id_temp_ac(where_other_vol)
;             energy_dep_temp_ac = energy_dep_temp_ac(where_other_vol)
;           endif else break
;        endwhile
;            
;        N_event_eq = n_elements(where_event_eq)
;        if where_event_eq(N_event_eq-1) LT (n_elements(event_id_ac)-1) then begin
;          j = where_event_eq(N_event_eq-1)+1
;        endif else break
;    endwhile
;    
;    
;    if (n_elements(event_id_tot_ac) GT 1) then begin
;      event_id_tot_ac = event_id_tot_ac[1:*]
;      vol_id_tot_ac = vol_id_tot_ac[1:*]
;      moth_id_tot_ac = moth_id_tot_ac[1:*]
;      energy_dep_tot_ac = energy_dep_tot_ac[1:*]
;    endif
;    
;    ; AC panel IDs
;    
;    AC_panel = strarr(n_elements(vol_id_tot_ac))
;    AC_subpanel = intarr(n_elements(vol_id_tot_ac))
;    
;    
;    for j=0l, n_elements(vol_id_tot_ac)-1 do begin
;     if ((vol_id_tot_ac(j) GE panel_S[0]) AND (vol_id_tot_ac(j) LE panel_S[2])) then begin
;        AC_panel(j) = 'S'
;        if (vol_id_tot_ac(j) EQ panel_S[0]) then AC_subpanel(j) = 3
;        if (vol_id_tot_ac(j) EQ panel_S[1]) then AC_subpanel(j) = 2
;        if (vol_id_tot_ac(j) EQ panel_S[2]) then AC_subpanel(j) = 1
;     endif
;     if ((vol_id_tot_ac(j) GE panel_D[0]) AND (vol_id_tot_ac(j) LE panel_D[2])) then begin
;        AC_panel(j) = 'D'
;        if (vol_id_tot_ac(j) EQ panel_D[0]) then AC_subpanel(j) = 3
;        if (vol_id_tot_ac(j) EQ panel_D[1]) then AC_subpanel(j) = 2
;        if (vol_id_tot_ac(j) EQ panel_D[2]) then AC_subpanel(j) = 1
;     endif
;     if ((vol_id_tot_ac(j) GE panel_F[0]) AND (vol_id_tot_ac(j) LE panel_F[2])) then begin
;        AC_panel(j) = 'F'
;        if (vol_id_tot_ac(j) EQ panel_F[0]) then AC_subpanel(j) = 1
;        if (vol_id_tot_ac(j) EQ panel_F[1]) then AC_subpanel(j) = 2
;        if (vol_id_tot_ac(j) EQ panel_F[2]) then AC_subpanel(j) = 3
;     endif
;     if ((vol_id_tot_ac(j) GE panel_B[0]) AND (vol_id_tot_ac(j) LE panel_B[2])) then begin
;        AC_panel(j) = 'B'
;        if (vol_id_tot_ac(j) EQ panel_B[0]) then AC_subpanel(j) = 1
;        if (vol_id_tot_ac(j) EQ panel_B[1]) then AC_subpanel(j) = 2
;        if (vol_id_tot_ac(j) EQ panel_B[2]) then AC_subpanel(j) = 3
;     endif
;     if (vol_id_tot_ac(j) EQ panel_top) then begin
;        AC_panel(j) = 'T'
;        AC_subpanel(j) = 0
;     endif
;    endfor
;    
;    CREATE_STRUCT, acInput, 'input_ac_dhsim', ['EVT_ID', 'AC_PANEL', 'AC_SUBPANEL', 'E_DEP'], $
;    'I,A,I,F20.15', DIMEN = n_elements(event_id_tot_ac)
;    acInput.EVT_ID = event_id_tot_ac
;    acInput.AC_PANEL = AC_panel
;    acInput.AC_SUBPANEL = AC_subpanel
;    acInput.E_DEP = energy_dep_tot_ac
;    
;    
;    hdr_acInput = ['COMMENT  AGILE V2.0 Geant4 simulation', $
;                   'N_in     = '+strtrim(string(N_in),1), $
;                   'Energy     = '+ene_type, $
;                   'Theta     = '+strtrim(string(theta_type),1), $
;                   'Phi     = '+strtrim(string(phi_type),1), $
;                   'Energy unit = GeV']
;    
;    MWRFITS, acInput, outdir+'/G4.AC.AGILE'+agile_version+'.'+py_name+'.'+sim_name+'.'+stripname+'.'+sname+'.'+strmid(strtrim(string(N_in),1),0,10)+'ph.'+ene_type+'MeV.'+strmid(strtrim(string(theta_type),1),0,10)+'.'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.fits', hdr_acInput, /create
;    
;    openw,lun,outdir+'/G4_GAMS_AC_AGILE'+agile_version+'_'+py_name+'_'+sim_name+'_'+stripname+'_'+sname+'_'+strmid(strtrim(string(N_in),1),0,10)+'ph_'+ene_type+'MeV_'+strmid(strtrim(string(theta_type),1),0,10)+'_'+strmid(strtrim(string(phi_type),1),0,10)+'.'+strtrim(string(ifile),1)+'.dat',/get_lun
;    ; ASCII Columns:
;    ; - c1 = event ID
;    ; - c2 = AC panel
;    ; - c3 = AC subpanel
;    ; - c4 = energy deposit
;
;    
;    gams_AC_panel = AC_panel
;    ;gams_AC_panel = strarr(n_elements(AC_panel))
;    ;for jac=0, n_elements(event_id_tot)-1 do begin
;    ;    if (AC_panel(jac) EQ 'S') then gams_AC_panel(jac) = 'B'
;    ;    if (AC_panel(jac) EQ 'F') then gams_AC_panel(jac) = 'S'
;    ;    if (AC_panel(jac) EQ 'D') then gams_AC_panel(jac) = 'F'
;    ;    if (AC_panel(jac) EQ 'B') then gams_AC_panel(jac) = 'D'    
;    ;    if (AC_panel(jac) EQ 'T') then gams_AC_panel(jac) = 'T'    
;    ;endfor
;    
;    j=0l
;    while (1) do begin
;        printf, lun, (event_id_tot_ac(j)+1),gams_AC_panel(j), AC_subpanel(j), energy_dep_tot_ac(j), format='(I5,2x,A,2x,I5,2x,F20.15)'
;    
;        if (j LT (n_elements(event_id_tot_ac)-1)) then begin
;          j = j+1
;        endif else break
;    endwhile
;    
;    Free_lun, lun
    
    endfor
end
