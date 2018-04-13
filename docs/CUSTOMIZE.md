## Customize

* [Extend TDF.DefaultValueProvider class](#extend-tdf-defaultvalueprovider-class)
* [Implement TDF.IFieldDefaultValue interface](#customize-the-auto-generated-data-for-some-specific-fields)

You can customize the auto-generated data of the Test Data Factory 

#### Extend TDF.DefaultValueProvider class

###### Customize all the auto-generated data

Create a default value provider class by extending the virtual class ``TDF.DefaultValueProvider`` 

Implement the methods ``get{Type}DefaultValue`` that you want to override

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
 
Define required fields and/or optional fields 

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
  
  Set the TDF value provider in your test class 
  
  ```apex
  TDF.defaultValueProvider = new MyDefaultValueProvider();
  ```
 
  
 #### Customize the auto-generated data for some specific fields
 
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
