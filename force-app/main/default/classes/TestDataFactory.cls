
 //  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 //  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 //  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 //  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 //  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 //  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 //  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 //  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 /**
 * @description Apex Test Data Factory 
 * @author benahm
 * @since 2017
 * @group Apex Test Data Factory
 */
@IsTest
public class TestDataFactory {

    /** Default value provider instance */
    private static DefaultValueProvider dvPrvdr = new DefaultValueProvider();
    
    /** Default value generator, used to auto-generate default values for non required fields  */
    public static final IFieldDefaultValue DEFAULT_VALUE = new AutoFieldDefaultValue();

    /** Constant that contains a dot '.' */
    private static final String DOT = '.';

    /** Map of sObject types with their corresponding map of field Tokens  */
    @TestVisible
    private static Map<Schema.SObjectType,Map<String, Schema.SObjectField>> mapOfFieldTokensMap = new Map<Schema.SObjectType,Map<String, Schema.SObjectField>>();

    /* ===========================  Properties =========================== */
    /** Default Value Provider property, used to override the default value provider instance  **/
    public static DefaultValueProvider defaultValueProvider {
        get { return dvPrvdr; }
        set {
            if(value != null){
                dvPrvdr = value;
            }
        }
    }

    /** Determine if person account is enabled in current org **/
    @TestVisible
    private static Boolean isPersonAccountEnabled{
        get{
            return Schema.SObjectType.Account.fields.getMap().containsKey( 'isPersonAccount' );
        }
    }

    /* ===========================  Public methods =========================== */
    /**
     * @description create an sObject
     * @param sObjectName (String): name of the sObject to be created
     * @return sObject instance
     * @example 
     * Account acc = (Account)TestDataFactory.createSObject('Account');
     */
    public static SObject createSObject(String sObjectName){
        return createSObject(sObjectName,new Map<String,Object>(),true);
    }

    /**
     * @description create an sObject
     * @param sObjectName (String): name of the sObject to be created
     * @param Boolean (Boolean): if true the sObject instance is inserted to the Salesforce database
     * @return sObject instance
     * @example 
     * Account acc = (Account)TestDataFactory.createSObject('Account',false);
     */
    public static SObject createSObject(String sObjectName, Boolean doInsert){
        return createSObject(sObjectName,new Map<String,Object>(),doInsert);
    }

