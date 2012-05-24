Model ---...---> View を書きやすくための提案
============================================

1. MVCは3層とか言ってもModelとViewを同時に変更することが多い（=依存）
2. 依存しているなら a.まとめるか、b.依存を解消するほうがいい
3. じゃあ**b**の解消で



テンプレートに注入するデータを、どうマークアップするか
------------------------------------------------------

オブジェクト構造のクラスとマークアップルールを対応付ければ、プログラミング言語での型を活用できて書きやすそう。



問題
----

* このデータ構造をどうやって作るかという…
* HTML出力の順番もデータ構造次第
* マークアップルール別にクラスを作らないといけない

全部1つの問題のような気がする。



Output
------

> ### Model->new: bless( {
> ###                      root => bless( {
> ###                                       c => [
> ###                                              bless( {
> ###                                                       c => [
> ###                                                              bless( {
> ###                                                                       c => 'TITLE:1'
> ###                                                                     }, 'Model::_title' ),
> ###                                                              bless( {
> ###                                                                       c => 'BODY:1'
> ###                                                                     }, 'Model::_body' ),
> ###                                                              bless( {
> ###                                                                       c => [
> ###                                                                              bless( {
> ###                                                                                       c => 'TAG:11'
> ###                                                                                     }, 'Model::_tag' ),
> ###                                                                              bless( {
> ###                                                                                       c => 'TAG:12'
> ###                                                                                     }, 'Model::_tag' )
> ###                                                                            ]
> ###                                                                     }, 'Model::_noop' )
> ###                                                            ]
> ###                                                     }, 'Model::_entry' ),
> ###                                              bless( {
> ###                                                       c => [
> ###                                                              bless( {
> ###                                                                       c => 'TITLE:2'
> ###                                                                     }, 'Model::_title' ),
> ###                                                              bless( {
> ###                                                                       c => 'BODY:21<br />BODY:22<br />BODY:23'
> ###                                                                     }, 'Model::_body' ),
> ###                                                              bless( {
> ###                                                                       c => [
> ###                                                                              bless( {
> ###                                                                                       c => 'TAG:21'
> ###                                                                                     }, 'Model::_tag' ),
> ###                                                                              bless( {
> ###                                                                                       c => 'TAG:22'
> ###                                                                                     }, 'Model::_tag' ),
> ###                                                                              bless( {
> ###                                                                                       c => 'TAG:23'
> ###                                                                                     }, 'Model::_tag' )
> ###                                                                            ]
> ###                                                                     }, 'Model::_noop' )
> ###                                                            ]
> ###                                                     }, 'Model::_entry' )
> ###                                            ]
> ###                                     }, 'Model::_root' )
> ###                    }, 'Model' )

> <html>
> <head>
> 	<title>DDT sample</title>
> 	<style>
> 		.entry {
> 			margin: 2em 0;
> 		}
> 		.title {
> 			border: solid navy;
> 			border-width: thin thin thin 1em;
> 			font-size: x-large;
> 			padding: 0 1ex;
> 		}
> 		.body {
> 			padding: 1em 1em 1em 2em;
> 		}
> 		.tag {
> 			border: dashed silver thin;
> 			margin: 0 1ex;
> 			padding: 0 1ex;
> 			font-size: x-small;
> 		}
> 	</style>
> </head>
> <body>
> 	<div>
> <div class="entry">
>  
> <div class="title">
>  TITLE:1 
> </div>
> 
> <div class="body">
>  BODY:1 
> </div>
> <span class="tag"> TAG:11 </span><span class="tag"> TAG:12 </span> 
> </div>
> 
> <div class="entry">
>  
> <div class="title">
>  TITLE:2 
> </div>
> 
> <div class="body">
>  BODY:21<br />BODY:22<br />BODY:23 
> </div>
> <span class="tag"> TAG:21 </span><span class="tag"> TAG:22 </span><span class="tag"> TAG:23 </span> 
> </div>
> </div>
> </body>
> </html>

