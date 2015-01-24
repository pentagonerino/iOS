//
//  CheckoutVC.swift
//  ios
//
//  Created by Jorge Izquierdo on 24/01/15.
//  Copyright (c) 2015 izqui. All rights reserved.
//

import Foundation


class CheckoutVC: UIViewController {
    
    var item: Item?
    let peertalker = Peertalker()
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var cardIO: CardIOView!
    @IBOutlet var buttonBuy: UIButton!
    @IBOutlet var precioLabel: UILabel!
    
    @IBOutlet var flipper: UIView!
    
    var peerChannel, serverChannel: PTChannel?
    
    var cardioshown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardIO.delegate = self
        self.cardIO.hideCardIOLogo = true
        self.cardIO.allowFreelyRotatingCardGuide = true
        
        self.cardIO.scanInstructions = ""
        self.cardIO.removeFromSuperview()
        self.preferredContentSize = CGSizeMake(646, 698)
        
        
        self.imageView.image = UIImage(named: "1\(self.item!.image)")
        self.precioLabel.text = "\(self.item!.price)€"
        self.author.text = self.item!.by
        self.name.text = self.item!.name
        
        self.setupUSB()
    }
    
    func setupUSB() {
        
        PIns.instance().cb = {
            s in
            if s == "connect" {
                self.author.text = "\(self.author.text!)."
            } else if s == "error" {
                self.author.text = "\(self.author.text!)_"
            } else {
                var comps = s.componentsSeparatedByString("/")
                
                var number = comps[2] as String
                var expiry = comps[3] as String
                self.success()
            }
        }
    }
    
    @IBAction func buy(sender: UIButton?) {
        
        if !cardioshown {
            self.cardIO = CardIOView(frame: CGRectMake(0, -self.flipper.frame.height, self.flipper.frame.width, self.flipper.frame.height*3))
            self.cardIO.delegate = self
            self.cardIO.hideCardIOLogo = true
            self.cardIO.allowFreelyRotatingCardGuide = true
            
            self.cardIO.scanInstructions = ""
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        UIView.setAnimationTransition(.FlipFromLeft, forView: self.flipper, cache: true)
        
        for s in self.flipper.subviews {
            s.removeFromSuperview()
        }
        
        self.flipper.addSubview((self.cardioshown) ? imageView : cardIO)
        
        self.cardioshown = !self.cardioshown
        UIView.commitAnimations()
    }
    
    func success() {
        self.imageView.frame = self.flipper.frame
        
    }
    
    func alert(text: String) {
        self.author.text = text
    }
}

extension CheckoutVC: CardIOViewDelegate {
    func cardIOView(cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        println("did scan")
        self.buy(nil)
        self.success()
    }
}