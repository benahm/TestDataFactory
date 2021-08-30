# Apex Test Data Factory


<p align="center"><img src ="/docs/assets/logo.png" width="400"/></p>




#### “ The ultimate Apex Test Data Factory ” :factory: :ok_hand:

Generate & insert an sObject with all the required fields & relationships auto-filled
  ```apex
  Contact con = (Contact)TestDataFactory.createSObject('Contact');
  ```

Inserted data*:
  ```javascript
  Contact:{Id='0036E00000R4nG0QAJ', Lastname:'test0'}
  ```

<br/>

Assign values to fields of the main sObject and the related sObjects
  ```apex
  Contact con = (Contact)TestDataFactory.createSObject('Contact', new Map<String,Object>{
    'Email' => 'test@email.com',
    'Account.Description' => 'Text for the Description field on the Account'
  });
  ```
 
Inserted data*:
  ```apex
  Contact:{Id='0036E00000R55chQAB', Lastname:'test0', Email:'test@email.com', AccountId='0016E00000Z6bC7QAJ'}
  Account:{Id='0016E00000Z6bC7QAJ', Name='test0', Description='Text for the Description field on the Account'}
  ```
<br/>



  \* *in a non-customized org*
  
  
  ### Install :

Get the ``TestDataFactory`` class by installing the [TestDataFactory Unlocked Package](https://test.salesforce.com/packaging/installPackage.apexp?p0=004t1n000002WsK5AAK) 🔓📦 in your org using the UI or by running the following sfdx command

    sfdx force:package:install --wait 10 --publishwait 10 --package 004t1n000002WsK5AAK -r -u AliasOfYourOrg

  
  ### More :
* [Examples 💻](/docs/EXAMPLES.md)
* [Core Concepts 💡](/docs/CONCEPT.md)
* [Performance 🚀](/docs/PERFORMANCE.md)
* [Customize ⚙️](/docs/CUSTOMIZE.md)
* [Limitations 🛑](/docs/LIMITATIONS.md)
* [Contribute 👐](/docs/CONTRIBUTE.md)



### [Releases 📦](https://github.com/benahm/TestDataFactory/releases)
### [License 🔰](LICENSE)

Apache 2.0
