REFLOWS := $(wildcard *.rf)

test:
	for REFLOW in $(REFLOWS); do \
		echo "--- Checking $$REFLOW for syntax errors ---" ;\
		reflow doc $$REFLOW || exit $$? ;\
	done

test_download_sra:
	reflow run download_sra.rf -sra_id='SRR1539523|SRR1539569|SRR1539570' -output=s3://olgabot-maca/test-download-sra/spider-transcriptome/

download_mosquito_blood:
	reflow run download_sra.rf -sra_id=PRJEB23372 -output=s3://tick-genome/download-sra/mosquito_blood_scrnaseq/
 