\n\n#---------------------------------
# New invocation of recon-all Thu Jul  6 19:06:27 EDT 2017 
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/nii.gz/J21199-t1/GR_IR-Siemens_MPRAGE.nii.gz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz \n
#--------------------------------------------
#@# MotionCor Thu Jul  6 19:06:36 EDT 2017
\n cp /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz \n
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig.mgz \n
#--------------------------------------------
#@# Deface Thu Jul  6 19:06:46 EDT 2017
\n mri_deface orig.mgz /Volumes/CFMI-CFS/opt/fs6/average/talairach_mixed_with_skull.gca /Volumes/CFMI-CFS/opt/fs6/average/face.gca orig_defaced.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul  6 19:08:48 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm --atlas 3T18yoSchwartzReactN32_as_orig \n
talairach_avi log file is transforms/talairach_avi.log...
\n cp transforms/talairach.auto.xfm transforms/talairach.xfm \n
#--------------------------------------------
#@# Talairach Failure Detection Thu Jul  6 19:10:25 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Volumes/CFMI-CFS/opt/fs6/bin/extract_talairach_avi_QA.awk /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul  6 19:10:25 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --proto-iters 1000 --distance 50 --n 1 \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul  6 19:11:53 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul  6 19:13:55 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta \n
\n mri_watershed -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
#-------------------------------------
#@# EM Registration Thu Jul  6 19:24:00 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Thu Jul  6 19:34:23 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Thu Jul  6 19:37:06 EDT 2017
\n mri_ca_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Thu Jul  6 22:46:16 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/cc_up.lta sub-03 \n
#--------------------------------------
#@# Merge ASeg Thu Jul  6 23:47:19 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Thu Jul  6 23:47:19 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Thu Jul  6 23:50:31 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Thu Jul  6 23:50:32 EDT 2017
\n mri_segment -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Thu Jul  6 23:52:47 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Thu Jul  6 23:53:31 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Thu Jul  6 23:53:36 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Thu Jul  6 23:53:41 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Thu Jul  6 23:53:41 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:22 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Fri Jul  7 09:46:22 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:30 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Fri Jul  7 09:46:31 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:39 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Fri Jul  7 09:46:39 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:57 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Fri Jul  7 09:46:57 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:47:14 EDT 2017 
#--------------------------------------------
#@# QSphere lh Fri Jul  7 09:47:14 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:49:13 EDT 2017 
#--------------------------------------------
#@# QSphere rh Fri Jul  7 09:49:13 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:52:18 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Fri Jul  7 09:52:18 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Fri Jul  7 09:52:18 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 10:19:44 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Fri Jul  7 10:19:44 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Fri Jul  7 10:19:44 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 10:52:39 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Fri Jul  7 10:52:39 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-03 lh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:10:13 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Fri Jul  7 11:10:13 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-03 rh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:28:50 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Fri Jul  7 11:28:50 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:28:59 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Fri Jul  7 11:28:59 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:29:17 EDT 2017 
#--------------------------------------------
#@# Sphere lh Fri Jul  7 11:29:17 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:46:19 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Fri Jul  7 11:46:19 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:19:09 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Fri Jul  7 12:19:09 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:19:38 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Fri Jul  7 12:19:38 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 lh \n
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 12:44:53 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:44:59 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 12:44:59 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:45:05 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Fri Jul  7 12:45:05 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:45:16 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Fri Jul  7 12:45:16 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:45:49 EDT 2017 
#--------------------------------------------
#@# Sphere rh Fri Jul  7 12:45:50 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:10:47 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Fri Jul  7 13:10:48 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:48:26 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Fri Jul  7 13:48:26 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:48:52 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Fri Jul  7 13:48:52 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 rh \n
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 14:12:48 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:12:53 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 14:12:53 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:12:58 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Fri Jul  7 14:12:58 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:14:28 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Fri Jul  7 14:14:28 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:15:55 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Fri Jul  7 14:15:55 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-03 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:16:03 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Fri Jul  7 14:16:03 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-03 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:16:12 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Fri Jul  7 14:16:12 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:16:15 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Fri Jul  7 14:16:15 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:16:18 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Fri Jul  7 14:16:18 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:16:21 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Fri Jul  7 14:16:22 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:16:24 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Fri Jul  7 14:16:25 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-03 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:36:09 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Fri Jul  7 14:36:09 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-03 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-03 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:37:43 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Fri Jul  7 14:37:43 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-03 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-03 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:39:18 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jul  7 14:39:18 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:39:45 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jul  7 14:39:45 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:40:11 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jul  7 14:40:11 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-03 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:40:56 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jul  7 14:40:56 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-03 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:41:41 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jul  7 14:41:41 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:42:00 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jul  7 14:42:00 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:42:21 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jul  7 14:42:21 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-03 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:43:05 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jul  7 14:43:06 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-03 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:43:50 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Fri Jul  7 14:43:50 EDT 2017
\n pctsurfcon --s sub-03 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:43:58 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Fri Jul  7 14:43:58 EDT 2017
\n pctsurfcon --s sub-03 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:44:06 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Fri Jul  7 14:44:06 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:44:35 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jul  7 14:44:36 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Jul  7 14:50:43 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Jul  7 14:56:20 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:01:48 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Fri Jul  7 15:01:48 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:01:55 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Fri Jul  7 15:01:55 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Volumes/CFMI-CFS/opt/fs6/ASegStatsLUT.txt --subject sub-03 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:03:22 EDT 2017 
#-----------------------------------------
#@# WMParc Fri Jul  7 15:03:22 EDT 2017
\n mri_aparc2aseg --s sub-03 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-03 --surf-wm-vol --ctab /Volumes/CFMI-CFS/opt/fs6/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:11:48 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jul  7 15:11:48 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-03 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-03 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-03 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-03 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-03 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-03 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-03 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-03 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-03 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:17:51 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jul  7 15:17:51 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-03 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-03 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-03 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-03 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-03 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-03 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-03 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-03 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-03 rh white \n
\n\n#---------------------------------
<<<<<<< HEAD
# New invocation of recon-all Mon Jul 10 15:57:24 EDT 2017 
#--------------------------------------------
#@# MotionCor Mon Jul 10 15:57:24 EDT 2017
\n cp /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:57:31 EDT 2017 
#--------------------------------------------
#@# Talairach Mon Jul 10 15:57:31 EDT 2017
=======
# New invocation of recon-all Thu Jul 13 14:41:36 EDT 2017 
#--------------------------------------------
#@# MotionCor Thu Jul 13 14:41:44 EDT 2017
\n cp /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz \n
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/orig.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul 13 14:41:55 EDT 2017
>>>>>>> master
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
<<<<<<< HEAD
#@# Talairach Failure Detection Mon Jul 10 15:58:54 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:58:55 EDT 2017 
#--------------------------------------------
#@# Nu Intensity Correction Mon Jul 10 15:58:55 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 16:00:32 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization Mon Jul 10 16:00:33 EDT 2017
\n mri_normalize -g 1 -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage nu.mgz T1.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 16:03:14 EDT 2017 
#--------------------------------------------
#@# Skull Stripping Mon Jul 10 16:03:14 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
=======
#@# Talairach Failure Detection Thu Jul 13 14:43:24 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Volumes/CFMI-CFS/opt/fs6/bin/extract_talairach_avi_QA.awk /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul 13 14:43:24 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul 13 14:45:07 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul 13 14:47:30 EDT 2017
\n mri_watershed -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-03/touch/rusage.mri_watershed.dat -keep brainmask.auto.mgz brainmask.mgz brainmask.mgz -T1 -brain_atlas /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
>>>>>>> master
\nINFO: brainmask.mgz already exists!
The new brainmask.auto.mgz will not be copied to brainmask.mgz.
This is done to retain any edits made to brainmask.mgz.
Add the -clean-bm flag to recon-all to overwrite brainmask.mgz.\n
<<<<<<< HEAD
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 16:03:35 EDT 2017 
#-------------------------------------
#@# EM Registration Mon Jul 10 16:03:35 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 16:16:37 EDT 2017 
#--------------------------------------
#@# CA Normalize Mon Jul 10 16:16:37 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 16:18:02 EDT 2017 
#--------------------------------------
#@# CA Reg Mon Jul 10 16:18:02 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:02:16 EDT 2017 
#--------------------------------------
#@# SubCort Seg Mon Jul 10 18:02:16 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/cc_up.lta sub-03 \n
#--------------------------------------
#@# Merge ASeg Mon Jul 10 18:45:53 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:45:54 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Mon Jul 10 18:45:54 EDT 2017
\n mri_normalize -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:49:45 EDT 2017 
#--------------------------------------------
#@# Mask BFS Mon Jul 10 18:49:45 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:49:47 EDT 2017 
#--------------------------------------------
#@# WM Segmentation Mon Jul 10 18:49:47 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n cp wm.mgz wm.seg.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:51:43 EDT 2017 
#--------------------------------------------
#@# Fill Mon Jul 10 18:51:43 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:52:19 EDT 2017 
#--------------------------------------------
#@# Tessellate lh Mon Jul 10 18:52:19 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:52:24 EDT 2017 
#--------------------------------------------
#@# Tessellate rh Mon Jul 10 18:52:24 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:52:29 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Mon Jul 10 18:52:29 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:52:37 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Mon Jul 10 18:52:37 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:52:45 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Mon Jul 10 18:52:45 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:53:10 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Mon Jul 10 18:53:10 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:53:36 EDT 2017 
#--------------------------------------------
#@# QSphere lh Mon Jul 10 18:53:36 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:56:11 EDT 2017 
#--------------------------------------------
#@# QSphere rh Mon Jul 10 18:56:11 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:58:39 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Mon Jul 10 18:58:39 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Mon Jul 10 18:58:39 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 19:13:11 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Mon Jul 10 19:13:11 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Mon Jul 10 19:13:11 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 19:35:42 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Mon Jul 10 19:35:42 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-03 lh \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 19:49:40 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Mon Jul 10 19:49:40 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-03 rh \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:04:43 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Mon Jul 10 20:04:43 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:04:51 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Mon Jul 10 20:04:51 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:05:24 EDT 2017 
#--------------------------------------------
#@# Sphere lh Mon Jul 10 20:05:24 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:35:25 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Mon Jul 10 20:35:25 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:06:20 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Mon Jul 10 21:06:20 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:06:34 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Mon Jul 10 21:06:34 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 lh \n
#--------------------------------------------
#@# Surf Volume lh Mon Jul 10 21:20:30 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:20:34 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Mon Jul 10 21:20:34 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:20:37 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Mon Jul 10 21:20:37 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:20:45 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Mon Jul 10 21:20:45 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:21:13 EDT 2017 
#--------------------------------------------
#@# Sphere rh Mon Jul 10 21:21:13 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:53:45 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Mon Jul 10 21:53:45 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:19:27 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Mon Jul 10 22:19:27 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:19:40 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Mon Jul 10 22:19:40 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 rh \n
#--------------------------------------------
#@# Surf Volume rh Mon Jul 10 22:33:07 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:33:10 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Mon Jul 10 22:33:10 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:33:13 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Mon Jul 10 22:33:13 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:34:11 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Mon Jul 10 22:34:11 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:09 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Mon Jul 10 22:35:09 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-03 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:15 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Mon Jul 10 22:35:15 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-03 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:20 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Mon Jul 10 22:35:20 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:22 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Mon Jul 10 22:35:22 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:24 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Mon Jul 10 22:35:24 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:26 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Mon Jul 10 22:35:26 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:27 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Mon Jul 10 22:35:27 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-03 \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:45:16 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Mon Jul 10 22:45:16 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-03 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-03 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:46:16 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Mon Jul 10 22:46:17 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-03 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-03 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:47:18 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Mon Jul 10 22:47:18 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:47:36 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Mon Jul 10 22:47:36 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:47:53 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Mon Jul 10 22:47:53 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-03 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:48:24 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Mon Jul 10 22:48:24 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-03 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:48:54 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Mon Jul 10 22:48:54 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:49:08 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Mon Jul 10 22:49:08 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:49:22 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Mon Jul 10 22:49:22 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-03 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:49:51 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Mon Jul 10 22:49:51 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-03 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:50:20 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Mon Jul 10 22:50:20 EDT 2017
\n pctsurfcon --s sub-03 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:50:26 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Mon Jul 10 22:50:26 EDT 2017
\n pctsurfcon --s sub-03 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:50:31 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Mon Jul 10 22:50:31 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:50:52 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Mon Jul 10 22:50:52 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Mon Jul 10 22:55:16 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Mon Jul 10 22:59:39 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 23:03:46 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Mon Jul 10 23:03:46 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 23:03:51 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Mon Jul 10 23:03:51 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-03 \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 23:05:50 EDT 2017 
#-----------------------------------------
#@# WMParc Mon Jul 10 23:05:50 EDT 2017
\n mri_aparc2aseg --s sub-03 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-03 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 23:12:42 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Mon Jul 10 23:12:42 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-03 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-03 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-03 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-03 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-03 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-03 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-03 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-03 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-03 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 23:16:25 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Mon Jul 10 23:16:25 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-03 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-03 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-03 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-03 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-03 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-03 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-03 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-03 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-03 rh white \n
=======
>>>>>>> master
\n\n#---------------------------------
# New invocation of recon-all Thu Jul 13 15:24:46 EDT 2017 
#--------------------------------------------
#@# MotionCor Thu Jul 13 15:24:50 EDT 2017
\n cp /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul 13 15:24:59 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n\n#---------------------------------
# New invocation of recon-all Thu Jul 13 15:26:12 EDT 2017 
\n mv -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/brainmask.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/trash \n
#--------------------------------------------
#@# MotionCor Thu Jul 13 15:26:14 EDT 2017
\n cp /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul 13 15:26:23 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
#@# Talairach Failure Detection Thu Jul 13 15:27:41 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul 13 15:27:41 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul 13 15:29:16 EDT 2017
\n mri_normalize -g 1 -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul 13 15:31:55 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Thu Jul 13 15:41:31 EDT 2017 
\n mv -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/brainmask.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/trash \n
#--------------------------------------------
#@# MotionCor Thu Jul 13 15:41:32 EDT 2017
\n cp /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul 13 15:41:41 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
#@# Talairach Failure Detection Thu Jul 13 15:42:57 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul 13 15:42:57 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul 13 15:44:30 EDT 2017
\n mri_normalize -g 1 -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul 13 15:46:45 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
#-------------------------------------
#@# EM Registration Thu Jul 13 15:47:08 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Thu Jul 13 15:51:53 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Thu Jul 13 15:53:12 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Thu Jul 13 17:32:15 EDT 2017
\n mri_seg_diff --seg1 aseg.auto.mgz --seg2 aseg.presurf.mgz --diff aseg.manedit.mgz \n
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/cc_up.lta sub-03 \n
#--------------------------------------
#@# Merge ASeg Thu Jul 13 18:14:41 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Thu Jul 13 18:14:41 EDT 2017
\n mri_normalize -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Thu Jul 13 18:17:41 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Thu Jul 13 18:17:42 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n cp wm.mgz wm.seg.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Thu Jul 13 18:19:33 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Thu Jul 13 18:20:04 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Thu Jul 13 18:20:08 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Thu Jul 13 18:20:12 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Thu Jul 13 18:20:12 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 14 11:42:13 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Fri Jul 14 11:42:15 EDT 2017
\n mri_normalize -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Fri Jul 14 11:45:48 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Fri Jul 14 11:45:50 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n cp wm.mgz wm.seg.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Fri Jul 14 11:47:50 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Fri Jul 14 11:48:24 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Fri Jul 14 11:48:29 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Fri Jul 14 11:48:34 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Fri Jul 14 11:48:42 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
#--------------------------------------------
#@# Inflation1 lh Fri Jul 14 11:48:49 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
#--------------------------------------------
#@# Inflation1 rh Fri Jul 14 11:49:11 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
#--------------------------------------------
#@# QSphere lh Fri Jul 14 11:49:36 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
#--------------------------------------------
#@# QSphere rh Fri Jul 14 11:51:44 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
#--------------------------------------------
#@# Fix Topology Copy lh Fri Jul 14 11:54:06 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#--------------------------------------------
#@# Fix Topology Copy rh Fri Jul 14 11:54:07 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology lh Fri Jul 14 11:54:07 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 lh \n
#@# Fix Topology rh Fri Jul 14 12:13:56 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 rh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
#--------------------------------------------
#@# Make White Surf lh Fri Jul 14 12:39:36 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-03 lh \n
#--------------------------------------------
#@# Make White Surf rh Fri Jul 14 12:43:42 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-03 rh \n
#--------------------------------------------
#@# Smooth2 lh Fri Jul 14 12:47:49 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
#--------------------------------------------
#@# Smooth2 rh Fri Jul 14 12:47:55 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
#--------------------------------------------
#@# Inflation2 lh Fri Jul 14 12:48:02 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
#--------------------------------------------
#@# Inflation2 rh Fri Jul 14 12:48:22 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
#--------------------------------------------
#@# Curv .H and .K lh Fri Jul 14 12:48:43 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
#--------------------------------------------
#@# Curv .H and .K rh Fri Jul 14 12:49:38 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n#-----------------------------------------
#@# Curvature Stats lh Fri Jul 14 12:50:33 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-03 lh curv sulc \n
\n#-----------------------------------------
#@# Curvature Stats rh Fri Jul 14 12:50:38 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-03 rh curv sulc \n
#--------------------------------------------
#@# Sphere lh Fri Jul 14 12:50:43 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
#--------------------------------------------
#@# Sphere rh Fri Jul 14 13:19:20 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
#--------------------------------------------
#@# Surf Reg lh Fri Jul 14 13:43:05 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
#--------------------------------------------
#@# Surf Reg rh Fri Jul 14 14:13:05 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
#--------------------------------------------
#@# Jacobian white lh Fri Jul 14 14:42:52 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
#--------------------------------------------
#@# Jacobian white rh Fri Jul 14 14:42:54 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
#--------------------------------------------
#@# AvgCurv lh Fri Jul 14 14:42:55 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
#--------------------------------------------
#@# AvgCurv rh Fri Jul 14 14:42:57 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
#-----------------------------------------
#@# Cortical Parc lh Fri Jul 14 14:42:58 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
#-----------------------------------------
#@# Cortical Parc rh Fri Jul 14 14:43:12 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
#--------------------------------------------
#@# Make Pial Surf lh Fri Jul 14 14:43:24 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 lh \n
#--------------------------------------------
#@# Make Pial Surf rh Fri Jul 14 14:55:59 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 rh \n
#--------------------------------------------
#@# Surf Volume lh Fri Jul 14 15:08:55 EDT 2017
#--------------------------------------------
#@# Surf Volume rh Fri Jul 14 15:08:58 EDT 2017
#--------------------------------------------
#@# Cortical ribbon mask Fri Jul 14 15:09:01 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-03 \n
#-----------------------------------------
#@# Parcellation Stats lh Fri Jul 14 15:17:59 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-03 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-03 lh pial \n
#-----------------------------------------
#@# Parcellation Stats rh Fri Jul 14 15:18:53 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-03 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-03 rh pial \n
#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jul 14 15:19:46 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jul 14 15:20:02 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jul 14 15:20:20 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-03 lh white \n
#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jul 14 15:20:47 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-03 rh white \n
#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jul 14 15:21:15 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jul 14 15:21:28 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jul 14 15:21:41 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-03 lh white \n
#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jul 14 15:22:08 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-03 rh white \n
#-----------------------------------------
#@# WM/GM Contrast lh Fri Jul 14 15:22:35 EDT 2017
\n pctsurfcon --s sub-03 --lh-only \n
#-----------------------------------------
#@# WM/GM Contrast rh Fri Jul 14 15:22:40 EDT 2017
\n pctsurfcon --s sub-03 --rh-only \n
#-----------------------------------------
#@# Relabel Hypointensities Fri Jul 14 15:22:45 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jul 14 15:23:06 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Jul 14 15:27:15 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Jul 14 15:31:24 EDT 2017
\n mri_aparc2aseg --s sub-03 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
#-----------------------------------------
#@# APas-to-ASeg Fri Jul 14 15:35:33 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
#--------------------------------------------
#@# ASeg Stats Fri Jul 14 15:35:37 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-03 \n
#-----------------------------------------
#@# WMParc Fri Jul 14 15:37:37 EDT 2017
\n mri_aparc2aseg --s sub-03 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-03 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jul 14 15:44:28 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-03 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-03 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-03 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-03 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-03 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-03 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-03 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-03 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-03 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-03 lh white \n
#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jul 14 15:48:11 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-03 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-03 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-03 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-03 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-03 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-03 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-03 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-03 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-03 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-03 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-03 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 11:14:47 EDT 2017 
#-------------------------------------
#@# EM Registration Mon Jul 17 11:14:47 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 11:25:51 EDT 2017 
#--------------------------------------
#@# CA Normalize Mon Jul 17 11:25:52 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 11:27:16 EDT 2017 
#--------------------------------------
#@# CA Reg Mon Jul 17 11:27:17 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 13:54:20 EDT 2017 
#--------------------------------------
#@# SubCort Seg Mon Jul 17 13:54:20 EDT 2017
\n mri_seg_diff --seg1 aseg.auto.mgz --seg2 aseg.presurf.mgz --diff aseg.manedit.mgz \n
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/cc_up.lta sub-03 \n
#--------------------------------------
#@# Merge ASeg Mon Jul 17 14:45:24 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:45:25 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Mon Jul 17 14:45:25 EDT 2017
\n mri_normalize -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:49:34 EDT 2017 
#--------------------------------------------
#@# Mask BFS Mon Jul 17 14:49:34 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:49:36 EDT 2017 
#--------------------------------------------
#@# WM Segmentation Mon Jul 17 14:49:36 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n cp wm.mgz wm.seg.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:51:44 EDT 2017 
#--------------------------------------------
#@# Fill Mon Jul 17 14:51:44 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:52:23 EDT 2017 
#--------------------------------------------
#@# Tessellate lh Mon Jul 17 14:52:23 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:52:30 EDT 2017 
#--------------------------------------------
#@# Tessellate rh Mon Jul 17 14:52:30 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:52:36 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Mon Jul 17 14:52:37 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:52:44 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Mon Jul 17 14:52:44 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:52:53 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Mon Jul 17 14:52:53 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:53:20 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Mon Jul 17 14:53:21 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:53:49 EDT 2017 
#--------------------------------------------
#@# QSphere lh Mon Jul 17 14:53:50 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:56:34 EDT 2017 
#--------------------------------------------
#@# QSphere rh Mon Jul 17 14:56:34 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 14:59:32 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Mon Jul 17 14:59:32 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Mon Jul 17 14:59:32 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 15:17:37 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Mon Jul 17 15:17:37 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Mon Jul 17 15:17:37 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 15:37:26 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Mon Jul 17 15:37:26 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-03 lh \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 15:50:48 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Mon Jul 17 15:50:48 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-03 rh \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 16:04:27 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Mon Jul 17 16:04:27 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 16:04:53 EDT 2017 
#--------------------------------------------
#@# Sphere lh Mon Jul 17 16:04:54 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 16:43:20 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Mon Jul 17 16:43:20 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 17:32:55 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Mon Jul 17 17:32:55 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 17:33:10 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Mon Jul 17 17:33:10 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 lh \n
#--------------------------------------------
#@# Surf Volume lh Mon Jul 17 17:47:28 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 17:47:32 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Mon Jul 17 17:47:32 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 17:47:35 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Mon Jul 17 17:47:35 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 17:48:08 EDT 2017 
#--------------------------------------------
#@# Sphere rh Mon Jul 17 17:48:08 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 18:19:26 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Mon Jul 17 18:19:26 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:04:53 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Mon Jul 17 19:04:53 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-03 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:05:07 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Mon Jul 17 19:05:07 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-03 rh \n
#--------------------------------------------
#@# Surf Volume rh Mon Jul 17 19:18:09 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:18:12 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Mon Jul 17 19:18:12 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:18:16 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Mon Jul 17 19:18:16 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:19:16 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Mon Jul 17 19:19:16 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:20:16 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Mon Jul 17 19:20:16 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-03 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:20:21 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Mon Jul 17 19:20:21 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-03 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 19:20:26 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Mon Jul 17 19:20:26 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 18 10:20:55 EDT 2017 
#--------------------------------------------
#@# MotionCor Tue Jul 18 10:21:04 EDT 2017
\n cp /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig/001.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/rawavg.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/orig.mgz \n
#--------------------------------------------
#@# Talairach Tue Jul 18 10:21:14 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
#@# Talairach Failure Detection Tue Jul 18 10:22:49 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Tue Jul 18 10:22:49 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Tue Jul 18 10:24:42 EDT 2017
\n mri_normalize -g 1 -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Tue Jul 18 10:27:37 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_watershed.dat -keep brainmask.auto.mgz brainmask.mgz brainmask.mgz -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\nINFO: brainmask.mgz already exists!
The new brainmask.auto.mgz will not be copied to brainmask.mgz.
This is done to retain any edits made to brainmask.mgz.
Add the -clean-bm flag to recon-all to overwrite brainmask.mgz.\n
#-------------------------------------
#@# EM Registration Tue Jul 18 10:28:05 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Tue Jul 18 10:37:52 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Tue Jul 18 10:39:31 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Tue Jul 18 12:53:12 EDT 2017
\n mri_seg_diff --seg1 aseg.auto.mgz --seg2 aseg.presurf.mgz --diff aseg.manedit.mgz \n
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/mri/transforms/cc_up.lta sub-03 \n
#--------------------------------------
#@# Merge ASeg Tue Jul 18 13:41:22 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Tue Jul 18 13:41:22 EDT 2017
\n mri_normalize -f /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/tmp/control.dat -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Tue Jul 18 13:45:14 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Tue Jul 18 13:45:16 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n cp wm.mgz wm.seg.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Tue Jul 18 13:47:19 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Tue Jul 18 13:47:57 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Tue Jul 18 13:48:03 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Tue Jul 18 13:48:08 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Tue Jul 18 13:48:15 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
#--------------------------------------------
#@# Inflation1 lh Tue Jul 18 13:48:23 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
#--------------------------------------------
#@# Inflation1 rh Tue Jul 18 13:48:50 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
#--------------------------------------------
#@# QSphere lh Tue Jul 18 13:49:16 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
#--------------------------------------------
#@# QSphere rh Tue Jul 18 13:51:44 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
#--------------------------------------------
#@# Fix Topology Copy lh Tue Jul 18 13:54:27 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#--------------------------------------------
#@# Fix Topology Copy rh Tue Jul 18 13:54:28 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology lh Tue Jul 18 13:54:28 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 lh \n
#@# Fix Topology rh Tue Jul 18 14:11:17 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-03 rh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
#--------------------------------------------
#@# Make White Surf lh Tue Jul 18 14:30:34 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-03 lh \n
#--------------------------------------------
#@# Make White Surf rh Tue Jul 18 14:34:47 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-03 rh \n
#--------------------------------------------
#@# Smooth2 lh Tue Jul 18 14:38:56 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
#--------------------------------------------
#@# Smooth2 rh Tue Jul 18 14:39:03 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
#--------------------------------------------
#@# Inflation2 lh Tue Jul 18 14:39:09 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
#--------------------------------------------
#@# Inflation2 rh Tue Jul 18 14:39:34 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
#--------------------------------------------
#@# Curv .H and .K lh Tue Jul 18 14:39:59 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
#--------------------------------------------
#@# Curv .H and .K rh Tue Jul 18 14:41:06 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n#-----------------------------------------
#@# Curvature Stats lh Tue Jul 18 14:42:05 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-03 lh curv sulc \n
\n#-----------------------------------------
#@# Curvature Stats rh Tue Jul 18 14:42:10 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-03 rh curv sulc \n
#--------------------------------------------
#@# Sphere lh Tue Jul 18 14:42:15 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-03/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 18 15:04:04 EDT 2017 
