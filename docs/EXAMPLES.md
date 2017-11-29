
## More examples


#### Methods of the TDF:


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
* createSObject(String sObjectName) // create an sObject with all required fields auto-filled
* createSObject(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride) // create an sObject with all required fields auto-filled and assign the values defined in the mapValuesOverride
* createSObject(String sObjectName,Boolean doInsert) // create an sObject with all required fields auto-filled and insert all if the doInsert = true
* createSObject(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride, Boolean doInsert) // create an sObject with all required fields auto-filled, assign the values defined in the mapValuesOverride and insert all if the doInsert = true

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
* createSObjectList(String sObjectName, Integer numberOfSObjects) // create a list of sObject with all required fields auto-filled
* createSObjectList(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride, Integer numberOfSObjects) // create a list of sObject with all required fields auto-filled and assign the values defined in the mapValuesOverride
* createSObjectList(String sObjectName, Boolean doInsert, Integer numberOfSObjects) // create a list of sObject with all required fields auto-filled and insert all if the doInsert = true
* createSObjectList(String sObjectName, Map&lt;String,Object&gt; mapValuesOverride, Boolean doInsert, Integer numberOfSObjects) // create a list of sObject with all required fields auto-filled, assign the values defined in the mapValuesOverride and insert all if the doInsert = true

</pre>
  </td>
</tr>
</table>


#### Create a single sObject:

##### Create an sObject using the sObject name or the sObject type
  ```apex
  // Using sObject name
  Contact con = (Contact)TDF.createSObject('Contact');
  
  // Using sObject Type
  Contact con = (Contact)TDF.createSObject(Contact.SObjectType);
  ```

##### Create an sObject by providing a map to assign values to fields in the main and the related sObjects

You can assign values to the main sObject and any related sObject, all sObjects will be created with the required fields auto-filled 
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'FirstName' => 'Doe',
    'LastName' => 'John',
    'Account.Description' => 'Description of the related account',
    'Account.Parent.Name' => 'Name of the parent Account'
  });
  ```

##### Create and insert an sObject
By default the created sObjects are not inserted, by providing the *doInsert* set to true, all the sObjects will be automatically inserted  
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'FirstName' => 'Doe',
    'LastName' => 'John',
  },true /* <-- doInsert flag */);
  ```

##### Auto generate value for non required fields

You can auto generate a value for non required field by assigning the TDF.DEFAULT_VALUE
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Description' => TDF.DEFAULT_VALUE,
    'Account.Phone' => TDF.DEFAULT_VALUE
  });
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

#### Create a list of sObjects:

##### Create an sObject using the sObject name or the sObject type

Create 10 contact sObject instances
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
