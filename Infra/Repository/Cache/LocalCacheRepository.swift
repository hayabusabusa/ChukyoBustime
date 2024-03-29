//
//  LocalCacheRepository.swift
//  Infra
//
//  Created by 山田隼也 on 2020/03/17.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftDate
import RxSwift

// MARK: - Interface

public protocol LocalCacheRepository {
    func saveCache(of destination: BusDestination, date: Date, busDate: BusDateEntity, busTimes: [BusTimeEntity]) -> Completable
    func checkCache(at date: Date, destination: BusDestination) -> Single<Bool>
    func loadCache<O: Object>(of type: O.Type) -> Single<O> where O: LocalCacheable
}

// MARK: - Implementation

public struct LocalCacheRepositoryImpl: LocalCacheRepository {
    
    // MARK: Dependency
    
    private let provider: RealmProviderProtocol
    
    // MARK: Initializer
    
    public init(provider: RealmProviderProtocol = RealmProvider.shared) {
        self.provider = provider
    }
    
    // MARK: Save cache
    
    public func saveCache(of destination: BusDestination, date: Date, busDate: BusDateEntity, busTimes: [BusTimeEntity]) -> Completable {
        return destination == BusDestination.toStation
            ? overwriteStationLocalCache(date: date, busDate: busDate, busTimes: busTimes)
            : overwriteCollegeLocalCache(date: date, busDate: busDate, busTimes: busTimes)
    }
    
    /// Realmに保存されている駅行きの時間データのキャッシュを上書きする.
    /// - Note: 既に保存されていない場合は新しく保存、既に保存されている場合は削除してから新規に保存.
    /// - Parameters:
    ///   - date: 保存を行ったタイミングの`Date`.
    ///   - busDate: 保存する`BusDateEntity`のオブジェクト.
    ///   - busTimes: 保存する`BusTimeEntity`のオブジェクト配列.
    private func overwriteStationLocalCache(date: Date, busDate: BusDateEntity, busTimes: [BusTimeEntity]) -> Completable {
        // NOTE: デフォルトの `Date` は GMT で設定されているため、9時間ずれる.
        // SwiftDate の `DateInRegion` で日本の日付にした上で yyyy-MM-dd のフォーマットにする.
        let dateInRegion = DateInRegion(date, region: .current)
        return provider.get(StationLocalCache.self)
            .flatMapCompletable { object -> Completable in
                // NOTE: 既にキャッシュを保存済みかどうかをチェック、正しくリレーションされているかどうかも確認
                let newCache = StationLocalCache(lastUpdatedDate: dateInRegion.toFormat("yyyy-MM-dd"), busDate: busDate, busTimes: busTimes)
                guard let object = object,
                    let relatedBusDate = object.busDate else {
                    return self.provider.save(newCache)
                }
                // NOTE: 保存されていたオブジェクトを削除してから新規保存
                return Completable.concat([self.provider.delete(relatedBusDate),
                                           self.provider.delete(object.busTimes),
                                           self.provider.delete(object),
                                           self.provider.save(newCache)])
        }
    }
    
    /// Realmに保存されている大学行きの時間データのキャッシュを上書きする.
    /// - Note: 既に保存されていない場合は新しく保存、既に保存されている場合は削除してから新規に保存.
    /// - Parameters:
    ///   - date: 保存を行ったタイミングの`Date`.
    ///   - busDate: 保存する`BusDateEntity`のオブジェクト.
    ///   - busTimes: 保存する`BusTimeEntity`のオブジェクト配列.
    private func overwriteCollegeLocalCache(date: Date, busDate: BusDateEntity, busTimes: [BusTimeEntity]) -> Completable {
        // NOTE: デフォルトの `Date` は GMT で設定されているため、9時間ずれる.
        // SwiftDate の `DateInRegion` で日本の日付にした上で yyyy-MM-dd のフォーマットにする.
        let dateInRegion = DateInRegion(date, region: .current)
        return provider.get(CollegeLocalCache.self)
            .flatMapCompletable { object -> Completable in
                // NOTE: 既にキャッシュを保存済みかどうかをチェック、正しくリレーションされているかどうかも確認
                let newCache = CollegeLocalCache(lastUpdatedDate: dateInRegion.toFormat("yyyy-MM-dd"), busDate: busDate, busTimes: busTimes)
                guard let object = object,
                    let relatedBusDate = object.busDate else {
                        return self.provider.save(newCache)
                }
                // NOTE: 保存されていたオブジェクトを削除してから新規保存
                return Completable.concat([self.provider.delete(relatedBusDate),
                                           self.provider.delete(object.busTimes),
                                           self.provider.delete(object),
                                           self.provider.save(newCache)])
        }
    }
    
    // MARK: Check cache
    
    public func checkCache(at date: Date, destination: BusDestination) -> Single<Bool> {
        return destination == BusDestination.toStation
            ? checkStationLocalCache(at: date)
            : checkCollegeLocalCache(at: date)
    }
    
    private func checkStationLocalCache(at date: Date) -> Single<Bool> {
        // NOTE: デフォルトの `Date` は GMT で設定されているため、9時間ずれる.
        // SwiftDate の `DateInRegion` で日本の日付にした上で yyyy-MM-dd のフォーマットにする.
        let dateInRegion = DateInRegion(date, region: .current)
        return provider.get(StationLocalCache.self)
            .map { object -> Bool in
                guard let object = object else { return false }
                return object.lastUpdatedDate == dateInRegion.toFormat("yyyy-MM-dd")
            }
    }
    
    private func checkCollegeLocalCache(at date: Date) -> Single<Bool> {
        // NOTE: デフォルトの `Date` は GMT で設定されているため、9時間ずれる.
        // SwiftDate の `DateInRegion` で日本の日付にした上で yyyy-MM-dd のフォーマットにする.
        let dateInRegion = DateInRegion(date, region: .current)
        return provider.get(CollegeLocalCache.self)
            .map { object -> Bool in
                guard let object = object else { return false }
                return object.lastUpdatedDate == dateInRegion.toFormat("yyyy-MM-dd")
            }
    }
    
    // MARK: Load cache
    
    /// Realmに保存されたキャッシュを取得する.
    /// - Note: 保存されたデータがない場合は`RealmError.objectNotFound`を返す.
    /// - Parameter type: `LocalCacheable`に準拠したRealmオブジェクトタイプ.
    public func loadCache<O: Object>(of type: O.Type) -> Single<O> where O: LocalCacheable {
        return provider.get(type)
            .map { object -> O in
                guard let object = object else { throw RealmError.objectNotFound }
                return object
            }
    }
}
