package fr.simplex_software.rest;

import java.math.*;
import java.net.*;

import javax.inject.*;
import javax.ws.rs.*;
import javax.ws.rs.core.*;

import fr.simplex_software.customer_management.data.*;
import fr.simplex_software.customer_management.repository.*;

@Path("/customers")
public class CustomerManagementResource
{
  @Inject
  private CustomerManagementRepository repo;

  @POST
  @Consumes(MediaType.APPLICATION_JSON)
  public Response createCustomer(Customer customer)
  {
    Customer newCustomer = repo.saveAndFlushAndRefresh(customer);
    return Response.created(URI.create("/customers/" + newCustomer.getId())).build();
  }

  @GET
  @Path("{id}")
  @Produces(MediaType.APPLICATION_JSON)
  public Response getCustomer(@PathParam("id") BigInteger id)
  {
    return Response.ok().entity(repo.findBy(id)).build();
  }

  @PUT
  @Path("{id}")
  @Consumes(MediaType.APPLICATION_JSON)
  public Response updateCustomer(@PathParam("id") BigInteger id, Customer customer)
  {
    Customer cust = repo.findBy(id);
    if (cust == null)
      throw new WebApplicationException(Response.Status.NOT_FOUND);
    Customer newCustomer = new Customer(cust);
    customer.setId(cust.getId());
    repo.save(newCustomer);
    return Response.ok().build();
  }

  @DELETE
  @Path("{id}")
  public Response deleteCustomer(@PathParam("id") BigInteger id)
  {
    Customer cust = repo.findBy(id);
    if (cust == null)
      throw new WebApplicationException(Response.Status.NOT_FOUND);
    repo.removeAndFlush(cust);
    return Response.ok().build();
  }
}
