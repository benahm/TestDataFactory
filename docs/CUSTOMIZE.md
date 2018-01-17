## Customize

* [Extend TDF.ADefaultValueProvider class](#customize-all-the-auto-generated-data)
* [Implement TDF.IFieldDefaultValue interface](#customize-the-auto-generated-data-for-some-specific-fields)

You can customize the auto-generated data of the Test Data Factory 

#### Customize all the auto-generated data

Create a default value provider class by extending the ``TDF.ADefaultValueProvider`` 

Implement all the methods ``get{Type}DefaultValue``

  ```apex
  public class MyDefaultValueProvider extends TDF.ADefaultValueProvider{
  ...
    public override String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
      return 'mycustomtestemail'+counter.format()+'@gmail.com';
    }
  ...
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
 
  Set the TDF value provider in your test class 
  
  ```apex
  TDF.setDefaultValueProvider(new MyDefaultValueProvider());
  ```
 
  
 #### Customize the auto-generated data for some specific fields
 
 Create a class that implements ``TDF.IFieldDefaultValue``
  
  ```apex
  public class MyFieldDefaultValue implements TDF.IFieldDefaultValue{
    private String fieldName = null;
    
    public MyFieldDefaultValue(String fieldName){
      this.fieldName = fieldName;
    }
    
    public Object getValue(Integer counter){
      if(fieldName == 'Contact.Lastname')
        return 'MyContactLastName'+counter.format();
      else if(fieldName == 'Account.Name')
        return 'MyAccountName'+counter.format();
      return 'test'+counter.format();
    }
  }
  ```
  Provide the instance of your field default value in the map override ``TDF.createSObject`` or ``TDF.createSObjectList``
  
  ```apex
  List<Contact> conList = TDF.createSObjectList('Contact', new Map<String,Object>{
    'Lastname' => new MyFieldDefaultValue('Contact.Lastname'),
    'Account.Name' => new MyFieldDefaultValue('Account.Name')
  },10);
  ```

## Next

* [Contribute](CONTRIBUTE.md)
