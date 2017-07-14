\n\n#---------------------------------
# New invocation of recon-all Thu Jul  6 19:07:06 EDT 2017 
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/nii.gz/A01235-t1/GR_IR-Siemens_MPRAGE.nii.gz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/orig/001.mgz \n
#--------------------------------------------
#@# MotionCor Thu Jul  6 19:07:16 EDT 2017
\n cp /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/orig/001.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/rawavg.mgz \n
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/rawavg.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/transforms/talairach.xfm /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/orig.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/orig.mgz \n
#--------------------------------------------
#@# Deface Thu Jul  6 19:07:26 EDT 2017
\n mri_deface orig.mgz /Volumes/CFMI-CFS/opt/fs6/average/talairach_mixed_with_skull.gca /Volumes/CFMI-CFS/opt/fs6/average/face.gca orig_defaced.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul  6 19:09:24 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm --atlas 3T18yoSchwartzReactN32_as_orig \n
talairach_avi log file is transforms/talairach_avi.log...
\n cp transforms/talairach.auto.xfm transforms/talairach.xfm \n
#--------------------------------------------
#@# Talairach Failure Detection Thu Jul  6 19:11:03 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Volumes/CFMI-CFS/opt/fs6/bin/extract_talairach_avi_QA.awk /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul  6 19:11:03 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --proto-iters 1000 --distance 50 --n 1 \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul  6 19:12:36 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul  6 19:14:47 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta \n
\n mri_watershed -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
#-------------------------------------
#@# EM Registration Thu Jul  6 19:26:40 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Thu Jul  6 19:35:52 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Thu Jul  6 19:38:41 EDT 2017
\n mri_ca_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Thu Jul  6 22:38:45 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/mri/transforms/cc_up.lta sub-04 \n
#--------------------------------------
#@# Merge ASeg Thu Jul  6 23:45:35 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Thu Jul  6 23:45:35 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Thu Jul  6 23:48:49 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Thu Jul  6 23:48:51 EDT 2017
\n mri_segment -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Thu Jul  6 23:51:13 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Thu Jul  6 23:51:58 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Thu Jul  6 23:52:03 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Thu Jul  6 23:52:08 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Thu Jul  6 23:52:09 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:47:16 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Fri Jul  7 09:47:16 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:47:26 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Fri Jul  7 09:47:26 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:47:36 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Fri Jul  7 09:47:36 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:47:58 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Fri Jul  7 09:47:58 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:48:22 EDT 2017 
#--------------------------------------------
#@# QSphere lh Fri Jul  7 09:48:22 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:51:14 EDT 2017 
#--------------------------------------------
#@# QSphere rh Fri Jul  7 09:51:14 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:54:43 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Fri Jul  7 09:54:44 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Fri Jul  7 09:54:44 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-04 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 10:38:45 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Fri Jul  7 10:38:45 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Fri Jul  7 10:38:45 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-04 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:20:15 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Fri Jul  7 11:20:15 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-04 lh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:42:26 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Fri Jul  7 11:42:26 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-04 rh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:05:42 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Fri Jul  7 12:05:42 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:05:55 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Fri Jul  7 12:05:55 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:06:25 EDT 2017 
#--------------------------------------------
#@# Sphere lh Fri Jul  7 12:06:25 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:36:43 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Fri Jul  7 12:36:43 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:19:26 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Fri Jul  7 13:19:26 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:19:47 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Fri Jul  7 13:19:47 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-04 lh \n
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 13:50:19 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:50:25 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 13:50:26 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:50:32 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Fri Jul  7 13:50:32 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:50:46 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Fri Jul  7 13:50:46 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:51:16 EDT 2017 
#--------------------------------------------
#@# Sphere rh Fri Jul  7 13:51:16 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:14:10 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Fri Jul  7 14:14:10 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-04/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:49:45 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Fri Jul  7 14:49:46 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:50:04 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Fri Jul  7 14:50:04 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-04 rh \n
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 15:10:09 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:10:15 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 15:10:15 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:10:20 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Fri Jul  7 15:10:20 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:11:56 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Fri Jul  7 15:11:56 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:27 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Fri Jul  7 15:13:27 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-04 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:34 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Fri Jul  7 15:13:35 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-04 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:42 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Fri Jul  7 15:13:42 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:45 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Fri Jul  7 15:13:45 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:47 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Fri Jul  7 15:13:48 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:50 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Fri Jul  7 15:13:50 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:53 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Fri Jul  7 15:13:53 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-04 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:37:55 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Fri Jul  7 15:37:55 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-04 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-04 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:39:18 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Fri Jul  7 15:39:18 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-04 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-04 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:40:40 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jul  7 15:40:40 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:41:02 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jul  7 15:41:03 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:41:26 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jul  7 15:41:26 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-04 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:42:12 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jul  7 15:42:12 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-04 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:42:53 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jul  7 15:42:53 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:43:11 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jul  7 15:43:11 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:43:29 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jul  7 15:43:29 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-04 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:44:10 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jul  7 15:44:10 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-04 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:44:52 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Fri Jul  7 15:44:52 EDT 2017
\n pctsurfcon --s sub-04 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:44:59 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Fri Jul  7 15:44:59 EDT 2017
\n pctsurfcon --s sub-04 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:45:06 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Fri Jul  7 15:45:06 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:45:34 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jul  7 15:45:34 EDT 2017
\n mri_aparc2aseg --s sub-04 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Jul  7 15:51:04 EDT 2017
\n mri_aparc2aseg --s sub-04 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Jul  7 15:56:29 EDT 2017
\n mri_aparc2aseg --s sub-04 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:01:49 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Fri Jul  7 16:01:49 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:01:54 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Fri Jul  7 16:01:55 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Volumes/CFMI-CFS/opt/fs6/ASegStatsLUT.txt --subject sub-04 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:03:07 EDT 2017 
#-----------------------------------------
#@# WMParc Fri Jul  7 16:03:07 EDT 2017
\n mri_aparc2aseg --s sub-04 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-04 --surf-wm-vol --ctab /Volumes/CFMI-CFS/opt/fs6/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:10:00 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jul  7 16:10:00 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-04 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-04 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-04 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-04 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-04 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-04 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-04 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-04 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-04 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:15:36 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jul  7 16:15:36 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-04 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-04 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-04 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-04 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-04 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-04 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-04 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-04 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-04 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 13:45:44 EDT 2017 
#--------------------------------------------
#@# MotionCor Tue Jul 11 13:45:44 EDT 2017
\n cp /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/orig/001.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/rawavg.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/orig.mgz /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/orig.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 13:45:54 EDT 2017 
#--------------------------------------------
#@# Talairach Tue Jul 11 13:45:54 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
#@# Talairach Failure Detection Tue Jul 11 13:48:03 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/transforms/talairach_avi.log \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 13:48:04 EDT 2017 
#--------------------------------------------
#@# Nu Intensity Correction Tue Jul 11 13:48:04 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 13:50:18 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization Tue Jul 11 13:50:18 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 13:52:56 EDT 2017 
#--------------------------------------------
#@# Skull Stripping Tue Jul 11 13:52:56 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\nINFO: brainmask.mgz already exists!
The new brainmask.auto.mgz will not be copied to brainmask.mgz.
This is done to retain any edits made to brainmask.mgz.
Add the -clean-bm flag to recon-all to overwrite brainmask.mgz.\n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 13:53:29 EDT 2017 
#-------------------------------------
#@# EM Registration Tue Jul 11 13:53:29 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 14:18:41 EDT 2017 
#--------------------------------------
#@# CA Normalize Tue Jul 11 14:18:41 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 14:20:28 EDT 2017 
#--------------------------------------
#@# CA Reg Tue Jul 11 14:20:28 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 16:59:03 EDT 2017 
#--------------------------------------
#@# SubCort Seg Tue Jul 11 16:59:03 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/mri/transforms/cc_up.lta sub-04 \n
#--------------------------------------
#@# Merge ASeg Tue Jul 11 17:56:49 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 17:56:50 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Tue Jul 11 17:56:50 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:00:31 EDT 2017 
#--------------------------------------------
#@# Mask BFS Tue Jul 11 18:00:31 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:00:33 EDT 2017 
#--------------------------------------------
#@# WM Segmentation Tue Jul 11 18:00:33 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n cp wm.mgz wm.seg.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:02:47 EDT 2017 
#--------------------------------------------
#@# Fill Tue Jul 11 18:02:47 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:03:26 EDT 2017 
#--------------------------------------------
#@# Tessellate lh Tue Jul 11 18:03:26 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:03:33 EDT 2017 
#--------------------------------------------
#@# Tessellate rh Tue Jul 11 18:03:33 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:03:39 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Tue Jul 11 18:03:39 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:03:48 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Tue Jul 11 18:03:48 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:03:57 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Tue Jul 11 18:03:57 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:04:33 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Tue Jul 11 18:04:33 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:05:07 EDT 2017 
#--------------------------------------------
#@# QSphere lh Tue Jul 11 18:05:07 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:08:21 EDT 2017 
#--------------------------------------------
#@# QSphere rh Tue Jul 11 18:08:21 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:11:29 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Tue Jul 11 18:11:29 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Tue Jul 11 18:11:29 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-04 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 18:47:38 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Tue Jul 11 18:47:38 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Tue Jul 11 18:47:38 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-04 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 19:26:25 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Tue Jul 11 19:26:25 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-04 lh \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 19:42:13 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Tue Jul 11 19:42:13 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-04 rh \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 19:56:55 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Tue Jul 11 19:56:55 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 19:57:03 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Tue Jul 11 19:57:03 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 19:57:34 EDT 2017 
#--------------------------------------------
#@# Sphere lh Tue Jul 11 19:57:34 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 20:31:42 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Tue Jul 11 20:31:42 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 21:24:50 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Tue Jul 11 21:24:50 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 21:25:06 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Tue Jul 11 21:25:06 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-04 lh \n
#--------------------------------------------
#@# Surf Volume lh Tue Jul 11 21:39:31 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 21:39:35 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Tue Jul 11 21:39:35 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 21:39:39 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Tue Jul 11 21:39:39 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 21:39:46 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Tue Jul 11 21:39:46 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 21:40:15 EDT 2017 
#--------------------------------------------
#@# Sphere rh Tue Jul 11 21:40:15 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 22:20:41 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Tue Jul 11 22:20:41 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/sub-04/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:10:09 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Tue Jul 11 23:10:09 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:10:24 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Tue Jul 11 23:10:24 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-04 rh \n
#--------------------------------------------
#@# Surf Volume rh Tue Jul 11 23:24:30 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:24:34 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Tue Jul 11 23:24:34 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:24:38 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Tue Jul 11 23:24:38 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:25:45 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Tue Jul 11 23:25:45 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:26:50 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Tue Jul 11 23:26:50 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-04 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:26:56 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Tue Jul 11 23:26:56 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-04 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:27:02 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Tue Jul 11 23:27:02 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:27:04 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Tue Jul 11 23:27:04 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:27:06 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Tue Jul 11 23:27:06 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:27:08 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Tue Jul 11 23:27:08 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:27:10 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Tue Jul 11 23:27:10 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-04 \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:44:26 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Tue Jul 11 23:44:27 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-04 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-04 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:45:37 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Tue Jul 11 23:45:37 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-04 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-04 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:46:47 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Tue Jul 11 23:46:47 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:47:07 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Tue Jul 11 23:47:07 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:47:27 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Tue Jul 11 23:47:27 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-04 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:48:04 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Tue Jul 11 23:48:04 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-04 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:48:40 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Tue Jul 11 23:48:40 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:48:56 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Tue Jul 11 23:48:56 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-04 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:49:12 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Tue Jul 11 23:49:12 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-04 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:49:48 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Tue Jul 11 23:49:48 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-04 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:50:23 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Tue Jul 11 23:50:23 EDT 2017
\n pctsurfcon --s sub-04 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:50:29 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Tue Jul 11 23:50:29 EDT 2017
\n pctsurfcon --s sub-04 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:50:35 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Tue Jul 11 23:50:35 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 23:50:58 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Tue Jul 11 23:50:58 EDT 2017
\n mri_aparc2aseg --s sub-04 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Tue Jul 11 23:56:26 EDT 2017
\n mri_aparc2aseg --s sub-04 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Wed Jul 12 00:01:55 EDT 2017
\n mri_aparc2aseg --s sub-04 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 00:07:25 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Wed Jul 12 00:07:25 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 00:07:31 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Wed Jul 12 00:07:31 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-04 \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 00:10:17 EDT 2017 
#-----------------------------------------
#@# WMParc Wed Jul 12 00:10:17 EDT 2017
\n mri_aparc2aseg --s sub-04 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-04 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 00:18:13 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Wed Jul 12 00:18:14 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-04 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-04 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-04 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-04 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-04 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-04 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-04 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-04 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-04 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-04 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Wed Jul 12 00:22:38 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Wed Jul 12 00:22:38 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-04 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-04 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-04 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-04 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-04 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-04 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/GitHub/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-04 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-04 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-04 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-04 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-04 rh white \n
