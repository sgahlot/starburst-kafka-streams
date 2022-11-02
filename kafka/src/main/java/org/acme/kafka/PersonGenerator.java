package org.acme.kafka;

import java.time.Duration;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;

import org.acme.kafka.Person.Genre;
import org.eclipse.microprofile.reactive.messaging.Outgoing;
import org.eclipse.microprofile.rest.client.inject.RestClient;
import org.jboss.logging.Logger;

import io.smallrye.mutiny.Multi;

/**
 * A bean producing random person every 5 seconds.
 * The persons are written to a Kafka topic (persons). The Kafka configuration is
 * specified in the application configuration.
 */
@ApplicationScoped
public class PersonGenerator {
    private Logger log = Logger.getLogger(PersonGenerator.class);

    @Outgoing("write-person")
    public Multi<Person> generate() {
        return Multi.createFrom().ticks().every(Duration.ofSeconds(5))
                .onOverflow().drop()
                .map(tick -> {
                    Person p = newPerson();
                    log.infof("Generated random %s", p);
                    return p;
                });
    }

    @Inject
    @RestClient
    NamesClient namesClient;


    private Person newPerson() {
        Person p = new Person();

        p.genre = Genre.random();
        if (p.genre == Genre.M) {
            p.name = namesClient.randomNames(1, NamesClient.BOYS).get(0);
        } else {
            p.name = namesClient.randomNames(1, NamesClient.GIRLS).get(0);
        }
        p.age = (int) (Math.random() * 80);
        return p;
    }

}
