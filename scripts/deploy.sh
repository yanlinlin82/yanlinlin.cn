#!/bin/bash
set -e # exit when error
Rscript -e 'blogdown::build_site()'
rsync -avP public/ yanlinlin.cn:/var/www/blog/ --delete
