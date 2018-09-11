# gitbook

gitbookでPDFを作成します。  
plantumlも使えます。  

## Quick Start

すぐに試したい場合は、docker-compose.yml と book.json を作成して、実行してみてください。

docker-compose.ymlの例
```
version: '2'

services:
  gitbook:
    image: altus5/gitbook
    volumes:
      - .:/gitbook
      - gitbook_node_modules:/gitbook/node_modules
    ports:
      - 4000:4000

volumes:
  gitbook_node_modules:
    driver: local
```

book.jsonの例（設定詳細はこちら → <https://toolchain.gitbook.com/config.html>）  
```
{
  "language": "ja",
  "plugins": [
    "uml"
  ],
  "pluginsConfig": {
  }
}
```

以下のとおり、実行してください。
```
docker-compose run --rm gitbook pdf
```
初回の実行時に、プラグインのインストールと`gitbook install`が実行されるので、このコマンドだけで大丈夫です。

package.json の スクリプトに、gitbook のコマンドを追加する場合も
docker-composeを使うことができます。  
以下の例は、build と serve は、Windows上のnodeで実行して、pdfの作成だけをdockerを使うという例になっています。  
```
{
  ・・・
  "scripts": {
    "build": "gitbook build",
    "serve": "gitbook serve",
    "pdf": "docker-compose run --rm gitbook pdf"
  },
  ・・・
}
```

## プラグインの追加

book.jsonにプラグインを追加した場合は、`gitbook install`を再実行してください。
```
docker-compose run --rm gitbook install
```
もしも、npmでの追加インストールが必要なものがある場合は、`entrypoint.sh`に必要な処理を加えて、dockerイメージを再buildするか、あるいは、volumesのところに以下のように追加して、コンテナ内のentrypoint.shを置き換えてください。
```
    volumes:
      - entrypoint.sh:/usr/local/bin/entrypoint.sh
```

## デバッグ

いろいろ追加したり、削除したりを繰り返すうちに、行かなくなることがあるので、node_modulesをいったん、全削除してから、やり直したい場合は、_initで削除されます。
```
docker-compose run --rm gitbook _init
```

コンテナに入って試したい場合は、bashを指定してください。
```
docker-compose run --rm gitbook bash
```
あるいは、entrypoint.shを書き換えると良いと思います。

そこまでいくと、Dockerイメージの作り直しをするのも、よいと思います。

