\n\n#---------------------------------
# New invocation of recon-all Fri Aug 19 23:13:43 -03 2022 
\n mri_convert /Users/scutiller/desktop/demencia/t1.nii /Applications/freesurfer/6.0/subjects/demencia/mri/orig/001.mgz \n
#--------------------------------------------
#@# MotionCor Fri Aug 19 23:14:18 -03 2022
\n cp /Applications/freesurfer/6.0/subjects/demencia/mri/orig/001.mgz /Applications/freesurfer/6.0/subjects/demencia/mri/rawavg.mgz \n
\n mri_convert /Applications/freesurfer/6.0/subjects/demencia/mri/rawavg.mgz /Applications/freesurfer/6.0/subjects/demencia/mri/orig.mgz --conform \n
\n mri_add_xform_to_header -c /Applications/freesurfer/6.0/subjects/demencia/mri/transforms/talairach.xfm /Applications/freesurfer/6.0/subjects/demencia/mri/orig.mgz /Applications/freesurfer/6.0/subjects/demencia/mri/orig.mgz \n
#--------------------------------------------
#@# Talairach Fri Aug 19 23:14:31 -03 2022
\n mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 \n
\n talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm \n
talairach_avi log file is transforms/talairach_avi.log...
\n cp transforms/talairach.auto.xfm transforms/talairach.xfm \n
#--------------------------------------------
#@# Talairach Failure Detection Fri Aug 19 23:15:28 -03 2022
\n talairach_afd -T 0.005 -xfm transforms/talairach.xfm \n
\n awk -f /Applications/freesurfer/6.0/bin/extract_talairach_avi_QA.awk /Applications/freesurfer/6.0/subjects/demencia/mri/transforms/talairach_avi.log \n
\n tal_QC_AZS /Applications/freesurfer/6.0/subjects/demencia/mri/transforms/talairach_avi.log \n
#--------------------------------------------
#@# Nu Intensity Correction Fri Aug 19 23:15:28 -03 2022
\n mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 \n
\n mri_add_xform_to_header -c /Applications/freesurfer/6.0/subjects/demencia/mri/transforms/talairach.xfm nu.mgz nu.mgz \n
#--------------------------------------------
#@# Intensity Normalization Fri Aug 19 23:16:43 -03 2022
\n mri_normalize -g 1 -mprage nu.mgz T1.mgz \n
#--------------------------------------------
#@# Skull Stripping Fri Aug 19 23:18:13 -03 2022
\n mri_em_register -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /Applications/freesurfer/6.0/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta \n
\n mri_watershed -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mri_watershed.dat -T1 -brain_atlas /Applications/freesurfer/6.0/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz \n
\n cp brainmask.auto.mgz brainmask.mgz \n
#-------------------------------------
#@# EM Registration Fri Aug 19 23:24:58 -03 2022
\n mri_em_register -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /Applications/freesurfer/6.0/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta \n
#--------------------------------------
#@# CA Normalize Fri Aug 19 23:47:48 -03 2022
\n mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /Applications/freesurfer/6.0/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz \n
#--------------------------------------
#@# CA Reg Fri Aug 19 23:49:04 -03 2022
\n mri_ca_register -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /Applications/freesurfer/6.0/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z \n
#--------------------------------------
#@# SubCort Seg Sat Aug 20 01:05:17 -03 2022
\n mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /Applications/freesurfer/6.0/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz \n
\n mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /Applications/freesurfer/6.0/subjects/demencia/mri/transforms/cc_up.lta demencia \n
#--------------------------------------
#@# Merge ASeg Sat Aug 20 01:30:54 -03 2022
\n cp aseg.auto.mgz aseg.presurf.mgz \n
#--------------------------------------------
#@# Intensity Normalization2 Sat Aug 20 01:30:54 -03 2022
\n mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz \n
#--------------------------------------------
#@# Mask BFS Sat Aug 20 02:02:52 -03 2022
\n mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz \n
#--------------------------------------------
#@# WM Segmentation Sat Aug 20 02:02:53 -03 2022
\n mri_segment -mprage brain.mgz wm.seg.mgz \n
\n mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz \n
\n mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz \n
#--------------------------------------------
#@# Fill Sat Aug 20 02:04:32 -03 2022
\n mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz \n
#--------------------------------------------
#@# Tessellate lh Sat Aug 20 02:05:00 -03 2022
\n mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz \n
\n mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix \n
\n rm -f ../mri/filled-pretess255.mgz \n
\n mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix \n
#--------------------------------------------
#@# Tessellate rh Sat Aug 20 02:05:04 -03 2022
\n mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz \n
\n mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix \n
\n rm -f ../mri/filled-pretess127.mgz \n
\n mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix \n
#--------------------------------------------
#@# Smooth1 lh Sat Aug 20 02:05:07 -03 2022
\n mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix \n
#--------------------------------------------
#@# Smooth1 rh Sat Aug 20 02:05:12 -03 2022
\n mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix \n
#--------------------------------------------
#@# Inflation1 lh Sat Aug 20 02:05:17 -03 2022
\n mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix \n
#--------------------------------------------
#@# Inflation1 rh Sat Aug 20 02:05:29 -03 2022
\n mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix \n
#--------------------------------------------
#@# QSphere lh Sat Aug 20 02:05:40 -03 2022
\n mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix \n
#--------------------------------------------
#@# QSphere rh Sat Aug 20 02:06:45 -03 2022
\n mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix \n
#--------------------------------------------
#@# Fix Topology Copy lh Sat Aug 20 02:07:53 -03 2022
\n cp ../surf/lh.orig.nofix ../surf/lh.orig \n
\n cp ../surf/lh.inflated.nofix ../surf/lh.inflated \n
#--------------------------------------------
#@# Fix Topology Copy rh Sat Aug 20 02:07:53 -03 2022
\n cp ../surf/rh.orig.nofix ../surf/rh.orig \n
\n cp ../surf/rh.inflated.nofix ../surf/rh.inflated \n
#@# Fix Topology lh Sat Aug 20 02:07:53 -03 2022
\n mris_fix_topology -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 demencia lh \n
#@# Fix Topology rh Sat Aug 20 02:15:21 -03 2022
\n mris_fix_topology -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 demencia rh \n
\n mris_euler_number ../surf/lh.orig \n
\n mris_euler_number ../surf/rh.orig \n
\n mris_remove_intersection ../surf/lh.orig ../surf/lh.orig \n
\n rm ../surf/lh.inflated \n
\n mris_remove_intersection ../surf/rh.orig ../surf/rh.orig \n
\n rm ../surf/rh.inflated \n
#--------------------------------------------
#@# Make White Surf lh Sat Aug 20 04:41:46 -03 2022
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs demencia lh \n
#--------------------------------------------
#@# Make White Surf rh Sat Aug 20 05:33:08 -03 2022
\n mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs demencia rh \n
#--------------------------------------------
#@# Smooth2 lh Sat Aug 20 06:42:23 -03 2022
\n mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm \n
#--------------------------------------------
#@# Smooth2 rh Sat Aug 20 06:42:27 -03 2022
\n mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm \n
#--------------------------------------------
#@# Inflation2 lh Sat Aug 20 06:42:31 -03 2022
\n mris_inflate -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated \n
#--------------------------------------------
#@# Inflation2 rh Sat Aug 20 06:42:42 -03 2022
\n mris_inflate -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated \n
#--------------------------------------------
#@# Curv .H and .K lh Sat Aug 20 06:42:54 -03 2022
\n mris_curvature -w lh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated \n
#--------------------------------------------
#@# Curv .H and .K rh Sat Aug 20 06:59:01 -03 2022
\n mris_curvature -w rh.white.preaparc \n
\n mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated \n
\n#-----------------------------------------
#@# Curvature Stats lh Sat Aug 20 07:15:43 -03 2022
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm demencia lh curv sulc \n
\n#-----------------------------------------
#@# Curvature Stats rh Sat Aug 20 07:15:47 -03 2022
\n mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm demencia rh curv sulc \n
#--------------------------------------------
#@# Sphere lh Sat Aug 20 07:15:50 -03 2022
\n mris_sphere -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere \n
#--------------------------------------------
#@# Sphere rh Sat Aug 20 07:57:45 -03 2022
\n mris_sphere -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere \n
#--------------------------------------------
#@# Surf Reg lh Sat Aug 20 09:09:14 -03 2022
\n mris_register -curv -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /Applications/freesurfer/6.0/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg \n
#--------------------------------------------
#@# Surf Reg rh Sat Aug 20 09:47:12 -03 2022
\n mris_register -curv -rusage /Applications/freesurfer/6.0/subjects/demencia/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /Applications/freesurfer/6.0/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg \n
#--------------------------------------------
#@# Jacobian white lh Sat Aug 20 11:12:16 -03 2022
\n mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white \n
#--------------------------------------------
#@# Jacobian white rh Sat Aug 20 11:12:18 -03 2022
\n mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white \n
#--------------------------------------------
#@# AvgCurv lh Sat Aug 20 11:12:19 -03 2022
\n mrisp_paint -a 5 /Applications/freesurfer/6.0/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv \n
#--------------------------------------------
#@# AvgCurv rh Sat Aug 20 11:12:20 -03 2022
\n mrisp_paint -a 5 /Applications/freesurfer/6.0/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv \n
#-----------------------------------------
#@# Cortical Parc lh Sat Aug 20 11:12:21 -03 2022
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 demencia lh ../surf/lh.sphere.reg /Applications/freesurfer/6.0/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot \n
#-----------------------------------------
#@# Cortical Parc rh Sat Aug 20 11:12:29 -03 2022
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 demencia rh ../surf/rh.sphere.reg /Applications/freesurfer/6.0/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot \n
#--------------------------------------------
#@# Make Pial Surf lh Sat Aug 20 11:12:38 -03 2022
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs demencia lh \n
#--------------------------------------------
#@# Make Pial Surf rh Sat Aug 20 12:04:03 -03 2022
\n mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs demencia rh \n
#--------------------------------------------
#@# Surf Volume lh Sat Aug 20 12:55:02 -03 2022
#--------------------------------------------
#@# Surf Volume rh Sat Aug 20 12:55:04 -03 2022
#--------------------------------------------
#@# Cortical ribbon mask Sat Aug 20 12:55:06 -03 2022
\n mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon demencia \n
#-----------------------------------------
#@# Parcellation Stats lh Sat Aug 20 12:57:50 -03 2022
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab demencia lh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab demencia lh pial \n
#-----------------------------------------
#@# Parcellation Stats rh Sat Aug 20 12:58:23 -03 2022
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab demencia rh white \n
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab demencia rh pial \n
#-----------------------------------------
#@# Cortical Parc 2 lh Sat Aug 20 12:58:56 -03 2022
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 demencia lh ../surf/lh.sphere.reg /Applications/freesurfer/6.0/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Cortical Parc 2 rh Sat Aug 20 12:59:07 -03 2022
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 demencia rh ../surf/rh.sphere.reg /Applications/freesurfer/6.0/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot \n
#-----------------------------------------
#@# Parcellation Stats 2 lh Sat Aug 20 12:59:17 -03 2022
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab demencia lh white \n
#-----------------------------------------
#@# Parcellation Stats 2 rh Sat Aug 20 12:59:34 -03 2022
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab demencia rh white \n
#-----------------------------------------
#@# Cortical Parc 3 lh Sat Aug 20 12:59:50 -03 2022
\n mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 demencia lh ../surf/lh.sphere.reg /Applications/freesurfer/6.0/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Cortical Parc 3 rh Sat Aug 20 12:59:59 -03 2022
\n mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 demencia rh ../surf/rh.sphere.reg /Applications/freesurfer/6.0/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot \n
#-----------------------------------------
#@# Parcellation Stats 3 lh Sat Aug 20 13:00:07 -03 2022
\n mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab demencia lh white \n
#-----------------------------------------
#@# Parcellation Stats 3 rh Sat Aug 20 13:00:23 -03 2022
\n mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab demencia rh white \n
#-----------------------------------------
#@# WM/GM Contrast lh Sat Aug 20 13:00:40 -03 2022
\n pctsurfcon --s demencia --lh-only \n
#-----------------------------------------
#@# WM/GM Contrast rh Sat Aug 20 13:00:47 -03 2022
\n pctsurfcon --s demencia --rh-only \n
#-----------------------------------------
#@# Relabel Hypointensities Sat Aug 20 13:00:52 -03 2022
\n mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz \n
#-----------------------------------------
#@# AParc-to-ASeg aparc Sat Aug 20 13:01:03 -03 2022
\n mri_aparc2aseg --s demencia --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/6.0/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt \n
#-----------------------------------------
#@# AParc-to-ASeg a2009s Sat Aug 20 13:03:15 -03 2022
\n mri_aparc2aseg --s demencia --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/6.0/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s \n
#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Sat Aug 20 13:05:29 -03 2022
\n mri_aparc2aseg --s demencia --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /Applications/freesurfer/6.0/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz \n
#-----------------------------------------
#@# APas-to-ASeg Sat Aug 20 13:55:23 -03 2022
\n apas2aseg --i aparc+aseg.mgz --o aseg.mgz \n
#--------------------------------------------
#@# ASeg Stats Sat Aug 20 14:10:53 -03 2022
\n mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /Applications/freesurfer/6.0/ASegStatsLUT.txt --subject demencia \n
#-----------------------------------------
#@# WMParc Sat Aug 20 14:46:35 -03 2022
\n mri_aparc2aseg --s demencia --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz \n
\n mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject demencia --surf-wm-vol --ctab /Applications/freesurfer/6.0/WMParcStatsLUT.txt --etiv \n
#--------------------------------------------
#@# BA_exvivo Labels lh Sat Aug 20 16:36:25 -03 2022
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA1_exvivo.label --trgsubject demencia --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA2_exvivo.label --trgsubject demencia --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA3a_exvivo.label --trgsubject demencia --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA3b_exvivo.label --trgsubject demencia --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA4a_exvivo.label --trgsubject demencia --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA4p_exvivo.label --trgsubject demencia --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA6_exvivo.label --trgsubject demencia --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA44_exvivo.label --trgsubject demencia --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA45_exvivo.label --trgsubject demencia --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.V1_exvivo.label --trgsubject demencia --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.V2_exvivo.label --trgsubject demencia --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.MT_exvivo.label --trgsubject demencia --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject demencia --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject demencia --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject demencia --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface \n
\n mris_label2annot --s demencia --hemi lh --ctab /Applications/freesurfer/6.0/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s demencia --hemi lh --ctab /Applications/freesurfer/6.0/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab demencia lh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab demencia lh white \n
#--------------------------------------------
#@# BA_exvivo Labels rh Sat Aug 20 17:43:18 -03 2022
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA1_exvivo.label --trgsubject demencia --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA2_exvivo.label --trgsubject demencia --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA3a_exvivo.label --trgsubject demencia --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA3b_exvivo.label --trgsubject demencia --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA4a_exvivo.label --trgsubject demencia --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA4p_exvivo.label --trgsubject demencia --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA6_exvivo.label --trgsubject demencia --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA44_exvivo.label --trgsubject demencia --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA45_exvivo.label --trgsubject demencia --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.V1_exvivo.label --trgsubject demencia --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.V2_exvivo.label --trgsubject demencia --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.MT_exvivo.label --trgsubject demencia --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject demencia --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject demencia --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mri_label2label --srcsubject fsaverage --srclabel /Applications/freesurfer/6.0/subjects/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject demencia --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface \n
\n mris_label2annot --s demencia --hemi rh --ctab /Applications/freesurfer/6.0/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose \n
\n mris_label2annot --s demencia --hemi rh --ctab /Applications/freesurfer/6.0/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab demencia rh white \n
\n mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab demencia rh white \n
