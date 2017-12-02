## Performance

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

  ```apex
  List<Contact> con = TDF.createSObjectList('Contact',true,10);
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

  ```apex
  List<Contact> con = TDF.createSObjectList('Contact',new Map<String,Object>{
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
