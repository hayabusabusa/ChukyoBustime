//
//  FirebaseProvider.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore

public final class FirebaseProvider {
    
    // MARK: Singletone
    
    public static let shared: FirebaseProvider = FirebaseProvider()
    
    // MARK: Properties
    
    private let db: Firestore = Firestore.firestore()
    
    // MARK: Initializer
    
    private init() {}
    
    // MARK: Firestore
    
    public func getDiagram(at date: String) -> Single<String> {
        return Single.create { observer in
            self.db.collection("calendar")
                .whereField("date", isEqualTo: date)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    }
                    if let document = querySnapshot?.documents.first,
                        let diagram = document.data()["diagram"] as? String {
                        observer(.success(diagram))
                    } else {
                        observer(.error(FirebaseError.dateNotFound))
                    }
            }
            return Disposables.create()
        }
    }
    
    public func getBusTimes(of diagram: String, hour: Int, minute: Int) -> Single<[(hour: Int, minute: Int)]> {
        return Single.create { observer in
            self.db.collection(diagram).document("toCollege").collection("times").whereField("second", isGreaterThanOrEqualTo: hour * 3600 + minute * 60).getDocuments { (querySnapshot, error) in
                if let error = error {
                    observer(.error(error))
                }
                if let documents = querySnapshot?.documents {
                    observer(.success(documents.map { (hour: $0.data()["hour"] as! Int, minute: $0.data()["minute"] as! Int) }))
                } else {
                    observer(.success([]))
                }
            }
            return Disposables.create()
        }
    }
}
