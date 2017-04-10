
# WebAssemblyとは？ 

<img src="https://raw.githubusercontent.com/umamichi/web-assembly/master/images/wasm.png" width="500">

ブラウザからアセンブリ（機械語）を実行できるようにする技術  
高速化手段、あるいはJavaScriptの処理系にできないことをするといった目的で提案された

2015年6月、Mozilla、Google、Microsoft、Appleが標準フォーマットとして開発することに合意した

## WebAssemblyが生まれた経緯

### JavaScriptに実行速度が求められる時代になった

### 1. なぜJavaScriptは遅いか？

+ インタプリタ言語である
+ 動的型付けをしている  
→ 解析に時間がかかってしまう  

よって、コンパイラ言語と比べると遅い😭

当初、JavascriptはHTMLに飾り付けをする程度だった  

さっと書いて、すぐに動く、それが売りだった  

しかし最近では・・・

 + 複雑なアニメーション
 + WebGLなどのグラフィック処理
 + 計算速度の遅いモバイル端末

にも用途が広がり、実行速度が求められるようになってきた


### 2. JavaScriptを高速化するため、asm.jsが生まれ

2013年頃、**asm.js**（読み：アスム） が生まれた  
asm.jsとは、JavaScriptを高速実行するために開発されたサブセット  
＝サブセットとは、全体に対する一部分のこと。本来の規格に関する限定部分、あるいはソフトウエアの機能を限定して使えるようにしたもの

asm.jsとは、JavaScriptをある制約に従って書くことで、  
**型を明確にして、ブラウザが事前コンパイルできるようにする**技術です

▼ asm.jsの例
```javascript
function asm(stdin, foreign, heap){ //引数は最大3つ
  // use asm宣言により,JavaScriptインタプリタはこのfunctionをasm.jsコードと解釈し, 事前コンパイルを試みます
  'use asm';
  
  // 共有変数宣言
  var a = 0;
  // 関数定義
  function hoge(){
    callOuter();
  }
  // 外部への公開
  return stdin.hoge;
}
```

👍 asm.jsの良いところ
+ 数値演算系の実行速度が速くなる（通常のJavascriptの6〜7割のパフォーマンス）
+ asm.jsをサポートしない環境では通常のJavaScriptコードとして振舞う
+ 他言語（C/C++）からasm.jsコードを出力可（コンパイラを使う）
+ ゲームエンジンによるサポート（Unreal Engine, Unity）  
→ UnityのコードをWebGLで動作させるときにasm.jsが使われている

👎 asm.jsの悪いところ
+ ファイルサイズが増大&通信量増加  
 → それによるパージング（構文解析）の時間増加 
+ データ構造の概念が存在しない  
 → 数値計算しかできない。オブジェクト指向的なアプローチが通用しない
+ Web API 呼び出しが得意ではない（外部からfunctionを渡す必要がある）


### 3. asm.jsの代替案として、Web Assemblyが生まれた

**バイナリコード**をブラウザが扱えるようになることで、
JavaScriptに比べてファイルサイズを大幅に小さくすることができ、これらの問題を解決しようというもの

<img src="https://raw.githubusercontent.com/umamichi/web-assembly/master/images/asm-js-to-wasm.png" width="500">  

※バイナリコード・・・コンピューターに処理を依頼する命令を、CPUが理解できるように2進数で表したコードのこと


## WebAssemblyのすごいところ✨

+ asm.jsに比べてファイルサイズが小さくなり、ロード時間が短くなる
  ※実行時間がはやくなるわけでない	
+ 将来的に、JavaScriptを書かずにGC, DOM, Web API操作を目標としている
+ 対応言語は現時点でC/C++, Rust（Mozillaによって開発されている言語）など

## WebAssemblyの悪いところ👼

+ どの言語で書こうが事前コンパイルが必須
  （下記で書きましたが、現時点でコンパイルがめちゃめちゃめんどくさい）
  
+ DOMを操作する必要があり、DOMからは解放されない



## Can I use WebAssembly?

Chrome、Firefoxを中心にこれから開発が進んでいく模様  
<img src="https://raw.githubusercontent.com/umamichi/web-assembly/master/images/caniuse.png?raw=true" width="100%">


## C言語をWebAssembly対応ブラウザで動かしてみる


以下のようなC言語の関数ををブラウザから呼び出し、実行してみます


```c
// sample.c
int c=0;
int count(){return c++;}
```

⬇︎これをWebAssemblyに変換するとこうなる (バイナリファイルは通常のエディタでは開けません)


```wasm
// sample.wasm
0000000    060400  066563  000001  000000  002401  060001  000400  001577
0000020    000402  002000  000404  000160  002400  000403  000400  011007
0000040    003002  062555  067555  074562  000002  061405  072557  072156
0000060    000000  013412  012401  000401  040577  040400  024000  006002
0000100    000042  000501  033152  006002  000040  005413  000412  040400
0000120    005414  000004  000000  000000
0000127
```

### 1. Chrome Canaryをインストール

Chrome Canaryとは・・・開発者向けブラウザ。開発段階の最新機能を備えている  

https://www.google.co.jp/chrome/browser/canary.html

