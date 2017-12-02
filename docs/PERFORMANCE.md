## Performance

Tests made in a Developer Org, without any active automations(Worfklow rules/Process Builder/Flow), Triggers or Validations rules on the Case, Contact and Account objects

#### Test #1

Create one instance of the Contact sObject

  ```apex
  Contact con = (Contact)TDF.createSObject('Contact',true);
  ```


> LIMIT_USAGE_… Number of SOQL queries: 0 out of 100<br/>
LIMIT_USAGE_… Number of query rows: 0 out of 50000<br/>
LIMIT_USAGE_… Number of SOSL queries: 0 out of 20<br/>
LIMIT_USAGE_… **Number of DML statements: 1 out of 150**<br/>
LIMIT_USAGE_… **Number of DML rows: 1 out of 10000**<br/>
LIMIT_USAGE_… Maximum CPU time: 0 out of 10000<br/>
LIMIT_USAGE_… Maximum heap size: 0 out of 6000000<br/>
LIMIT_USAGE_… Number of callouts: 0 out of 100<br/>
LIMIT_USAGE_… Number of Email Invocations: 0 out of 10<br/>
LIMIT_USAGE_… Number of future calls: 0 out of 50<br/>
LIMIT_USAGE_… Number of queueable jobs added to the queue: 0 out of 50<br/>
LIMIT_USAGE_… Number of Mobile Apex push calls: 0 out of 10
  
---

#### Test #2

Create 10 instances of the Contact sObject

  ```apex
  List<Contact> conList = TDF.createSObjectList('Contact',true,10);
  ```


> LIMIT_USAGE_… Number of SOQL queries: 0 out of 100<br/>
LIMIT_USAGE_… Number of query rows: 0 out of 50000<br/>
LIMIT_USAGE_… Number of SOSL queries: 0 out of 20<br/>
LIMIT_USAGE_… **Number of DML statements: 1 out of 150**<br/>
LIMIT_USAGE_… **Number of DML rows: 10 out of 10000**<br/>
LIMIT_USAGE_… Maximum CPU time: 0 out of 10000<br/>
LIMIT_USAGE_… Maximum heap size: 0 out of 6000000<br/>
LIMIT_USAGE_… Number of callouts: 0 out of 100<br/>
LIMIT_USAGE_… Number of Email Invocations: 0 out of 10<br/>
LIMIT_USAGE_… Number of future calls: 0 out of 50<br/>
LIMIT_USAGE_… Number of queueable jobs added to the queue: 0 out of 50<br/>
LIMIT_USAGE_… Number of Mobile Apex push calls: 0 out of 10

----

#### Test #3

Create one instance of the Contact sObject and its related Account sObject

  ```apex
  Contact con = (Contact)TDF.createSObject('Contact',new Map<String,Object>{
	  'Account.Description' => 'Create the related Account'
  },true);
  ```


> LIMIT_USAGE_… Number of SOQL queries: 0 out of 100<br/>
LIMIT_USAGE_… Number of query rows: 0 out of 50000<br/>
LIMIT_USAGE_… Number of SOSL queries: 0 out of 20<br/>
LIMIT_USAGE_… **Number of DML statements: 2 out of 150**<br/>
LIMIT_USAGE_… **Number of DML rows: 2 out of 10000**<br/>
LIMIT_USAGE_… Maximum CPU time: 0 out of 10000<br/>
LIMIT_USAGE_… Maximum heap size: 0 out of 6000000<br/>
LIMIT_USAGE_… Number of callouts: 0 out of 100<br/>
LIMIT_USAGE_… Number of Email Invocations: 0 out of 10<br/>
LIMIT_USAGE_… Number of future calls: 0 out of 50<br/>
LIMIT_USAGE_… Number of queueable jobs added to the queue: 0 out of 50<br/>
LIMIT_USAGE_… Number of Mobile Apex push calls: 0 out of 10

----

#### Test #4

Create 10 instances of the Contact sObject and its related Account sObjects

  ```apex
  List<Contact> conList = TDF.createSObjectList('Contact',new Map<String,Object>{
    'Account.Description' => 'Create the related Account'
  },true,10);
  ```


> LIMIT_USAGE_… Number of SOQL queries: 0 out of 100<br/>
LIMIT_USAGE_… Number of query rows: 0 out of 50000<br/>
LIMIT_USAGE_… Number of SOSL queries: 0 out of 20<br/>
LIMIT_USAGE_… **Number of DML statements: 2 out of 150**<br/>
LIMIT_USAGE_… **Number of DML rows: 2 out of 10000**<br/>
LIMIT_USAGE_… **Maximum CPU time: 219 out of 10000**<br/>
LIMIT_USAGE_… Maximum heap size: 0 out of 6000000<br/>
LIMIT_USAGE_… Number of callouts: 0 out of 100<br/>
LIMIT_USAGE_… Number of Email Invocations: 0 out of 10<br/>
LIMIT_USAGE_… Number of future calls: 0 out of 50<br/>
LIMIT_USAGE_… Number of queueable jobs added to the queue: 0 out of 50<br/>
LIMIT_USAGE_… Number of Mobile Apex push calls: 0 out of 10


----

  ```apex
  List<Case> caseList = TDF.createSObjectList('Case',new Map<String,Object>{
    'Account.Description' => 'Create the related Account',
    'Contact.Description' => 'Create the related Contact',
    'Contact.Account.Description' => 'Create the related Account for the related Contact'
  },true,200);
  ```


> LIMIT_USAGE_… Number of SOQL queries: 0 out of 100<br/>
LIMIT_USAGE_… Number of query rows: 0 out of 50000<br/>
LIMIT_USAGE_… Number of SOSL queries: 0 out of 20<br/>
LIMIT_USAGE_… **Number of DML statements: 4 out of 150**<br/>
LIMIT_USAGE_… **Number of DML rows: 800 out of 10000**<br/>
LIMIT_USAGE_… **Maximum CPU time: 7612 out of 10000** ******* CLOSE TO LIMIT<br/>
LIMIT_USAGE_… Maximum heap size: 0 out of 6000000<br/>
LIMIT_USAGE_… Number of callouts: 0 out of 100<br/>
LIMIT_USAGE_… Number of Email Invocations: 0 out of 10<br/>
LIMIT_USAGE_… Number of future calls: 0 out of 50<br/>
LIMIT_USAGE_… Number of queueable jobs added to the queue: 0 out of 50<br/>
LIMIT_USAGE_… Number of Mobile Apex push calls: 0 out of 10
