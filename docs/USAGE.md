## Usage 



#### Installation

Install the ``TDF`` class by coping the apex code or using the Ant Migration Tools

The ``TDF`` class is provided with a test class ``TDFTest``

You can install only the ``TDF`` class and add the ``@isTest`` annotation on it, in order to exclude it from the organization code size limit 

#### Configure TDF Class 

There is a configuration related to orgs that have person account enabled 

  ```apex
public class TDF {

	// Org config
	// ==========================================================================
	private static final Boolean PERSON_ACCOUNT_IS_ENABLED = true | false;
	// ==========================================================================
  ```

## Next

* [Examples](EXAMPLES.md) 
