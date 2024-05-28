//
//  ErrorViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/28.
//

import Foundation
import SnapKit
import UIKit

final class ErrorViewController : UIViewController {
    //MARK: - UI Components
    private let errorView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = UIImage(named: "Error")
        view.contentMode = .scaleAspectFit
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .white
    }
}
//MARK: - UI Layout
private extension ErrorViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(errorView)
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
