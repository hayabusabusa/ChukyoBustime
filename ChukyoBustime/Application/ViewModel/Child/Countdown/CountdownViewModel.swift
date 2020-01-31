//
//  CountdownViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class CountdownViewModel {
    
    // MARK: Dependency
    
    typealias Dependency = (destination: Destination, busTimesDriver: Driver<[BusTime]>)
    
    let dependency: Dependency
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension CountdownViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: Transform I/O
    
    func transform(input: CountdownViewModel.Input) -> CountdownViewModel.Output {
        return Output()
    }
}
