Created: 2019-05-31
Author: Andrew H. Liem, MS
Purpose: General coding spacing for running wgsa v.76 with 1000G and MVP snp chip information


#Understanding wgsa - background information
	#setting up wgsa instructions: https://sites.google.com/site/jpopgen/wgsa/setting-up-wgsa-linux
#./WGSA/work = for storing intermediate files
#./WGSA/tmp = for annotating indels with VEP
	#the annotator components
#./WGSA/annovar20180416 = the ANNOVAR file
#./WGSA/annovar20180416 = the snpeff file
#./WGSA/annovar20180416 = the VEP file

#Understanding my AWS EC2: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html#access-ec2
	#commands to run understand your instance: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html#instancedata-dynamic-data-retrieval
df -h #get diskspace
		# Filesystem      Size  Used Avail Use% Mounted on
		# /dev/hda1       9.8G  1.6G  7.7G  17% /
		# devtmpfs        7.5G  8.0K  7.5G   1% /dev
		# tmpfs           7.5G     0  7.5G   0% /dev/shm
		# tmpfs           7.5G   18M  7.5G   1% /run
		# tmpfs           7.5G     0  7.5G   0% /sys/fs/cgroup
		# /dev/xvdf       2.4T  1.9T  466G  81% /WGSA
lsblk #list block devices
		# NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
		# hda      3:0    0   10G  0 disk
		# `-hda1   3:1    0   10G  0 part /
		# xvdf   202:80   0  2.4T  0 disk /WGSA

curl http://169.254.169.254/latest/dynamic/instance-identity/document #get metadata of instance
		  # "accountId" : "713692290723",
		  # "availabilityZone" : "us-east-1b",
		  # "kernelId" : null,
		  # "ramdiskId" : null,
		  # "pendingTime" : "2019-05-22T11:56:48Z",
		  # "architecture" : "x86_64",
		  # "privateIp" : "10.0.0.139",
		  # "version" : "2017-09-30",
		  # "devpayProductCodes" : null,
		  # "marketplaceProductCodes" : null,
		  # "region" : "us-east-1",
		  # "imageId" : "ami-0b777b0e7ab1372dc",
		  # "billingProducts" : [ "bp-6ca54005" ],
		  # "instanceId" : "i-013ab18145241020c",
		  # "instanceType" : "r4.large" #vCPU, 15.25 Mem, 2.3 GHz Intel Xeon E5-2686 v4 Processor
		  
#using the upgraded specifications; 
	  # "devpayProductCodes" : null,
	  # "marketplaceProductCodes" : null,
	  # "accountId" : "713692290723",
	  # "availabilityZone" : "us-east-1b",
	  # "ramdiskId" : null,
	  # "kernelId" : null,
	  # "pendingTime" : "2019-06-06T19:05:05Z",
	  # "architecture" : "x86_64",
	  # "privateIp" : "10.0.0.141",
	  # "version" : "2017-09-30",
	  # "region" : "us-east-1",
	  # "imageId" : "ami-0ed7ba938f1dbc89f",
	  # "billingProducts" : [ "bp-6ca54005" ],
	  # "instanceId" : "i-02d34c7ef68636490",
	  # "instanceType" : "r4.xlarge"


curl http://169.254.169.254/latest/meta-data/instance-type #prints out all categories of instance metdata within running instance; table in above link explaining
curl http://169.254.169.254/latest/meta-data/instance-id
	#i-013ab18145241020c

#additional profiling
less -NS /proc/cpuinfo
	#4 processors with 2 cores each = 8 cores; 
	#upgraded 2019-06-17: 8 processor, 4 cores each
		#
less -NS /proc/meminfo
      # 1 MemTotal:       29363716 kB
      # 2 MemFree:        12041328 kB
      # 3 MemAvailable:   28884796 kB
      # 4 Buffers:          165384 kB
      # 5 Cached:         16819252 kB
      # 6 SwapCached:            0 kB
      # 7 Active:          2745016 kB
      # 8 Inactive:       14335744 kB
      # 9 Active(anon):      96492 kB
     # 10 Inactive(anon):    17860 kB
     # 11 Active(file):    2648524 kB
     # 12 Inactive(file): 14317884 kB
     # 13 Unevictable:          80 kB
     # 14 Mlocked:              80 kB
     # 15 SwapTotal:             0 kB
     # 16 SwapFree:              0 kB
     # 17 Dirty:                48 kB
     # 18 Writeback:             0 kB
     # 19 AnonPages:         96008 kB
     # 20 Mapped:            15288 kB
     # 21 Shmem:             18224 kB
     # 22 Slab:             108840 kB
     # 23 SReclaimable:      91988 kB
     # 24 SUnreclaim:        16852 kB
     # 25 KernelStack:         944 kB
     # 26 PageTables:         2536 kB
     # 27 NFS_Unstable:          0 kB
     # 28 Bounce:                0 kB
     # 29 WritebackTmp:          0 kB
     # 30 CommitLimit:    14681856 kB
     # 31 Committed_AS:     134532 kB
     # 32 VmallocTotal:   34359738367 kB
     # 33 VmallocUsed:       61900 kB
     # 34 VmallocChunk:   34359671035 kB
     # 35 HardwareCorrupted:     0 kB
     # 36 AnonHugePages:         0 kB
     # 37 HugePages_Total:       0
     # 38 HugePages_Free:        0
     # 39 HugePages_Rsvd:        0
     # 40 HugePages_Surp:        0
     # 41 Hugepagesize:       2048 kB
     # 42 DirectMap4k:       90112 kB
     # 43 DirectMap2M:     5677056 kB
     # 44 DirectMap1G:    26214400 kB

