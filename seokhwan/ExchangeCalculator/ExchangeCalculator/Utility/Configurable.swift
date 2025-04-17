import UIKit

protocol Configurable { }

extension Configurable {
    func configure(_ block: (Self) -> Void) -> Self {
        block(self)

        return self
    }
}
