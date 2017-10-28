/**
* @author benahm
* @date 2017
* @description DF Class
*/
@isTest
private class DFTest {
	
	/************************* SObjectManager tests *************************/
	
	/************************* SObjectFactory tests *************************/
	@isTest static void sObjectManagerInstanceTest(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		System.assertNotEquals(null,sObjMgr.getDefaultValueProvider());
		sObjMgr = new DF.SObjectFactory(null);
		System.assertNotEquals(null,sObjMgr.getDefaultValueProvider());
		sObjMgr = new DF.SObjectFactory(new DF.DefaultValueProvider());
		System.assertNotEquals(null,sObjMgr.getDefaultValueProvider());
	}	
	@isTest static void getSObjectManagerTest(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		System.assertNotEquals(null,sObjMgr.getSObjectManager());
	}	
	@isTest static void getDefaultValueProviderTest(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		System.assertNotEquals(null,sObjMgr.getDefaultValueProvider());
	}
	@isTest static void getSObjectInstanceTest1(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		SObject sObj = sObjMgr.getSObjectInstance('Account');
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getSObjectInstanceTest2(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		SObject sObj = sObjMgr.getSObjectInstance(Account.SObjectType);
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getSObjectInstanceTest3(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		SObject sObj = sObjMgr.getSObjectInstance('Account', new Map<String,Object>());
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getSObjectInstanceTest4(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		SObject sObj = sObjMgr.getSObjectInstance(Account.SObjectType, new Map<String,Object>());
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest1(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		List<SObject> sObjList = sObjMgr.getListSObjectInstance('Account',5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest2(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		List<SObject> sObjList = sObjMgr.getListSObjectInstance(Account.SObjectType,5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest3(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		List<SObject> sObjList = sObjMgr.getListSObjectInstance('Account',new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest4(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		List<SObject> sObjList = sObjMgr.getListSObjectInstance(Account.SObjectType,new Map<String,Object>(),5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Account.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getListSObjectInstanceTest5(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		List<SObject> sObjList = sObjMgr.getListSObjectInstance(Contact.SObjectType,new Map<String,Object>{'Account.Description' => 'test'},5);
		System.assertNotEquals(null,sObjList);
		System.assertEquals(5,sObjList.size());
		System.assertEquals(Contact.SObjectType,sObjList.get(0).getSObjectType());
	}
	@isTest static void getRelationshipInstanceTest(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		SObject sObj = sObjMgr.getRelationshipInstance(Case.SObjectType,'Contact.Account',0);
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void getRelatedSObjectInstanceTest(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		SObject sObj = sObjMgr.getRelatedSObjectInstance(Contact.SObjectType,'AccountId');
		System.assertNotEquals(null,sObj);
		System.assertEquals(Account.SObjectType,sObj.getSObjectType());
	}
	@isTest static void relationshipToFieldNameTest(){
		DF.SObjectFactory sObjMgr = new DF.SObjectFactory();
		System.assertEquals('customrelationship__c',sObjMgr.relationshipToFieldName('customrelationshiP__r'));
		System.assertEquals('standardrelationshipid',sObjMgr.relationshipToFieldName('standardRelationshiP'));
	}
	
	/************************* DefaultValueProvider tests *************************/
	@isTest static void getDefaultMapTest1(){
		DF.IDefaultValueProvider dvPrvdr = new DF.DefaultValueProvider();
		Map<String,Object> mapValues = dvPrvdr.getDefaultMap(Opportunity.SObjectType);
		System.assertEquals('test0',mapValues.get('name'));
		System.assertNotEquals('',mapValues.get('stagename'));
		System.assertEquals(Date.today(),mapValues.get('closedate'));
	}
	@isTest static void getDefaultMapTest2(){
		DF.IDefaultValueProvider dvPrvdr = new DF.DefaultValueProvider();
		Map<String,Object> mapValues = dvPrvdr.getDefaultMap('Opportunity');
		System.assertEquals('test0',mapValues.get('name'));
		System.assertNotEquals('',mapValues.get('stagename'));
		System.assertEquals(Date.today(),mapValues.get('closedate'));
	}
	@isTest static void getDefaultMapTest3(){
		DF.IDefaultValueProvider dvPrvdr = new DF.DefaultValueProvider();
		Map<String,Object> mapValues = dvPrvdr.getDefaultMap(Contract.SObjectType);
		System.assertEquals(null,mapValues.get('account.id'));
		System.assertEquals('test0',mapValues.get('account.name'));
	}
	@isTest static void getDefaultPicklistValueTest(){
		DF.ADefaultValueProvider dvPrvdr = new DF.DefaultValueProvider();
		String defaultValue = dvPrvdr.getDefaultPicklistValue(Contract.fields.Status.getDescribe());
		System.assertNotEquals(null,defaultValue);
		System.assertNotEquals('',defaultValue);
	}
	@isTest static void getDefaultValueTest(){
		DF.ADefaultValueProvider dvPrvdr = new DF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvPrvdr.getDefaultValue(Attachment.fields.Body.getDescribe(),0));
		System.assertEquals(true,dvPrvdr.getDefaultValue(Campaign.fields.IsActive.getDescribe(),0));
		System.assertEquals('0',dvPrvdr.getDefaultValue(Event.fields.Subject.getDescribe(),0));
		System.assertEquals('0',dvPrvdr.getDefaultValue(Lead.fields.AnnualRevenue.getDescribe(),0));
		System.assertEquals(Date.today(),dvPrvdr.getDefaultValue(Account.fields.LastActivityDate.getDescribe(),0));
		System.assertEquals(Datetime.now(),dvPrvdr.getDefaultValue(Account.fields.CreatedDate.getDescribe(),0));
		System.assertEquals(0,dvPrvdr.getDefaultValue(Asset.fields.Quantity.getDescribe(),0));
		System.assertEquals('test0@email.com',dvPrvdr.getDefaultValue(Contact.fields.Email.getDescribe(),0));
		//System.assertEquals('secret0',dvPrvdr.getDefaultValue(ExternalDataUserAuth.fields.Password.getDescribe(),0));
		System.assertEquals(null,dvPrvdr.getDefaultValue(Account.fields.Id.getDescribe(),0));
		System.assertEquals(0,dvPrvdr.getDefaultValue(Attachment.fields.BodyLength.getDescribe(),0));
		//System.assertNotEquals('',dvPrvdr.getDefaultValue(Group.fields.Categories.getDescribe(),0));
		System.assertEquals(0,dvPrvdr.getDefaultValue(Opportunity.fields.Probability.getDescribe(),0));
		System.assertEquals('123456789',dvPrvdr.getDefaultValue(Contact.fields.Phone.getDescribe(),0));
		System.assertNotEquals('',dvPrvdr.getDefaultValue(Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvPrvdr.getDefaultValue(Contact.fields.FirstName.getDescribe(),0));
		System.assertEquals('test0',dvPrvdr.getDefaultValue(Account.fields.Description.getDescribe(),0));
		// no time field
		//System.assertEquals('http://test0.com',dvPrvdr.getDefaultValue(Weblink.fields.URL.getDescribe(),0));
		System.assertEquals(null,dvPrvdr.getDefaultValue(null,0));

	}
	@isTest static void getTypeDefaultValueTest(){
		DF.ADefaultValueProvider dvPrvdr = new DF.DefaultValueProvider();
		System.assertEquals(Blob.valueOf('0'),dvPrvdr.getBase64DefaultValue(null,0));
		System.assertEquals(true,dvPrvdr.getBooleanDefaultValue(null,0));
		System.assertEquals('0',dvPrvdr.getComboboxDefaultValue(null,0));
		System.assertEquals('0',dvPrvdr.getCurrencyDefaultValue(null,0));
		System.assertEquals(Date.today(),dvPrvdr.getDateDefaultValue(null,0));
		System.assertEquals(Datetime.now(),dvPrvdr.getDateTimeDefaultValue(null,0));
		System.assertEquals(0,dvPrvdr.getDoubleDefaultValue(null,0));
		System.assertEquals('test0@email.com',dvPrvdr.getEmailDefaultValue(null,0));
		System.assertEquals('secret0',dvPrvdr.getEncryptedStringDefaultValue(null,0));
		System.assertEquals(null,dvPrvdr.getIDDefaultValue(null,0));
		System.assertEquals(0,dvPrvdr.getIntegerDefaultValue(null,0));
		System.assertEquals(null,dvPrvdr.getMultiPicklistDefaultValue(null,0));
		System.assertNotEquals('',dvPrvdr.getMultiPicklistDefaultValue(Account.fields.Type.getDescribe(),0));
		System.assertEquals(0,dvPrvdr.getPercentDefaultValue(null,0));
		System.assertEquals('123456789',dvPrvdr.getPhoneDefaultValue(null,0));
		System.assertEquals(null,dvPrvdr.getPicklistDefaultValue(null,0));
		System.assertNotEquals('',dvPrvdr.getPicklistDefaultValue(Account.fields.Type.getDescribe(),0));
		System.assertEquals('test0',dvPrvdr.getStringDefaultValue(null,0));
		System.assertEquals('test0',dvPrvdr.getTextAreaDefaultValue(null,0));
		System.assertEquals(Time.newInstance(0, 0, 0, 0),dvPrvdr.getTimeDefaultValue(null,0));
		System.assertEquals('http://test0.com',dvPrvdr.getURLDefaultValue(null,0));
	}
	
}