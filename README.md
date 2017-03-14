
## WebAssemblyとは 

<img src="https://raw.githubusercontent.com/umamichi/web-assembly/master/images/wasm.png" width="500">

ブラウザからアセンブリ（機械語）を実行できるようにする技術であり、高速化手段、あるいはJavaScriptの処理系にできないことをするといった目的で提案された

2015年6月、Mozilla、Google、Microsoft、Appleが標準フォーマットとして開発に合意した

## WebAssemblyが生まれた経緯

### JavaScriptに実行速度が求められる時代になった

### なぜJavaScriptは遅いか？

+ インタプリタ言語である
+ 動的型付け言語である
→ 解析に時間がかかってしまう  

よって、コンパイラ言語と比べると遅い😭

当初、JavascriptはHTMLに飾り付けをする程度だったが、最近では
 + 複雑なアニメーション
 + WebGLなどのグラフィック処理
 + 計算速度の遅いモバイル端末

にも用途が広がり、実行速度が求められるようになってきた


### 高速化するため、asm.jsが生まれた

2013年頃、**asm.js** が生まれた
asm.jsとは、JavaScriptを高速実行するために開発されたサブセット
※サブセットとは、全体に対する一部分のこと。本来の規格（JavaScript）に関する限定部分、あるいはソフトウエアの機能を限定して使えるようにしたもの

asm.jsとは、JavaScriptをある制約に従って書くことで、
**型を明確にして事前コンパイルできるようにする**技術です


👍 asm.jsの良いところ
+ 実行速度が速くなる
+ C/C++からJavaScriptへコンパイル可
+ ゲームエンジンによるサポート(Unreal Engine, Unity)

👎 asm.jsの悪いところ
+ ファイルサイズが増大&通信量増加
+ ファイルサイズの増大によるパージング(構文解析)の時間増加 
+ Web API 呼び出しが得意ではない(外部からfunctionを渡す必要がある)


### asm.jsの代替案として、Web Assemblyが生まれた

**バイナリコード**をブラウザが扱えるようになることで、
JavaScriptに比べてファイルサイズを大幅に小さくすることができ、これらの問題を解決しようというもの

<img src="https://raw.githubusercontent.com/umamichi/web-assembly/master/images/asm-js-to-wasm.png" width="500">  

※バイナリコード・・・コンピューターに処理を依頼する命令を、CPUが理解できるように2進数で表したコードのこと


## WebAssemblyのすごいところ✨

+ バイナリコードにコンパイルされるから実行速度が速い (実行速度はasm.jsと同等)  
+ asm.jsに比べてファイルサイズが小さくなり、ロード時間が短くなる
+ GC（ガベージコレクション）, DOM, Web API操作が可能
+ 対応言語はC/C++, Rust（Mozillaによって開発されている）など

## WebAssemblyの悪いところ👼

+ どの言語で書こうが事前コンパイルが必須
  （下記で書きましたが、現時点でコンパイルがめちゃめちゃめんどくさい）
  
+ DOMを操作する必要があり、DOMからは解放されない


## Can I use Web Assembly?

Chrome、Firefoxを中心にこれから開発が進んでいく模様  
<img src="https://raw.githubusercontent.com/umamichi/web-assembly/master/images/caniuse.png?raw=true" width="100%">


## wasmバイナリへコンパイルの流れ

人間がwasmのバイナリを書くのは無理なので、
何かしらの方法でソースコードから生成する必要があります。
現状では前述のasm.jsと同様、オープンソースのコンパイラ基盤 LLVM を使います。

<img>

LLVMは、フロントエンドとバックエンドにコンパイラが分かれており、
内部で中間表現(LLVM IR)に変換することで、指定の形式にコンパイルすることができます。

## C言語をWebAssembly対応ブラウザで動かしてみる


以下のようなC言語の関数ををブラウザから呼び出し、実行してみます

▼sample.c
```c
int c=0;
int count(){return c++;}
```


### 1. Chrome Canaryをインストール

Chrome Canaryとは・・・開発者向けブラウザ。開発段階の最新機能を備えている  

https://www.google.co.jp/chrome/browser/canary.html

### 2. Chrome Canary起動、URLから「<a href="chrome://flags/#enable-webassembly">chrome://flags/#enable-webassembly</a>」を開く


### 3. WebAssemblyを有効にし、Canary再起動する


### 4. https://umamichi.github.io/wasm/ にアクセスし、デペロッパーツールを開き、画面上のボタンをクリックする

```::index.html
<html>
<head>
  <meta charset="utf-8" />
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>WebAssembly</title>
</head>
<body>
  <input type="button" id="countup" value="CountUp?" />
  <script>
  fetch('sample.wasm')
  .then(response => response.arrayBuffer())
  .then(buffer => WebAssembly.compile(buffer))
  .then(module => {
    const instance = new WebAssembly.Instance(module);
    document.getElementById('countup').addEventListener('click', () => {
      // C言語で定義されたcountを呼び出すことが可能
      this.value = instance.exports.count();
      console.log(this.value);
    }, false);
  });
  </script>
</body>
</html>
```

**⚠️ 現段階では、wasmファイルをjavascriptで読み込むコードが必要**


### 5. UnityでつくられたゲームをWebAssemblyで動かす

