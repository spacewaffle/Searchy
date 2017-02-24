//
//  ViewController.swift
//  Searchy
//
//  Created by Jon on 2/24/17.
//  Copyright © 2017 Jon. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.label.text = "loaded label"
        
        let buttonTap = self.button.rx.tap.asDriver()
        
        buttonTap.drive(
            onNext: { x in
                self.label.text = "button was tapped!"
                
            }
        ).addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

