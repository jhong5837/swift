//
//  GameCenterView.swift
//  TestSwift
//
//  Created by XNIOS on 2018/8/30.
//  Copyright © 2018年 cxy. All rights reserved.
//  游戏中心

import UIKit

class GameCenterView: UIView, UIDynamicAnimatorDelegate {
    var sh : CGFloat = 0.0;
    var sw : CGFloat = 0.0;
    
    var animator = UIDynamicAnimator();
    var tapDisplayLink: CADisplayLink!;
    var pillarDisplayLink: CADisplayLink!;
    
    // 上下柱子间隙
    let gap : Float = 80.0;
    
    // 小鸟的宽度
    let birdW : Float = 30;
    
    // 柱子的宽度
    let pillarW : Float = 25;
    
    // 存放所有生成的柱子
    var pillarArr : Array<UIView> = Array();
    
    // 小鸟
    var bird : UIView?;
    
    // 分数
    var score : Int = 0;
    
    var isGameOver = false;
    
    var gameScore: ((Int) -> ())?;
    var gameOverBlock: ((Int) -> ())?;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.setupSubviews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func setupSubviews() -> Void {
        
    }
    
    // 开始游戏
    func startGame() -> Void {
        for pillar in self.pillarArr {
            pillar.removeFromSuperview();
        }
        self.pillarArr.removeAll();
        self.bird?.removeFromSuperview();
        self.isGameOver = false;
        self.score = 0;
        
        if (self.gameScore != nil) {
            self.gameScore!(0);
        }
        
        if self.tapDisplayLink != nil {
            self.tapDisplayLink.isPaused = true
        }
        
        if self.pillarDisplayLink != nil {
            self.pillarDisplayLink.isPaused = true
        }
        
        self.addPillar();
        
        self.addActionForBird();
    }
    
    // 添加柱子
    func addPillar() -> Void {
        self.sh = self.bounds.size.height;
        self.sw = self.bounds.size.width;
        
        var x : Float = Float(self.sw);
        let w : Float = self.pillarW;
        
        for _ in 1...6 {
            self.createPillar(x: x, w: w)
            x += (self.gapRandom() + w);
        }
        
        // 添加小鸟
        self.addBird();
        
        // 开始移动
        self.startMovePillar();
    }
    
    // 添加一只小鸟
    func addBird() -> Void {
        self.bird = UIView();
        self.bird!.backgroundColor = UIColor.clear;
        self.bird!.bounds = CGRect(x: 0, y: 0, width: CGFloat(self.birdW), height: CGFloat(self.birdW));
        self.bird!.center = CGPoint(x: 100, y: self.sh * 0.5);
        self.addSubview(self.bird!);
        
        let bi = UIImageView();
        bi.frame = self.bird!.bounds;
        bi.image = UIImage(named: "icon_bird");
        bi.contentMode = .scaleAspectFit;
        self.bird?.addSubview(bi);
    }
    
    // 给小鸟添加自由落体运动
    func addActionForBird() -> Void {
        if let dynamicView = self.bird {
            animator = UIDynamicAnimator(referenceView: self);
            animator.delegate = self;
            
            let gravityBeahvior = UIGravityBehavior(items: [dynamicView]);
            gravityBeahvior.magnitude = 0.3;
            animator.addBehavior(gravityBeahvior);
            
            let colission = UICollisionBehavior(items: [dynamicView])
            colission.translatesReferenceBoundsIntoBoundary = true
            colission.collisionMode = .everything
            animator.addBehavior(colission)
            
            let itemBehavior = UIDynamicItemBehavior(items: [dynamicView])
            itemBehavior.elasticity = 0.4
            animator.addBehavior(itemBehavior)
        }
    }
    
    // 创建并添加柱子
    func createPillar(x : Float, w : Float) -> Void {
        // 1.创建顶部柱子
        let topPillar = UIImageView();
        topPillar.backgroundColor = .clear;
        topPillar.contentMode = .scaleToFill;
        var ti = UIImage(named: "pillar_up");
        ti = ti?.stretchableImage(withLeftCapWidth: 0, topCapHeight: Int(ti!.size.height * 0.8));
        topPillar.image = ti;
        
        // 2.创建底部柱子
        let bottomPillar = UIImageView()
        bottomPillar.backgroundColor = .clear;
        bottomPillar.contentMode = .scaleToFill;
        var bi = UIImage(named: "pillar_down");
        bi = bi?.stretchableImage(withLeftCapWidth: 0, topCapHeight: Int(bi!.size.height * 0.2));
        bottomPillar.image = bi;
        
        // 3.设置柱子的尺寸
        let tx = x;
        let ty = 0;
        let tw = w;
        let th = self.pillarRandomHeight();
        topPillar.frame = CGRect(x: CGFloat(tx), y: CGFloat(ty), width: CGFloat(tw), height: CGFloat(th));
        
        let bx = tx;
        let by = th + gap;
        let bw = tw;
        let bh = self.sh - CGFloat(by);
        bottomPillar.frame = CGRect(x: CGFloat(bx), y: CGFloat(by), width: CGFloat(bw), height: CGFloat(bh));
        
        // 4.添加到view
        self.addSubview(topPillar);
        self.addSubview(bottomPillar);
        
        // 5.添加到集合中
        self.pillarArr.append(topPillar);
        self.pillarArr.append(bottomPillar);
    }
    
