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

    public func getDiagram(at date: String) -> Single<BusDiagram> {
        return Single.create { observer in
            self.db.collection("calendar")
                .whereField("date", isEqualTo: date)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    }
                    if let document = querySnapshot?.documents.first {
                        do {
                            let busDate = try Firestore.Decoder().decode(BusDate.self, from: document.data())
                            
                            guard let busDiagram = BusDiagram(rawValue: busDate.diagram) else {
                                throw FirestoreError.unknownDiagram
                            }
                            observer(.success(busDiagram))
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

    public func getBusTimes(of diagram: BusDiagram, destination: BusDestination, second: Int) -> Single<[BusTime]> {
        return Single.create { observer in
            self.db.collection(diagram.rawValue + destination.rawValue)
                .whereField("second", isGreaterThanOrEqualTo: second).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    }
                    if let documents = querySnapshot?.documents {
                        do {
                            let busTimes = try documents.map { try Firestore.Decoder().decode(BusTime.self, from: $0.data()) }
                            observer(.success(busTimes))
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
}
