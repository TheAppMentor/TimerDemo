//
//  SettingsPickerView.swift
//  TimerDemo
//
//  Created by Moorthy, Prashanth on 6/8/17.
//  Copyright © 2017 Moorthy, Prashanth. All rights reserved.
//

import UIKit

protocol SettingsPickerViewDelegate {
    func settingsPickerViewCancelPressed()
    func settingsPickerViewDonePressed(index : Int)
}

protocol SettingsPickerViewData {
    var pickerViewItems : [String] {get}
    var pickerViewIndexOfSelectedItem : Int {get}
    var pickerViewTitle : String {get}
    var isAlert : Bool {get}
}

class SettingsPickerView: UIView {    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func userPressedDone(_ sender: UIButton) {
        delegate?.settingsPickerViewDonePressed(index: pickerView.selectedRow(inComponent: 0))
    }
    
    @IBAction func userPressedCancel(_ sender: UIButton) {
        delegate?.settingsPickerViewCancelPressed()
    }
    
    
    var pickerViewData : SettingsPickerViewData?{
        didSet{
            setupData()
        }
    }
    
    var delegate : SettingsPickerViewDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    convenience init(frame: CGRect, data : SettingsPickerViewData, delegate : SettingsPickerViewDelegate?) {
        self.init(frame : frame)
        
        pickerViewData = data
        self.delegate = delegate
        setupData()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    
    func setupView(){
        let bundle = Bundle.init(for: type(of: self))
        let ourNib = UINib(nibName: "SettingsPickerView", bundle: bundle)
        let theView = ourNib.instantiate(withOwner: self, options: nil).first as! UIView
        theView.frame = self.bounds
        self.addSubview(theView)
    }
    
    
    func setupData() {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        //Set up Title
        titleLabel.text = pickerViewData?.pickerViewTitle
    }
    
}


extension SettingsPickerView : UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData!.pickerViewItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let theString = pickerViewData?.pickerViewItems[row]{
            let attributedString = NSMutableAttributedString(string: theString)
            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value:UIColor.white , range:(theString as NSString).range(of: theString))
            
            return attributedString
        }
        
        return nil
    }
    
    func scrollToSelectedRow() {
        pickerView.selectRow(pickerViewData?.pickerViewIndexOfSelectedItem ?? 0, inComponent: 0, animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerViewData?.isAlert == true{
            AudioHandler.shared.playAudio(audioID: AudioFileMap(rawValue: pickerViewData!.pickerViewItems[row])!)
        }
    }
    
    
}


