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

// MARK: Protocols

protocol DiagramViewModelInputs {
    
}

protocol DiagramViewModelOutputs {
    var diagramName: Driver<String> { get }
}

protocol DiagramViewModelType {
    var input: DiagramViewModelInputs { get }
    var output: DiagramViewModelOutputs { get }
}

// MARK: ViewModel

final class DiagramViewModel: DiagramViewModelInputs, DiagramViewModelOutputs {
    
    // MARK: Dependency
    
    struct Dependency {
        let diagramNameDriver: Driver<String>
    }
    let dependency: Dependency
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    var diagramName: Driver<String> {
        return dependency.diagramNameDriver
    }
    
    // MARK: Initializer
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension DiagramViewModel: DiagramViewModelType {
    var input: DiagramViewModelInputs { return self }
    var output: DiagramViewModelOutputs { return self }
}
