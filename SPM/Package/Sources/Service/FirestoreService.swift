//
//  FirestoreService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import ServiceProtocol
import Shared

/// Firestore の操作をまとめた Service クラス.
public final class FirestoreService: FirestoreServiceProtocol {
    /// シングルトン.
    public static let shared: FirestoreService = .init()

    private let db = Firestore.firestore()

    private init() {}

    public func busDate(with request: BusDateRequest) async throws -> BusDate {
        try await document(for: request)
    }

    public func busTimes(with request: BusTimesRequest) async throws -> [BusTime] {
        try await documents(for: request)
    }
}

private extension FirestoreService {
    /// Firestore のコレクションから単一のドキュメントを取り出す.
    /// - Parameters:
    ///   - reference: ドキュメントへのリファレンス.
    ///   - type: デコードする型.
    /// - Returns: デコードしたドキュメント.
    func document<T>(for reference: T) async throws -> T.DocumentType where T: FirestoreRequestable, T: FirestoreReferenceable, T.ReferenceType == DocumentReference {
        let decoder = Firestore.Decoder()

        return try await withCheckedThrowingContinuation { continuation in
            reference.toReference(with: db)
                .getDocument { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let data = snapshot?.data() {
                        do {
                            let decoded = try decoder.decode(T.DocumentType.self, from: data)
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }

    /// Firestore のコレクションからドキュメント一覧を取り出す.
    /// - Parameters:
    ///   - reference: コレクションへのリファレンス.
    ///   - type: デコードする型.
    /// - Returns: デコードしたドキュメント一覧.
    func documents<T>(for reference: T) async throws -> [T.DocumentType] where T: FirestoreRequestable, T: FirestoreReferenceable, T.ReferenceType == CollectionReference {
        let decoder = Firestore.Decoder()

        return try await withCheckedThrowingContinuation { continuation in
            reference.toReference(with: db)
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let documents = snapshot?.documents {
                        do {
                            let decoded = try documents.map { try decoder.decode(T.DocumentType.self, from: $0.data(), in: $0.reference) }
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }

    /// Firestore のコレクションからクエリを実行してドキュメント一覧を取り出す.
    /// - Parameters:
    ///   - query: 実行するクエリ.
    ///   - type: デコードする型.
    /// - Returns: デコードしたドキュメント一覧.
    func documents<T>(for query: T) async throws -> [T.DocumentType] where T: FirestoreRequestable, T: FirestoreReferenceable, T.ReferenceType == Query {
        let decoder = Firestore.Decoder()

        return try await withCheckedThrowingContinuation { continuation in
            query.toReference(with: db)
                .getDocuments { snapshot, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    if let documents = snapshot?.documents {
                        do {
                            let decoded = try documents.map { try decoder.decode(T.DocumentType.self, from: $0.data(), in: $0.reference) }
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
}
