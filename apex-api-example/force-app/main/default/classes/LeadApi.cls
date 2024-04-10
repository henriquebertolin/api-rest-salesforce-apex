@RestResource(urlMapping = '/EventoComunidade/Leads/*')

global with sharing class LeadApi {
    @HttpGet()
    global static void getLeads() {
        RestResponse resultRest = RestContext.response;
        RestRequest request = RestContext.request;

        String firstName = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        List<Lead> leadsList = String.isNotBlank(firstName) ? [SELECT Id, Name, Email from Lead where FirstName = :firstName] : [SELECT Id, Name, Email from Lead];
        
        resultRest.responseBody = Blob.valueOf(JSON.serializePretty(leadsList));
        resultRest.statusCode = 200;

    }

    @HttpPost
    global static void insertLeads(List<LeadInsertWrapper> leadList) {
        RestResponse resultRest = RestContext.response;

        List<Lead> leadInsertList = new List<Lead>();

        for (LeadInsertWrapper l : leadList) {
            Lead leadInsert = new Lead(
                LastName = l.sobrenome,
                Company = l.nome_empresa,
                Status = l.status_do_lead,
                Email = l.email,
                FirstName = l.nome
            );
            leadInsertList.add(leadInsert);
        }

        List<String> idsResponse = new List<String>();

        if (leadInsertList.size() > 0) {
            Database.UpsertResult[] results = Database.upsert(leadInsertList);

            for (Integer index = 0, size = results.size(); index < size; index++) {
                if (results[index].isSuccess()) {
                    idsResponse.add(results[index].Id);
                } else {
                    idsResponse.add('ERROR');
                }
            }
        }
        resultRest.responseBody = Blob.valueOf(JSON.serializePretty(idsResponse));
        resultRest.statusCode = 200;
    }
}