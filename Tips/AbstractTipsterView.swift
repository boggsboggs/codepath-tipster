import UIKit


class AbstractTipsterView: UIViewController {
    var endEditingTimer = NSTimer()
    
    // End editing when user taps away
    @IBAction func onViewTap(sender: AnyObject) {
        endEditing()
    }
    
    // End editing when view is dismissed
    override func viewWillDisappear(animated: Bool) {
        endEditing()
    }
    
    func stripNonDecimalChars(rawString: String) -> String {
        var decimalsSet = NSCharacterSet(charactersInString: "1234567890")
        var decimalString = "".join(rawString.componentsSeparatedByCharactersInSet(decimalsSet.invertedSet))
        return decimalString
    }
    
    func endEditing() {
        view.endEditing(true)
    }

    func startEndEditingTimer() {
        endEditingTimer.invalidate()
        endEditingTimer = NSTimer.scheduledTimerWithTimeInterval(
            Double(2.0),
            target: self,
            selector: "endEditing",
            userInfo: nil,
            repeats: false
        )
    }
    func cancelEndEditingTimer() {
        endEditingTimer.invalidate()
    }
}