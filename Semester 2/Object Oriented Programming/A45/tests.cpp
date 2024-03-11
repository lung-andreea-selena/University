#include <cassert>
#include <string>
#include "ui.h"
#include "service.h"
#include "serviceUser.h"
#include "repository.h"
#include "repositoryUser.h"
#include "dynamicarray.h"
#include "domain.h"
#include "tests.h"

void testDomain()
{
	Dog dog{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	assert(dog.breedGetter() == "Maltipoo");
	assert(dog.nameGetter() == "Zomy");
	assert(dog.ageGetter() == 5);
	assert(dog.photoGetter() == "https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp");
}

void testDynamicArray()
{
	DynamicArray<Dog> dynamicArray;
	assert(dynamicArray.getLengthOfDynamicArray() == 0);
	Dog dog1{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	dynamicArray.add(dog1);
	Dog dog2{ "Maltese","Micky",4,"https://www.petfinder.com/static/c96d31ec1b02dc3fd026b3def12e703f/01623/maltese-card-medium.webp" };
	dynamicArray.add(dog2);
	assert(dynamicArray.getLengthOfDynamicArray() == 2);
	Dog dog3{ "Havanese","Zack",5,"https://www.petfinder.com/static/162d0111407774435b86dead094cb1f8/211a2/havanese-detail-scaled.webp" };
	dynamicArray.updateElement(1, dog3);
	assert(dynamicArray.getLengthOfDynamicArray() == 2);
}

void testRepository()
{
	Repository repo;
	DynamicArray<Dog> dynamicArray;
	Dog dog1{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	assert(repo.addRepository(dog1)==true);
	Dog dog2{ "Maltese","Micky",4,"https://www.petfinder.com/static/c96d31ec1b02dc3fd026b3def12e703f/01623/maltese-card-medium.webp" };
	assert(repo.addRepository(dog2)==true);
	assert(repo.getLengthRepository()==12);
	Dog dog3{ "Havanese","Zack",5,"https://www.petfinder.com/static/162d0111407774435b86dead094cb1f8/211a2/havanese-detail-scaled.webp" };
	repo.updateRepository(1, dog3);
	assert(repo.getLengthRepository() == 12);

}

void testRepositoryUser()
{
	RepositoryUser repoUser;
	DynamicArray<Dog> dynamicArray;
	Dog dog1{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	assert(repoUser.addRepositoryUser(dog1)==true);
	Dog dog2{ "Maltese","Micky",4,"https://www.petfinder.com/static/c96d31ec1b02dc3fd026b3def12e703f/01623/maltese-card-medium.webp" };
	assert(repoUser.addRepositoryUser(dog2)==true);
	assert(repoUser.checkIfAlreadyAdopted(dog1) != -1);
}

void testService()
{
	Service service;
	Repository repo;
	DynamicArray<Dog> dynamicArray;
	assert(service.getLenghtService() == 10);
	Dog dog1{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	service.addService(dog1);
	assert(service.getLenghtService() == 11);
	assert(service.searchDogByBreedAndName("Maltipoo", "Zomy") != -1);
	service.updateService("Maltipoo", "Zomy", 4, "https://www.petfinder.com/static/c96d31ec1b02dc3fd026b3def12e703f/01623/maltese.webp");

}

void testServiceUser()
{
	ServiceUser serviceUser;
	RepositoryUser repoUser;
	DynamicArray<Dog> dynamicArray;
	Dog dog1{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	assert(repoUser.addRepositoryUser(dog1) == 0);
	Dog dog2{ "Maltese","Micky",4,"https://www.petfinder.com/static/c96d31ec1b02dc3fd026b3def12e703f/01623/maltese-card-medium.webp" };
	assert(repoUser.addRepositoryUser(dog2) == true);
	assert(repoUser.checkIfAlreadyAdopted(dog1) != -1);
	assert(repoUser.getLengthRepositoryUser() == 12);

}

void tests()
{
	testDomain();
	testDynamicArray();
	testRepository();
	testRepositoryUser();
	testService();
}