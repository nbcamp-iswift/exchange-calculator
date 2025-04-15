import UIKit

class TableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"

    var label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttributes()
        addContentView()
        setConstraints()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setAttributes() {}

    private func addContentView() {
        contentView.addSubview(label)
    }

    private func setConstraints() {
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(10) // 10
        }
    }
}
