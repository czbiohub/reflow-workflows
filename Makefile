SHELL := /bin/bash

REFLOWS := $(wildcard **/*.rf)

TESTS := $(wildcard **/*_test.rf)

test: test_syntax test_run

test_syntax:
	# Use "reflow doc" to test for syntax errors
	for REFLOW in $(REFLOWS); do \
		echo "--- Checking $$REFLOW for syntax errors ---" ;\
		pushd $$(dirname $$REFLOW) && reflow doc $$(basename $$REFLOW) || exit $$? && popd;\
	done

test_run:
	# Use "reflow run" to test for runtime execution errors
	for TEST in $(TESTS); do \
		echo "--- Running $$TEST ---" ;\
		reflow run $$TEST || exit $$? && popd;\
	done

test_download_sra:
	reflow run download_sra.rf -sra_id='SRR1539523|SRR1539569|SRR1539570' -output=s3://olgabot-maca/test-download-sra/spider-transcriptome/

download_mosquito_blood:
	reflow run download_sra.rf -sra_id=PRJEB23372 -output=s3://tick-genome/download-sra/mosquito_blood_scrnaseq/
