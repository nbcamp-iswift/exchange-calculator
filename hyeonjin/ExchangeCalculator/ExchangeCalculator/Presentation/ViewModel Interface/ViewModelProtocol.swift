//
//  ViewModelProtocol.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype Mutation
    associatedtype State

    var state: BehaviorRelay<State> { get }
    var action: PublishRelay<Action> { get }

    func mutate(action: Action) -> Observable<Mutation>
    func reduce(state: State, mutation: Mutation) -> State
}
