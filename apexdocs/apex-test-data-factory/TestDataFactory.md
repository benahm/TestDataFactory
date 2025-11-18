# TestDataFactory Class

`ISTEST`

Provides reusable utilities for generating test SObject records with default and override values.

**Since**

2017

**Group** Apex Test Data Factory

**Author** benahm

## Fields
### `dvPrvdr`

Default value provider instance

#### Signature
```apex
private static dvPrvdr
```

#### Type
DefaultValueProvider

---

### `DEFAULT_VALUE`

Default value generator, used to auto-generate default values for non required fields

#### Signature
```apex
public static final DEFAULT_VALUE
```

#### Type
IFieldDefaultValue

---

### `DOT`

Constant that contains a dot &#x27;.&#x27;

#### Signature
```apex
private static final DOT
```

#### Type
String

---

### `mapOfFieldTokensMap`

`TESTVISIBLE`

Map of sObject types with their corresponding map of field Tokens

#### Signature
```apex
private static mapOfFieldTokensMap
```

#### Type
Map&lt;Schema.SObjectType,Map&lt;String,Schema.SObjectField&gt;&gt;

## Properties
### `defaultValueProvider`

Default Value Provider property, used to override the default value provider instance

#### Signature
```apex
public static defaultValueProvider
```

#### Type
DefaultValueProvider

---

### `isPersonAccountEnabled`

`TESTVISIBLE`

Determines if person account is enabled in current org

#### Signature
```apex
private static isPersonAccountEnabled
```

#### Type
Boolean

## Methods
### `createSObject(sObjectName)`

Creates an sObject.

#### Signature
```apex
public static SObject createSObject(String sObjectName)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |

#### Return Type
**SObject**

sObject instance

#### Example
Account acc &#x3D; (Account)TestDataFactory.createSObject(&#x27;Account&#x27;);

---

### `createSObject(sObjectName, doInsert)`

Creates an sObject.

#### Signature
```apex
public static SObject createSObject(String sObjectName, Boolean doInsert)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |
| doInsert | Boolean |  |

#### Return Type
**SObject**

sObject instance

#### Example
Account acc &#x3D; (Account)TestDataFactory.createSObject(&#x27;Account&#x27;,false);

---

### `createSObject(sObjectName, mapOfValuesOverride)`

Creates an sObject with a map to override field values.

#### Signature
```apex
public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |
| mapOfValuesOverride | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values |

#### Return Type
**SObject**

sObject instance

#### Example
Account acc &#x3D; (Account)TestDataFactory.createSObject(&#x27;Account&#x27;,new Map&lt;String,Object&gt;{ 
&#x27;Description&#x27; &#x3D;&gt; &#x27;Test&#x27; 
});

---

### `createSObject(sObjectName, mapOfValuesOverride, doInsert)`

Creates an sObject with a map to override field values.

#### Signature
```apex
public static SObject createSObject(String sObjectName, Map<String,Object> mapOfValuesOverride, Boolean doInsert)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |
| mapOfValuesOverride | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values |
| doInsert | Boolean | (Boolean): if true the sObject instance is inserted to the Salesforce database |

#### Return Type
**SObject**

sObject instance

#### Example
Account acc &#x3D; (Account)TestDataFactory.createSObject(&#x27;Account&#x27;,new Map&lt;String,Object&gt;{ 
&#x27;Description&#x27; &#x3D;&gt; &#x27;Test&#x27; 
},false);

---

### `createSObjectList(sObjectName, numberOfSObjects)`

Creates a list of sObjects.

#### Signature
```apex
public static List<SObject> createSObjectList(String sObjectName, Integer numberOfSObjects)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |
| numberOfSObjects | Integer | (Integer): number of sObjects to be created |

#### Return Type
**List&lt;SObject&gt;**

list of sObject instances

#### Example
List&lt;Account&gt; accList &#x3D; TestDataFactory.createSObjectList(&#x27;Account&#x27;,10);

---

### `createSObjectList(sObjectName, numberOfSObjects, doInsert)`

Creates a list of sObjects.

#### Signature
```apex
public static List<SObject> createSObjectList(String sObjectName, Integer numberOfSObjects, Boolean doInsert)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |
| numberOfSObjects | Integer | (Integer): number of sObjects to be created |
| doInsert | Boolean | (Boolean): if true the sObject list instances is inserted to the Salesforce database |

#### Return Type
**List&lt;SObject&gt;**

list of sObject instances

#### Example
List&lt;Account&gt; accList &#x3D; TestDataFactory.createSObjectList(&#x27;Account&#x27;,10,false);

---

### `createSObjectList(sObjectName, mapOfValuesOverride, numberOfSObjects)`

Creates a list of sObjects with a map to override field values.

