@isTest(seeAllData=false)
public class IMS_InvoiceController_Test {
    
    //create Test Data
    @TestSetup
    static void testSetup(){
        List<Account> company= IMS_TestDataFactory.createAccount(1);
        List<Contact> customer= IMS_TestDataFactory.createContact(1, company[0].Id);
        List<Invoice__c> invoice= IMS_TestDataFactory.createInvoice(1, company[0].Id, customer[0].Id);
        List<InvoiceLineItem__c> invoiceLine= IMS_TestDataFactory.createInvoiceLine(1, invoice[0].Id);
        List<Payment__c> payment= IMS_TestDataFactory.createPayment(1, invoice[0].Id);
        List<Refund__c> refund= IMS_TestDataFactory.createRefund(1, invoice[0].Id);
        
    }
    
    @isTest
    static void getInvoiceTest(){
        Test.startTest();
        InvoiceController controller= new InvoiceController();
        List<Invoice__c> invoiceList= InvoiceController.getInvoices();
        Test.stopTest();
        
        system.assertEquals(1, invoiceList.size());
    }
      
    @isTest
    static void createInvoiceRecordTest(){
        Test.startTest();
        Account account= new Account(Name='Test Account');
        insert account;
        Contact contact= new Contact(firstName='Test', lastName='Contact',AccountId=account.Id);
        insert contact;        
        String invoiceNumber='INV-001';
        Date invoiceDate=Date.today();
        Date dueDate= Date.today().addDays(30);
        String status= 'Draft';
        String reference='Test Ref';
        String fromAddress='Test Address';
        String comments='Test comments';
        
        Id createdInvoiceId= InvoiceController.createInvoiceRecord(invoiceNumber, contact.Id, account.Id, invoiceDate, dueDate, status, reference, comments, fromAddress);
        Test.stopTest();
        List<Invoice__c> createdInvoice=[SELECT Id,Invoice_Number__c,Contact__c,Company__c,InvoiceDate__c,Due_Date__c,Status__c,Reference__c,Comments__c,FromAddress__c FROM Invoice__c WHERE Id=:createdInvoiceId];
        system.assertEquals(1, createdInvoice.size());
    }
    
    @isTest
    static void deleteRecordTest(){
        Test.startTest();
        List<Invoice__c> invoiceList=[SELECT Id FROM Invoice__c]; 
        InvoiceController.deleteRecord(invoiceList[0].Id);
        Test.stopTest();
        List<Invoice__c> deletedInvoice=[SELECT Id from Invoice__c WHERE Id=:invoiceList[0].Id];
        system.assertEquals(0, deletedInvoice.size());
    }
    
    @isTest
    static void getInvoiceByIdTest(){
       List<Account> accList= [SELECT Id from Account];
        Test.startTest();
        List<Invoice__c> invoices=InvoiceController.getInvoicesById(accList[0].Id);
        Test.stopTest();
        system.assertEquals(1, invoices.size());
    }
    
    @isTest
    static void getContactDetailsTest(){
        List<Contact> contactList= [SELECT Id,MailingCity FROM Contact];
        Test.startTest();
        Contact contacts=InvoiceController.getContactDetails(contactList[0].Id);
        Test.stopTest();
        system.assertEquals(contactList[0].MailingCity, contacts.MailingCity);
    }
    
    @isTest
    static void getPaymentsTest(){
        List<Invoice__c> invoiceList=[SELECT Id FROM Invoice__c];
        List<Payment__c> paymentList=[SELECT Id FROM Payment__c WHERE Id=:invoiceList[0].Id ];
        Test.startTest();
        List<Payment__c> payments = InvoiceController.getPayments(invoiceList[0].Id);
        Test.stopTest();
        system.assertEquals(1, payments.size());
    }
    
