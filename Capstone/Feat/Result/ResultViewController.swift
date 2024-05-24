//
//  ResultViewController.swift
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

final class ResultViewController : UIViewController {
    private let disposeBag = DisposeBag()
    //MARK: - UI Components
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "분석 완료!"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let decLabel : UITextView = {
        let label = UITextView()
        label.text = "심리분석 결과에 맞는 상담사가 생성되었습니다."
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    private let chatBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle(" 상담 받아보기 ➜", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setImage(UIImage(named: "Chat"), for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.backgroundColor = .clear
        return btn
    }()
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Result")
        view.clipsToBounds = true
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}
//MARK: - UI Layout
private extension ResultViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.view.addSubview(titleLabel)
        self.view.addSubview(decLabel)
        self.view.addSubview(chatBtn)
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
        chatBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(decLabel.snp.bottom).offset(0)
            make.height.equalTo(30)
        }
        image.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(30)
            make.top.equalTo(chatBtn.snp.bottom).offset(100)
            make.height.equalTo(250)
        }
    }
}