#### Signature
```apex
public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Integer numberOfSObjects)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |
| mapOfValuesOverride | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values |
| numberOfSObjects | Integer | (Integer): number of sObjects to be created |

#### Return Type
**List&lt;SObject&gt;**

list of sObject instances

#### Example
List&lt;Account&gt; accList &#x3D; TestDataFactory.createSObjectList(&#x27;Account&#x27;,new Map&lt;String,Object&gt;{ 
&#x27;Description&#x27; &#x3D;&gt; &#x27;Test&#x27; 
},10);

---

### `createSObjectList(sObjectName, mapOfValuesOverride, numberOfSObjects, doInsert)`

Creates a list of sObjects with a map to override field values.

#### Signature
```apex
public static List<SObject> createSObjectList(String sObjectName, Map<String,Object> mapOfValuesOverride, Integer numberOfSObjects, Boolean doInsert)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): name of the sObject to be created |
| mapOfValuesOverride | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values |
| numberOfSObjects | Integer | (Integer): number of sObjects to be created |
| doInsert | Boolean | (Boolean): if true the sObject list instances is inserted to the Salesforce database |

#### Return Type
**List&lt;SObject&gt;**

list of sObject instances

#### Example
List&lt;Account&gt; accList &#x3D; TestDataFactory.createSObjectList(&#x27;Account&#x27;,new Map&lt;String,Object&gt;{ 
&#x27;Description&#x27; &#x3D;&gt; &#x27;Test&#x27; 
},10,false);

---

### `getFieldTokensMap(sObjectType)`

`TESTVISIBLE`

Gets the field tokens map of an sObject type with caching.

#### Signature
```apex
private static Map<String,Schema.SObjectField> getFieldTokensMap(Schema.SObjectType sObjectType)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject type for which the map of field tokens will be returned |

#### Return Type
**Map&lt;String,Schema.SObjectField&gt;**

field tokens map

---

### `getFieldNameFromRelationshipName(relationshipName)`

`TESTVISIBLE`

Gets field name from a relationship name.

#### Signature
```apex
private static String getFieldNameFromRelationshipName(String relationshipName)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| relationshipName | String | (String): relationship name |

#### Return Type
**String**

field name

---

### `mergeValue(text, name, value)`

`TESTVISIBLE`

Merges given value in a string.

#### Signature
```apex
private static String mergeValue(String text, String name, String value)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| text | String | (String): text with a merge value |
| name | String | (String): name of the merge value |
| value | String | (String): value to be merged |

#### Return Type
**String**

text with merged value

---

### `formatErrorMessage(message, mergeValues, originalMessage)`

`TESTVISIBLE`

Formats an error message.

#### Signature
```apex
private static String formatErrorMessage(String message, List<String> mergeValues, String originalMessage)
```

#### Parameters
| Name | Type | Description |
|------|------|-------------|
| message | String | (String): error message |
| mergeValues | List&lt;String&gt; | (List&lt;String&gt;): values to be merge in the error message |
| originalMessage | String | (String): original error message |

#### Return Type
**String**

error message

---

### `dummyTest()`

`ISTEST`

This is a dummy test method needed in order to create a managed package for TestDataFactory.

#### Signature
```apex
private static void dummyTest()
```

#### Return Type
**void**

## Classes
### SObjectManager Class

Coordinates SObject instances and ensures their insertions respect parent-child ordering.

**Implements**

ISObjectManager

#### Fields
##### `sObjectName`

Main sObject name

###### Signature
```apex
private sObjectName
```

###### Type
String

---

##### `mainSObjectList`

`TESTVISIBLE`

List of main sObject instances

###### Signature
```apex
private mainSObjectList
```

###### Type
List&lt;SObject&gt;

---

##### `relatedSObjMapList`

`TESTVISIBLE`

Map of relationship names with their related list of sObject instances

###### Signature
```apex
private relatedSObjMapList
```

###### Type
Map&lt;String,List&lt;SObject&gt;&gt;

---

##### `orderedRelationshipList`

`TESTVISIBLE`

List of ordered relationship names by dot notation

###### Signature
```apex
private orderedRelationshipList
```

###### Type
List&lt;String&gt;

---

##### `ERR_INSERT_SOBJECT`

Unable to insert &quot;{0}&quot; records: {1}

###### Signature
```apex
private final ERR_INSERT_SOBJECT
```

###### Type
String

#### Constructors
##### `SObjectManager(sObjectName)`

Constructs a manager for the specified main SObject type.

###### Signature
```apex
public SObjectManager(String sObjectName)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectName | String | (String): main sObject name |

#### Methods
##### `getMainSObjectList()`

Gets the list of all main sObject instances.

