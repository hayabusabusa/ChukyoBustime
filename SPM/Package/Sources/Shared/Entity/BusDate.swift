//
//  BusDate.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation

/// Firestore に保存しているバスのカレンダーのコレクションに入っているデータ.
public struct BusDate: Codable {
    /// バスのダイヤ.
    ///
    /// この値を利用してカレンダーのコレクションにアクセスする.
    public let diagram: String
    /// 画面表示用のダイヤ名.
    public let diagramName: String

    public init(diagram: String, diagramName: String) {
        self.diagram = diagram
        self.diagramName = diagramName
    }
}
