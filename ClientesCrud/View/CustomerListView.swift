//
//  CustomerListView.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import SwiftUI
import CoreData

struct CustomerListView: View {
    
    @State var customers:[NSManagedObject] = []
    @State var customerSearchName = ""
    @State var showingForm = false
    @State var showToast = false
    @State var message = ""
    @Binding var navBarHidden : Bool
    var viewModel = CustomerViewModel()
    
    var body: some View {
        
        ZStack {
            VStack {
                
                Button(action: {self.showingForm = true}) {
                    Text("Adicionar novo cliente")
                        .font(.system(size: 22))
                        .foregroundColor(.black)
                        .padding(.all, 8)
                }.background(Color.green)
                    .cornerRadius(12)
                    .padding(.top)
                
                List {
                    Section(header: SearchBar(text: self.$customerSearchName, placeholder: "Digite o nome para filtrar os clientes")) {
                        ForEach(customers.filter {
                            self.customerSearchName.isEmpty ?
                                true :
                                "\(($0 as? Customer)?.name ?? "")".contains(self.customerSearchName)
                        }, id: \.self) { customer in
                            Text(self.viewModel.convertInfoToList(customer: customer))
                        }
                    }
                }
            }
            .sheet(isPresented: $showingForm) {
                CustomerFormView(showingForm: self.$showingForm, showToast: self.$showToast, message: self.$message, customers: self.$customers)
            }.toast(isPresented: self.$showToast) {
                HStack {
                    Text(self.message)
                }
            }
        }
        .onAppear() {
            self.customers = self.viewModel.loadAllCustomers()
            self.navBarHidden = false
        }
        
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView(navBarHidden: .constant(false))
    }
}

