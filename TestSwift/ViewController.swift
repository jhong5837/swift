//
//  ViewController.swift
//  TestSwift
//
//  Created by XNIOS on 2018/8/27.
//  Copyright © 2018年 cxy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let bottomView = BottomLawnView();
    let topView = TopScoreView();
    let gameView = GameCenterView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化控件
        self.setupSubviews();
        
        // 操作
        self.action();
    }
    
    // 初始化界面
    func setupSubviews() -> Void {
        // 草坪
        let bw = self.view.bounds.size.width;
        let bh = 200;
        let bx = 0;
        let by = self.view.bounds.size.height - CGFloat(bh);
        self.bottomView.frame = CGRect(x: CGFloat(bx), y: by, width: bw, height: CGFloat(bh));
        self.view.addSubview(self.bottomView);
        
        // 天空、分数显示区
        let tw = bw;
        let th = bh;
        let tx = 0;
        let ty = 0;
        self.topView.frame = CGRect(x: CGFloat(tx), y: CGFloat(ty), width: tw, height: CGFloat(th));
        self.view.addSubview(self.topView);
        
        // 游戏控制区
        let cw = bw;
        let ch = self.view.bounds.size.height - CGFloat(bh + th);
        let cx = 0;
        let cy = th;
        self.gameView.frame = CGRect(x: CGFloat(cx), y: CGFloat(cy), width: cw, height: ch);
        self.view.addSubview(self.gameView);
    }
    
    // 操作
    func action() -> Void {
        // 开始游戏
        self.bottomView.start = {
            self.gameView.startGame();
            self.topView.startGame();
        };
        
        self.gameView.gameScore = {
            (score: Int) -> () in self.topView.scoreLabel?.text = "\(score)分";
        };
        
        self.gameView.gameOverBlock = {
            (score: Int) -> () in self.bottomView.gameOver();
            self.topView.gameOver(score);
        };
    }
}

