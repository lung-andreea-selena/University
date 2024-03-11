#pragma once
#include "repositoryUser.h"

class ServiceUser
{
private:
	RepositoryUser repository;

public:
	ServiceUser();

	ServiceUser(const RepositoryUser& repositoryy);

	//ServiceUser(const ServiceUser& service);

	~ServiceUser();

	bool addServiceUser(const Dog& dog);

	vector<Dog> getAllServiceUser();

	int getLenghtServiceUser();

};