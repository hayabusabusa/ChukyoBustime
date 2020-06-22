
<div align="center">
    <img src="https://github.com/hayabusabusa/ChukyoBustime/blob/develop/Images/app_icon.png"  title="AppIcon">
</div>

中京大学スクールバスの**非公式**アプリです。

## Requirements
- CocoaPods
- Carthage

## Installation
**Firebase**を使用しているため  `GoogleService-Info.plist` が必須です。  
用意した上でプロジェクトがあるディレクトリで以下のコマンドを実行してください。

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
