# My Personal Website

Here is the source code of my personal website.

## How to update

1. Download from github:

    ```
    git clone https://github.com/yanlinlin82/yanlinlin.cn
    ```

2. Build website:

    ```
    cd yanlinlin.cn
    git submodule update --init
    Rscript -e 'blogdown::build_site()'
    ```
