#!/bin/bash

hugo && rsync -avP --delete public/ yanlinlin.cn:/var/www/blog/ \
	--exclude ARTS-Weekly/ \
	--exclude ARTS-Weekly-BioMed/