###### Signature
```apex
public List<SObject> getMainSObjectList()
```

###### Return Type
**List&lt;SObject&gt;**

list of sObject instances

---

##### `setSObject(index, sObj)`

Sets or add an sObject to the main sObject list for a given index.

###### Signature
```apex
public void setSObject(Integer index, SObject sObj)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer | (Integer): index for which the sObject instance will be added or set |
| sObj | SObject | (SObject): sObject instance to add or set to the main sObject list |

###### Return Type
**void**

---

##### `getSObject(index)`

Gets an sObject from the main sObject list for a given index.

###### Signature
```apex
public SObject getSObject(Integer index)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer | (Integer): index for which the sObject instance will be returned |

###### Return Type
**SObject**

the returned sObject instance

---

##### `setRelationship(index, fullyQualifiedRelationshipName, sObj)`

Sets or add a related sObject into the related sObject map list for a given index and relationship name.

###### Signature
```apex
public void setRelationship(Integer index, String fullyQualifiedRelationshipName, SObject sObj)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer | (Integer): index for which the sObject instance will be added or set |
| fullyQualifiedRelationshipName | String | (String): fully qualified relationship name for which the sObject instance will be added or set |
| sObj | SObject | (SObject): sObject instance to add or set to the related sObject map list |

###### Return Type
**void**

---

##### `getRelationship(index, fullyQualifiedRelationshipName)`

Gets a related sObject from the related sObject map list for a given index and relationship name.

###### Signature
```apex
public SObject getRelationship(Integer index, String fullyQualifiedRelationshipName)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer | (Integer): index for which the sObject instance will be returned |
| fullyQualifiedRelationshipName | String | (String): fully qualified relationship name for which the sObject instance will be returned |

###### Return Type
**SObject**

the returned sObject instance

---

##### `insertAll()`

Inserts all the sObjects stored in the sObject Manager into the Salesforce database.

###### Signature
```apex
public void insertAll()
```

###### Return Type
**void**

---

##### `setChildParentRelationship(sObjChildList, sObjParentList, relationshipName)`

`TESTVISIBLE`

Links a list of child sObject instances to a list of parent sObject instances for a given relationship name.

###### Signature
```apex
private void setChildParentRelationship(List<SObject> sObjChildList, List<SObject> sObjParentList, String relationshipName)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjChildList | List&lt;SObject&gt; | (List&lt;SObject&gt;): list of child sObject instances |
| sObjParentList | List&lt;SObject&gt; | (List&lt;SObject&gt;): list of parent sObject instances |
| relationshipName | String | (String): relationship name that links the child sObject to the parent sObject |

###### Return Type
**void**

---

##### `addRelationshipName(fullyQualifiedRelationshipName)`

`TESTVISIBLE`

Adds relationship name to the ordered relationship list, ordered by the number of dots.

###### Signature
```apex
private void addRelationshipName(String fullyQualifiedRelationshipName)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| fullyQualifiedRelationshipName | String | (String): fully qualified relationship name (example contact.account) |

###### Return Type
**void**

---

##### `insertList(sObjList, errorMessageMergeValue)`

`TESTVISIBLE`

Execute a DML insert operation on a list of sObjects.

###### Signature
```apex
private void insertList(List<SObject> sObjList, String errorMessageMergeValue)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjList | List&lt;SObject&gt; | (List&lt;SObject&gt;): list of sObjects to be inserted |
| errorMessageMergeValue | String | (String): merge value provided only for error message generation (example : .contact.account) |

###### Return Type
**void**

### SObjectFactory Class

Builds SObject instances by combining default values, overrides, and relationship wiring.

**Implements**

ISObjectFactory

#### Fields
##### `sObjectType`

Main sObject type to instantiated

###### Signature
```apex
private sObjectType
```

###### Type
Schema.SObjectType

---

##### `sObjectName`

Main sObject Name to instantiated

###### Signature
```apex
private sObjectName
```

###### Type
String

---

##### `sObjMgr`

Instance of SObject Manager to store all the created sObject instances

###### Signature
```apex
private sObjMgr
```

###### Type
SObjectManager

---

##### `ERR_NOT_FOUND_SOBJECT`

Unable to find the sObject

###### Signature
```apex
private final ERR_NOT_FOUND_SOBJECT
```

###### Type
String

---

##### `ERR_FIELD_NOT_EXIST`

The field &quot;{0}&quot; does not exist on &quot;{1}&quot; or the value type provided is incorrect

###### Signature
```apex
private final ERR_FIELD_NOT_EXIST
```

###### Type
String

---

##### `ERR_RELATIONSHIP_NOT_EXIST`

The relationship &quot;{0}&quot; does not exist on &quot;{1}&quot;

###### Signature
```apex
private final ERR_RELATIONSHIP_NOT_EXIST
```

###### Type
String

---

##### `ERR_UNABLE_TO_GET_FIELD_VALUE`

Unable to get the value for the field &quot;{0}&quot;

###### Signature
```apex
private final ERR_UNABLE_TO_GET_FIELD_VALUE
```

###### Type
String

#### Constructors
##### `SObjectFactory(sObjectType)`

Constructor.

###### Signature
```apex
public SObjectFactory(Schema.SObjectType sObjectType)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): main sObject type to be instantiated |

