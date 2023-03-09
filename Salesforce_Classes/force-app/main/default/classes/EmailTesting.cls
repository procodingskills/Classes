global class EmailTesting implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          Contact con = new Contact();
          con.LastName = 'Pavani';
          con.FirstName='Test';
          Insert con;
          return result;
      }
  }