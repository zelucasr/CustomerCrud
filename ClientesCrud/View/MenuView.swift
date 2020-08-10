//
//  MenuView.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    
    @State private var navBarHidden = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Image("myBackgroundImage")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.5)
                
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: TabControllerView(navBarHidden: self.$navBarHidden)) {
                        Text("Cadastro de clientes")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    }.background(Color.green)
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    Button(action: {self.leave()}) {
                        Text("Sair")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                            .padding()
                    }.background(Color.green)
                        .cornerRadius(12)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(self.navBarHidden)
            .navigationBarTitle("Home", displayMode: .inline)
            .onAppear(perform: {
                self.navBarHidden = true
            })
            
        }
    }
    
    func leave() {
        
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