    // 随机高度
    func pillarRandomHeight() -> Float {
        let r = Float(arc4random()) / 0xFFFFFFFF;
        let min : Float = 20;
        let max : Float = Float(self.sh) - 2 * min - self.gap;
        
        return r * (max - min + 1) + min;
    }
    
    // 随机距离
    func gapRandom() -> Float {
        let r = Float(arc4random()) / 0xFFFFFFFF;
        let max : Float = (Float(self.sw) - 3 * self.pillarW) / 2;
        let min : Float = (Float(self.sw) - 5 * self.pillarW) / 2;
        
        return r * (max - min + 1) + min;
    }
    
    // 开始移动
    func startMovePillar() -> Void {
        // 创建定时器
        if self.pillarDisplayLink != nil {
            self.pillarDisplayLink.isPaused = false;
        } else {
            self.pillarDisplayLink = CADisplayLink.init(target: self, selector: #selector(moveOnePillar(_:)));
            self.pillarDisplayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode);
        }
    }
    
    // 移动一根柱子
    @objc func moveOnePillar(_ displayLink : CADisplayLink) -> Void {
        var endArr : Array<UIView> = Array();
        
        // 遍历所有柱子
        var scoreArr : Array<UIView> = Array();
        
        for pillar in self.pillarArr {
            var frame = pillar.frame;
            let w = frame.size.width;
            
            // 判断是否有碰撞
            let isC = self.bird?.frame.intersects(frame);
            if isC! {
                self.gameOver();
                self.endFly();
                return;
            }
            
            // 判断柱子的x坐标是否为0
            if frame.origin.x + w <= 0 {
                endArr.append(pillar);
            } else {
                // 移动柱子
                frame.origin.x -= 0.5;
                pillar.frame = frame;
            }
            
            // 判断是否移动过小鸟
            if Float(frame.origin.x + w) <= (100 - self.birdW * 0.5) {
                if pillar.tag != 88 {
                    scoreArr.append(pillar);
                    pillar.tag = 88;
                }
            }
        }
        
        if endArr.count > 0 {
            // 销毁柱子
            for pillar in endArr {
                pillar.removeFromSuperview();
                
                if let index = self.pillarArr.index(of: pillar) {
                    self.pillarArr.remove(at: index);
                }
            }
            
            // 在末尾添加一根新柱子
            let lastPillar = self.pillarArr.last;
            if (lastPillar != nil) {
                let frame = lastPillar?.frame;
                let x : CGFloat! = frame?.origin.x;
                let w : CGFloat! = frame?.size.width;
                
                self.createPillar(x: (Float(x) + self.gapRandom() + Float(w)), w: Float(w))
            }
        }
        
        if scoreArr.count > 0 {
            self.score += (scoreArr.count / 2)
            
            // 显示分数
            if self.gameScore != nil {
                self.gameScore!(self.score);
            }
        }
        
        // 如果超过边界就结束
        if (self.bird?.frame.origin.y)! < CGFloat(0.0) {
            self.gameOver();
            self.endFly();
        }
        
        if ((self.bird?.frame.origin.y)! + CGFloat(self.birdW)) >= CGFloat(self.sh - 1) {
            self.gameOver();
            
            if self.tapDisplayLink != nil {
                self.tapDisplayLink.isPaused = true;
            }
        }
    }
    
    func startFly() -> Void {
        if self.tapDisplayLink != nil {
            self.tapDisplayLink.isPaused = false;
        } else {
            self.tapDisplayLink = CADisplayLink.init(target: self, selector: #selector(fly));
            self.tapDisplayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode);
        }
    }
    
    @objc func fly() -> Void {
        if var frame = self.bird?.frame {
            frame.origin.y -= 3;
            self.bird?.frame = frame;
            
            if self.isGameOver == false {
                self.animator.removeAllBehaviors();
            }
        }
    }
    
    func endFly() -> Void {
        if self.tapDisplayLink != nil {
            self.tapDisplayLink.isPaused = true;
        }
        
        self.addActionForBird();
    }
    
    // Game Over
    func gameOver() -> Void {
        print("GameOver==>\(self.score)");
        self.isGameOver = true;
        
        // 显示分数
        if self.gameScore != nil {
            self.gameScore!(self.score);
        }
        
        // 柱子停止移动
        if self.pillarDisplayLink != nil {
            self.pillarDisplayLink.isPaused = true;
        }
        
        if self.gameOverBlock != nil {
            self.gameOverBlock!(self.score);
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isGameOver == false {
            self.startFly();
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isGameOver == false {
            self.endFly();
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isGameOver == false {
            self.endFly();
        }
    }
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {

    }
}
