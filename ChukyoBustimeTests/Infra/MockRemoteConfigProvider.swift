//
//  MockRemoteConfigProvider.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/13.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift

final class MockRemoteConfigProvider: RemoteConfigProviderProtocol {
    private let isErrorOccured: Bool
    
    init(isErrorOccured: Bool = false) {
        self.isErrorOccured = isErrorOccured
    }

    func fetchAndActivate() -> Completable {
        return Completable.create { observer in
            observer(self.isErrorOccured
                        ? .error(MockError.somethingWentWrong)
                        : .completed)
            return Disposables.create()
        }
    }
    
    func getConfigValue<T: RemoteConfigType>(for key: RemoteConfigProvider.Key, configType: T.Type) -> Single<T> {
        return Single.create { observer in
            // NOTE: `.success()` 時に流している Entity は、RemoteConfig にオブジェクトが増えたときに変更が必要
            observer(self.isErrorOccured
                        ? .failure(MockError.somethingWentWrong)
                        : .success(Stub.pdfURLEntity as! T))
            return Disposables.create()
        }
    }
}
