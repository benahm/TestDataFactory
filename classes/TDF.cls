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
* @description TDF Class
*/
@testVisible
public class TDF {

	// Org config
	// ==========================================================================
	private static final Boolean PERSON_ACCOUNT_IS_ENABLED = false;
	// ==========================================================================

	public static final IFieldDefaultValue DEFAULT_VALUE = new AutoFieldDefaultValue();
	
	private static DefaultValueProvider dvProvider = new DefaultValueProvider();
	private static final Util util = new Util();
	private static final String DOT = '.';

	/* ===========================  Properties =========================== */
	// Global Describe
	private static Map<String, Schema.SObjectType> globalDescribe{
		get{
			if(globalDescribe == null){
		 		globalDescribe = Schema.getGlobalDescribe();
			}
			return globalDescribe;
		}
	} 
	// Person Account record type Ids
	@testVisible
	private static Set<Id> personAccountRecordTypes{ 
		get{
			if(personAccountRecordTypes == null){
				String account = 'Account';
				personAccountRecordTypes = new Map<Id,SObject>(Database.query('select Id from RecordType where SObjectType=:account and isPersonType=true')).keySet();
			}
			return personAccountRecordTypes;
		}
	}

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @return SObject : sObject instance
	 */
	public static SObject createSObject(String sObjectName){
		return createSObject(sObjectName,new Map<String,Object>());
	}

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @param Map<String,Object> : map of values 
	 * @return SObject : sObject instance
	 */
	public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride){
		return createSObject(sObjectName,mapOfValuesOverride,false);
	}

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @param Boolean : do insert flag 
	 * @return SObject : sObject instance
	 */
	public static SObject createSObject(String sObjectName, Boolean doInsert){
		return createSObject(sObjectName,new Map<String,Object>(),doInsert);
	}

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @param Map<String,Object> : map of values
	 * @param Boolean : do insert flag 
	 * @return SObject : sObject instance
	 */
	public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride, Boolean doInsert){
		return createSObjectList(sObjectName,mapOfValuesOverride,doInsert,1).get(0);
	}
	
	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param numberOfSObjects : number of sObjects
	 * @return List<SObject> : list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Integer numberOfSObjects){
		return createSObjectList(sObjectName,new Map<String,Object>(),numberOfSObjects);
	}		

	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param Map<String,Object> : map of values
	 * @param numberOfSObjects : number of sObjects
	 * @return List<SObject> : list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Integer numberOfSObjects){
		return createSObjectList(sObjectName,mapOfValuesOverride,false,numberOfSObjects);
	}	

	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param Boolean : do insert flag
	 * @param numberOfSObjects : number of sObjects
	 * @return List<SObject> : list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Boolean doInsert, Integer numberOfSObjects){
		return createSObjectList(sObjectName,new Map<String,Object>(),doInsert,numberOfSObjects);
	}

	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param Map<String,Object> : map of values
	 * @param Boolean : do insert flag
	 * @param numberOfSObjects : number of sObjects
	 * @return List<SObject> : list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects){
		Schema.SObjectType sObjectType = globalDescribe.get(sObjectName); 
		ISObjectFactory sObjFactory = new SObjectFactory(sObjectType);
		List<SObject> listSObjectInstance = sObjFactory.getListSObjectInstance(mapOfValuesOverride, doInsert, numberOfSObjects);
		return listSObjectInstance;
	}

	/**
	 * @description set the default value provider 
	 * @param DefaultValueProvider : default value provider
	 */
	public static void setDefaultValueProvider(DefaultValueProvider dvProviderOverride){
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
	* @description class SObjectManager : manage all the sObjects instances and the insertion to the salesforce DB
	*/
	@testVisible
	private class SObjectManager implements ISObjectManager{
		
		private String sObjectName = null; // main sObject name
		@testVisible
		private List<SObject> mainSObjectList = new List<SObject>(); // list of main sObject instances
		@testVisible
		private Map<String,List<SObject>> relatedSObjMapList = new Map<String,List<SObject>>(); // map of all list of related sObject instances
		@testVisible
		private List<String> orderedRelationshipList = new List<String>(); // list of ordered relationship names

		// Error Messages 
		private String ERR_RECORDTYPE_REQUIRED_FOR_ACCOUNT = 'RecordTypeId is required to create an account';
		private String ERR_NAME_ON_PERSONACCOUNT = 'You can not set the name field for a person account';
		private String ERR_CONTACT_TO_PERSONACCOUNT = 'You cannot set the AccountId of a contact to a person account';
		private String ERR_REQUIRED_FOR_ASSET = 'AccountId or ContactId is required for an Asset';
		private String ERR_INSERT_SOBJECT = 'Unable to insert "{0}"';
		

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
		* @param Integer : index
		* @param SObject : sObject instance
		*/
		public void setSObject(Integer index,SObject sObj){
			if(index < 0) return;
			if(index < mainSObjectList.size())
				mainSObjectList.set(index,sObj);
			else mainSObjectList.add(sObj);
		}

		/**
		* @description get an sObject from the main list with a specific index
		* @param Integer : index
		* @return SObject : sObject instance
		*/
		public SObject getSObject(Integer index){
			if(index >= mainSObjectList.size() || index < 0) return null;
			return mainSObjectList.get(index);
		}

		/**
		* @description set a related sObject with a specific index and relationship name
		* @param Integer : index
		* @param String : relationship name
		* @param SObject : sObject instance
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
		* @param Integer : index
		* @param String : relationship name
		* @return SObject : sObject instance
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
			// loop through the ordered relationship list
			for(Integer i = 0; i < orderedRelationshipList.size(); i++){
				String relationshipName = orderedRelationshipList.get(i);
				List<SObject> sObjParentList = relatedSObjMapList.get(relationshipName);
				insertList(DOT+relationshipName,validateList(relationshipName,sObjParentList));
				if(relationshipName.contains(DOT)){
					String childRelationshipName = relationshipName.substringBeforeLast(DOT);
					List<SObject> sObjChildList = relatedSObjMapList.get(childRelationshipName);
					// link child sObject list to the parent sObject list
					setChildParentRelationship(sObjChildList,sObjParentList,relationshipName.substringAfterLast(DOT));
				}else{
					// link child sObject list to the main sObject list
					setChildParentRelationship(mainSObjectList,sObjParentList,relationshipName);
				}
			}

			insertList('',validateList('',mainSObjectList));
		}

		/**
		* @description set child parent relationship
		* @param List<SObject> : list of child sObjects
		* @param List<SObject> : list of parent sObjects
		* @param String : relationship name that links the child to the parent
		*/
		@testVisible
		private void setChildParentRelationship(List<SObject> sObjChildList, List<SObject> sObjParentList, String relationshipName){
			if(sObjChildList == null || sObjParentList == null) return;
			if(sObjChildList.size() != sObjParentList.size()) return;
			Integer index = 0;
			for(SObject sObjChild: sObjChildList){
				// set field related to the relationship name (on the child sObject), with the Id of the parent sObject
				sObjChild.put(util.relationshipToFieldName(relationshipName),sObjParentList.get(index).get('Id'));
				index++;
			}
		}

		/**
		* @description add relationship name to a list, ordered by the number of dots
		* @param String : relationship name with dot notation (example contact.account)
		*/
		@testVisible
		private void addRelationshipName(String dotRelationshipName){
			String dotRelationshipNameLowerCase = dotRelationshipName.toLowerCase();
			Integer i=0;
			for (String rName : orderedRelationshipList) {
				if(dotRelationshipNameLowerCase == rName) return; // already exists
				if(rName.countMatches('.') < dotRelationshipName.countMatches('.')){
					// insert depending of the number of dots
					orderedRelationshipList.add(i, dotRelationshipNameLowerCase);
					return;
				}
				i++;
			}
			// insert at the end
			orderedRelationshipList.add(dotRelationshipNameLowerCase);
		}

		/**
		* @description insert a list of sObjects
		* @param String : relationship name with dot notation (example contact.account)
		* @param List<SObject> : list of sObjects
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
		* @return List<SObject> : list of sObject instances
		*/
		@testVisible
		// @todo : review the generate of default value for lastname & name , write test classes
		private List<sObject> validateList(String relationshipName, List<SObject> sObjList){
			Integer counter = 0;
			for(SObject sObj : sObjList){
				if(sObj.getSObjectType() == Account.SObjectType){
					if(PERSON_ACCOUNT_IS_ENABLED){
						Id recordTypeId = (Id)sObj.get('RecordTypeId');
						if(recordTypeId == null) throw new TestDataFactoryException(util.formatErrorMessage(ERR_RECORDTYPE_REQUIRED_FOR_ACCOUNT,new List<String>{},''));
						Boolean nameIsSet = (sObj.get('Name') != null);
						Schema.DescribeSObjectResult accountDesc = Account.SObjectType.getDescribe();
						if(personAccountRecordTypes.contains(recordTypeId)) { // Person Account
							if(nameIsSet) throw new TestDataFactoryException(util.formatErrorMessage(ERR_NAME_ON_PERSONACCOUNT,new List<String>{},''));
							sObj.put('Lastname',dvProvider.getTextDefaultValue(accountDesc,accountDesc.fields.getMap().get('Lastname').getDescribe(),counter));
							if(relationshipName.substringBeforeLast(DOT) == 'contact'){
								throw new TestDataFactoryException(util.formatErrorMessage(ERR_CONTACT_TO_PERSONACCOUNT,new List<String>{},''));
							}
						}else{ // Business Account
							if(!nameIsSet)
								sObj.put('Name',dvProvider.getTextDefaultValue(accountDesc,Account.fields.Name.getDescribe(),counter));
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
		SObject getSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert);
		List<SObject> getListSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects);
	}

	/**
	* @description class SObjectFactory : manage the creation of all the sObjects instances 
	*/
	@testVisible
	private class SObjectFactory implements ISObjectFactory{

		private Schema.SObjectType sObjectType = null;
		private ISObjectManager sObjMgr = null;

		// Error Messages 
		private String ERR_NOT_FOUND_SOBJECT = 'Unable to find the sObject';
		private String ERR_FIELD_NOT_EXIST = 'The field "{0}" does not exist on "{1} or the value type provided is incorrect"';
		private String ERR_RELATIONSHIP_NOT_EXIST = 'The relationship "{0}" does not exist on "{1}"';


		public SObjectFactory(Schema.SObjectType sObjectType){
			validateSObjectType(sObjectType);
			this.sObjectType = sObjectType;
			this.sObjMgr = new SObjectManager(sObjectType.getDescribe().getName());
		}

		/**
		* @description Get SObject Manager instance
	  * @return ISObjectManager : sObjectManager instance
		*/
		public ISObjectManager getSObjectManager(){
			return sObjMgr;
		}

		/**
		* @description Generate an sObject instance
		* @return SObject : sObject instance
		*/
		public SObject getSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert){
			return getListSObjectInstance(mapOfValuesOverride,doInsert,1).get(0);
		}

		/**
		* @description Generate a list of sObject instances
		* @return List<SObject> : list of sObject instances
		*/
		public List<SObject> getListSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects){
			Map<String,IFieldDefaultValue> mapOfValues = dvProvider.getDefaultMap(sObjectType,mapOfValuesOverride);

			for(Integer i = 0; i < numberOfSObjects; i++) {
				sObjMgr.setSObject(i,sObjectType.newSObject()); 
				initSObjectInstance(mapOfValues,i);
			}

			if(doInsert) sObjMgr.insertAll();

			return sObjMgr.getMainSObjectList();
		}

		/**
		* @description Initiate an sObject
		* @param Map<String,IFieldDefaultValue> : map of values
		* @param Integer : counter
		*/
		private void initSObjectInstance(Map<String,IFieldDefaultValue> mapOfValues, Integer counter){
			String sObjectName = sObjectType.getDescribe().getName();
			for(String fullyQualifiedFieldName : mapOfValues.keySet()){

				String fieldName = (DOT+fullyQualifiedFieldName).substringAfterLast(DOT);
				if(fullyQualifiedFieldName.contains(DOT)){ // field with dot notation

					String firstRelationshipName = fullyQualifiedFieldName.substringBefore(DOT);
					String fullyQualifiedRelationshipName = fullyQualifiedFieldName.substringBeforeLast(DOT);
					SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipName,counter);
					putField(relatedSObj,fieldName,mapOfValues.get(fullyQualifiedFieldName).getValue(counter),sObjectName+DOT+fullyQualifiedRelationshipName);
					putSObject(sObjMgr.getSObject(counter),firstRelationshipName,sObjMgr.getRelationship(counter,firstRelationshipName),sObjectName);

				}else { // field name
					putField(sObjMgr.getSObject(counter),fieldName,mapOfValues.get(fieldName).getValue(counter),sObjectName);
				}

			}
		}

		/**
		* @description Initiate all the related sObjects for a given fully qualified relationship name
		* @return SObject : sObject instance
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
		* @return SObject : sObject instance
		*/
		@testVisible
		private SObject getRelatedSObjectInstance(Schema.SObjectType sObjectType, String relationshipName, String prefix){
			Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
			Schema.DescribeFieldResult fieldDesc;
			try{
				fieldDesc = fieldsMap.get(util.relationshipToFieldName(relationshipName)).getDescribe();
			}catch(Exception e){
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_RELATIONSHIP_NOT_EXIST,new List<String>{relationshipName,prefix},e.getMessage()));
			}
			return  fieldDesc.getReferenceTo().get(0).newSObject();
		}
		/**
		* @description put a related sObject to an sObject
		* @return SObject : sObject instance
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
		* @return SObject : sObject instance
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
		/**
		* @description validate sObjectType
		*/
		@testVisible
		private void validateSObjectType(Schema.SObjectType sObjectType){
			if(sObjectType == null) 
				throw new TestDataFactoryException(util.formatErrorMessage(ERR_NOT_FOUND_SOBJECT,new List<String>{},''));
		}

	}

	/**
	* @description interface IDefaultValueProvider
	*/
	public interface IDefaultValueProvider{
		Map<String,IFieldDefaultValue> getDefaultMap(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride);
		Object getDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter);
	}

	/**
	* @description virtual class DefaultValueProvider : manage the creation of the defaultMap and getting field default values
	*/
	public virtual class DefaultValueProvider implements IDefaultValueProvider{

		/**
		* @description get the default map values
		* @param Schema.SObjectType : sObject Type
		* @param Map<String,Object> : mapOfValuesOverride
		* @return Map<String,IFieldDefaultValue> : map values
		*/
		public Map<String,IFieldDefaultValue> getDefaultMap(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride){
			Map<String,IFieldDefaultValue> mapOfValues = new Map<String,IFieldDefaultValue>(convertMap(mapOfValuesOverride));
			generateDefaultMap(sObjectType,mapOfValues,'');
			return mapOfValues;
		}

		/**
		* @description generate the default map values
		* @param Schema.SObjectType : sObject Type
		* @param Map<String,Object> : mapOfValuesOverride
		* @param String : prefix (example : Contact.Account.)
		*/
		@testVisible
		private void generateDefaultMap(Schema.SObjectType sObjectType, Map<String,IFieldDefaultValue> mapOfValues, String prefix){
			Schema.DescribeSObjectResult sObjectDesc = sObjectType.getDescribe();
			Map<String, Schema.SObjectField> fieldsMap = sObjectDesc.fields.getMap(); // get the fields map
			Set<String> keySetOverride = mapOfValues.keySet();
			Set<String> relationshipKeySet = getRelationshipKeySet(keySetOverride,prefix);
			// loop through fields map
			for(String fieldName : fieldsMap.keySet()){
				Schema.DescribeFieldResult fieldDesc = fieldsMap.get(fieldName).getDescribe(); // get field describe
				String fullyQualifiedFieldName = prefix+fieldName.toLowerCase();
				Object overrideFieldValue = mapOfValues.get(fullyQualifiedFieldName);
				if(overrideFieldValue != null){ // override value provided for the field
					if(overrideFieldValue instanceof AutoFieldDefaultValue) { // auto generate a field value
							if(fieldDesc.getRelationshipName() == null){ // field
								mapOfValues.put(fullyQualifiedFieldName,new FieldDefaultValue(sObjectDesc,fieldDesc));
							}else { // relationship
								putRelationship(mapOfValues,fieldDesc,prefix);
								mapOfValues.remove(fullyQualifiedFieldName);
							} 
					}
				}else { // no override value provided for the field
					Boolean defaultValueIsRequired = defaultValueIsRequired(fieldDesc);
					if(fieldDesc.getRelationshipName() == null){ // field
						if(defaultValueIsRequired)
							mapOfValues.put(fullyQualifiedFieldName,new FieldDefaultValue(sObjectDesc,fieldDesc));
					}else { // relationship
						String relationshipName = fieldDesc.getRelationshipName().toLowerCase();
						if(defaultValueIsRequired || relationshipKeySet.contains(relationshipName)){ // relationship required or mentioned in the mapOfValues
							putRelationship(mapOfValues,fieldDesc,prefix);
						}
					}
				}
			}
		}

		/**
		* @description put a relationship to the mapOfValues
		* @param Map<String,IFieldDefaultValue> : map of values
		* @return Schema.DescribeFieldResult : field describe
		* @param String : prefix (example : Contact.Account.)
		*/
		@testVisible
		private void putRelationship(Map<String,IFieldDefaultValue> mapOfValues, Schema.DescribeFieldResult fieldDesc, String prefix){
			String relationshipName = fieldDesc.getRelationshipName().toLowerCase();
			String fullyQualifiedRelationshipName = prefix+relationshipName;
			// at least add (fullyQualifiedRelationshipName.id,null) to force the instantiation of the related sObject
			mapOfValues.put(fullyQualifiedRelationshipName+DOT+'id',new FieldDefaultValue(null));
			SObjectType refSObjectType = fieldDesc.getReferenceTo().get(0);
			// generate a map for the related sObject
			generateDefaultMap(refSObjectType,mapOfValues,fullyQualifiedRelationshipName+DOT);
		}

		/**
		* @description get relationship names keyset that starts with a given prefix
		* @param Set<String> : keySet of fully qualified field names
		* @param String : prefix (example : Contact.Account.)
		* @return Set<String> : set of relationship names
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
		* @param Map<String,Object> mapOfValues : map of values
		* @return Map<String,IFieldDefaultValue> : converted map
		*/
		@testVisible
		private Map<String,IFieldDefaultValue> convertMap(Map<String,Object> mapOfValues){
			Map<String,IFieldDefaultValue> convertedMap = new Map<String,IFieldDefaultValue>();
			if(mapOfValues == null) return convertedMap;
			for(String name : mapOfValues.keySet()){
				if(name != null){
					Object value = mapOfValues.get(name);
					if(value instanceof IFieldDefaultValue)
							// already of type IFieldDefaultValue
							convertedMap.put(name.trim().toLowerCase(),(IFieldDefaultValue)value);
					else 
							// wrap the value in a FieldDefaultValue instance
							convertedMap.put(name.trim().toLowerCase(),new FieldDefaultValue(value));
				}
			}
			return convertedMap;
		}

		/**
		* @description test if a field requires a default value
		* @param Schema.DescribeFieldResult : field describe
		* @return Boolean : is default value required
		*/
		@testVisible
		private Boolean defaultValueIsRequired(Schema.DescribeFieldResult fieldDesc){
			return 
				!fieldDesc.isDefaultedOnCreate() // does not have a defaut value on creation
				&& !fieldDesc.isAutoNumber() // is not an auto number
				&& !fieldDesc.isNillable() // is required
				&& fieldDesc.isCreateable(); // value can be set on creation 
		}

		/**
		* @description get the default for a specific field
		* @param fieldDesc : field describe
		* @param counter : counter
		* @return Object : default value
		*/
		public Object getDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			if(fieldDesc != null){
				// DisplayType Enum -> https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_enum_Schema_DisplayType.htm
				if(fieldDesc.getType() == Schema.DisplayType.Base64){
					return getBase64DefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Combobox){
					return getComboboxDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Address){
					return getAddressDefaultValue(sObjectDesc,fieldDesc,counter);
				}else if(fieldDesc.getType() == Schema.DisplayType.Reference){
					return getLookupDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Boolean){
					return getCheckboxDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Currency){
					return getCurrencyDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Date){
					return getDateDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Datetime){
					return getDateTimeDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Email){
					return getEmailDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Location){
					return getGeolocationDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Integer || fieldDesc.getType() == Schema.DisplayType.Double){
					return getNumberDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Percent){
					return getPercentDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Phone){
					return getPhoneDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.Picklist){
					return getPicklistDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.MultiPicklist){
					return getMultiPicklistDefaultValue(sObjectDesc,fieldDesc,counter);
				} else if(fieldDesc.getType() == Schema.DisplayType.String){
					return getTextDefaultValue(sObjectDesc,fieldDesc,counter);
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
		* @param Schema.DescribeFieldResult : field description
		* @return String : picklist default value
		*/
		@testVisible
		protected String getDefaultPicklistValue(Schema.DescribeFieldResult fieldDesc){
			if(fieldDesc != null){
				List<Schema.PicklistEntry> pickVals = fieldDesc.getPicklistValues();        
				for (Schema.PicklistEntry pickVal: pickVals) {
				    if (pickVal.isDefaultValue()) {
				        return pickVal.getValue(); // default value
				    }    
				}
				// if no default value is set, return the first value
				return pickVals.get(0).getValue();
			}
			return null;
		}

		public virtual Blob getBase64DefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Blob.valueOf(counter.format());
		}
		public virtual String getComboboxDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter.format();
		}
		public virtual Address getAddressDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return new Address();
		}		
		public virtual ID getLookupDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return null;
		}
		public virtual Boolean getCheckboxDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return true;
		}
		public virtual String getCurrencyDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter.format();
		}
		public virtual Date getDateDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Date.today();
		}
		public virtual Datetime getDateTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return DateTime.now();
		}
		public virtual String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format()+'@email.com';
		}
		public virtual Location getGeolocationDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Location.newInstance(0,0);
		}
		public virtual Decimal getNumberDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public virtual Decimal getPercentDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return counter;
		}
		public virtual String getPhoneDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return '123456789';
		}
		public virtual String getPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return getDefaultPicklistValue(fieldDesc);
		}
		public virtual String getMultiPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return getDefaultPicklistValue(fieldDesc);
		}
		public virtual String getTextDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format();
		}
		public virtual String getTextAreaDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'test'+counter.format();
		}
		public virtual Time getTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
			return Time.newInstance(0, 0, 0, 0);
		}
		public virtual String getURLDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer counter){
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
	* @description class AutoFieldDefaultValue :
	*/
	@testVisible
	private class AutoFieldDefaultValue implements IFieldDefaultValue{
		public Object getValue(Integer counter){
			return null;
		}
	}

	/**
	* @description class FieldDefaultValue : wrapper for a field default value
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

		/**
		* @description get encapsulated value
		* @param Integer : counter
		* @return Object : field default value
		*/
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
		* @param String : relationship name
		* @return String : field name 
		*/
		public String relationshipToFieldName(String relationshipName){
			String relationshipNameLowerCase = relationshipName.toLowerCase();
			if(relationshipNameLowerCase.contains('__r')) // custom relationship 
				return relationshipNameLowerCase.replace('__r', '__c');
			return relationshipNameLowerCase+'id'; // standard relationship
		}

		/**
		* @description merge value in a string
		* @param String : text with a merge value
		* @param String : name of the merge value
		* @param String : value to be merged
		* @return String : text with merged value
		*/
		public String mergeValue(String text, String name, String value){
			if(text == null) return null;
			String pattern = '(?i)\\{!'+name+'\\}';
			return text.replaceAll(pattern,value);
		}

		/**
		* @description format an error message
		* @param String : message
		* @param List<String> : merge values
		* @param String : original message
		* @return String : error message
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