<a href="https://webassembly.github.io/demo/AngryBots/" target="_blank">https://webassembly.github.io/demo/AngryBots/</a>
<!-- <img src="https://raw.githubusercontent.com/umamichi/web-assembly/master/images/game.gif" width="500"> -->



## C言語をWebAssembly用にバイナリコードにコンパイルしてみる

**注意）3〜4時間かかります**

```
環境　･･･　MacOS Yosemite 10.10.5
必要な空き容量　･･･　18GB
必要な時間　･･･ 3〜4時間ほど
```

### 1.LLVM+clang のインストール

① LLVM をダウンロードする
LLVM とは、コンパイル時、リンク時、実行時などあらゆる時点でプログラムを最適化するよう設計された、**コンパイラ基盤**である。

```
$ mkdir web-assembly  // 任意の場所に作業ディレクトリを作る
$ cd web-assembly
$ git clone http://llvm.org/git/llvm.git
```


② clang（クラン）をダウンロードする
clangとは、プログラミング言語 C、C++、Objective-C、Objective-C++ 向けのコンパイラフロントエンドである。 バックエンドとして LLVM を使用している。

```
$ cd llvm/tools
$ git clone http://llvm.org/git/clang.git
```

③ cmakeを使えるようにしておく
cmakeとはCMakeはコンパイラに依存しないビルド自動化のためのフリーソフトウェアである

```
$ brew update
$ brew install cmake
```

④ LLVMとclangをインストールする

```
$ cd ../../   // ルートに戻る
$ mkdir llvm_build
$ cd llvm_build
$ cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=/usr/local -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly ../llvm 
$ make -j 8
// 70分ほどかかります...🍺🍺🍺🍺🍺🍺🍺
$ sudo make install
```

インストールに成功すると、今回利用するclangやllcが使えるようになります。

### 2. binaryenのインストール

binaryenとは、Mozilla社が開発した、WebAssemblyのツールチェインのためのプロジェクト。
WebAssemblyモジュールをロードできる「Binaryen shell」や「asm.js」技術を使って実装されたコードをWebAssemblyにコンパイルする「asm2wasm」、その逆の処理を行う「wasm2asm」、LLVMで開発されているWebAssemblyバックエンドが出力する「.s」形式コードをWebAssemblyにコンパイルする「s2wasm」、BinaryenのJaVaScriptポートである「wasm.js」などを含んでいる。


```
$ cd .. // ルートに戻る
$ git clone https://github.com/WebAssembly/binaryen.git
$ cd binaryen
$ cmake . && make
$ sudo make install
```

インストールに成功すると、binaryen-shell、wasm-as、wasm-dis、asm2wasm、wasm2asm、s2wasm、wasm.jsなどのコマンドが使えるようになります。

### 3. wabtのインストール

wabtとは・・・

```
cd ..
$ git clone --recursive https://github.com/WebAssembly/wabt
$ cd wabt
$ make clang-debug-no-tests
```

※ READMEには ```$ make``` と書いてありますが、```vector not found```というエラーが出たので、```make clang-debug-no-tests```とするとうまくいきました。
参考）https://github.com/WebAssembly/wabt/issues/333

※ もし下記のようなエラーがでたらbisonのバージョンをあげる必要があります  
```
-- Could NOT find BISON: Found unsuitable version "2.3", but required is at least "3.0" (found /usr/bin/bison)
CMake Error at CMakeLists.txt:308 (message):
  Can't find third_party/gtest.  Run git submodule update --init, or disable
  with CMake -DBUILD_TESTS=OFF.


-- Configuring incomplete, errors occurred!
```
brewなどをつかってbisonのバージョンを上げ、PATHを通してください
参考）http://stackoverflow.com/questions/24835116/bison-latest-version-installed-but-not-in-use


### 4. コンパイルする

```
$ cd ..  // ルートにもどり
$ mkdir build && cd build // buildディレクトリをつくって移動
$ touch sample.c
$ vi sample.c  // またはエディタで開く
```


▼sample.c
```c
int c=0;
int count(){return c++;}
```

このあと、以下を1行ずつ順番に実行してください
```
$ clang -emit-llvm --target=wasm32 -S sample.c
$ llc sample.ll -march=wasm32
$ s2wasm sample.s > sample.wast
$ ../wabt/out/clang/Debug/no-tests/wast2wasm -o sample.wasm sample.wast
```

sample.wast ファイルが生成されたらコンパイル成功です！



## まとめ＆今後

+ WebAssemblyを使えば、何でも速くなるわけではない

+ これまでWebでできなかった種類のアプリケーションが実現できる（特にグラフィック処理の多いゲーム系？） 

+ 将来的にC, C#以外の言語でもWebAssemblyにコンパイルされる「クロスコンパイラ」の可能性が高まっている
 → WEBアプリ開発にJavascriptが必須ではなくなる？



### （おまけ）ChromeはすでにJavascriptを機械語に翻訳している？

Chromeに搭載されている「Google V8 JavaScriptEngine」は、Javascriptをあらかじめ機械語に翻訳している。  
そのため、WebAssemblyは必ずしもJavascriptより早くなる、というわけではない


## 参考
http://gigazine.net/news/20161101-webassembly-browser-preview/
https://www.slideshare.net/likr/asmjswebassembly

