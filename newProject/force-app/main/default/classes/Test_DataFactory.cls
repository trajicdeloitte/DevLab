/**
 * Created by trajic on 3/1/2022.
 */

@IsTest
public with sharing class Test_DataFactory {

    public static Account createTestAccount(){
        Account acc = new Account(Name = 'TestName');
        insert acc;
        return acc;
    }


    public static Account createOpportunity(Account account){
        Opportunity opp = new Opportunity(
                Name = account.Name + 'Test Opportuniy',
                StageName = 'Prospecting',
                Amount = 10,
                CloseDate = System.today().addMonths(2),
                AccountId = account.Id
        );
        insert opp;
        return account;
    }

    public static Contact createTestInvalidContact(String last_name){
        Contact contact = new Contact(
                FirstName = 'Jon',
                LastName = last_name
        );

        return contact;
    }
    public static Contact createTestInvalidContactforUpdate(Contact contact,String last_name){
        contact.LastName = last_name;
        return contact;
    }
}