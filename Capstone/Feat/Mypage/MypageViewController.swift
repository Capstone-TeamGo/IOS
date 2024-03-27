//
//  MypageViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices
class MypageViewController: UIViewController{
    //MARK: UI Components
    //분석 버튼
    private let analyzeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon1"), for: .normal)
        btn.backgroundColor = .clear
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    //상담 버튼
    private let consultingBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon2"), for: .normal)
        btn.backgroundColor = .clear
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    //과거 기록 버튼
    private let recordBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon4"), for: .normal)
        btn.backgroundColor = .clear
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    //추천 버튼
    private let recommandBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon3"), for: .normal)
        btn.backgroundColor = .clear
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
}
//MARK: - UI Layout
extension MypageViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(analyzeBtn)
        self.view.addSubview(consultingBtn)
        self.view.addSubview(recordBtn)
        self.view.addSubview(recommandBtn)
        
        analyzeBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(30)
            make.height.equalTo(198)
            make.width.equalTo(150)
        }
        consultingBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(180)
            make.top.equalTo(analyzeBtn.snp.bottom).offset(10)
        }
        recordBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(30)
            make.height.equalTo(91)
            make.leading.equalTo(analyzeBtn.snp.trailing).offset(10)
        }
        recommandBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(91)
            make.top.equalTo(recordBtn.snp.bottom).offset(10)
        }
    }
}
