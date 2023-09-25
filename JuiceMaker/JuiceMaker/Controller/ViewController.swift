//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

protocol DismissEditStoreViewDelegate: AnyObject {
  func updateData()
}

final class ViewController: UIViewController, DismissEditStoreViewDelegate {
  
  private let juiceMaker = JuiceMaker()
  
  @IBOutlet weak private var strawberryNumberLabel: UILabel!
  @IBOutlet weak private var bananaNumberLabel: UILabel!
  @IBOutlet weak private var pineappleNumberLabel: UILabel!
  @IBOutlet weak private var kiwiNumberLabel: UILabel!
  @IBOutlet weak private var mangoNumberLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNumberLabel()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is EditStoreViewController {
      guard let editStoreView = segue.destination as? EditStoreViewController else { return }
      sendData(view: editStoreView)
    }
  }
  
  func updateData() {
    setNumberLabel()
  }
  
  func setNumberLabel() {
    strawberryNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.strawberry))
    bananaNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.banana))
    pineappleNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.pineapple))
    kiwiNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.kiwi))
    mangoNumberLabel.text = String(juiceMaker.store.getNum(fruitName: Fruit.mango))
  }
  
  @IBAction private func juiceOrderButtonTapped(_ sender: UIButton) {
    guard let buttonName = sender.titleLabel?.text else { return }
    let juiceName = buttonName.split(separator: " ")[0]
    let message = juiceMaker.createJuice(type: String(juiceName))
    showAlert(message: message)
    setNumberLabel()
  }
  
  private func showAlert(message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
    let outOfStock = (message == "재료가 모자라요. 재고를 수정할까요?")
    
    if outOfStock {
      alert.addAction(UIAlertAction(title: "예", style: UIAlertAction.Style.default, handler: { [self] _ in
        guard let editStoreView = self.storyboard?.instantiateViewController(identifier: "editStoreView") as? EditStoreViewController else { return }
        editStoreView.modalTransitionStyle = .coverVertical
        editStoreView.modalPresentationStyle = .automatic
        sendData(view: editStoreView)
        self.present(editStoreView, animated: true, completion: nil)
      }))
    }
    
    alert.addAction(UIAlertAction(title: outOfStock ? "아니오" : "확인", style: UIAlertAction.Style.cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  private func sendData(view: EditStoreViewController) {
    view.strawberryValue = self.strawberryNumberLabel?.text
    view.bananaValue = self.bananaNumberLabel?.text
    view.pineappleValue = self.pineappleNumberLabel?.text
    view.kiwiValue = self.kiwiNumberLabel?.text
    view.mangoValue = self.mangoNumberLabel?.text
    view.delegate = self
  }
}
