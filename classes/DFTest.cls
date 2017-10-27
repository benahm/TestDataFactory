/**
* @author benahm
* @date 2017
* @description DF Class
*/
@isTest
private class DFTest {
	
	@isTest static void test_method_one() {
		// Implement test code
	}
	
	// DefaultValueProvider tests
	@isTest static void getDefaultValueTest() {
		DF.IDefaultValueProvider dvProvider = new DF.DefaultValueProvider();
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

	}
	@isTest static void getTypeDefaultValueTest() {
		DF.IDefaultValueProvider dvProvider = new DF.DefaultValueProvider();
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
	
}