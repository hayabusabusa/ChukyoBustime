//
//  FirestoreProvider.swift
//  Infra
//
//  Created by 山田隼也 on 2020/01/28.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

public final class FirestoreProvider {

    // MARK: Singletone

    public static let shared: FirestoreProvider = FirestoreProvider()

    // MARK: Properties

    private let db: Firestore = Firestore.firestore()

    // MARK: Initializer

    private init() {}

    // MARK: Firestore

    public func getBusDate(at date: String) -> Single<BusDateEntity> {
        return Single.create { observer in
            self.db.collection("calendar")
                .whereField("date", isEqualTo: date)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    }
                    if let document = querySnapshot?.documents.first {
                        do {
                            let entity = try Firestore.Decoder().decode(BusDateEntity.self, from: document.data())
                            observer(.success(entity))
                        } catch {
                            observer(.error(error))
                        }
                    } else {
                        observer(.error(FirestoreError.dateNotFound))
                    }
            }
            return Disposables.create()
        }
    }

    public func getBusTimes(of diagram: String, destination: BusDestination, second: Int) -> Single<[BusTimeEntity]> {
        return Single.create { observer in
            self.db.collection(diagram + destination.rawValue)
                .whereField("second", isGreaterThanOrEqualTo: second).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    }
                    if let documents = querySnapshot?.documents {
                        do {
                            let entities = try documents.map { try Firestore.Decoder().decode(BusTimeEntity.self, from: $0.data()) }
                            observer(.success(entities))
                        } catch {
                            observer(.error(error))
                        }
                    } else {
                        observer(.success([]))
                    }
            }
            return Disposables.create()
        }
    }
    
    public func getBusTimes(at date: BusDateEntity, destination: BusDestination, second: Int) -> Single<(busDate: BusDateEntity, busTimes: [BusTimeEntity])> {
        return Single.create { observer in
            self.db.collection(date.diagram + destination.rawValue)
                .whereField("second", isGreaterThanOrEqualTo: second).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    }
                    if let documents = querySnapshot?.documents {
                        do {
                            let busTimes = try documents.map { try Firestore.Decoder().decode(BusTimeEntity.self, from: $0.data()) }
                            observer(.success((busDate: date, busTimes: busTimes)))
                        } catch {
                            observer(.error(error))
                        }
                    } else {
                        observer(.success((busDate: date, busTimes: [])))
                    }
            }
            return Disposables.create()
        }
    }
}
