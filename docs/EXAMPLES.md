
## More examples


#### Methods of the TDF class :


<table>
<thead>
<tr>
  <th align='left'>Method</th>
  <th align='left'>Supported signatures</th>
</tr>
</thead>
<tbody>
<tr>
  <td>
  <em>createSObject</em>
  </td>
  <td>
<pre lang='apex'>  
* createSObject(String sObjectName) // create an sObject with all required fields auto-filled and insert all sObjects
* createSObject(String sObjectName,Boolean doInsert) // create an sObject with all required fields auto-filled and insert all sObjects if the doInsert = true
* createSObject(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride) // create an sObject with all required fields auto-filled, assign the values defined in the mapValuesOverride and insert all sObjects if the doInsert = true
* createSObject(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride, Boolean doInsert) // create an sObject with all required fields auto-filled, assign the values defined in the mapValuesOverride and insert all sObjects if the doInsert = true

</pre>
  </td>
</tr>
<tr>
</tr>
<tr>
  <td>
  <em>createSObjectList</em>
  </td>
  <td>
<pre lang='apex'>  
* createSObjectList(String sObjectName, Integer numberOfSObjects) // create a list of sObject with all required fields auto-filled and insert all sObjects
* createSObjectList(String sObjectName, Integer numberOfSObjects, Boolean doInsert) // create a list of sObject with all required fields auto-filled and insert all sObjects if the doInsert = true
* createSObjectList(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride, Integer numberOfSObjects) // create a list of sObject with all required fields auto-filled, assign the values defined in the mapValuesOverride and insert all sObjects
* createSObjectList(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride, Integer numberOfSObjects, Boolean doInsert) // create a list of sObject with all required fields auto-filled, assign the values defined in the mapValuesOverride and insert all sObjects if the doInsert = true

</pre>
  </td>
</tr>
</table>


#### Create a single sObject:

##### Create a Contact 
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact');
  ```

##### Create a Contact by providing a map to assign values to fields in the main and the related sObjects

You can assign values to the main sObject or any related sObject, all sObjects will be created with the required fields auto-filled 
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'FirstName' => 'Doe',
    'LastName' => 'John',
    'Account.Description' => 'Description of the related account',
    'Account.Parent.Name' => 'Name of the parent Account'
  });
  ```

##### Auto-generate values for non required fields

You can auto-generate a value for a non required field by assigning the TDF.DEFAULT_VALUE to it, in the Map of values
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Description' => TDF.DEFAULT_VALUE,
    'Account.Phone' => TDF.DEFAULT_VALUE
  });
  ```

##### Force the instantiation of a related sObject

For example when creating a Contact you can force the Test Data Factory to create a related Account, even if an Account is not required
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'AccountId' => TDF.DEFAULT_VALUE
  });
  ```

##### Provide a map for a related sObject

You can provide a sub map of values for a related sObject
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Description' => 'Contact description',
    'Account' => new Map<String,Object>{
      'Name' => 'Account Name',
      'Description' => 'Account Description'
    }
  });
  ```

##### Provide an Id for a required related sObject to avoid its instantiation

You can provide an Id for a required related sObject, to force the use of that Id and prevent the instantiation of the related sObject
  ```apex
  User u = (User)TDF.createSObject('User', new Map<String,Object>{
    'ProfileId' => UserInfo.getProfileId()
  });
  ```

#### Create a list of sObjects:

##### Create and insert a list of Contact sObjects

Create & insert 10 contact sObject instances
  ```apex
  List<Contact> conList = TDF.createSObjectList('Contact',true,10);
  ```

##### Create and insert a list of Users using the index merge value

The following code creates 10 users with different usernames and nicknames 
  ```apex
  List<User> uList = TDF.createSObjectList('User', new Map<String,Object>{
    'ProfileId' => UserInfo.getProfileId(),
    'Username' => 'test{!index}@mytestdomain.developer',
    'CommunityNickname' => 'test{!index}'
  },10);
  ```


##### Create 5 Accounts with different names

Create a list of 5 Account sObjects with different names and a same description
  ```apex
  List<Account> accList = TDF.createSObjectList('Account', new Map<String,Object>{
    'Name' => new List<String>{'Alex','Jack','Susie','Sarah','Paul'}
    'Description' => 'Same description'
  },5);
  ```


##### Create 10 Cases related to 10 Accounts

Create a list of Acount sObjects and link them to a list of 10 Case sObjects
  ```apex
  List<Account> accList = TDF.createSObjectList('Account', new Map<String,Object>{
    'Description' => 'Account Description'
  },10);
  ```
  
  ```apex
  List<Case> caseList = TDF.createSObjectList('Case', new Map<String,Object>{
    'AccountId' => AccList,
    'Contact.AccountId' => AccList
  },10);
  ```

## Next

* [Core Concepts](CONCEPT.md)
