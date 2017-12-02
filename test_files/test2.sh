#!/bin/sh

for zip in *.zip;do
	unzip $zip
	cd ${zip%%.*}
	make
	mkdir ans
	./parser ../decl.p
done
