//
//  FirestoreReferenceable.swift
//  
//
//  Created by Shunya Yamada on 2023/03/08.
//

import Foundation
import FirebaseFirestore
import Shared

/// Firestore のリファレンスを表す Protocol.
protocol FirestoreReferenceable {
    associatedtype ReferenceType

    /// リファレンスを作成する.
    /// - Returns: 任意のリファレンス形式.
    func toReference(with db: Firestore) -> ReferenceType
}

extension BusDateRequest: FirestoreReferenceable {
    typealias ReferenceType = DocumentReference

    func toReference(with db: Firestore) -> DocumentReference {
        db.collection("calendar").document(date)
    }
}

extension BusTimesRequest: FirestoreReferenceable {
    typealias ReferenceType = Query

    func toReference(with db: Firestore) -> ReferenceType {
        db.collection(diagram + destination.rawValue).whereField("second", isGreaterThanOrEqualTo: second)
    }
}
