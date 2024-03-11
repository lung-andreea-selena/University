#pragma once
#include "repositoryUser.h"
#include "repositoryUser.h"

class ServiceUser
{
private:
	RepositoryUser repository;

public:
	ServiceUser();

	ServiceUser(const RepositoryUser& repositoryy);

	ServiceUser(const ServiceUser& service);

	~ServiceUser();

	int addServiceUser(Dog dog);

	DynamicArray<Dog> getAllServiceUser();

	int getLenghtServiceUser();

};