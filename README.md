# Apex Test Data Factory

_Work in progress_

<p align="center"><img src ="/docs/assets/TDF.png" width="500"/></p>




#### The ultimate Apex Test Data Factory

Generate an sObject with all the required fields & relationships auto-filled
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact');
  ```

Generate an sObject with all the required fields & relationships auto-filled and override some values
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com'
    'Account.Description' => 'Text for the Description field on the Account'
  });
  ```
  
  
  ### More :
* [Examples](/docs/EXAMPLES.md)
* [Contributing](/docs/CONTRIBUTE.md)
