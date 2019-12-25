#!/bin/bash

hugo && rsync -avP --delete public/ yanlinlin.cn:/var/www/blog/
