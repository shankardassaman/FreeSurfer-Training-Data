\n\n#---------------------------------
# New invocation of recon-all Thu Jul  6 19:08:37 EDT 2017 
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/nii.gz/H10181-t1/GR_IR-Siemens_MPRAGE.nii.gz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/orig/001.mgz \n
#--------------------------------------------
#@# MotionCor Thu Jul  6 19:08:47 EDT 2017
\n cp /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/orig/001.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/rawavg.mgz \n
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/rawavg.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/transforms/talairach.xfm /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/orig.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/orig.mgz \n
#--------------------------------------------
#@# Deface Thu Jul  6 19:08:57 EDT 2017
\n mri_deface orig.mgz /Volumes/CFMI-CFS/opt/fs6/average/talairach_mixed_with_skull.gca /Volumes/CFMI-CFS/opt/fs6/average/face.gca orig_defaced.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul  6 19:11:21 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm --atlas 3T18yoSchwartzReactN32_as_orig \n
talairach_avi log file is transforms/talairach_avi.log...
\n cp transforms/talairach.auto.xfm transforms/talairach.xfm \n
#--------------------------------------------
#@# Talairach Failure Detection Thu Jul  6 19:12:58 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Volumes/CFMI-CFS/opt/fs6/bin/extract_talairach_avi_QA.awk /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul  6 19:12:58 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --proto-iters 1000 --distance 50 --n 1 \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul  6 19:14:32 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul  6 19:16:55 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta \n
\n mri_watershed -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
#-------------------------------------
#@# EM Registration Thu Jul  6 19:29:01 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Thu Jul  6 19:43:40 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Thu Jul  6 19:46:18 EDT 2017
\n mri_ca_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Thu Jul  6 22:42:49 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/mri/transforms/cc_up.lta sub-06 \n
#--------------------------------------
#@# Merge ASeg Thu Jul  6 23:35:06 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Thu Jul  6 23:35:06 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Thu Jul  6 23:38:10 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Thu Jul  6 23:38:11 EDT 2017
\n mri_segment -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Thu Jul  6 23:40:33 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Thu Jul  6 23:41:16 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Thu Jul  6 23:41:22 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Thu Jul  6 23:41:27 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Thu Jul  6 23:41:27 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:48:00 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Fri Jul  7 09:48:00 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:48:09 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Fri Jul  7 09:48:09 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:48:19 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Fri Jul  7 09:48:19 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:48:39 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Fri Jul  7 09:48:39 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:49:00 EDT 2017 
#--------------------------------------------
#@# QSphere lh Fri Jul  7 09:49:00 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:51:21 EDT 2017 
#--------------------------------------------
#@# QSphere rh Fri Jul  7 09:51:21 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:54:08 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Fri Jul  7 09:54:08 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Fri Jul  7 09:54:08 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-06 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 10:22:37 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Fri Jul  7 10:22:37 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Fri Jul  7 10:22:38 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-06 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:34:00 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Fri Jul  7 11:34:00 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-06 lh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:51:26 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Fri Jul  7 11:51:26 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-06 rh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:11:50 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Fri Jul  7 12:11:51 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:12:02 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Fri Jul  7 12:12:02 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:12:26 EDT 2017 
#--------------------------------------------
#@# Sphere lh Fri Jul  7 12:12:26 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:32:22 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Fri Jul  7 12:32:23 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:04:35 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Fri Jul  7 13:04:35 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:04:58 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Fri Jul  7 13:04:58 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-06 lh \n
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 13:23:50 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:23:54 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 13:23:54 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:23:59 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Fri Jul  7 13:23:59 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:24:09 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Fri Jul  7 13:24:09 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:24:34 EDT 2017 
#--------------------------------------------
#@# Sphere rh Fri Jul  7 13:24:34 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:46:44 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Fri Jul  7 13:46:44 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-06/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:17:48 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Fri Jul  7 14:17:49 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:18:04 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Fri Jul  7 14:18:04 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-06 rh \n
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 14:35:39 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:35:44 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 14:35:44 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:35:48 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Fri Jul  7 14:35:48 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:37:07 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Fri Jul  7 14:37:07 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:38:27 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Fri Jul  7 14:38:27 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-06 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:38:34 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Fri Jul  7 14:38:34 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-06 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:38:41 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Fri Jul  7 14:38:41 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:38:43 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Fri Jul  7 14:38:43 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:38:46 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Fri Jul  7 14:38:46 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:38:48 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Fri Jul  7 14:38:48 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:38:51 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Fri Jul  7 14:38:51 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-06 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:51:37 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Fri Jul  7 14:51:37 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-06 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-06 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:52:47 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Fri Jul  7 14:52:47 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-06 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-06 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:53:57 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jul  7 14:53:57 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:54:15 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jul  7 14:54:15 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:54:34 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jul  7 14:54:34 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-06 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:55:08 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jul  7 14:55:09 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-06 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:55:43 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jul  7 14:55:43 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:55:58 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jul  7 14:55:58 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:56:13 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jul  7 14:56:13 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-06 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:56:47 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jul  7 14:56:47 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-06 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:57:20 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Fri Jul  7 14:57:20 EDT 2017
\n pctsurfcon --s sub-06 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:57:27 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Fri Jul  7 14:57:27 EDT 2017
\n pctsurfcon --s sub-06 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:57:33 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Fri Jul  7 14:57:33 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:57:57 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jul  7 14:57:57 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Jul  7 15:02:48 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Jul  7 15:08:20 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:56 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Fri Jul  7 15:13:56 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:14:03 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Fri Jul  7 15:14:03 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Volumes/CFMI-CFS/opt/fs6/ASegStatsLUT.txt --subject sub-06 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:15:50 EDT 2017 
#-----------------------------------------
#@# WMParc Fri Jul  7 15:15:51 EDT 2017
\n mri_aparc2aseg --s sub-06 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-06 --surf-wm-vol --ctab /Volumes/CFMI-CFS/opt/fs6/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:24:07 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jul  7 15:24:08 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-06 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-06 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-06 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-06 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-06 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-06 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-06 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-06 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-06 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:29:04 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jul  7 15:29:04 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-06 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-06 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-06 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-06 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-06 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-06 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-06 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-06 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-06 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:05:30 EDT 2017 
#--------------------------------------------
#@# MotionCor Wed Jul 12 10:05:30 EDT 2017
\n cp /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/orig/001.mgz /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/rawavg.mgz /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/orig.mgz /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/orig.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:05:37 EDT 2017 
#--------------------------------------------
#@# Talairach Wed Jul 12 10:05:37 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
#@# Talairach Failure Detection Wed Jul 12 10:07:09 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/transforms/talairach_avi.log \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:07:09 EDT 2017 
#--------------------------------------------
#@# Nu Intensity Correction Wed Jul 12 10:07:09 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:08:54 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization Wed Jul 12 10:08:54 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:11:01 EDT 2017 
#--------------------------------------------
#@# Skull Stripping Wed Jul 12 10:11:01 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\nINFO: brainmask.mgz already exists!
The new brainmask.auto.mgz will not be copied to brainmask.mgz.
This is done to retain any edits made to brainmask.mgz.
Add the -clean-bm flag to recon-all to overwrite brainmask.mgz.\n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:11:26 EDT 2017 
#-------------------------------------
#@# EM Registration Wed Jul 12 10:11:26 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:21:43 EDT 2017 
#--------------------------------------
#@# CA Normalize Wed Jul 12 10:21:43 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 10:23:06 EDT 2017 
#--------------------------------------
#@# CA Reg Wed Jul 12 10:23:06 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 12:30:50 EDT 2017 
#--------------------------------------
#@# SubCort Seg Wed Jul 12 12:30:50 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/mri/transforms/cc_up.lta sub-06 \n
#--------------------------------------
#@# Merge ASeg Wed Jul 12 13:13:37 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:13:38 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Wed Jul 12 13:13:38 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:17:02 EDT 2017 
#--------------------------------------------
#@# Mask BFS Wed Jul 12 13:17:02 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:17:04 EDT 2017 
#--------------------------------------------
#@# WM Segmentation Wed Jul 12 13:17:04 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:19:16 EDT 2017 
#--------------------------------------------
#@# Fill Wed Jul 12 13:19:16 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:19:54 EDT 2017 
#--------------------------------------------
#@# Tessellate lh Wed Jul 12 13:19:54 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:20:00 EDT 2017 
#--------------------------------------------
#@# Tessellate rh Wed Jul 12 13:20:00 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:20:06 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Wed Jul 12 13:20:06 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:20:14 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Wed Jul 12 13:20:14 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:20:21 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Wed Jul 12 13:20:21 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:20:49 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Wed Jul 12 13:20:49 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:21:16 EDT 2017 
#--------------------------------------------
#@# QSphere lh Wed Jul 12 13:21:17 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:23:49 EDT 2017 
#--------------------------------------------
#@# QSphere rh Wed Jul 12 13:23:49 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:26:22 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Wed Jul 12 13:26:22 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Wed Jul 12 13:26:22 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-06 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 13:52:30 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Wed Jul 12 13:52:30 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Wed Jul 12 13:52:31 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-06 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 14:29:15 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Wed Jul 12 14:29:15 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-06 lh \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 14:43:24 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Wed Jul 12 14:43:25 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-06 rh \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 14:58:07 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Wed Jul 12 14:58:07 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 14:58:15 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Wed Jul 12 14:58:15 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 14:58:49 EDT 2017 
#--------------------------------------------
#@# Sphere lh Wed Jul 12 14:58:49 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 15:34:17 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Wed Jul 12 15:34:17 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 16:29:18 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Wed Jul 12 16:29:18 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 16:29:36 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Wed Jul 12 16:29:36 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-06 lh \n
#--------------------------------------------
#@# Surf Volume lh Wed Jul 12 16:44:03 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 16:44:08 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Wed Jul 12 16:44:09 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 16:44:13 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Wed Jul 12 16:44:13 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 16:44:20 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Wed Jul 12 16:44:20 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 16:44:52 EDT 2017 
#--------------------------------------------
#@# Sphere rh Wed Jul 12 16:44:52 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 17:22:47 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Wed Jul 12 17:22:47 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:08:03 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Wed Jul 12 18:08:03 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:08:19 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Wed Jul 12 18:08:19 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-06 rh \n
#--------------------------------------------
#@# Surf Volume rh Wed Jul 12 18:22:48 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:22:53 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Wed Jul 12 18:22:53 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:22:57 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Wed Jul 12 18:22:57 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:24:05 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Wed Jul 12 18:24:05 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:25:10 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Wed Jul 12 18:25:10 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-06 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:25:16 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Wed Jul 12 18:25:16 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-06 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:25:22 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Wed Jul 12 18:25:22 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:25:24 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Wed Jul 12 18:25:24 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:25:26 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Wed Jul 12 18:25:26 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:25:29 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Wed Jul 12 18:25:29 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:25:31 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Wed Jul 12 18:25:31 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-06 \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:40:38 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Wed Jul 12 18:40:38 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-06 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-06 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:41:52 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Wed Jul 12 18:41:52 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-06 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-06 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:43:02 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Wed Jul 12 18:43:02 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:43:23 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Wed Jul 12 18:43:23 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:43:43 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Wed Jul 12 18:43:43 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-06 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:44:19 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Wed Jul 12 18:44:19 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-06 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:44:55 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Wed Jul 12 18:44:55 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:45:12 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Wed Jul 12 18:45:12 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:45:29 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Wed Jul 12 18:45:30 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-06 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:46:10 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Wed Jul 12 18:46:10 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-06 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:46:47 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Wed Jul 12 18:46:47 EDT 2017
\n pctsurfcon --s sub-06 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:46:54 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Wed Jul 12 18:46:54 EDT 2017
\n pctsurfcon --s sub-06 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:47:01 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Wed Jul 12 18:47:01 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 18:47:26 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Wed Jul 12 18:47:26 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Wed Jul 12 18:52:48 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Wed Jul 12 18:57:36 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 19:02:34 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Wed Jul 12 19:02:34 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 19:02:41 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Wed Jul 12 19:02:41 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-06 \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 19:05:54 EDT 2017 
#-----------------------------------------
#@# WMParc Wed Jul 12 19:05:54 EDT 2017
\n mri_aparc2aseg --s sub-06 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-06 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 19:15:03 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Wed Jul 12 19:15:03 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-06 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-06 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-06 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-06 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-06 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-06 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-06 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-06 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-06 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 19:19:46 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Wed Jul 12 19:19:46 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-06 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-06 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-06 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-06 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-06 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-06 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-06 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-06 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-06 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 17 15:41:59 EDT 2017 
#--------------------------------------------
#@# Mask BFS Mon Jul 17 15:42:06 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# Make White Surf lh Mon Jul 17 15:42:08 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-06 lh \n
#--------------------------------------------
#@# Make White Surf rh Mon Jul 17 15:45:49 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-06 rh \n
#--------------------------------------------
#@# Smooth2 lh Mon Jul 17 15:49:32 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
#--------------------------------------------
#@# Smooth2 rh Mon Jul 17 15:49:38 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
#--------------------------------------------
#@# Inflation2 lh Mon Jul 17 15:49:44 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
#--------------------------------------------
#@# Inflation2 rh Mon Jul 17 15:50:07 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
#--------------------------------------------
#@# Curv .H and .K lh Mon Jul 17 15:50:30 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
#--------------------------------------------
#@# Curv .H and .K rh Mon Jul 17 15:51:22 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n#-----------------------------------------
#@# Curvature Stats lh Mon Jul 17 15:52:14 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-06 lh curv sulc \n
\n#-----------------------------------------
#@# Curvature Stats rh Mon Jul 17 15:52:19 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-06 rh curv sulc \n
#--------------------------------------------
#@# Sphere lh Mon Jul 17 15:52:24 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
#--------------------------------------------
#@# Sphere rh Mon Jul 17 16:18:45 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
#--------------------------------------------
#@# Surf Reg lh Mon Jul 17 16:46:34 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
#--------------------------------------------
#@# Surf Reg rh Mon Jul 17 17:28:07 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-06/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
#--------------------------------------------
#@# Jacobian white lh Mon Jul 17 18:04:02 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
#--------------------------------------------
#@# Jacobian white rh Mon Jul 17 18:04:03 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
#--------------------------------------------
#@# AvgCurv lh Mon Jul 17 18:04:05 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
#--------------------------------------------
#@# AvgCurv rh Mon Jul 17 18:04:06 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
#-----------------------------------------
#@# Cortical Parc lh Mon Jul 17 18:04:08 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
#-----------------------------------------
#@# Cortical Parc rh Mon Jul 17 18:04:20 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
#--------------------------------------------
#@# Make Pial Surf lh Mon Jul 17 18:04:33 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-06 lh \n
#--------------------------------------------
#@# Make Pial Surf rh Mon Jul 17 18:16:38 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-06 rh \n
#--------------------------------------------
#@# Surf Volume lh Mon Jul 17 18:28:55 EDT 2017
#--------------------------------------------
#@# Surf Volume rh Mon Jul 17 18:28:58 EDT 2017
#--------------------------------------------
#@# Cortical ribbon mask Mon Jul 17 18:29:01 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-06 \n
#-----------------------------------------
#@# Parcellation Stats lh Mon Jul 17 18:42:05 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-06 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-06 lh pial \n
#-----------------------------------------
#@# Parcellation Stats rh Mon Jul 17 18:43:14 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-06 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-06 rh pial \n
#-----------------------------------------
#@# Cortical Parc 2 lh Mon Jul 17 18:44:20 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Cortical Parc 2 rh Mon Jul 17 18:44:39 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Parcellation Stats 2 lh Mon Jul 17 18:44:58 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-06 lh white \n
#-----------------------------------------
#@# Parcellation Stats 2 rh Mon Jul 17 18:45:32 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-06 rh white \n
#-----------------------------------------
#@# Cortical Parc 3 lh Mon Jul 17 18:46:06 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Cortical Parc 3 rh Mon Jul 17 18:46:21 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-06 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Parcellation Stats 3 lh Mon Jul 17 18:46:37 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-06 lh white \n
#-----------------------------------------
#@# Parcellation Stats 3 rh Mon Jul 17 18:47:11 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-06 rh white \n
#-----------------------------------------
#@# WM/GM Contrast lh Mon Jul 17 18:47:43 EDT 2017
\n pctsurfcon --s sub-06 --lh-only \n
#-----------------------------------------
#@# WM/GM Contrast rh Mon Jul 17 18:47:50 EDT 2017
\n pctsurfcon --s sub-06 --rh-only \n
#-----------------------------------------
#@# Relabel Hypointensities Mon Jul 17 18:47:56 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
#-----------------------------------------
#@# AParc-to-ASeg aparc Mon Jul 17 18:48:19 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Mon Jul 17 18:53:14 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Mon Jul 17 18:57:29 EDT 2017
\n mri_aparc2aseg --s sub-06 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
#-----------------------------------------
#@# APas-to-ASeg Mon Jul 17 19:01:51 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
#--------------------------------------------
#@# ASeg Stats Mon Jul 17 19:01:58 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-06 \n
#-----------------------------------------
#@# WMParc Mon Jul 17 19:05:06 EDT 2017
\n mri_aparc2aseg --s sub-06 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-06 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
#--------------------------------------------
#@# BA_exvivo Labels lh Mon Jul 17 19:12:19 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-06 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-06 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-06 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-06 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-06 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-06 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-06 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-06 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-06 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-06 lh white \n
#--------------------------------------------
#@# BA_exvivo Labels rh Mon Jul 17 19:16:01 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-06 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-06 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-06 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-06 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-06 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-06 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-06 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-06 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-06 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-06 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-06 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 18 11:23:06 EDT 2017 
#--------------------------------------------
#@# Qdec Cache preproc lh thickness fsaverage Tue Jul 18 11:23:07 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas thickness --target fsaverage --out lh.thickness.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh area fsaverage Tue Jul 18 11:23:13 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas area --target fsaverage --out lh.area.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh area.pial fsaverage Tue Jul 18 11:23:21 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas area.pial --target fsaverage --out lh.area.pial.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh volume fsaverage Tue Jul 18 11:23:28 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas volume --target fsaverage --out lh.volume.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh curv fsaverage Tue Jul 18 11:23:36 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas curv --target fsaverage --out lh.curv.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh sulc fsaverage Tue Jul 18 11:23:42 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas sulc --target fsaverage --out lh.sulc.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh white.K fsaverage Tue Jul 18 11:23:48 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas white.K --target fsaverage --out lh.white.K.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh white.H fsaverage Tue Jul 18 11:23:55 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas white.H --target fsaverage --out lh.white.H.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh jacobian_white fsaverage Tue Jul 18 11:24:00 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas jacobian_white --target fsaverage --out lh.jacobian_white.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc lh w-g.pct.mgh fsaverage Tue Jul 18 11:24:07 EDT 2017
\n mris_preproc --s sub-06 --hemi lh --meas w-g.pct.mgh --target fsaverage --out lh.w-g.pct.mgh.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh thickness fsaverage Tue Jul 18 11:24:13 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas thickness --target fsaverage --out rh.thickness.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh area fsaverage Tue Jul 18 11:24:20 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas area --target fsaverage --out rh.area.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh area.pial fsaverage Tue Jul 18 11:24:27 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas area.pial --target fsaverage --out rh.area.pial.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh volume fsaverage Tue Jul 18 11:24:35 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas volume --target fsaverage --out rh.volume.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh curv fsaverage Tue Jul 18 11:24:42 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas curv --target fsaverage --out rh.curv.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh sulc fsaverage Tue Jul 18 11:24:49 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas sulc --target fsaverage --out rh.sulc.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh white.K fsaverage Tue Jul 18 11:24:55 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas white.K --target fsaverage --out rh.white.K.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh white.H fsaverage Tue Jul 18 11:25:01 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas white.H --target fsaverage --out rh.white.H.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh jacobian_white fsaverage Tue Jul 18 11:25:07 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas jacobian_white --target fsaverage --out rh.jacobian_white.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache preproc rh w-g.pct.mgh fsaverage Tue Jul 18 11:25:13 EDT 2017
\n mris_preproc --s sub-06 --hemi rh --meas w-g.pct.mgh --target fsaverage --out rh.w-g.pct.mgh.fsaverage.mgh \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm0 fsaverage Tue Jul 18 11:25:20 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm5 fsaverage Tue Jul 18 11:25:22 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm10 fsaverage Tue Jul 18 11:25:27 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm15 fsaverage Tue Jul 18 11:25:32 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm20 fsaverage Tue Jul 18 11:25:37 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh thickness fwhm25 fsaverage Tue Jul 18 11:25:42 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.thickness.fsaverage.mgh --tval lh.thickness.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm0 fsaverage Tue Jul 18 11:25:49 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm5 fsaverage Tue Jul 18 11:25:51 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm10 fsaverage Tue Jul 18 11:25:56 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm15 fsaverage Tue Jul 18 11:26:00 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm20 fsaverage Tue Jul 18 11:26:06 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area fwhm25 fsaverage Tue Jul 18 11:26:11 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.area.fsaverage.mgh --tval lh.area.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm0 fsaverage Tue Jul 18 11:26:18 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm5 fsaverage Tue Jul 18 11:26:22 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm10 fsaverage Tue Jul 18 11:26:28 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm15 fsaverage Tue Jul 18 11:26:33 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm20 fsaverage Tue Jul 18 11:26:39 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh area.pial fwhm25 fsaverage Tue Jul 18 11:26:45 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.area.pial.fsaverage.mgh --tval lh.area.pial.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm0 fsaverage Tue Jul 18 11:26:51 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm5 fsaverage Tue Jul 18 11:26:53 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm10 fsaverage Tue Jul 18 11:26:59 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm15 fsaverage Tue Jul 18 11:27:04 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm20 fsaverage Tue Jul 18 11:27:10 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh volume fwhm25 fsaverage Tue Jul 18 11:27:16 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.volume.fsaverage.mgh --tval lh.volume.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm0 fsaverage Tue Jul 18 11:27:22 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm5 fsaverage Tue Jul 18 11:27:25 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm10 fsaverage Tue Jul 18 11:27:30 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm15 fsaverage Tue Jul 18 11:27:35 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm20 fsaverage Tue Jul 18 11:27:39 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh curv fwhm25 fsaverage Tue Jul 18 11:27:45 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.curv.fsaverage.mgh --tval lh.curv.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm0 fsaverage Tue Jul 18 11:27:51 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm5 fsaverage Tue Jul 18 11:27:53 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm10 fsaverage Tue Jul 18 11:27:59 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm15 fsaverage Tue Jul 18 11:28:03 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm20 fsaverage Tue Jul 18 11:28:09 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh sulc fwhm25 fsaverage Tue Jul 18 11:28:15 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.sulc.fsaverage.mgh --tval lh.sulc.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm0 fsaverage Tue Jul 18 11:28:21 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm5 fsaverage Tue Jul 18 11:28:23 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm10 fsaverage Tue Jul 18 11:28:28 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm15 fsaverage Tue Jul 18 11:28:33 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm20 fsaverage Tue Jul 18 11:28:38 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.K fwhm25 fsaverage Tue Jul 18 11:28:43 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.white.K.fsaverage.mgh --tval lh.white.K.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm0 fsaverage Tue Jul 18 11:28:49 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm5 fsaverage Tue Jul 18 11:28:51 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm10 fsaverage Tue Jul 18 11:28:56 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm15 fsaverage Tue Jul 18 11:29:00 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm20 fsaverage Tue Jul 18 11:29:05 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh white.H fwhm25 fsaverage Tue Jul 18 11:29:10 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.white.H.fsaverage.mgh --tval lh.white.H.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm0 fsaverage Tue Jul 18 11:29:16 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm5 fsaverage Tue Jul 18 11:29:18 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm10 fsaverage Tue Jul 18 11:29:23 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm15 fsaverage Tue Jul 18 11:29:28 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm20 fsaverage Tue Jul 18 11:29:33 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh jacobian_white fwhm25 fsaverage Tue Jul 18 11:29:39 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.jacobian_white.fsaverage.mgh --tval lh.jacobian_white.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm0 fsaverage Tue Jul 18 11:29:45 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 0 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm5 fsaverage Tue Jul 18 11:29:47 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 5 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm10 fsaverage Tue Jul 18 11:29:52 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 10 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm15 fsaverage Tue Jul 18 11:29:57 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 15 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm20 fsaverage Tue Jul 18 11:30:02 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 20 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf lh w-g.pct.mgh fwhm25 fsaverage Tue Jul 18 11:30:08 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi lh --fwhm 25 --sval lh.w-g.pct.mgh.fsaverage.mgh --tval lh.w-g.pct.mgh.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm0 fsaverage Tue Jul 18 11:30:14 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm5 fsaverage Tue Jul 18 11:30:17 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm10 fsaverage Tue Jul 18 11:30:22 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm15 fsaverage Tue Jul 18 11:30:27 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm20 fsaverage Tue Jul 18 11:30:32 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh thickness fwhm25 fsaverage Tue Jul 18 11:30:38 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.thickness.fsaverage.mgh --tval rh.thickness.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm0 fsaverage Tue Jul 18 11:30:45 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm5 fsaverage Tue Jul 18 11:30:47 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm10 fsaverage Tue Jul 18 11:30:53 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm15 fsaverage Tue Jul 18 11:30:58 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm20 fsaverage Tue Jul 18 11:31:03 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area fwhm25 fsaverage Tue Jul 18 11:31:09 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.area.fsaverage.mgh --tval rh.area.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm0 fsaverage Tue Jul 18 11:31:16 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm5 fsaverage Tue Jul 18 11:31:18 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm10 fsaverage Tue Jul 18 11:31:23 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm15 fsaverage Tue Jul 18 11:31:28 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm20 fsaverage Tue Jul 18 11:31:33 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh area.pial fwhm25 fsaverage Tue Jul 18 11:31:38 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.area.pial.fsaverage.mgh --tval rh.area.pial.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm0 fsaverage Tue Jul 18 11:31:44 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm5 fsaverage Tue Jul 18 11:31:46 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm10 fsaverage Tue Jul 18 11:31:51 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm15 fsaverage Tue Jul 18 11:31:56 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm20 fsaverage Tue Jul 18 11:32:02 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh volume fwhm25 fsaverage Tue Jul 18 11:32:08 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.volume.fsaverage.mgh --tval rh.volume.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm0 fsaverage Tue Jul 18 11:32:13 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm5 fsaverage Tue Jul 18 11:32:16 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm10 fsaverage Tue Jul 18 11:32:20 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm15 fsaverage Tue Jul 18 11:32:25 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm20 fsaverage Tue Jul 18 11:32:30 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh curv fwhm25 fsaverage Tue Jul 18 11:32:35 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.curv.fsaverage.mgh --tval rh.curv.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm0 fsaverage Tue Jul 18 11:32:41 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm5 fsaverage Tue Jul 18 11:32:44 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm10 fsaverage Tue Jul 18 11:32:48 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm15 fsaverage Tue Jul 18 11:32:53 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm20 fsaverage Tue Jul 18 11:32:58 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh sulc fwhm25 fsaverage Tue Jul 18 11:33:03 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.sulc.fsaverage.mgh --tval rh.sulc.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm0 fsaverage Tue Jul 18 11:33:09 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm5 fsaverage Tue Jul 18 11:33:11 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm10 fsaverage Tue Jul 18 11:33:16 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm15 fsaverage Tue Jul 18 11:33:21 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm20 fsaverage Tue Jul 18 11:33:25 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.K fwhm25 fsaverage Tue Jul 18 11:33:30 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.white.K.fsaverage.mgh --tval rh.white.K.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm0 fsaverage Tue Jul 18 11:33:36 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm5 fsaverage Tue Jul 18 11:33:38 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm10 fsaverage Tue Jul 18 11:33:43 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm15 fsaverage Tue Jul 18 11:33:48 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm20 fsaverage Tue Jul 18 11:33:52 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh white.H fwhm25 fsaverage Tue Jul 18 11:33:58 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.white.H.fsaverage.mgh --tval rh.white.H.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm0 fsaverage Tue Jul 18 11:34:03 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm5 fsaverage Tue Jul 18 11:34:05 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm10 fsaverage Tue Jul 18 11:34:10 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm15 fsaverage Tue Jul 18 11:34:15 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm20 fsaverage Tue Jul 18 11:34:20 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh jacobian_white fwhm25 fsaverage Tue Jul 18 11:34:25 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.jacobian_white.fsaverage.mgh --tval rh.jacobian_white.fwhm25.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm0 fsaverage Tue Jul 18 11:34:31 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 0 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm0.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm5 fsaverage Tue Jul 18 11:34:33 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 5 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm5.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm10 fsaverage Tue Jul 18 11:34:38 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 10 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm10.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm15 fsaverage Tue Jul 18 11:34:43 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 15 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm15.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm20 fsaverage Tue Jul 18 11:34:48 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 20 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm20.fsaverage.mgh --cortex \n
#--------------------------------------------
#@# Qdec Cache surf2surf rh w-g.pct.mgh fwhm25 fsaverage Tue Jul 18 11:34:53 EDT 2017
\n mri_surf2surf --prune --s fsaverage --hemi rh --fwhm 25 --sval rh.w-g.pct.mgh.fsaverage.mgh --tval rh.w-g.pct.mgh.fwhm25.fsaverage.mgh --cortex \n
