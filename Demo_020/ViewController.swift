//
//  ViewController.swift
//  Demo_020
//
//  Created by 鄭淳澧 on 2021/8/4.
//

import UIKit

/// 計算機頁面
class ViewController: UIViewController {
    
    // MARK: - Properties
    private var previousResult: Double = 0
    private var currentResult: Double = 0
    private var result: Double = 0
    private var operation: String = ""
    private var opCount: Int = 0
    private var equalCount: Int = 0
    private var stillTyping: Bool = false
    
    private var input: Double {
        get { Double(resultLabel.text!)! }
//        set { resultLabel.text = "\(newValue)" }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var allCleanedBtn: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        var one = "1"
//        var plus = "+"
//        var two = "2"
//        var result = 0
//        print(Int(one)!)
//        print(Int(two)!)
//        print(Double(one)!)
//        print(Double(two)!)
//        if plus == "+" {
//            result = Int(one)! + Int(two)!
//        }
//        print(result)
    }
    
    // MARK: - IBAction
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
    
    @IBAction func signChanged(_ sender: UIButton) {
        opCount = 0
        equalCount = 0
        stillTyping = false
        guard let text = resultLabel.text else { return }
        
        if !text.contains("＋"),
           !text.contains("−"),
           !text.contains("×"),
           !text.contains("÷"),
           !text.contains("%") {
            resultLabel.text = modifiedResult(from: -input)
            currentResult = input
        }
    }
    
    @IBAction func dotBtnPressed(_ sender: UIButton) {
        guard let text = resultLabel.text else { return }
        
        if !text.contains("."),
           !text.contains("＋"),
           !text.contains("−"),
           !text.contains("×"),
           !text.contains("÷"),
           !text.contains("%") {
            resultLabel.text! += sender.currentTitle!
        }
        print(sender.currentTitle!)
    }
    
    @IBAction func numsBtnPressed(_ sender: UIButton) {
        guard var text = resultLabel.text else { return }

        // 如果是一位數字且為 0，因要加上數字，所以先設為空
        if text.count == 1, text.first == "0" {
            text = ""
        }
        
        // List of special characters/operators
        let specialCharacters = ["", "＋", "−", "×", "÷", "%"]
        
        // 如果是空不能進來，不得加上數字，要直接等於數字
        if !specialCharacters.contains(text), opCount == 0 {
            
            if resultLabel.text!.count <= 13 {
                resultLabel.text! += sender.currentTitle!
                currentResult = input
                
            } else {
                resultLabel.text = "Err"
                let controller = UIAlertController(title: "警告",
                                                   message: "輸入有誤，請重新操作",
                                                   preferredStyle: .alert)
                let backAction = UIAlertAction(title: "返回", style: .cancel) { [weak self] (_) in
                    self?.allCleaned(self?.allCleanedBtn ?? UIButton())
                }
                controller.addAction(backAction)
                self.present(controller, animated: true, completion: nil)
            } 
            
        }
//        else if text != "",
//                  stillTyping {
//            resultLabel.text! += sender.currentTitle!
//            currentResult = input
//            print("數字尚未輸入完成")
//        }
        else {
            resultLabel.text = sender.currentTitle!
            currentResult = input
//            stillTyping = true
        }
               
        print(sender.currentTitle!)
    }
    
    @IBAction func equalBtnTapped(_ sender: UIButton) {
        equalCount += 1
        opCount = 0
        stillTyping = false
        
        switch equalCount {
        case 1:
            result = calculation(previousNum: previousResult, currentNum: currentResult)
            resultLabel.text = modifiedResult(from: result)

            previousResult = currentResult
            currentResult = result
        default:
            result = calculation(previousNum: currentResult, currentNum: previousResult)
            resultLabel.text = modifiedResult(from: result)

            currentResult = result
        }
        
//        if equalCount != 1 {
//            result = calculation(previousNum: currentResult, currentNum: previousResult)
//            resultLabel.text = modifiedResult(from: result)
//            currentResult = result
//        } else {
//            result = calculation(previousNum: previousResult, currentNum: currentResult)
//            resultLabel.text = modifiedResult(from: result)
//            previousResult = currentResult
//            currentResult = result
//        }
        
        print("按了 \(sender.currentTitle!) 運算 \(equalCount)次")
    }
    
    @IBAction func operatorBtnTapped(_ sender: UIButton) {
        equalCount = 0
        stillTyping = false
        let operatorString = sender.currentTitle!
        
        if operation == operatorString {
            opCount += 1
        } else {
            opCount = 0
        }
        
        switch opCount {
        case 0:
            resultLabel.text = operatorString
            
            operation = operatorString
            previousResult = currentResult
        default:
            result = calculation(previousNum: previousResult, currentNum: currentResult)
            resultLabel.text = modifiedResult(from: result)
            
            operation = operatorString
            previousResult = result
        }
        
//        if opCount != 0 {
//            result = calculation(previousNum: previousResult, currentNum: currentResult)
//            resultLabel.text = modifiedResult(from: result)
//            operation = operatorString
//            previousResult = result
//
//        } else {
//            resultLabel.text = operatorString
//            operation = operatorString
//            previousResult = currentResult
//        }
        
        print("按了 \(operatorString) 運算 \(opCount)次")
    }
    
    // MARK: - Private Methods
    private func calculation(previousNum: Double, currentNum: Double) -> Double {
        
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
    
    // 無條件捨去後若與自身相同，去掉小數位後顯示，否則直接顯示
    // 字串長度限縮為 13
    private func modifiedResult(from number: Double) -> String {
        var wantedText: String
        
        if floor(number) == number {
            wantedText = "\(Int(number))"
        } else {
            wantedText = "\(number)"
        }
        if wantedText.count >= 13 {
            wantedText = String(wantedText.prefix(13))
        }
        return wantedText
    }
    
    
    func test() {
        let arrays = ["0", "＋", "−", "×", "÷"]
        
        guard let text = resultLabel.text else { return }
        func checkOp() -> Bool {
            var doesntContain: Bool = false
            for array in arrays {
                if text != array {
                    doesntContain = true
                }
                return doesntContain
            }
            return false
        }
    }
    
}

