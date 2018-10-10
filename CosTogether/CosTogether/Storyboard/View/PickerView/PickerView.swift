//
//  PickerView.swift
//  CosTogether
//
//  Created by George Liu on 2018/10/9.
//  Copyright © 2018 George Liu. All rights reserved.
//

import UIKit

class PickerView: UIView {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var confirmBot: UIButton!
    
    var city = [
        "台北", "新北", "桃園", "新竹",
        "苗栗", "台中", "彰化", "雲林",
        "嘉義", "台南", "高雄"
        ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    private func setup() {
        
        viewSetup()
        pickerViewSetup()
    }
    
    private func viewSetup() {
        
        self.cornerSetup(cornerRadius: 20)
        confirmBot.cornerSetup(
            cornerRadius: 0,
            borderWidth: 1,
            borderColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
            maskToBounds: true
        )
    }
    
    private func pickerViewSetup() {
        
        pickerView.delegate = self
        pickerView.dataSource = self

    }
}

extension PickerView: UIPickerViewDelegate {
    
    // swiftlint:disable identifier_name

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
        ) -> String? {
        
        return city[row]
        
    }
    
    // swiftlint:enable identifier_name

}

extension PickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return city.count
    }

}
