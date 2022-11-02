package org.acme.kafka;

import javax.enterprise.context.ApplicationScoped;

import org.eclipse.microprofile.reactive.messaging.Acknowledgment;
import org.eclipse.microprofile.reactive.messaging.Incoming;
import org.eclipse.microprofile.reactive.messaging.Outgoing;
import org.jboss.logging.Logger;

import io.smallrye.reactive.messaging.annotations.Broadcast;

/**
 * A bean consuming data from the "prices" Kafka topic and applying some
 * conversion.
 * The result is pushed to the "my-data-stream" stream which is an in-memory
 * stream.
 */
@ApplicationScoped
public class PersonLogger {
    private Logger log = Logger.getLogger(PersonLogger.class);

    // Consume from the `persons` channel and produce to the `my-data-stream`
    // channel
    @Incoming("read-person")
    @Outgoing("my-data-stream")
    // Send to all subscribers
    @Broadcast
    // Acknowledge the messages before calling this method.
    @Acknowledgment(Acknowledgment.Strategy.POST_PROCESSING)
    public Person process(Person p) {
        log.infof("PersonLogger received %s", p);
        return p;
    }

}
