//
//  CustomerViewModel.swift
//  ClientesCrud
//
//  Created by Jose Lucas on 09/08/20.
//  Copyright © 2020 Jose Lucas. All rights reserved.
//

import SwiftUI
import CoreData
import Foundation

class CustomerViewModel {
    
    //MARK: - Create function
    func addNewCustomer(_ cpf: String, _ name: String, _ phone: String, _ gender: String, _ birthDate: Date) -> Bool {
        
        if !checkFields(cpf, name, phone, gender) {
            return false
        }
        
        if let _ = self.findCustomer(cpf: cpf) {
            print("Já existe este cpf no banco, o cliente não será salvo.")
            return false
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Customer", in: managedContext) else { return false }
        
        var customerManagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        let customer = self.createCustomer(cpf, name, phone, gender, birthDate)
        customerManagedObject = updateNSObjectValues(customerManagedObject, customer)
        
        do {
            try managedContext.save()
            print("Salvo com sucesso.")
            return true
        } catch let error as NSError {
            print("Não foi possível salvar. \(error)")
            return false
        }
        
    }
    
    //MARK: - Read function
    func loadAllCustomers() -> [NSManagedObject] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Customer")
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            return objects
        } catch let error as NSError {
            print("Não foi possível executar a query. \(error)")
            return []
        }
        
    }
    
    //MARK: - Update function
    func updateCustomer(_ cpf: String, _ name: String, _ phone: String, _ gender: String, _ birthDate: Date) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Customer")
        
        fetchRequest.predicate = NSPredicate(format: "cpf = %@", cpf)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            var customerToUpdate = objects[0] as! NSManagedObject
            let customer = self.createCustomer(cpf, name, phone, gender, birthDate)
            customerToUpdate = updateNSObjectValues(customerToUpdate, customer)
            
            do {
                try managedContext.save()
                print("Atualizado com sucesso.")
                return true
            } catch let error as NSError {
                print("Não foi possível atualizar o objeto. \(error)")
                return false
            }
            
        } catch let error as NSError {
            print("Não foi possível executar a query. \(error)")
            return false
        }
        
    }
    
    //MARK: - Delete function
    func deleteCustomer(cpf: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Customer")
        fetchRequest.predicate = NSPredicate(format: "cpf = %@", cpf)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            let customerToDelete = objects[0] as! NSManagedObject
            managedContext.delete(customerToDelete)
            
            do {
                try managedContext.save()
                print("Deletado com sucesso.")
                return true
            } catch let error as NSError {
                print("Não foi possível deletar o objeto. \(error)")
                return false
            }
            
        } catch let error as NSError {
            print("Não foi possível executar a query. \(error)")
            return false
        }
        
    }
    
    //MARK: - Find by CPF function
    func findCustomer(cpf: String) -> Customer? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Customer")
        fetchRequest.predicate = NSPredicate(format: "cpf = %@", cpf)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            let result = objects.first as? Customer ?? nil
            return result
            
        } catch let error as NSError {
            print("Não foi possível executar a query. \(error)")
            return nil
        }
        
    }
    
    fileprivate func createCustomer(_ cpf: String, _ name: String, _ phone: String, _ gender: String, _ birthDate: Date) -> CustomerDTO {
        var customer = CustomerDTO()
        customer.cpf = cpf
        customer.name = name
        customer.phone = phone
        customer.birthDate = birthDate
        if gender == "Masculino" {
            customer.gender = true
        } else {
            customer.gender = false
        }
        return customer
    }
    
    func checkFields(_ cpf: String, _ name: String, _ phone: String, _ gender: String) -> Bool {
        if cpf.isEmpty || name.isEmpty || phone.isEmpty || gender.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    fileprivate func updateNSObjectValues(_ customerManagedObject: NSManagedObject, _ customer: CustomerDTO) -> NSManagedObject{
        customerManagedObject.setValue(customer.cpf, forKey: "cpf")
        customerManagedObject.setValue(customer.birthDate, forKey: "birthDate")
        customerManagedObject.setValue(customer.name, forKey: "name")
        customerManagedObject.setValue(customer.gender, forKey: "gender")
        customerManagedObject.setValue(customer.phone, forKey: "phone")
        return customerManagedObject
    }
    
    func convertInfoToList(customer: NSManagedObject) -> String {
        let now = Date()
        let name = (customer as? Customer)?.name ?? "error"
        let age = (customer as? Customer)?.birthDate ?? Date()
        let calendar = Calendar(identifier: .gregorian)
        let ageComponents = calendar.dateComponents([.year], from: age, to: now)
        return "\(name) - \(ageComponents.year ?? 0)"
    }
    
}
