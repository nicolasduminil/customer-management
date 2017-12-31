package fr.simplex_software.rest;

import java.math.*;
import java.net.*;

import javax.ejb.*;
import javax.ws.rs.*;
import javax.ws.rs.core.*;

import org.apache.commons.lang3.builder.*;
import org.jboss.resteasy.spi.*;
import org.keycloak.*;
import org.keycloak.representations.*;
import org.slf4j.*;

import fr.simplex_software.customer_management.data.*;
import fr.simplex_software.customer_management.facade.*;

@Path("/customers")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CustomerManagementResource
{
  private Logger slf4jLogger = LoggerFactory.getLogger(CustomerManagementResource.class);

  @Context
  private HttpRequest httpRequest;

  @EJB
  private CustomerManagementFacade facade;

  @POST
  public Response createCustomer(Customer customer)
  {
    slf4jLogger.debug("*** createCustomer(): {}", new ReflectionToStringBuilder(customer).toString());
    Customer newCustomer = facade.saveAndFlushAndRefresh(customer);
    return Response.created(URI.create("/customers/" + newCustomer.getId())).entity(newCustomer).build();
  }

  @GET
  @Path("{id}")
  public Response getCustomer(@PathParam("id") BigInteger id)
  {
    slf4jLogger.debug("*** getCustomer(): ID {}", id);
    return Response.ok().entity(facade.findBy(id)).build();
  }

  @PUT
  @Path("{id}")
  public Response updateCustomer(@PathParam("id") BigInteger id, Customer customer)
  {
    slf4jLogger.debug("*** updateCustomer(): {}", new ReflectionToStringBuilder(customer).toString());
    Customer cust = facade.findBy(id);
    if (cust == null)
      throw new WebApplicationException(Response.Status.NOT_FOUND);
    Customer newCustomer = new Customer(cust);
    customer.setId(cust.getId());
    facade.save(newCustomer);
    return Response.ok().build();
  }

  @DELETE
  @Path("{id}")
  public Response deleteCustomer(@PathParam("id") BigInteger id)
  {
    slf4jLogger.debug("*** deleteCustomer(): ID {}", id);
    facade.removeAndFlush(id);
    return Response.ok().build();
  }

  @GET
  @Path("firstName/{firstName}")
  public Response getCustomersByFirstName(@PathParam("firstName") String firstName)
  {
    slf4jLogger.debug("*** getCustomerByFirstName(): {}", firstName);
    return Response.ok().entity(facade.findByFirstName(firstName)).build();
  }

  @GET
  public Response getCustomers()
  {
    KeycloakSecurityContext securityContext = (KeycloakSecurityContext) httpRequest.getAttribute(KeycloakSecurityContext.class.getName());
    AccessToken accessToken = securityContext.getToken();
    slf4jLogger.info("User {} with email {} made request to /customers REST endpoint", accessToken.getPreferredUsername(), accessToken.getEmail());
    return Response.ok().entity(facade.findAll()).build();
  }

  @GET
  @Path("secured")
  public String getSecured()
  {
    return new String("secured");
  }
}
