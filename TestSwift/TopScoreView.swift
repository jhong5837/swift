//
//  TopScoreView.swift
//  TestSwift
//
//  Created by XNIOS on 2018/8/30.
//  Copyright © 2018年 cxy. All rights reserved.
//  游戏分数

import UIKit

class TopScoreView: UIView {
    var scoreLabel: UILabel?;
    var tipLabel: UILabel?;
    var bestScore: UILabel?;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setupSubviews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func setupSubviews() -> Void {
        self.backgroundColor = UIColor.green; 
        
        self.scoreLabel = UILabel();
        self.scoreLabel?.font = UIFont(name: "Helvetica Neue", size: 50);
        self.scoreLabel?.textAlignment = .center;
        self.scoreLabel?.textColor = UIColor.white;
        self.scoreLabel?.text = "0分";
        self.addSubview(self.scoreLabel!);
        
        self.tipLabel = UILabel();
        self.tipLabel?.font = UIFont(name: "Helvetica Neue", size: 30);
        self.tipLabel?.textAlignment = .center;
        self.tipLabel?.textColor = UIColor.white;
        self.tipLabel?.text = "Game Over!";
        self.tipLabel?.isHidden = true;
        self.addSubview(self.tipLabel!);
        
        self.bestScore = UILabel();
        self.bestScore?.font = UIFont(name: "Helvetica Neue", size: 18);
        self.bestScore?.textAlignment = .right;
        self.bestScore?.textColor = UIColor.red;
        self.addSubview(self.bestScore!);
        
        let best = UserDefaults.standard.integer(forKey: "CurrentScore");
        self.bestScore?.text = "Best:\(best)分";
        
        self.scoreLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.snp.centerY).offset(-15);
        });
        
        self.tipLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.snp.centerY).offset(60);
        });
        
        self.bestScore?.snp.makeConstraints({ (make) in
            make.bottom.equalTo((self.scoreLabel?.snp.bottom)!);
            make.right.equalTo(self.snp.right).offset(-20);
        });
    }
    
    func gameOver(_ score: Int) -> Void {
        self.tipLabel?.isHidden = false;
        
        let userDefault = UserDefaults.standard
        let best = userDefault.integer(forKey: "CurrentScore");
        
        if best < score {
            self.bestScore?.text = "Best:\(score)分";
            
            // 存储当前的分数
            userDefault.set(score, forKey: "CurrentScore");
            userDefault.synchronize();
        }
    }
    
    func startGame() -> Void {
        self.tipLabel?.isHidden = true;
    }
}
