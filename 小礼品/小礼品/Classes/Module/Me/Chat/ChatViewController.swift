//
//  ChatViewController.swift
//  小礼品
//
//  Created by 李莎鑫 on 2017/4/27.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

//MARK: 懒加载
    lazy var tableView:UITableView = { () -> UITableView in
        let view = UITableView(frame: CGRect.zero, style: .plain)
        view.separatorStyle = .none
        view.allowsSelection = false
        
        return view
    }()
//MARK: 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChatView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupChatViewSubView()
    }
//MARK: 私有方法
    private func setupChatView() {
        view.backgroundColor = SystemGlobalBackgroundColor
        view.addSubview(tableView)
    }
    
    private func setupChatViewSubView() {
        tableView.snp.makeConstraints { (make) in
           
        }
    }

}
