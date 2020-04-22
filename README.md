# ken-all

Seach postal code by address using `KEN_ALL.csv`

## Installation

1. Download [KEN_ALL.CSV](http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip).
2. Put KEN_ALL.csv in repository root.
3. Do indexing.

```bash
$ ruby index.rb
1/3: start normalizing...
2/3: start indexing...
3/3: start saving index file...
completed!
```

## Usage

```bash
$ ruby search.rb
東京都
"1500000","東京都","渋谷区"
"1510064","東京都","渋谷区","上原"
...
```
