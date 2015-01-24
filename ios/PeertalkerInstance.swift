//
//  PeertalkerInstance.swift
//  ios
//
//  Created by Jorge Izquierdo on 24/01/15.
//  Copyright (c) 2015 izqui. All rights reserved.
//

import Foundation

class PIns {
    let peertalker = Peertalker()
    init() {
        peertalker.setupWithCallback {
           s in
        }
    }
    
    class func instance() -> Peertalker {
        return ins__.peertalker
    }
}

let ins__: PIns = {
    return PIns()
}()