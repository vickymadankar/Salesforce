@isTest(seeAllData=false)
public class IMS_InvoiceLineItemController_Test {

    //create Test Data
    @TestSetup
    static void testSetup(){
        List<Account> company= IMS_TestDataFactory.createAccount(1);
        List<Contact> customer= IMS_TestDataFactory.createContact(1, company[0].Id);
        List<Invoice__c> invoice= IMS_TestDataFactory.createInvoice(1, company[0].Id, customer[0].Id);
        List<InvoiceLineItem__c> invoiceLine= IMS_TestDataFactory.createInvoiceLine(1, invoice[0].Id);  
    }
    
    @isTest
    static void getInvoiceLinesTest(){
        List<Invoice__c> invoiceList= [SELECT Id FROM Invoice__c];
        List<InvoiceLineItem__c> lineList= [SELECT Id FROM InvoiceLineItem__c WHERE Invoice__c=:invoiceList[0].Id];
        Test.startTest();
        List<InvoiceLineItem__c> lines= IMS_InvoiceLineItemController.getInvoiceLines(invoiceList[0].Id);
        Test.stopTest();
        system.assertEquals(1, lines.size());
    }
    
    @isTest
    static void hasInvoiceRecordTest(){
        List<Invoice__c> invoiceList=[SELECT Id FROM Invoice__c];
        List<InvoiceLineItem__c> lineList=[SELECT Id FROM InvoiceLineItem__c WHERE Invoice__c=:invoiceList[0].Id ];
        Test.startTest();
        Boolean hasLine = IMS_InvoiceLineItemController.hasInvoiceRecord();
        Test.stopTest();
        system.assertEquals(true, hasLine);
    }
    
    @isTest
    static void insertInvoiceLinesTest(){
        List<Invoice__c> invoiceList= [SELECT Id from Invoice__c];
        List<InvoiceLineItem__c> lineList= new List<InvoiceLineItem__c>{
            new InvoiceLineItem__c(Invoice__c=invoiceList[0].Id, Amount__c=50, Quantity__c=2)
        }; 
        String jsonString= JSON.serialize(lineList);
        Test.startTest();
        IMS_InvoiceLineItemController.insertInvoiceLineItems(jsonString);
        Test.stopTest();
        List<InvoiceLineItem__c> insertedLines= [SELECT Id ,Amount__c, Quantity__c,Invoice__c
                                                 FROM InvoiceLineItem__c WHERE Invoice__c=:invoiceList[0].Id];
        system.assertEquals(2, insertedLines.size());
    }
}