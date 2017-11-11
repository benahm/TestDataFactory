
## More examples

### Create a single sObject:

##### Create an sObject using the sObject name or the sObject type
  ```apex
  // Using sObject name
  Contact con = (Contact)TDF.createSObject('Contact');
  
  // Using sObject Type
  Contact con = (Contact)TDF.createSObject(Contact.SObjectType);
  ```

##### Create an sObject by providing a map to assign values to fields in the main and the related sObjects
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'FirstName' => 'Doe',
    'LastName' => 'John',
    'Account.Description' => 'test'
  });
  ```

##### Create and insert an sObject
by default the created sObjects are not inserted, by providing the *doInsert* to true, the sObjects will be automatically inserted  
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'FirstName' => 'Doe',
    'LastName' => 'John',
  },true /* <-- doInsert flag */);
  ```

##### Force to instanciate a related sObject

For example when creating a contact you can force the Test Data Factory to create a related account event if an account is not required
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Account.Id' => null
  });
  ```

##### Provide an Id for a required related sObject to avoid instantiation

You can provide an Id for a required related sObject, to force the use of that Id and prevent the instantiation of the related sObject
  ```apex
  User u = (User)TDF.createSObject('User', new Map<String,Object>{
    'ProfileId' => UserInfo.profileId()
  });
  ```

### Create a list of sObjects:

##### Create an sObject using the sObject name or the sObject type
  ```apex
  // Using sObject name
  List<Contact> conList = TDF.createSObjectList('Contact',10);
  
  // Using sObject Type
  List<Contact> conList = TDF.createSObjectList(Contact.SObjectType,10);
  ```

##### Create a list of users using the index merge value

The following code creates 10 users with different usernames and nicknames 
  ```apex
  List<User> uList = TDF.createSObjectList('User', new Map<String,Object>{
    'ProfileId' => UserInfo.profileId(),
    'Username' => 'test{!index}@mytestdomain.developer',
    'CommunityNickname' => 'test{!index}'
  },10);
