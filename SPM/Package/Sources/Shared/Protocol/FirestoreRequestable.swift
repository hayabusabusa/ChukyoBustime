//
//  FirestoreRequestable.swift
//  
//
//  Created by Shunya Yamada on 2023/03/08.
//

import Foundation

/// Firestore からデータを取得するリクエストに適合させる Protocol.
public protocol FirestoreRequestable {
    /// Firestore から取得するドキュメントの型.
    associatedtype DocumentType: Decodable
}

/// バスのカレンダーのコレクションからその日の運行情報のデータを取得するリクエスト.
public struct BusDateRequest: FirestoreRequestable {
    public typealias DocumentType = BusDate

    /// 取得する日付.
    public let date: String

    public init(date: String) {
        self.date = date
    }
}

/// ダイヤのコレクションからデータ一覧を取り出すリクエスト.
public struct BusTimesRequest: FirestoreRequestable {
    public typealias DocumentType = BusTime

    /// 取得するダイヤ名.
    public let diagram: String
    /// 行き先.
    public let destination: BusDestination
    /// 取得開始する時刻を秒数にしたもの.
    public let second: Int

    public init(diagram: String,
                destination: BusDestination,
                second: Int) {
        self.diagram = diagram
        self.destination = destination
        self.second = second
    }
}
