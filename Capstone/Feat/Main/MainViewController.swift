//
//  MainViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices
import Charts
import DGCharts
class MainViewController: UIViewController{
    private let disposeBag = DisposeBag()
    //MARK: UI Components
    //분석 버튼
    private lazy var analyzeBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon1"), for: .normal)
        btn.backgroundColor = .ThirdryColor
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(analyzeBtnTapped), for: .touchUpInside)
        return btn
    }()
    //상담 버튼
    private lazy var consultingBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon2"), for: .normal)
        btn.backgroundColor = .FourthryColor
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        return btn
    }()
    //과거 기록 버튼
    private lazy var recordBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon4"), for: .normal)
        btn.backgroundColor = .SecondaryColor
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        return btn
    }()
    //추천 버튼
    private lazy var recommandBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "mainIcon3"), for: .normal)
        btn.backgroundColor = .FifthryColor
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 20
        btn.layer.masksToBounds = true
        return btn
    }()
    //차트
    private let Chart : BarChartView = {
        let view = BarChartView()
        view.backgroundColor = .clear
        view.xAxis.drawGridLinesEnabled = false
        view.leftAxis.drawGridLinesEnabled = false
        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setchart()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
}
//MARK: - UI Layout
extension MainViewController {
    private func setLayout() {
        self.view.backgroundColor = .white
        self.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.view.addSubview(analyzeBtn)
        self.view.addSubview(consultingBtn)
        self.view.addSubview(recordBtn)
        self.view.addSubview(recommandBtn)
        self.view.addSubview(Chart)
        analyzeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(self.view.frame.height / 10)
            make.height.equalToSuperview().dividedBy(3.5)
            make.width.equalToSuperview().dividedBy(2.5)
            make.leading.equalToSuperview().inset(30)
        }
        consultingBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalToSuperview().dividedBy(4.5)
            make.top.equalTo(analyzeBtn.snp.bottom).offset(10)
        }
        recordBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(self.view.frame.height / 10)
            make.height.equalTo(analyzeBtn.snp.height).dividedBy(2).inset(2.5)
            make.leading.equalTo(analyzeBtn.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(30)
        }
        recommandBtn.snp.makeConstraints { make in
            make.height.equalTo(analyzeBtn.snp.height).dividedBy(2).inset(2.5)
            make.top.equalTo(recordBtn.snp.bottom).offset(10)
            make.leading.equalTo(recordBtn.snp.leading).inset(0)
            make.trailing.equalToSuperview().inset(30)
        }
        Chart.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(consultingBtn.snp.bottom).offset(30)
            make.bottom.equalToSuperview().inset(self.view.frame.height / 10)
        }
    }
    private func setchart() {
        var entries = [BarChartDataEntry]()
        entries.append(BarChartDataEntry(x: 0, y: 10))
        entries.append(BarChartDataEntry(x: 1, y: 20))
        entries.append(BarChartDataEntry(x: 2, y: 30))
        
        let dataSet = BarChartDataSet(entries: entries, label: "한달 간 심리분석 결과")
        dataSet.colors = [UIColor.ThirdryColor, UIColor.FourthryColor, UIColor.FifthryColor]
        Chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["행복", "우울", "슬픔"])
        Chart.xAxis.setLabelCount(3, force: false)
        Chart.xAxis.labelPosition = .top
        Chart.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        Chart.animate(yAxisDuration: 1.5)
        
        let data = BarChartData(dataSet: dataSet)
        data.setValueTextColor(.black)
        data.setValueFont(UIFont.systemFont(ofSize: 12))
        
        Chart.data = data
    }
}
//MARK: - set Binding
extension MainViewController {
    private func setBinding() {
        
    }
    @objc func analyzeBtnTapped() {
        self.navigationController?.pushViewController(FirstQuestionViewController(), animated: true)
    }
}
