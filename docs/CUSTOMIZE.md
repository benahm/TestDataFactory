## Customize ⚙️

* [Extend TestDataFactory.DefaultValueProvider class](#extend-TestDataFactorydefaultvalueprovider-class)
* [Implement TestDataFactory.IFieldDefaultValue interface](#implement-TestDataFactoryifielddefaultvalue-interface)

You can customize the auto-generated data of the Test Data Factory 

### Extend TestDataFactory.DefaultValueProvider class

#### Customize the auto-generated data

Create a default value provider class by extending the virtual class ``TestDataFactory.DefaultValueProvider`` 

Implement the methods ``get{Type}DefaultValue`` that you want to override (available methods are listed in the table below)

  ```apex
public class MyDefaultValueProvider extends TestDataFactory.DefaultValueProvider{

	public override String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
		return 'mycustomtestemail'+counter.format()+'@gmail.com';
	}

}
  ```
 
 Here is the list of supported datatypes and the method that defines the default value for each type and their default value

| Salesforce    Datatype | Method                       | Default value for the creation of a single sObject               | Default value for the creation of a list of sObject |
|------------------------|------------------------------|------------------------------------------------------------------|-----------------------------------------------------|
| Base64                 | getBase64DefaultValue        | Blob.valueOf(0)                                                  | Blob.valueOf(recordIndex)                           |
| Checkbox               | getCheckboxDefaultValue      | False                                                            | //                                                  |
| Currency               | getCurrencyDefaultValue      | 0                                                                | recordIndex                                         |
| Date                   | getDateDefaultValue          | Date.today()                                                     | //                                                  |
| DateTime               | getDateTimeDefaultValue      | Datetime.now()                                                   | //                                                  |
| Email                  | getEmailDefaultValue         | 'test0@example.com'                                              | 'test'+recordIndex+'@example.com'                   |
| Geolocation            | getGeolocationDefaultValue   | Location.newInstance(0,0)                                        | //                                                  |
| Number                 | getNumberDefaultValue        | 0                                                                | recordIndex                                         |
| Percent                | getPercentDefaultValue       | 0                                                                | recordIndex                                         |
| Phone                  | getPhoneDefaultValue         | '01 23 45 67 89'                                                 | //                                                  |
| Picklist               | getPicklistDefaultValue      | The default value of the picklist otherwise the first value      | //                                                  |
| MultiPicklist          | getMultiPicklistDefaultValue | The default value of the multipicklist otherwise the first value | //                                                  |
| Text                   | getTextDefaultValue          | 'test0'                                                          | 'test'+recordIndex                                  |
| TextArea               | getTextAreaDefaultValue      | 'test0'                                                          | 'test'+recordIndex                                  |
| Time                   | getTimeDefaultValue          | Time.newInstance(12, 0, 0, 0)                                    | //                                                  |
| URL                    | getURLDefaultValue           | 'http://test0.com'                                               | 'http://test'+RecordIndex+'.com'                    |


*recordIndex* : index number (starting from 0) of each record when creating a list of sObjects

*//* : same value
 
#### Define required fields and/or optional fields 

* You can force  non-required field to behave as a required field (example if a field is part of a validation rule)
* You can force a required field to behave as a non-required field (example if a field is required but get its value from a trigger)

In the example below the fields *Firstname*, *Description* and *Email* of the Contact are defined as required fields so the Test Data Factory will auto-generate default values for those fields each time a Contact is created 

The field Lastname of the Contact is defined as optional so the Test Data Factory will not generate a default value for it

  ```apex
public class MyDefaultValueProvider extends TestDataFactory.DefaultValueProvider{     
    public override Set<String> defineSObjectRequiredFields(Schema.SObjectType sObjectType){
        if(sObjectType == Contact.SObjectType){
            return new Set<String>{
                'Firstname',
                'Description',
                'Email'
            };
        }
        return null;
    }
    public override Set<String> defineSObjectOptionalFields(Schema.SObjectType sObjectType){
        if(sObjectType == Contact.SObjectType){
            return new Set<String>{
                'Lastname'
            };
        }
        return null;
    }
}
  ```  
  
Using your custom default value provider class
  
**Apply it to the current transaction**:
  
Set your default value provider class as the default one before using the Test Data Factory
  
```apex
TestDataFactory.defaultValueProvider = new MyDefaultValueProvider();
```
 
**Apply it globally**:
 
In the TestDataFactory class, change default value provider from the `DefaultValueProvider` to your custom default value provider class

```apex
/** Default value provider instance */
private static DefaultValueProvider dvPrvdr = new DefaultValueProvider();
```

Apply your custom default value provider like below

```apex
/** Default value provider instance */
private static DefaultValueProvider dvPrvdr = new MyDefaultValueProvider();
```
 
  
 ### Implement TestDataFactory.IFieldDefaultValue interface
 
 Create a class that implements ``TestDataFactory.IFieldDefaultValue`` 
 
 ``getValue`` method give access to the counter
 
 In this example we will create 100 Accounts that will be used to create 100 Cases 
  
  ```apex
public class AccountIdWrapper implements TestDataFactory.IFieldDefaultValue{
	private List<Account> AccountList = null;

	public AccountIdWrapper(List<Account> accountList){
		this.accountList = accountList;
	}

	public Object getValue(Integer counter){
		return accountList.get(counter).Id;
	}
}
  ```
  Provide the instance of your field default value in the map override for the ``TestDataFactory.createSObjectList`` method
  
  ```apex


// creating 100 Accounts
List<Account> accountList = TestDataFactory.createSObjectList('Account', new Map<String,Object>{
	'Description' => 'test'
},true,100);

AccountIdWrapper accIdWrapped = new AccountIdWrapper(accountList);

// creating 100 Cases
List<Case> caseList = TestDataFactory.createSObjectList('Case',new Map<String,Object>{
	'AccountId' => accIdWrapped
	'Contact.Description' => 'Create the related Contact',
	'Contact.AccountId' => accIdWrapped
},true,100);
  ```
  
## Next

* [Contribute 👐](CONTRIBUTE.md)
