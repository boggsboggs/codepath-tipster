//
//  SettingsView.swift
//  Tips
//
//  Created by John Boggs on 1/10/15.
//  Copyright (c) 2015 John Boggs. All rights reserved.
//

import UIKit


class SettingsView: AbstractTipsterView {
    @IBOutlet weak var defaultTipPercentage: UITextField!
    
    var backingDefaultTipPercentage = 0.0
    
    func parseTipPercentage(tipPercentageInput: String) -> Double {
        return tipPercentageInput.doubleValue()
    }
    
    @IBAction func tipPercentEditingBegin(sender: AnyObject) {
        self.defaultTipPercentage.text = "0%"
    }
    
    @IBAction func tipPercentEditing(sender: AnyObject) {
        var tipPercentageString = self.stripNonDecimalChars(self.defaultTipPercentage.text)
        if (defaultTipPercentage.text != "0%") {
            backingDefaultTipPercentage = tipPercentageString.doubleValue()
        }
        renderInputs()
        startEndEditingTimer()
    }
    
    func setTipPercentageText(value: Double) {
        var oneDecimalTipPercent = round(value * 10) / 10
        defaultTipPercentage.text = oneDecimalTipPercent.format("%g%%")
    }
    
    func renderInputs() {
        setTipPercentageText(backingDefaultTipPercentage)
    }
    
    @IBAction func morePressed(sender: AnyObject) {
        backingDefaultTipPercentage += 1
        renderInputs()
    }
    
    @IBAction func lessPressed(sender: AnyObject) {
        backingDefaultTipPercentage = max(backingDefaultTipPercentage - 1, 0)
        renderInputs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper.jpg")!)
        var defaults = NSUserDefaults.standardUserDefaults()
        var storedDefaultTipPercentage = defaults.doubleForKey("default_tip_percentage")
        backingDefaultTipPercentage = storedDefaultTipPercentage
        renderInputs()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        var defaults = NSUserDefaults.standardUserDefaults()
        let defaultTipPercentage = defaults.doubleForKey("default_tip_percentage")
        if (defaultTipPercentage != backingDefaultTipPercentage) {
            defaults.setDouble(
                backingDefaultTipPercentage,
                forKey: "default_tip_percentage"
            )
            defaults.setBool(true, forKey: "default_tip_percentage_changed")
            defaults.synchronize()
        }
    }
}