REFLOWS := $(wildcard *.rf)

test:
	for REFLOW in $(REFLOWS); do \
		echo "--- Checking $$REFLOW for syntax errors ---" ;\
		reflow doc $$REFLOW ; \
	done
