public with sharing class AssignMtdController implements Metadata.DeployCallback {

    @AuraEnabled
    public static List<Assign__mdt> getAssignMdt(){
                return  [Select Id,QualifiedApiName, MasterLabel,   Better_is_Better__c, 
                    Equal_time_distribution_importance__c, Maximum_Expert_Bonus__c, Minimum_Sub_Rating_Ratio__c,
                    Sales_Rep_Profile__c,Sub_Rating_join_type__c
                from Assign__mdt];
                
         
    }
    @AuraEnabled
    public static void updateAssignMdt(Map<String,Object> data){
        String temp = String.valueOf(data.get('Id'));
        String fullName2 = [Select label from Assign__mdt where id = :temp ].label;
        fullName2=fullName2.replaceAll(' ', '_');
        Metadata.CustomMetadata myMetadata = new Metadata.CustomMetadata(); 
        myMetadata.fullName = 'Assign.'+fullName2;
        myMetadata.label =fullName2;
        for(String key: data.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            if(key == 'Id'){
                break;
         
            }else{
                customField.field = key;            
                customField.value = data.get(key);
            }    
            myMetadata.values.add(customField);            
            String objectName = 'Assign__mdt';
            String fieldName = 'Equal_time_distribution_importance__c';
            SObjectType r = ((SObject)(Type.forName('Schema.'+objectName).newInstance())).getSObjectType();
            DescribeSObjectResult d = r.getDescribe();
            System.debug(d.fields
                .getMap()
                .get(fieldName)
                .getDescribe()
                .getType());    
        }
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(myMetadata);
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
    }
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context){
        if(result.status == Metadata.DeployStatus.Succeeded){
            System.debug('success' + result);
        }else{
            System.debug('fail' +result);
        }
    }
    
}