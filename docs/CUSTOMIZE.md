## Customize

You can customize the auto-generated data of the Test Data Factory 

#### Customize all the auto-generated data

Create a default value provider class by extending the ``TDF.ADefaultValueProvider``

  ```apex
  public class MyDefaultValueProvider extends TDF.ADefaultValueProvider{
  ...
    public override String getEmailDefaultValue(Schema.DescribeSObjectResult objectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
      return 'mycustomtestemail'+counter.format()+'@gmail.com';
    }
  ...
  }
  ```
  
  Set the TDF value provider in your test class 
  
  ```apex
  TDF.setDefaultValueProvider(new MyDefaultValueProvider());
  ```
 
  
 #### Customize the auto-generated data for some specific fields
 
  
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
  
  ```apex
  List<Contact> conList = TDF.createSObjectList('Contact', new Map<String,Object>{
    'Lastname' => new MyFieldDefaultValue('Contact.Lastname'),
    'Account.Name' => new MyFieldDefaultValue('Account.Name'),
  },10);
  ```
