\n\n#---------------------------------
# New invocation of recon-all Thu Jul  6 19:19:54 EDT 2017 
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/nii.gz/J22178-t1/GR_IR-Siemens_MPRAGE.nii.gz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/orig/001.mgz \n
#--------------------------------------------
#@# MotionCor Thu Jul  6 19:20:09 EDT 2017
\n cp /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/orig/001.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/rawavg.mgz \n
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/rawavg.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach.xfm /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/orig.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/orig.mgz \n
#--------------------------------------------
#@# Deface Thu Jul  6 19:20:23 EDT 2017
\n mri_deface orig.mgz /Volumes/CFMI-CFS/opt/fs6/average/talairach_mixed_with_skull.gca /Volumes/CFMI-CFS/opt/fs6/average/face.gca orig_defaced.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul  6 19:23:21 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm --atlas 3T18yoSchwartzReactN32_as_orig \n
talairach_avi log file is transforms/talairach_avi.log...
\n cp transforms/talairach.auto.xfm transforms/talairach.xfm \n
#--------------------------------------------
#@# Talairach Failure Detection Thu Jul  6 19:25:22 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Volumes/CFMI-CFS/opt/fs6/bin/extract_talairach_avi_QA.awk /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul  6 19:25:22 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --proto-iters 1000 --distance 50 --n 1 \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul  6 19:27:50 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul  6 19:31:58 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta \n
\n mri_watershed -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
#-------------------------------------
#@# EM Registration Thu Jul  6 19:45:46 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Thu Jul  6 19:59:30 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Thu Jul  6 20:02:18 EDT 2017
\n mri_ca_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Thu Jul  6 22:42:41 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/mri/transforms/cc_up.lta sub-08 \n
#--------------------------------------
#@# Merge ASeg Thu Jul  6 23:47:33 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Thu Jul  6 23:47:33 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Thu Jul  6 23:50:32 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Thu Jul  6 23:50:33 EDT 2017
\n mri_segment -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Thu Jul  6 23:52:51 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Thu Jul  6 23:53:34 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Thu Jul  6 23:53:40 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Thu Jul  6 23:53:46 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Thu Jul  6 23:53:46 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:49:48 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Fri Jul  7 09:49:48 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:50:01 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Fri Jul  7 09:50:01 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:50:17 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Fri Jul  7 09:50:17 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:51:00 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Fri Jul  7 09:51:01 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:51:48 EDT 2017 
#--------------------------------------------
#@# QSphere lh Fri Jul  7 09:51:48 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:55:11 EDT 2017 
#--------------------------------------------
#@# QSphere rh Fri Jul  7 09:55:11 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:57:51 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Fri Jul  7 09:57:52 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Fri Jul  7 09:57:52 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-08 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 10:34:07 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Fri Jul  7 10:34:07 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Fri Jul  7 10:34:07 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-08 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:54:38 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Fri Jul  7 15:54:38 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-08 lh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:13:37 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Fri Jul  7 16:13:37 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-08 rh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:32:51 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Fri Jul  7 16:32:51 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:33:00 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Fri Jul  7 16:33:00 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:33:21 EDT 2017 
#--------------------------------------------
#@# Sphere lh Fri Jul  7 16:33:21 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 16:52:03 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Fri Jul  7 16:52:04 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 17:24:38 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Fri Jul  7 17:24:38 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 17:24:57 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Fri Jul  7 17:24:57 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-08 lh \n
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 17:43:53 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 17:43:57 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 17:43:57 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 17:44:02 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Fri Jul  7 17:44:02 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 17:44:12 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Fri Jul  7 17:44:12 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 17:44:34 EDT 2017 
#--------------------------------------------
#@# Sphere rh Fri Jul  7 17:44:34 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 18:04:28 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Fri Jul  7 18:04:28 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 18:38:38 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Fri Jul  7 18:38:38 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 18:38:56 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Fri Jul  7 18:38:56 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-08 rh \n
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 18:57:57 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 18:58:01 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 18:58:01 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 18:58:05 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Fri Jul  7 18:58:06 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 18:59:27 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Fri Jul  7 18:59:27 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:00:51 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Fri Jul  7 19:00:51 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-08 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:00:58 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Fri Jul  7 19:00:58 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-08 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:01:05 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Fri Jul  7 19:01:05 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:01:07 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Fri Jul  7 19:01:07 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:01:10 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Fri Jul  7 19:01:10 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:01:12 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Fri Jul  7 19:01:12 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:01:15 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Fri Jul  7 19:01:15 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-08 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:14:34 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Fri Jul  7 19:14:34 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-08 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-08 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:16:00 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Fri Jul  7 19:16:00 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-08 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-08 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:17:26 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jul  7 19:17:26 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:17:49 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jul  7 19:17:49 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:18:12 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jul  7 19:18:12 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-08 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:18:56 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jul  7 19:18:56 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-08 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:19:42 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jul  7 19:19:42 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:20:00 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jul  7 19:20:00 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:20:18 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jul  7 19:20:18 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-08 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:21:00 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jul  7 19:21:00 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-08 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:21:44 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Fri Jul  7 19:21:44 EDT 2017
\n pctsurfcon --s sub-08 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:21:51 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Fri Jul  7 19:21:51 EDT 2017
\n pctsurfcon --s sub-08 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:21:58 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Fri Jul  7 19:21:58 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:22:26 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jul  7 19:22:26 EDT 2017
\n mri_aparc2aseg --s sub-08 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Jul  7 19:27:39 EDT 2017
\n mri_aparc2aseg --s sub-08 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Jul  7 19:32:49 EDT 2017
\n mri_aparc2aseg --s sub-08 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:37:59 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Fri Jul  7 19:37:59 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:38:05 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Fri Jul  7 19:38:05 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Volumes/CFMI-CFS/opt/fs6/ASegStatsLUT.txt --subject sub-08 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:39:18 EDT 2017 
#-----------------------------------------
#@# WMParc Fri Jul  7 19:39:18 EDT 2017
\n mri_aparc2aseg --s sub-08 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-08 --surf-wm-vol --ctab /Volumes/CFMI-CFS/opt/fs6/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:46:33 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jul  7 19:46:33 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-08 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-08 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-08 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-08 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-08 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-08 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-08 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-08 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-08 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 19:51:50 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jul  7 19:51:50 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-08 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-08 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-08 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-08 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-08 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-08 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-08 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-08 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-08 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 18 15:22:31 EDT 2017 
#--------------------------------------------
#@# MotionCor Tue Jul 18 15:22:31 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 00:48:05 EDT 2017 
#--------------------------------------------
#@# MotionCor Fri Jul 21 00:48:05 EDT 2017
\n cp /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/orig/001.mgz /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/rawavg.mgz /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/orig.mgz /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/orig.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 00:48:12 EDT 2017 
#--------------------------------------------
#@# Talairach Fri Jul 21 00:48:12 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
#@# Talairach Failure Detection Fri Jul 21 00:49:39 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach_avi.log \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 00:49:39 EDT 2017 
#--------------------------------------------
#@# Nu Intensity Correction Fri Jul 21 00:49:39 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 00:51:16 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization Fri Jul 21 00:51:16 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 00:53:15 EDT 2017 
#--------------------------------------------
#@# Skull Stripping Fri Jul 21 00:53:15 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\nINFO: brainmask.mgz already exists!
The new brainmask.auto.mgz will not be copied to brainmask.mgz.
This is done to retain any edits made to brainmask.mgz.
Add the -clean-bm flag to recon-all to overwrite brainmask.mgz.\n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 00:53:36 EDT 2017 
#-------------------------------------
#@# EM Registration Fri Jul 21 00:53:36 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 01:03:15 EDT 2017 
#--------------------------------------
#@# CA Normalize Fri Jul 21 01:03:15 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 01:04:32 EDT 2017 
#--------------------------------------
#@# CA Reg Fri Jul 21 01:04:32 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 02:53:59 EDT 2017 
#--------------------------------------
#@# SubCort Seg Fri Jul 21 02:53:59 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/mri/transforms/cc_up.lta sub-08 \n
#--------------------------------------
#@# Merge ASeg Fri Jul 21 03:42:50 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:42:51 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Fri Jul 21 03:42:51 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:45:57 EDT 2017 
#--------------------------------------------
#@# Mask BFS Fri Jul 21 03:45:57 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:45:59 EDT 2017 
#--------------------------------------------
#@# WM Segmentation Fri Jul 21 03:45:59 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:47:59 EDT 2017 
#--------------------------------------------
#@# Fill Fri Jul 21 03:47:59 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:48:33 EDT 2017 
#--------------------------------------------
#@# Tessellate lh Fri Jul 21 03:48:33 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:48:39 EDT 2017 
#--------------------------------------------
#@# Tessellate rh Fri Jul 21 03:48:39 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:48:45 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Fri Jul 21 03:48:45 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:48:53 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Fri Jul 21 03:48:53 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:49:02 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Fri Jul 21 03:49:02 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:49:32 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Fri Jul 21 03:49:32 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:50:02 EDT 2017 
#--------------------------------------------
#@# QSphere lh Fri Jul 21 03:50:02 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:52:53 EDT 2017 
#--------------------------------------------
#@# QSphere rh Fri Jul 21 03:52:53 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 03:55:56 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Fri Jul 21 03:55:56 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Fri Jul 21 03:55:56 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-08 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 04:25:29 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Fri Jul 21 04:25:29 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Fri Jul 21 04:25:29 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-08 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 07:52:55 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Fri Jul 21 07:52:55 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-08 lh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 08:08:11 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Fri Jul 21 08:08:11 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-08 rh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 08:23:34 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Fri Jul 21 08:23:34 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 08:23:42 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Fri Jul 21 08:23:42 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 08:24:11 EDT 2017 
#--------------------------------------------
#@# Sphere lh Fri Jul 21 08:24:11 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 08:56:40 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Fri Jul 21 08:56:41 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 09:47:48 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Fri Jul 21 09:47:48 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 09:48:04 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Fri Jul 21 09:48:04 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-08 lh \n
#--------------------------------------------
#@# Surf Volume lh Fri Jul 21 10:03:11 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 10:03:15 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Fri Jul 21 10:03:15 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 10:03:18 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Fri Jul 21 10:03:18 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 10:03:27 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Fri Jul 21 10:03:27 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 10:03:57 EDT 2017 
#--------------------------------------------
#@# Sphere rh Fri Jul 21 10:03:57 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 10:43:36 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Fri Jul 21 10:43:36 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/sub-08/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 11:42:59 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Fri Jul 21 11:42:59 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 11:43:15 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Fri Jul 21 11:43:15 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-08 rh \n
#--------------------------------------------
#@# Surf Volume rh Fri Jul 21 11:58:51 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 11:58:55 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Fri Jul 21 11:58:55 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 11:58:59 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Fri Jul 21 11:58:59 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:00:06 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Fri Jul 21 12:00:06 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:01:15 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Fri Jul 21 12:01:15 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-08 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:01:21 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Fri Jul 21 12:01:21 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-08 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:01:28 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Fri Jul 21 12:01:28 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:01:30 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Fri Jul 21 12:01:30 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:01:32 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Fri Jul 21 12:01:32 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:01:34 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Fri Jul 21 12:01:34 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:01:36 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Fri Jul 21 12:01:36 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-08 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:16:41 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Fri Jul 21 12:16:41 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-08 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-08 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:17:52 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Fri Jul 21 12:17:52 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-08 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-08 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:19:03 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jul 21 12:19:03 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:19:24 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jul 21 12:19:24 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:19:44 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jul 21 12:19:44 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-08 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:20:20 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jul 21 12:20:20 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-08 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:20:57 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jul 21 12:20:57 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:21:13 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jul 21 12:21:13 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-08 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:21:30 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jul 21 12:21:30 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-08 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:22:05 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jul 21 12:22:05 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-08 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:22:41 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Fri Jul 21 12:22:41 EDT 2017
\n pctsurfcon --s sub-08 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:22:47 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Fri Jul 21 12:22:47 EDT 2017
\n pctsurfcon --s sub-08 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:22:53 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Fri Jul 21 12:22:53 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:23:15 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jul 21 12:23:16 EDT 2017
\n mri_aparc2aseg --s sub-08 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Jul 21 12:27:20 EDT 2017
\n mri_aparc2aseg --s sub-08 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Jul 21 12:31:23 EDT 2017
\n mri_aparc2aseg --s sub-08 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:35:28 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Fri Jul 21 12:35:28 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:35:33 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Fri Jul 21 12:35:33 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-08 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:38:16 EDT 2017 
#-----------------------------------------
#@# WMParc Fri Jul 21 12:38:16 EDT 2017
\n mri_aparc2aseg --s sub-08 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-08 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:46:13 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jul 21 12:46:13 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-08 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-08 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-08 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-08 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-08 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-08 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-08 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-08 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-08 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-08 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul 21 12:50:28 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jul 21 12:50:28 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-08 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-08 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-08 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-08 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-08 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-08 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/Github/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-08 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-08 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-08 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-08 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-08 rh white \n
