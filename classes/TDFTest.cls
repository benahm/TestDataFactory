/**
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/


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
		SObject sObj = TDF.createSObject('Account',new Map<String,Object>());
		System.assertNotEquals(null,sObj);
	}
	@isTest static void createSObjectTest3(){
		SObject sObj = TDF.createSObject('Account',false);
		System.assertNotEquals(null,sObj);
	}	
	@isTest static void createSObjectTest4(){
		SObject sObj = TDF.createSObject('Account',new Map<String,Object>(),false);
		System.assertNotEquals(null,sObj);
	}	
	@isTest static void createSObjectTest5(){
		Case cse = (Case)TDF.createSObject('Case', new Map<String,Object>{
				'Contact.FirstName' => 'test',
				'Contact.Account.Name' => 'test',
				'Contact.Account.Parent.Name' => 'test'
			});
		System.assertEquals('test',cse.Contact.FirstName);
		System.assertEquals('test',cse.Contact.Account.Name);
		System.assertEquals('test',cse.Contact.Account.Parent.Name);
	}
	@isTest static void createSObjectTest6(){
		SObject sObj = TDF.createSObject('Case', new Map<String,Object>{
				'id' => null,
				'aCCount.Description' => 'test',
				'ConTact.FirstName'=> 'test',
				'Description' => 'test',
				'asset.accounT.Name' => 'test',
				'asset.contact.account.Description' => 'test',
				'asset.Parent.contact.account.Description' => TDF.DEFAULT_VALUE
			},true);
		Case cse = [select Asset.Parent.Contact.Account.Name, Asset.Parent.Contact.Account.Description from Case limit 1];
		System.assertEquals('test0',cse.Asset.Parent.Contact.Account.Name);
		System.assertEquals('test0',cse.Asset.Parent.Contact.Account.Description);
	}
	@isTest static void createSObjectTest7(){
		SObject sObj = TDF.createSObject('Account', new Map<String,Object>{
				'Name'=> 'test',
				'OwnerId'=> UserInfo.getUserId()
			},true);
		Account acc = [select OwnerId from Account limit 1];
		System.assertEquals(UserInfo.getUserId(),acc.OwnerId);
	}
	@isTest static void createSObjectTest8(){
		SObject sObj = TDF.createSObject('Account', new Map<String,Object>{
			'Owner.Username' => 'test123456789@mycompanydomain.developer',
			'Owner.ProfileId' => UserInfo.getProfileId()
			},true);
		List<User> uList = [select Id,ProfileId from User where Username = 'test123456789@mycompanydomain.developer'];
		System.assertNotEquals(null,uList);
		System.assertEquals(1,uList.size());
		System.assertEquals(UserInfo.getProfileId(),uList.get(0).ProfileId);
	}
	@isTest static void createSObjectTest9(){
		try{
			SObject sObj = TDF.createSObject('TEST');
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
	}
	@isTest static void createSObjectTest10(){
		try{
			SObject sObj = TDF.createSObject('Profile',true);
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
	}
	@isTest static void createSObjectTest11(){
		try{
			SObject sObj = TDF.createSObject('Contact',new Map<String,Object>{
			'Test' => 'test'
			});
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
		try{
			SObject sObj = TDF.createSObject('Contact',new Map<String,Object>{
			'Account.Test' => 'test'
			});
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
		try{
			SObject sObj = TDF.createSObject('Contact',new Map<String,Object>{
			'Account.Test.Parent.Id' => 'test'
			});
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
		try{
			SObject sObj = TDF.createSObject('Contact',new Map<String,Object>{
			'Description' => Date.today()
			});
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
	}
	@isTest static void createSObjectListTest1(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest2(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest3(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest4(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest5(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest6(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}	
	@isTest static void createSObjectListTest7(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',new Map<String,Object>(),false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest8(){
		List<SObject> sObjList = TDF.createSObjectList('Contact',new Map<String,Object>(),false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
	}
	@isTest static void createSObjectListTest9(){
		List<Contact> sObjList = TDF.createSObjectList('Contact',new Map<String,Object>(),false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals('test0',sObjList.get(0).Lastname);
		System.assertEquals('test1',sObjList.get(1).Lastname);
		System.assertEquals('test2',sObjList.get(2).Lastname);
		System.assertEquals('test3',sObjList.get(3).Lastname);
		System.assertEquals('test4',sObjList.get(4).Lastname);
	}
	@isTest static void createSObjectListTest10(){
		List<SObject> sObjList = TDF.createSObjectList('Account', new Map<String,Object>{
			'Owner.Username' => 'test123456789@mycompanydomain.developer{!index}',
			'Owner.CommunityNickname' => 'testd{!index}',
			'Owner.ProfileId' => UserInfo.getProfileId()
			},true,5);
		List<User> uList = [select Id,ProfileId from User where Username LIKE 'test123456789@mycompanydomain.developer%'];
		System.assertNotEquals(null,uList);
		System.assertEquals(5,uList.size());
		System.assertEquals(UserInfo.getProfileId(),uList.get(0).ProfileId);
	}
	@isTest static void setDefaultValueProviderTest(){
		System.assertNotEquals(null,TDF.dvProvider);
		TDF.setDefaultValueProvider(null);
		System.assertNotEquals(null,TDF.dvProvider);
		TDF.setDefaultValueProvider(new TDF.DefaultValueProvider());
		System.assertNotEquals(null,TDF.dvProvider);
	}
	@isTest static void personAccountRecordTypesTest(){
		Set<Id> recordTypesSet;
		if(!TDF.PERSON_ACCOUNT_IS_ENABLED){
			try{
				recordTypesSet = TDF.personAccountRecordTypes;
				System.assert(false);
			}catch(Exception e){
				System.assert(true);
			}
		}	else{
			try{
				recordTypesSet = TDF.personAccountRecordTypes;
				System.assert(true);
				System.assertNotEquals(null,recordTypesSet);
			}catch(Exception e){
				System.assert(false);
			}
		}
	}

	@isTest static void getFieldsMapTest(){
		Map<String, Schema.SObjectField> accountFieldMap = TDF.getFieldsMap(Account.SObjectType);
		System.assertNotEquals(null,accountFieldMap);
		System.assertEquals(1,TDF.mapOfFieldsMap.size());
	}

	/************************* SObjectManager tests *************************/
	@isTest static void getMainSObjectListTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
		System.assertNotEquals(null,sObjManager.getMainSObjectList());
		System.assertEquals(0,sObjManager.getMainSObjectList().size());
		sObjManager.mainSObjectList.add(new Contact());
		System.assertEquals(1,sObjManager.getMainSObjectList().size());
	}
	@isTest static void setSObjectTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
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
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
		System.assertEquals(null,sObjManager.getSObject(0));
		System.assertEquals(null,sObjManager.getSObject(1));
		sObjManager.mainSObjectList.add(new Contact());
		System.assertNotEquals(null,sObjManager.getSObject(0));
	}
	@isTest static void setRelationshipTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
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
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
		System.assertEquals(null,sObjManager.getRelationship(0,'contact'));
		sObjManager.relatedSObjMapList.put('contact',new List<SObject>());
		System.assertEquals(null,sObjManager.getRelationship(0,'contact'));
		sObjManager.relatedSObjMapList.put('contact',new List<SObject>{new Contact()});
		System.assertNotEquals(null,sObjManager.getRelationship(0,'contact'));
		System.assertNotEquals(null,sObjManager.getRelationship(0,'ConTacT'));
	}
	@isTest static void insertAllTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
		Account acc = new Account(Name='test');
		Contact con = new Contact(LastName='test');
		sObjManager.mainSObjectList.add(con);
		sObjManager.relatedSObjMapList.put('account',new List<SObject>{acc});
		sObjManager.orderedRelationshipList.add('account');
		try {
			sObjManager.insertAll();
		}catch(DmlException e){
			System.assert(true); // if missing required fields
		}
		List<Contact> conList = [select LastName, Account.Name from Contact limit 1];
		System.assertNotEquals(null,conList);
		System.assertEquals(1,conList.size());
		System.assertEquals('test',conList.get(0).LastName);
		System.assertEquals('test',conList.get(0).Account.Name);
	}
	@isTest static void setChildParentRelationshipTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
		List<Account> accList = new List<Account>{new Account(Name='test')};
		List<Contact> conList = new List<Contact>{new Contact(LastName='test')};
		try {
			insert accList;
			sObjManager.setChildParentRelationship(conList,accList,'Account');
		}catch(DmlException e){
			System.assert(true); // if missing required fields
		}
		System.assertNotEquals(null,conList.get(0).AccountId);
	}
	@isTest static void addRelationshipNameTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
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
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Case');
		List<Account> accList = new List<Account>{new Account(Name='test')};
		try {
			sObjManager.insertList('',accList);
		}catch(DmlException e){
			System.assert(true); // if missing required fields
		}
		System.assertNotEquals(null,accList.get(0).Id);
	}
	@isTest static void validateListTest(){
		TDF.SObjectManager sObjManager = new TDF.SObjectManager('Asset');
		List<Asset> assetList = new List<Asset>{new Asset()};
		try{
			sObjManager.validateList('',assetList);
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}	
	}

	/************************* SObjectFactory tests *************************/
	@isTest static void getSObjectManagerTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		System.assertNotEquals(null,sObjFactory.getSObjectManager());
	}	
	@isTest static void getSObjectInstanceTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		SObject sObj = sObjFactory.getSObjectInstance(new Map<String,Object>(),false);
		System.assertNotEquals(null,sObj);
		System.assertEquals(Contact.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		List<SObject> sObjList = sObjFactory.getListSObjectInstance(new Map<String,Object>{'Account.Description' => 'test'},false,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Contact.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getRelationshipInstanceTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		SObject sObj = sObjFactory.getRelationshipInstance(Case.SObjectType,'Contact.Account',0);
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getRelatedSObjectInstanceTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		SObject sObj = sObjFactory.getRelatedSObjectInstance(Contact.SObjectType,'Account','');
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void putSObjectTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		Contact con = new Contact();
		sObjFactory.putSObject(con,'Account',new Account(Name='Test'),'');
		System.assertEquals(con.Account.Name,'Test');
		try{
			sObjFactory.putSObject(con,'Test',new Account(),'');
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}
	}
	@isTest static void putFieldTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		Contact con = new Contact();
		sObjFactory.putField(con,'FirstName','Test','');
		System.assertEquals(con.FirstName,'Test');
		try{
			sObjFactory.putField(con,'Test','Test','');
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}
	}
	@isTest static void validateSObjectTypeTest(){
		TDF.SObjectFactory sObjFactory = new TDF.SObjectFactory(Contact.SObjectType);
		try{
			sObjFactory.validateSObjectType(null);
			System.assert(false);
		}catch(TDF.TestDataFactoryException e){
			System.assert(true);
		}
		sObjFactory.validateSObjectType(Account.sObjectType);
		System.assert(true);
	}
	
	/************************* DefaultValueProvider tests *************************/
	@isTest static void getDefaultMapTest1(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = dvProvider.getDefaultMap(Opportunity.SObjectType,new Map<String,Object>());
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals('test0',mapOfValues.get('name').getValue(0));
		System.assertNotEquals('',mapOfValues.get('stagename').getValue(0));
		System.assertEquals(Date.today(),mapOfValues.get('closedate').getValue(0));
	}
	@isTest static void getDefaultMapTest2(){
		TDF.IDefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = dvProvider.getDefaultMap(Contract.SObjectType,new Map<String,Object>());
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals(null,mapOfValues.get('account.id').getValue(0));
		System.assertEquals('test0',mapOfValues.get('account.name').getValue(0));
	}
	@isTest static void getDefaultMapTest3(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = new Map<String,TDF.IFieldDefaultValue>();
		dvProvider.generateDefaultMap(Contract.SObjectType,mapOfValues,'');
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals(null,mapOfValues.get('account.id').getValue(0));
		System.assertEquals('test0',mapOfValues.get('account.name').getValue(0));
	}
	@isTest static void getDefaultMapTest4(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = new Map<String,TDF.IFieldDefaultValue>{
			'contact.id' => new TDF.FieldDefaultValue(null)
			};
		dvProvider.generateDefaultMap(Case.SObjectType,mapOfValues,'');
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals('test0',mapOfValues.get('contact.lastname').getValue(0));
	}
	@isTest static void getDefaultMapTest5(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = dvProvider.getDefaultMap(Contact.SObjectType,null);
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals('test0',mapOfValues.get('lastname').getValue(0));
	}
	@isTest static void getDefaultMapTest6(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = new Map<String,TDF.IFieldDefaultValue>{
			'contact.description' => TDF.DEFAULT_VALUE,
			'subject' => TDF.DEFAULT_VALUE
			};
		dvProvider.generateDefaultMap(Case.SObjectType,mapOfValues,'');
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals('test0',mapOfValues.get('contact.lastname').getValue(0));
		System.assertEquals('test0',mapOfValues.get('contact.description').getValue(0));
		System.assertEquals('test0',mapOfValues.get('subject').getValue(0));
	}
	@isTest static void getDefaultMapTest7(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = new Map<String,TDF.IFieldDefaultValue>{
			'contact.description' => TDF.DEFAULT_VALUE,
			'subject' => TDF.DEFAULT_VALUE
			};
		dvProvider.generateDefaultMap(Contact.SObjectType,mapOfValues,'contact.');
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals('test0',mapOfValues.get('contact.lastname').getValue(0));
		System.assertEquals('test0',mapOfValues.get('contact.description').getValue(0));
	}

	@isTest static void getDefaultMapTest8(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,TDF.IFieldDefaultValue> mapOfValues = new Map<String,TDF.IFieldDefaultValue>{
			'contactid' => TDF.DEFAULT_VALUE
			};
		dvProvider.generateDefaultMap(Case.SObjectType,mapOfValues,'');
		System.assertNotEquals(null,mapOfValues);
		System.assertEquals(null,mapOfValues.get('contactid'));
		System.assertEquals(null,mapOfValues.get('contact.id').getValue(0));
		System.assertEquals('test0',mapOfValues.get('contact.lastname').getValue(0));
	}

	@isTest static void getRelationshipKeySetTest(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(new Set<String>{'contact'},dvProvider.getRelationshipKeySet(new Set<String>{'Contact.AccountId','Contact.Account.ParentId'},''));
		System.assertEquals(new Set<String>{'account'},dvProvider.getRelationshipKeySet(new Set<String>{'Contact.Account.Id','Contact.Account.ParentId','Contact.AccountId'},'Contact.'));
		System.assertEquals(new Set<String>{'parent','user'},dvProvider.getRelationshipKeySet(new Set<String>{'Contact.Account.User.Id','Contact.Account.Parent.Id','Contact.Account.Description'},'Contact.Account.'));
	}
	@isTest static void convertMapTest(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		Map<String,Object> mapTest = new Map<String,Object>{
			'TesT' => 0,
			'  tOto  ' => 1
			};
		System.assert(dvProvider.convertMap(mapTest).keySet().contains('test'));
		System.assert(dvProvider.convertMap(mapTest).keySet().contains('toto'));
		System.assertEquals(0,dvProvider.convertMap(mapTest).get('test').getValue(0));
		System.assertEquals(1,dvProvider.convertMap(mapTest).get('toto').getValue(0));
	}
	@isTest static void getDefaultPicklistValueTest(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		String defaultValue = dvProvider.getDefaultPicklistValue(Contract.fields.Status.getDescribe());
		System.assertNotEquals(null,defaultValue);
		System.assertNotEquals('',defaultValue);
	}
	@isTest static void defaultValueIsRequiredTest(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(true,dvProvider.defaultValueIsRequired(Account.fields.Name.getDescribe()));
		System.assertEquals(false,dvProvider.defaultValueIsRequired(Account.fields.OwnerId.getDescribe()));
	}
	@isTest static void getDefaultValueTest(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvProvider.getDefaultValue(Attachment.SObjectType.getDescribe(),Attachment.fields.Body.getDescribe(),0)); // base64
 		System.assertEquals(true,dvProvider.getDefaultValue(Campaign.SObjectType.getDescribe(),Campaign.fields.IsActive.getDescribe(),0)); // checkbox
		System.assertEquals('0',dvProvider.getDefaultValue(Lead.SObjectType.getDescribe(),Lead.fields.AnnualRevenue.getDescribe(),0)); // currency
		System.assertEquals(Date.today(),dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.LastActivityDate.getDescribe(),0)); // date
		System.assertEquals(Datetime.now(),dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.CreatedDate.getDescribe(),0)); // datetime
		System.assertEquals('test0@email.com',dvProvider.getDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.Email.getDescribe(),0)); // email
		// no standard geolocation field
		System.assertEquals(0,dvProvider.getDefaultValue(Attachment.SObjectType.getDescribe(),Attachment.fields.BodyLength.getDescribe(),0)); // number
		System.assertEquals(0,dvProvider.getDefaultValue(Asset.SObjectType.getDescribe(),Asset.fields.Quantity.getDescribe(),0)); // number
		System.assertEquals(0,dvProvider.getDefaultValue(Opportunity.SObjectType.getDescribe(),Opportunity.fields.Probability.getDescribe(),0)); // percent
		System.assertEquals('123456789',dvProvider.getDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.Phone.getDescribe(),0)); // phone
		System.assertNotEquals('',dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Type.getDescribe(),0)); //  picklist
		// no standard multipicklist field
		System.assertEquals('test0',dvProvider.getDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.FirstName.getDescribe(),0));  // text
		System.assertEquals('test0',dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Description.getDescribe(),0)); // textarea
		// no standard time field
		System.assertEquals('http://test0.com',dvProvider.getDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Website.getDescribe(),0));
		System.assertEquals(null,dvProvider.getDefaultValue(null,null,0));
	}
	@isTest static void getTypeDefaultValueTest(){
		TDF.DefaultValueProvider dvProvider = new TDF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvProvider.getBase64DefaultValue(null,null,0));
		System.assertEquals(true,dvProvider.getCheckboxDefaultValue(null,null,0));
		System.assertEquals('0',dvProvider.getCurrencyDefaultValue(null,null,0));
		System.assertEquals(Date.today(),dvProvider.getDateDefaultValue(null,null,0));
		System.assertEquals(Datetime.now(),dvProvider.getDateTimeDefaultValue(null,null,0));
		System.assertEquals('test0@email.com',dvProvider.getEmailDefaultValue(null,null,0));
		System.assertNotEquals(null,dvProvider.getGeolocationDefaultValue(null,null,0));
		System.assertEquals(0,dvProvider.getNumberDefaultValue(null,null,0));
		System.assertEquals(0,dvProvider.getPercentDefaultValue(null,null,0));
		System.assertEquals('123456789',dvProvider.getPhoneDefaultValue(null,null,0));
		System.assertEquals(null,dvProvider.getPicklistDefaultValue(null,null,0));
		System.assertNotEquals('',dvProvider.getPicklistDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getTextDefaultValue(null,null,0));
		System.assertEquals(null,dvProvider.getMultiPicklistDefaultValue(null,null,0));
		System.assertNotEquals('',dvProvider.getMultiPicklistDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvProvider.getTextDefaultValue(null,null,0));
		System.assertEquals('test0',dvProvider.getTextAreaDefaultValue(null,null,0));
		System.assertEquals(Time.newInstance(0, 0, 0, 0),dvProvider.getTimeDefaultValue(null,null,0));
		System.assertEquals('http://test0.com',dvProvider.getURLDefaultValue(null,null,0));
	}

	/************************* AutoFieldDefaultValue tests *************************/
	@isTest static void getValueTest1(){
		TDF.IFieldDefaultValue autoFieldDV = new TDF.AutoFieldDefaultValue();
		System.assertEquals(null,autoFieldDV.getValue(0));
	}

	/************************* FieldDefaultValue tests *************************/
	@isTest static void getValueTest2(){
		TDF.IFieldDefaultValue fieldDV1 = new TDF.FieldDefaultValue(null);
		System.assertEquals(null,(new TDF.FieldDefaultValue(null)).getValue(0));
		TDF.IFieldDefaultValue fieldDV2 = new TDF.FieldDefaultValue('test');
		System.assertEquals('test',fieldDV2.getValue(0));
		TDF.IFieldDefaultValue fieldDV3 = new TDF.FieldDefaultValue(Attachment.SObjectType.getDescribe(),Attachment.fields.Body.getDescribe());
		System.assertEquals(Blob.valueOf('0'),fieldDV3.getValue(0));		
		TDF.IFieldDefaultValue fieldDV4 = new TDF.FieldDefaultValue(Campaign.SObjectType.getDescribe(),Campaign.fields.IsActive.getDescribe());
		System.assertEquals(true,fieldDV4.getValue(0));
		TDF.IFieldDefaultValue fieldDV5 = new TDF.FieldDefaultValue(Lead.SObjectType.getDescribe(),Lead.fields.AnnualRevenue.getDescribe());
		System.assertEquals('0',fieldDV5.getValue(0));
		TDF.IFieldDefaultValue fieldDV6 = new TDF.FieldDefaultValue(Account.SObjectType.getDescribe(),Account.fields.LastActivityDate.getDescribe());
		System.assertEquals(Date.today(),fieldDV6.getValue(0));
		TDF.IFieldDefaultValue fieldDV7 = new TDF.FieldDefaultValue(Account.SObjectType.getDescribe(),Account.fields.CreatedDate.getDescribe());
		System.assertEquals(Datetime.now(),fieldDV7.getValue(0));
		TDF.IFieldDefaultValue fieldDV8 = new TDF.FieldDefaultValue(Asset.SObjectType.getDescribe(),Asset.fields.Quantity.getDescribe());
		System.assertEquals(0,fieldDV8.getValue(0));
		TDF.IFieldDefaultValue fieldDV9 = new TDF.FieldDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.Email.getDescribe());
		System.assertEquals('test0@email.com',fieldDV9.getValue(0));
		TDF.IFieldDefaultValue fieldDV10 = new TDF.FieldDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Id.getDescribe());
		System.assertEquals(null,fieldDV10.getValue(0));
		TDF.IFieldDefaultValue fieldDV11 = new TDF.FieldDefaultValue(Attachment.SObjectType.getDescribe(),Attachment.fields.BodyLength.getDescribe());
		System.assertEquals(0,fieldDV11.getValue(0));
		TDF.IFieldDefaultValue fieldDV12 = new TDF.FieldDefaultValue(Opportunity.SObjectType.getDescribe(),Opportunity.fields.Probability.getDescribe());
		System.assertEquals(0,fieldDV12.getValue(0));
		TDF.IFieldDefaultValue fieldDV13 = new TDF.FieldDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.Phone.getDescribe());
		System.assertEquals('123456789',fieldDV13.getValue(0));
		TDF.IFieldDefaultValue fieldDV14 = new TDF.FieldDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Type.getDescribe());
		System.assertNotEquals('',fieldDV14.getValue(0));
		TDF.IFieldDefaultValue fieldDV15 = new TDF.FieldDefaultValue(Contact.SObjectType.getDescribe(),Contact.fields.FirstName.getDescribe());
		System.assertEquals('test0',fieldDV15.getValue(0));
		TDF.IFieldDefaultValue fieldDV16 = new TDF.FieldDefaultValue(Account.SObjectType.getDescribe(),Account.fields.Description.getDescribe());
		System.assertEquals('test0',fieldDV16.getValue(0));
	}

	/************************* Util tests *************************/
	@isTest static void relationshipToFieldNameTest(){
		TDF.Util util = new TDF.Util();
		System.assertEquals('customrelationship__c',util.relationshipToFieldName('customrelationshiP__r'));
		System.assertEquals('standardrelationshipid',util.relationshipToFieldName('standardRelationshiP'));
	}
	@isTest static void mergeValueTest(){
		TDF.Util util = new TDF.Util();
		System.assertEquals(null,util.mergeValue(null,'i','101'));
		System.assertEquals('test101',util.mergeValue('test{!i}','i','101'));
		System.assertEquals('test101',util.mergeValue('test{!iD}','id','101'));
		System.assertEquals('test101',util.mergeValue('test{!Id}','ID','101'));
	}
}
