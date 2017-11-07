package fr.simplex_software.customer_management.data;

import java.io.*;
import java.math.*;

import javax.persistence.*;

public class Customer implements Serializable
{
  private static final long serialVersionUID = 1L;
  private BigInteger id;
  private String firstName;
  private String lastName;
  private String street;
  private String city;
  private String state;
  private String zip;
  private String country;

  public Customer()
  {
  }

  public Customer(String firstName, String lastName, String street, String city, String state, String zip, String country)
  {
    this.lastName = lastName;
    this.street = street;
    this.city = city;
    this.state = state;
    this.zip = zip;
    this.country = country;
  }
  
  public Customer (Customer customer)
  {
    this (customer.firstName, customer.lastName, customer.street, customer.city, customer.state, customer.zip, customer.country);
  }
  

  @Id
  @SequenceGenerator(name = "CUSTOMERS_ID_GENERATOR", sequenceName = "CUSTOMERS_SEQ")
  @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "CUSTOMERS_ID_GENERATOR")
  @Column(name = "CUSTOMER_ID", unique = true, nullable = false, length = 8)
  public BigInteger getId()
  {
    return id;
  }

  public void setId(BigInteger id)
  {
    this.id = id;
  }

  @Column(name = "FIRST_NAME", nullable = false, length = 40)
  public String getFirstName()
  {
    return firstName;
  }

  public void setFirstName(String firstName)
  {
    this.firstName = firstName;
  }

  @Column(name = "LAST_NAME", nullable = false, length = 40)
  public String getLastName()
  {
    return lastName;
  }

  public void setLastName(String lastName)
  {
    this.lastName = lastName;
  }

  @Column(name = "ADDRESS_STREET", nullable = false, length = 80)
  public String getStreet()
  {
    return street;
  }

  public void setStreet(String street)
  {
    this.street = street;
  }

  @Column(name = "ADDRESS_CITY", nullable = false, length = 80)
  public String getCity()
  {
    return city;
  }

  public void setCity(String city)
  {
    this.city = city;
  }

  @Column(name = "ADDRESS_STATE", nullable = false, length = 40)
  public String getState()
  {
    return state;
  }

  public void setState(String state)
  {
    this.state = state;
  }

  @Column(name = "ADDRESS_ZIP", nullable = false, length = 8)
  public String getZip()
  {
    return zip;
  }

  public void setZip(String zip)
  {
    this.zip = zip;
  }

  @Column(name = "ADDRESS_COUNTRY", nullable = false, length = 40)
  public String getCountry()
  {
    return country;
  }

  public void setCountry(String country)
  {
    this.country = country;
  }
}
