/**
* @author benahm
* @date 2017
* @description TDF Class
*/
@testVisible
public class TDF {

	// Org config
	// ==========================================================================
	private static final Boolean PERSON_ACCOUNT_IS_ENABLED = false;
	private static final ID PERSON_ACCOUNT_RECORDTYPE_ID = null;
	// ==========================================================================

	public static final IFieldDefaultValue DEFAULT_VALUE = new AutoFieldDefaultValue();
	
	private static ADefaultValueProvider dvProvider = new DefaultValueProvider();
	private static final String DOT = '.';
	private static final Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
	private static final Util util=new Util();

	// sObjects That Don’t Support DML Operations => https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dml_non_dml_objects.htm
	private static Set<String> ignoredSObjects = new Set<String>{
								'AccountTerritoryAssignmentRule',
								'AccountTerritoryAssignmentRuleItem',
								'ApexComponent',
								'ApexPage',
								'BusinessHours',
								'BusinessProcess',
								'CategoryNode',
								'CurrencyType',
								'DatedConversionRate',
								'NetworkMember',
								'ProcessInstance',
								'Profile',
								'RecordType',
								'SelfServiceUser',
								'StaticResource',
								'Territory2',
								'UserAccountTeamMember',
								'UserTerritory',
								'WebLink'
							};

	/**
	 * @description create an sObject
	 * @return SObject : sObject instance
	 */
	public static SObject createSObject(String sObjectName){
		return createSObject(globalDescribe.get(sObjectName));
	}
	public static SObject createSObject(Schema.SObjectType sObjectType){
		return createSObject(sObjectType,new Map<String,Object>());
	}		
	public static SObject createSObject(String sObjectName, Map<String,Object> mapValuesOverride){
		return createSObject(globalDescribe.get(sObjectName),mapValuesOverride);
	}
	public static SObject createSObject(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride){
		return createSObject(sObjectType,mapValuesOverride,false);
	}	
	public static SObject createSObject(String sObjectName, Boolean doInsert){
		return createSObject(globalDescribe.get(sObjectName),doInsert);
	}
	public static SObject createSObject(Schema.SObjectType sObjectType, Boolean doInsert){
		return createSObjectList(sObjectType,new Map<String,Object>(),doInsert,1).get(0);
	}	
	public static SObject createSObject(String sObjectName, Map<String,Object> mapValuesOverride, Boolean doInsert){
		return createSObject(globalDescribe.get(sObjectName),mapValuesOverride,doInsert);
	}
	public static SObject createSObject(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride, Boolean doInsert){
		return createSObjectList(sObjectType,mapValuesOverride,doInsert,1).get(0);
	}
	
	/**
	 * @description create a list of sObjects
	 * @return List<SObject> : list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Integer numberOfSObjects){
		return createSObjectList(globalDescribe.get(sObjectName),numberOfSObjects);
	}		
	public static List<SObject> createSObjectList(Schema.SObjectType sObjectType, Integer numberOfSObjects){
		return createSObjectList(sObjectType,new Map<String,Object>(),numberOfSObjects);
	}	
	public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapValuesOverride, Integer numberOfSObjects){
		return createSObjectList(globalDescribe.get(sObjectName),mapValuesOverride,numberOfSObjects);
	}	
	public static List<SObject> createSObjectList(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride, Integer numberOfSObjects){
		return createSObjectList(sObjectType,mapValuesOverride,false,numberOfSObjects);
	}
	public static List<SObject> createSObjectList(String sObjectName, Boolean doInsert, Integer numberOfSObjects){
		return createSObjectList(globalDescribe.get(sObjectName),doInsert,numberOfSObjects);
	}
	public static List<SObject> createSObjectList(Schema.SObjectType sObjectType, Boolean doInsert, Integer numberOfSObjects){
		return createSObjectList(sObjectType,new Map<String,Object>(),doInsert,numberOfSObjects);
	}
	public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapValuesOverride, Boolean doInsert, Integer numberOfSObjects){
		return createSObjectList(globalDescribe.get(sObjectName),mapValuesOverride,doInsert,numberOfSObjects);
	}
	public static List<SObject> createSObjectList(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride, Boolean doInsert, Integer numberOfSObjects){
		ISObjectFactory sObjFactory = new SObjectFactory(sObjectType);
		List<SObject> listSObjectInstance = sObjFactory.getListSObjectInstance(mapValuesOverride, doInsert, numberOfSObjects);
		return listSObjectInstance;
	}

	/**
	 * @description set the default value provider 
	 */
	public static void setDefaultValueProvider(ADefaultValueProvider dvProviderOverride){
		if(dvProviderOverride != null)
			dvProvider = dvProviderOverride;
	}


