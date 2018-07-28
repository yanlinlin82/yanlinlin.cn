# My Personal Blog

Here is the source code of my personal blog.

## How to update

1. Download from github:

    git clone https://github.com/yanlinlin82/myblog.git

2. Build website:

    cd myblog
    git submodule update --init
    Rscript -e 'blogdown::build_site()'
