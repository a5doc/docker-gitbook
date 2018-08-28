#!/bin/bash
set -e
trap 'echo "エラーが発生しました。" 1>&2' ERR

cmd=${1:-help}

cd /gitbook

export PATH=$(npm bin):$PATH

_init() {
  if [ ! -e node_modules/.a5tmp ]; then
    echo '初回のため gitbook install を実行してプラグインの準備します...'
    # gitbookの3.2.2の未解決のバグで、エラーになることがある
    # エラーになった場合は、コメントアウトを外して、sedで修正する
    # Fixes https://github.com/GitbookIO/gitbook/issues/1309
    # sed -i 's/confirm: true/confirm: false/g' \
    #   /root/.gitbook/versions/3.2.2/lib/output/website/copyPluginAssets.js

    # npm install -g gitbook-plugin-uml だとエラーになるので、この位置でinstallする
    npm install gitbook-plugin-uml

    gitbook install
    touch node_modules/.a5tmp
    echo 'コンテナ内での gitbook の準備が整いました'
    echo 'book.jsonを変更した場合は、gitbook install を実行してください'
  fi
}

case "$cmd" in
  '_init')
    rm -f node_modules/.a5tmp
    rm -rf node_modules/*
    _init
    ;;
  'bash')
    exec "$@"
    ;;
  *)
    _init
    echo 'gitbook' "$@"
    gitbook "$@"
    ;;
esac