	/****************************************************************************************/
	/*			         Inner Interfaces & Classes			        */
	/****************************************************************************************/
	/**
	* @description interface ISObjectManager
	*/
	public interface ISObjectManager{
		List<SObject> getMainSObjectList();
		void setSObject(Integer index, SObject sObj);
		SObject getSObject(Integer index);
		void setRelationship(Integer index, String relationshipName, SObject sObj);
		SObject getRelationship(Integer index, String relationshipName);
		void insertAll();
	}

	/**
	* @description class SObjectManager
	*/
	@testVisible
	private class SObjectManager implements ISObjectManager{

		private String sObjectName = null;
		@testVisible
		private List<SObject> mainSObjectList = new List<SObject>();
		@testVisible
		private Map<String,List<SObject>> relatedSObjMapList = new Map<String,List<SObject>>();
		@testVisible
		private List<String> orderedRelationshipList = new List<String>();

		// Error Messages 
		private String ERR_NAME_ON_PERSONACCOUNT = 'You can not set the name field for a person account';
		private String ERR_CONTACT_TO_PERSONACCOUNT = 'You cannot set an AccountId of a contact to a person account';
		private String ERR_REQUIRED_FOR_ASSET = 'AccountId or ContactId is required for an Asset';
		private String ERR_INSERT_SOBJECT = 'Unable to insert the "{0}" sObject';
		

		public SObjectManager(String sObjectName){
			this.sObjectName = sObjectName;
		}

		/**
		* @description get the main sObject list
		*/
		public List<SObject> getMainSObjectList(){
			return mainSObjectList;
		}

		/**
		* @description set an sObject to the main list with a specific index
		*/
		public void setSObject(Integer index,SObject sObj){
			if(index < 0) return;
			if(index < mainSObjectList.size())
				mainSObjectList.set(index,sObj);
			else mainSObjectList.add(sObj);
		}

		/**
		* @description get an sObject from the main list with a specific index
		*/
		public SObject getSObject(Integer index){
			if(index >= mainSObjectList.size() || index < 0) return null;
			return mainSObjectList.get(index);
		}

		/**
		* @description set a related sObject with a specific index and relationship name
		*/
		public void setRelationship(Integer index, String relationshipName, SObject sObj){
			if(index < 0) return;
			List<SObject> relatedSObjList = relatedSObjMapList.get(relationshipName);
			if(relatedSObjList == null) relatedSObjList = new List<SObject>();
			if(index < relatedSObjList.size())
				relatedSObjList.set(index,sObj);
			else relatedSObjList.add(sObj);
			relatedSObjMapList.put(relationshipName.toLowerCase(),relatedSObjList);
			addRelationshipName(relationshipName);
		}

		/**
		* @description get a related sObject with a specific index and relationship name
		*/
		public SObject getRelationship(Integer index,String relationshipName){
			List<SObject> relatedSObjList = relatedSObjMapList.get(relationshipName.toLowerCase());
			if(relatedSObjList == null) return null;
			if(index >= relatedSObjList.size() || index < 0) return null;
			return relatedSObjList.get(index);
		}

