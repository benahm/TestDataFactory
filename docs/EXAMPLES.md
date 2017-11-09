
## More examples

### Create a single sObject:

##### Create an sObject using the sObject name or the sObject type
  ```apex
  // Using sObject name
  Contact con = (Contact)TDF.createSObject('Contact');
  
  // Using sObject Type
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

##### Create and insert an sObject
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'FirstName' => 'Doe',
  },true);
  ```

##### Force to instanciate a related objects

For example when creating a contact you can force the test data factory to create a related account event if and account is not required to create a contact
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Account.Id' => null,
  },true);
  ```


### Create a list of sObjects:

##### Create an sObject using the sObject name or the sObject type
  ```apex
  // Using sObject name
  List<Contact> conList = TDF.createSObjectList('Contact',10);
  
  // Using sObject Type
  List<Contact> conList = TDF.createSObjectList(Contact.SObjectType,10);
  ```
