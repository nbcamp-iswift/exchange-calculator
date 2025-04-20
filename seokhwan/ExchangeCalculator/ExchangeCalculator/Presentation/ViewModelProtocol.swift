import Foundation
import RxRelay

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State

    var action: PublishRelay<Action> { get }
    var state: State { get }
}