### 2. Chrome Canary起動、URLから「[chrome://flags/#enable-webassembly](chrome://flags/#enable-webassembly)」を開く


### 3. WebAssemblyを有効にし、Canary再起動する


### 4. https://umamichi.github.io/wasm/ にアクセスし、デペロッパーツールを開き、画面上のボタンをクリックする

クリックする度にインクリメントされた数値がコンソールに出力されたら成功です

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

**現段階では、このようにwasmファイルをJavaScriptで読み込むための処理を書く必要があります**


### 5.(おまけ) UnityでつくられたゲームをWebAssemblyで動かす

Chrome Canaryで開いてください  

<a href="http://webassembly.org/demo/Tanks/" target="_blank">http://webassembly.org/demo/Tanks/</a>  
<img src="http://webassembly.org/demo/screenshot.jpg" width="500">



## WebAssemblyをいつ使うか

+ 部分的な処理の高速化
  → ブラウザ上で高速な画像処理/動画処理が必要な場合
+ C, C++等の他言語で書かれた既存アプリを移植
+ WASMでほとんどを実装し、UIなどをWeb技術で実装する

## まとめ＆今後

+ WebAssemblyを使えば、何でも速くなるわけではない。
　asm.jsと比べて早くなるのはロード時間のみ。実行時間ではない    

+ 現時点でコンパイル環境をつくるのがかなり面倒 

+ これまでWebでできなかった種類のアプリケーションが実現できる（特にグラフィック処理の多いゲーム系） 

+ 将来的にC, C#以外の言語でもWebAssemblyにコンパイルされる「クロスコンパイラ」の可能性が高まっている
 → WEBアプリ開発にJavascriptが必須ではなくなる？



# C言語をWebAssembly用バイナリコードにコンパイルしてみる


**⚠️ 注意 3〜4時間かかります**

```
環境　･･･　MacOS Yosemite 10.10.5
必要な空き容量　･･･　18GB
必要な時間　･･･ 3〜4時間ほど
```


### WebAssemblyバイナリへコンパイルする流れ

オープンソースのコンパイラ基盤 LLVM を使います  

<img>

LLVMは、フロントエンドとバックエンドにコンパイラが分かれており、
内部で中間表現(LLVM IR)に変換することで、指定の形式にコンパイルすることができます  


### 1.LLVM+clang のインストール

① LLVM をダウンロードする

```
$ mkdir web-assembly  // 任意の場所に作業ディレクトリを作る
$ cd web-assembly
$ git clone http://llvm.org/git/llvm.git
```


② clang（クラン）をダウンロードする
clangとは、プログラミング言語 C、C++、Objective-C、Objective-C++ 向けのコンパイラフロントエンドである   
バックエンドとして LLVM を使用している。

```
$ cd llvm/tools
$ git clone http://llvm.org/git/clang.git
```

③ cmakeを使えるようにしておく
cmakeはコンパイラに依存しないビルド自動化のためのフリーソフトウェアである  

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

binaryenとは、WebAssemblyのツールチェインのためのプロジェクト。
WebAssemblyモジュールをロードできる「Binaryen shell」や「asm.js」を使って実装されたコードをWebAssemblyにコンパイルする「asm2wasm」、その逆の処理を行う「wasm2asm」、LLVMで開発されているWebAssemblyバックエンドが出力する「.s」形式コードをWebAssemblyにコンパイルする「s2wasm」などを含んでいる


```
$ cd .. // ルートに戻る
$ git clone https://github.com/WebAssembly/binaryen.git
$ cd binaryen
$ cmake . && make
$ sudo make install
```

インストールに成功すると、binaryen-shell、wasm-as、wasm-dis、asm2wasm、wasm2asm、s2wasm、wasm.jsなどのコマンドが使えるようになります。

### 3. wabtのインストール

WebAssembly Binary Toolkit.  
wastファイルをwasmファイルにコンパイルするために必要です  

```
cd ..
$ git clone --recursive https://github.com/WebAssembly/wabt
$ cd wabt
$ make clang-debug-no-tests
```

※ READMEには ```$ make``` と書いてありますが、```vector not found```というエラーが出たので、```make clang-debug-no-tests```とするとうまくいきました  
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
$ ../wabt/out/clang/Debug/no-tests/wast2wasm -o sample.wasm sampl e.wast
```

sample.wast ファイルが生成されたらコンパイル成功！  

適用なサーバーを立て、先ほどのhtmlファイルとwasmファイルを配置すると動きます


## どれくらい速くなるのか検証してみた

### JavaScript

```javascript
  console.time('timer2'); 
  for (var i = 0; i < 10000000; i++) {
    const x = 0.000001 * 0.000001;
  }
  console.timeEnd('timer2');
```
#### 結果: 5.84ms


### WASM

```c
int loop(){
  int i;
  double x;
  for (i = 0; i < 10000000; i++) {
    x = 0.000001 * 0.000001;
  }
  return 0;
}
```

#### 結果: 35.3ms

### → 速くならなかった、むしろ遅くなった



## 参考
http://gigazine.net/news/20161101-webassembly-browser-preview/  
https://www.slideshare.net/likr/asmjswebassembly  
https://github.com/WebAssembly/design/blob/master/GC.md

