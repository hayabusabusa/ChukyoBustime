//
//  RealmProvider.swift
//  Infra
//
//  Created by 山田隼也 on 2020/03/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

// MARK: - Interface

public protocol RealmProviderProtocol: AnyObject {
    func save<O: Object>(_ object: O) -> Completable
    func save<O: Object>(overwrite object: O) -> Completable
    func save<S: Sequence>(_ objects: S) -> Completable where S.Element: Object
    func save<S: Sequence>(overwrite objects: S) -> Completable where S.Element: Object
    func get<O: Object>(_ type: O.Type) -> Single<O?>
    func get<O: Object>(_ type: O.Type) -> Single<[O]>
    func delete<O: Object>(_ object: O) -> Completable
    func delete<S: Sequence>(_ objects: S) -> Completable where S.Element: Object
    func deleteAll<O: Object>(_ type: O.Type) -> Completable
    func deleteAll() -> Completable
}

// MARK: - Implementation

public final class RealmProvider: RealmProviderProtocol {
    
    // MARK: Singleton
    
    public static let shared: RealmProvider = .init()
    
    // MARK: Properties
    
    private let realm: Realm
    private static let schemaVersion: UInt64 = 1
    
    // MARK: Initializer
    
    private init() {
        RealmProvider.migrateIfNeeded()
        
        do {
            realm = try Realm()
            #if DEBUG
            print(realm.configuration.fileURL ?? "nil")
            #endif
        } catch {
            fatalError("Could not instantiate Realm: \(error)")
        }
    }
    
    // MARK: Private
    
    private static func migrateIfNeeded() {
        let config = Realm.Configuration(schemaVersion: schemaVersion,
                                         deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: Save
    
    /// Realmに保存のみ行う.
    ///
    /// - Parameter object: 保存したいObjectクラスを継承したクラス
    public func save<O: Object>(_ object: O) -> Completable {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(object)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    /// Realmに全体上書きで保存する( Updateではないので注意 )
    ///
    /// - Parameter object: 上書き保存したいObjectクラスを継承したクラス
    public func save<O: Object>(overwrite object: O) -> Completable {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                let stored = realm.objects(O.self)
                try realm.write {
                    realm.delete(stored)
                    realm.add(object)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    /// Realmに保存のみ行う.
    ///
    /// - Parameter objects: 保存したいObjectクラスの配列
    public func save<S: Sequence>(_ objects: S) -> Completable where S.Element: Object {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(objects)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    /// Realmに全体上書きで保存する( Updateではないので注意 )
    ///
    /// - Parameter objects: 上書き保存したいObjectクラスの配列
    public func save<S: Sequence>(overwrite objects: S) -> Completable where S.Element: Object {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                let stored = realm.objects(S.Element.self)
                try realm.write {
                    realm.delete(stored)
                    realm.add(objects)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    // MARK: Get
    /// Realmに保存されているオブジェクトの最新一件を取り出す
    ///
    /// - Parameter type: 読み込みたいObjectクラスを継承したクラスの型
    public func get<O: Object>(_ type: O.Type) -> Single<O?> {
        return Single.create { observer in
            do {
                let realm = try Realm()
                let stored = realm.objects(type).first
                observer(.success(stored))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    /// Realmに保存されているオブジェクトを全て取り出す
    ///
    /// - Parameter type: 読み込みたいObjectクラスを継承したクラスの型
    public func get<O: Object>(_ type: O.Type) -> Single<[O]> {
        return Single.create { observer in
            do {
                let realm = try Realm()
                let stored = Array(realm.objects(type))
                observer(.success(stored))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    // MARK: Delete
    
    /// 指定したオブジェクトを削除する.
    ///
    /// - Parameter object: 削除したい`Object`クラスを継承したオブジェクト.
    public func delete<O: Object>(_ object: O) -> Completable {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(object)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
    
    /// 指定したオブジェクト群を削除する.
    ///
    /// - Parameter objects: 削除したい`Object`が要素となる配列.
    public func delete<S: Sequence>(_ objects: S) -> Completable where S.Element: Object {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(objects)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    /// 指定したクラスをRealmから全て削除する
    ///
    /// - Parameter type: 削除したいObjectクラスを継承したクラスの型
    public func deleteAll<O: Object>(_ type: O.Type) -> Completable {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                let objects = realm.objects(type)
                try realm.write {
                    realm.delete(objects)
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    /// Realmに保存されているオブジェクトを全て削除する
    public func deleteAll() -> Completable {
        return Completable.create { observer in
            do {
                let realm = try Realm()
                try realm.write {
                    realm.deleteAll()
                }
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}
