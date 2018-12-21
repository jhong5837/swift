//
//  BottomLawnView.swift
//  TestSwift
//
//  Created by XNIOS on 2018/8/30.
//  Copyright © 2018年 cxy. All rights reserved.
//  底部草坪

import UIKit
import SnapKit

class BottomLawnView: UIView {
    var start: (() -> ())?;
    var startBtn: UIButton!;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setupSubviews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func setupSubviews() -> Void {
        self.backgroundColor = UIColor.green;
        
        // 添加开始按钮
        self.startBtn = UIButton();
        self.startBtn.backgroundColor = UIColor.clear;
        self.startBtn.addTarget(self, action: #selector(startGrame(_:)), for: .touchUpInside);
        self.startBtn.setImage(UIImage(named: "start"), for: .normal);
        self.addSubview(self.startBtn);
        self.startBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(60);
            make.center.equalTo(self);
        }
    }
    
    // 开始游戏
    @objc func startGrame(_ btn: UIButton) -> Void {
        if start != nil {
            start!();
        }
        
        self.startBtn.isHidden = true;
    }
    
    // 从新开始游戏
    func restartGame() -> Void {
        self.startGrame(self.startBtn);
    }
    
    // 游戏结束
    func gameOver() -> Void {
        self.startBtn.isHidden = false;
        self.startBtn.setImage(UIImage(named: "restart"), for: .normal);
    }
}
