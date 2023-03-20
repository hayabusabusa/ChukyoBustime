//
//  ToDestinationModel.swift
//  
//
//  Created by Shunya Yamada on 2023/03/08.
//

import Combine
import Foundation
import ServiceProtocol
import Shared

protocol ToDestinationModelProtocol {
    /// バスの行き先.
    var destination: BusDestination { get }
    /// ロード中かどうかのフラグ.
    var isLoading: AnyPublisher<Bool, Never> { get }
    /// バスの時刻表データを取得する.
    func fetchBusTimes() async
}

final class ToDestinationModel: ToDestinationModelProtocol {
    let destination: BusDestination
    private let dateService: DateServiceProtocol
    private let fileService: FileServiceProtocol
    private let firestoreService: FirestoreServiceProtocol
    private let remoteConfigService: RemoteConfigServiceProtocol
    private let isLoadingSubject: CurrentValueSubject<Bool, Never>
    private let errorSubject: PassthroughSubject<Error, Never>

    var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }

    init(destination: BusDestination,
         dateService: DateServiceProtocol,
         fileService: FileServiceProtocol,
         firestoreService: FirestoreServiceProtocol,
         remoteConfigService: RemoteConfigServiceProtocol) {
        self.destination = destination
        self.dateService = dateService
        self.fileService = fileService
        self.firestoreService = firestoreService
        self.remoteConfigService = remoteConfigService
        self.isLoadingSubject = CurrentValueSubject<Bool, Never>(true)
        self.errorSubject = PassthroughSubject<Error, Never>()
    }

    func fetchBusTimes() async {
        defer {
            isLoadingSubject.send(false)
        }
        isLoadingSubject.send(true)

        do {
            let formattedDate = dateService.formatted(dateService.nowDate, format: "yyyy-MM-dd")
            let busDateRequest = BusDateRequest(date: formattedDate)
            let busDate = try await firestoreService.busDate(with: busDateRequest)

            let busTimesRequest = BusTimesRequest(diagram: busDate.diagram,
                                                  destination: destination,
                                                  second: dateService.nowTimeForSecond)
            let busTimes = try await firestoreService.busTimes(with: busTimesRequest)

            // キャッシュを保存する
            let cache = Cache(busDate: busDate,
                              busTimes: busTimes,
                              lastUpdatedDate: formattedDate)
            let data = try JSONEncoder().encode(cache)
            fileService.store(data: data, for: destination.rawValue)
        } catch {
            errorSubject.send(error)
        }
    }
}
