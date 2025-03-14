# C++ アプリケーション プロジェクト テンプレート

## 環境構築

### ツールのインストール

```powershell
winget install -e --id Git.Git
winget install -e --id JetBrains.CLion
winget install -e --id Kitware.CMake
winget install -e --id Python.Python.3.13
winget install -e --id ezwinports.make
```

### ツールのインストール（WebAssembly）

```powershell
winget install -e --id OpenJS.NodeJS
```

### Gitの設定

```bash
git config --local core.autocrlf false
```

### 3rdのソースの取得

```bash
cd tools/build_shell
sh git_clone_thirdparty.sh
```

### CLion（WebAssembly作成用設定）

- 外観 ＆ 振る舞い
  - パス変数
    - 名前：EMSCRIPTEN
    - 値：`tools\emsdk\upstream\emscripten`のフルパス

- ビルド、実行、デプロイ
  - CMake
    - CMake オプション：-DCMAKE_TOOLCHAIN_FILE=${EMSCRIPTEN}/cmake/Modules/Platform/Emscripten.cmake

## サンプルプロジェクトの実行方法

### サンプルプロジェクトの取り込み

- CLionで、`CMakeLists.txt`のあるフォルダを開く。
  - プロジェクトを信頼する。

### サンプルプロジェクトのビルド

- 左下の`CMake`アイコンから、`CMakeツールウィンド`を開き、`CMakeプロジェクトの再ロード`ボタンを押下。
- メニューから、`ビルド` ＞ `プロジェクトの再ビルド` を選択

### サンプルプロジェクトのアプリケーション実行

- メニューから、`実行` ＞ `実行構成の編集` を選択し、`実行/デバッグ構成`ダイアログを開く
- `実行/デバッグ構成`ダイアログの左のツリーから、`CMakeアプリケーション` の 実行したいアプリケーションを選択し、`実行` ボタンを押下

### サンプルプロジェクトのテスト実行

- メニューから、`実行` ＞ `実行構成の編集` を選択し、`実行/デバッグ構成`ダイアログを開く
- `実行/デバッグ構成`ダイアログの左のツリーから、`CTest アプリケーション` の テスト対象を選択し、`実行` ボタンを押下

## プロジェクトのディレクトリ構成

## bashの環境構築

```bash
```

BrechtSanders.WinLibs.POSIX.UCRT.LLVM


## 参考資料

- 参考にしたプロジェクトテンプレート
  - [C++ Application Project Template](https://code.google.com/archive/p/cpp-project-template/)
  - [C++ Library Project Template](https://code.google.com/archive/p/cpp-library-project-template/)

- 参考にしたサイト
  - [CMakeスクリプトを作成する際のガイドライン](https://qiita.com/shohirose/items/5b406f060cd5557814e9)

## オリジナルドキュメント

```text
== README ==

 1.) Prerequisites
 2.) Building
 3.) Installing
 4.) Contributing
 
== 1. PREREQUISITES ==

 This project requires:
  * Cross-platform Make (CMake) v2.6.2+
  * GNU Make or equivalent.
  * GCC or an alternative, reasonably conformant C++ compiler.
  * Boost C++ Libraries v1.37+ [HEADERS and LIBRARIES]
  * Qt Framework v4.5+
  * Log4Cxx v0.10.0+
  * UnitTest++ (a.k.a. unittest-cpp)

== 2. BUILDING ==
 
 This project uses the Cross-platform Make (CMake) build system. However, we
 have conveniently provided a wrapper configure script and Makefile so that
 the typical build invocation of "./configure" followed by "make" will work.
 For a list of all possible build targets, use the command "make help".

 NOTE: Users of CMake may believe that the top-level Makefile has been
 generated by CMake; it hasn't, so please do not delete that file.

== 3. INSTALLING ==

 Once the project has been built (see "BUILDING"), execute "sudo make install".

== 4. CONTRIBUTING ==

 TODO: Enhance section.
``` 

