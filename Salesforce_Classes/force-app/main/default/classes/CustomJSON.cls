public with sharing class CustomJSON {
    public CustomJSON() {
        addressLocator();
       /* JSONGenerator gen = JSON.createGenerator(true);
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeNumberField('abc', 1.21);
        gen.writeStringField('def', 'xyz');
        gen.writeFieldName('ghi');
        gen.writeStartObject();
        List<integer> intlist = new List<integer>();
        intlist.add(1);
        intlist.add(2);
        intlist.add(3);

        gen.writeObjectField('aaa', intlist);

        gen.writeEndObject();

        gen.writeFieldName('Object A');

        gen.writeObject(new Account());

        gen.writeEndObject();

        // Get the JSON string.
        String pretty = gen.getAsString();
        system.debug('Pretty : '+pretty); */

    }

    public static void addressLocator(){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeFieldName('IntegrationEntities');
        gen.writeStartObject();
        gen.writeFieldName('integrationEntity');
        gen.writeStartArray();
        gen.writeStartObject();
        gen.writeFieldName('integrationEntityHeader');
        gen.writeStartObject();
        gen.writeStringField('integrationTrackingNumber', '4734847');
        gen.writeStringField('referenceCodeForEntity', 'ADD001434');
        gen.writeStringField('additionalInfo', 'ADDITIONALINFO');
        gen.writeEndObject();
        
        // for address details Start 
        gen.writeFieldName('integrationEntityDetails');
        gen.writeStartObject();
        gen.writeFieldName('address');
        gen.writeStartObject();
        gen.writeStringField('id', '4734847');
        gen.writeStringField('status', 'ADD001434');
        gen.writeStringField('addressName', 'ADDITIONALINFO');
        gen.writeStringField('addressLine1', 'ADDITIONALINFO');
        gen.writeStringField('addressLine2', 'ADDITIONALINFO');
        gen.writeStringField('addressLine3', 'ADDITIONALINFO');
        gen.writeStringField('addressLine4', 'ADDITIONALINFO');
        gen.writeStringField('url', 'ADDITIONALINFO');
        gen.writeStringField('phone', 'ADDITIONALINFO');
        gen.writeStringField('fax', 'ADDITIONALINFO');
        gen.writeStringField('email', 'ADDITIONALINFO');
        gen.writeStringField('countryId', 'ADDITIONALINFO');
        gen.writeStringField('stateId', 'ADDITIONALINFO');
        gen.writeStringField('county', 'ADDITIONALINFO');
        gen.writeStringField('stateId', 'ADDITIONALINFO');
        gen.writeStringField('city', 'ADDITIONALINFO');
        gen.writeStringField('zipCode', 'ADDITIONALINFO');
        gen.writeStringField('isShipToAddress', 'ADDITIONALINFO');
        gen.writeStringField('isBillToAddress', 'ADDITIONALINFO');
        gen.writeStringField('isInvoiceToAddress', 'ADDITIONALINFO');
        gen.writeStringField('isWarehouseAddress', 'ADDITIONALINFO');
        gen.writeStringField('erpId', 'ADDITIONALINFO');
        gen.writeStringField('isWarehouseAddress', 'ADDITIONALINFO');
        gen.writeStringField('createdBy', 'ADDITIONALINFO');
        gen.writeStringField('createdOn', 'ADDITIONALINFO');
        gen.writeStringField('updatedBy', 'ADDITIONALINFO');
        gen.writeStringField('updatedOn', 'ADDITIONALINFO');
        gen.writeEndObject();
        gen.writeEndObject();
        gen.writeEndObject();
        // for address details end
        gen.writeEndArray();
        gen.writeEndObject();
        gen.writeEndObject();
        String pretty = gen.getAsString();
        system.debug('Pretty : '+pretty);
    }
}