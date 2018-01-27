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
	private static final String DOT = '.';

	private static Map<Schema.SObjectType,Map<String, Schema.SObjectField>> mapOfFieldsMap = new Map<Schema.SObjectType,Map<String, Schema.SObjectField>>();

	// Properties
	// ==========================================================================
	// Global Describe //
	private static Map<String, Schema.SObjectType> globalDescribe{
		get{
			if(globalDescribe == null){
		 		globalDescribe = Schema.getGlobalDescribe();
			}
			return globalDescribe;
		}
	} 
	// Person Account record type Ids //
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
	// ==========================================================================

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @return sObject instance
	 */
	public static SObject createSObject(String sObjectName){
		return createSObject(sObjectName,new Map<String,Object>());
	}

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @param mapOfValuesOverride : map of values 
	 * @return sObject instance
	 */
	public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride){
		return createSObject(sObjectName,mapOfValuesOverride,false);
	}

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @param Boolean : do insert flag 
	 * @return sObject instance
	 */
	public static SObject createSObject(String sObjectName, Boolean doInsert){
		return createSObject(sObjectName,new Map<String,Object>(),doInsert);
	}

	/**
	 * @description create an sObject
	 * @param sObjectName : name of the sObject
	 * @param mapOfValuesOverride : map of values
	 * @param doInsert : do insert flag 
	 * @return sObject instance
	 */
	public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride, Boolean doInsert){
		return createSObjectList(sObjectName,mapOfValuesOverride,doInsert,1).get(0);
	}
	
	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param numberOfSObjects : number of sObjects
	 * @return list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Integer numberOfSObjects){
		return createSObjectList(sObjectName,new Map<String,Object>(),numberOfSObjects);
	}		

	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param mapOfValuesOverride : map of values
	 * @param numberOfSObjects : number of sObjects
	 * @return list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Integer numberOfSObjects){
		return createSObjectList(sObjectName,mapOfValuesOverride,false,numberOfSObjects);
	}	

	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param doInsert : do insert flag
	 * @param numberOfSObjects : number of sObjects
	 * @return list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Boolean doInsert, Integer numberOfSObjects){
		return createSObjectList(sObjectName,new Map<String,Object>(),doInsert,numberOfSObjects);
	}

	/**
	 * @description create a list of sObjects
	 * @param sObjectName : name of the sObject
	 * @param mapOfValuesOverride : map of values
	 * @param doInsert : do insert flag
	 * @param numberOfSObjects : number of sObjects
	 * @return list of sObject instances
	 */
	public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects){
		Schema.SObjectType sObjectType = globalDescribe.get(sObjectName); 
		ISObjectFactory sObjFactory = new SObjectFactory(sObjectType);
		List<SObject> listSObjectInstance = sObjFactory.getListSObjectInstance(mapOfValuesOverride, doInsert, numberOfSObjects);
		return listSObjectInstance;
	}

	/**
	 * @description set the default value provider 
	 * @param dvProviderOverride : default value provider
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
		private Map<String,List<SObject>> relatedSObjMapList = new Map<String,List<SObject>>(); // map of all lists of related sObject instances
		@testVisible
		private List<String> orderedRelationshipList = new List<String>(); // list of ordered relationship names

		// Error Messages 
		private String ERR_RECORDTYPE_REQUIRED_FOR_ACCOUNT = 'RecordTypeId is required to create an account';
		private String ERR_NAME_ON_PERSONACCOUNT = 'You can not set the name field for a person account';
		private String ERR_CONTACT_TO_PERSONACCOUNT = 'You cannot set the AccountId of a contact to a person account';
		private String ERR_REQUIRED_FOR_ASSET = 'AccountId or ContactId is required for an Asset';
		private String ERR_INSERT_SOBJECT = 'Unable to insert "{0}"';
		

		/**
		* @description constructor
		* @return sObjectName : sObject name
		*/
		public SObjectManager(String sObjectName){
			this.sObjectName = sObjectName;
		}

		/**
		* @description get the main sObject list
		* @return list of sObject instances
		*/
		public List<SObject> getMainSObjectList(){
			return mainSObjectList;
		}

		/**
		* @description set an sObject to the main list with a specific index
		* @param index : index
		* @param sObj : sObject instance
		*/
		public void setSObject(Integer index, SObject sObj){
			if(index < 0) return;
			if(index < mainSObjectList.size())
				mainSObjectList.set(index,sObj);
			else mainSObjectList.add(sObj);
		}

		/**
		* @description get an sObject from the main list with a specific index
		* @param index : index
		* @return sObject instance
		*/
		public SObject getSObject(Integer index){
			if(index >= mainSObjectList.size() || index < 0) return null;
			return mainSObjectList.get(index);
		}

		/**
		* @description set a related sObject with a specific index and relationship name
		* @param index : index
		* @param relationshipName : relationship name
		* @param sObj : sObject instance
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
		* @param index : index
		* @param relationshipName : relationship name
		* @return sObject instance
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
				// insert parent sObject list
				insertList(DOT+relationshipName,validateList(relationshipName,sObjParentList));
				if(relationshipName.contains(DOT)){ // multiple relationships
					String childRelationshipName = relationshipName.substringBeforeLast(DOT);
					List<SObject> sObjChildList = relatedSObjMapList.get(childRelationshipName);
					// link child sObject list to the parent sObject list
					setChildParentRelationship(sObjChildList,sObjParentList,relationshipName.substringAfterLast(DOT));
				}else{ // single relationship
					// link child sObject list to the main sObject list
					setChildParentRelationship(mainSObjectList,sObjParentList,relationshipName);
				}
			}
			// insert main sObject list
			insertList('',validateList('',mainSObjectList));
		}

		/**
		* @description set child parent relationship
		* @param sObjChildList : list of child sObjects
		* @param sObjParentList : list of parent sObjects
		* @param relationshipName : relationship name that links the child to the parent
		*/
		@testVisible
		private void setChildParentRelationship(List<SObject> sObjChildList, List<SObject> sObjParentList, String relationshipName){
			if(sObjChildList == null || sObjParentList == null) return;
			if(sObjChildList.size() != sObjParentList.size()) return;
			Integer index = 0;
			for(SObject sObjChild: sObjChildList){
				// set field related to the relationship name (on the child sObject), with the Id of the parent sObject
				sObjChild.put(relationshipToFieldName(relationshipName),sObjParentList.get(index).get('Id'));
				index++;
			}
		}

		/**
		* @description add relationship name to a list, ordered by the number of dots
		* @param dotRelationshipName : relationship name with dot notation (example contact.account)
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
		* @param dotRelationshipName : relationship name with dot notation (example contact.account)
		* @param sObjList : list of sObjects
		*/
		@testVisible
		private void insertList(String dotRelationshipName, List<SObject> sObjList){
			try{
				insert sObjList;
			}catch(Exception e){
				throw new TestDataFactoryException(formatErrorMessage(ERR_INSERT_SOBJECT,new List<String>{sObjectName+dotRelationshipName},e.getMessage()));
			}
		}

		/**
		* @description validate a list of sObjects before insert
		*							 handle required fields for accounts in case person account is enabled
		*							 handle required fields for asset by default AccountId or ContactId should be provided
		* @param relationshipName : relationship name
		* @param sObjList : sObject list
		* @return list of sObject instances
		*/
		@testVisible
		private List<sObject> validateList(String relationshipName, List<SObject> sObjList){
			Integer recordIndex = 0;
			for(SObject sObj : sObjList){
				if(sObj.getSObjectType() == Account.SObjectType){
					if(PERSON_ACCOUNT_IS_ENABLED){
						Id recordTypeId = (Id)sObj.get('RecordTypeId');
						// the Account record type id is required if the org has person account enabled
						if(recordTypeId == null) throw new TestDataFactoryException(formatErrorMessage(ERR_RECORDTYPE_REQUIRED_FOR_ACCOUNT,new List<String>{},''));
						Boolean nameIsSet = (sObj.get('Name') != null);
						Boolean lastnameIsSet = (sObj.get('Lastname') != null);
						Schema.DescribeSObjectResult accountDesc = Account.SObjectType.getDescribe();
						if(personAccountRecordTypes.contains(recordTypeId)) { // Person Account
							// name should not be set for a person account
							if(nameIsSet) throw new TestDataFactoryException(formatErrorMessage(ERR_NAME_ON_PERSONACCOUNT,new List<String>{},''));
							if(!lastnameIsSet) // apply default value if lastname is not set
								sObj.put('Lastname',dvProvider.getTextDefaultValue(accountDesc,getFieldsMap(Account.SObjectType).get('Lastname').getDescribe(),recordIndex));
							if(relationshipName.substringBeforeLast(DOT) == 'contact'){ // a contact should not point to a person account
								throw new TestDataFactoryException(formatErrorMessage(ERR_CONTACT_TO_PERSONACCOUNT,new List<String>{},''));
							}
						}else{ // Business Account
							if(!nameIsSet) // apply defaut value if name is not set
								sObj.put('Name',dvProvider.getTextDefaultValue(accountDesc,Account.fields.Name.getDescribe(),recordIndex));
						}
					}
				}else if(sObj.getSObjectType() == Asset.SObjectType){ // Asset
					if(sObj.get('AccountId') == null && sObj.get('ContactId') == null){
						throw new TestDataFactoryException(formatErrorMessage(ERR_REQUIRED_FOR_ASSET,new List<String>{},''));
					}
				}
				recordIndex++;
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
	  * @return sObjectManager instance
		*/
		public ISObjectManager getSObjectManager(){
			return sObjMgr;
		}

		/**
		* @description Generate an sObject instance
		* @param mapOfValuesOverride : map of values
		* @param doInsert : doInsert flag
		* @return sObject instance
		*/
		public SObject getSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert){
			return getListSObjectInstance(mapOfValuesOverride,doInsert,1).get(0);
		}

		/**
		* @description Generate a list of sObject instances
		* @param mapOfValuesOverride : map of values
		* @param doInsert : doInsert flag
		* @param numberOfSObjects : number of sObjects
		* @return list of sObject instances
		*/
		public List<SObject> getListSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects){
			Map<String,IFieldDefaultValue> mapOfValues = dvProvider.getDefaultMap(sObjectType,mapOfValuesOverride);

			for(Integer i = 0; i < numberOfSObjects; i++) {
				initSObjectInstance(mapOfValues,i); // init sObject instance
			}

			if(doInsert) sObjMgr.insertAll(); // insert all if doInsert = true

			return sObjMgr.getMainSObjectList();
		}

		/**
		* @description Initiate an sObject
		* @param mapOfValues : map of values
		* @param recordIndex : recordIndex
		*/
		private void initSObjectInstance(Map<String,IFieldDefaultValue> mapOfValues, Integer recordIndex){
			String sObjectName = sObjectType.getDescribe().getName();
			sObjMgr.setSObject(recordIndex,sObjectType.newSObject()); 

			for(String fullyQualifiedFieldName : mapOfValues.keySet()){

				String fieldName = (DOT+fullyQualifiedFieldName).substringAfterLast(DOT);
				if(fullyQualifiedFieldName.contains(DOT)){ // field name in a related sObject

					String firstRelationshipName = fullyQualifiedFieldName.substringBefore(DOT);
					String fullyQualifiedRelationshipName = fullyQualifiedFieldName.substringBeforeLast(DOT);
					SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipName,recordIndex);
					putField(relatedSObj,fieldName,mapOfValues.get(fullyQualifiedFieldName).getValue(recordIndex),sObjectName+DOT+fullyQualifiedRelationshipName);
					putSObject(sObjMgr.getSObject(recordIndex),firstRelationshipName,sObjMgr.getRelationship(recordIndex,firstRelationshipName),sObjectName);

				}else { // field name
					putField(sObjMgr.getSObject(recordIndex),fieldName,mapOfValues.get(fieldName).getValue(recordIndex),sObjectName);
				}

			}
		}

		/**
		* @description Initiate all the related sObjects for a given fully qualified relationship name
		* @param sObjectType : sObject Type
		* @param fullyQualifiedRelationshipName : fully qualified relationship name
		* @param index : index 
		* @return sObject instance
		*/
		@testVisible
		private SObject getRelationshipInstance(Schema.SObjectType sObjectType,String fullyQualifiedRelationshipName, Integer index){
			SObject sObj = sObjMgr.getRelationship(index,fullyQualifiedRelationshipName);
			if(sObj != null) return sObj;
			String sObjectName = sObjectType.getDescribe().getName();
			String leafRelationshipName = (DOT+fullyQualifiedRelationshipName).substringAfterLast(DOT);

			if(fullyQualifiedRelationshipName.contains(DOT)){ // multiple relationships
				String fullyQualifiedRelationshipNameBefore = fullyQualifiedRelationshipName.substringBeforeLast(DOT);
				SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipNameBefore,index); // <= recursion
				sObj = getRelatedSObjectInstance(relatedSObj.getSObjectType(),leafRelationshipName,sObjectName+DOT+fullyQualifiedRelationshipNameBefore); 
				relatedSObj = putSObject(relatedSObj,leafRelationshipName,sObj,sObjectName+DOT+fullyQualifiedRelationshipNameBefore);
			}else { // single relationship
				sObj = getRelatedSObjectInstance(sObjectType,leafRelationshipName,sObjectName); 
			}

			sObjMgr.setRelationship(index,fullyQualifiedRelationshipName,sObj);
			return sObj;
		}

		/**
		* @description get related sObject instance
		* @param sObjectType : sObjectType
		* @param relationshipName : relationship name
		* @param prefix : prefix (example : Contact.Account)
		* @return sObject instance
		*/
		@testVisible
		private SObject getRelatedSObjectInstance(Schema.SObjectType sObjectType, String relationshipName, String prefix){
			Map<String, Schema.SObjectField> fieldsMap = getFieldsMap(sObjectType);
			Schema.DescribeFieldResult fieldDesc;
			try{
				fieldDesc = fieldsMap.get(relationshipToFieldName(relationshipName)).getDescribe(); // get related field describe
			}catch(Exception e){
				throw new TestDataFactoryException(formatErrorMessage(ERR_RELATIONSHIP_NOT_EXIST,new List<String>{relationshipName,prefix},e.getMessage()));
			}
			return  fieldDesc.getReferenceTo().get(0).newSObject(); 
		}

		/**
		* @description put a related sObject in an sObject
		* @param sObj : sObject instance
		* @param sObjectName : sObject name
		* @param value : value
		* @param prefix : prefix (example : Contact.Account)
		* @return sObject instance
		*/
		@testVisible
		private SObject putSObject(SObject sObj, String sObjectName, sObject value, String prefix){
			try{
				sObj.putSObject(sObjectName,value);
			}catch(Exception e){
				throw new TestDataFactoryException(formatErrorMessage(ERR_RELATIONSHIP_NOT_EXIST,new List<String>{sObjectName,prefix},e.getMessage()));
			}
			return sObj;
		}		

		/**
		* @description put a field value in an sObject
		* @param sObj : sObject instance
		* @param fieldName : field name
		* @param value : value
		* @param prefix : prefix (example : Contact.Account)
		* @return sObject instance
		*/
		@testVisible
		private SObject putField(SObject sObj, String fieldName, Object value, String prefix){
			try{
				sObj.put(fieldName,value);
			}catch(Exception e){
				throw new TestDataFactoryException(formatErrorMessage(ERR_FIELD_NOT_EXIST,new List<String>{fieldName,prefix},e.getMessage()));
			}
			return sObj;
		}

		/**
		* @description validate sObjectType
		* @param sObjectType : sObject type
		*/
		@testVisible
		private void validateSObjectType(Schema.SObjectType sObjectType){
			if(sObjectType == null) 
				throw new TestDataFactoryException(formatErrorMessage(ERR_NOT_FOUND_SOBJECT,new List<String>{},''));
		}

	}

	/**
	* @description interface IDefaultValueProvider
	*/
	public interface IDefaultValueProvider{
		Map<String,IFieldDefaultValue> getDefaultMap(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride);
	}

	/**
	* @description virtual class DefaultValueProvider : manage the creation of the defaultMap and getting field default values
	*/
	public virtual class DefaultValueProvider implements IDefaultValueProvider{

		/**
		* @description get the default map of values
		*							 the map of values will contain 
		*								* all the fields with override values provided  
		* 							* all the required fields of the main sObject and related required sObject
		* @param sObjectType : sObject Type
		* @param mapOfValuesOverride : mapOfValuesOverride
		* @return map of values
		*/
		public Map<String,IFieldDefaultValue> getDefaultMap(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride){
			Map<String,IFieldDefaultValue> mapOfValues = new Map<String,IFieldDefaultValue>(convertMapValueTypes(mapOfValuesOverride));
			generateDefaultMap(sObjectType,mapOfValues,'');
			return mapOfValues;
		}

		/**
		* @description generate the default map values
		* 						 this method : 
		*								* detects required fields of an sObject and adds the fields with default values to the map of values 
		*								* detects the DEFAULT_VALUE and replace it with an instance of FieldDefaultValue class
		*								* detects required related sObjects or related sObject mentioned in the given map of values 
		* @param sObjectType : sObject Type
		* @param mapOfValues : mapOfValuesOverride
		* @param prefix : prefix (example : Contact.Account.)
		*/
		@testVisible
		private void generateDefaultMap(Schema.SObjectType sObjectType, Map<String,IFieldDefaultValue> mapOfValues, String prefix){
			Schema.DescribeSObjectResult sObjectDesc = sObjectType.getDescribe();
			Map<String, Schema.SObjectField> fieldsMap = getFieldsMap(sObjectType); // get the fields map
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
								putRelationship(mapOfValues,fieldDesc,prefix); // <= recursion  generateDefaultMap is called in putRelationship
								mapOfValues.remove(fullyQualifiedFieldName);
							} 
					}
				}else { // no override value provided for the field
					Boolean isDefaultValueRequired = isDefaultValueRequired(fieldDesc);
					if(fieldDesc.getRelationshipName() == null){ // field
						if(isDefaultValueRequired)
							mapOfValues.put(fullyQualifiedFieldName,new FieldDefaultValue(sObjectDesc,fieldDesc));
					}else { // relationship
						String relationshipName = fieldDesc.getRelationshipName().toLowerCase();
						if(isDefaultValueRequired || relationshipKeySet.contains(relationshipName)){ // relationship required or mentioned in the mapOfValues
							putRelationship(mapOfValues,fieldDesc,prefix); // <= recursion  generateDefaultMap is called in putRelationship
						}
					}
				}
			}
		}

		/**
		* @description put a relationship to the mapOfValues
		*							 this method :
		*								* adds the id field to the map of value with a null default value 
		*									in order to force the instantiation of that sObject (in case there no required fields and no field is mentioned in the map of value for it)
		*								* get the related sObjec type and call the generateDefaultMap on it
		* @param mapOfValues : map of values
		* @param fieldDesc : field describe
		* @param prefix : prefix (example : Contact.Account.)
		*/
		@testVisible
		private void putRelationship(Map<String,IFieldDefaultValue> mapOfValues, Schema.DescribeFieldResult fieldDesc, String prefix){
			String relationshipName = fieldDesc.getRelationshipName().toLowerCase();
			String fullyQualifiedRelationshipName = prefix+relationshipName;
			// at least add (fullyQualifiedRelationshipName.id,null) to force the instantiation of the related sObject
			// in case the sObject has no required fields
			mapOfValues.put(fullyQualifiedRelationshipName+DOT+'id',new FieldDefaultValue(null));
			// get the related sObject instance
			SObjectType refSObjectType = fieldDesc.getReferenceTo().get(0);
			// generate a map for the related sObject
			generateDefaultMap(refSObjectType,mapOfValues,fullyQualifiedRelationshipName+DOT);
		}

		/**
		* @description get relationship names keyset that starts with a given prefix
		* 						 this method extract all the relationship names persent in the keySetOverride just after the prefix
		* @param keySetOverride : keySet of fully qualified field names
		* @param prefix : prefix (example : Contact.Account.)
		* @return set of relationship names
		*/
		@testVisible
		private Set<String> getRelationshipKeySet(Set<String> keySetOverride, String prefix){
			if(keySetOverride == null || prefix == null) return null;
			Set<String> relationshipKeySet = new Set<String>();
			String prefixLowerCase = prefix.toLowerCase();
			// loop through the keySet
			for(String fullyQualifiedFieldName : keySetOverride){
				fullyQualifiedFieldName = fullyQualifiedFieldName.toLowerCase();
				if(fullyQualifiedFieldName.startsWith(prefixLowerCase)){ // starts with the prefix
					String fullyQualifiedFieldNameAfterPrefix = fullyQualifiedFieldName.substringAfter(prefixLowerCase)+'';
					if(fullyQualifiedFieldNameAfterPrefix.contains(DOT)) // if there is a relationship after the prefix
						// add the relationship name after the prefix
						relationshipKeySet.add(fullyQualifiedFieldName.substringBetween(prefixLowerCase,DOT));
				}
			}
			return relationshipKeySet;
		}

		/**
		* @description Converting a map from Map<String,Object> to Map<String,IFieldDefaultValue>
		* @param mapOfValues : map of values
		* @return converted map
		*/
		@testVisible
		private Map<String,IFieldDefaultValue> convertMapValueTypes(Map<String,Object> mapOfValues){
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
		* @param fieldDesc : field describe
		* @return true if is default value required
		*/
		@testVisible
		private Boolean isDefaultValueRequired(Schema.DescribeFieldResult fieldDesc){
			return 
				!fieldDesc.isDefaultedOnCreate() // does not have a defaut value on creation
				&& !fieldDesc.isAutoNumber() // is not an auto number
				&& !fieldDesc.isNillable() // is required
				&& fieldDesc.isCreateable(); // value can be set on creation 
		}

		/**
		* @description get the default for a specific field
		* @param fieldDesc : field describe
		* @param recordIndex : recordIndex
		* @return the generated field default value
		*/
		@testVisible
		private Object getDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			if(fieldDesc != null){
				// DisplayType Enum -> https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_enum_Schema_DisplayType.htm
				if(fieldDesc.getType() == Schema.DisplayType.Base64){
					return getBase64DefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Boolean){
					return getCheckboxDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Currency){
					return getCurrencyDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Date){
					return getDateDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Datetime){
					return getDateTimeDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Email){
					return getEmailDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Location){
					return getGeolocationDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Integer || fieldDesc.getType() == Schema.DisplayType.Double){
					return getNumberDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Percent){
					return getPercentDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Phone){
					return getPhoneDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Picklist){
					return getPicklistDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.MultiPicklist){
					return getMultiPicklistDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.String){
					return getTextDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.TextArea){
					return getTextAreaDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.Time){
					return getTimeDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				} else if(fieldDesc.getType() == Schema.DisplayType.URL){
					return getURLDefaultValue(sObjectDesc,fieldDesc,recordIndex);
				}
			}
			return null;
		}

		/**
		* @description get the default value for a picklist
		* @param fieldDesc : field description
		* @return picklist default value
		*/
		@testVisible
		private String getDefaultPicklistValue(Schema.DescribeFieldResult fieldDesc){
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

		// ==========================================================================
		// Virtual methods 
		// ==========================================================================
		/**
		* @description get the default value for Base64 field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Blob getBase64DefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return Blob.valueOf(recordIndex.format());
		}	
		/**
		* @description get the default value for checkbox field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Boolean getCheckboxDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return true;
		}
		/**
		* @description get the default value for Currency field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getCurrencyDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return recordIndex.format();
		}
		/**
		* @description get the default value for Date field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Date getDateDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return Date.today();
		}
		/**
		* @description get the default value for Datetime field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Datetime getDateTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return Datetime.now();
		}
		/**
		* @description get the default value for Email field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return 'test'+recordIndex.format()+'@email.com';
		}
		/**
		* @description get the default value for Geolocation field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Location getGeolocationDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return Location.newInstance(0,0);
		}		
		/**
		* @description get the default value for Number field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Decimal getNumberDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return recordIndex;
		}
		/**
		* @description get the default value for Percent field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Decimal getPercentDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return recordIndex;
		}
		/**
		* @description get the default value for Phone field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getPhoneDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return '01 23 45 67 89';
		}
		/**
		* @description get the default value for Picklist field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return getDefaultPicklistValue(fieldDesc);
		}
		/**
		* @description get the default value for Multipicklist field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getMultiPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return getDefaultPicklistValue(fieldDesc);
		}
		/**
		* @description get the default value for Text field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getTextDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return 'test'+recordIndex.format();
		}
		/**
		* @description get the default value for TextArea field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getTextAreaDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return 'test'+recordIndex.format();
		}
		/**
		* @description get the default value for Time field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual Time getTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return Time.newInstance(12, 0, 0, 0);
		}
		/**
		* @description get the default value for URL field type
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		* @param recordIndex : record index
		* @return default value
		*/
		public virtual String getURLDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
			return 'http://test' + recordIndex + '.com';
		}
	}

	/**
	* @description interface IFieldDefaultValue
	*/
	public interface IFieldDefaultValue{
		Object getValue(Integer recordIndex);
	}

	/**
	* @description class AutoFieldDefaultValue : wrapper for auto default value that will be auto generated 
	*/
	@testVisible
	private class AutoFieldDefaultValue implements IFieldDefaultValue{
		/**
		* @description get encapsulated value
		* @param recordIndex : recordIndex
		* @return field default value
		*/
		public Object getValue(Integer recordIndex){
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

		/**
		* @description construtor
		* @param value : value
		*/
		public FieldDefaultValue(Object value){
			this.value = value;
		}	

		/**
		* @description construtor
		* @param sObjectDesc : sObject describe
		* @param fieldDesc : field describe
		*/	
		public FieldDefaultValue(Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc){
			this.sObjectDesc = sObjectDesc;
			this.fieldDesc = fieldDesc;
		}

		/**
		* @description get encapsulated value
		* @param recordIndex : recordIndex
		* @return field default value
		*/
		public Object getValue(Integer recordIndex){
			if(value != null){
				if(value instanceof String)
					return mergeValue((String)value,'Index',recordIndex.format());
				else return value;
			} 
			return dvProvider.getDefaultValue(sObjectDesc,fieldDesc,recordIndex);
		}
	}

	/* ===========================  Utility methods  =========================== */

	/**
	 * @description get the fields map of an sObject type with caching
	 * @param sObjectType : sObject type
	 * @return fields map
	 */
	@testVisible 
	private static Map<String, Schema.SObjectField> getFieldsMap(Schema.SObjectType sObjectType){
		if(mapOfFieldsMap.containsKey(sObjectType)){
			return mapOfFieldsMap.get(sObjectType);
		}else {
			Map<String, Schema.SObjectField> fieldsMap = sObjectType.getDescribe().fields.getMap();
			mapOfFieldsMap.put(sObjectType,fieldsMap);
			return fieldsMap;
		}
	}

	/**
	* @description get field name from a relationship name
	* @param relationshipName : relationship name
	* @return field name 
	*/
	private static String relationshipToFieldName(String relationshipName){
		String relationshipNameLowerCase = relationshipName.toLowerCase();
		if(relationshipNameLowerCase.contains('__r')) // custom relationship 
			return relationshipNameLowerCase.replace('__r', '__c');
		return relationshipNameLowerCase+'id'; // standard relationship
	}

	/**
	* @description merge value in a string
	* @param text : text with a merge value
	* @param name : name of the merge value
	* @param value : value to be merged
	* @return text with merged value
	*/
	private static String mergeValue(String text, String name, String value){
		if(text == null) return null;
		String pattern = '(?i)\\{!'+name+'\\}';
		return text.replaceAll(pattern,value);
	}

	/**
	* @description format an error message
	* @param message : message
	* @param mergeValues : merge values
	* @param originalMessage : original message
	* @return error message
	*/
	private static String formatErrorMessage(String message, List<String> mergeValues, String originalMessage){
		String errorMessage = String.format(message,mergeValues);
		if(!String.isBlank(originalMessage)) errorMessage +='\n'+'Original error message : '+originalMessage;
		return errorMessage;
	}

	/**
	* @description Exceptions
	*/
	public class TestDataFactoryException extends Exception {}

}
