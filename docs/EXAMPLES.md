
## More examples

### Create a single sObject:


Create an sObject using the sObject name or the sObject type
  ```apex
  // using sObject name
  Contact con = (Contact)TDF.createSObject('Contact');
  
  // using sObject Type
  Contact con = (Contact)TDF.createSObject(Contact.SObjectType);
  ```

### Create a list of sObjects:

Create an sObject using the sObject name or the sObject type
  ```apex
  // using sObject name
  List<Contact> conList = TDF.createSObjectList('Contact',10);
  
  // using sObject Type
  List<Contact> conList = TDF.createSObjectList(Contact.SObjectType,10);
  ```
