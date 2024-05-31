//
//  ConsultingPagingTableViewCell.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ConsultingPagingTableViewCell: UITableViewCell {
    static let id : String = "ConsultingPagingTableViewCell"
    //MARK: - UI Components
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    private let scoreLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setLayout()
    }
}
//MARK: - UI Layout
private extension ConsultingPagingTableViewCell {
    private func setLayout() {
        let view = contentView
        view.backgroundColor = .clear
        
        let totalView = UIView()
        totalView.backgroundColor = .white
        totalView.layer.cornerRadius = 15
        totalView.layer.masksToBounds = true
        totalView.addSubview(titleLabel)
        totalView.addSubview(dateLabel)
        totalView.addSubview(scoreLabel)
        view.addSubview(totalView)
        
        totalView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.bottom.equalToSuperview().inset(20)
        }
        scoreLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
//MARK: - UI Configure
extension ConsultingPagingTableViewCell {
    public func configure(model : CounselContent) {
        self.titleLabel.text = model.date
        self.scoreLabel.text = model.counselType
    }
}
