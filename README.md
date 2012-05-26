Model ---...---> View を書きやすくための提案
============================================

1. MVCは3層とか言ってもModelとViewを同時に変更することが多い（=依存）
2. 依存しているなら a.まとめるか、b.依存を解消するほうがいい
3. じゃあ**b**の解消で



テンプレートに注入するデータを、どうマークアップするか
------------------------------------------------------

Modelの内部をどうマークアップするかが問題。
せっかくプログラミング言語には型というものがあるので、これでModel内部の要素を区別 → それぞれに対応するコードを実行。

例えば、最初のentryのtitle要素を指定する記述…

    Model::_entries ARRAY->[0] Model::_entry HASH->{title}

この要素をどうマークアップするかをプログラムコードで記述。



実装
----

* 仕組みはDDT.pm
* モデル(Models.pm)、ビュー(Views.pm)の仕様はなんでもいい。
* ddt.pl内のカスタマイズ版DDT (DDT::_entries)がモデルとビューを扱えればいい。ここがコントローラーのビュー生成部分に相当。
