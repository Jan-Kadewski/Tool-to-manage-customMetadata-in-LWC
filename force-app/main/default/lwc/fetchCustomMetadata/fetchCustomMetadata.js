import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAssignMdt from '@salesforce/apex/AssignMtdController.getAssignMdt';
import updateAssignMdt from'@salesforce/apex/AssignMtdController.updateAssignMdt';


const COLUMNS =[
    {label:'Label',fieldName:'MasterLabel',type:'ID'},
    {label:'Sales Rep Profile',fieldName:'Sales_Rep_Profile__c', type:'string', editable:true},
    {label:'Better is Better',fieldName:'Better_is_Better__c',type:'boolean',editable:true},
    {label:'Sub-Rating join type',fieldName:'Sub_Rating_join_type__c',type:'string', editable:true,},
    {label:'Equal time distribution importance',fieldName:'Equal_time_distribution_importance__c',type:'decimal',editable:true},
    {label:'Maximum Expert Bonus',fieldName:'Maximum_Expert_Bonus__c',type:'decimal',editable: true},
    {label:'Minimum Sub-Rating Ratio',fieldName:'Minimum_Sub_Rating_Ratio__c',type:'decimal',editable:true}   
];

export default class FetchCustomMetadata extends LightningElement {

    records;
    error;
    columns = COLUMNS;
     draftValues;
    loaded = false;
    connectedCallback(){
        getAssignMdt()
            .then(results =>{
                this.records = results;
            }).catch(error =>{
                this.error = error;
                console.log(this.error);
            })      
        }  

    handleSave(event){
        this.loaded = true;
        this.draftValues = event.detail.draftValues;
        this.draftValues.forEach( (obj)=> {       
            let myMap = {};
            Object.keys(obj).forEach( (key)=>{
                myMap[key] = obj[key];
       } )       
            updateAssignMdt({data:myMap})
                .then( () =>{
                    const event = new ShowToastEvent({
                        title:'Metadata changed',
                        message:'Custom Metadata has been changed',
                        variant:'success'
                    })
                    this.dispatchEvent(event);
                } )
        } )
    }
}
