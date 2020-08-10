//
//  CustomerSearchView.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import SwiftUI

struct CustomerSearchView: View {
    @State var customerSearchCPF = ""
    @State var showingForm = false
    @State var showToast = false
    @State var message = ""
    @State var customer: Customer? = nil
    var viewModel = CustomerViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    
                    TextField("Digite o CPF para buscar", text: $customerSearchCPF)
                        .keyboardType(.numberPad)
                        .padding(.all)
                    
                    Button(action: {self.searchCustomer()}) {
                        Text("Buscar")
                            .font(.system(size: 22))
                            .foregroundColor(.black)
                            .padding(.all, 8)
                    }.background(Color.green)
                        .cornerRadius(12)
                        .padding(.top)
                    
                    Spacer()
                }.sheet(isPresented: $showingForm) {
                    CustomerUpdateView(showingForm: self.$showingForm, showToast: self.$showToast, message: self.$message, customer: self.$customer)
                }.toast(isPresented: self.$showToast) {
                    HStack {
                        Text(self.message)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
    }
    
    func searchCustomer() {
        if let customer = viewModel.findCustomer(cpf: customerSearchCPF) {
            self.customer = customer
            self.showingForm = true
        } else {
            self.message = "O cliente não foi encontrado no banco."
            self.showToast = true
        }
    }
    
}

struct CustomerSearchView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSearchView()
    }
}
