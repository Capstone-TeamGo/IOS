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
    private let disposeBag = DisposeBag()
    //MARK: UI Components
    private let naviImage : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .white
        image.image = UIImage(named: "appIcon")
        return image
    }()
    //개인 정보 텍스트
    private let personText : UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        view.text = "김승진"
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setLayout()
    }
}
//MARK: - UI Navigation
extension MypageViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.hidesBackButton = false
    }
    private func setNavigation() {
        self.title = "마이페이지"
        self.view.backgroundColor = .white
        self.navigationItem.titleView = naviImage
        self.navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - UI Layout
extension MypageViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(personText)
        
        personText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().inset(self.view.frame.height / 8)
            make.height.equalToSuperview().dividedBy(3)
        }
    }
}
