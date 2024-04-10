@RestResource(urlMapping = '/EventoComunidade/Leads/*')

global with sharing class LeadApi {
    @HttpGet
    global static void getLeads() {
        RestResponse resultRest = RestContext.response;

        List<Lead> leadsList = [SELECT Id, Name, Email from Lead];
        
        resultRest.responseBody = Blob.valueOf(JSON.serializePretty(leadsList));
        resultRest.statusCode = 200;

    }
}