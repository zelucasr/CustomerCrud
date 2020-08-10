//
//  CustomerUpdateView.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import SwiftUI
import CoreData

struct CustomerUpdateView: View {
    
    @Binding var showingForm : Bool
    @Binding var showToast : Bool
    @Binding var message: String
    @Binding var customer: Customer?
    @State var viewModel = CustomerViewModel()
    @State var pickerArrayOptions : Array<String> = ["Masculino", "Feminino"]
    @State var birthDate: Date = Date()
    @State var cpf = ""
    @State var name = ""
    @State var phone = ""
    @State var gender = ""
    
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
                HStack {
                    Spacer()
                    Button(action: {self.updateCustomer()}) {
                        Text("Atualizar")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .padding(.all, 8)
                    }.background(Color.yellow)
                        .cornerRadius(12)
                        .padding(.bottom, 20)
                    Spacer()
                    Button(action: {self.deleteCustomer()}) {
                        Text("Deletar")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .padding(.all, 8)
                    }.background(Color.red)
                        .cornerRadius(12)
                        .padding(.bottom, 20)
                    Spacer()
                }
                
            }.onAppear() {
                self.updateLocalVariables()
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
    }
    
    func deleteCustomer() {
        if viewModel.deleteCustomer(cpf: self.cpf) {
            self.showingForm = false
            self.message = "Cliente deletado com sucesso."
            self.showToast = true
        } else {
            self.showingForm = false
            self.message = "Ocorreu um problema ao deletar o cliente."
            self.showToast = true
        }
    }
    
    func updateCustomer() {
        if !viewModel.checkFields(cpf, name, phone, gender) {
            self.showingForm = false
            self.message = "Preencha todos os campos para atualizar o cliente."
            self.showToast = true
            return
        }
        let success = viewModel.updateCustomer(cpf, name, phone, gender, birthDate)
        if success {
            self.showingForm = false
            self.message = "Cliente atualizado com sucesso."
            self.showToast = true
        } else {
            self.showingForm = false
            self.message = "Ocorreu um problema ao atualizar o cliente."
            self.showToast = true
        }
    }
    
    func updateLocalVariables() {
        if let customer = self.customer, let bDate = customer.birthDate, let cpf = customer.cpf, let name = customer.name, let phone = customer.phone {
            self.birthDate = bDate
            self.cpf = cpf
            self.name = name
            self.phone = phone
            if customer.gender {
                self.gender = pickerArrayOptions[0]
            } else {
                self.gender = pickerArrayOptions[1]
            }
        }
    }
    
}

struct CustomerUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerUpdateView(showingForm: .constant(false), showToast: .constant(false), message: .constant(""), customer: .constant(Customer()))
    }
}
