//
//  AddExpenseFormView.swift
//  Expense Tracker
//
//  Created by Tsenguun on 1/8/22.
//

import SwiftUI
import CoreData

struct AddExpenseFormView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject private var expensesFormViewModel: ExpensesFormViewModel
    var payment: PaymentActivityModel?
    
    init(payment: PaymentActivityModel? = nil) {
        self.payment = payment
        self.expensesFormViewModel = ExpensesFormViewModel(paymentActivity: payment)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                //Title Bar
                HStack(alignment: .lastTextBaseline) {
                    Text("Add new Expense")
                        .font(.system(.largeTitle, design: .default))
                        .fontWeight(.black)
                        .padding(.bottom)
                    Spacer()
                    
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "multiply")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                }
                
                Group {
                    if !expensesFormViewModel.isNameValid {
                        ValidationErrorText(text: "Please enter the payment name")
                        
                    }
                    
                    if !expensesFormViewModel.isAmountValid {
                        ValidationErrorText(text: "Please enter a valid amount")
                        
                    }
                    
                    if !expensesFormViewModel.isMemoValid {
                        ValidationErrorText(text: "Your memo should not exceed 300 characters")
                    }
                }
                
                //Name Field
                FormTextField(name: "Name", placeholder: "Enter your payment", value: $expensesFormViewModel.name)
                
                //Type selection
                VStack(alignment: .leading) {
                    Text("TYPE")
                        .font(.system(.subheadline, design: .default))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                    
                    HStack(spacing: 0) {
                        Button {
                            self.expensesFormViewModel.type = .income
                        } label: {
                            Text("Income")
                                .font(.headline)
                                .foregroundColor(self.expensesFormViewModel.type == .income ? Color.white : Color.primary)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(self.expensesFormViewModel.type == .income ? Color("IncomeCard") : Color(.systemBackground))

                        Button {
                            self.expensesFormViewModel.type = .expense
                        } label: {
                            Text("Expense")
                                .font(.headline)
                                .foregroundColor(self.expensesFormViewModel.type == .expense ? Color.white : Color.primary)
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(self.expensesFormViewModel.type == .expense ? Color("ExpenseCard") : Color(.systemBackground))
                    }
                    .border(Color("Border"), width: 1.0)
                }
                //Date and Amount
                HStack {
                    FormDateField(name: "Date", value: $expensesFormViewModel.date)
                    
                    FormTextField(name: "Amount ($)", placeholder: "0.0", value: $expensesFormViewModel.amount)
                }
                .padding(.top)
                
                //Location
                FormTextField(name: "Location (optional)", placeholder: "Where did you spend?", value: $expensesFormViewModel.location)
                    .padding(.top)
                
                //Memo
                FormTextEditor(name: "Memo (optional)", value: $expensesFormViewModel.memo)
                    .padding(.top)
                
                //Save Button
                Button {
                    self.save()
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                        .opacity(expensesFormViewModel.isFormInputValid ? 1.0 : 0.5)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .background(Color("IncomeCard"))
                        .cornerRadius(10)
                }
                .padding()
                .disabled(!expensesFormViewModel.isFormInputValid)
            }
            .padding()
        }
        .keyboardAdaptive()
    }
        // Save the record using Core Data
    private func save() {
        let newPayment = payment ?? PaymentActivityModel(context: context)
        
        newPayment.paymentId = UUID()
        newPayment.name = expensesFormViewModel.name
        newPayment.type = expensesFormViewModel.type
        newPayment.date = expensesFormViewModel.date
        newPayment.amount = Double(expensesFormViewModel.amount)!
        newPayment.address = expensesFormViewModel.location
        newPayment.memo = expensesFormViewModel.memo
        
        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
    
}

struct AddExpenseFormView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseFormView()
    }
}


struct FormTextField: View {
    let name: String
    var placeholder: String
    
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name.uppercased())
                .font(.system(.subheadline, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $value)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .border(Color("Border"), width: 1.0)
        }
    }
}

struct ValidationErrorText: View {
    var iconName = "info.circle"
    var iconColor = Color(red: 251/255, green: 128/255, blue: 128/255)
    var text = ""
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(text)
                .font(.system(.body, design: .default))
            Spacer()
        }
    }
}

struct FormDateField: View {
    let name: String
    
    @Binding var value: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name.uppercased())
                .font(.system(.subheadline, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            DatePicker("", selection: $value, displayedComponents: .date)
                .tint(.primary)
                .padding(10)
                .border(Color("Border"), width: 1.0)
                .labelsHidden()
        }
    }
}

struct FormTextEditor: View {
    let name: String
    var height: CGFloat = 80.0
    
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name.uppercased())
                .font(.system(.subheadline, design: .default))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            TextEditor(text: $value)
                .frame(minHeight: height)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .border(Color("Border"), width: 1.0)
        }
    }
}