#### Methods
##### `getSObjectManager()`

Gets the SObject Manager instance.

###### Signature
```apex
public SObjectManager getSObjectManager()
```

###### Return Type
**SObjectManager**

sObject Manager instance

---

##### `getSObjectInstance(mapOfValuesOverride, doInsert)`

Generates an sObject instance and apply the override map of values.

###### Signature
```apex
public SObject getSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValuesOverride | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values to override when instanciating the sObject |
| doInsert | Boolean | (Boolean): if true the sObject list instances is inserted to the Salesforce database |

###### Return Type
**SObject**

sObject instance

---

##### `getListSObjectInstance(mapOfValuesOverride, doInsert, numberOfSObjects)`

Generates a list of sObject instances and apply the override map of values.

###### Signature
```apex
public List<SObject> getListSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValuesOverride | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values to override when instanciating the sObject |
| doInsert | Boolean | (Boolean): if true the sObject list instances is inserted to the Salesforce database |
| numberOfSObjects | Integer | (Integer): number of sObjects to be instantiated |

###### Return Type
**List&lt;SObject&gt;**

list of sObject instances

---

##### `initSObjectInstance(mapOfValues, recordIndex)`

`TESTVISIBLE`

Initiates the main sObject instance with all related sObject and apply the map of values.

