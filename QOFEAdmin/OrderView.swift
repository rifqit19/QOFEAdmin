//
//  OrderView.swift
//  QOFEAdmin
//
//  Created by rifqitriginandri on 25/03/23.
//

import SwiftUI

struct OrderView: View {
    
    @ObservedObject var orderListener  = OrderListener()
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        
        NavigationView{
            List{
                
                HStack{
                    Spacer()
                    Image("qofe_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 50)
                    Spacer()
                }
                .padding(.top)
                .listRowBackground(Color("darkBrown"))
                
                Section(header: Text("Pesanan Aktif").foregroundColor(.white)) {
                    ForEach(self.orderListener.activeOrders ?? []) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            HStack{
                                Text(order.customerName)
                                Spacer()
                                Text("\(order.amount.clean)")
                            }//end of hstack
                        }// end off navigation link
                    }// end of foreach
                }
                
                Section(header: Text("Pesanan Selesai").foregroundColor(.white)) {
                    ForEach(self.orderListener.completedOrders ?? []) { order in
                        NavigationLink(destination: OrderDetailView(order: order)){
                            HStack{
                                Text(order.customerName)
                                Spacer()
                                Text("\(order.amount.clean)")
                            }//end of hstack
                            
                        }
                    }// end of foreach
                }
                
                
            }//end off list
            .background(Color("darkBrown"))
            .scrollContentBackground(.hidden)
//            .navigationBarTitle("Orders")
//            .navigationBarTitleDisplayMode(.large)
        }// end off navigation
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