		/**
		* @description insert all the sObjects
		*/
		public void insertAll(){
			for(Integer i = 0; i < orderedRelationshipList.size(); i++){
				String relationshipName = orderedRelationshipList.get(i);
				List<SObject> sObjParentList = relatedSObjMapList.get(relationshipName);
				insertList(DOT+relationshipName,validateList(relationshipName,sObjParentList));
				if(relationshipName.contains(DOT)){
					String childRelationshipName = relationshipName.substringBeforeLast(DOT);
					List<SObject> sObjChildList = relatedSObjMapList.get(childRelationshipName);
					setChildParentRelationship(sObjChildList,sObjParentList,relationshipName.substringAfterLast(DOT));
				}else{
					setChildParentRelationship(mainSObjectList,sObjParentList,relationshipName);
				}
			}

			insertList('',validateList('',mainSObjectList));
		}

		/**
		* @description set child parent relationship
		*/
		@testVisible
		private void setChildParentRelationship(List<SObject> sObjChildList, List<SObject> sObjParentList, String relationshipName){
			if(sObjChildList == null || sObjParentList == null) return;
			if(sObjChildList.size() != sObjParentList.size()) return;
			Integer index = 0;
			for(SObject sObjChild: sObjChildList){
				sObjChild.put(util.relationshipToFieldName(relationshipName),sObjParentList.get(index).get('Id'));
				index++;
			}
		}

		/**
		* @description add relationship name to a list ordered by the dot notation
		*/
		@testVisible
		private void addRelationshipName(String relationshipName){
			String relationshipNameLowerCase = relationshipName.toLowerCase();
			Integer i=0;
			for (String rName : orderedRelationshipList) {
				if(relationshipNameLowerCase == rName) return;
				if(rName.countMatches('.') < relationshipName.countMatches('.')){
					orderedRelationshipList.add(i, relationshipNameLowerCase);
					return;
				}
				i++;
			}
			orderedRelationshipList.add(relationshipNameLowerCase);
		}

