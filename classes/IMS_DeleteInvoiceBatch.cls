global class IMS_DeleteInvoiceBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Invoice__c WHERE InvoiceDate__c >= LAST_YEAR';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        delete scope;
    }
   
    global void finish(Database.BatchableContext BC) {
        
    }

}