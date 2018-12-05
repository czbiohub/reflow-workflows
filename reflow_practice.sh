#stating instance
aegea launch --iam-role S3fromEC2 --ami-tags Name=czbiohub-specops -t m5.4xlarge --duration-hours 2 kalani-40

aegea ssh ubuntu@kalani-40 -i ~/.ssh/aegea.launch.kalani.ratnasiri.ratnasirik-mba.pem

#in CMS_12F file is elephant.fasta
scp -i /Users/kalani.ratnasiri/.ssh/aegea.launch.kalani.ratnasiri.ratnasirik-mba.pem ~/Desktop/CMS_12F/elephant.fasta ubuntu@ec2-34-222-229-117.us-west-2.compute.amazonaws.com:/mnt/data/reference

#bowtie container
https://quay.io/repository/biocontainers/bowtie2

#build in index
bowtie2-build /mnt/data/references/elephant.fasta elephant

#samples here
# https://s3.console.aws.amazon.com/s3/buckets/czb-seqbot/fastqs/181022_NB501961_0176_AH532CAFXY/?region=us-east-1&tab=overview#

touch /mnt/data/output/elephant_bowtie2.log

mkdir reference index reads output

#while in reads
aws s3 cp --recursive --exclude "*" --include "Exp_12F_A08" s3://czb-seqbot/fastqs/181022_NB501961_0176_AH532CAFXY/ .
aws s3 cp --recursive --exclude "*" --include "Exp_12F_C01" s3://czb-seqbot/fastqs/181022_NB501961_0176_AH532CAFXY/ .
aws s3 cp --recursive --exclude "*" --include "Exp_12F_C02" s3://czb-seqbot/fastqs/181022_NB501961_0176_AH532CAFXY/ .
gunzip *.gz


PriceSeqFilter -f Exp_12F_A08_S8_R1_001.fastq -o Exp_12F_A08_S8_R1_001_PF.fastq -a 12 -rnf 90 -log c -rqf 85 0.98
PriceSeqFilter -f Exp_12F_A08_S8_R2_001.fastq -o Exp_12F_A08_S8_R2_001_PF.fastq -a 12 -rnf 90 -log c -rqf 85 0.98
PriceSeqFilter -f Exp_12F_C01_S17_R1_001.fastq -o Exp_12F_C01_S17_R1_001_PF.fastq -a 12 -rnf 90 -log c -rqf 85 0.98
PriceSeqFilter -f Exp_12F_C01_S17_R2_001.fastq -o Exp_12F_C01_S17_R2_001.fastq -a 12 -rnf 90 -log c -rqf 85 0.98
PriceSeqFilter -f Exp_12F_C02_S18_R1_001.fastq -o Exp_12F_C02_S18_R1_001_PF.fastq -a 12 -rnf 90 -log c -rqf 85 0.98
PriceSeqFilter -f Exp_12F_C02_S18_R2_001.fastq -o Exp_12F_C02_S18_R2_001_PF.fastq -a 12 -rnf 90 -log c -rqf 85 0.98


bowtie2 -p12 -x elephant -q -1 Exp_12F_A08_S8_R1_001_PF.fastq -2 Exp_12F_A08_S8_R2_001_PF.fastq --very-sensitive-local -S /mnt/data/output/Exp_12F_A08.sam --no-unal --al-conc /mnt/data/output/Exp_12F_A08_conc.fq 2>> /mnt/data/output/elephant_bowtie2.log
bowtie2 -p12 -x elephant -q -1 Exp_12F_C01_S17_R1_001_PF.fastq -2 Exp_12F_C01_S17_R2_001_PF.fastq --very-sensitive-local -S /mnt/data/output/Exp_12F_C01.sam --no-unal --al-conc /mnt/data/output/Exp_12F_C01_conc.fq 2>> /mnt/data/output/elephant_bowtie2.log
bowtie2 -p12 -x elephant -q -1 Exp_12F_C02_S18_R1_001_PF.fastq -2 Exp_12F_C02_S18_R2_001_PF.fastq --very-sensitive-local -S /mnt/data/output/Exp_12F_C02.sam --no-unal --al-conc /mnt/data/output/Exp_12F_C02_conc.fq 2>> /mnt/data/output/elephant_bowtie2.log
