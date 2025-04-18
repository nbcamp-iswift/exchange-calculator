import Foundation
import Combine

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var action: PassthroughSubject<Action, Never> { get }
    var state: State { get }
}
