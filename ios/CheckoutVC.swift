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
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var author: UILabel!
    @IBOutlet var cardIO: CardIOView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardIO.delegate = self
        self.cardIO.hideCardIOLogo = true
    }
}

extension CheckoutVC: CardIOViewDelegate {
    func cardIOView(cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        println("did scan")
    }
}