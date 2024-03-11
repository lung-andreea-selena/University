#include "ui.h"
#include <iostream>
#include <Windows.h>
#include <shellapi.h>
#include <crtdbg.h>
#include"tests.h"
using namespace std;

constexpr auto MAIN_ADMIN = 1;
constexpr auto MAIN_USER = 2;
constexpr auto MAIN_EXIT = 0;
constexpr auto ADMIN_ADD = 1;
constexpr auto ADMIN_REMOVE = 2;
constexpr auto ADMIN_UPDATE = 3;
constexpr auto ADMIN_DISPLAY = 4;
constexpr auto ADMIN_EXIT = 0;
constexpr auto USER_SEE_ALL = 1;
constexpr auto USER_SEE_ALL_GIVEN = 2;
constexpr auto USER_ADOPTION_LIST = 3;
constexpr auto USER_EXIT = 0;

Ui::Ui()
{
}

Ui::Ui(const Service& servicee, const ServiceUser& serviceuser):service{servicee}, serviceUser{serviceuser}
{
}

Ui::Ui(const Ui& ui)
{
	this->service = ui.service;
	this->serviceUser = ui.serviceUser;
}

Ui::~Ui() = default;

void Ui::mainMenu()
{
	cout << endl;
	cout << "MAIN MENU" << endl;
	cout << "Please select the mode:" << endl;
	cout << "1. Administrator mode" << endl;
	cout << "2. User Mode" << endl;
	cout << "0. Exit the app" << endl;
}

void Ui::administratorMode()
{
	cout << endl;
	cout << "ADMINISTRATOR MODE" << endl;
	cout << "1. Add a dog" << endl;
	cout << "2. Remove a dog" << endl;
	cout << "3. Update a dog" << endl;
	cout << "4. Display all dogs" << endl;
	cout << "0. Exit Administrator mode" << endl;
}

void Ui::addAdministratorMode()
{
	string breed, name, photo;
	int age;
	cout << "Breed:" << endl;
	cin >> breed;
	cout << "Name:" << endl;
	cin >> name;
	cout << "Age:" << endl;
	cin >> age;
	if (age <= 0)
	{
		throw "Age must be more than 0";
	}
	else
	{
		cout << "Photo link:" << endl;
		cin >> photo;
		
		Dog dog{ breed,name,age,photo };
		if (this->service.addService(dog))
			cout << "Dog added successfully" << endl;
		else
			cout << "Dog already exists" << endl;
	}
}

void Ui::removeAdministratorMode()
{
	string breed, name;
	cout << "Breed of the dog you want to remove:" << endl;
	cin >> breed;
	cout << "Name of the dog you want to remove:" << endl;
	cin >> name;
	if (this->service.removeService(breed, name))
		cout << "The dog was removed successfully" << endl;
	else
		cout << "The dog you want to remove is not in the database" << endl;
}

void Ui::displayAdministratorMode()
{
	DynamicArray<Dog> dogs = this->service.getAllService();
	int index = 0;
	int numberOfDogs = this->service.getLenghtService();
	if (numberOfDogs == 0)
		throw "There are no dogs in the shelter!";
	for (index = 0; index < numberOfDogs; index++)
	{
		cout << index+1 << ". " << "Breed: " << dogs[index].breedGetter() << " | Name: " << dogs[index].nameGetter() << " | Age: " << dogs[index].ageGetter() << " | Photo: " << dogs[index].photoGetter() << endl;
	}
}

void Ui::updateAdministratorMode()
{
	string breed, name;
	cout << "Breed of the dog you want to update:" << endl;
	cin >> breed;
	cout << "Name of the dog you want to update:" << endl;
	cin >> name;
	if (this->service.searchDogByBreedAndName(breed, name) == -1)
	{
		cout << "This dog is not in the database" << endl;
	}
	else
	{
		string newPhoto;
		int newAge;
		cout << "The new age" << endl;
		cin >> newAge;
		cout << "New photo link" << endl;
		cin >> newPhoto;
		if (newAge <= 0)
			cout << "Age has to be more than 0" << endl;
		else
		{
			if (this->service.updateService(breed, name, newAge, newPhoto))
				cout << "Dog updated successfully" << endl;
			else
				cout << "Dog could not be updated" << endl;
		}
	}
}

void Ui::userMode()
{
	cout << endl;
	cout << "USER MODE" << endl;
	cout << "1. See the dogs available for adoption" << endl;
	cout << "2. See all the dogs of the given breed having an age less than a given number " << endl;
	cout << "3. See the adoption list" << endl;
	cout << "0. Exit" << endl;
}

