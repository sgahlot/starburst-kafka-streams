package org.acme.kafka;

import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.QueryParam;

import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;


@Path("/")
@RegisterRestClient
public interface NamesClient {
    final static String BOYS = "boy_names";
    final static String GIRLS = "girl_names";

    @GET
    @Path("/{size}")
    List<String> randomNames(@PathParam("size") int size, @QueryParam("nameOptions") String nameOptions);
}