		/**
		* @description insert a list of sObjects
		*/
		@testVisible
		private void insertList(String dotRelationshipName, List<SObject> sObjList){
			try{
				insert sObjList;
			}catch(Exception e){
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_INSERT_SOBJECT,new List<String>{sObjectName+dotRelationshipName},e.getMessage()));
			}
		}

		/**
		* @description validate a list of sObjects before insert
		*/
		@testVisible
		private List<sObject> validateList(String relationshipName, List<SObject> sObjList){
			Integer counter = 0;
			for(SObject sObj : sObjList){
				if(sObj.getSObjectType() == Account.SObjectType){
					if(PERSON_ACCOUNT_IS_ENABLED){
						Boolean nameIsSet = sObj.get('Name') != null;
						Schema.DescribeSObjectResult accountDesc = Account.SObjectType.getDescribe();
						if(sObj.get('RecordTypeId') == PERSON_ACCOUNT_RECORDTYPE_ID) {
							if(nameIsSet) throw new TestDataFactoryException(util.formatErrorMessage(ERR_NAME_ON_PERSONACCOUNT,new List<String>{},''));
							sObj.put('Lastname',dvProvider.getStringDefaultValue(accountDesc,accountDesc.fields.getMap().get('Lastname').getDescribe(),counter));
							if(relationshipName.substringBeforeLast(DOT) == 'contact'){
								throw new TestDataFactoryException(util.formatErrorMessage(ERR_CONTACT_TO_PERSONACCOUNT,new List<String>{},''));
							}
						}else{
							if(!nameIsSet)
								sObj.put('Name',dvProvider.getStringDefaultValue(accountDesc,Account.fields.Name.getDescribe(),counter));
						}
					}
				}else if(sObj.getSObjectType() == Asset.SObjectType){
					if(sObj.get('AccountId') == null && sObj.get('ContactId') == null){
						throw new TestDataFactoryException(util.formatErrorMessage(ERR_REQUIRED_FOR_ASSET,new List<String>{},''));
					}
				}
				counter++;
			}
			return sObjList;
		}
	}

	/**
	* @description interface ISObjectFactory
	*/
	public interface ISObjectFactory{

		ISObjectManager getSObjectManager();
		SObject getSObjectInstance(Map<String,Object> mapValuesOverride, Boolean doInsert);
		List<SObject> getListSObjectInstance(Map<String,Object> mapValuesOverride, Boolean doInsert, Integer numberOfSObjects);
	}

	/**
	* @description class SObjectFactory
	*/
	@testVisible
	private class SObjectFactory implements ISObjectFactory{

		private Schema.SObjectType sObjectType = null;
		private ISObjectManager sObjMgr = null;

		// Error Messages 
		private String ERR_NOT_FOUND_SOBJECT = 'Unable to find the sObject';
		private String ERR_UNSUPPORTED_SOBJECT = 'DML Operations are not supported on "{0}"';
		private String ERR_FIELD_NOT_EXIST = 'The field "{0}" does not exist on "{1} or the value type provided is incorrect"';
		private String ERR_RELATIONSHIP_NOT_EXIST = 'The relationship "{0}" does not exist on "{1}"';


		public SObjectFactory(Schema.SObjectType sObjectType){
			validateSObjectType(sObjectType);
			this.sObjectType = sObjectType;
			this.sObjMgr = new SObjectManager(sObjectType.getDescribe().getName());
		}

		/**
		* @description Get SObject Manager instance
		*/
		public ISObjectManager getSObjectManager(){
			return sObjMgr;
		}

		/**
		* @description Generate an sObject instance
		* @return SObject : sObject instance
		*/
		public SObject getSObjectInstance(Map<String,Object> mapValuesOverride, Boolean doInsert){
			return getListSObjectInstance(mapValuesOverride,doInsert,1).get(0);
		}

		/**
		* @description Generate a list of sObject instances
		* @return List<SObject> : list of sObject instances
		*/
		public List<SObject> getListSObjectInstance(Map<String,Object> mapValuesOverride, Boolean doInsert, Integer numberOfSObjects){
			Map<String,IFieldDefaultValue> mapValues = dvProvider.getDefaultMap(sObjectType,mapValuesOverride);

			for(Integer i = 0; i < numberOfSObjects; i++) {
				sObjMgr.setSObject(i,sObjectType.newSObject()); 
				initSObjectInstance(mapValues,i);
			}

			if(doInsert) sObjMgr.insertAll();

			return sObjMgr.getMainSObjectList();
		}

		/**
		* @description Initiate an sObject
		*/
		private void initSObjectInstance(Map<String,IFieldDefaultValue> mapValues, Integer counter){
			String sObjectName = sObjectType.getDescribe().getName();
			for(String fullyQualifiedFieldName : mapValues.keySet()){

				String fieldName = (DOT+fullyQualifiedFieldName).substringAfterLast(DOT);
				if(fullyQualifiedFieldName.contains(DOT)){ // field with dot notation

					String firstRelationshipName = fullyQualifiedFieldName.substringBefore(DOT);
					String fullyQualifiedRelationshipName = fullyQualifiedFieldName.substringBeforeLast(DOT);
					SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipName,counter);
					putField(relatedSObj,fieldName,mapValues.get(fullyQualifiedFieldName).getValue(counter),sObjectName+DOT+fullyQualifiedRelationshipName);
					putSObject(sObjMgr.getSObject(counter),firstRelationshipName,sObjMgr.getRelationship(counter,firstRelationshipName),sObjectName);

				}else { // field name
					putField(sObjMgr.getSObject(counter),fieldName,mapValues.get(fieldName).getValue(counter),sObjectName);
				}

			}
		}

		/**
		* @description Initiate all the related sObjects for a given fully qualified relationship name
		* @return SObject
		*/
		@testVisible
		private SObject getRelationshipInstance(Schema.SObjectType sObjectType,String fullyQualifiedRelationshipName, Integer index){
			SObject sObj = sObjMgr.getRelationship(index,fullyQualifiedRelationshipName);
			if(sObj != null) return sObj;
			String sObjectName = sObjectType.getDescribe().getName();
			String leafRelationshipName = (DOT+fullyQualifiedRelationshipName).substringAfterLast(DOT);

			if(fullyQualifiedRelationshipName.contains(DOT)){ // multiple relationships
				String fullyQualifiedRelationshipNameBefore = fullyQualifiedRelationshipName.substringBeforeLast(DOT);
				SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipNameBefore,index);
				sObj = getRelatedSObjectInstance(relatedSObj.getSObjectType(),leafRelationshipName,sObjectName+DOT+fullyQualifiedRelationshipNameBefore); 
				relatedSObj = putSObject(relatedSObj,leafRelationshipName,sObj,sObjectName+DOT+fullyQualifiedRelationshipNameBefore);
			}else { // single relationship
				sObj = getRelatedSObjectInstance(sObjectType,leafRelationshipName,sObjectName); 
			}

			sObjMgr.setRelationship(index,fullyQualifiedRelationshipName,sObj);
			return sObj;
		}
		/**
		* @description get related sObject 
		* @return SObject
		*/
		@testVisible
		private SObject getRelatedSObjectInstance(Schema.SObjectType sObjectType, String relationshipName, String prefix){
			Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
			Schema.DescribeFieldResult fieldDesc;
			try{
				fieldDesc = fieldMap.get(util.relationshipToFieldName(relationshipName)).getDescribe();
			}catch(Exception e){
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_RELATIONSHIP_NOT_EXIST,new List<String>{relationshipName,prefix},e.getMessage()));
			}
			return  fieldDesc.getReferenceTo().get(0).newSObject();
		}
		/**
		* @description put a related sObject to an sObject
		*/
		@testVisible
		private SObject putSObject(SObject sObj, String name, sObject value, String prefix){
			try{
				sObj.putSObject(name,value);
			}catch(Exception e){
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_RELATIONSHIP_NOT_EXIST,new List<String>{name,prefix},e.getMessage()));
			}
			return sObj;
		}		
		/**
		* @description put a field value to an sObject
		*/
		@testVisible
		private SObject putField(SObject sObj, String name, Object value, String prefix){
			try{
				sObj.put(name,value);
			}catch(Exception e){
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_FIELD_NOT_EXIST,new List<String>{name,prefix},e.getMessage()));
			}
			return sObj;
		}

		private void validateSObjectType(Schema.SObjectType sObjectType){
			if(sObjectType == null) 
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_NOT_FOUND_SOBJECT,new List<String>{},''));
			String sObjectName = sObjectType.getDescribe().getName();
			if(ignoredSObjects.contains(sObjectName)) 
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_UNSUPPORTED_SOBJECT,new List<String>{sObjectName},''));
		}

	}

	/**
	* @description interface IDefaultValueProvider
	*/
	public interface IDefaultValueProvider{
		Map<String,IFieldDefaultValue> getDefaultMap(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride);
		Object getDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter);
	}

	/**
	* @description abstract class ADefaultValueProvider
	*/
	public abstract class ADefaultValueProvider implements IDefaultValueProvider{

		/**
		* @description get the default map values
		* @return Map<String,IFieldDefaultValue> : map values
		*/
		public Map<String,IFieldDefaultValue> getDefaultMap(Schema.SObjectType sObjectType, Map<String,Object> mapValues){
			if(mapValues == null)
				return getDefaultMap(sObjectType,new Map<String,IFieldDefaultValue>(),'');
			return getDefaultMap(sObjectType,new Map<String,IFieldDefaultValue>(convertMap(mapValues)),'');
		}
		@testVisible
		private Map<String,IFieldDefaultValue> getDefaultMap(Schema.SObjectType sObjectType, Map<String,IFieldDefaultValue> mapValues, String prefix){
			Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
			String prefixLowerCase = prefix.toLowerCase();
			Schema.DescribeFieldResult fieldDesc;
			Set<String> keySetOverride = mapValues.keySet();
			Set<String> relationshipKeySet = getRelationshipKeySet(keySetOverride,prefixLowerCase);
			for(String fieldName : fieldMap.keySet()){
				fieldDesc = fieldMap.get(fieldName).getDescribe();
				String fullyQualifiedFieldName = prefixLowerCase+fieldName.toLowerCase();
				Object initialFieldValue = mapValues.get(fullyQualifiedFieldName);
				if(initialFieldValue != null){
					if(initialFieldValue instanceof AutoFieldDefaultValue) {
							mapValues.put(fullyQualifiedFieldName,new FieldDefaultValue(sObjectType.getDescribe(),fieldDesc));
					}
				}else {
					if(defaultValueIsRequired(fieldDesc) || relationshipKeySet.contains((fieldDesc.getRelationshipName()+'').toLowerCase())){
						if(fieldDesc.getRelationshipName() != null){ // relationship 
							String fullyQualifiedRelationshipName = prefixLowerCase+fieldDesc.getRelationshipName().toLowerCase();
							SObjectType refSObjectType = fieldDesc.getReferenceTo().get(0);
							if(!ignoredSObjects.contains(refSObjectType.getDescribe().getName())){
								mapValues.put(fullyQualifiedRelationshipName+DOT+'id',new FieldDefaultValue(null));
								getDefaultMap(refSObjectType,mapValues,fullyQualifiedRelationshipName+DOT);
							}
						}else { // field
							mapValues.put(fullyQualifiedFieldName,new FieldDefaultValue(sObjectType.getDescribe(),fieldDesc));
						}
					}
				}
			}
			return mapValues;
		}

		/**
		* @description get relationship names key set after a given prefix
		*/
		@testVisible
		private Set<String> getRelationshipKeySet(Set<String> keySetOverride, String prefix){
			if(keySetOverride == null || prefix == null) return null;
			Set<String> relationshipKeySet = new Set<String>();
			String prefixLowerCase = prefix.toLowerCase();
			for(String fullyQualifiedFieldName : keySetOverride){
				fullyQualifiedFieldName = fullyQualifiedFieldName.toLowerCase();
				if(fullyQualifiedFieldName.startsWith(prefixLowerCase)){
					if(fullyQualifiedFieldName.substringAfter(prefixLowerCase).contains(DOT)) 
						relationshipKeySet.add(fullyQualifiedFieldName.substringBetween(prefixLowerCase,DOT));
				}
			}
			return relationshipKeySet;
		}

		/**
		* @description Convert Map<String,Object> to Map<String,IFieldDefaultValue>
		*/
		@testVisible
		private Map<String,IFieldDefaultValue> convertMap(Map<String,Object> mapValues){
			Map<String,IFieldDefaultValue> convertedMap = new Map<String,IFieldDefaultValue>();
			for(String name : mapValues.keySet()){
				if(name != null){
					Object value = mapValues.get(name);
					if(value instanceof IFieldDefaultValue)
							convertedMap.put(name.trim().toLowerCase(),(IFieldDefaultValue)value);
					else 
							convertedMap.put(name.trim().toLowerCase(),new FieldDefaultValue(value));
				}
			}
			return convertedMap;
		}

		/**
		* @description test if a field requires a default value
		*/
		@testVisible
		private Boolean defaultValueIsRequired(Schema.DescribeFieldResult fieldDesc){
			return !fieldDesc.isDefaultedOnCreate() && !fieldDesc.isAutoNumber() && !fieldDesc.isNillable() && fieldDesc.isCreateable();
		}

		/**
		* @description get the default for a specific field
		* @param fieldDesc : field describe
		* @param counter : counter
		* @return Object : default value
		*/
		public Object getDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			if(fieldDesc != null){
				if(fieldDesc.getType() == Schema.DisplayType.Base64){
					return getBase64DefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Boolean){
					return getBooleanDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Combobox){
					return getComboboxDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Currency){
					return getCurrencyDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Date){
					return getDateDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Datetime){
					return getDateTimeDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Double){
					return getDoubleDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Email){
					return getEmailDefaultValue(sObjectDesc,fieldDesc,counter);
				}else if(fieldDesc.getType() == Schema.DisplayType.ID){
					return getIDDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Integer){
					return getIntegerDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.MultiPicklist){
					return getMultiPicklistDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Percent){
					return getPercentDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Phone){
					return getPhoneDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Picklist){
					return getPicklistDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.String){
					return getStringDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.TextArea){
					return getTextAreaDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Time){
					return getTimeDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.URL){
					return getURLDefaultValue(sObjectDesc,fieldDesc,counter);
				}
			}
			return null;
		}
		/**
		* @description get the default value for a picklist
		*/
		@testVisible
		protected String getDefaultPicklistValue(Schema.DescribeFieldResult fieldDesc){
			if(fieldDesc != null){
				List<Schema.PicklistEntry> pickVals = fieldDesc.getPicklistValues();        
				for (Schema.PicklistEntry pickVal: pickVals) {
				    if (pickVal.isDefaultValue()) {
				        return pickVal.getValue();
				    }    
				}
				// if no default value is set
				return pickVals.get(0).getValue();
			}
			return null;
		}

		public abstract Blob getBase64DefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Boolean getBooleanDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getComboboxDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getCurrencyDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Date getDateDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Datetime getDateTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Double getDoubleDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract ID getIDDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Integer getIntegerDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getMultiPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Decimal getPercentDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getPhoneDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getStringDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getTextAreaDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Time getTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getURLDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc, Integer counter);
	}

	/**
	* @description class DefaultValueProvider
	*/
	@testVisible
	private class DefaultValueProvider extends ADefaultValueProvider{

		public override Blob getBase64DefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Blob.valueOf(counter.format());
		}
		public override Boolean getBooleanDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return true;
		}
		public override String getComboboxDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter.format();
		}
		public override String getCurrencyDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter.format();
		}
		public override Date getDateDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Date.today();
		}
		public override Datetime getDateTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return DateTime.now();
		}
		public override Double getDoubleDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public override String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format()+'@email.com';
		}
		public override ID getIDDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return null;
		}
		public override Integer getIntegerDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public override String getMultiPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return getDefaultPicklistValue(fieldDesc);
		}
		public override Decimal getPercentDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public override String getPhoneDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return '123456789';
		}
		public override String getPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return getDefaultPicklistValue(fieldDesc);
		}
		public override String getStringDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format();
		}
		public override String getTextAreaDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format();
		}
		public override Time getTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Time.newInstance(0, 0, 0, 0);
		}
		public override String getURLDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'http://test' + counter + '.com';
		}
	}

	/**
	* @description interface IFieldDefaultValue
	*/
	public interface IFieldDefaultValue{
		Object getValue(Integer counter);
	}

	/**
	* @description class AutoFieldDefaultValue
	*/
	@testVisible
	private class AutoFieldDefaultValue implements IFieldDefaultValue{
		public Object getValue(Integer counter){
			return null;
		}
	}

	/**
	* @description class FieldDefaultValue
	*/
	@testVisible
	private class FieldDefaultValue implements IFieldDefaultValue{
		private Object value = null;
		private Schema.DescribeSObjectResult sObjectDesc = null;
		private Schema.DescribeFieldResult fieldDesc = null;

		public FieldDefaultValue(Object value){
			this.value = value;
		}		

		public FieldDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc){
			this.sObjectDesc = sObjectDesc;
			this.fieldDesc = fieldDesc;
		}

		public Object getValue(Integer counter){
			if(value != null){
				if(value instanceof String)
					return util.mergeValue((String)value,'Index',counter.format());
				else return value;
			} 
			return dvProvider.getDefaultValue(sObjectDesc,fieldDesc,counter);
		}
	}

	/**
	* @description Util : Utility class
	*/
	@testVisible
	private class Util {

		/**
		* @description get field name from a relationship name
		*/
		public String relationshipToFieldName(String relationshipName){
			String relationshipNameLowerCase = relationshipName.toLowerCase();
			if(relationshipNameLowerCase.contains('__r')) // custom relationship 
				return relationshipNameLowerCase.replace('__r', '__c');
			return relationshipNameLowerCase+'id'; // standard relationship
		}

		/**
		* @description merge value in a string
		*/
		public Object mergeValue(String text, String name, String value){
			if(text == null) return null;
			String pattern = '(?i)\\{!'+name+'\\}';
			return text.replaceAll(pattern,value);
		}

		/**
		* @description format an error message
		*/
		public String formatErrorMessage(String message, List<String> mergeValues, String originalMessage){
			String errorMessage = String.format(message,mergeValues);
			if(!String.isBlank(originalMessage)) errorMessage +='\n'+'Original error message : '+originalMessage;
			return errorMessage;
		}
	}

	/**
	* @description Exceptions
	*/
	public class TestDataFactoryException extends Exception {}

}
