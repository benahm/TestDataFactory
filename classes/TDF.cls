/**
* @author benahm
* @date 2017
* @description TDF Class
*/
public class TDF {
	private static final String DOT = '.';
	private static final Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
	private static final Util util=new Util();
	@testVisible
	private static IDefaultValueProvider dvPrvdrOverride = null;
	// https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dml_non_dml_objects.htm
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
		ISObjectFactory sObjFactory = new SObjectFactory(dvPrvdrOverride);
		List<SObject> listSObjectInstance = sObjFactory.getListSObjectInstance(sObjectType, mapValuesOverride, numberOfSObjects);
		if(doInsert) sObjFactory.getSObjectManager().insertAllSObjects();
		return listSObjectInstance;
	}

	/**
	 * @description set the default value provider 
	 */
	public static void setDefaultValueProvider(ADefaultValueProvider dvPrvdr){
		dvPrvdrOverride = dvPrvdr;
	}


	/**
	* @description interface ISObjectManager
	*/
	public interface ISObjectManager{
		List<SObject> getMainSObjectList();
		void setSObject(Integer index, SObject sObj);
		SObject getSObject(Integer index);
		void setRelationship(Integer index, String relationshipName, SObject sObj);
		SObject getRelationship(Integer index, String relationshipName);
		void insertAllSObjects();
	}

	/**
	* @description class SObjectManager
	*/
	@testVisible
	private class SObjectManager implements ISObjectManager{
		@testVisible
		private List<SObject> mainSObjectList = new List<SObject>();
		@testVisible
		private Map<String,List<SObject>> relatedSObjMapList = new Map<String,List<SObject>>();
		@testVisible
		private List<String> orderedRelationshipList = new List<String>();

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
		* @description get a related sObject in with specific index and relationship name
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
		public void insertAllSObjects(){
			for(Integer i = 0; i < orderedRelationshipList.size(); i++){
				String relationshipName = orderedRelationshipList.get(i);
				List<SObject> sObjParentList = relatedSObjMapList.get(relationshipName);
				insert sObjParentList;
				if(relationshipName.contains(DOT)){
					String childRelationshipName = relationshipName.substringBeforeLast(DOT);
					List<SObject> sObjChildList = relatedSObjMapList.get(childRelationshipName);
					setChildParentRelationship(sObjChildList,sObjParentList,relationshipName.substringAfterLast(DOT));
				}else{
					setChildParentRelationship(mainSObjectList,sObjParentList,relationshipName);
				}
			}

			insert mainSObjectList;
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
	}

	/**
	* @description interface ISObjectFactory
	*/
	public interface ISObjectFactory{

		ISObjectManager getSObjectManager();
		IDefaultValueProvider getDefaultValueProvider();
		SObject getSObjectInstance(String sObjectName);
		SObject getSObjectInstance(Schema.SObjectType sObjectType);
		SObject getSObjectInstance(String sObjectName, Map<String,Object> mapValuesOverride);
		SObject getSObjectInstance(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride);
		List<SObject> getListSObjectInstance(String sObjectName, Integer numberOfSObjects);
		List<SObject> getListSObjectInstance(Schema.SObjectType sObjectType, Integer numberOfSObjects);
		List<SObject> getListSObjectInstance(String sObjectName, Map<String,Object> mapValuesOverride, Integer numberOfSObjects);
		List<SObject> getListSObjectInstance(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride, Integer numberOfSObjects);
	}

	/**
	* @description class SObjectFactory
	*/
	@testVisible
	private class SObjectFactory implements ISObjectFactory{

		private ISObjectManager sObjMgr = new SObjectManager();
		private IDefaultValueProvider dvPrvdr = new DefaultValueProvider();

		public SObjectFactory(){}
		public SObjectFactory(IDefaultValueProvider dvPrvdrOverride){
			if(dvPrvdrOverride != null) 
				this.dvPrvdr = dvPrvdrOverride;
		}

		public ISObjectManager getSObjectManager(){
			return sObjMgr;
		}

		public IDefaultValueProvider getDefaultValueProvider(){
			return dvPrvdr;
		}

		/**
		* @description Generate an sObject instance
		* @return SObject : sObject instance
		*/
		public SObject getSObjectInstance(String sObjectName){
			return getSObjectInstance(globalDescribe.get(sObjectName));
		}
		public SObject getSObjectInstance(Schema.SObjectType sObjectType){
			return getSObjectInstance(sObjectType,new Map<String,Object>());
		}
		public SObject getSObjectInstance(String sObjectName, Map<String,Object> mapValuesOverride){
			return getSObjectInstance(globalDescribe.get(sObjectName),mapValuesOverride);
		}		
		public SObject getSObjectInstance(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride){
			return getListSObjectInstance(sObjectType, mapValuesOverride,1).get(0);
		}

		/**
		* @description Generate a list of sObject instances
		* @return List<SObject> : list of sObject instances
		*/
		public List<SObject> getListSObjectInstance(String sObjectName, Integer numberOfSObjects){
			return getListSObjectInstance(globalDescribe.get(sObjectName),numberOfSObjects);
		}
		public List<SObject> getListSObjectInstance(Schema.SObjectType sObjectType, Integer numberOfSObjects){
			return getListSObjectInstance(sObjectType,new Map<String,Object>(),numberOfSObjects);
		}
		public List<SObject> getListSObjectInstance(String sObjectName, Map<String,Object> mapValuesOverride, Integer numberOfSObjects){
			return getListSObjectInstance(globalDescribe.get(sObjectName),mapValuesOverride,numberOfSObjects);
		}
		public List<SObject> getListSObjectInstance(Schema.SObjectType sObjectType, Map<String,Object> mapValuesOverride, Integer numberOfSObjects){
			Map<String,Object> mapValuesLowerCase = util.mapToLowerCase(mapValuesOverride);
			Map<String,Object> mapValues = dvPrvdr.getDefaultMap(sObjectType,mapValuesLowerCase.keySet());
			mapValues.putAll(mapValuesLowerCase);
			for(Integer i = 0; i < numberOfSObjects; i++) {

				sObjMgr.setSObject(i,sObjectType.newSObject()); 
				for(String fullyQualifiedFieldName : mapValues.keySet()){

					String fieldName = (DOT+fullyQualifiedFieldName).substringAfterLast(DOT);
					if(fullyQualifiedFieldName.contains(DOT)){ // field with dot notation

						String firstRelationshipName = fullyQualifiedFieldName.substringBefore(DOT);
						String fullyQualifiedRelationshipName = fullyQualifiedFieldName.substringBeforeLast(DOT);
						SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipName,i);
						relatedSObj.put(fieldName,util.mergeValue(mapValues.get(fullyQualifiedFieldName),'Index',i.format())); 
						sObjMgr.getSObject(i).putSObject(firstRelationshipName, sObjMgr.getRelationship(i,firstRelationshipName));

					}else { // field name
						sObjMgr.getSObject(i).put(fieldName,util.mergeValue(mapValues.get(fieldName),'Index',i.format()));
					}

				}
			}

			return sObjMgr.getMainSObjectList();
		}

		/**
		* @description Initiate all the related sObjects for a given fully qualified relationship name
		* @return SObject
		*/
		@testVisible
		private SObject getRelationshipInstance(Schema.SObjectType sObjectType,String fullyQualifiedRelationshipName, Integer index){
			SObject sObj = sObjMgr.getRelationship(index,fullyQualifiedRelationshipName);
			if(sObj != null) return sObj;
			String leafRelationshipName = (DOT+fullyQualifiedRelationshipName).substringAfterLast(DOT);

			if(fullyQualifiedRelationshipName.contains(DOT)){ // multiple relationships
				String fullyQualifiedRelationshipNameBefore = fullyQualifiedRelationshipName.substringBeforeLast(DOT);
				SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipNameBefore,index);
				sObj = getRelatedSObjectInstance(relatedSObj.getSObjectType(),util.relationshipToFieldName(leafRelationshipName)); 
				relatedSObj.putSObject(leafRelationshipName,sObj);
			}else { // single relationship
				sObj = getRelatedSObjectInstance(sObjectType,util.relationshipToFieldName(leafRelationshipName)); 
			}

			sObjMgr.setRelationship(index,fullyQualifiedRelationshipName,sObj);
			return sObj;
		}
		/**
		* @description get related sObject 
		* @return SObject
		*/
		@testVisible
		private SObject getRelatedSObjectInstance(Schema.SObjectType sObjectType, String fieldName){
			Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
			Schema.DescribeFieldResult fieldDesc = fieldMap.get(fieldName).getDescribe();
			return  fieldDesc.getReferenceTo().get(0).newSObject();
		}
	}

	/**
	* @description interface IDefaultValueProvider
	*/
	public interface IDefaultValueProvider{
		Map<String,Object> getDefaultMap(String sObjectName, Set<String> setValuesOverride);
		Map<String,Object> getDefaultMap(Schema.SObjectType sObjectType, Set<String> setValuesOverride);
	}

	/**
	* @description abstract class ADefaultValueProvider
	*/
	public abstract class ADefaultValueProvider implements IDefaultValueProvider{

		/**
		* @description get the default map values
		* @return Map<String,Object> : map values
		*/
		public Map<String,Object> getDefaultMap(String sObjectName, Set<String> setValuesOverride){
			return getDefaultMap(globalDescribe.get(sObjectName),setValuesOverride);
		}
		public Map<String,Object> getDefaultMap(Schema.SObjectType sObjectType, Set<String> setValuesOverride){
			return getDefaultMap(sObjectType,setValuesOverride,'');
		}
		@testVisible
		private Map<String,Object> getDefaultMap(Schema.SObjectType sObjectType, Set<String> setValuesOverride, String prefix){
			Map<String, Object> defaultValues = new Map<String,Object>();
			Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
			String prefixLowerCase = prefix.toLowerCase();
			Schema.DescribeFieldResult fieldDesc;
			Integer counter = 0;
			Set<String> setOverrideRelationship = getSetOverrideRelationship(setValuesOverride,prefixLowerCase);
			for(String fieldName : fieldMap.keySet()){
				fieldDesc = fieldMap.get(fieldName).getDescribe();
				if(defaultValueIsRequired(fieldDesc) || setOverrideRelationship.contains(util.toLowerCase(fieldDesc.getRelationshipName()))){
					if(fieldDesc.getRelationshipName() != null){ // relationship field
						String fullyQualifiedRelationshipName = prefixLowerCase+fieldDesc.getRelationshipName().toLowerCase();
						if(!setValuesOverride.contains(fullyQualifiedRelationshipName+'id')){
							SObjectType refSObjectType = fieldDesc.getReferenceTo().get(0);
							if(!ignoredSObjects.contains(refSObjectType.getDescribe().getName())){
								defaultValues.put(fullyQualifiedRelationshipName+DOT+'id',null);
								defaultValues.putAll(getDefaultMap(refSObjectType,setValuesOverride,fullyQualifiedRelationshipName+DOT));
							}
						}
					}else { // field
						Object fieldValue = getDefaultValue(fieldDesc,counter++);
						defaultValues.put(prefixLowerCase+fieldName.toLowerCase(),fieldValue);
					}
				}
			}
			return defaultValues;
		}

		@testVisible
		private Set<String> getSetOverrideRelationship(Set<String> setValuesOverride, String prefix){
			if(setValuesOverride == null || prefix == null) return null;
			Set<String> setOverrideRelationship = new Set<String>();
			String prefixLowerCase = prefix.toLowerCase();
			for(String fullyQualifiedFieldName : setValuesOverride){
				fullyQualifiedFieldName = fullyQualifiedFieldName.toLowerCase();
				if(fullyQualifiedFieldName.startsWith(prefixLowerCase) && fullyQualifiedFieldName.substringAfter(prefixLowerCase).contains(DOT)){
					setOverrideRelationship.add(fullyQualifiedFieldName.substringBetween(prefixLowerCase,DOT));
				}
			}
			return setOverrideRelationship;
		}

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
		@testVisible
		private Object getDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			if(fieldDesc != null){
				if(fieldDesc.getType() == Schema.DisplayType.Base64){
					return getBase64DefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Boolean){
					return getBooleanDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Combobox){
					return getComboboxDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Currency){
					return getCurrencyDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Date){
					return getDateDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Datetime){
					return getDateTimeDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Double){
					return getDoubleDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Email){
					return getEmailDefaultValue(fieldDesc,counter);
				}else if(fieldDesc.getType() == Schema.DisplayType.ID){
					return getIDDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Integer){
					return getIntegerDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.MultiPicklist){
					return getMultiPicklistDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Percent){
					return getPercentDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Phone){
					return getPhoneDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Picklist){
					return getPicklistDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.String){
					return getStringDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.TextArea){
					return getTextAreaDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Time){
					return getTimeDefaultValue(fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.URL){
					return getURLDefaultValue(fieldDesc,counter);
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

		public abstract Blob getBase64DefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Boolean getBooleanDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getComboboxDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getCurrencyDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Date getDateDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Datetime getDateTimeDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Double getDoubleDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getEmailDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract ID getIDDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Integer getIntegerDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getMultiPicklistDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Decimal getPercentDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getPhoneDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getPicklistDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getStringDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getTextAreaDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract Time getTimeDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		public abstract String getURLDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
	}

	/**
	* @description class DefaultValueProvider
	*/
	@testVisible
	private class DefaultValueProvider extends ADefaultValueProvider{

		public override Blob getBase64DefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Blob.valueOf(counter.format());
		}
		public override Boolean getBooleanDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return true;
		}
		public override String getComboboxDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter.format();
		}
		public override String getCurrencyDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter.format();
		}
		public override Date getDateDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Date.today();
		}
		public override Datetime getDateTimeDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return DateTime.now();
		}
		public override Double getDoubleDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public override String getEmailDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format()+'@email.com';
		}
		public override ID getIDDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return null;
		}
		public override Integer getIntegerDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public override String getMultiPicklistDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return getDefaultPicklistValue(fieldDesc);
		}
		public override Decimal getPercentDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public override String getPhoneDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return '123456789';
		}
		public override String getPicklistDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return getDefaultPicklistValue(fieldDesc);
		}
		public override String getStringDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format();
		}
		public override String getTextAreaDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format();
		}
		public override Time getTimeDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Time.newInstance(0, 0, 0, 0);
		}
		public override String getURLDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'http://test' + counter + '.com';
		}
	}

	/**
	* @description Util : Utility class
	*/
	@testVisible
	private class Util {
		
		public String relationshipToFieldName(String relationshipName){
			String relationshipNameLowerCase = relationshipName.toLowerCase();
			if(relationshipNameLowerCase.contains('__r')) // custom relationship 
				return relationshipNameLowerCase.replace('__r', '__c');
			return relationshipNameLowerCase+'id'; // standard relationship
		}

		public Map<String,Object> mapToLowerCase(Map<String,Object> mapValues){
			Map<String,Object> mapValuesLowerCase = new Map<String,Object>();
			for(String name : mapValues.keySet()){
				mapValuesLowerCase.put(name.toLowerCase(),mapValues.get(name));
			}
			return mapValuesLowerCase;
		}

		public String toLowerCase(String value){
			if(value == null) return null;
			return value.toLowerCase();
		}

		public Object mergeValue(Object obj, String name, String value){
			if(obj == null) return null;
			if(!(obj instanceof String)) return obj;
			String pattern = '(?i)\\{!'+name+'\\}';
			return ((String)obj).replaceAll(pattern,value);
		}
	}

	/**
	* @description Exceptions
	*/
	public class TestDataFactoryException extends Exception {}


}
