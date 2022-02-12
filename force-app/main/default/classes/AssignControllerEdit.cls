public with sharing class AssignControllerEdit {
   public final List<Assign__mdt> assignData {get;set;}
   final Map<String,Assign__mdt> assignDataByApiName {get;set;}
    public AssignControllerEdit(){
          assignData  = new List<Assign__mdt>();
          assignDataByApiName  = new Map<String,Assign__mdt>();
        for(Assign__mdt data : [Select QualifiedApiName, MasterLabel, Better_is_Better__c, Equal_time_distribution_importance__c,	
        Maximum_Expert_Bonus__c,Minimum_Sub_Rating_Ratio__c, Sales_Rep_Profile__c,Sub_Rating_join_type__c
                                   FROM Assign__mdt]){
                                    assignData.add(data);
                                    assignDataByApiName.put(data.QualifiedApiName,data);
                                    System.debug(data.QualifiedApiName);
                                }

    }
  public PageReference save(){    
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        List<String> assignDataFullName = new List<String>();
        for(String RecordName : assignDataByApiName.keySet()){
            assignDataFullName.add('Assign.'+RecordName);
        }
        List<Metadata.Metadata> records = Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata
        ,assignDataFullName);
        for(Metadata.Metadata record: records){
            Metadata.CustomMetadata assignRecord = (Metadata.CustomMetadata) record;
            String assignRecordName = assignRecord.fullName.substringAfter('.');
            Assign__mdt assignToCopy = assignDataByApiName.get(assignRecordName);
            for(Metadata.CustomMetadataValue assignRecValue : assignRecord.values){
                assignRecValue.value = assignToCopy.get(assignRecValue.field);
        }
        container.addMetadata(assignRecord);
        System.debug(container);
    }
    Id asyncResultId = Metadata.Operations.enqueueDeployment(container, null);
    return null;
    }
}