package fr.simplex_software.customer_management.repository;

import javax.enterprise.inject.*;
import javax.persistence.*;

public class EntityManagerProducer
{
  @PersistenceContext(unitName = "customers")
  private EntityManager em;

  @Produces
  public EntityManager createEntityManager()
  {
    return em;
  }
}
