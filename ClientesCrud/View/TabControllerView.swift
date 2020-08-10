//
//  TabControllerView.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import SwiftUI

struct TabControllerView: View {
    
    @Binding var navBarHidden : Bool
    
    var body: some View {
        TabView {
        CustomerListView(navBarHidden: self.$navBarHidden)
          .tabItem {
            Image(systemName: "list.bullet")
             Text("Clientes")
           }
        CustomerSearchView()
          .tabItem {
             Image(systemName: "magnifyingglass")
             Text("Busca")
           }
            .onAppear() {
                self.navBarHidden = false
            }}
        
    }
}

struct TabControllerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView(navBarHidden: .constant(false))
    }
}
