# Apex Test Data Factory


<p align="center"><img src ="/docs/assets/TDF.png" width="500"/></p>




#### “ The ultimate Apex Test Data Factory ” :factory: :ok_hand:

Generate & insert an sObject with all the required fields & relationships auto-filled
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact',true);
  ```

Assign values to fields of the main and the related sObjects
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com',
    'Account.Description' => 'Text for the Description field on the Account'
  },true);
  ```
  
  
  ### More :
* [Usage](/docs/USAGE.md)
* [Examples](/docs/EXAMPLES.md)
* [Core Concepts](/docs/CONCEPT.md)
* [Performance](/docs/PERFORMANCE.md)
* [Customize](/docs/CUSTOMIZE.md)
* [Contribute](/docs/CONTRIBUTE.md)



### [Releases](https://github.com/benahm/TDF/releases)
### [License](LICENSE)

Apache 2.0
