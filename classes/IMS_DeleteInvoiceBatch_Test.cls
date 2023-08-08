@isTest
public class IMS_DeleteInvoiceBatch_Test {
    
     @TestSetup
    static void testSetup(){
        List<Account> company= IMS_TestDataFactory.createAccount(1);
    }
    
    @isTest
    static void testDeleteInvoiceBatch() {
        List<Account> testList= [SELECT Id FROM Account];
        List<Invoice__c> testRecords = new List<Invoice__c>();
        for (Integer i = 0; i < 5; i++) {
            Invoice__c invoice = new Invoice__c(
                InvoiceDate__c= Date.today(),
                Company__c = testList[0].Id,
                Status__c = 'Draft',
                Due_Date__c = Date.today().addDays(30),
                Invoice_Number__c = 'INV-' + i
            );
            testRecords.add(invoice);
        }
        insert testRecords;
        Test.startTest();
        IMS_DeleteInvoiceBatch batch = new IMS_DeleteInvoiceBatch();
        Database.executeBatch(batch, 100);
        Test.stopTest();
        List<Invoice__c> remainingRecords = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, remainingRecords.size());
    }

}