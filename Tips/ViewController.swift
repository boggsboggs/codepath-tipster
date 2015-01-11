//
//  ViewController.swift
//  Tips
//
//  Created by John Boggs on 12/20/14.
//  Copyright (c) 2014 John Boggs. All rights reserved.
//

import UIKit


class ViewController: AbstractTipsterView {
    var backingCheckAmount = 0.0

    var backingTipAmount = 0.0
    var tipAmountSetByUser = false
    
    var backingTipPercentage = 0.0
    var tipPercentSetByUser = false
    
    var backingTotalAmount = 0.0
    var totalAmountSetByUser = false
    
    @IBOutlet weak var tipPercentage: UITextField!
    @IBOutlet weak var checkAmount: UITextField!
    @IBOutlet weak var tipAmount: UITextField!
    @IBOutlet weak var totalAmount: UITextField!
    
    @IBAction func checkAmountEditBegin(sender: AnyObject) {
        checkAmount.text = "$0.00"
        cancelEndEditingTimer()
    }
    
    @IBAction func checkAmountEditing(sender: AnyObject) {
        checkAmount.text = parseMoneyFieldInput(checkAmount.text).format("$%.2f")
        startEndEditingTimer()
    }
    
    @IBAction func checkAmountChanged(sender: AnyObject) {
        if self.checkAmount.text != "$0.00" {
            self.backingCheckAmount = self.parseMoneyFieldInput(self.checkAmount.text)
            
            var userWantsToSetPercent = self.tipAmountSetByUser && !self.tipPercentSetByUser
            if userWantsToSetPercent && self.backingCheckAmount != 0 {
                self.backingTipPercentage = 100 * self.backingTipAmount / self.backingCheckAmount
            } else {
                self.backingTipAmount = self.backingCheckAmount * self.backingTipPercentage / 100
            }
            
            self.backingTotalAmount = self.backingCheckAmount + self.backingTipAmount
        }
        self.renderInputs()
    }

    @IBAction func tipAmountEditingBegin(sender: AnyObject) {
        self.tipAmount.text = "$0.00"
        self.totalAmount.text = self.checkAmount.text
        cancelEndEditingTimer()
    }
    
    @IBAction func tipAmountChanged(sender: AnyObject) {
        if self.tipAmount.text != "$0.00" {
            self.backingTipAmount = self.parseMoneyFieldInput(self.tipAmount.text)
            if self.backingCheckAmount != 0 {
                self.backingTipPercentage = 100 * self.backingTipAmount / self.backingCheckAmount
            }
            self.backingTotalAmount = self.backingCheckAmount + self.backingTipAmount
            
            self.tipAmountSetByUser = true
        }
        self.renderInputs()
        startEndEditingTimer()
    }
    
    @IBAction func totalAmountEditingBegin(sender: AnyObject) {
        self.totalAmount.text = "$0.00"
        cancelEndEditingTimer()
    }
    
    @IBAction func totalAmountEditing(sender: AnyObject) {
        self.totalAmount.text = self.parseMoneyFieldInput(self.totalAmount.text).format("$%.2f")
        startEndEditingTimer()
    }
    
    @IBAction func totalAmountChanged(sender: AnyObject) {
        if self.totalAmount.text != "$0.00" {
            var newTotalAmount = self.parseMoneyFieldInput(self.totalAmount.text)
            self.backingTotalAmount = max(newTotalAmount, self.backingCheckAmount)
            self.backingTipAmount = self.backingTotalAmount - self.backingCheckAmount
            if self.backingCheckAmount != 0 {
                self.backingTipPercentage = 100 * self.backingTipAmount / self.backingCheckAmount
            }
            self.totalAmountSetByUser = true
        }
        self.renderInputs()
    }
    
    @IBAction func tipPercentEditingBegin(sender: AnyObject) {
        self.tipPercentage.text = "0%"
        cancelEndEditingTimer()
    }
    
    @IBAction func tipPercentEditing(sender: AnyObject) {
        var tipPercentageString = self.stripNonDecimalChars(self.tipPercentage.text)
        var tipPercentage = (tipPercentageString as NSString).doubleValue
        self.setTipPercentageText(tipPercentage)
        startEndEditingTimer()
    }
    
    @IBAction func tipPercentChanged(sender: AnyObject) {
        var tipPercentageString = self.tipPercentage.text
        
        let containsPercent = tipPercentageString.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "%"))
        if containsPercent == nil {
            tipPercentageString = tipPercentageString.substringToIndex(tipPercentageString.endIndex.predecessor())
        }
        
        tipPercentageString = self.stripNonDecimalChars(tipPercentageString)
        if self.tipPercentage.text != "0%" {
            self.backingTipPercentage = (tipPercentageString as NSString).doubleValue
        }
        self.updateFromTipPercentChanged()
    }
    
    @IBAction func incrementTipPercentage(sender: AnyObject) {
        self.backingTipPercentage = Double(floor(self.backingTipPercentage + 1))
        self.updateFromTipPercentChanged()
    }
    
    @IBAction func decrementTipPercentage(sender: AnyObject) {
        self.backingTipPercentage = Double(ceil(self.backingTipPercentage - 1))
        self.updateFromTipPercentChanged()
    }
    
    func setTipPercentageText(value: Double) {
        var oneDecimalTipPercent = round(value * 10) / 10
        self.tipPercentage.text = oneDecimalTipPercent.format("%g%%")
    }
    
    func parseMoneyFieldInput (rawInput: String) -> Double {
        var decimalString = self.stripNonDecimalChars(rawInput) as NSString
        return decimalString.doubleValue / (100 as Double)
    }
    
    func updateFromTipPercentChanged() {
        self.backingTipAmount = self.backingCheckAmount * self.backingTipPercentage / 100
        self.backingTotalAmount = self.backingCheckAmount + self.backingTipAmount
        
        self.tipPercentSetByUser = true
        self.renderInputs()
    }
    
    func renderInputs() {
        self.setTipPercentageText(self.backingTipPercentage)
        self.checkAmount.text = self.backingCheckAmount.format("$%.2f")
        self.tipAmount.text = self.backingTipAmount.format("$%.2f")
        self.totalAmount.text = self.backingTotalAmount.format("$%.2f")
    }
    
    
    // View Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper.jpg")!)
        
        self.renderInputs()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentage = defaults.doubleForKey("default_tip_percentage")
        let defaultTipPercentageChanged = defaults.boolForKey("default_tip_percentage_changed")
        let state_save_time = defaults.integerForKey("state_save_time")
        let three_hours = 60 * 60 * 3

        if (state_save_time + three_hours > NSDate().toEpoch()) {
            backingTipPercentage = defaults.doubleForKey("tip_percentage")
            backingCheckAmount = defaults.doubleForKey("check_amount")
        } else {
            backingTipPercentage = defaultTipPercentage
            backingCheckAmount = 0.0
        }
        
        if (defaultTipPercentageChanged) {
            backingTipPercentage = defaultTipPercentage
            defaults.setBool(false, forKey:"default_tip_percentage_changed")
        }

        updateFromTipPercentChanged()
    }

    override func viewDidDisappear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(backingCheckAmount, forKey:"check_amount")
        defaults.setDouble(backingTipPercentage, forKey: "tip_percentage")
        defaults.setInteger(NSDate().toEpoch(), forKey: "state_save_time")
        defaults.synchronize()
    }
}

