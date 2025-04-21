//
//  ViewModelProtocol.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/21/25.
//

import Foundation
import Combine

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var action: PassthroughSubject<Action, Never> { get }
    var state: State { get }
}
