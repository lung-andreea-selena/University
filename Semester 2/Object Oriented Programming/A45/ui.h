#pragma once
#include "service.h"
#include "serviceUser.h"

class Ui
{
private:
	Service service;
	ServiceUser serviceUser;

public:
	Ui();

	Ui(const Service& servicee, const ServiceUser& serviceuser);

	Ui(const Ui& ui);

	~Ui();

	void mainMenu();

	void startUi();
	
	void administratorMode();

	void addAdministratorMode();

	void removeAdministratorMode();

	void displayAdministratorMode();


	void updateAdministratorMode();

	void userMode();

	void adoptionUserMode();

	int adoptionDogs();

	void displayAdoptionList();

	int seeAllOfGiveBreedAndAge(string breed, int age);

};