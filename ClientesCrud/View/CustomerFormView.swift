//
//  CustomerFormView.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import SwiftUI
import CoreData

struct CustomerFormView: View {
    
    @Binding var showingForm : Bool
    @State var viewModel = CustomerViewModel()
    @State var pickerArrayOptions : Array<String> = ["Masculino", "Feminino"]
    @State var birthDate: Date = Date()
    @State var cpf = ""
    @State var name = ""
    @State var phone = ""
    @State var gender = ""
    @Binding var showToast : Bool
    @Binding var message: String
    @Binding var customers : [NSManagedObject]
    
    var body: some View {
        NavigationView{
            VStack {
                Form {
                    Section(header: Text("Cliente")) {
                        TextField("Insira o nome", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Insira o CPF", text: $cpf)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Insira o telefone", text: $phone)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        VStack {
                            DatePicker(selection: $birthDate, displayedComponents: .date) {
                                Text("Data de nascimento")
                            }
                        }.animation(nil)
                        Picker("Selecione o gênero", selection: self.$gender) {
                            ForEach(self.pickerArrayOptions, id : \.self) { i in
                                Text(i)
                            }
                        }.pickerStyle(DefaultPickerStyle())
                            .id(pickerArrayOptions)
                        
                    }
                }
                Button(action: {self.addNewCustomer()}) {
                    Text("Salvar")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                        .padding(.all, 8)
                }.background(Color.green)
                    .cornerRadius(12)
                    .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
    }
    
    func addNewCustomer() {
        if !viewModel.checkFields(cpf, name, phone, gender) {
            self.showingForm = false
            self.message = "Preencha todos os campos para adicionar um cliente."
            self.showToast = true
            return
        }
        let success = viewModel.addNewCustomer(cpf, name, phone, gender, birthDate)
        if success {
            self.showingForm = false
            self.message = "Cliente cadastrado com sucesso."
            self.showToast = true
            self.customers = viewModel.loadAllCustomers()
        } else {
            self.showingForm = false
            self.message = "Ocorreu um problema ao cadastrar o cliente."
            self.showToast = true
        }
    }
    
}

struct CustomerFormView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerFormView(showingForm: .constant(false), showToast: .constant(false), message: .constant(""), customers: .constant([]))
    }
}
