egrep -A1 -w 'Fri|Sat|Sun' output_test0017.txt > AA_chip_run_times_raw.txt
egrep -w 'Fri|Sat|Sun' output_test0017.txt > AA_chip_run_times_raw.txt #to just get times

#to only get next line 
awk '/Fri|Sat|Sun/{getline; print}' output_test0017.txt > AA_chip_run_times_only_raw.txt

###############################

egrep -w 'Thu|Fri|Sat|Sun' output_test0003.txt > clinvarsubset_run_times_only_raw.txt
egrep -A1 -w 'Thu|Fri|Sat|Sun' output_test0003.txt | less -NS

egrep -w 'Mon|Tue|Wed|Thu|Fri|Sat|Sun' output_test0018.txt > full_run_times_only_raw.txt
egrep -A1 -w 'Mon|Tue|Wed|Thu|Fri|Sat|Sun' output_test0018.txt | less -NS

