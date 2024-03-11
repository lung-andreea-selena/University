#include "tests.h"
#include "repository.h"
#include "service.h"
#include "repositoryUser.h"
#include "serviceUser.h"
#include <cassert>

using namespace std;

void testDomain()
{
	Dog dog{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	assert(dog.breedGetter() == "Maltipoo");
	assert(dog.nameGetter() == "Zomy");
	assert(dog.ageGetter() == 5);
	assert(dog.photoGetter() == "https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp");
	dog.ageSetter(8);
	dog.photoSetter("https://a-z-animals.com/media/2021/02/shutterstock_1403831096-e1659970560966.jpg");
	assert(dog.ageGetter() == 8);
	assert(dog.photoGetter() == "https://a-z-animals.com/media/2021/02/shutterstock_1403831096-e1659970560966.jpg");
}

void testRepository()
{
	Repository repo{};
	Dog dog1{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	assert(repo.checkIfAlreadyExistDog(dog1.breedGetter(),dog1.nameGetter()) == false);
	assert(repo.checkIfAlreadyExistDog("Beagle", "Bobo") == true);
	vector<Dog> dogs = repo.getAllRepository();
	assert(dogs.size() == 10);
	assert(repo.addRepository(dog1) == true);
	Dog dog2{ "Beagle","Bobo",5,"asdfghjkl" };
	assert(repo.addRepository(dog2) == false);
	assert(repo.getLengthRepository() == 11);
	assert(repo.removeRepository("Maltipoo", "Zomy") == true);
	assert(repo.removeRepository("Maltipoo", "Alabala") == false);
	auto iterator = repo.getIteratorByBreedAndName("Beagle", "Bobo");
	assert(repo.updateRepository("Beagle", "Bobo", 4, "asdfghj") == true);
	assert(repo.updateRepository("Beaglee", "Zozo", 6, "asdfgh") == false);
	Repository copyConstructor{ repo.getAllRepository() };
	assert(copyConstructor.addRepository(dog2) == false);
	Dog dog3{ "Maltese","Micky",4,"https://www.petfinder.com/static/c96d31ec1b02dc3fd026b3def12e703f/01623/maltese-card-medium.webp" };
	assert(copyConstructor.addRepository(dog3) == true);

}

void testRepositoryUser()
{
	RepositoryUser repo{};
	Dog dog1{ "Maltipoo","Zomy",5,"https://www.petfinder.com/static/5c05429636dcc36d84076bab8600b029/a647e/maltipoo-dog-breed.webp" };
	assert(repo.checkIfAlreadyAdopted(dog1.breedGetter(), dog1.nameGetter()) == false);
	assert(repo.addRepositoryUser(dog1) == true);
	assert(repo.checkIfAlreadyAdopted(dog1.breedGetter(), dog1.nameGetter()) == true);
	assert(repo.addRepositoryUser(dog1) == false);
	vector<Dog> adoptedDogs = repo.getAllRepositoryUser();
	assert(adoptedDogs.size() == repo.getLengthRepositoryUser());
	RepositoryUser copyConstructor(repo.getAllRepositoryUser());
	assert(copyConstructor.addRepositoryUser(dog1) == false);
}

void testService()
{
	Repository repo;
	Service service{};
	Dog dog3{ "Maltese","Micky",4,"https://www.petfinder.com/static/c96d31ec1b02dc3fd026b3def12e703f/01623/maltese-card-medium.webp" };
	assert(service.addService(dog3) == true);
	assert(service.addService(dog3) == false);
	vector<Dog> dogs = service.getAllService();
	assert(dogs.size() == service.getLenghtService());
	assert(service.updateService("Maltese", "Micky", 8, "asdftgyhuji") == true);
	assert(service.updateService("Makdj", "KJH", 7, "sdfghgfds") == false);
	assert(service.removeService("Maltese", "Micky") == true);
	assert(service.removeService("Maltese", "Micky") == false);
	Service copyConstructor{ repo };

}

void testServiceUser()
{
	RepositoryUser repo{};
	ServiceUser service{};
	Dog dog4 {"Havanese", "Zack", 5, "https://www.petfinder.com/static/162d0111407774435b86dead094cb1f8/211a2/havanese-detail-scaled.webp"};
	assert(service.addServiceUser(dog4) == true);
	assert(service.addServiceUser(dog4) == false);
	vector<Dog> adoptedDogs = service.getAllServiceUser();
	assert(adoptedDogs.size() == service.getLenghtServiceUser());
	ServiceUser copyConstructor{ repo };
}

void testAll()
{
	testDomain();
	testRepository();
	testRepositoryUser();
	testService();
	testServiceUser();
}