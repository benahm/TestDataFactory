
## Limitations 🛑


#### Default values for picklist/mulipicklist fields 


For an sObject that has multiple record types, TestDataFactory will assign the default picklist value and if the default value is not assigned to the used recrod type, you will get the error below

*Example: Contact has multiple record types and the field CustomField__c has 'TEST' value as default, but it's not assigned to the record types*
	
    TestDataFactory.TestDataFactoryException: Unable to insert "Contact" records: 
    INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST: PicklistExample: bad value for restricted picklist field: TEST [CustomField__c=TEST]
    Stack Trace 

    Class.TestDataFactory.SObjectManager: line 381, column 1
    Class.TestDataFactory.SObjectManager.insertAll: line 302, column 1
    Class.TestDataFactory.SObjectFactory: line 465, column 1
    Class.TestDataFactory: line 149, column 1
    Class.TestDataFactory: line 91, column 1
    Class.TestDataFactory: line 76, column 1
    Class.YourTestClass_Test.yourTestMethod: line XX, column XX

This restriction is due to Apex limitation [no way to get picklist values based on Record Type](https://success.salesforce.com/ideaView?id=08730000000gNpLAAU) 

###### Workaround

Define a custom ``TestDataFactory.DefaultValueProvider`` implementation and handle the picklist default value per sObject, RecordType & field


  ```apex
public class TestDefaultValueProvider extends TestDataFactory.DefaultValueProvider{
    public override String getPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Id recordTypeId, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
      Map<String,Schema.RecordTypeInfo> recordTypesMap = sObjectDesc.getRecordTypeInfosByDeveloperName();
      if(sObjectDesc.getSObjectType() == Contact.SObjectType){
        if(fieldDesc.getName() == 'CustomField__c'){
          if(recordTypesMap.get('RecordType1').getRecordTypeId() == recordTypeId ){
            return 'Value Assigned to the Record Type 1';
          }else if(recordTypesMap.get('RecordType2').getRecordTypeId() == recordTypeId ){
            return 'Value Assigned to the Record Type 2';
          }
        }
      }
      return getSFDefaultPicklistValue(fieldDesc);
    }
  }
  ```
