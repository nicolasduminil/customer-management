package fr.simplex_software.customer_management.facade;

import java.math.*;
import java.util.*;

import javax.ejb.*;
import javax.enterprise.inject.*;
import javax.inject.*;
import javax.persistence.*;
import javax.persistence.metamodel.*;

import org.apache.commons.lang3.builder.*;
import org.slf4j.*;

import fr.simplex_software.customer_management.data.*;
import fr.simplex_software.customer_management.repository.*;

@Stateless
public class CustomerManagementFacade
{
  private static Logger slf4jLogger = LoggerFactory.getLogger(CustomerManagementFacade.class);

  @Inject
  private CustomerManagementRepository repo;
  
  @Produces
  @PersistenceContext
  private static EntityManager entityManager;

  
  public List<Customer> findByFirstName(String firstName)
  {
    slf4jLogger.debug("*** findByFirstName: {}", firstName);
    return repo.findByFirstName(firstName);
  }
  
  public List<Customer> findByLastName(String lastName)
  {
    return repo.findByLastName(lastName);
  }

  
  public List<Customer> findByCountry(String country)
  {
    return repo.findByCountry(country);
  }

  
  public List<Customer> findByCity(String city)
  {
    return repo.findByCity(city);
  }

  
  public List<Customer> findByZip(String zip)
  {
    return null;
  }

  
  public List<Customer> findByState(String state)
  {
    return repo.findByState(state);
  }

  
  public List<Customer> findByStreet(String street)
  {
    return repo.findByStreet(street);
  }

  
  public List<Customer> findAll()
  {
    return repo.findAll();
  }

  
  public List<Customer> findAll(int customer, int arg1)
  {
    return repo.findAll(customer, arg1);
  }

  
  public Customer findBy(BigInteger customerId)
  {
    slf4jLogger.debug("*** findBy: {}", customerId);
    return repo.findBy(customerId);
  }

  
  public List<Customer> findBy(Customer customer, @SuppressWarnings("unchecked") SingularAttribute<Customer, ?>... attribs)
  {
    return repo.findBy(customer, attribs);
  }

  
  public List<Customer> findBy(Customer customer, int start, int max, @SuppressWarnings("unchecked") SingularAttribute<Customer, ?>... attribs)
  {
    return repo.findBy(customer, start, max, attribs);
  }

  
  public List<Customer> findByLike(Customer customer, @SuppressWarnings("unchecked") SingularAttribute<Customer, ?>... atrribs)
  {
    return repo.findByLike(customer, atrribs);
  }

  
  public List<Customer> findByLike(Customer customer, int start, int max, @SuppressWarnings("unchecked") SingularAttribute<Customer, ?>... attribs)
  {
    return repo.findByLike(customer, start, max, attribs);
  }

  
  public void attachAndRemove(Customer customer)
  {
    repo.attachAndRemove(customer);
  }

  
  public void flush()
  {
    repo.flush();
  }

  
  public BigInteger getPrimaryKey(Customer customer)
  {
    return repo.getPrimaryKey(customer);
  }

  
  public void refresh(Customer customer)
  {
    repo.refresh(customer);
  }

  
  public void remove(Customer customer)
  {
    repo.remove(customer);
  }

  
  public void removeAndFlush(BigInteger id)
  {
    slf4jLogger.debug("*** removeAndFlush: ID {}", id);
    repo.removeAndFlush(repo.findBy(id));
  }

  
  public Customer save(Customer customer)
  {
    slf4jLogger.debug("*** save(): {}", new ReflectionToStringBuilder(customer).toString());
    return repo.save(customer);
  }

  
  public Customer saveAndFlush(Customer customer)
  {
    return repo.saveAndFlush(customer);
  }

  
  public Customer saveAndFlushAndRefresh(Customer customer)
  {
    return repo.saveAndFlushAndRefresh(customer);
  }

  
  public Long count()
  {
    return repo.count();
  }

  
  public Long count(Customer customer, @SuppressWarnings("unchecked") SingularAttribute<Customer, ?>... attribs)
  {
    return repo.count(customer, attribs);
  }

  
  public Long countLike(Customer customer, @SuppressWarnings("unchecked") SingularAttribute<Customer, ?>... attribs)
  {
    return repo.countLike(customer, attribs);
  }
}
