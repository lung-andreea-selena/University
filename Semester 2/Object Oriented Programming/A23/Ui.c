#include "offer.h"
#include "DynamicArray.h"
#include "Repository.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Service.h"
#include "Ui.h"
#include <crtdbg.h>

Ui* createUi(Service* service)
{
	Ui* ui = malloc(sizeof(Ui));
	if (ui != NULL)
	{
		ui->service = service;
		return ui;
	}
}

void destroyUi(Ui* ui)
{
	destroyService(ui->service);
	free(ui);
}

void menu()
{
	printf("1.Add an offer \n");
	printf("2.Delete an offer \n");
	printf("3.Update an offer \n");
	printf("4.Display all tourism offers whose destinations contain a given string\n");
	printf("5.Display all offers of a given type, having their departure after a given date\n");
	printf("6.Undo\n");
	printf("7.Redo\n");
	printf("0.Exit \n");
	printf("Select option: ");
}

void StartUi(Ui* ui)
{	
	int optionFromMenu = 1;
	initForRepositoryService(ui->service);
	while (1)
	{
		printf("\n");
		menu();
		scanf("%d", &optionFromMenu);
		if (optionFromMenu == 1)
		{
			char type[20], destination[50], departureDate[20];
			int price;
			printf("What is the type of offer? Seaside,mountain or city?\n");
			scanf("%s", type);
			if ((strcmp(type, "seaside") != 0) && (strcmp(type, "mountain") != 0) && (strcmp(type, "city") != 0))
			{
				printf("Please enter one of the types above\n");
			}
			else
			{
				printf("What is the destination?\n");
				scanf("%s", destination);
				printf("What is the departure date?\n");
				scanf("%s", departureDate);
				printf("What is the price?\n");
				scanf("%d", &price);
				if (addOfferService(ui->service, type, destination, departureDate, price) == 0)
					printf("Offer added successfully\n");
				else
					printf("Offer could not be added\n");
			}

		}
		if (optionFromMenu == 2)
		{
			char destination[50], departureDate[20];
			printf("What is the destination of the offer you want to delete?\n");
			scanf("%s", destination);
			printf("What is the departure date of the offer you want to delete?\n");
			scanf("%s", departureDate);
			if (removeOfferService(ui->service, destination, departureDate) == 0)
				printf("Offer deleted successfully\n");
			else
				printf("Offer not found\n");

		}
		if (optionFromMenu == 3)
		{
			char newType[20], destination[50], departureDate[20];
			int newPrice = 0;
			printf("What is the destination of the offer you want to update?\n");
			scanf("%s", destination);
			printf("What is the departure date of the offer you want to update?\n");
			scanf("%s", departureDate);
			printf("What is the new type of offer?\n");
			scanf("%s", newType);
			if ((strcmp(newType, "seaside") != 0) && (strcmp(newType, "mountain") != 0) && (strcmp(newType, "city") != 0))
			{
				printf("Please enter one of the types above\n");
			}
			else
			{
				printf("What is the new price of the offer?\n");
				scanf("%d", &newPrice);
				if (updateOfferService(ui->service, destination, departureDate, newType, newPrice) == 0)
					printf("Update done!\n");
				else
					printf("Offer to update was not found\n");
			}

		}
		if (optionFromMenu == 4)
		{
			char string[20];
			printf("What is the string you want to search by?\n");
			scanf("%s", string);
			void* offersList = getAllService(ui->service);
			TElem* castedList = (TElem*)offersList;
			sortedAscendingByPrice(ui->service, castedList);
			for (int i = 0; i < getLenghtOfDynamicArrayService(ui->service); i++)
			{
				if (strcmp(string, "-") == 0)
				{
					printf("%s %s %s %d\n", getType(castedList[i]), getDestination(castedList[i]), getDepartureDate(castedList[i]), getPrice(castedList[i]));
				}
				else {
					if (strstr(getDestination(castedList[i]), string) != NULL)
					{
						printf("%s %s %s %d\n", getType(castedList[i]), getDestination(castedList[i]), getDepartureDate(castedList[i]), getPrice(castedList[i]));
					}
				}
			}
		}
		if (optionFromMenu == 5)
		{
			char type[20], departureDate[20];
			printf("What is the type of offer?\n");
			scanf("%s", type);
			if ((strcmp(type, "seaside") != 0) && (strcmp(type, "mountain") != 0) && (strcmp(type, "city") != 0))
			{
				printf("Please enter one of the types above\n");
			}
			else
			{
				printf("What is the departure date of the offer\n");
				scanf("%s", departureDate);
				void* offersList = getAllService(ui->service);
				TElem* castedList = (TElem*)offersList;
				for (int i = 0; i < getLenghtOfDynamicArrayService(ui->service); i++)
				{
					if ((strcmp(getType(castedList[i]), type) == 0) && (strcmp(getDepartureDate(castedList[i]), departureDate) == 0))
					{
						printf("%s %s %s %d\n", getType(castedList[i]), getDestination(castedList[i]), getDepartureDate(castedList[i]), getPrice(castedList[i]));
					}
				}

			}
			
		}
		if (optionFromMenu == 6)
		{
			if (UndoOperation(&ui->service->undo_redo) == 0)
				printf("There is no undo operation available!");
			else
				copy_repo_service(&ui->service, &ui->service->undo_redo);
		}
		if (optionFromMenu == 7)
		{
			if (RedoOperation(&ui->service->undo_redo) == 0)
				printf("There is no redo operation available!");
			else
				copy_repo_service(&ui->service, &ui->service->undo_redo);
		}
		if (optionFromMenu == 0)
		{
			destroyService(ui->service);
			break;
		}
	}
	_CrtDumpMemoryLeaks();
}

