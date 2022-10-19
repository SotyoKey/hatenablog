# tabelog tech blog の記事執筆方法開始方法

## 1 issueを作成する
issueを作成すると自動的にプルリクエストが作成され、issue番号に紐づいたディレクトリ内に記事執筆にようなファイルが準備されます。

記事執筆用ファイル説明
draft.md：ブログの下書きです。
image：ブログで使用する画像を格納するディレクトリです。

ディレクトリ構造
```
.
└── entry
    └── 2022
        ├── 09
        │   └── issue_#{NUM}
        │       └── draft.md
        │       └── image
        └── 10
```

## 2 ブログ運営チームに連絡する
teamsでブログ運営チーム宛てにissueの共有をお願いします。
今後の進め方、期日等についてすり合わせをおこなわせていただきます。


## その他
### 記事カテゴリの設定の仕方
draft.md内のCategoryを編集してください。
例：
```
Category:
- category1
- caategory2
```

### slugの設定方法(URLのカスタム)
draft.md内のCustom_pathを指定したいslugに書き換えてください
記事の公開URLがhttps://sotyo-gbf.hatenablog.com/entry/#{slug}となります。
例：
```
CustomPath: open-tech-blog-vol1
```

### 注意事項
draft.md内の"Draft: true"の記述を消さないこと
push時に記事が公開されてしまいます。



test
testp
fdafae1
dsds^
fdfdds