#----- Running wgsa on VA AWS -------------------------------------------
	#https://sites.google.com/site/jpopgen/wgsa/using-wgsa-via-aws
	#Step 1: Prepare and validate input files
	#Step 2: Update config text file
	#Step 3: Run WGSA main program
	

#Step 1: using toy dataset clinvar_subset.txt	
#input file = text format with TAB-delimited columns; first 4 columns = chr, pos, ref.all, alt.all; vcf format works too
	#EG.
			#chr    pos     ref     alt     clinvar_rs      CLNSIG  CLNDBN
			#1       955597  G       T       rs115173026     3       not_specified
			#1       957640  C       T       rs6657048       3       not_specified
			#1       976629  C       T       rs113789806     2       not_specified
			#1       976963  A       G       rs150359724     3       not_specified

#Step 2: Update config text file = using toy example




#Step 3:
	#Run WGSA main progress (i.e. WGSA076.class) following config file name (i.e. test0001-hg38-WGSA076.EC2.setting)
	#Run shell script created from above (e.g. 	bash test1000g-hg38-WGSA08.EC2.setting.sh)

#java WGSA08 [setting_file] 
		# <-m maximum_number_of_GB_memory_to_use> 
		# <-t maximum_number_of_threads_to_use> 
		# <-v hg19_or_hg38> <-i vcf_or_tsv>


					# mkdir tmp_test0002
					# mkdir work_test0002
					# java -Xmx10g WGSA076 test0002-hg38-WGSA076.EC2.setting -i tsv -v hg38 -m 30 -t 4
					# java -Xmx10g WGSA076 test0001-hg38-WGSA076.EC2.setting -v hg38 -m 30 -t 4
# -Xmxn
             # Specifies the maximum size, in bytes, of the memory allocation pool. This value must a multiple
             # of 1024 greater than 2 MB. Append the letter k or K to indicate kilobytes, or m or M to indicate
             # megabytes. The default value is chosen at runtime based on system configuration.
             # For server deployments, -Xms and -Xmx are often set to the same value. See Garbage Collector
             # Ergonomics at http://docs.oracle.com/javase/7/docs/technotes/guides/vm/gc-ergonomics.html
             # Examples:
             # -Xmx83886080
             # -Xmx81920k
             # -Xmx80m
             # On Solaris 7 and Solaris 8 SPARC platforms, the upper limit for this value is approximately 4000
             # m minus overhead amounts. On Solaris 2.6 and x86 platforms, the upper limit is approximately
             # 2000 m minus overhead amounts. On Linux platforms, the upper limit is approximately 2000 m minus
             # overhead amounts.
			 
mkdir tmp_test0003
mkdir work_test0003
java -Xmx10g WGSA076 test0003-hg38-WGSA076.EC2.setting -i tsv -v hg38 -m 30 -t 4
java -Xmx30g WGSA076 test0003-hg38-WGSA076.EC2.setting -v hg38 -m 15 -t 2
java -Xmx10g WGSA076 test0003-hg38-WGSA076.EC2.setting -v hg38 -m 30 -t 4
java -Xmx10g WGSA076 test0003-hg38-WGSA076.EC2.setting -v hg38

	#output: 
			# Notice: Licenses are needed for commercial usage of software ANNOVAR and resources CADD, GenoCanyon, GenoSkyline-Plus, LINSIGHT, Polyphen2, REVEL and VEST4 (in dbNSFP).
			# Notice: WGSA pipeline is provided AS IS. No warranties.
			# Type "Understand" to proceed; "Exit" to exit
			# Understand
			# Preparing input files ...
			# Number of SNV:106 Number of indel:18
			# Pipeline written to test0002-hg38-WGSA076.EC2.setting.sh

			#nohup bash test0002-hg38-WGSA076.EC2.setting.sh >output_test0002.txt 2>error_test0002.txt &