###### Signature
```apex
private void initSObjectInstance(Map<String,IFieldDefaultValue> mapOfValues, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValues | Map&lt;String,IFieldDefaultValue&gt; | (Map&lt;String,IFieldDefaultValue&gt;): map of values with key as field name and value as the default value to be used when instantiating the sObject. 
This map contains the default values provided as input by the user and the auto-generated default values for the required fields |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**void**

---

##### `getRelationshipInstance(fullyQualifiedRelationshipName, recordIndex)`

`TESTVISIBLE`

Recursively initiates all related SObjects for the specified fully qualified relationship name.

###### Signature
```apex
private SObject getRelationshipInstance(String fullyQualifiedRelationshipName, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| fullyQualifiedRelationshipName | String | (String): fully qualified relationship name (example : Case.Contact.Account) |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**SObject**

main sObject instance with all related sObjects attached to it

---

##### `getRelatedSObjectInstance(sObjectType, relationshipName, errorMessageMergeValue)`

`TESTVISIBLE`

Gets related sObject instance of an sObject type for a given relationship name.

###### Signature
```apex
private SObject getRelatedSObjectInstance(Schema.SObjectType sObjectType, String relationshipName, String errorMessageMergeValue)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject type to which the generate sObject is related |
| relationshipName | String | (String): relationship name that links the sObject type and the sObject instance that will be generated |
| errorMessageMergeValue | String | (String): merge value provided only for error message generation (example : Contact.Account) |

###### Return Type
**SObject**

the generated related sObject instance

---

##### `getFieldValueFromMapOfValues(mapOfValues, fullyQualifiedFieldName, recordIndex)`

`TESTVISIBLE`

Gets the field value from the map of values for a given record index and fully qualified field name.

###### Signature
```apex
private Object getFieldValueFromMapOfValues(Map<String,IFieldDefaultValue> mapOfValues, String fullyQualifiedFieldName, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValues | Map&lt;String,IFieldDefaultValue&gt; | (Map&lt;String,IFieldDefaultValue&gt;): map of values with key as field name and value as the default value to be used when instantiating the sObject. |
| fullyQualifiedFieldName | String | (String): fully qualified field name (example : Contact.Account.Name) |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Object**

field value

---

##### `putSObject(sObj, relationshipName, sObjectValue, errorMessageMergeValue)`

`TESTVISIBLE`

Attaches an sObject into a related sObject.

###### Signature
```apex
private SObject putSObject(SObject sObj, String relationshipName, SObject sObjectValue, String errorMessageMergeValue)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObj | SObject | (SObject): main sObject instance |
| relationshipName | String | (String): sObject name of the related sObject |
| sObjectValue | SObject | (SObject): related sObject instance to be attached to the main sObject instance |
| errorMessageMergeValue | String | (String): merge value provided only for error message generation (example : Contact.Account) |

###### Return Type
**SObject**

main sObject instance

---

##### `putField(sObj, fieldName, fieldValue, errorMessageMergeValue)`

`TESTVISIBLE`

Sets field value in given sObject instance.

###### Signature
```apex
private SObject putField(SObject sObj, String fieldName, Object fieldValue, String errorMessageMergeValue)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObj | SObject | (SObject): main sObject instance |
| fieldName | String | (String): field name of the field to set |
| fieldValue | Object | (Object): value of the field to set |
| errorMessageMergeValue | String | (String): merge value provided only for error message generation (example : Contact.Account) |

###### Return Type
**SObject**

main sObject instance

### DefaultValueProvider Class

Provides a base implementation that builds default value maps and resolves per-field defaults.

**Implements**

IDefaultValueProvider

#### Fields
##### `ERR_LIST_VALUE_NOT_SUPPORTED`

List values is not supported for field {0}

###### Signature
```apex
private final ERR_LIST_VALUE_NOT_SUPPORTED
```

###### Type
String

---

##### `ERR_BAD_RECORDTYPE_ID_FOR_ACCOUNT`

Bad record type Id provided for Account

###### Signature
```apex
private final ERR_BAD_RECORDTYPE_ID_FOR_ACCOUNT
```

###### Type
String

#### Properties
##### `personAccountRecordTypes`

`TESTVISIBLE`

Person Account record type Ids

###### Signature
```apex
private personAccountRecordTypes
```

###### Type
Set&lt;Id&gt;

---

##### `accountDefaultRecordTypeId`

`TESTVISIBLE`

Account default record type Id

###### Signature
```apex
private accountDefaultRecordTypeId
```

###### Type
Id

#### Methods
##### `getDefaultMapOfValues(sObjectType, mapOfValuesOverride)`

Gets the default map of values for a given sObjectType. 
The default map of value contains fully qualified field name as a key and the field value wrapped in FieldDefaultValue instance

###### Signature
```apex
public Map<String,IFieldDefaultValue> getDefaultMapOfValues(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject Type for which the map of values will be generated |
| mapOfValuesOverride | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values that will override the the auto-generated map of values |

###### Return Type
**Map&lt;String,IFieldDefaultValue&gt;**

map of values

---

##### `generateDefaultMapOfValues(sObjectType, mapOfValues, prefix)`

`TESTVISIBLE`

Generates the default map of values for a given sObjectType. 
The default value map of values will contain the map of values overrided and generated value for all required fields of the sObjectType

###### Signature
```apex
private void generateDefaultMapOfValues(Schema.SObjectType sObjectType, Map<String,IFieldDefaultValue> mapOfValues, String prefix)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject Type for which the map of values will generated |
| mapOfValues | Map&lt;String,IFieldDefaultValue&gt; | (Map&lt;String,IFieldDefaultValue&gt;): map of values |
| prefix | String | (String): prefix of the relationship (example : Contact.Account.) |

###### Return Type
**void**

---

##### `putRelationshipField(mapOfValues, fieldDesc, prefix)`

`TESTVISIBLE`

Puts a relationship field into a map of values.

###### Signature
```apex
private void putRelationshipField(Map<String,IFieldDefaultValue> mapOfValues, Schema.DescribeFieldResult fieldDesc, String prefix)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValues | Map&lt;String,IFieldDefaultValue&gt; | (Map&lt;String,IFieldDefaultValue&gt;): map of values in which relationship field will be put |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information information of the relationship field |
| prefix | String | (String): prefix of the relationship field (example : Contact.Account.) |

###### Return Type
**void**

---

##### `managePersonAccountOrgEnabled(mapOfValues, prefix, definedRequiredFields)`

`TESTVISIBLE`

Manages the map of values and the defined required fields for Account if person account enabled org.

###### Signature
```apex
private void managePersonAccountOrgEnabled(Map<String,IFieldDefaultValue> mapOfValues, String prefix, Set<String> definedRequiredFields)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValues | Map&lt;String,IFieldDefaultValue&gt; | (Map&lt;String,IFieldDefaultValue&gt;): map of values from which the field value id will be extracted |
| prefix | String | (String): prefix of the relationship field (example : Contact.Account.) |
| definedRequiredFields | Set&lt;String&gt; | (Set&lt;String&gt;): Set of defined required fields |

###### Return Type
**void**

---

##### `getDefinedSObjectRequiredFields(sObjectType)`

`TESTVISIBLE`

Gets defined set of required fields for a given sObject type and record type id.

###### Signature
```apex
private Set<String> getDefinedSObjectRequiredFields(Schema.SObjectType sObjectType)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject type for which the defined required fields will be returned |

###### Return Type
**Set&lt;String&gt;**

set of defined required fields

---

##### `getDefinedSObjectOptionalFields(sObjectType)`

`TESTVISIBLE`

Gets defined set of optional fields for a given sObject type.

###### Signature
```apex
private Set<String> getDefinedSObjectOptionalFields(Schema.SObjectType sObjectType)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject type for which the defined optional fields will be returned |

###### Return Type
**Set&lt;String&gt;**

set of defined optional fields

---

##### `getRelationshipKeySet(keySetOverride, prefix)`

`TESTVISIBLE`

Gets relationship names keyset that starts with a given prefix.

###### Signature
```apex
private Set<String> getRelationshipKeySet(Set<String> keySetOverride, String prefix)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| keySetOverride | Set&lt;String&gt; | (Set&lt;String&gt;): keySet of fully qualified field names |
| prefix | String | (String): prefix (example : Contact.Account.) |

###### Return Type
**Set&lt;String&gt;**

set of relationship names

###### Example
keySetOverride &#x3D; {Contact.Account.Name,Contact.FirstName} 
Prefix : Contact. 
Result : {Account}

---

##### `convertMapValueTypes(prefix, mapOfValues)`

`TESTVISIBLE`

Converts a map from Map(key:String,value:Object) to Map(key:String,value:IFieldDefaultValue).

###### Signature
```apex
private Map<String,IFieldDefaultValue> convertMapValueTypes(String prefix, Map<String,Object> mapOfValues)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| prefix | String | (String): prefix (example : Contact.Account.) |
| mapOfValues | Map&lt;String,Object&gt; | (Map&lt;String,Object&gt;): map of values to convert |

###### Return Type
**Map&lt;String,IFieldDefaultValue&gt;**

converted map

---

##### `convertSetToLowerCase(setOfValues)`

`TESTVISIBLE`

Converts a given set of String to set of lower case string values.

###### Signature
```apex
private Set<String> convertSetToLowerCase(Set<String> setOfValues)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| setOfValues | Set&lt;String&gt; | (Set&lt;String&gt;): set of values to convert to lower case |

###### Return Type
**Set&lt;String&gt;**

converted set

---

##### `isDefaultValueRequired(fieldDesc)`

`TESTVISIBLE`

Tests if a field requires a default value.

###### Signature
```apex
private Boolean isDefaultValueRequired(Schema.DescribeFieldResult fieldDesc)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |

###### Return Type
**Boolean**

true if a default value is required

---

##### `getDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

`TESTVISIBLE`

Generates a default value for a given field of an sObject. 
depending on the field type, the corresponding get{FieldType}DefaultValue method will be invoked to retrieve the default value

###### Signature
```apex
private Object getDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Object**

the generated field default value

---

##### `getSFDefaultPicklistValue(fieldDesc)`

`TESTVISIBLE`

Gets the Salesforce default value for given picklist.

###### Signature
```apex
private String getSFDefaultPicklistValue(Schema.DescribeFieldResult fieldDesc)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |

###### Return Type
**String**

The picklist default value on Salesforce

---

##### `defineSObjectRequiredFields(sObjectType)`

Defines a set of required fields for a given sObject.

###### Signature
```apex
public virtual Set<String> defineSObjectRequiredFields(Schema.SObjectType sObjectType)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject Type for which the required fields will be defined |

###### Return Type
**Set&lt;String&gt;**

set of defined required fields

---

##### `defineSObjectOptionalFields(sObjectType)`

Defines a set of optional fields for a given sObject.

###### Signature
```apex
public virtual Set<String> defineSObjectOptionalFields(Schema.SObjectType sObjectType)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType | (Schema.SObjectType): sObject Type for which the optional fields will be defined |

###### Return Type
**Set&lt;String&gt;**

set of defined optional fields

---

##### `getBase64DefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Base64 field type.

###### Signature
```apex
public virtual Blob getBase64DefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Blob**

base64 default value

---

##### `getCheckboxDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for checkbox field type.

###### Signature
```apex
public virtual Boolean getCheckboxDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Boolean**

checkbox default value

---

##### `getCurrencyDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Currency field type.

###### Signature
```apex
public virtual Decimal getCurrencyDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Decimal**

currency default value

---

##### `getDateDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Date field type.

###### Signature
```apex
public virtual Date getDateDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Date**

date default value

---

##### `getDateTimeDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Datetime field type.

###### Signature
```apex
public virtual Datetime getDateTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Datetime**

datetime default value

---

##### `getEmailDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Email field type.

###### Signature
```apex
public virtual String getEmailDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**String**

email default value

---

##### `getGeolocationDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Geolocation field type.

###### Signature
```apex
public virtual Location getGeolocationDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Location**

geolocation default value

---

##### `getNumberDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Number field type.

###### Signature
```apex
public virtual Decimal getNumberDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Decimal**

number default value

---

##### `getPercentDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Percent field type.

###### Signature
```apex
public virtual Decimal getPercentDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Decimal**

percent default value

---

##### `getPhoneDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Phone field type.

###### Signature
```apex
public virtual String getPhoneDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**String**

phone default value

---

##### `getPicklistDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Picklist field type.

###### Signature
```apex
public virtual String getPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**String**

picklist default value

---

##### `getMultiPicklistDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Multipicklist field type.

###### Signature
```apex
public virtual String getMultiPicklistDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**String**

multipicklist default value

---

##### `getTextDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Text field type.

###### Signature
```apex
public virtual String getTextDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**String**

text default value

---

##### `getTextAreaDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for TextArea field type.

###### Signature
```apex
public virtual String getTextAreaDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**String**

text area default value

---

##### `getTimeDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for Time field type.

###### Signature
```apex
public virtual Time getTimeDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Time**

time default value

---

##### `getURLDefaultValue(sObjectDesc, fieldDesc, recordIndex)`

Gets the default value for URL field type.

###### Signature
```apex
public virtual String getURLDefaultValue(Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc, Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**String**

URL default value

### AutoFieldDefaultValue Class

Wrapper for default value that will be auto generated.

**Implements**

IFieldDefaultValue

#### Methods
##### `getValue(recordIndex)`

Gets the value wrapped for a given record index.

###### Signature
```apex
public Object getValue(Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Object**

field default value

### FieldDefaultValue Class

`TESTVISIBLE`

Wrapper for a field default value.

**Implements**

IFieldDefaultValue

#### Fields
##### `dvPrvdr`

Instance of the container class

###### Signature
```apex
private dvPrvdr
```

###### Type
DefaultValueProvider

---

##### `value`

Field value

###### Signature
```apex
private value
```

###### Type
Object

---

##### `sObjectDesc`

SObject describe information

###### Signature
```apex
private sObjectDesc
```

###### Type
Schema.DescribeSObjectResult

---

##### `fieldDesc`

Field describe information

###### Signature
```apex
private fieldDesc
```

###### Type
Schema.DescribeFieldResult

#### Constructors
##### `FieldDefaultValue(value)`

Constructor to wrap a griven field value.

###### Signature
```apex
public FieldDefaultValue(Object value)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| value | Object | (Object): the value that will be wrapped |

---

##### `FieldDefaultValue(dvPrvdr, sObjectDesc, fieldDesc)`

Constructor to wrap a field value that will be generated based on the given sObject &amp; Field describe informations.

###### Signature
```apex
public FieldDefaultValue(DefaultValueProvider dvPrvdr, Schema.DescribeSObjectResult sObjectDesc, Schema.DescribeFieldResult fieldDesc)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| dvPrvdr | DefaultValueProvider | (DefaultValueProvider): default value provider instance of the containing class DefaultValueProvider |
| sObjectDesc | Schema.DescribeSObjectResult | (Schema.DescribeSObjectResult): sObject describe information |
| fieldDesc | Schema.DescribeFieldResult | (Schema.DescribeFieldResult): field describe information |

#### Methods
##### `getValue(recordIndex)`

Gets the wrapped value for a given record index.

###### Signature
```apex
public Object getValue(Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Object**

field default value

### RelationshipFieldDefaultValue Class

`TESTVISIBLE`

Wrapper for a relationship field default value.

**Implements**

IFieldDefaultValue

#### Fields
##### `sObjectValue`

Field value

###### Signature
```apex
private sObjectValue
```

###### Type
SObject

#### Constructors
##### `RelationshipFieldDefaultValue(sObjectValue)`

Constructor to wrap a griven field sObject value.

###### Signature
```apex
public RelationshipFieldDefaultValue(SObject sObjectValue)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectValue | SObject | (Object): the sObject value that will be wrapped |

#### Methods
##### `getValue(recordIndex)`

Gets the wrapped sObject value for a given record index.

###### Signature
```apex
public Object getValue(Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Object**

Id of the sObject field default value

### ListFieldDefaultValue Class

`TESTVISIBLE`

Wrapper for a list of field default values.

**Implements**

IFieldDefaultValue

#### Fields
##### `listValues`

Field list values

###### Signature
```apex
private listValues
```

###### Type
List&lt;Object&gt;

#### Constructors
##### `ListFieldDefaultValue(listValues)`

Constructor to wrap a griven field list of values.

###### Signature
```apex
public ListFieldDefaultValue(List<Object> listValues)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| listValues | List&lt;Object&gt; | (List&lt;Object&gt;): the list of values that will be wrapped |

#### Methods
##### `getValue(recordIndex)`

Gets the wrapped value for a given record index.

###### Signature
```apex
public Object getValue(Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Object**

value at recordIndex position of list field default values

---

##### `size()`

Returns the size of the wrapped list of values.

###### Signature
```apex
public Integer size()
```

###### Return Type
**Integer**

### ListRelationshipFieldDefaultValue Class

`TESTVISIBLE`

Wrapper for a list of relationship field default values.

**Implements**

IFieldDefaultValue

#### Fields
##### `listSObjectValues`

Field list sObject values

###### Signature
```apex
private listSObjectValues
```

###### Type
List&lt;SObject&gt;

#### Constructors
##### `ListRelationshipFieldDefaultValue(listSObjectValues)`

Constructor to wrap a griven field list of sObject values.

###### Signature
```apex
public ListRelationshipFieldDefaultValue(List<SObject> listSObjectValues)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| listSObjectValues | List&lt;SObject&gt; | (List&lt;SObject&gt;): the list of values that will be wrapped |

#### Methods
##### `getValue(recordIndex)`

Gets the wrapped list sObject values for a given record index.

###### Signature
```apex
public Object getValue(Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIndex | Integer | (Integer): index number (starting from 0) of each record when creating a list of sObjects. For single sObject creation recordIndex is default to 0 |

###### Return Type
**Object**

id of the sObject at recordIndex position of list relationship field default values

---

##### `size()`

Returns the size of the wrapped list of the sObject values.

###### Signature
```apex
public Integer size()
```

###### Return Type
**Integer**

### TestDataFactoryException Class

Tests Data Factory Exception.

## Interfaces
### ISObjectManager Interface

Defines the contract for tracking SObject instances and their relationships during test data creation.

#### Methods
##### `getMainSObjectList()`

###### Signature
```apex
public List<SObject> getMainSObjectList()
```

###### Return Type
**List&lt;SObject&gt;**

---

##### `setSObject(index, sObj)`

###### Signature
```apex
public void setSObject(Integer index, SObject sObj)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer |  |
| sObj | SObject |  |

###### Return Type
**void**

---

##### `getSObject(index)`

###### Signature
```apex
public SObject getSObject(Integer index)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer |  |

###### Return Type
**SObject**

---

##### `setRelationship(index, relationshipName, sObj)`

###### Signature
```apex
public void setRelationship(Integer index, String relationshipName, SObject sObj)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer |  |
| relationshipName | String |  |
| sObj | SObject |  |

###### Return Type
**void**

---

##### `getRelationship(index, relationshipName)`

###### Signature
```apex
public SObject getRelationship(Integer index, String relationshipName)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| index | Integer |  |
| relationshipName | String |  |

###### Return Type
**SObject**

---

##### `insertAll()`

###### Signature
```apex
public void insertAll()
```

###### Return Type
**void**

### ISObjectFactory Interface

Declares how to create SObject instances and expose the SObject manager used during generation.

#### Methods
##### `getSObjectManager()`

###### Signature
```apex
public ISObjectManager getSObjectManager()
```

###### Return Type
**ISObjectManager**

---

##### `getSObjectInstance(mapOfValuesOverride, doInsert)`

###### Signature
```apex
public SObject getSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValuesOverride | Map&lt;String,Object&gt; |  |
| doInsert | Boolean |  |

###### Return Type
**SObject**

---

##### `getListSObjectInstance(mapOfValuesOverride, doInsert, numberOfSObjects)`

###### Signature
```apex
public List<SObject> getListSObjectInstance(Map<String,Object> mapOfValuesOverride, Boolean doInsert, Integer numberOfSObjects)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| mapOfValuesOverride | Map&lt;String,Object&gt; |  |
| doInsert | Boolean |  |
| numberOfSObjects | Integer |  |

###### Return Type
**List&lt;SObject&gt;**

### IDefaultValueProvider Interface

Specifies how default field values are supplied for a given SObject type.

#### Methods
##### `getDefaultMapOfValues(sObjectType, mapOfValuesOverride)`

###### Signature
```apex
public Map<String,IFieldDefaultValue> getDefaultMapOfValues(Schema.SObjectType sObjectType, Map<String,Object> mapOfValuesOverride)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| sObjectType | Schema.SObjectType |  |
| mapOfValuesOverride | Map&lt;String,Object&gt; |  |

###### Return Type
**Map&lt;String,IFieldDefaultValue&gt;**

### IFieldDefaultValue Interface

Common interface fo the field default value classes.

#### Methods
##### `getValue(recordIndex)`

Gets the value wrapped for a given record index.

###### Signature
```apex
public Object getValue(Integer recordIndex)
```

###### Parameters
| Name | Type | Description |
|------|------|-------------|
| recordIndex | Integer |  |

###### Return Type
**Object**