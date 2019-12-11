# My Personal Website

Here is the source code of my personal website.

## How to update

1. Download from github:

    ```sh
    git clone https://github.com/yanlinlin82/yanlinlin.cn
    ```

2. Build website:

    ```sh
    cd yanlinlin.cn
    git submodule update --init
    Rscript -e 'blogdown::build_site()'
    ```

3. Deploy website:

    ```sh
    rsync -avP public/ yanlinlin.cn:/var/www/blog/ --delete
    ```