nohup bash test0003-hg38-WGSA076.EC2.setting.sh >output_test0003.txt 2>error_test0003.txt &
	#Initiated = Tue Jun  4 11:10:34 UTC 2019


# Run real/complete dataset
dos2unix DATA_1000G_cv1_cv2_SNPs.tsv
nohup bash aliem_scratch/scripts/memory_check_space.sh > aliem_scratch/scripts/memory_check_space.log &
mkdir tmp_test0004.1
mkdir work_test0004.1

mkdir tmp_test0004.2
mkdir work_test0004.2

mkdir tmp_test0005
mkdir work_test0005

#since the files are too big, we split it in half
java -Xmx10g WGSA076 test0005-hg38-WGSA076.EC2.setting -v hg38
nohup bash test0005-hg38-WGSA076.EC2.setting.sh >output_test0005.txt 2>error_test0005.txt &
#PID = 18220

java -Xmx10g WGSA076 test0004-hg38-WGSA076.EC2.setting.1 -v hg38
nohup bash test0004-hg38-WGSA076.EC2.setting.1.sh >output_test0004.1.txt 2>error_test0004.1.txt &

java -Xmx10g WGSA076 test0004-hg38-WGSA076.EC2.setting.2 -v hg38
nohup bash test0004-hg38-WGSA076.EC2.setting.2.sh >output_test0004.2.txt 2>error_test0004.2.txt &

java -Xmx10g WGSA076 test0008-hg38-WGSA076.EC2.setting -v hg38 -m 30 -t 4
nohup bash test0008-hg38-WGSA076.EC2.setting.sh >output_test0008.txt 2>error_test0008.txt &

java -Xmx10g WGSA076 test0009-hg38-WGSA076.EC2.setting -v hg38 -m 30 -t 8
nohup bash test0009-hg38-WGSA076.EC2.setting.sh >output_test0009.txt 2>error_test0009.txt &

java -Xmx30g WGSA076 test0010-hg38-WGSA076.EC2.setting -v hg38 -m 30 -t 4
nohup bash test0010-hg38-WGSA076.EC2.setting.sh >output_test0010.txt 2>error_test0010.txt &

mkdir tmp_test0011
mkdir work_test0011
java -Xmx30g WGSA076 test0011-hg38-WGSA076.EC2.setting -v hg38 -m 30 -t 4
nohup bash test0011-hg38-WGSA076.EC2.setting.sh >output_test0011.txt 2>error_test0011.txt &


mkdir tmp_test0012
mkdir work_test0012
java -Xmx30g WGSA076 test0012-hg38-WGSA076.EC2.setting -v hg38 -m 30 -t 4
nohup bash test0012-hg38-WGSA076.EC2.setting.sh >output_test0012.txt 2>error_test0012.txt &

#running now with 32 cores from "r4.2xlarge"
mkdir tmp_test0014
mkdir work_test0014
java -Xmx30g WGSA076 test0014-hg38-WGSA076.EC2.setting -v hg38
nohup bash test0014-hg38-WGSA076.EC2.setting.sh >output_test0014.txt 2>error_test0014.txt &

mkdir tmp_test0015
mkdir work_test0015
java -Xmx30g WGSA076 test0015-hg38-WGSA076.EC2.setting -v hg38
nohup bash test0015-hg38-WGSA076.EC2.setting.sh >output_test0015.txt 2>error_test0015.txt &

#for run15_test0016 -- see folder; it was a bit differently using a loop


mkdir tmp_test0017
mkdir work_test0017
java -Xmx60g WGSA076 test0017-hg38-WGSA076.EC2.setting -v hg19
nohup bash test0017-hg38-WGSA076.EC2.setting.sh >output_test0017.txt 2>error_test0017.txt &

mkdir tmp_test0018
mkdir work_test0018
java -Xmx60g WGSA076 test0018-hg38-WGSA076.EC2.setting -v hg19
nohup bash test0018-hg38-WGSA076.EC2.setting.sh >output_test0018.txt 2>error_test0018.txt &

mkdir tmp_test0019
mkdir work_test0019
java -Xmx30g WGSA076 test0019-hg38-WGSA076.EC2.setting -v hg19
nohup bash test0019-hg38-WGSA076.EC2.setting.sh >output_test0019.txt 2>error_test0019.txt &

#for run18_test0019 --> indels only; need to filter out where chr = NA
		# https://www.tim-dennis.com/data/tech/2016/08/09/using-awk-filter-rows.html
		# awk "{print NF}" < SNP_AA_chip_indels_only.txt | uniq
		# awk '/NA/' SNP_AA_chip_indels_only.txt | wc -l #get count of how many chr = NA = 536
		# awk '{ if($1 <=22) {print}}' SNP_AA_chip_indels_only.txt> SNP_AA_chip_indels_only_v2.txt #keep chr <= 22



