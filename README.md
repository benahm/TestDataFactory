# Apex Test Data Factory


<p align="center"><img src ="/docs/assets/TDF.png" width="500"/></p>




#### The ultimate Apex Test Data Factory

Generate an sObject with all the required fields & relationships auto-filled
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact');
  ```

Assign values to fields of the main and the related sObjects
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com'
    'Account.Description' => 'Text for the Description field on the Account'
  });
  ```
  
  
  ### More :
* [Examples](/docs/EXAMPLES.md)
* [Core Concepts](/docs/CONCEPT.md)
* [Contributing](/docs/CONTRIBUTE.md)
