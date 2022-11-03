//
//  FirestoreService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol FirestoreServiceProtocol {
    /// Firestore のコレクションからドキュメント一覧を取り出す.
    /// - Parameters:
    ///   - reference: コレクションへのリファレンス.
    ///   - type: デコードする型.
    /// - Returns: デコードしたドキュメント一覧.
    func documents<R: FirestoreReferenceable, T: Decodable>(for reference: R, type: T.Type) async throws -> [T] where R.ReferenceType == CollectionReference

    /// Firestore のコレクションからクエリを実行してドキュメント一覧を取り出す.
    /// - Parameters:
    ///   - query: 実行するクエリ.
    ///   - type: デコードする型.
    /// - Returns: デコードしたドキュメント一覧.
    func documents<R: FirestoreReferenceable, T: Decodable>(for query: R, type: T.Type) async throws -> [T] where R.ReferenceType == Query
}

/// Firestore のリファレンスを表す Protocol.
public protocol FirestoreReferenceable {
    associatedtype ReferenceType

    /// リファレンスを作成する.
    /// - Returns: 任意のリファレンス形式.
    func toReference(with db: Firestore) -> ReferenceType
}

/// Firestore の操作をまとめた Service クラス.
public final class FirestoreService: FirestoreServiceProtocol {

    /// シングルトン.
    public static let shared: FirestoreService = .init()

    private let db = Firestore.firestore()

    private init() {}

    public func documents<R, T>(for reference: R, type: T.Type) async throws -> [T] where R: FirestoreReferenceable, T: Decodable, R.ReferenceType == CollectionReference {
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
                            let decoded = try documents.map { try decoder.decode(type, from: $0.data(), in: $0.reference) }
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }

    public func documents<R, T>(for query: R, type: T.Type) async throws -> [T] where R: FirestoreReferenceable, T: Decodable, R.ReferenceType == Query {
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
                            let decoded = try documents.map { try decoder.decode(type, from: $0.data(), in: $0.reference) }
                            continuation.resume(returning: decoded)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }
}

