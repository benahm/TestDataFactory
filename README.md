# Apex Data Factory

_Work in progress_

Generate an sObject with all required fields & relationships auto-filled
  ```apex
  DF.generateSObject('Contact');
  ```

Generate an sObject with all required fields & relationships auto-filled and overriding values
  ```apex
  DF.generateSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com'
    'Account.Description' => 'To be in the Description__c field of the account'
  });
  ```
