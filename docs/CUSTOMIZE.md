## Customize

* [Extend TDF.DefaultValueProvider class](#extend-tdfdefaultvalueprovider-class)
* [Implement TDF.IFieldDefaultValue interface](#implement-tdfifielddefaultvalue-interface)

You can customize the auto-generated data of the Test Data Factory 

### Extend TDF.DefaultValueProvider class

#### Customize the auto-generated data

Create a default value provider class by extending the virtual class ``TDF.DefaultValueProvider`` 

Implement the methods ``get{Type}DefaultValue`` that you want to override (available methods are listed in the table below)

  ```apex
public class MyDefaultValueProvider extends TDF.DefaultValueProvider{

	public override String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
		return 'mycustomtestemail'+counter.format()+'@gmail.com';
	}

}
  ```
 
 Here is the list of support datatypes and the method that defines the default value for each type

| Salesforce    Datatype | Method                       |
|------------------------|------------------------------|
| Base64                 | getBase64DefaultValue        |
| Checkbox               | getCheckboxDefaultValue      |
| Currency               | getCurrencyDefaultValue      |
| Date                   | getDateDefaultValue          |
| DateTime               | getDateTimeDefaultValue      |
| Email                  | getEmailDefaultValue         |
| Geolocation            | getGeolocationDefaultValue   |
| Number                 | getNumberDefaultValue        |
| Percent                | getPercentDefaultValue       |
| Phone                  | getPhoneDefaultValue         |
| Picklist               | getPicklistDefaultValue      |
| MultiPicklist          | getMultiPicklistDefaultValue |
| Text                   | getTextDefaultValue          |
| TextArea               | getTextAreaDefaultValue      |
| Time                   | getTimeDefaultValue          |
| URL                    | getURLDefaultValue           |
 
#### Define required fields and/or optional fields 

* You can force  non-required field to behave as a required field (example if a field is part of a validation rule)
* You can force a required field to behave as a non-required field (example if a field is required but get its value from a trigger)

In the example below the fields Firstname, Description and Email of the Contact are defined as required fields so the Test Data Factory will generate default values for those fields each time a Contact is created 

The field Lastname of the Contact is defined as optional so the Test Data Factory will not generate a default value for it

  ```apex
public class MyDefaultValueProvider extends TDF.DefaultValueProvider{     
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
  
Use your custom default value provider class
  
**Apply it to the current transaction**:
  
Set your default value provider class as the default one before using the Test Data Factory
  
```apex
TDF.defaultValueProvider = new MyDefaultValueProvider();
```
 
**Apply it globally**:
 
In the TDF class, change default value provider from the `DefaultValueProvider` to your custom default value provider 

```apex
/** Default value provider instance */
private static DefaultValueProvider dvPrvdr = new DefaultValueProvider();
```

Apply your custom default value provider like below

```apex
/** Default value provider instance */
private static DefaultValueProvider dvPrvdr = new MyDefaultValueProvider();
```
 
  
 ### Implement TDF.IFieldDefaultValue interface
 
 Create a class that implements ``TDF.IFieldDefaultValue`` 
 
 ``getValue`` method give access to the counter
 
 In this example we will create 100 Accounts that will be used to create 100 Cases 
  
  ```apex
public class AccountIdWrapper implements TDF.IFieldDefaultValue{
	private List<Account> AccountList = null;

	public AccountIdWrapper(List<Account> accountList){
		this.accountList = accountList;
	}

	public Object getValue(Integer counter){
		return accountList.get(counter).Id;
	}
}
  ```
  Provide the instance of your field default value in the map override for the ``TDF.createSObjectList`` method
  
  ```apex


// creating 100 Accounts
List<Account> accountList = TDF.createSObjectList('Account', new Map<String,Object>{
	'Description' => 'test'
},true,100);

AccountIdWrapper accIdWrapped = new AccountIdWrapper(accountList);

// creating 100 Cases
List<Case> caseList = TDF.createSObjectList('Case',new Map<String,Object>{
	'AccountId' => accIdWrapped
	'Contact.Description' => 'Create the related Contact',
	'Contact.AccountId' => accIdWrapped
},true,100);
  ```
  
## Next

* [Contribute](CONTRIBUTE.md)
