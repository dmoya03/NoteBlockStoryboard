//
//  addView.swift
//  Notas2Storyboard
//
//  Created by Daniel Moya on 19/12/23.
//

import UIKit

class addView: UIViewController {
    
    @IBOutlet weak var title_: UITextField!
    @IBOutlet weak var note_: UITextView!
    @IBOutlet weak var date_: UIDatePicker!
    @IBOutlet weak var btnSave: UIButton!
    var notes: Notes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = notes != nil ? "Edit note" : "Create note"
        title_.text = notes?.title
        note_.text = notes?.note
        date_.date = notes?.date ?? Date()
        btnSave.setTitle(notes != nil ? "Save changes" : "Save", for: .normal)
        
        if notes != nil {
            validateText2()
        } else {
            validateText()
        }
        
    }
    

    @IBAction func btnSaveClick(_ sender: UIButton) {
        if notes != nil{
            Model.shared.editData(title: title_.text ?? "", note: note_.text, date: date_.date, notes: notes!)
        } else {
            Model.shared.saveData(title: title_.text ?? "", note: note_.text, date: date_.date)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func validateText(){
        btnSave.isEnabled = false
        btnSave.backgroundColor = .systemGray2
        title_.addTarget(self, action: #selector(validateTextField), for: .editingChanged)
    }
    
    func validateText2(){
        btnSave.backgroundColor = .systemTeal
        title_.addTarget(self, action: #selector(validateTextField), for: .editingChanged)
    }
    
    @objc func validateTextField(sender: UITextField){
        guard let title2 = title_.text, !title2.isEmpty else {
            btnSave.isEnabled = false
            btnSave.backgroundColor = .systemGray2
            return
        }
        btnSave.isEnabled = true
        btnSave.backgroundColor = .systemTeal
    }
    
}