##################################################################################################################################################
#2019-06-17: Chunking data by 1000 lines
	#annotation only work up to 1k lines; 

#template: 
		# for item in [LIST]
		# do
		  # [COMMANDS]
		# done

	###############################################################################
	###############################################################################
		###### TESTING ENVIRONMENT
		###### TESTING ENVIRONMENT
		###### TESTING ENVIRONMENT
		###### TESTING ENVIRONMENT
		###### TESTING ENVIRONMENT
	###############################################################################
	###############################################################################

		
#Step 1: split large files into # of smaller files: 
	#using awk: https://stackoverflow.com/questions/14973815/how-to-split-a-file-using-a-numeric-suffix
awk 'NR%1000==1 { file = FILENAME "_" sprintf("%04d", NR+999) } { print > file }' SNP_AA_chip_v3.tsv

#Step 2: create output directories
	#create the work and tmp directories

#for i in /WGSA/test2/data/*; do
for i in /WGSA/test/data/*; do
	mkdir /WGSA/test/intermediate_directory/"work_$("basename" "$i")"
	mkdir /WGSA/test/intermediate_directory/"tmp_$("basename" "$i")"
done


#Step 3: (FOR TESTING) create small/test files for loop @ /WGSA/test2/data
FILES=/WGSA/test2/data/* #used files = 1k rows which is now defunct
for i in $FILES
do 
	head -10 $i > "small_$(basename $i)"
done


#Step 4: Running script (need to pass arguements into the java script)
	#part 1: creating all the .sh files --> I need to set unique input files from loop output

	#create the setting file
#FILES=/WGSA/test2/data/*
FILES=/WGSA/test/data/*
for file in $FILES
	do
awk -v var="$(basename $file)" '{gsub("input_file_unique111", var, $0)}1' < /WGSA/test/template-hg38-WGSA076.EC2.setting | awk -v var="tmp_$(basename $file)" '{gsub("input_file_unique222", var, $0)}1' | awk -v var="work_$(basename $file)" '{gsub("input_file_unique333", var, $0)}1' > /WGSA/test/01_pre_setting_files/"$(basename $file)"_hg38-WGSA076.EC2.setting
done

#create the .sh file  
	#go to HOME directory, cp all *.setting files and data files and execute in /WGSA/
#files=/WGSA/test2/intermediate_directory0/*
files=/WGSA/test/01_pre_setting_files/*
for file in $files; do
	#echo $i
	awk -v var="$(basename $file)" '{gsub("input_file_unique111", var, $0)}1' < /WGSA/aliem_scratch/scripts/chunking_java_files.sh >> /WGSA/test/02_setting_files/chunking_java_files_tmp.sh
	#cat /WGSA/aliem_scratch/tmp/chunking_java_files_tmp.sh 
	#rm /wgsa/tmp/chunking_java_files_tmp.sh
done


cat /WGSA/test/02_setting_files/chunking_java_files_tmp.sh #to confirm its present

#@ /WGSA/
#run the .sh file
cp /WGSA/test/01_pre_setting_files/* /WGSA/.
cp /WGSA/test/02_setting_files/chunking_java_files_tmp.sh /WGSA/.
cp /WGSA/test/data/* /WGSA/.

nohup bash chunking_java_files_tmp.sh >output_chunking_java_files_tmp.log 2>error_chunking_java_files_tmp.errorlog & 
mv /WGSA/SNP_AA_chip_v3.tsv_*_hg38-WGSA076.EC2.setting.sh /WGSA/test/03_sh_files/
rm SNP_AA_chip_v3.tsv_*.annotated.*.description.txt #remove SNP and indel information file
rm SNP_AA_chip_v3.tsv_*_hg38-WGSA076.EC2.setting #remove SNP and indel information file
#create file of list
ls /WGSA/SNP_AA_chip_v3.tsv_*_hg38-WGSA076.EC2.setting.sh | sed 's+/WGSA/++g' > /WGSA/test/03_sh_files/sh_java_files.sh
	#cat -A /WGSA/test/03_sh_files/sh_java_files.sh #QC check


#run in loop each sh script produced from setting
mapfile</WGSA/test/03_sh_files/sh_java_files.sh
cp /WGSA/test/03_sh_files/SNP_AA_chip_v3.tsv_*_hg38-WGSA076.EC2.setting.sh /WGSA/.
echo "${MAPFILE[@]}" #to check it works
nohup echo "${MAPFILE[@]}" | xargs -I '{}' bash {} > sh_java_files.log 2> sh_java_files.errorlog &
	#for improvement, can print NAME OF THE .SH file prior running: 


#rm SNP_AA_chip_v3.tsv_*
#rm SNP_AA_chip_v3.tsv_*











