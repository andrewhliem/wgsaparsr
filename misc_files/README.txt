run1 = failed run; recommend upgrading instance type
run2 (test0003) = completed run using clinvar_subset.txt, 124 variants
run3 (test0004) = run using complete full dataset (MVP v1 chip + MVP AA chip + 1000G)
	- error = ; did not write output file.. deleted output;
				Exception in thread "main" java.io.FileNotFoundException: /WGSA/work_test0004.1/annotation.in.93.gz (No such f
					at java.io.FileInputStream.open(Native Method)
					at java.io.FileInputStream.<init>(FileInputStream.java:146)
					at java.io.FileInputStream.<init>(FileInputStream.java:101)
					at java.io.FileReader.<init>(FileReader.java:58)
					at indel_add_compressed_anno_commandline3.main(indel_add_compressed_anno_commandline3.java:128)
			mv: cannot stat '/WGSA/work_test0004.1/annotation.in.93.gz.addAnno.gz': No such file or directory
			mv: cannot stat '/WGSA/work_test0004.1/annotation.in.94.gz': No such file or directory
	- Exception in thread "main" java.io.EOFException: Unexpected end of ZLIB input stream

run4 (test0005) = MVP AA chip = 856968 Number of indel:10343
	error =didn't print output files --> lets not keep intermediate file?
run5 (test0006) = MVP AA chip = 856968 Number of indel:10343
run6 (test0007) = MVP AA chip head 50; completed and worked
run7 (test0008) = MVP AA chip = 859941 Number of indel:10370 -- with memory set (-m 30 -t 4)
						FAILED
run8 (test0009) = MVP AA chip = 859941 Number of indel:10370 -- with memory set (-m 30 -t 8)
run9 (test0010) = MVP AA chip = 859941 Number of indel:10370 -- with memory set (-m 30 -t 4) and java -Xmx30g
run10 (test0011) = MVP AA chip head 100,000 = -- with memory set (-m 30 -t 4) and java -Xmx30g
run11 (test0012) = MVP AA chip head 1000 = -- with memory set (-m 30 -t 4) and java -Xmx30g
	#UPGRADE to "r4.2xlarge"
run12 (test0013) = MVP AA chip head 859941 Number of indel:10370
run14 (test0015) = MVP AA chip head 859941 Number of indel:10370 WITH conditions: 
	AltaiNeandertal genotypes = NO
run15 (test0016) = MVP AA chip head 859941 Number of indel:10370 WITH LOOPS
	-ended at SNP_AA_chip_v3.tsv_108000.annotated.snp.description.txt (check 'order_of_loop.txt' if want to continue7

	#onward using '-v hg19' setting
run16 (test0017) = MVP AA chip head 859941 Number of indel:10370 WITH '-v hg19' setting
run17 (test0018) = full dataset run WITH '-v hg19' setting 
	-FAILED at *.66
run18 (test0019) = full dataset run WITH '-v hg19' setting, SNV only, 
	- turn off certain elements: Roadmap-15-state_model, Roadmap-25-state_model, Roadmap_peak_calls, 
								GenoSkyline-Plus, Roadmap_sample_ids, RegulomeDB



		#FUTURE RUN; PENDING
run18 (test0019) = MVP AA chip INDELS only: 10370
	--> based on '/WGSA/aliem_scratch/run16_test0017/work_test0017/SNP_AA_chip_v3.tsv.indel.gz'
	--> turned off 'CADD'
