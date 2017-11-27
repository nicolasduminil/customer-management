package fr.simplex_software.customer_management.repository;

import java.math.*;
import java.util.*;

import org.apache.deltaspike.data.api.*;

import fr.simplex_software.customer_management.data.*;

@Repository
public interface CustomerManagementRepository extends EntityRepository<Customer, BigInteger>, EntityManagerDelegate<Customer>
{
  public List<Customer> findByLastName (String lastName);
  public List<Customer> findByCountry (String country);
  public List<Customer> findByCity (String city);
  public List<Customer> findByZip (String zip);
  public List<Customer> findByState (String state);
  public List<Customer> findByStreet (String street);
  public List<Customer> findByFirstName(String firstName);
}
