# Apex Test Data Factory

_Work in progress_

![overview](/docs/assets/TDF.png)

Generate an sObject with all required fields & relationships auto-filled
  ```apex
  TDF.generateSObject('Contact');
  ```

Generate an sObject with all required fields & relationships auto-filled and overriding values
  ```apex
  TDF.generateSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com'
    'Account.Description' => 'To be in the Description__c field of the account'
  });
  ```
