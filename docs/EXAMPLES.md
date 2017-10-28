
## More examples

### Create a single sObject:

##### Create an sObject using the sObject name or the sObject type
  ```apex
  // using sObject name
  Contact con = (Contact)TDF.createSObject('Contact');
  
  // using sObject Type
  Contact con = (Contact)TDF.createSObject(Contact.SObjectType);
  ```

##### Create an sObject by providing a map to override some field values in the main and the related sObjects
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'FirstName' => 'Doe',
    'LastName' => 'John',
    'Account.Description' => 'test'
  });
  ```

### Create a list of sObjects:

##### Create an sObject using the sObject name or the sObject type
  ```apex
  // using sObject name
  List<Contact> conList = TDF.createSObjectList('Contact',10);
  
  // using sObject Type
  List<Contact> conList = TDF.createSObjectList(Contact.SObjectType,10);
  ```
