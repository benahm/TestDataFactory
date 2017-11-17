/**
* @author benahm
* @date 2017
* @description TDFTest Class
*/
@isTest
private class TDFTest {
	/************************* TDF tests *************************/
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
		Case cse = (Case)TDF.createSObject('Case', new Map<String,Object>{
				'Contact.FirstName' => 'test',
				'Contact.Account.Name' => 'test',
				'Contact.Account.Parent.Name' => 'test'
			});
		System.assertEquals('test',cse.Contact.FirstName);
		System.assertEquals('test',cse.Contact.Account.Name);
		System.assertEquals('test',cse.Contact.Account.Parent.Name);
	}
	@isTest static void createSObjectTest10(){
		SObject sObj = TDF.createSObject('Case', new Map<String,Object>{
				'aCCount.Description' => 'test',
				'ConTact.FirstName'=> 'test',
				'Description' => 'test',
				'asset.accounT.Name' => 'test',
				'asset.contact.account.Description' => 'test',
				'asset.Parent.contact.account.Description' => 'test'
			},true);
		Case cse = [select Asset.Parent.Contact.Account.Name from Case limit 1];
		System.assertEquals('test0',cse.Asset.Parent.Contact.Account.Name);
	}
	@isTest static void createSObjectTest11(){
		SObject sObj = TDF.createSObject('Account', new Map<String,Object>{
				'Name'=> 'test',
				'OwnerId'=> UserInfo.getUserId()
			},true);
		Account acc = [select OwnerId from Account limit 1];
		System.assertEquals(UserInfo.getUserId(),acc.OwnerId);
	}
	@isTest static void createSObjectTest12(){
		SObject sObj = TDF.createSObject('Account', new Map<String,Object>{
			'Owner.ProfileId' => UserInfo.getProfileId(),
			'Owner.Username' => 'test123456789@mycompanydomain.developer'
			},true);
		List<User> uList = [select Id,ProfileId from User where Username = 'test123456789@mycompanydomain.developer'];
		System.assertNotEquals(null,uList);
		System.assertEquals(1,uList.size());
		System.assertEquals(UserInfo.getProfileId(),uList.get(0).ProfileId);
	}
	@isTest static void createSObjectTest13(){
		try{
			SObject sObj = TDF.createSObject('TEST');
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
	}
	@isTest static void createSObjectTest14(){
		try{
			SObject sObj = TDF.createSObject('Profile');
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
	}
	@isTest static void createSObjectTest15(){
		try{
			SObject sObj = TDF.createSObject('Contact',new Map<String,Object>{
			'Test' => 'test'
			});
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
		try{
			SObject sObj = TDF.createSObject('Contact',new Map<String,Object>{
			'Account.Test' => 'test'
			});
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
		try{
			SObject sObj = TDF.createSObject('Contact',new Map<String,Object>{
			'Account.Test.Parent.Id' => 'test'
			});
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
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
	@isTest static void createSObjectListTest9(){
		List<SObject> sObjList = TDF.createSObjectList('Account', new Map<String,Object>{
			'Owner.ProfileId' => UserInfo.getProfileId(),
			'Owner.Username' => 'test123456789@mycompanydomain.developer{!index}',
			'Owner.CommunityNickname' => 'testd{!index}'
			},true,5);
		List<User> uList = [select Id,ProfileId from User where Username LIKE 'test123456789@mycompanydomain.developer%'];
		System.assertNotEquals(null,uList);
		System.assertEquals(5,uList.size());
		System.assertEquals(UserInfo.getProfileId(),uList.get(0).ProfileId);
	}
	@isTest static void setDefaultValueProviderTest(){
		System.assertEquals(null,TDF.dvPrvdrOverride);
		TDF.setDefaultValueProvider(null);
		System.assertEquals(null,TDF.dvPrvdrOverride);
		TDF.setDefaultValueProvider(new TDF.DefaultValueProvider());
		System.assertNotEquals(null,TDF.dvPrvdrOverride);
	}

	/************************* SObjectManager tests *************************/
	@isTest static void getMainSObjectListTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		System.assertNotEquals(null,sObjManager.getMainSObjectList());
		System.assertEquals(0,sObjManager.getMainSObjectList().size());
		sObjManager.mainSObjectList.add(new Contact());
		System.assertEquals(1,sObjManager.getMainSObjectList().size());
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
	@isTest static void insertAllTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		Account acc = new Account(Name='test');
		Contact con = new Contact(LastName='test');
		sObjManager.mainSObjectList.add(con);
		sObjManager.relatedSObjMapList.put('account',new List<SObject>{acc});
		sObjManager.orderedRelationshipList.add('account');
		try {
			sObjManager.insertAll();
		}catch(DmlException e){
			System.debug(e);
			System.assert(true); // if missing required fields
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
			System.assert(true); // if missing required fields
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
		sObjManager.addRelationshipName('Contact');
		System.assertEquals(2,sObjManager.orderedRelationshipList.size());
		System.assertEquals('contact.account',sObjManager.orderedRelationshipList.get(0));
		System.assertEquals('contact',sObjManager.orderedRelationshipList.get(1));
	}
	@isTest static void insertListTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		List<Account> accList = new List<Account>{new Account(Name='test')};
		try {
			sObjManager.insertList(accList);
		}catch(DmlException e){
			System.debug(e);
			System.assert(true); // if missing required fields
		}
		System.assertNotEquals(null,accList.get(0).Id);
	}
	@isTest static void validateListTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager();
		List<Asset> assetList = new List<Asset>{new Asset()};
		try{
			sObjManager.validateList('',assetList);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
		// TODO add more tests
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
		SObject sObj = sObjFactory.getSObjectInstance(Account.SObjectType, new Map<String,Object>(),false);
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest1(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		List<SObject> sObjList = sObjFactory.getListSObjectInstance(Contact.SObjectType,new Map<String,Object>{'Account.Description' => 'test'},false,5);
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
		SObject sObj = sObjFactory.getRelatedSObjectInstance(Contact.SObjectType,'Account','');
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void putSObjectTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		Contact con = new Contact();
		sObjFactory.putSObject(con,'Account',new Account(Name='Test'),'');
		System.assertEquals(con.Account.Name,'Test');
		try{
			sObjFactory.putSObject(con,'Test',new Account(),'');
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}
	}
	@isTest static void putFieldTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory();
		Contact con = new Contact();
		sObjFactory.putField(con,'FirstName','Test','');
		System.assertEquals(con.FirstName,'Test');
		try{
			sObjFactory.putField(con,'Test','Test','');
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}
	}
	
	/************************* DefaultValueProvider tests *************************/
	@isTest static void getDefaultMapTest1(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapValues = dvProvider.getDefaultMap(Opportunity.SObjectType,new Set<String>(),0);
		System.assertEquals('test0',mapValues.get('name'));
		System.assertNotEquals('',mapValues.get('stagename'));
		System.assertEquals(Date.today(),mapValues.get('closedate'));
	}
	@isTest static void getDefaultMapTest2(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapValues = dvProvider.getDefaultMap('Opportunity',new Set<String>(),0);
		System.assertEquals('test0',mapValues.get('name'));
		System.assertNotEquals('',mapValues.get('stagename'));
		System.assertEquals(Date.today(),mapValues.get('closedate'));
	}
	@isTest static void getDefaultMapTest3(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapValues = dvProvider.getDefaultMap(Contract.SObjectType,new Set<String>(),0);
		System.assertEquals(null,mapValues.get('account.id'));
		System.assertEquals('test0',mapValues.get('account.name'));
	}
	@isTest static void getDefaultMapTest4(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapValues = dvProvider.getDefaultMap(Contract.SObjectType,new Set<String>(),0,'');
		System.assertEquals(null,mapValues.get('account.id'));
		System.assertEquals('test0',mapValues.get('account.name'));
	}
	@isTest static void getSetOverrideRelationshipTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(new Set<String>{'contact'},dvProvider.getSetOverrideRelationship(new Set<String>{'Contact.AccountId','Contact.Account.ParentId'},''));
		System.assertEquals(new Set<String>{'account'},dvProvider.getSetOverrideRelationship(new Set<String>{'Contact.Account.Id','Contact.Account.ParentId','Contact.AccountId'},'Contact.'));
		System.assertEquals(new Set<String>{'parent','user'},dvProvider.getSetOverrideRelationship(new Set<String>{'Contact.Account.User.Id','Contact.Account.Parent.Id','Contact.AccountId'},'Contact.Account.'));
	}
	@isTest static void getDefaultPicklistValueTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		String defaultValue = dvProvider.getDefaultPicklistValue(Contract.fields.Status.getDescribe());
		System.assertNotEquals(null,defaultValue);
		System.assertNotEquals('',defaultValue);
	}
	@isTest static void defaultValueIsRequiredTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(true,dvProvider.defaultValueIsRequired(Account.fields.Name.getDescribe()));
		System.assertEquals(false,dvProvider.defaultValueIsRequired(Account.fields.OwnerId.getDescribe()));
	}
	@isTest static void getDefaultValueTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvProvider.getDefaultValue(Attachment.SObjectType.getDescribe(),Attachment.fields.Body.getDescribe(),0));
		System.assertEquals(true,dvProvider.getDefaultValue(Campaign.SObjectType.getDescribe(),Campaign.fields.IsActive.getDescribe(),0));
		System.assertEquals('0',dvProvider.getDefaultValue(Event.SObjectType.getDescribe(),Event.fields.Subject.getDescribe(),0));
		System.assertEquals('0',dvProvider.getDefaultValue(Lead.SObjectType.getDescribe(),Lead.fields.AnnualRevenue.getDescribe(),0));
		System.assertEquals(Date.today(),dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.LastActivityDate.getDescribe(),0));
		System.assertEquals(Datetime.now(),dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.CreatedDate.getDescribe(),0));
		System.assertEquals(0,dvProvider.getDefaultValue(Asset.SObjectType.getDescribe(),Asset.fields.Quantity.getDescribe(),0));
		System.assertEquals('test0@email.com',dvProvider.getDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.Email.getDescribe(),0));
		System.assertEquals(null,dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Id.getDescribe(),0));
		System.assertEquals(0,dvProvider.getDefaultValue(Attachment.SObjectType.getDescribe(),Attachment.fields.BodyLength.getDescribe(),0));
		//System.assertNotEquals('',dvProvider.getDefaultValue(Group.fields.Categories.getDescribe(),0));
		System.assertEquals(0,dvProvider.getDefaultValue(Opportunity.SObjectType.getDescribe(),Opportunity.fields.Probability.getDescribe(),0));
		System.assertEquals('123456789',dvProvider.getDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.Phone.getDescribe(),0));
		System.assertNotEquals('',dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.FirstName.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Description.getDescribe(),0));
		// no time field
		//System.assertEquals('http://test0.com',dvProvider.getDefaultValue(Weblink.fields.URL.getDescribe(),0));
		System.assertEquals(null,dvProvider.getDefaultValue(null,null,0));
	}
	@isTest static void getTypeDefaultValueTest(){
		TDF.ADefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvProvider.getBase64DefaultValue(null,null,0));
		System.assertEquals(true,dvProvider.getBooleanDefaultValue(null,null,0));
		System.assertEquals('0',dvProvider.getComboboxDefaultValue(null,null,0));
		System.assertEquals('0',dvProvider.getCurrencyDefaultValue(null,null,0));
		System.assertEquals(Date.today(),dvProvider.getDateDefaultValue(null,null,0));
		System.assertEquals(Datetime.now(),dvProvider.getDateTimeDefaultValue(null,null,0));
		System.assertEquals(0,dvProvider.getDoubleDefaultValue(null,null,0));
		System.assertEquals('test0@email.com',dvProvider.getEmailDefaultValue(null,null,0));
		System.assertEquals(null,dvProvider.getIDDefaultValue(null,null,0));
		System.assertEquals(0,dvProvider.getIntegerDefaultValue(null,null,0));
		System.assertEquals(null,dvProvider.getMultiPicklistDefaultValue(null,null,0));
		System.assertNotEquals('',dvProvider.getMultiPicklistDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Type.getDescribe(),0));
		System.assertEquals(0,dvProvider.getPercentDefaultValue(null,null,0));
		System.assertEquals('123456789',dvProvider.getPhoneDefaultValue(null,null,0));
		System.assertEquals(null,dvProvider.getPicklistDefaultValue(null,null,0));
		System.assertNotEquals('',dvProvider.getPicklistDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getStringDefaultValue(null,null,0));
		System.assertEquals('test0',dvProvider.getTextAreaDefaultValue(null,null,0));
		System.assertEquals(Time.newInstance(0, 0, 0, 0),dvProvider.getTimeDefaultValue(null,null,0));
		System.assertEquals('http://test0.com',dvProvider.getURLDefaultValue(null,null,0));
	}

	/************************* Util tests *************************/
	@isTest static void relationshipToFieldNameTest(){
		TDF.Util util = new TDF.Util();
		System.assertEquals('customrelationship__c',util.relationshipToFieldName('customrelationshiP__r'));
		System.assertEquals('standardrelationshipid',util.relationshipToFieldName('standardRelationshiP'));
	}
	@isTest static void mapToLowerCaseTest(){
		TDF.Util util = new TDF.Util();
		Map<String,Object> mapTest = new Map<String,Object>{
			'TesT' => 0,
			'tOto' => 1
			};
		System.assert(util.mapToLowerCase(mapTest).keySet().contains('test'));
		System.assert(util.mapToLowerCase(mapTest).keySet().contains('toto'));
	}
	@isTest static void toLowerCaseTest(){
		TDF.Util util = new TDF.Util();
		System.assertEquals(null,util.toLowerCase(null));
		System.assertEquals('test',util.toLowerCase('TeSt'));
	}
	@isTest static void mergeValueTest(){
		TDF.Util util = new TDF.Util();
		System.assertEquals(null,util.mergeValue(null,'i','101'));
		System.assertEquals(1,util.mergeValue(1,'i','101'));
		System.assertEquals('test101',util.mergeValue('test{!i}','i','101'));
		System.assertEquals('test101',util.mergeValue('test{!iD}','id','101'));
		System.assertEquals('test101',util.mergeValue('test{!Id}','ID','101'));
	}
}
