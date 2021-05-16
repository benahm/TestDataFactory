### Generate an Unlocked Package 

Create the package

    sfdx force:package:create --name ApexTestDataFactory --packagetype Unlocked --path force-app --targetdevhubusername MyDevOrg

Note : if there is already a promoted package version, update the version in `sfdx-project.json` before generating a new version    

Create a package version 
    
    sfdx force:package:version:create --package ApexTestDataFactory --codecoverage --installationkeybypass --wait 20

Promote the package version

    sfdx force:package:version:promote --package "04t..." 