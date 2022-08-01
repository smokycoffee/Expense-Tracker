//
//  AddPaymentDetailView.swift
//  Expense Tracker
//
//  Created by Tsenguun on 1/8/22.
//

import SwiftUI

struct AddPaymentDetailView: View {
    
    @Bivinding var isShow: Bool
    
    let payment: PaymentActityModel
    
    private let viewModel: PaymentDetailViewModel
    
    init(isShow: Binding<Bool>, payment: PaymentActivityModel) {
        self._isShow = isShow
        
        self.payment = payment
        self.viewModel = PaymentDetailViewModel(payment: payment)
    }

    
    var body: some View {
        BottomSheet(isShow: $isShow) {
            VStack {
                TitleBar(viewModel: self.viewModel)
                
                Image(self.viewModel.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                // Payment details
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(self.viewModel.name)
                            .font(.system(.headline))
                            .fontWeight(.semibold)
                        Text(self.viewModel.date)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Subheadline"))
                        Text(self.viewModel.address)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Subheadline"))
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                                        
                    VStack(alignment: .trailing) {
                        Text(self.viewModel.amount)
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                    .padding(.trailing)
                }

                Divider()
                    .padding(.horizontal)

                if self.viewModel.memo != "" {
                    Group {
                        Text("Memo")
                            .font(.subheadline)
                            .bold()
                            .padding(.bottom, 5)
                        
                        Text(self.viewModel.memo)
                            .font(.subheadline)
                        
                        Divider()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                }
                
            }

        }
    }
}


struct AddPaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let testTrans = PaymentActivityModel(context: context)
        testTrans.paymentId = UUID()
        testTrans.name = "Flight ticket"
        testTrans.amount = 2000.0
        testTrans.date = .today
        testTrans.type = .expense
        testTrans.address = "Crawford House, 70 Queen's Road Central, Hong Kong"
        testTrans.memo = "Just hope that I can travel again later this year"
        
        return Group {
            AddPaymentDetailView(isShow: .constant(true), payment: testTrans)
            AddPaymentDetailView(isShow: .constant(true), payment: testTrans)
                .preferredColorScheme(.dark)
        }
        .background(Color.primary.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }}

struct TitleBar: View {
    var viewModel: PaymentDetailViewModel
    
    var body: some View {
        HStack {
            Text("Payment Details")
                .font(.headline)
                .foregroundColor(Color("Heading"))

            Image(systemName: viewModel.typeIcon)
                .foregroundColor(Color("ExpenseCard"))
            
            Spacer()
        }
        .padding()
    }
}
