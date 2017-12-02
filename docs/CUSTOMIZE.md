## Customize

You can customize the auto-generated data of the Test Data Factory 

#### Customize all the auto-generated data

Extending TDF.ADefaultValueProvider

  ```apex
  public class MyDefaultValueProvider extends TDF.ADefaultValueProvider{
  ...
    public override String getEmailDefaultValue(Schema.DescribeSObjectResult objectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
      return 'mycustomtestemail'+counter.format()+'@gmail.com';
    }
  ...
  }
  ```
  
  
  ```apex
  TDF.setDefaultValueProvider(new MyDefaultValueProvider());
  ```
  
  
 #### Customize the auto-generated a specific field
 
  
  ```apex
  public class MyFieldDefaultValue implements TDF.IFieldDefaultValue{
    public Object getValue(Integer counter){
      return 'MyContactLastName'+counter.format();
    }
  }
  ```
  
  ```apex
  List<Contact> conList = TDF.createSObjectList('Contact', new Map<String,Object>{
    'Lastname' => new MyFieldDefaultValue(),
    'Account.Description' => 'Text for the Description field on the Account'
  },10);
  ```