void Ui::adoptionUserMode()
{
	cout << "1. Adopt dog" << endl;
	cout << "2. Next" << endl;
	cout << "0. Exit" << endl;
}

int Ui::adoptionDogs()
{
	DynamicArray<Dog> dogs = this->service.getAllService();
	for (int i = 0; i < this->service.getLenghtService(); i++)
	{
		ShellExecuteA(NULL, NULL, "chrome.exe", dogs[i].photoGetter().c_str(), NULL, SW_SHOWMAXIMIZED);
		cout << "Breed: " << dogs[i].breedGetter() << " | Name: " << dogs[i].nameGetter() << " | Age: " << dogs[i].ageGetter()<<endl;
		this->adoptionUserMode();
		int commandAdoption;
		cout << "Command for adoption:";
		cin >> commandAdoption;
		if (commandAdoption == 1)
		{
			if (this->serviceUser.addServiceUser(dogs[i]) == 0)
			{
				cout << "Dog added to adoption list" << endl;
			}
			else
				cout << "You already adopted this dog" << endl;
			
		}
		if (commandAdoption == 0)
			return 1;
	}
	return 0;
}


void Ui::displayAdoptionList()
{
	DynamicArray<Dog> dogs = this->serviceUser.getAllServiceUser();
	int index = 0;
	int numberOfDogs = this->serviceUser.getLenghtServiceUser();
	if (numberOfDogs == 0)
		throw "There are no dogs in the shelter!";
	for (index = 0; index < numberOfDogs; index++)
	{
		cout << index+1 << ". " << "Breed: " << dogs[index].breedGetter() << " | Name: " << dogs[index].nameGetter() << " | Age: " << dogs[index].ageGetter() << " | Photo: " << dogs[index].photoGetter() << endl;
	}
}

int Ui::seeAllOfGiveBreedAndAge(string breed,int age)
{
	DynamicArray<Dog> dogs = this->service.getAllService();
	for (int i = 0; i < this->service.getLenghtService(); i++)
	{
		
		if (dogs[i].breedGetter() == breed && dogs[i].ageGetter() < age)
		{
			ShellExecuteA(NULL, NULL, "chrome.exe", dogs[i].photoGetter().c_str(), NULL, SW_SHOWMINIMIZED);
			cout << "Breed: " << dogs[i].breedGetter() << " | Name: " << dogs[i].nameGetter() << " | Age: " << dogs[i].ageGetter() << endl;
			this->adoptionUserMode();
			int commandAdoption;
			cout << "Command for adoption:";
			cin >> commandAdoption;
			if (commandAdoption == 1)
			{
				if (this->serviceUser.addServiceUser(dogs[i]))
				{
					cout << "Dog added to adoption list" << endl;
				}
				else
					cout << "You already adopted this dog" << endl;

			}
			if (commandAdoption == 0)
				return 1;
		}
	}
	return 0;

}

void Ui::startUi()
{
	int command = 0;
	while (true)
	{
		this->mainMenu();
		cout << "Command:";
		cin >> command;
		if (command == MAIN_ADMIN)
		{
			while (true)
			{
				this->administratorMode();
				int commanAdministrator = 0;
				cout << "Command administrator mode:";
				cin >> commanAdministrator;
				if (commanAdministrator == ADMIN_ADD)
				{
					this->addAdministratorMode();
				}
				if (commanAdministrator == ADMIN_REMOVE)
				{
					this->removeAdministratorMode();
				}
				if (commanAdministrator == ADMIN_UPDATE)
				{
					this->updateAdministratorMode();
				}
				if (commanAdministrator == ADMIN_DISPLAY)
				{
					this->displayAdministratorMode();
				}
				if (commanAdministrator == ADMIN_EXIT)
				{
					break;
				}
			}
		}
		if (command == MAIN_USER)
		{
			while (true)
			{
				this->userMode();
				int commandUser;
				cout << "Command user mode:";
				cin >> commandUser;
				if (commandUser == USER_SEE_ALL)
				{
					while (true)
					{
						if (adoptionDogs() == 1)
							break;
					}
				}
				if (commandUser == USER_SEE_ALL_GIVEN)
				{
					string breed;
					int age;
					cout << "What is the breed?" << endl;
					cin >> breed;
					cout << "What is the maximum age?" << endl;
					cin >> age;
					while (true)
					{
						if (this->seeAllOfGiveBreedAndAge(breed, age) == 1)
							break;
					}
				}
				if (commandUser == USER_ADOPTION_LIST)
				{
					this->displayAdoptionList();
				}
				if (commandUser == USER_EXIT)
					break;
			}
		}
		if (command == MAIN_EXIT)
			break;

	}
	
}




