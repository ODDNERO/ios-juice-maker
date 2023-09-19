//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
  
  let juiceMaker = JuiceMaker()
  
  @IBOutlet weak var strawberryNumberLabel: UILabel!
  @IBOutlet weak var bananaNumberLabel: UILabel!
  @IBOutlet weak var pineappleNumberLabel: UILabel!
  @IBOutlet weak var kiwiNumberLabel: UILabel!
  @IBOutlet weak var mangoNumberLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNumberLabel()
  }
  
  @IBAction func juiceOrderButtonTapped(_ sender: UIButton) {
    let tag = sender.tag
    
    guard let buttonName = sender.titleLabel?.text else { return }
    let juiceName = buttonName.split(separator: " ")[0]
    let (message, type) = juiceMaker.createJuice(type: tag, juiceName: String(juiceName))
    showAlert(message: message, type: type)
    setNumberLabel()
  }
  
  func showAlert(message: String, type: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
    if type == "oneButton" {
      alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
    } else {
      alert.addAction(UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: { _ in
        guard let editStoreView = self.storyboard?.instantiateViewController(identifier: "editStoreView") else { return }
        editStoreView.modalTransitionStyle = .coverVertical
        editStoreView.modalPresentationStyle = .automatic
        self.present(editStoreView, animated: true, completion: nil)
      }))
      alert.addAction(UIAlertAction(title: "아니오", style: UIAlertAction.Style.cancel, handler: nil))
    }
    self.present(alert, animated: true, completion: nil)
  }
  
  func setNumberLabel() {
    strawberryNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.strawberry))
    bananaNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.banana))
    pineappleNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.pineapple))
    kiwiNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.kiwi))
    mangoNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.mango))
  }
}

