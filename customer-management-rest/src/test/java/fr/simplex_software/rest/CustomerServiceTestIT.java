package fr.simplex_software.rest;

import static org.junit.Assert.*;

import java.util.*;

import javax.ws.rs.client.*;
import javax.ws.rs.core.*;

import org.junit.*;
import org.junit.runners.*;
import org.slf4j.*;

import fr.simplex_software.customer_management.data.*;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class CustomerServiceTestIT
{
  private static Logger slf4jLogger = LoggerFactory.getLogger(CustomerServiceTestIT.class);
  private static Client client;
  private static WebTarget webTarget;
  private static Customer customer = null;

  @Before
  public void setUp() throws Exception
  {
    client = ClientBuilder.newClient();
    webTarget = client.target("http://localhost:8080/customer-management/services/customers");
  }

  @After
  public void tearDown() throws Exception
  {
    if (client != null)
    {
      client.close();
      client = null;
    }
    webTarget = null;
  }

  @Test
  public void test1() throws Exception
  {
    slf4jLogger.debug("*** Create a new Customer ***");
    Customer newCustomer = new Customer("Nick", "DUMINIL", "26 Allée des Sapins", "Soisy sous Montmorency", "None", "95230", "France");
    Response response = webTarget.request().post(Entity.entity(newCustomer, "application/json"));
    assertEquals(201, response.getStatus());
    customer = response.readEntity(Customer.class);
    assertNotNull(customer);
    String location = response.getLocation().toString();
    slf4jLogger.debug("*** Location: " + location + " ***");
    response.close();
  }
  
  @Test
  public void test2()
  {
    String customerId = customer.getId().toString();
    slf4jLogger.debug("*** Get a Customer with ID {} ***", customerId);
    Response response = webTarget.path(customerId).request().get();
    assertEquals(200, response.getStatus());
    customer = response.readEntity(Customer.class);
    assertNotNull(customer);
    assertEquals(customer.getCountry(), "France");
  }
  
  @Test
  public void test3()
  {
    String firstName = customer.getFirstName();
    slf4jLogger.debug("*** Get a Customer by first name {} ***", firstName);
    Response response = webTarget.path("firstName").path(firstName).request().get();
    assertEquals(200, response.getStatus());
    List<Customer> customers = response.readEntity(new GenericType<List<Customer>>(){});
    assertNotNull(customers);
    assertTrue (customers.size() > 0);
    customer = customers.get(0);
    assertNotNull(customer);
    assertEquals(customer.getCountry(), "France");    
  }
  
  @Test
  public void test4()
  {
    String customerId = customer.getId().toString();
    slf4jLogger.debug("*** Update the customer with ID {} ***", customerId);
    customer.setCountry("Belgium");
    Response response = webTarget.path(customerId).request().put(Entity.entity(customer, "application/json"));
    assertEquals(200, response.getStatus());
  }
  
  @Test
  public void test5()
  {
    String customerId = customer.getId().toString();
    slf4jLogger.debug("*** Delete the customer with ID {} ***", customerId);
    Response response = webTarget.path(customerId).request().delete();
    assertEquals(200, response.getStatus());
  }
  
  @Test
  public void test6()
  {
    Response response = webTarget.request().get();
    assertEquals(200, response.getStatus());
    List<Customer> customers = response.readEntity(new GenericType<List<Customer>>(){});
    assertNotNull(customers);
    assertTrue (customers.size() > 0);
    customer = customers.get(0);
    assertNotNull(customer);
    assertEquals(customer.getCountry(), "France");    
  }
}
