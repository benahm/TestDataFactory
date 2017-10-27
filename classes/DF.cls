/**
* @author benahm
* @date 2017
* @description DF Class
*/
public class DF {
	private static final String DOT = '.';
	private static final Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

	private interface ISObjectManager{
		void setSObject(SObject sObj);
		SObject getSObject();
		void setRelationship(String relationshipName, SObject sObj);
		SObject getRelationship(String relationshipName);
		void insertAllSObjects(SObject sObj);
	}

	private abstract class ASObjectManager implements ISObjectManager{
		public abstract void setSObject(SObject sObj);
		public abstract SObject getSObject();
		public abstract void setRelationship(String relationshipName, SObject sObj);
		public abstract SObject getRelationship(String relationshipName);
		public abstract void insertAllSObjects(SObject sObj);
	}

	private class SObjectManager extends ASObjectManager{
		private SObject mainSObject;
		private Map<String,SObject> relatedSObjectMap = new Map<String,SObject>();
		private List<String> orderedRelationshipList = new List<String>();

		public override void setSObject(SObject sObj){
			mainSObject = sObj;
		}

		public override SObject getSObject(){
			return mainSObject;
		}

		public override void setRelationship(String relationshipName, SObject sObj){
			relatedSObjectMap.put(relationshipName,sObj);
			addRelationshipName(relationshipName);
		}

		public override SObject getRelationship(String relationshipName){
			return relatedSObjectMap.get(relationshipName);
		}

		public override void insertAllSObjects(SObject sObj){
			for(String relationshipName : orderedRelationshipList){
				insert relatedSObjectMap.get(relationshipName);
			}
			insert mainSObject;
		}

		private void addRelationshipName(String relationshipName){
			Integer i=0;
			for (String rName : orderedRelationshipList) {
				if(rName.countMatches('.') < relationshipName.countMatches('.')){
					orderedRelationshipList.add(i, relationshipName);
					return;
				}
				i++;
			}
			orderedRelationshipList.add(relationshipName);
		}
	}


	private interface ISObjectFactory{

		SObject getSObjectInstance(String sObjectName);
		SObject getSObjectInstance(Schema.SObjectType sObjectType);
		SObject getSObjectInstance(String sObjectName, Map<String,Object> mapFieldValues);
		SObject getSObjectInstance(Schema.SObjectType sObjectType, Map<String,Object> mapFieldValues);
	
	}

	private abstract class ASObjectFactory implements ISObjectFactory{

		public abstract SObject getSObjectInstance(String sObjectName);
		public abstract SObject getSObjectInstance(Schema.SObjectType sObjectType);
		public abstract SObject getSObjectInstance(String sObjectName, Map<String,Object> mapFieldValues);
		public abstract SObject getSObjectInstance(Schema.SObjectType sObjectType, Map<String,Object> mapFieldValues);

	}

	private class SObjectFactory extends ASObjectFactory{

		private ISObjectManager sObjManager = new SObjectManager();
		private IDefaultValueProvider dvProvider = new DefaultValueProvider();

		public override SObject getSObjectInstance(String sObjectName){
			return getSObjectInstance(sObjectName,null);
		}

		public override SObject getSObjectInstance(Schema.SObjectType sObjectType){
			return getSObjectInstance(sObjectType,null);
		}


		public override SObject getSObjectInstance(String sObjectName, Map<String,Object> mapFieldValues){
			return getSObjectInstance(globalDescribe.get(sObjectName),mapFieldValues);
		}

		/**
		* @description Generate an sObject 
		* @param sObjectName : sObject name
		* @param mapFieldValues : map of field values
		* @return SObject
		*/
		public override SObject getSObjectInstance(Schema.SObjectType sObjectType, Map<String,Object> mapFieldValues){
			SObject sObj = sObjectType.newSObject(); // instantiate sObject
			sObjManager.setSObject(sObj); 

			for(String fullyQualifiedFieldName : mapFieldValues.keySet()){
				if(fullyQualifiedFieldName.contains(DOT)){ // field with dot notation

					String firstRelationshipName = fullyQualifiedFieldName.substringBefore(DOT);
					String fullyQualifiedRelationshipName = fullyQualifiedFieldName.substringBeforeLast(DOT);
					String fieldName = fullyQualifiedFieldName.substringAfterLast(DOT);

					SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipName);
					relatedSObj.put(fieldName,mapFieldValues.get(fullyQualifiedFieldName)); 

					sObj.putSObject(firstRelationshipName, sObjManager.getRelationship(firstRelationshipName));

				}else { // field name
					sObj.put(fullyQualifiedFieldName,mapFieldValues.get(fullyQualifiedFieldName));
				}

			}

			return sObj;
		}


