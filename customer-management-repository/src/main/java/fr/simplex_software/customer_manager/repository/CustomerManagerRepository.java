package fr.simplex_software.customer_manager.repository;

import java.math.*;
import java.util.*;

import org.apache.deltaspike.data.api.*;

import fr.simplex_software.customer_management.data.*;

@Repository
public interface CustomerManagerRepository extends EntityRepository<Customer, BigInteger>
{
  public List<Customer> findByFirsName(String firstName);
  public List<Customer> findByLastName (String lastName);
  public List<Customer> findByCountry (String country);
  public List<Customer> findByCity (String city);
  public List<Customer> findByZip (String zip);
  public List<Customer> findByState (String state);
  public List<Customer> findByStreet (String street);
}
