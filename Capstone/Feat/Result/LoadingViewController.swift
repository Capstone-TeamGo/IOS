//
//  LoadingViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/28.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher
import UIKit

class LoadingViewController : UIViewController {
    private let disposeBag = DisposeBag()
    //MARK: - UI Components
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "저장 완료!"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let decLabel : UITextView = {
        let label = UITextView()
        label.text = "@@님의 답변을 토대로 심리 분석중입니다.\n분석이 완료되면 자동으로 페이지가 넘어갑니다."
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let image : AnimatedImageView = {
        let view = AnimatedImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
}
//MARK: - UI Layout
extension LoadingViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.view.addSubview(titleLabel)
        self.view.addSubview(decLabel)
        self.view.addSubview(image)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
            make.top.equalToSuperview().inset(self.view.frame.height / 10)
        }
        decLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        image.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(0)
            make.top.equalTo(decLabel.snp.bottom).offset(0)
            make.leading.equalToSuperview().offset(30)
        }
        if let gifUrl = Bundle.main.url(forResource: "confetti", withExtension: "gif") {
            image.kf.setImage(with: gifUrl)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigationController?.pushViewController(ResultViewController(), animated: true)
        }
    }
}
