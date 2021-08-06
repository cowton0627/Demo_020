//
//  ViewController.swift
//  Demo_020
//
//  Created by 鄭淳澧 on 2021/8/4.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    var currentResult: Double = 0
    var previousResult: Double = 0
    var operation: String = ""
    var result: Double = 0
    var opCount: Int = 0
    var equalCount: Int = 0
    var stillTyping: Bool = false
    var input: Double {
        get { return Double(resultLabel.text!)! }
//        set {
//            resultLabel.text = "\(newValue)"
//        }
    }
    
    //無條件進位後若與自身相同, 代表後面無小數位的表達式較適合顯示, 否則直接顯示
    //字串長度限縮為14
    func resultPresented(from number: Double) -> String{
        var wantedText: String
        if floor(number) == number {
            wantedText = "\(Int(number))"
        }else {
            wantedText = "\(number)"
        }
        if wantedText.count >= 13 {
            wantedText = String(wantedText.prefix(13))
        }
        return wantedText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func allCleaned(_ sender: UIButton) {
        resultLabel.text = "0"
        currentResult = 0
        previousResult = 0
        operation = ""
        result = 0
        opCount = 0
        equalCount = 0
        stillTyping = false
    }
    
    @IBAction func lastDeleted(_ sender: UIButton) {
        resultLabel.text?.removeLast()
        if resultLabel.text?.isEmpty == true || resultLabel.text == "-" {
            resultLabel.text = "0"
        }
        currentResult = input
        print(sender.currentTitle!)
    }
    
    @IBAction func dotBtnPressed(_ sender: UIButton) {
        if !( resultLabel.text!.contains(".") ) {
            resultLabel.text! += sender.currentTitle!
        }
        print(sender.currentTitle!)
    }
    
    @IBAction func numsBtnPressed(_ sender: UIButton) {
        if resultLabel.text != "0" && resultLabel.text != "＋" && resultLabel.text != "−" && resultLabel.text != "×" && resultLabel.text != "÷" && opCount <= 1{
            if resultLabel.text!.count <= 13{
                resultLabel.text! += sender.currentTitle!
                    currentResult = input
                
            }else {
                resultLabel.text = "Err"
                let controller = UIAlertController(title: "警告", message: "返回後請按AC鍵清除", preferredStyle: .alert)
                let backAction = UIAlertAction(title: "返回", style: .cancel, handler: nil)
                controller.addAction(backAction)
                self.present(controller, animated: true, completion: nil)
                
            }
            
        }else if stillTyping == true {
            resultLabel.text! += sender.currentTitle!
            currentResult = input
            print("數字尚未輸入完成")
        }else {
            resultLabel.text = sender.currentTitle!
            currentResult = input
            stillTyping = true
        }
               
        
        
        print(sender.currentTitle!)
    }
    
    func calculation(previousNum: Double, currentNum: Double) -> Double {
        switch operation {
        case "＋": result = previousNum + currentNum
        case "−": result = previousNum - currentNum
        case "×": result = previousNum * currentNum
        case "÷": result = previousNum / currentNum
        case "%": result = previousNum / 100
        default: break
        }
        return result
    }
    
    @IBAction func signChanged(_ sender: UIButton) {
        opCount = 0
        equalCount = 0
        stillTyping = false
        resultLabel.text = "\(resultPresented(from: -input))"
        currentResult = input
    }
    
    @IBAction func equalBtnTapped(_ sender: UIButton) {
        equalCount += 1
        opCount = 0
        stillTyping = false
        if equalCount != 1 {
            result = calculation(previousNum: currentResult, currentNum: previousResult)
            resultLabel.text = "\(resultPresented(from: result))"
            currentResult = result
        }else {
            result = calculation(previousNum: previousResult, currentNum: currentResult)
            resultLabel.text = "\(resultPresented(from: result))"
            previousResult = currentResult
            currentResult = result
        }
        
        
        print("按了等於 \(equalCount)次")
    }
    
    @IBAction func operatorBtnTapped(_ sender: UIButton) {
        opCount += 1
        equalCount = 0
        stillTyping = false
        if opCount != 1 {
            result = calculation(previousNum: previousResult, currentNum: currentResult)
            operation = sender.currentTitle!
            previousResult = result
            resultLabel.text = "\(resultPresented(from: result))"

        }else {
            resultLabel.text = "\(sender.currentTitle!)"
            operation = sender.currentTitle!
            previousResult = currentResult
        }
        
        print(sender.currentTitle!)
        print("按了運算 \(opCount)次")
    }
    
    
}

