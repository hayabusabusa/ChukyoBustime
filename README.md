
<div align="center">
    <img src="https://github.com/hayabusabusa/ChukyoBustime/blob/develop/Images/app_icon.png"  title="AppIcon">
</div>

<div align="center">
    <a href="https://apps.apple.com/jp/app/%E4%B8%AD%E4%BA%AC%E5%A4%A7%E5%AD%A6%E8%B1%8A%E7%94%B0%E3%82%AD%E3%83%A3%E3%83%B3%E3%83%91%E3%82%B9-%E3%82%B9%E3%82%AF%E3%83%BC%E3%83%AB%E3%83%90%E3%82%B9%E6%99%82%E5%88%BB%E8%A1%A8%E3%82%A2%E3%83%97%E3%83%AA/id1520394786"><img src="https://linkmaker.itunes.apple.com/assets/shared/badges/ja-jp/appstore-lrg.svg" alt="AppStoreで入手" height="40" style="margin:10px 10px;" /></a>
</div>

中京大学スクールバスの**非公式**アプリです。  
使用した技術の詳細などは [note](https://note.com/hayabusabusa/n/n92e244c20bff) に記事として投稿しています。

## Requirements
- CocoaPods
- Carthage

## Installation
**Firebase**を使用しているため  `GoogleService-Info.plist` が必須です。  
用意した上で `Firebase` フォルダ内に配置し、Xcode のプロジェクトがあるディレクトリで以下のコマンドを実行してください。

```
make bootstrap
```

## Architecture

- MVVM

## Dependency

- Firebase( Firestore )
- RxSwift
- RxCocoa
- SwiftDate

## Design

- Atomic Design
- [Figma](https://www.figma.com/file/ReIySQcR65ncs8k2cYGo1i/CHKBus-App-Design?node-id=3%3A195)

## Other platform
Android 版を [m.coder](https://github.com/nanaten) さんに作っていただきました。  
リポジトリは[こちら](https://github.com/nanaten/bustime)になります。

## LICENSE

```
MIT License

Copyright (c) 2020 Shunya Yamada

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