    @isTest
    static void getRefundsTest(){
        List<Invoice__c> invoiceList=[SELECT Id FROM Invoice__c];
        List<Refund__c> refundList=[SELECT Id FROM Refund__c WHERE Id=:invoiceList[0].Id ];
        Test.startTest();
        List<Refund__c> refunds= InvoiceController.getRefunds(invoiceList[0].Id);
        Test.stopTest();
        system.assertEquals(1, refunds.size());
    }
    
     @isTest
    static void hasPaymentTest(){
        List<Invoice__c> invoiceList=[SELECT Id FROM Invoice__c];
        List<Payment__c> paymentList=[SELECT Id FROM Payment__c WHERE Id=:invoiceList[0].Id ];
        Test.startTest();
        Boolean hasPayment = InvoiceController.hasPaymentRecord(invoiceList[0].Id);
        Test.stopTest();
        system.assertEquals(true, hasPayment);
    }
    
     @isTest
    static void hasLineRecordTest(){
        List<Invoice__c> invoiceList=[SELECT Id FROM Invoice__c];
        List<InvoiceLineItem__c> lineList=[SELECT Id FROM InvoiceLineItem__c WHERE Id=:invoiceList[0].Id ];
        Test.startTest();
        Boolean hasLine = InvoiceController.hasLineRecord(invoiceList[0].Id);
        Test.stopTest();
        system.assertEquals(true, hasLine);
    }
    
    @isTest
    static void searchContactssTest(){
        List<Account> accList= [SELECT Id FROM Account];
        List<Contact> contactList= [SELECT Id FROM Contact WHERE AccountId=:accList[0].Id];
        Test.startTest();
        List<SObject> searchResults = InvoiceController.searchContactss('Test');
        Test.stopTest();
        System.assertEquals(0, searchResults.size());
    }
    
    @isTest
    static void displayInvoiceRecordTest(){
        Account account= new Account(Name='Test Account');
        insert account;
        Contact contact= new Contact(firstName='Test', lastName='Contact',AccountId=account.Id);
        insert contact;  
        Invoice__c testInvoice= new Invoice__c(Invoice_Number__c='Test-INV-001',
                                          InvoiceDate__c=Date.today(),
                                          Due_Date__c= Date.today().addDays(30),
                                          Status__c= 'Draft',
                                          Company__c=account.Id, Contact__c=contact.Id);                              
        insert testInvoice;
        InvoiceLineItem__c testLine1= new InvoiceLineItem__c(Invoice__c=testInvoice.Id,
                                                            Amount__c=100,Tax__c=0.1,
                                                            Quantity__c=2);
        insert testLine1;
        InvoiceLineItem__c testLine2= new InvoiceLineItem__c(Invoice__c=testInvoice.Id,
                                                            Amount__c=200,Tax__c=0.05,
                                                            Quantity__c=3);
        insert testLine2;
        Payment__c testPayment1= new Payment__c(Invoice__c= testInvoice.Id,Amount__c=200,
                                               Date__c=Date.today(), Status__c='Draft');
        insert testPayment1;
        Payment__c testPayment2= new Payment__c(Invoice__c= testInvoice.Id,Amount__c=150,
                                               Date__c=Date.today(), Status__c='Draft');
        insert testPayment2;
        Refund__c testRefund= new Refund__c(Invoice__c= testInvoice.Id, Amount__c=50,
                                            Date__c=Date.today().addDays(29),Status__c='Draft');
        insert testRefund;
        Test.startTest();
        List<Invoice__c> invoices = InvoiceController.displayInvoiceRecord(testInvoice.Id);
        Test.stopTest();
        system.assertEquals(1, invoices.size());
        system.assertEquals(800, invoices[0].TotalLineAmount__c);
        system.assertEquals(0.50, invoices[0].Tax_Amount__c);
        system.assertEquals(800.50, invoices[0].GrandTotal__c);
        system.assertEquals(350, invoices[0].TotalPaidAmount__c);
        system.assertEquals(50, invoices[0].TotalRefundAmount__c);
        
    }
}