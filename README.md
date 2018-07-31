# Apex Test Data Factory


<p align="center"><img src ="/docs/assets/TDF.png" width="500"/></p>




#### “ The ultimate Apex Test Data Factory ” :factory: :ok_hand:

Generate & insert an sObject with all the required fields & relationships auto-filled
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact',true);
  ```

Inserted data*:
  ```javascript
  Contact:{Id='0036E00000R4nG0QAJ', Lastname:'test0'}
  ```

<br/>

Assign values to fields of the main sObject and the related sObjects
  ```apex
  Contact con = (Contact)TDF.createSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com',
    'Account.Description' => 'Text for the Description field on the Account'
  },true);
  ```
 
Inserted data*:
  ```apex
  Contact:{Id='0036E00000R55chQAB', Lastname:'test0', Email:'test@email.com', AccountId='0016E00000Z6bC7QAJ'}
  Account:{Id='0016E00000Z6bC7QAJ', Name='test0', Description='Text for the Description field on the Account'}
  ```
<br/>



  \* *in a vanilla org*
  
  ### More :
* [Usage](/docs/USAGE.md)
* [Examples](/docs/EXAMPLES.md)
* [Core Concepts](/docs/CONCEPT.md)
* [Performance](/docs/PERFORMANCE.md)
* [Customize](/docs/CUSTOMIZE.md)
* [Contribute](/docs/CONTRIBUTE.md)



### [Releases](https://github.com/benahm/TDF/releases)
### [License](LICENSE)

Apache 2.0