		/**
		* @description Initiate all the related sObjects for a given fully qualified relationship
		* @param fullyQualifiedRelationshipName : a fully qualified relationship name
		* @return SObject
		*/
		private SObject getRelationshipInstance(Schema.SObjectType sObjectType,String fullyQualifiedRelationshipName){

			SObject sObj = sObjManager.getRelationship(fullyQualifiedRelationshipName);

			if(sObj != null) return sObj;

			if(fullyQualifiedRelationshipName.contains(DOT)){
				System.debug('fullyQualifiedRelationshipName '+fullyQualifiedRelationshipName);
				String fullyQualifiedRelationshipNameBefore = fullyQualifiedRelationshipName.substringBeforeLast(DOT);
				String lastRelationshipName = fullyQualifiedRelationshipName.substringAfterLast(DOT);

				SObject relatedSObj = getRelationshipInstance(sObjectType,fullyQualifiedRelationshipNameBefore);
				
				sObj = getRelatedSObjectInstance(relatedSObj.getSObjectType(),relationshipNameToFieldName(lastRelationshipName)); // get sobject name 
				sObjManager.setRelationship(fullyQualifiedRelationshipName,sObj);
				
				relatedSObj.putSObject(lastRelationshipName,sObj);
				return sObj;
			}else {
				sObj = getRelatedSObjectInstance(sObjectType,relationshipNameToFieldName(fullyQualifiedRelationshipName)); // get sobject name
				sObjManager.setRelationship(fullyQualifiedRelationshipName,sObj);
				return sObj;
			}

		}


		private SObject getRelatedSObjectInstance(Schema.SObjectType sObjectType, String fieldName){
			Map<String, Schema.SObjectField> fieldMap = sObjectType.getDescribe().fields.getMap();
			Schema.DescribeFieldResult fieldDesc = fieldMap.get(fieldName).getDescribe();
			return  fieldDesc.getReferenceTo().get(0).newSObject();
		}


	}

	public interface IDefaultValueProvider{
		Map<String,Object> getDefaultMap(String sObjectName);
		Object getDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Blob getBase64DefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Boolean getBooleanDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getComboboxDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getCurrencyDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Date getDateDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Datetime getDateTimeDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Double getDoubleDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getEmailDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getEncryptedStringDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		ID getIDDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Integer getIntegerDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getMultiPicklistDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Decimal getPercentDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getPhoneDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getPicklistDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getStringDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getTextAreaDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		Time getTimeDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
		String getURLDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);

	}

	public abstract class ADefaultValueProvider implements IDefaultValueProvider{

		public Map<String,Object> getDefaultMap(String sObjectName){
			return getDefaultMap(sObjectName,'');
		}

		private Map<String,Object> getDefaultMap(String sObjectName, String prefix){
			Map<String, Object> defaultValues = new Map<String,Object>();
			Map<String, Schema.SObjectField> fieldMap = globalDescribe.get(sObjectName).getDescribe().fields.getMap();
			Schema.DescribeFieldResult fieldDesc;
			Integer counter = 0;
			for(String fieldName : fieldMap.keySet()){
				fieldDesc = fieldMap.get(fieldName).getDescribe();
				if(!fieldDesc.isDefaultedOnCreate() && !fieldDesc.isNillable() && fieldDesc.isCreateable()){
					if(fieldDesc.getRelationshipName() != null){
						defaultValues.put(prefix+fieldDesc.getRelationshipName()+DOT+'Id',null);
						defaultValues.putAll(getDefaultMap(fieldDesc.getReferenceTo().get(0).getDescribe().getName(),fieldDesc.getRelationshipName()+DOT));
					}else {
						defaultValues.put(prefix+fieldName,getDefaultValue(fieldDesc,counter++));
					}
				}
			}
			return defaultValues;
		}

		public Object getDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
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
			} else if(fieldDesc.getType() == Schema.DisplayType.EncryptedString){
				return getEncryptedStringDefaultValue(fieldDesc,counter);
			} else if(fieldDesc.getType() == Schema.DisplayType.ID){
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
		public abstract String getEncryptedStringDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter);
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


	public class DefaultValueProvider extends ADefaultValueProvider{

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

		public override String getEncryptedStringDefaultValue(Schema.DescribeFieldResult fieldDesc, Integer counter){
			return 'secret'+counter.format();
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


	/* utility methods */

	private static String relationshipNameToFieldName(String relationshipName){
		System.debug(relationshipName);
		if(relationshipName.contains('__r')) // custom relationship 
			return relationshipName.replace('__r', '__c');
		return relationshipName+'Id'; // standard relationship
	
	}

	private static String getDefaultPicklistValue(Schema.DescribeFieldResult fieldDesc){
		if(fieldDesc != null){
			List<Schema.PicklistEntry> pickVals = fieldDesc.getPicklistValues();        
			for (Schema.PicklistEntry pickVal: pickVals) {
			    if (pickVal.isDefaultValue()) {
			        return pickVal.getValue();
			    }    
			}
			// if no default value set
			return pickVals.get(0).getValue();
		}
		return null;
	
	}

}