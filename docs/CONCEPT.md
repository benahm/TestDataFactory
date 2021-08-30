
## Core concepts 💡

This Apex Test Data Factory (TestDataFactory) uses the [Apex Describe Information](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dynamic_describe_objects_understanding.htm) to automatically detect and fill all the required fields of an sObject

### Overview

Overview of the internal classes of the TestDataFactory


<p align="center"><img src ="./assets/overview.png"/></p>



TestDataFactory internal classes list

| Class name                            | Description                                           |
|---------------------------------------|-------------------------------------------------------|
| **TestDataFactory**                               | The containing class                                  |
| **ObjectFactory**                     | Instantiate the sObject and all the related sObjects  |
| **ObjectManager**                     | Contains all the sObjects instances, insertAll method |
| **DefaultValueProvider**              | Virtual class that provide all default field values   |
| **AutoFieldDefaultValue**             | Wrapper of an auto generated default value            |
| **FieldDefaultValue**                 | Wrapper of a field default value                      |
| **ListFieldDefaultValue**             | Wrapper of a list of field default values             |
| **RelationshipFieldDefaultValue**     | Wrapper of a lookup field default value               |
| **ListRelationshipFieldDefaultValue** | Wrapper of a list of lookup field default values      |

For more details please visit the [TestDataFactory ApexDox](http://test-data-factory.surge.sh/)

## Next

* [Performance 🚀](PERFORMANCE.md)
