package org.acme.kafka;

import javax.enterprise.context.ApplicationScoped;

import org.eclipse.microprofile.reactive.messaging.Acknowledgment;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.jboss.logging.Logger;

/**
 * A bean consuming data from the "prices" Kafka topic and applying some
 * conversion.
 * The result is pushed to the "my-data-stream" stream which is an in-memory
 * stream.
 */
@ApplicationScoped
public class PersonReceiver {
    private Logger log = Logger.getLogger(PersonReceiver.class);

    @Incoming("get-person")
    @Acknowledgment(Acknowledgment.Strategy.POST_PROCESSING)
    public void process(Person p) {
        log.infof("PersonReceiver received %s", p);
    }

}