    /**
     * @description create an sObject with a map to override field values
     * @param sObjectName (String): name of the sObject to be created
     * @param mapOfValuesOverride (Map<String,Object>): map of values
     * @return sObject instance
     * @example 
     * Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object>{
     *  'Description' => 'Test'
     * });
     */
    public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride){
        return createSObject(sObjectName,mapOfValuesOverride,true);
    }

    /**
     * @description create an sObject with a map to override field values
     * @param sObjectName (String): name of the sObject to be created
     * @param mapOfValuesOverride (Map<String,Object>): map of values
     * @param doInsert (Boolean): if true the sObject instance is inserted to the Salesforce database
     * @return sObject instance
     * @example 
     * Account acc = (Account)TestDataFactory.createSObject('Account',new Map<String,Object>{
     *  'Description' => 'Test'
     * },false);
     */
    public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride, Boolean doInsert){
        return createSObjectList(sObjectName,mapOfValuesOverride,1,doInsert).get(0);
    }

    /**
     * @description create a list of sObjects
     * @param sObjectName (String): name of the sObject to be created
     * @param numberOfSObjects (Integer): number of sObjects to be created
     * @return list of sObject instances
     * @example 
     * List<Account> accList = TestDataFactory.createSObjectList('Account',10);
     */
    public static List<SObject> createSObjectList(String sObjectName, Integer numberOfSObjects){
        return createSObjectList(sObjectName,new Map<String,Object>(),numberOfSObjects,true);
    }
    
    /**
     * @description create a list of sObjects
     * @param sObjectName (String): name of the sObject to be created
     * @param numberOfSObjects (Integer): number of sObjects to be created
     * @param doInsert (Boolean): if true the sObject list instances is inserted to the Salesforce database
     * @return list of sObject instances
     * @example 
     * List<Account> accList = TestDataFactory.createSObjectList('Account',10,false);
     */
    public static List<SObject> createSObjectList(String sObjectName, Integer numberOfSObjects, Boolean doInsert){
        return createSObjectList(sObjectName,new Map<String,Object>(),numberOfSObjects, doInsert);
    }

    /**
     * @description create a list of sObjects with a map to override field values
     * @param sObjectName (String): name of the sObject to be created
     * @param mapOfValuesOverride (Map<String,Object>): map of values
     * @param numberOfSObjects (Integer): number of sObjects to be created
     * @return list of sObject instances
     * @example 
     * List<Account> accList = TestDataFactory.createSObjectList('Account',new Map<String,Object>{
     *  'Description' => 'Test'
     * },10);
     */
    public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Integer numberOfSObjects){
        return createSObjectList(sObjectName,mapOfValuesOverride,numberOfSObjects,true);
    }

    /**
     * @description create a list of sObjects with a map to override field values
     * @param sObjectName (String): name of the sObject to be created
     * @param mapOfValuesOverride (Map<String,Object>): map of values
     * @param numberOfSObjects (Integer): number of sObjects to be created
     * @param doInsert (Boolean): if true the sObject list instances is inserted to the Salesforce database
     * @return list of sObject instances
     * @example 
     * List<Account> accList = TestDataFactory.createSObjectList('Account',new Map<String,Object>{
     *  'Description' => 'Test'
     * },10,false);
     */
    public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Integer numberOfSObjects, Boolean doInsert){
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName); 
        SObjectFactory sObjFactory = new SObjectFactory(sObjectType);
        List<SObject> listSObjectInstance = sObjFactory.getListSObjectInstance(mapOfValuesOverride, doInsert, numberOfSObjects);
        return listSObjectInstance;
    }


    /* ======================================================================================================== */
    /* =======================================  inner classes & interfaces ==================================== */
    /* ======================================================================================================== */
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
    public class SObjectManager implements ISObjectManager{
        
        /** Main sObject name */
        private String sObjectName = null; 
        /** List of main sObject instances */
        @TestVisible
        private List<SObject> mainSObjectList = new List<SObject>();
        /** Map of relationship names with their related list of sObject instances */
        @TestVisible
        private Map<String,List<SObject>> relatedSObjMapList = new Map<String,List<SObject>>();
        /** List of ordered relationship names by dot notation */
        @TestVisible
        private List<String> orderedRelationshipList = new List<String>();

        /* ===========================  Error Messages =========================== */
        /** Unable to insert "{0}" records: {1} */
        private final String ERR_INSERT_SOBJECT = 'Unable to insert "{0}" records: \n{1}';


        /**
        * @description constructor
        * @return sObjectName (String): main sObject name
        */
        public SObjectManager(String sObjectName){
            this.sObjectName = sObjectName;
        }

        /**
        * @description get the list of all main sObject instances
        * @return list of sObject instances
        */
        public List<SObject> getMainSObjectList(){
            return mainSObjectList;
        }

        /**
        * @description set or add an sObject to the main sObject list for a given index
        * @param index (Integer): index for which the sObject instance will be added or set
        * @param sObj (SObject): sObject instance to add or set to the main sObject list
        */
        public void setSObject(Integer index, SObject sObj){
            if(index == mainSObjectList.size()){
                mainSObjectList.add(sObj);
            }else{
                mainSObjectList.set(index,sObj);
            } 
        }

        /**
        * @description get an sObject from the main sObject list for a given index
        * @param index (Integer): index for which the sObject instance will be returned
        * @return the returnd sObject instance
        */
        public SObject getSObject(Integer index){
            return mainSObjectList.get(index);
        }

        /**
        * @description set or add a related sObject into the related sObject map list for a given index and relationship name
        * @param index (Integer): index for which the sObject instance will be added or set
        * @param fullyQualifiedRelationshipName (String): fully qualified relationship name for which the sObject instance will be added or set
        * @param sObj (SObject): sObject instance to add or set to the related sObject map list
        */
        public void setRelationship(Integer index, String fullyQualifiedRelationshipName, SObject sObj){
            String fullyQualifiedRelationshipNameLowerCase = fullyQualifiedRelationshipName.toLowerCase();
            // get related sObject list for the fully qualified relationship name
            List<SObject> relatedSObjList = relatedSObjMapList.get(fullyQualifiedRelationshipNameLowerCase);
            if(relatedSObjList == null){ 
                // instantiate the list if null
                relatedSObjList = new List<SObject>();
                // put the list into the related sObject map list 
                relatedSObjMapList.put(fullyQualifiedRelationshipNameLowerCase,relatedSObjList);
                // add the fully qualified relationship name to the list of ordered relationship names
                addRelationshipName(fullyQualifiedRelationshipNameLowerCase);
            } 

            if(index == relatedSObjList.size()){
                relatedSObjList.add(sObj);
            }
            else{
                relatedSObjList.set(index,sObj);
            } 
        }

        /**
        * @description get a related sObject from the related sObject map list for a given index and relationship name
        * @param index (Integer): index for which the sObject instance will be returned
        * @param fullyQualifiedRelationshipName (String): fully qualified relationship name for which the sObject instance will be returned
        * @return the returnd sObject instance
        */
        public SObject getRelationship(Integer index, String fullyQualifiedRelationshipName){
            try{
                List<SObject> relatedSObjList = relatedSObjMapList.get(fullyQualifiedRelationshipName.toLowerCase());
                return relatedSObjList.get(index);
            }catch(Exception e){
                return null;
            }
        }

        /**
        * @description insert all the sObjects stored in the sObject Manager into the Salesforce database  
        */
        public void insertAll(){
            // loop through the ordered relationship list
            for(Integer i = 0; i < orderedRelationshipList.size(); i++){
                String fullyQualifiedRelationshipName = orderedRelationshipList.get(i);
                List<SObject> sObjParentList = relatedSObjMapList.get(fullyQualifiedRelationshipName);

                // insert parent sObject list
                insertList(sObjParentList,DOT+fullyQualifiedRelationshipName);
                
                // last relationship name in the dot notation
                String leafRelationshipName = (DOT+fullyQualifiedRelationshipName).substringAfterLast(DOT); 

                if(!fullyQualifiedRelationshipName.contains(DOT)){ // single relationship 
                    // link child sObject list to the main sObject list
                    setChildParentRelationship(mainSObjectList,sObjParentList,fullyQualifiedRelationshipName);

                }else{ // multiple relationships

                    // fully qualified relationship name without the leaf relationship
                    String fullyQualifiedRelationshipNameWithoutLeaf = fullyQualifiedRelationshipName.substringBeforeLast(DOT);
                    // get the list of sObject of the fully qualified relationship name without the leaf relationship name
                    List<SObject> sObjChildList = relatedSObjMapList.get(fullyQualifiedRelationshipNameWithoutLeaf);
                    // link child sObject list to the parent sObject list
                    setChildParentRelationship(sObjChildList,sObjParentList,leafRelationshipName);
                }
            }

            // insert main sObject list
            insertList(mainSObjectList,'');
        }

        /* ============================================================================================= */
        /* =======================================  private methods ==================================== */
        /* ============================================================================================= */

        /**
        * @description link a list of child sObject instances to a list of parent sObject instances for a given relationship name
        * @param sObjChildList (List<SObject>): list of child sObject instances
        * @param sObjParentList (List<SObject>): list of parent sObject instances
        * @param relationshipName (String): relationship name that links the child sObject to the parent sObject
        */
        @TestVisible
        private void setChildParentRelationship(List<SObject> sObjChildList, List<SObject> sObjParentList, String relationshipName){
            Integer index = 0;
            for(SObject sObjChild: sObjChildList){
                // get the field name that links the child sObject to the parent sObject
                String relationshipFieldName = getFieldNameFromRelationshipName(relationshipName); 
                // set field related to the relationship name (on the child sObject), with the Id of the parent sObject
                sObjChild.put(relationshipFieldName,sObjParentList.get(index).get('Id'));
                index++;
            }
        }

        /**
        * @description add relationship name to the ordered relationship list, ordered by the number of dots
        * @param fullyQualifiedRelationshipName (String): fully qualified relationship name (example contact.account)
        */
        @testVisible
        private void addRelationshipName(String fullyQualifiedRelationshipName){
            Integer i=0;
            for (String rName : orderedRelationshipList) {
                if(fullyQualifiedRelationshipName == rName) return; // already exists
                if(rName.countMatches('.') < fullyQualifiedRelationshipName.countMatches('.')){
                    // insert depending of the number of dots
                    orderedRelationshipList.add(i, fullyQualifiedRelationshipName);
                    return;
                }
                i++;
            }
            // insert at the end
            orderedRelationshipList.add(fullyQualifiedRelationshipName);
        }

        /**
        * @description execute a DML insert operation on a list of sObjects
        * @param sObjList (List<SObject>): list of sObjects to be inserted
        * @param errorMessageMergeValue (String): merge value provided only for error message generation (example : .contact.account)
        */
        @testVisible
        private void insertList(List<SObject> sObjList, String errorMessageMergeValue){
            Database.SaveResult[] saveResults = Database.insert(sObjList, false);
            Integer i = 0;
            List<String> listErrors = new List<String>();
            // Iterate through the save results
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()){
                    // Iterate through the errors                
                    for(Database.Error error : saveResult.getErrors()) {
                        Set<String> fieldNames = new Set<String>{'Name','RecordTypeId'};
                        fieldNames.addAll(error.getFields());
                        String listFieldValues = '';     
                        for(String fieldName : fieldNames){
                            Object fieldValue;
                            try {
                                fieldValue = sObjList.get(i).get(fieldName);
                            }catch(Exception e){ /*  ignore errors */}
                            if(fieldValue != null){
                                listFieldValues += fieldName + '='+ fieldValue +', ';
                            }
                        }              
                        listFieldValues = listFieldValues.removeEnd(', ');
                        listErrors.add(error.getStatusCode() + ': ' + error.getMessage() + ' ' +'['+listFieldValues+']');
                    }
                    i++;
                }
            }
            if(!listErrors.isEmpty()){
                throw new TestDataFactoryException(formatErrorMessage(ERR_INSERT_SOBJECT,new List<String>{sObjectName+errorMessageMergeValue,String.join(listErrors,'\n')},''));
            }
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
    public class SObjectFactory implements ISObjectFactory{

        /** Main sObject type to instantiated */
        private Schema.SObjectType sObjectType = null;
        /** Main sObject Name to instantiated */
        private String sObjectName;
        /** Instance of SObject Manager to store all the created sObject instances */
        private SObjectManager sObjMgr;

        /* ===========================  Error Messages =========================== */
        /** Unable to find the sObject */
        private final String ERR_NOT_FOUND_SOBJECT = 'Unable to find the sObject';
        /** The field "{0}" does not exist on "{1}" or the value type provided is incorrect */
        private final String ERR_FIELD_NOT_EXIST = 'The field "{0}" does not exist on "{1}" or the value type provided is incorrect';
        /** The relationship "{0}" does not exist on "{1}" */
        private final String ERR_RELATIONSHIP_NOT_EXIST = 'The relationship "{0}" does not exist on "{1}"';
        /** Unable to get the value for the field "{0}" */
        private final String ERR_UNABLE_TO_GET_FIELD_VALUE = 'Unable to get the value for the field "{0}"';


        /**
        * @description construtor
        * @param sObjectType (Schema.SObjectType): main sObject type to be instantiated
        */
        public SObjectFactory(Schema.SObjectType sObjectType){
            if(sObjectType == null){
                throw new TestDataFactoryException(formatErrorMessage(ERR_NOT_FOUND_SOBJECT,new List<String>{},''));
            }
            this.sObjectType = sObjectType;
            this.sObjectName = sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).getName();
            this.sObjMgr = new SObjectManager(this.sObjectName);
        }

        /**
        * @description get the SObject Manager instance
        * @return sObject Manager instance
        */
        public SObjectManager getSObjectManager(){
            return sObjMgr;
        }

        /**
        * @description generate an sObject instance and apply the override map of values
        * @param mapOfValuesOverride (Map<String,Object>): map of values to override when instanciating the sObject
        * @param doInsert (Boolean): if true the sObject list instances is inserted to the Salesforce database
        * @return sObject instance
        */
        public SObject getSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert){
            return getListSObjectInstance(mapOfValuesOverride,doInsert,1).get(0);
        }

        /**
        * @description generate a list of sObject instances and apply the override map of values
        * @param mapOfValuesOverride (Map<String,Object>): map of values to override when instanciating the sObject
        * @param doInsert (Boolean): if true the sObject list instances is inserted to the Salesforce database
        * @param numberOfSObjects (Integer): number of sObjects to be instantiated
        * @return list of sObject instances
        */
        public List<SObject> getListSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects){
            // get the map of values formed from the union of the map of values override given by the user and the auto-generated map of values for the required fields
            Map<String,IFieldDefaultValue> mapOfValues = defaultValueProvider.getDefaultMapOfValues(sObjectType,mapOfValuesOverride);

            for(Integer i = 0; i < numberOfSObjects; i++) {
                initSObjectInstance(mapOfValues,i); // init sObject instance
            }

            if(doInsert){
                sObjMgr.insertAll(); // insert all if doInsert = true
            }

            return sObjMgr.getMainSObjectList();
        }

        /* ============================================================================================= */
        /* =======================================  private methods ==================================== */
        /* ============================================================================================= */

        /**
        * @description initiate the main sObject instance with all related sObject and apply the map of values
        * @param mapOfValues (Map<String,IFieldDefaultValue>): map of values with key as field name and value as the default value to be used when instantiating the sObject. 
        *           This map contains the default values provided as input by the user and the auto-generated default values for the required fields
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        */
        @TestVisible
        private void initSObjectInstance(Map<String,IFieldDefaultValue> mapOfValues, Integer recordIndex){
            // add the main sObject instance to the sObject Manager
            sObjMgr.setSObject(recordIndex,sObjectType.newSObject()); 

            for(String fullyQualifiedFieldName : mapOfValues.keySet()){ // loop through the map of values

                // get the field name from the fully qualified field name
                String fieldName = (DOT+fullyQualifiedFieldName).substringAfterLast(DOT);
                // get the field value from the map of values
                Object fieldValue = getFieldValueFromMapOfValues(mapOfValues,fullyQualifiedFieldName,recordIndex);
                
                if(!fullyQualifiedFieldName.contains(DOT)){ // field name
                    putField(sObjMgr.getSObject(recordIndex),fieldName,fieldValue,sObjectName);
                }else{ // relationship
                    // first relationship name in fully qualified relationship name
                    String firstRelationshipName = fullyQualifiedFieldName.substringBefore(DOT); 
                    // fully qualified relationship name without the field name 
                    String fullyQualifiedRelationshipName = fullyQualifiedFieldName.substringBeforeLast(DOT);  
                    // generate the related sObject instances for a given fullyQualifiedRelationshipName
                    SObject relatedSObj = getRelationshipInstance(fullyQualifiedRelationshipName,recordIndex); 
                    // apply the field value for the related sObject
                    putField(relatedSObj,fieldName,fieldValue,sObjectName+DOT+fullyQualifiedRelationshipName);
                    // link the related sObject to the main sObject
                    putSObject(sObjMgr.getSObject(recordIndex),firstRelationshipName,sObjMgr.getRelationship(recordIndex,firstRelationshipName),sObjectName);
                }
            }
        }

        /**
        * @description Recursive method that initiate all the related sObjects of a given fully qualified relationship name
        * @param fullyQualifiedRelationshipName (String): fully qualified relationship name (example : Case.Contact.Account)
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return main sObject instance with all related sObjects attached to it
        */
        @TestVisible
        private SObject getRelationshipInstance(String fullyQualifiedRelationshipName, Integer recordIndex){
            // get the sObject instance from the sObject Manager
            SObject sObj = sObjMgr.getRelationship(recordIndex,fullyQualifiedRelationshipName);
            // return the sObject instance if already exists in the sObject Manager
            if(sObj != null){
                return sObj; 
            } 

            // last relationship name in the dot notation
            String leafRelationshipName = (DOT+fullyQualifiedRelationshipName).substringAfterLast(DOT); 

            if(!fullyQualifiedRelationshipName.contains(DOT)){ // single relationship
                sObj = getRelatedSObjectInstance(sObjectType,leafRelationshipName,sObjectName); 
            }else{ // multiple relationships

                // fully qualified relationship name without the leaf relationship
                String fullyQualifiedRelationshipNameWithoutLeaf = fullyQualifiedRelationshipName.substringBeforeLast(DOT); 
                // generate the all the sObject instances for the fully qualified relationship name without the leaf relationship name
                SObject relatedSObj = getRelationshipInstance(fullyQualifiedRelationshipNameWithoutLeaf,recordIndex); // <= recursion
                // merge value for error message display
                String errorMessageMergeValue = sObjectName+DOT+fullyQualifiedRelationshipNameWithoutLeaf;
                // get sObject instance for the leaf relationship
                sObj = getRelatedSObjectInstance(relatedSObj.getSObjectType(),leafRelationshipName,errorMessageMergeValue); 
                // link the related instance of the leaf relationship to the related sObject of the fully qualified relationship name without the leaf relationship name
                putSObject(relatedSObj,leafRelationshipName,sObj,errorMessageMergeValue);
            } 

            // add the sObject instance to the sObject Manager
            sObjMgr.setRelationship(recordIndex,fullyQualifiedRelationshipName,sObj);
            return sObj;
        }

        /**
        * @description get related sObject instance of an sObject type for a given relationship name
        * @param sObjectType (Schema.SObjectType): sObject type to which the generate sObject is related
        * @param relationshipName (String): relationship name that links the sObject type and the sObject instance that will be generated
        * @param errorMessageMergeValue (String): merge value provided only for error message generation (example : Contact.Account)
        * @return the generated related sObject instance
        */
        @TestVisible
        private SObject getRelatedSObjectInstance(Schema.SObjectType sObjectType, String relationshipName, String errorMessageMergeValue){
            Map<String, Schema.SObjectField> fieldsMap = getFieldTokensMap(sObjectType);
            Schema.DescribeFieldResult fieldDesc;
            SObject sObj;
            try{
                // get the related field describe
                fieldDesc = fieldsMap.get(getFieldNameFromRelationshipName(relationshipName)).getDescribe(); 
                // get related sObject instance
                sObj = fieldDesc.getReferenceTo().get(0).newSObject();
            }catch(Exception e){
                throw new TestDataFactoryException(formatErrorMessage(ERR_RELATIONSHIP_NOT_EXIST,new List<String>{relationshipName,errorMessageMergeValue},e.getMessage()));
            }
            return  sObj;
        }

        /**
        * @description get the field value from the map of values for a given record index and fully qualified field name
        * @param mapOfValues (Map<String,IFieldDefaultValue>): map of values with key as field name and value as the default value to be used when instantiating the sObject. 
        * @param fullyQualifiedFieldName (String): fully qualified field name (example : Contact.Account.Name)
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return field value
        */
        @TestVisible
        private Object getFieldValueFromMapOfValues(Map<String,IFieldDefaultValue> mapOfValues, String fullyQualifiedFieldName, Integer recordIndex){
            Object fieldValue;
            try{
                // get the field value
                fieldValue = mapOfValues.get(fullyQualifiedFieldName).getValue(recordIndex); 
            }catch(Exception e){
                throw new TestDataFactoryException(formatErrorMessage(ERR_UNABLE_TO_GET_FIELD_VALUE,new List<String>{fullyQualifiedFieldName},e.getMessage()));
            }
            return fieldValue;
        }

        /**
        * @description attach an sObject into a related sObject
        * @param sObj (SObject): main sObject instance
        * @param relationshipName (String): sObject name of the related sObject
        * @param sObjectValue (SObject): related sObject instance to be attached to the main sObject instance
        * @param errorMessageMergeValue (String): merge value provided only for error message generation (example : Contact.Account)
        * @return main sObject instance
        */
        @TestVisible
        private SObject putSObject(SObject sObj, String relationshipName , SObject sObjectValue, String errorMessageMergeValue){
            try{
                sObj.putSObject(relationshipName,sObjectValue);
            }catch(Exception e){
                throw new TestDataFactoryException(formatErrorMessage(ERR_RELATIONSHIP_NOT_EXIST,new List<String>{relationshipName,errorMessageMergeValue},e.getMessage()));
            }
            return sObj;
        }       

        /**
        * @description set field value in given sObject instance
        * @param sObj (SObject): main sObject instance
        * @param fieldName (String): field name of the field to set
        * @param fieldValue (Object): value of the field to set
        * @param errorMessageMergeValue (String): merge value provided only for error message generation (example : Contact.Account)
        * @return main sObject instance
        */
        @TestVisible
        private SObject putField(SObject sObj, String fieldName, Object fieldValue, String errorMessageMergeValue){
            try{
                sObj.put(fieldName,fieldValue);
            }catch(Exception e){
                throw new TestDataFactoryException(formatErrorMessage(ERR_FIELD_NOT_EXIST,new List<String>{fieldName,errorMessageMergeValue},e.getMessage()));
            }
            return sObj;
        }

    }

    /**
    * @description interface IDefaultValueProvider
    */
    public interface IDefaultValueProvider{
        Map<String,IFieldDefaultValue> getDefaultMapOfValues(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride);
    }

    /**
    * @description virtual class DefaultValueProvider : manage the creation of the defaultMap and getting field default values
    */
    public virtual class DefaultValueProvider implements IDefaultValueProvider {

        /* ===========================  Error Messages =========================== */
        /** List values is not supported for field {0} */
        private final String ERR_LIST_VALUE_NOT_SUPPORTED = 'List values is not supported for field {0}';
        /** Bad record type Id provided for Account */
        private final String ERR_BAD_RECORDTYPE_ID_FOR_ACCOUNT = 'Bad record type Id provided for Account';

        /* ===========================  Properties =========================== */
        /** Person Account record type Ids */
        @TestVisible
        private Set<Id> personAccountRecordTypes{ 
            get{
                if(personAccountRecordTypes == null){
                    if(isPersonAccountEnabled){
                        String account = 'Account';
                        personAccountRecordTypes = new Map<Id,SObject>(Database.query('select Id from RecordType where SObjectType=:account and isPersonType=true')).keySet();
                    }else {
                        personAccountRecordTypes = new Set<Id>();
                    }
                }
                return personAccountRecordTypes;
            }
            set{}
        }

        /** Account default record type Id */
        @TestVisible
        private Id accountDefaultRecordTypeId {
            get{
                if(accountDefaultRecordTypeId == null){
                    Schema.DescribeSObjectResult dsr = Account.SObjectType.getDescribe(SObjectDescribeOptions.DEFERRED);
                    for(Schema.RecordTypeInfo rti : dsr.getRecordTypeInfos()) {
                        if(rti.isDefaultRecordTypeMapping()) {
                            return rti.getRecordTypeId();
                        }
                    }
                }
                return accountDefaultRecordTypeId;
            }
            set{}
        }

        /**
        * @description get the default map of values for a given sObjectType.
        *                        The default map of value contains fully qualified field name as a key and the field value wrapped in FieldDefaultValue instance
        * @param sObjectType (Schema.SObjectType): sObject Type for which the map of values will be generated
        * @param mapOfValuesOverride (Map<String,Object>): map of values that will override the the auto-generated map of values
        * @return map of values
        */
        public Map<String,IFieldDefaultValue> getDefaultMapOfValues(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride){
            Map<String,IFieldDefaultValue> mapOfValues = new Map<String,IFieldDefaultValue>(convertMapValueTypes('',mapOfValuesOverride));
            generateDefaultMapOfValues(sObjectType,mapOfValues,'');
            return mapOfValues;
        }

        /* ============================================================================================= */
        /* =======================================  private methods ==================================== */
        /* ============================================================================================= */

        /**
        * @description generate the default map of values for a given sObjectType.
        *               The default value map of values will contain the map of values overrided and generated value for all required fields of the sObjectType
        * @param sObjectType (Schema.SObjectType): sObject Type for which the map of values will generated
        * @param mapOfValues (Map<String,IFieldDefaultValue>): map of values
        * @param prefix (String): prefix of the relationship (example : Contact.Account.)
        */
        @TestVisible
        private void generateDefaultMapOfValues(Schema.SObjectType sObjectType, Map<String,IFieldDefaultValue> mapOfValues, String prefix){
            Schema.DescribeSObjectResult sObjectDesc = sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED);
            Map<String, Schema.SObjectField> fieldsMap = getFieldTokensMap(sObjectType); // get the field Tokens map
            Set<String> keySetOverride = mapOfValues.keySet();
            Set<String> relationshipKeySet = getRelationshipKeySet(keySetOverride,prefix);
            // get the defined required fields set
            Set<String> definedRequiredFields = getDefinedSObjectRequiredFields(sObjectType);
            // get the defined optional fields set
            Set<String> definedOptionalFields = getDefinedSObjectOptionalFields(sObjectType);
            // Manage Person Account Org enabled
            if(sObjectType == Account.sObjectType && isPersonAccountEnabled){ 
                managePersonAccountOrgEnabled(mapOfValues,prefix,definedRequiredFields);
            }
            // loop through fields map
            for(String fieldName : fieldsMap.keySet()){
                Schema.DescribeFieldResult fieldDesc = fieldsMap.get(fieldName).getDescribe(); // get field describe
                String fieldNameLowerCase = fieldName.toLowerCase();
                // construct the fully qualified name of the field
                String fullyQualifiedFieldName = prefix+fieldNameLowerCase;
                // get the field value from the mapOfValues
                Object overrideFieldValue = mapOfValues.get(fullyQualifiedFieldName);
                if(overrideFieldValue != null){ // override value provided for the field
                    if(overrideFieldValue instanceof AutoFieldDefaultValue) { // auto generate a field value
                        if(fieldDesc.getRelationshipName() == null){ // field
                            // put a fieldDefaultValue instance of the field in order to auto-generate the field default value
                            mapOfValues.put(fullyQualifiedFieldName,new FieldDefaultValue(this,sObjectDesc,fieldDesc));
                        }else { // relationship
                            // put a field relationship in the map of values
                            putRelationshipField(mapOfValues,fieldDesc,prefix); // <== recursion
                            // remove the AutoFieldDefaultValue instance from the map
                            mapOfValues.remove(fullyQualifiedFieldName);
                        } 
                    }
                }else { // no override value provided for the field
                    // field default value required and field not mentioned in definedOptionalFields or field mentioned in definedRequiredFields
                    Boolean isRequired = (isDefaultValueRequired(fieldDesc) && !definedOptionalFields.contains(fieldNameLowerCase)) || definedRequiredFields.contains(fieldNameLowerCase);
                    if(fieldDesc.getRelationshipName() == null){ // field
                        if(isRequired){
                            // put a fieldDefaultValue instance of the field in order to auto-generate the field default value
                            mapOfValues.put(fullyQualifiedFieldName,new FieldDefaultValue(this,sObjectDesc,fieldDesc));
                        }
                    }else { // relationship
                        String relationshipName = fieldDesc.getRelationshipName().toLowerCase();
                        if(isRequired || relationshipKeySet.contains(relationshipName)){ // relationship required or mentioned in the relationshipKeySet
                            // put a field relationship in the map of values
                            putRelationshipField(mapOfValues,fieldDesc,prefix); // <== recursion
                        }
                    }
                }
            }
        }

        /**
        * @description put a relationship field into a map of values
        * @param mapOfValues (Map<String,IFieldDefaultValue>): map of values in which relationship field will be put
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information information of the relationship field
        * @param prefix (String): prefix of the relationship field (example : Contact.Account.)
        */
        @TestVisible
        private void putRelationshipField(Map<String,IFieldDefaultValue> mapOfValues, Schema.DescribeFieldResult fieldDesc, String prefix){
            String relationshipName = fieldDesc.getRelationshipName().toLowerCase();
            String fullyQualifiedRelationshipName = prefix+relationshipName;
            // at least add (fullyQualifiedRelationshipName.id,null) to force the instantiation of the related sObject
            // in case the sObject has no required fields
            mapOfValues.put(fullyQualifiedRelationshipName+DOT+'id',new FieldDefaultValue(null));
            // get the related sObject instance
            SObjectType refSObjectType = fieldDesc.getReferenceTo().get(0);
            // generate a map for the related sObject
            generateDefaultMapOfValues(refSObjectType,mapOfValues,fullyQualifiedRelationshipName+DOT);
        }

        /**
        * @description manage the map of values and the defined required fields for Account if person account enabled org
        * @param mapOfValues (Map<String,IFieldDefaultValue>): map of values from which the field value id will be extracted
        * @param prefix (String): prefix of the relationship field (example : Contact.Account.)
        * @param definedRequiredFields (Set<String>): Set of defined required fields
        */
        @TestVisible
        private void managePersonAccountOrgEnabled(Map<String,IFieldDefaultValue> mapOfValues, String prefix, Set<String> definedRequiredFields){
            String fullyQualifieldRecordTypeIdFieldName = prefix+'recordtypeid';
            IFieldDefaultValue recordTypeIdDefaultValue = mapOfValues.get(fullyQualifieldRecordTypeIdFieldName);
            if(recordTypeIdDefaultValue == null){
                recordTypeIdDefaultValue = new FieldDefaultValue(null);
            }
            if(recordTypeIdDefaultValue instanceof FieldDefaultValue){ // instance of FieldDefaultValue
                Object recordTypeIdValue = recordTypeIdDefaultValue.getValue(0);
                if(recordTypeIdValue == null) {
                    recordTypeIdValue = accountDefaultRecordTypeId;
                    mapOfValues.put(fullyQualifieldRecordTypeIdFieldName, new FieldDefaultValue(accountDefaultRecordTypeId));
                }
                try{
                    Id recordTypeId = Id.valueOf((String)recordTypeIdValue);
                    if(personAccountRecordTypes.contains(recordTypeId)){ // person account 
                        definedRequiredFields.add('lastname');
                    }else { // business account
                        definedRequiredFields.add('name');
                    }
                }catch(Exception e){
                    throw new TestDataFactoryException(formatErrorMessage(ERR_BAD_RECORDTYPE_ID_FOR_ACCOUNT,new List<String>{},e.getMessage()));
                }
            }else if(recordTypeIdDefaultValue instanceof ListFieldDefaultValue){ // instance of ListFieldDefaultValue
                throw new TestDataFactoryException(formatErrorMessage(ERR_LIST_VALUE_NOT_SUPPORTED,new List<String>{fullyQualifieldRecordTypeIdFieldName},''));
            }
        }

        /**
        * @description get defined set of required fields for a given sObject type and record type id
        * @param sObjectType (Schema.SObjectType): sObject type for which the defined required fields will be returned 
        * @param recordTypeValue (Object): record type id provided for to the sObject Type
        * @return set of defined required fields
        */
        @TestVisible
        private Set<String> getDefinedSObjectRequiredFields(Schema.SObjectType sObjectType){
            Set<String> definedRequiredFields = new Set<String>();
            Set<String> definedRequiredFieldsByDeveloper = defineSObjectRequiredFields(sObjectType);
            if(definedRequiredFieldsByDeveloper != null){
                definedRequiredFields.addAll(convertSetToLowerCase(definedRequiredFieldsByDeveloper));
            }
            
            return definedRequiredFields;
        }

        /**
        * @description get defined set of optional fields for a given sObject type
        * @param sObjectType (Schema.SObjectType): sObject type for which the defined optional fields will be returned 
        * @param recordTypeValue (Object): record type id provided for to the sObject Type
        * @return set of defined optional fields
        */
        @TestVisible
        private Set<String> getDefinedSObjectOptionalFields(Schema.SObjectType sObjectType){
            Set<String> definedOptionalFields = new Set<String>();
            Set<String> definedOptionalFieldsByDeveloper = defineSObjectOptionalFields(sObjectType);
            if(definedOptionalFieldsByDeveloper != null){
                definedOptionalFields.addAll(convertSetToLowerCase(definedOptionalFieldsByDeveloper));
            }
            
            return definedOptionalFields;
        }

        /**
        * @description get relationship names keyset that starts with a given prefix
        * @param keySetOverride (Set<String>): keySet of fully qualified field names
        * @param prefix (String): prefix (example : Contact.Account.)
        * @return set of relationship names
        * @example 
        * keySetOverride = {Contact.Account.Name,Contact.FirstName}
        * Prefix : Contact.
        * Result : {Account}
        */
        @TestVisible
        private Set<String> getRelationshipKeySet(Set<String> keySetOverride, String prefix){
            Set<String> relationshipKeySet = new Set<String>();
            String prefixLowerCase = prefix.toLowerCase();
            // loop through the keySet
            for(String fullyQualifiedFieldName : keySetOverride){
                fullyQualifiedFieldName = fullyQualifiedFieldName.toLowerCase();
                if(fullyQualifiedFieldName.startsWith(prefixLowerCase)){ // starts with the prefix
                    String fullyQualifiedFieldNameAfterPrefix = fullyQualifiedFieldName.substringAfter(prefixLowerCase)+'';
                    if(fullyQualifiedFieldNameAfterPrefix.contains(DOT)){ // if there is a relationship after the prefix
                        // add the relationship name after the prefix
                        relationshipKeySet.add(fullyQualifiedFieldName.substringBetween(prefixLowerCase,DOT));
                    }
                }
            }
            return relationshipKeySet;
        }

        /**
        * @description converting a map from Map(key:String,value:Object) to Map(key:String,value:IFieldDefaultValue)
        * @param prefix (String): prefix (example : Contact.Account.)
        * @param mapOfValues (Map<String,Object>): map of values to convert
        * @return converted map
        */
        @TestVisible
        private Map<String,IFieldDefaultValue> convertMapValueTypes(String prefix, Map<String,Object> mapOfValues){ 
            Map<String,IFieldDefaultValue> convertedMap = new Map<String,IFieldDefaultValue>();
            if(mapOfValues == null){
                return convertedMap;
            } 
            for(String name : mapOfValues.keySet()){
                if(name != null){
                    Object value = mapOfValues.get(name);
                    String fullyQualifiedName = prefix + name.trim().toLowerCase();
                    if(value instanceof IFieldDefaultValue){
                        // cast the value if already of type IFieldDefaultValue
                        convertedMap.put(fullyQualifiedName,(IFieldDefaultValue)value);
                    }else if(value instanceof Map<String,Object>){
                        // convert the sub map of values and putting into the main map of values
                        convertedMap.putAll(convertMapValueTypes(fullyQualifiedName+DOT,(Map<String,Object>)value));
                    }else if(value instanceof SObject){
                        String fullyQualifiedFieldName = getFieldNameFromRelationshipName(fullyQualifiedName);
                        if(value instanceof List<SObject>){
                            // cast to list of sObject and wrap it in a ListRelationshipFieldDefaultValue instance
                            convertedMap.put(fullyQualifiedFieldName,new ListRelationshipFieldDefaultValue((List<SObject>)value));
                        }else{
                            // wrap the value in a RelationshipFieldDefaultValue instance
                            convertedMap.put(fullyQualifiedFieldName,new RelationshipFieldDefaultValue((SObject)value));
                        }
                    }else if(value instanceof List<Object>){
                        // cast to list objects and wrap it in a ListFieldDefaultValue instance
                        convertedMap.put(fullyQualifiedName,new ListFieldDefaultValue((List<Object>)value));
                    }else{
                        // wrap the value in a FieldDefaultValue instance
                        convertedMap.put(fullyQualifiedName,new FieldDefaultValue(value));
                    }
                }
            }
            return convertedMap;
        }

        /**
        * @description converting a given set of String to set of lower case string values
        * @param setOfValues (Set<String>): set of values to convert to lower case
        * @return converted set
        */
        @TestVisible
        private Set<String> convertSetToLowerCase(Set<String> setOfValues){
            Set<String> convertedSet = new Set<String>();
            if(setOfValues == null){
                return convertedSet;
            } 
            for(String value : setOfValues){
                if(value != null){
                    convertedSet.add(value.trim().toLowerCase());
                }
            }
            return convertedSet;
        }

        /**
        * @description test if a field requires a default value
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @return true if a default value is required
        */
        @TestVisible
        private Boolean isDefaultValueRequired(Schema.DescribeFieldResult fieldDesc){
            return 
                !fieldDesc.isDefaultedOnCreate() // does not have a defaut value on creation
                && !fieldDesc.isAutoNumber() // is not an auto number
                && !fieldDesc.isNillable() // is required
                && fieldDesc.isCreateable(); // value can be set on creation 
        }

        /**
        * @description generate a default value for a given field of an sObject 
        *                       depending on the field type, the corresponding get{FieldType}DefaultValue method will be invoked to retrieve the default value
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return the generated field default value
        */
        @TestVisible
        private Object getDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            if(fieldDesc != null){
                // DisplayType Enum -> https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_enum_Schema_DisplayType.htm
                switch on fieldDesc.getType() {
                    when Base64 {
                        return getBase64DefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Boolean {
                        return getCheckboxDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Currency {
                        return getCurrencyDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Date {
                        return getDateDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Datetime {
                        return getDateTimeDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Email {
                        return getEmailDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Location {
                        return getGeolocationDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Integer, Double {
                        return getNumberDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Percent {
                        return getPercentDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Phone {
                        return getPhoneDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Picklist {
                        return getPicklistDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when MultiPicklist {
                        return getMultiPicklistDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when String {
                        return getTextDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when TextArea {
                        return getTextAreaDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when Time {
                        return getTimeDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                    when URL {
                        return getURLDefaultValue(sObjectDesc,fieldDesc,recordIndex);
                    }
                }
            }
            return null;
        }

        /**
        * @description get the Saleforce default value for given picklist
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @return The picklist default value on Salesforce
        */
        @TestVisible
        private String getSFDefaultPicklistValue(Schema.DescribeFieldResult fieldDesc){
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

        /* ============================================================================================= */
        /* =======================================  virtual methods ==================================== */
        /* ============================================================================================= */
        /**
        * @description define a set of required fields for a given sObject
        * @param sObjectType (Schema.SObjectType): sObject Type for which the required fields will be defined
        * @return set of defined required fields
        */
        public virtual Set<String> defineSObjectRequiredFields(Schema.SObjectType sObjectType){
            return null;
        }
        /**
        * @description define a set of optional fields for a given sObject
        * @param sObjectType (Schema.SObjectType): sObject Type for which the optional fields will be defined
        * @return set of defined optional fields
        */
        public virtual Set<String> defineSObjectOptionalFields(Schema.SObjectType sObjectType){
            return null;
        }
        /**
        * @description get the default value for Base64 field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return base64 default value
        */
        public virtual Blob getBase64DefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return Blob.valueOf(recordIndex.format());
        }   
        /**
        * @description get the default value for checkbox field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return checkbox default value
        */
        public virtual Boolean getCheckboxDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return false;
        }
        /**
        * @description get the default value for Currency field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return currency default value
        */
        public virtual Decimal getCurrencyDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return recordIndex;
        }
        /**
        * @description get the default value for Date field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return date default value
        */
        public virtual Date getDateDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return Date.today();
        }
        /**
        * @description get the default value for Datetime field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return datetime default value
        */
        public virtual Datetime getDateTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return Datetime.now();
        }
        /**
        * @description get the default value for Email field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return email default value
        */
        public virtual String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return 'test'+recordIndex.format()+'@email.com';
        }
        /**
        * @description get the default value for Geolocation field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return geolocation default value
        */
        public virtual Location getGeolocationDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return Location.newInstance(0,0);
        }       
        /**
        * @description get the default value for Number field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return number default value
        */
        public virtual Decimal getNumberDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return recordIndex;
        }
        /**
        * @description get the default value for Percent field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return percent default value
        */
        public virtual Decimal getPercentDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return recordIndex;
        }
        /**
        * @description get the default value for Phone field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return phone default value
        */
        public virtual String getPhoneDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return '01 23 45 67 89';
        }
        /**
        * @description get the default value for Picklist field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return picklist default value
        */
        public virtual String getPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return getSFDefaultPicklistValue(fieldDesc);
        }
        /**
        * @description get the default value for Multipicklist field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return multipicklist default value
        */
        public virtual String getMultiPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return getSFDefaultPicklistValue(fieldDesc);
        }
        /**
        * @description get the default value for Text field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return text default value
        */
        public virtual String getTextDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return 'test'+recordIndex.format();
        }
        /**
        * @description get the default value for TextArea field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return text area default value
        */
        public virtual String getTextAreaDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return 'test'+recordIndex.format();
        }
        /**
        * @description get the default value for Time field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return time default value
        */
        public virtual Time getTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return Time.newInstance(12, 0, 0, 0);
        }
        /**
        * @description get the default value for URL field type
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return URL default value
        */
        public virtual String getURLDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex){
            return 'http://test' + recordIndex + '.com';
        }

    }

    /**
    * @description common interface fo the field default value classes
    */
    public interface IFieldDefaultValue{
        /**
        * @description get the value wrapped for a given record index
        */
        Object getValue(Integer recordIndex);
    }

    /**
    * @description wrapper for default value that will be auto generated 
    */
    public class AutoFieldDefaultValue implements IFieldDefaultValue{
        /**
        * @description get the value wrapped for a given record index
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return field default value
        */
        public Object getValue(Integer recordIndex){
            return null;
        }
    }

    /**
    * @description wrapper for a field default value
    */
    @TestVisible
    private class FieldDefaultValue implements IFieldDefaultValue{
        /** Instance of the container class */
        private DefaultValueProvider dvPrvdr = null;
        /** Field value */
        private Object value = null;
        /** SObject describe information */
        private Schema.DescribeSObjectResult sObjectDesc = null;
        /** Field describe information */
        private Schema.DescribeFieldResult fieldDesc = null;

        /**
        * @description construtor to wrap a griven field value
        * @param value (Object): the value that will be wrapped
        */
        public FieldDefaultValue(Object value){
            this.value = value;
        }   

        /**
        * @description construtor to wrap a field value that will be generated based on the given sObject & Field describe informations
        * @param dvPrvdr (DefaultValueProvider): default value provider instance of the containing class DefaultValueProvider
        * @param sObjectDesc (Schema.DescribeSObjectResult): sObject describe information
        * @param fieldDesc (Schema.DescribeFieldResult): field describe information
        */  
        public FieldDefaultValue(DefaultValueProvider dvPrvdr,Schema.DescribeSObjectResult sObjectDesc,Schema.DescribeFieldResult fieldDesc){
            this.dvPrvdr = dvPrvdr;
            this.sObjectDesc = sObjectDesc;
            this.fieldDesc = fieldDesc;
        }

        /**
        * @description get the wrapped value for a given record index
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return field default value
        */
        public Object getValue(Integer recordIndex){
            if(dvPrvdr != null){ // if default value provider is set
                // generate the value from the sObject & field describe informations
                return dvPrvdr.getDefaultValue(sObjectDesc,fieldDesc,recordIndex);
            }else {
                if(value instanceof String) // if value is of type string merge the index value
                    return mergeValue((String)value,'index',recordIndex.format());
                else return value;
            }
        }
    }

    /**
    * @description wrapper for a relationship field default value
    */
    @TestVisible
    private class RelationshipFieldDefaultValue implements IFieldDefaultValue{
        /** Field value */
        private SObject sObjectValue = null;

        /**
        * @description construtor to wrap a griven field sObject value
        * @param sObjectValue (Object): the sObject value that will be wrapped
        */
        public RelationshipFieldDefaultValue(SObject sObjectValue){
            this.sObjectValue = sObjectValue;
        }   

        /**
        * @description get the wrapped sObject value for a given record index
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return Id of the sObject field default value
        */
        public Object getValue(Integer recordIndex){
            return sObjectValue.Id;
        }
    }

    /**
    * @description wrapper for a list of field default values
    */
    @TestVisible
    private class ListFieldDefaultValue implements IFieldDefaultValue{
        /** Field list values */
        private List<Object> listValues = null;

        /**
        * @description construtor to wrap a griven field list of values
        * @param listValues (List<Object>): the list of values that will be wrapped
        */
        public ListFieldDefaultValue(List<Object> listValues){
            this.listValues = listValues;
        }   

        /**
        * @description get the wrapped value for a given record index
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return value at recordIndex position of list field default values
        */
        public Object getValue(Integer recordIndex){
            return listValues.get(Math.mod(recordIndex,listValues.size()));
        }

        /**
        * @description return the size of the wrapped list of values
        */
        public Integer size(){
            return listValues.size();
        }
    }

    /**
    * @description wrapper for a list of relationship field default values
    */
    @TestVisible
    private class ListRelationshipFieldDefaultValue implements IFieldDefaultValue{
        /** Field list sObject values */
        private List<SObject> listSObjectValues = null;

        /**
        * @description construtor to wrap a griven field list of sObject values
        * @param listSObjectValues (List<SObject>): the list of values that will be wrapped
        */
        public ListRelationshipFieldDefaultValue(List<SObject> listSObjectValues){
            this.listSObjectValues = listSObjectValues;
        }   

        /**
        * @description get the wrapped list sObject values for a given record index
        * @param recordIndex (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0
        * @return id of the sObject at recordIndex position of list relationship field default values
        */
        public Object getValue(Integer recordIndex){
                return listSObjectValues.get(recordIndex).Id;
        }

        /**
        * @description return the size of the wrapped list of the sObject values
        */
        public Integer size(){
            return listSObjectValues.size();
        }
    }

    /* ===========================  Utility methods  =========================== */

    /**
     * @description get the field tokens map of an sObject type with caching
     * @param sObjectType (Schema.SObjectType): sObject type for which the map of field tokens will be returned
     * @return field tokens map
     */
     @TestVisible
    private static Map<String, Schema.SObjectField> getFieldTokensMap(Schema.SObjectType sObjectType){
        if(mapOfFieldTokensMap.containsKey(sObjectType)){
            return mapOfFieldTokensMap.get(sObjectType);
        }else {
            Map<String, Schema.SObjectField> fieldTokensMap = sObjectType.getDescribe(SObjectDescribeOptions.DEFERRED).fields.getMap();
            mapOfFieldTokensMap.put(sObjectType,fieldTokensMap);
            return fieldTokensMap;
        }
    }

    /**
    * @description get field name from a relationship name
    * @param relationshipName (String): relationship name
    * @return field name 
    */
    @TestVisible
    private static String getFieldNameFromRelationshipName(String relationshipName){
        String relationshipNameLowerCase = relationshipName.toLowerCase();
        if(relationshipNameLowerCase.contains('__r')) // custom relationship 
            return relationshipNameLowerCase.replace('__r', '__c');
        return relationshipNameLowerCase+'id'; // standard relationship
    }

    /**
    * @description merge given value in a string
    * @param text (String): text with a merge value
    * @param name (String): name of the merge value
    * @param value (String): value to be merged
    * @return text with merged value
    */
    @TestVisible
    private static String mergeValue(String text, String name, String value){
        if(text == null) return null;
        String pattern = '(?i)\\{!'+name+'\\}';
        return text.replaceAll(pattern,value);
    }

    /**
    * @description format an error message
    * @param message (String): error message
    * @param mergeValues (List<String>): values to be merge in the error message
    * @param originalMessage (String): original error message
    * @return error message
    */
    @TestVisible
    private static String formatErrorMessage(String message, List<String> mergeValues, String originalMessage){
        String errorMessage = String.format(message,mergeValues);
        // if originalMessage is passed as param it will be include in the errorMessage
        if(!String.isBlank(originalMessage)) errorMessage +='\n'+'Original error message : '+originalMessage;
        return errorMessage;
    }
    
    /**
    * @description this is a dummy test method needed in order to create a managed package for TestDataFactory
    */
    @IsTest
    private static void dummyTest(){}

    /**
    * @description Test Data Factory Exception
    */
    public class TestDataFactoryException extends Exception {}

}
