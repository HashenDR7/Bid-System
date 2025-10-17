package lk.jiat.ee.ejb.bean;

import jakarta.ejb.ActivationConfigProperty;
import jakarta.ejb.MessageDriven;
import jakarta.jms.Message;
import jakarta.jms.MessageListener;
import jakarta.jms.TextMessage;

@MessageDriven(
        activationConfig = {
                @ActivationConfigProperty(propertyName = "destinationType", propertyValue = "jakarta.jms.Topic"),
                @ActivationConfigProperty(propertyName = "destinationLookup", propertyValue = "jms/MyTopic")
        }
)
public class BidReceiverBean implements MessageListener {

    @Override
    public void onMessage(Message message) {
        try {
                System.out.println("Bid received: " + message.getBody(String.class));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
