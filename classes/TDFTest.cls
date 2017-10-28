/**
* @author benahm
* @date 2017
* @description TDF Class
*/
@isTest
private class TDFTest {
	/************************* TTDF tests *************************/
	@isTest static void createSObjectTest1(){
		SObject sObj = TDF.createSObject('Account');
		System.assertNotEquals(null,sObj);
	}
	@isTest static void createSObjectTest2(){
		SObject sObj = TDF.createSObject(Account.SObjectType);
		System.assertNotEquals(null,sObj);
	}
	@isTest static void createSObjectTest3(){
		SObject sObj = TDF.createSObject('Account',new Map<String,Object>());
		System.assertNotEquals(null,sObj);
	}
	@isTest static void createSObjectTest4(){
		SObject sObj = TDF.createSObject(Account.SObjectType,new Map<String,Object>());
		System.assertNotEquals(null,sObj);
	}
	@isTest static void createSObjectTest5(){
		SObject sObj = TDF.createSObject('Account',false);
		System.assertNotEquals(null,sObj);
	}	
	@isTest static void createSObjectTest6(){
		SObject sObj = TDF.createSObject(Account.SObjectType,false);
		System.assertNotEquals(null,sObj);
	}	
	@isTest static void createSObjectTest7(){
		SObject sObj = TDF.createSObject('Account',new Map<String,Object>(),false);
		System.assertNotEquals(null,sObj);
	}	
	@isTest static void createSObjectTest8(){
		SObject sObj = TDF.createSObject(Account.SObjectType,new Map<String,Object>(),false);
		System.assertNotEquals(null,sObj);
	}
	@isTest static void createSObjectTest9(){
		TDF.ISObjectFactory factory = new TDF.SObjectFactory();
		SObject sObj = TDF.createSObject('Case', new Map<String,Object>{
				'aCCount.Description' => 'test',
				'ConTact.FirstName'=> 'test',
				'Description' => 'test',
				'asset.accounT.description' => 'test',
				'asset.contact.account.Description' => 'test',
				'asset.Parent.contact.account.Description' => 'test'
			},true);
		Case cse = [select Asset.Parent.Contact.Account.Name from Case limit 1];
		System.assertEquals('test0',cse.Asset.Parent.Contact.Account.Name);
	}
	@isTest static void createSObjectListTest1(){
		List<SObject> sObjList = TDF.createSObjectList('Account',5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest2(){
		List<SObject> sObjList = TDF.createSObjectList(Account.SObjectType,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest3(){
		List<SObject> sObjList = TDF.createSObjectList('Account',new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest4(){
		List<SObject> sObjList = TDF.createSObjectList(Account.SObjectType,new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest5(){
		List<SObject> sObjList = TDF.createSObjectList('Account',false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest6(){
		List<SObject> sObjList = TDF.createSObjectList(Account.SObjectType,false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}	
	@isTest static void createSObjectListTest7(){
		List<SObject> sObjList = TDF.createSObjectList('Account',new Map<String,Object>(),false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest8(){
		List<SObject> sObjList = TDF.createSObjectList(Account.SObjectType,new Map<String,Object>(),false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void setDefaultValueProviderTest(){
		System.assertEquals(null,TDF.dvPrvdrOverride);
		TDF.setDefaultValueProvider(null);
		System.assertEquals(null,TDF.dvPrvdrOverride);
		TDF.setDefaultValueProvider(new TDF.DefaultValueProvider());
		System.assertNotEquals(null,TDF.dvPrvdrOverride);
	}

	/************************* SObjectManager tests *************************/
	@isTest static void getSObjectListTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		System.assertNotEquals(null,sObjManager.getSObjectList());
		System.assertEquals(0,sObjManager.getSObjectList().size());
		sObjManager.mainSObjectList.add(new Contact());
		System.assertEquals(1,sObjManager.getSObjectList().size());
	}
	@isTest static void setSObjectTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		sObjManager.setSObject(0,new Contact(FirstName='test1'));
		System.assertEquals(1,sObjManager.mainSObjectList.size());
		System.assertEquals('test1',((Contact)sObjManager.mainSObjectList.get(0)).FirstName);
		sObjManager.setSObject(1,new Contact(FirstName='test2'));
		System.assertEquals(2,sObjManager.mainSObjectList.size());
		System.assertEquals('test1',((Contact)sObjManager.mainSObjectList.get(0)).FirstName);
		System.assertEquals('test2',((Contact)sObjManager.mainSObjectList.get(1)).FirstName);
		sObjManager.setSObject(0,new Contact(FirstName='test3'));
		System.assertEquals(2,sObjManager.mainSObjectList.size());
		System.assertEquals('test3',((Contact)sObjManager.mainSObjectList.get(0)).FirstName);
		System.assertEquals('test2',((Contact)sObjManager.mainSObjectList.get(1)).FirstName);
	}
	@isTest static void getSObjectTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		System.assertEquals(null,sObjManager.getSObject(0));
		System.assertEquals(null,sObjManager.getSObject(1));
		sObjManager.mainSObjectList.add(new Contact());
		System.assertNotEquals(null,sObjManager.getSObject(0));
	}
	@isTest static void setRelationshipTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		sObjManager.setRelationship(0,'contact',new Contact(FirstName='test1'));
		System.assertNotEquals(null,sObjManager.relatedSObjMapList.get('contact'));
		System.assertEquals(1,sObjManager.relatedSObjMapList.get('contact').size());
		System.assertEquals('test1',((Contact)sObjManager.relatedSObjMapList.get('contact').get(0)).FirstName);
		sObjManager.setRelationship(1,'contact',new Contact(FirstName='test2'));
		System.assertEquals(2,sObjManager.relatedSObjMapList.get('contact').size());
		System.assertEquals('test1',((Contact)sObjManager.relatedSObjMapList.get('contact').get(0)).FirstName);
		System.assertEquals('test2',((Contact)sObjManager.relatedSObjMapList.get('contact').get(1)).FirstName);
		sObjManager.setRelationship(0,'contact',new Contact(FirstName='test3'));
		System.assertEquals(2,sObjManager.relatedSObjMapList.get('contact').size());
		System.assertEquals('test3',((Contact)sObjManager.relatedSObjMapList.get('contact').get(0)).FirstName);
		System.assertEquals('test2',((Contact)sObjManager.relatedSObjMapList.get('contact').get(1)).FirstName);
	}
	@isTest static void getRelationshipTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		System.assertEquals(null,sObjManager.getRelationship(0,'contact'));
		sObjManager.relatedSObjMapList.put('contact',new List<SObject>());
		System.assertEquals(null,sObjManager.getRelationship(0,'contact'));
		sObjManager.relatedSObjMapList.put('contact',new List<SObject>{new Contact()});
		System.assertNotEquals(null,sObjManager.getRelationship(0,'contact'));
		System.assertNotEquals(null,sObjManager.getRelationship(0,'ConTacT'));
	}
	@isTest static void insertAllSObjectsTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		Account acc = new Account(Name='test');
		Contact con = new Contact(LastName='test');
		sObjManager.mainSObjectList.add(con);
		sObjManager.relatedSObjMapList.put('account',new List<SObject>{acc});
		sObjManager.orderedRelationshipList.add('account');
		try {
			sObjManager.insertAllSObjects();
		}catch(DmlException e){
			System.debug(e);
			System.assert(true); // missing required fields
		}
		List<Contact> conList = [select LastName, Account.Name from Contact limit 1];
		System.assertNotEquals(null,conList);
		System.assertEquals(1,conList.size());
		System.assertEquals('test',conList.get(0).LastName);
		System.assertEquals('test',conList.get(0).Account.Name);
	}
	@isTest static void setChildParentRelationshipTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		List<Account> accList = new List<Account>{new Account(Name='test')};
		List<Contact> conList = new List<Contact>{new Contact(LastName='test')};
		try {
			insert accList;
			sObjManager.setChildParentRelationship(conList,accList,'Account');
		}catch(DmlException e){
			System.debug(e);
			System.assert(true); // missing required fields
		}
		System.assertNotEquals(null,conList.get(0).AccountId);
	}
	@isTest static void addRelationshipNameTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		sObjManager.addRelationshipName('Contact');
		System.assertNotEquals(null,sObjManager.orderedRelationshipList);
		System.assertEquals(1,sObjManager.orderedRelationshipList.size());
		sObjManager.addRelationshipName('Contact.Account');
		System.assertEquals(2,sObjManager.orderedRelationshipList.size());
		System.assertEquals('contact.account',sObjManager.orderedRelationshipList.get(0));
		System.assertEquals('contact',sObjManager.orderedRelationshipList.get(1));
	}

	/************************* SObjectFactory tests *************************/
	@isTest static void sObjectManagerInstanceTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		System.assertNotEquals(null,sObjFactory.getDefaultValueProvider());
		sObjFactory = new TDF.SObjectFactory(null);
		System.assertNotEquals(null,sObjFactory.getDefaultValueProvider());
		sObjFactory = new TDF.SObjectFactory(new TDF.DefaultValueProvider());
		System.assertNotEquals(null,sObjFactory.getDefaultValueProvider());
	}	
	@isTest static void getSObjectManagerTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		System.assertNotEquals(null,sObjFactory.getSObjectManager());
	}	
	@isTest static void getDefaultValueProviderTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		System.assertNotEquals(null,sObjFactory.getDefaultValueProvider());
	}
	@isTest static void getSObjectInstanceTest1(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		SObject sObj = sObjFactory.getSObjectInstance('Account');
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getSObjectInstanceTest2(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		SObject sObj = sObjFactory.getSObjectInstance(Account.SObjectType);
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getSObjectInstanceTest3(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		SObject sObj = sObjFactory.getSObjectInstance('Account', new Map<String,Object>());
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getSObjectInstanceTest4(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		SObject sObj = sObjFactory.getSObjectInstance(Account.SObjectType, new Map<String,Object>());
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest1(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		List<SObject> sObjList = sObjFactory.getListSObjectInstance('Account',5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest2(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		List<SObject> sObjList = sObjFactory.getListSObjectInstance(Account.SObjectType,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest3(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		List<SObject> sObjList = sObjFactory.getListSObjectInstance('Account',new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest4(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		List<SObject> sObjList = sObjFactory.getListSObjectInstance(Account.SObjectType,new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest5(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		List<SObject> sObjList = sObjFactory.getListSObjectInstance(Contact.SObjectType,new Map<String,Object>{'Account.Description' => 'test'},5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Contact.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getRelationshipInstanceTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		SObject sObj = sObjFactory.getRelationshipInstance(Case.SObjectType,'Contact.Account',0);
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getRelatedSObjectInstanceTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		SObject sObj = sObjFactory.getRelatedSObjectInstance(Contact.SObjectType,'AccountId');
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	
	/************************* DefaultValueProvider tests *************************/
	@isTest static void getDefaultMapTest1(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapValues = dvProvider.getDefaultMap(Opportunity.SObjectType,new Set<String>());
		System.assertEquals('test0',mapValues.get('name'));
		System.assertNotEquals('',mapValues.get('stagename'));
		System.assertEquals(Date.today(),mapValues.get('closedate'));
	}
	@isTest static void getDefaultMapTest2(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapValues = dvProvider.getDefaultMap('Opportunity',new Set<String>());
		System.assertEquals('test0',mapValues.get('name'));
		System.assertNotEquals('',mapValues.get('stagename'));
		System.assertEquals(Date.today(),mapValues.get('closedate'));
	}
	@isTest static void getDefaultMapTest3(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapValues = dvProvider.getDefaultMap(Contract.SObjectType,new Set<String>());
		System.assertEquals(null,mapValues.get('account.id'));
		System.assertEquals('test0',mapValues.get('account.name'));
	}
	@isTest static void getDefaultPicklistValueTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		String defaultValue = dvProvider.getDefaultPicklistValue(Contract.fields.Status.getDescribe());
		System.assertNotEquals(null,defaultValue);
		System.assertNotEquals('',defaultValue);
	}
	@isTest static void getDefaultValueTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvProvider.getDefaultValue(Attachment.fields.Body.getDescribe(),0));
		System.assertEquals(true,dvProvider.getDefaultValue(Campaign.fields.IsActive.getDescribe(),0));
		System.assertEquals('0',dvProvider.getDefaultValue(Event.fields.Subject.getDescribe(),0));
		System.assertEquals('0',dvProvider.getDefaultValue(Lead.fields.AnnualRevenue.getDescribe(),0));
		System.assertEquals(Date.today(),dvProvider.getDefaultValue(Account.fields.LastActivityDate.getDescribe(),0));
		System.assertEquals(Datetime.now(),dvProvider.getDefaultValue(Account.fields.CreatedDate.getDescribe(),0));
		System.assertEquals(0,dvProvider.getDefaultValue(Asset.fields.Quantity.getDescribe(),0));
		System.assertEquals('test0@email.com',dvProvider.getDefaultValue(Contact.fields.Email.getDescribe(),0));
		//System.assertEquals('secret0',dvProvider.getDefaultValue(ExternalDataUserAuth.fields.Password.getDescribe(),0));
		System.assertEquals(null,dvProvider.getDefaultValue(Account.fields.Id.getDescribe(),0));
		System.assertEquals(0,dvProvider.getDefaultValue(Attachment.fields.BodyLength.getDescribe(),0));
		//System.assertNotEquals('',dvProvider.getDefaultValue(Group.fields.Categories.getDescribe(),0));
		System.assertEquals(0,dvProvider.getDefaultValue(Opportunity.fields.Probability.getDescribe(),0));
		System.assertEquals('123456789',dvProvider.getDefaultValue(Contact.fields.Phone.getDescribe(),0));
		System.assertNotEquals('',dvProvider.getDefaultValue(Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getDefaultValue(Contact.fields.FirstName.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getDefaultValue(Account.fields.Description.getDescribe(),0));
		// no time field
		//System.assertEquals('http://test0.com',dvProvider.getDefaultValue(Weblink.fields.URL.getDescribe(),0));
		System.assertEquals(null,dvProvider.getDefaultValue(null,0));
	}
	@isTest static void getTypeDefaultValueTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvProvider.getBase64DefaultValue(null,0));
		System.assertEquals(true,dvProvider.getBooleanDefaultValue(null,0));
		System.assertEquals('0',dvProvider.getComboboxDefaultValue(null,0));
		System.assertEquals('0',dvProvider.getCurrencyDefaultValue(null,0));
		System.assertEquals(Date.today(),dvProvider.getDateDefaultValue(null,0));
		System.assertEquals(Datetime.now(),dvProvider.getDateTimeDefaultValue(null,0));
		System.assertEquals(0,dvProvider.getDoubleDefaultValue(null,0));
		System.assertEquals('test0@email.com',dvProvider.getEmailDefaultValue(null,0));
		System.assertEquals('secret0',dvProvider.getEncryptedStringDefaultValue(null,0));
		System.assertEquals(null,dvProvider.getIDDefaultValue(null,0));
		System.assertEquals(0,dvProvider.getIntegerDefaultValue(null,0));
		System.assertEquals(null,dvProvider.getMultiPicklistDefaultValue(null,0));
		System.assertNotEquals('',dvProvider.getMultiPicklistDefaultValue(Account.fields.Type.getDescribe(),0));
		System.assertEquals(0,dvProvider.getPercentDefaultValue(null,0));
		System.assertEquals('123456789',dvProvider.getPhoneDefaultValue(null,0));
		System.assertEquals(null,dvProvider.getPicklistDefaultValue(null,0));
		System.assertNotEquals('',dvProvider.getPicklistDefaultValue(Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getStringDefaultValue(null,0));
		System.assertEquals('test0',dvProvider.getTextAreaDefaultValue(null,0));
		System.assertEquals(Time.newInstance(0, 0, 0, 0),dvProvider.getTimeDefaultValue(null,0));
		System.assertEquals('http://test0.com',dvProvider.getURLDefaultValue(null,0));
	}

	/************************* Util tests *************************/
	@isTest static void relationshipToFieldNameTest(){
		TDF.Util util = new TDF.Util();
		System.assertEquals('customrelationship__c',util.relationshipToFieldName('customrelationshiP__r'));
		System.assertEquals('standardrelationshipid',util.relationshipToFieldName('standardRelationshiP'));
	}
	
}