//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/08.
//

@_exported import FirestoreClient
import Dependencies
import FirebaseFirestore
import Foundation
import Shared

extension FirestoreClient: @retroactive DependencyKey {
    public static var liveValue: FirestoreClient {
        Self.live()
    }

    private static func live() -> Self {
        let db = Firestore.firestore()
        let decoder = Firestore.Decoder()

        return Self.init { date in
            let snapshot = try await db.collection("calendar")
                .document(date)
                .getDocument()
            let decoded = try decoder.decode(
                BusDate.self,
                from: snapshot.data() ?? [:]
            )

            return decoded
        } fetchBusTimes: { diagram, destination, second in
            let snapshot = try await db.collection(diagram + destination.rawValue)
                .whereField("second", isGreaterThanOrEqualTo: second)
                .getDocuments()
            let decoded = try snapshot.documents
                .map { document in
                    try decoder.decode(
                        BusTime.self,
                        from: document.data()
                    )
                }

            return decoded
        }
    }
}
