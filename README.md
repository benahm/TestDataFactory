# Apex Test Data Factory

_Work in progress_

<p align="center"><img src ="/docs/assets/TDF.png" width="500"/></p>


Generate an sObject with all required fields & relationships auto-filled
  ```apex
  SObject con = TDF.createSObject('Contact');
  ```

Generate an sObject with all required fields & relationships auto-filled and overriding values
  ```apex
  SObject con = TDF.createSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com'
    'Account.Description' => 'To be in the Description__c field of the account'
  });
  ```
