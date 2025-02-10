# create PTM searching library

# citrullination
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n citrullination -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Citrullination,0.984016,R"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_citrullination_report-lib

# hypusine
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n hypusine -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Hypusine,87.068414,K --var-mod Deoxyhypusine,71.073499,K"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_hypusine_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Hypusine,87.068414,K --var-mod Deoxyhypusine,71.073499,K"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_hypusine_report-lib


#Deoxyhypusine
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n deoxyhypusine -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Deoxyhypusine,71.073499,K"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_deoxyhypusine_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod Deoxyhypusine,71.073499,K"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_deoxyhypusine_report-lib

#diann37
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann37 -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod UniMod:37,42.046950,KR"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann37_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod UniMod:37,42.046950,KR"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann37_report-lib

#diann36dimethyl
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann36dimethyl -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod UniMod:36,28.031300,KR"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann36dimethyl_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod UniMod:36,28.031300,KR"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann36dimethyl_report-lib

# diann1acetyl
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann1acetyl -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod UniMod:1,42.010565,K"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann1acetyl_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --relaxed-prot-inf --rt-profiling --var-mod UniMod:1,42.010565,K"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann1acetyl_report-lib

# diann21phosph S
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 300 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann21phosph_S -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:21,79.966331,S"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 300 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann21phosph_S_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:21,79.966331,S"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann21phosph_S_report-lib

# diann21phosph T
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann21phosph_T -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:21,79.966331,T"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann21phosph_T_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:21,79.966331,T"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann21phosph_T_report-lib

# diann21phosph Y
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann21phosph_Y -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:21,79.966331,Y"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann21phosph_Y_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:21,79.966331,Y"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann21phosph_Y_report-lib

#diann121KGG
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100  -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann121KGG -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:121,114.042927,K --no-cut-after-mod UniMod:121"

diann/create_job.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann121KGG_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:121,114.042927,K --no-cut-after-mod UniMod:121"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann121KGG_report-lib

#diann213PARyl
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann213PARyl -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:213,541.061110,R"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann213PARyl_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:213,541.061110,R"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann213PARyl_report-lib

#diann47palmityl
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann47palmityl -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:47,238.229666,C"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann47palmityl_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:47,238.229666,C"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann47palmityl_report-lib

#diann354nitro
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann354nitro -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:354,44.985078,T"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann354nitro_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:354,44.985078,T"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann354nitro_report-lib

#diann275Snitosyl
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann275Snitosyl -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:275,28.990164,C"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann275Snitosyl_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:275,28.990164,C"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann275Snitosyl_report-lib

#diann7cit
diann/create_spec_lib.sh  -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG.fasta -n diann7cit -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:7,0.984016,R"

diann/create_job.sh -r /rsrch5/scratch/ccp/hanash/Hanash_GPFS/Chunhui -m 100 -f DIANN_Testing/data/RAINBOW -l DIANN_Testing/library/UNIPROT_human_revi_2024_12_19_ProteinAG_diann7cit_report-lib.predicted.speclib -p "--min-fr-mz 200 --max-fr-mz 2000 --min-pep-len 7 --max-pep-len 52 --min-pr-mz 200 --max-pr-mz 2000 --min-pr-charge 2 --max-pr-charge 6 --cut K*,R* --missed-cleavages 2 --unimod4 --var-mods 5 --var-mod UniMod:35,15.994915,M --mass-acc 10 --mass-acc-ms1 15 --reanalyse --relaxed-prot-inf --rt-profiling --var-mod UniMod:7,0.984016,R"

diann/run_batch.sh diann/tasks/RAINBOW_UNIPROT_human_revi_2024_12_19_ProteinAG_diann7cit_report-lib