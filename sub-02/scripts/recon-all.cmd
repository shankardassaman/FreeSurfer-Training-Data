\n\n#---------------------------------
# New invocation of recon-all Thu Jul  6 19:05:35 EDT 2017 
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/nii.gz/J21705-t1/GR_IR-Siemens_MPRAGE.nii.gz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/orig/001.mgz \n
#--------------------------------------------
#@# MotionCor Thu Jul  6 19:05:44 EDT 2017
\n cp /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/orig/001.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/rawavg.mgz \n
\n mri_convert /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/rawavg.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/transforms/talairach.xfm /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/orig.mgz /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/orig.mgz \n
#--------------------------------------------
#@# Deface Thu Jul  6 19:05:55 EDT 2017
\n mri_deface orig.mgz /Volumes/CFMI-CFS/opt/fs6/average/talairach_mixed_with_skull.gca /Volumes/CFMI-CFS/opt/fs6/average/face.gca orig_defaced.mgz \n
#--------------------------------------------
#@# Talairach Thu Jul  6 19:08:28 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm --atlas 3T18yoSchwartzReactN32_as_orig \n
talairach_avi log file is transforms/talairach_avi.log...
\n cp transforms/talairach.auto.xfm transforms/talairach.xfm \n
#--------------------------------------------
#@# Talairach Failure Detection Thu Jul  6 19:10:04 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Volumes/CFMI-CFS/opt/fs6/bin/extract_talairach_avi_QA.awk /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Thu Jul  6 19:10:04 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --proto-iters 1000 --distance 50 --n 1 \n
\n mri_add_xform_to_header -c /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Thu Jul  6 19:11:33 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Thu Jul  6 19:13:37 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta \n
\n mri_watershed -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Volumes/CFMI-CFS/opt/fs6/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
#-------------------------------------
#@# EM Registration Thu Jul  6 19:23:48 EDT 2017
\n mri_em_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Thu Jul  6 19:32:50 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Thu Jul  6 19:35:41 EDT 2017
\n mri_ca_register -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Thu Jul  6 22:08:35 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/mri/transforms/cc_up.lta sub-02 \n
#--------------------------------------
#@# Merge ASeg Thu Jul  6 23:16:24 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Thu Jul  6 23:16:24 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Thu Jul  6 23:19:44 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Thu Jul  6 23:19:46 EDT 2017
\n mri_segment -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Thu Jul  6 23:22:29 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Thu Jul  6 23:23:17 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Thu Jul  6 23:23:22 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Thu Jul  6 23:23:28 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Thu Jul  6 23:23:28 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:09 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Fri Jul  7 09:46:09 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:17 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Fri Jul  7 09:46:17 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:25 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Fri Jul  7 09:46:25 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:46:42 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Fri Jul  7 09:46:42 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:47:00 EDT 2017 
#--------------------------------------------
#@# QSphere lh Fri Jul  7 09:47:00 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:49:00 EDT 2017 
#--------------------------------------------
#@# QSphere rh Fri Jul  7 09:49:01 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 09:51:55 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Fri Jul  7 09:51:55 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Fri Jul  7 09:51:55 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-02 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 10:39:47 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Fri Jul  7 10:39:47 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Fri Jul  7 10:39:47 EDT 2017
\n mris_fix_topology -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-02 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:13:46 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Fri Jul  7 11:13:47 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-02 lh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:33:27 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Fri Jul  7 11:33:27 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-02 rh \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:54:08 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Fri Jul  7 11:54:09 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:54:18 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Fri Jul  7 11:54:18 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 11:54:38 EDT 2017 
#--------------------------------------------
#@# Sphere lh Fri Jul  7 11:54:38 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:08:15 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Fri Jul  7 12:08:15 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:44:08 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Fri Jul  7 12:44:08 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 12:44:35 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Fri Jul  7 12:44:36 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-02 lh \n
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 13:11:39 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:11:44 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Fri Jul  7 13:11:44 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:11:48 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Fri Jul  7 13:11:48 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:11:59 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Fri Jul  7 13:11:59 EDT 2017
\n mris_inflate -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:12:20 EDT 2017 
#--------------------------------------------
#@# Sphere rh Fri Jul  7 13:12:21 EDT 2017
\n mris_sphere -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 13:22:58 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Fri Jul  7 13:22:58 EDT 2017
\n mris_register -curv -rusage /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/sub-02/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:06:10 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Fri Jul  7 14:06:10 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:06:34 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Fri Jul  7 14:06:34 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-02 rh \n
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 14:27:01 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:27:06 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Fri Jul  7 14:27:06 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:27:10 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Fri Jul  7 14:27:10 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:28:40 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Fri Jul  7 14:28:40 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:30:11 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Fri Jul  7 14:30:11 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-02 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:30:18 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Fri Jul  7 14:30:19 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-02 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:30:27 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Fri Jul  7 14:30:27 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:30:30 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Fri Jul  7 14:30:30 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:30:33 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Fri Jul  7 14:30:33 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:30:36 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Fri Jul  7 14:30:36 EDT 2017
\n mrisp_paint -a 5 /Volumes/CFMI-CFS/opt/fs6/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:30:39 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Fri Jul  7 14:30:39 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-02 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:48:27 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Fri Jul  7 14:48:27 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-02 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-02 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:49:49 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Fri Jul  7 14:49:49 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-02 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-02 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:51:08 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Fri Jul  7 14:51:08 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:51:30 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Fri Jul  7 14:51:31 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:51:53 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Fri Jul  7 14:51:53 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-02 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:52:33 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Fri Jul  7 14:52:33 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-02 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:53:14 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Fri Jul  7 14:53:14 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:53:32 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Fri Jul  7 14:53:32 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Volumes/CFMI-CFS/opt/fs6/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:53:49 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Fri Jul  7 14:53:49 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-02 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:54:26 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Fri Jul  7 14:54:26 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-02 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:55:04 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Fri Jul  7 14:55:04 EDT 2017
\n pctsurfcon --s sub-02 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:55:11 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Fri Jul  7 14:55:11 EDT 2017
\n pctsurfcon --s sub-02 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:55:17 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Fri Jul  7 14:55:17 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 14:55:44 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Fri Jul  7 14:55:44 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Fri Jul  7 15:01:07 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Fri Jul  7 15:07:14 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Volumes/CFMI-CFS/opt/fs6/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:38 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Fri Jul  7 15:13:38 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:13:46 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Fri Jul  7 15:13:46 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Volumes/CFMI-CFS/opt/fs6/ASegStatsLUT.txt --subject sub-02 \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:15:33 EDT 2017 
#-----------------------------------------
#@# WMParc Fri Jul  7 15:15:33 EDT 2017
\n mri_aparc2aseg --s sub-02 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-02 --surf-wm-vol --ctab /Volumes/CFMI-CFS/opt/fs6/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:24:46 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Fri Jul  7 15:24:46 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-02 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-02 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-02 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-02 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-02 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-02 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-02 --hemi lh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-02 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-02 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Fri Jul  7 15:30:03 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Fri Jul  7 15:30:03 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-02 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-02 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-02 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-02 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-02 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Volumes/CFMI-CFS/sync/ADS/data/mri/FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-02 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-02 --hemi rh --ctab /Volumes/CFMI-CFS/opt/fs6/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-02 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-02 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:26:59 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Mon Jul 10 15:27:10 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:28:14 EDT 2017 
#--------------------------------------------
#@# MotionCor Mon Jul 10 15:28:14 EDT 2017
\n cp /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/orig/001.mgz /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/rawavg.mgz \n
\n mri_convert /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/rawavg.mgz /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/transforms/talairach.xfm /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/orig.mgz /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/orig.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:28:23 EDT 2017 
#--------------------------------------------
#@# Talairach Mon Jul 10 15:28:23 EDT 2017
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\nINFO: transforms/talairach.xfm already exists!
The new transforms/talairach.auto.xfm will not be copied to transforms/talairach.xfm
This is done to retain any edits made to transforms/talairach.xfm
Add the -clean-tal flag to recon-all to overwrite transforms/talairach.xfm\n
#--------------------------------------------
#@# Talairach Failure Detection Mon Jul 10 15:30:13 EDT 2017
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/bin/extract_talairach_avi_QA.awk /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/transforms/talairach_avi.log \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:30:13 EDT 2017 
#--------------------------------------------
#@# Nu Intensity Correction Mon Jul 10 15:30:14 EDT 2017
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:32:18 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization Mon Jul 10 15:32:18 EDT 2017
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:34:38 EDT 2017 
#--------------------------------------------
#@# Skull Stripping Mon Jul 10 15:34:38 EDT 2017
\n mri_watershed -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\nINFO: brainmask.mgz already exists!
The new brainmask.auto.mgz will not be copied to brainmask.mgz.
This is done to retain any edits made to brainmask.mgz.
Add the -clean-bm flag to recon-all to overwrite brainmask.mgz.\n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:35:03 EDT 2017 
#-------------------------------------
#@# EM Registration Mon Jul 10 15:35:03 EDT 2017
\n mri_em_register -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:44:05 EDT 2017 
#--------------------------------------
#@# CA Normalize Mon Jul 10 15:44:05 EDT 2017
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 15:45:30 EDT 2017 
#--------------------------------------
#@# CA Reg Mon Jul 10 15:45:30 EDT 2017
\n mri_ca_register -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 17:48:46 EDT 2017 
#--------------------------------------
#@# SubCort Seg Mon Jul 10 17:48:46 EDT 2017
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/mri/transforms/cc_up.lta sub-02 \n
#--------------------------------------
#@# Merge ASeg Mon Jul 10 18:41:59 EDT 2017
\n cp aseg.auto.mgz aseg.presurf.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:42:00 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Mon Jul 10 18:42:00 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:45:50 EDT 2017 
#--------------------------------------------
#@# Mask BFS Mon Jul 10 18:45:50 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:45:53 EDT 2017 
#--------------------------------------------
#@# WM Segmentation Mon Jul 10 18:45:53 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:48:24 EDT 2017 
#--------------------------------------------
#@# Fill Mon Jul 10 18:48:24 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:49:08 EDT 2017 
#--------------------------------------------
#@# Tessellate lh Mon Jul 10 18:49:08 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:49:15 EDT 2017 
#--------------------------------------------
#@# Tessellate rh Mon Jul 10 18:49:15 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:49:21 EDT 2017 
#--------------------------------------------
#@# Smooth1 lh Mon Jul 10 18:49:21 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:49:30 EDT 2017 
#--------------------------------------------
#@# Smooth1 rh Mon Jul 10 18:49:30 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:49:38 EDT 2017 
#--------------------------------------------
#@# Inflation1 lh Mon Jul 10 18:49:38 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:50:12 EDT 2017 
#--------------------------------------------
#@# Inflation1 rh Mon Jul 10 18:50:12 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:50:45 EDT 2017 
#--------------------------------------------
#@# QSphere lh Mon Jul 10 18:50:45 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:53:42 EDT 2017 
#--------------------------------------------
#@# QSphere rh Mon Jul 10 18:53:42 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 18:56:49 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy lh Mon Jul 10 18:56:49 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#@# Fix Topology lh Mon Jul 10 18:56:49 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-02 lh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 19:29:01 EDT 2017 
#--------------------------------------------
#@# Fix Topology Copy rh Mon Jul 10 19:29:02 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology rh Mon Jul 10 19:29:02 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-02 rh \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:19:44 EDT 2017 
#--------------------------------------------
#@# Make White Surf lh Mon Jul 10 20:19:44 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-02 lh \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:34:41 EDT 2017 
#--------------------------------------------
#@# Make White Surf rh Mon Jul 10 20:34:41 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -mgz -T1 brain.finalsurfs sub-02 rh \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:49:23 EDT 2017 
#--------------------------------------------
#@# Smooth2 lh Mon Jul 10 20:49:23 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:49:30 EDT 2017 
#--------------------------------------------
#@# Inflation2 lh Mon Jul 10 20:49:30 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 20:49:58 EDT 2017 
#--------------------------------------------
#@# Sphere lh Mon Jul 10 20:49:58 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 21:32:20 EDT 2017 
#--------------------------------------------
#@# Surf Reg lh Mon Jul 10 21:32:20 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:19:29 EDT 2017 
#-----------------------------------------
#@# Cortical Parc lh Mon Jul 10 22:19:29 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:19:47 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf lh Mon Jul 10 22:19:47 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-02 lh \n
#--------------------------------------------
#@# Surf Volume lh Mon Jul 10 22:34:50 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:34:54 EDT 2017 
#--------------------------------------------
#@# Surf Volume lh Mon Jul 10 22:34:54 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:34:57 EDT 2017 
#--------------------------------------------
#@# Smooth2 rh Mon Jul 10 22:34:57 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:05 EDT 2017 
#--------------------------------------------
#@# Inflation2 rh Mon Jul 10 22:35:05 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:35:33 EDT 2017 
#--------------------------------------------
#@# Sphere rh Mon Jul 10 22:35:33 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 22:57:10 EDT 2017 
#--------------------------------------------
#@# Surf Reg rh Mon Jul 10 22:57:10 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 23:45:52 EDT 2017 
#-----------------------------------------
#@# Cortical Parc rh Mon Jul 10 23:45:53 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
\n\n#---------------------------------
# New invocation of recon-all Mon Jul 10 23:46:09 EDT 2017 
#--------------------------------------------
#@# Make Pial Surf rh Mon Jul 10 23:46:10 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-02 rh \n
#--------------------------------------------
#@# Surf Volume rh Tue Jul 11 00:00:47 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:00:51 EDT 2017 
#--------------------------------------------
#@# Surf Volume rh Tue Jul 11 00:00:51 EDT 2017
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:00:54 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K lh Tue Jul 11 00:00:54 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:01:57 EDT 2017 
#--------------------------------------------
#@# Curv .H and .K rh Tue Jul 11 00:01:57 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:03:00 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats lh Tue Jul 11 00:03:00 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-02 lh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:03:05 EDT 2017 
\n#-----------------------------------------
#@# Curvature Stats rh Tue Jul 11 00:03:05 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-02 rh curv sulc \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:03:11 EDT 2017 
#--------------------------------------------
#@# Jacobian white lh Tue Jul 11 00:03:11 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:03:13 EDT 2017 
#--------------------------------------------
#@# Jacobian white rh Tue Jul 11 00:03:13 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:03:15 EDT 2017 
#--------------------------------------------
#@# AvgCurv lh Tue Jul 11 00:03:16 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:03:18 EDT 2017 
#--------------------------------------------
#@# AvgCurv rh Tue Jul 11 00:03:18 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:03:19 EDT 2017 
#--------------------------------------------
#@# Cortical ribbon mask Tue Jul 11 00:03:19 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-02 \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:16:43 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats lh Tue Jul 11 00:16:43 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-02 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-02 lh pial \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:17:45 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats rh Tue Jul 11 00:17:45 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-02 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-02 rh pial \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:18:47 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 lh Tue Jul 11 00:18:47 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:19:05 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 2 rh Tue Jul 11 00:19:05 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:19:23 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 lh Tue Jul 11 00:19:23 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-02 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:19:54 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 2 rh Tue Jul 11 00:19:54 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-02 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:20:26 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 lh Tue Jul 11 00:20:26 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:20:40 EDT 2017 
#-----------------------------------------
#@# Cortical Parc 3 rh Tue Jul 11 00:20:41 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:20:55 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 lh Tue Jul 11 00:20:55 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-02 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:21:25 EDT 2017 
#-----------------------------------------
#@# Parcellation Stats 3 rh Tue Jul 11 00:21:25 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-02 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:21:55 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast lh Tue Jul 11 00:21:55 EDT 2017
\n pctsurfcon --s sub-02 --lh-only \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:22:01 EDT 2017 
#-----------------------------------------
#@# WM/GM Contrast rh Tue Jul 11 00:22:01 EDT 2017
\n pctsurfcon --s sub-02 --rh-only \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:22:07 EDT 2017 
#-----------------------------------------
#@# Relabel Hypointensities Tue Jul 11 00:22:07 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:22:28 EDT 2017 
#-----------------------------------------
#@# AParc-to-ASeg aparc Tue Jul 11 00:22:28 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Tue Jul 11 00:26:52 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Tue Jul 11 00:31:22 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:35:51 EDT 2017 
#-----------------------------------------
#@# APas-to-ASeg Tue Jul 11 00:35:51 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:35:57 EDT 2017 
#--------------------------------------------
#@# ASeg Stats Tue Jul 11 00:35:57 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-02 \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:38:55 EDT 2017 
#-----------------------------------------
#@# WMParc Tue Jul 11 00:38:55 EDT 2017
\n mri_aparc2aseg --s sub-02 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-02 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:47:17 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels lh Tue Jul 11 00:47:17 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-02 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-02 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-02 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-02 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-02 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-02 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-02 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-02 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-02 lh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 00:51:25 EDT 2017 
#--------------------------------------------
#@# BA_exvivo Labels rh Tue Jul 11 00:51:25 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-02 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-02 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-02 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-02 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-02 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-02 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-02 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-02 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-02 rh white \n
\n\n#---------------------------------
# New invocation of recon-all Tue Jul 11 10:56:44 EDT 2017 
#--------------------------------------------
#@# Intensity Normalization2 Tue Jul 11 10:56:51 EDT 2017
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Tue Jul 11 11:00:30 EDT 2017
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Tue Jul 11 11:00:32 EDT 2017
\n mri_binarize --i wm.mgz --min 255 --max 255 --o wm255.mgz --count wm255.txt \n
\n mri_binarize --i wm.mgz --min 1 --max 1 --o wm1.mgz --count wm1.txt \n
\n rm wm1.mgz wm255.mgz \n
\n cp wm.mgz wm.seg.mgz \n
\n mri_segment -keep -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess -keep wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Tue Jul 11 11:03:00 EDT 2017
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Tue Jul 11 11:03:41 EDT 2017
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Tue Jul 11 11:03:47 EDT 2017
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Tue Jul 11 11:03:52 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Tue Jul 11 11:04:00 EDT 2017
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
#--------------------------------------------
#@# Inflation1 lh Tue Jul 11 11:04:07 EDT 2017
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
#--------------------------------------------
#@# Inflation1 rh Tue Jul 11 11:04:34 EDT 2017
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
#--------------------------------------------
#@# QSphere lh Tue Jul 11 11:05:02 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
#--------------------------------------------
#@# QSphere rh Tue Jul 11 11:07:41 EDT 2017
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
#--------------------------------------------
#@# Fix Topology Copy lh Tue Jul 11 11:10:20 EDT 2017
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#--------------------------------------------
#@# Fix Topology Copy rh Tue Jul 11 11:10:21 EDT 2017
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology lh Tue Jul 11 11:10:21 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-02 lh \n
#@# Fix Topology rh Tue Jul 11 11:41:12 EDT 2017
\n mris_fix_topology -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-02 rh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
#--------------------------------------------
#@# Make White Surf lh Tue Jul 11 12:32:54 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-02 lh \n
#--------------------------------------------
#@# Make White Surf rh Tue Jul 11 12:37:47 EDT 2017
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-02 rh \n
#--------------------------------------------
#@# Smooth2 lh Tue Jul 11 12:42:50 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
#--------------------------------------------
#@# Smooth2 rh Tue Jul 11 12:42:58 EDT 2017
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
#--------------------------------------------
#@# Inflation2 lh Tue Jul 11 12:43:06 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
#--------------------------------------------
#@# Inflation2 rh Tue Jul 11 12:43:36 EDT 2017
\n mris_inflate -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
#--------------------------------------------
#@# Curv .H and .K lh Tue Jul 11 12:44:07 EDT 2017
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
#--------------------------------------------
#@# Curv .H and .K rh Tue Jul 11 12:45:12 EDT 2017
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n#-----------------------------------------
#@# Curvature Stats lh Tue Jul 11 12:46:21 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-02 lh curv sulc \n
\n#-----------------------------------------
#@# Curvature Stats rh Tue Jul 11 12:46:27 EDT 2017
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-02 rh curv sulc \n
#--------------------------------------------
#@# Sphere lh Tue Jul 11 12:46:32 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
#--------------------------------------------
#@# Sphere rh Tue Jul 11 13:25:16 EDT 2017
\n mris_sphere -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
#--------------------------------------------
#@# Surf Reg lh Tue Jul 11 13:55:03 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
#--------------------------------------------
#@# Surf Reg rh Tue Jul 11 14:52:26 EDT 2017
\n mris_register -curv -rusage /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/sub-02/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
#--------------------------------------------
#@# Jacobian white lh Tue Jul 11 16:00:34 EDT 2017
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
#--------------------------------------------
#@# Jacobian white rh Tue Jul 11 16:00:36 EDT 2017
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
#--------------------------------------------
#@# AvgCurv lh Tue Jul 11 16:00:39 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
#--------------------------------------------
#@# AvgCurv rh Tue Jul 11 16:00:41 EDT 2017
\n mrisp_paint -a 5 /Applications/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
#-----------------------------------------
#@# Cortical Parc lh Tue Jul 11 16:00:43 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
#-----------------------------------------
#@# Cortical Parc rh Tue Jul 11 16:01:01 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
#--------------------------------------------
#@# Make Pial Surf lh Tue Jul 11 16:01:19 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-02 lh \n
#--------------------------------------------
#@# Make Pial Surf rh Tue Jul 11 16:16:50 EDT 2017
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-02 rh \n
#--------------------------------------------
#@# Surf Volume lh Tue Jul 11 16:32:20 EDT 2017
#--------------------------------------------
#@# Surf Volume rh Tue Jul 11 16:32:25 EDT 2017
#--------------------------------------------
#@# Cortical ribbon mask Tue Jul 11 16:32:28 EDT 2017
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-02 \n
#-----------------------------------------
#@# Parcellation Stats lh Tue Jul 11 16:49:02 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-02 lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-02 lh pial \n
#-----------------------------------------
#@# Parcellation Stats rh Tue Jul 11 16:50:21 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-02 rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-02 rh pial \n
#-----------------------------------------
#@# Cortical Parc 2 lh Tue Jul 11 16:51:41 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Cortical Parc 2 rh Tue Jul 11 16:52:02 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Parcellation Stats 2 lh Tue Jul 11 16:52:24 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-02 lh white \n
#-----------------------------------------
#@# Parcellation Stats 2 rh Tue Jul 11 16:53:06 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-02 rh white \n
#-----------------------------------------
#@# Cortical Parc 3 lh Tue Jul 11 16:53:48 EDT 2017
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 lh ../surf/lh.sphere.reg /Applications/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Cortical Parc 3 rh Tue Jul 11 16:54:05 EDT 2017
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-02 rh ../surf/rh.sphere.reg /Applications/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Parcellation Stats 3 lh Tue Jul 11 16:54:21 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-02 lh white \n
#-----------------------------------------
#@# Parcellation Stats 3 rh Tue Jul 11 16:55:00 EDT 2017
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-02 rh white \n
#-----------------------------------------
#@# WM/GM Contrast lh Tue Jul 11 16:55:40 EDT 2017
\n pctsurfcon --s sub-02 --lh-only \n
#-----------------------------------------
#@# WM/GM Contrast rh Tue Jul 11 16:55:47 EDT 2017
\n pctsurfcon --s sub-02 --rh-only \n
#-----------------------------------------
#@# Relabel Hypointensities Tue Jul 11 16:55:54 EDT 2017
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
#-----------------------------------------
#@# AParc-to-ASeg aparc Tue Jul 11 16:56:20 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Tue Jul 11 17:02:46 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Tue Jul 11 17:09:17 EDT 2017
\n mri_aparc2aseg --s sub-02 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
#-----------------------------------------
#@# APas-to-ASeg Tue Jul 11 17:15:13 EDT 2017
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
#--------------------------------------------
#@# ASeg Stats Tue Jul 11 17:15:20 EDT 2017
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/ASegStatsLUT.txt --subject sub-02 \n
#-----------------------------------------
#@# WMParc Tue Jul 11 17:18:38 EDT 2017
\n mri_aparc2aseg --s sub-02 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-02 --surf-wm-vol --ctab /Applications/freesurfer/WMParcStatsLUT.txt --etiv \n
#--------------------------------------------
#@# BA_exvivo Labels lh Tue Jul 11 17:28:47 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-02 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-02 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-02 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-02 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-02 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-02 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s sub-02 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-02 --hemi lh --ctab /Applications/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-02 lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-02 lh white \n
#--------------------------------------------
#@# BA_exvivo Labels rh Tue Jul 11 17:33:31 EDT 2017
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-02 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-02 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-02 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-02 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-02 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-02 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Users/freesurfer_user/Documents/github/Edits-FreeSurfer-Training-Data/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-02 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s sub-02 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s sub-02 --hemi rh --ctab /Applications/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-02 rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-02 rh white \n
