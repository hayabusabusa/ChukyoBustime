//
//  DiagramViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class DiagramViewModel {
    
    // MARK: Dependency
    
    typealias Dependency = Driver<String>
    
    let dependency: Dependency
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension DiagramViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    // MARK: Transform I/O
    
    func transform(input: DiagramViewModel.Input) -> DiagramViewModel.Output {
        return Output()
    }
}
