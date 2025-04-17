import UIKit

extension UITableView {
    func register(_ cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }
}
