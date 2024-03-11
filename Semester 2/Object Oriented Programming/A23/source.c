#include <stdio.h>
#include <string.h>

#define MAX_OFFERS 100

typedef struct {
	char type[30];
	char destination[50];
	char departureDate[20];
	float price;
}Offer;

//Offer offers[MAX_OFFERS];
//int numberOfOffers = 0;

void addOffer(char* type, char* destination, char* departureDate, float price,Offer* offers, int numberOfOffers)
{
	for (int i = 0; i < numberOfOffers; i++)
	{
		if ((strcmp(offers[i].destination, destination) == 0) && (strcmp(offers[i].departureDate, departureDate) == 0))
		{
			printf("This offer is already added\n");
			return;
		}
	}
	if (numberOfOffers == MAX_OFFERS)
	{
		printf("Maximum number of offers reached\n");
		return;
	}
	strcpy(offers[numberOfOffers].type, type);
	strcpy(offers[numberOfOffers].destination, destination);
	strcpy(offers[numberOfOffers].departureDate, departureDate);
	offers[numberOfOffers].price = price;
	numberOfOffers++;
	printf("Offer added successfully\n");
}

void deleteAnOffer(char* destination, char* departureDate, Offer* offers,int numberOfOffers)
{
	for (int i=0; i < numberOfOffers; i++)
	{
		if ((strcmp(offers[i].destination, destination) == 0) && (strcmp(offers[i].departureDate, departureDate) == 0))
		{
			for (int j = i; j < numberOfOffers - 1; j++)
			{
				offers[j] = offers[j + 1];
			}
			numberOfOffers--;
			printf("Offer deleted successfully\n");
			return;
		}
	}
	printf("Offer not found!\n");
}

void updateOffer(char* type, char* destination, char* departureDate, float price, Offer* offers, int numberOfOffers)
{
	for (int i=0; i < numberOfOffers; i++)
	{
		if ((strcmp(offers[i].destination, destination) == 0) && (strcmp(offers[i].departureDate, departureDate) == 0))
		{
			strcpy(offers[i].type, type);
			offers[i].price = price;
			printf("Offer updated successfully!\n");
			return;
		}
	}
	printf("Offer not found\n");
}

void diasplayOffers(const char *givenString, int numberOfOffers, Offer* offers)
{
	Offer filteredOffers[MAX_OFFERS];
	int numberOfFilteredOffers = 0;

	for (int i = 0; i < numberOfOffers; i++)
	{
		if (givenString == NULL || strstr(offers[i].destination, givenString) != NULL)
		{
			filteredOffers[numberOfFilteredOffers] = offers[i];
			numberOfFilteredOffers++;
		}
	}
	qsort(filteredOffers, numberOfFilteredOffers, sizeof(char), strcmp);
	for (int i = 0; i < numberOfFilteredOffers; i++)
	{
		printf("%s %s %s %lf\n", filteredOffers[i].type, filteredOffers[i].destination, filteredOffers[i].departureDate, filteredOffers[i].price);

	}
}
int main()
{
	Offer offers[MAX_OFFERS];
	int numberOfOffers = 0;
	int optionFromMenu = 1;
	while (1)
	{
		printf("1.Add an offer \n");
		printf("2.Delete an offer \n");
		printf("3.Update an offer \n");
		printf("4.Display all tourism offers whose destinations contain a given string\n");
		printf("0.Exit \n");
		printf("Select option: ");
		scanf("%d", &optionFromMenu);
		if (optionFromMenu == 1)
		{
			char type[20], destination[50], departureDate[20];
			float price;
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
				scanf("%f", &price);
				addOffer(type, destination, departureDate, price,offers,numberOfOffers);
			}
			
		}
		if (optionFromMenu == 2)
		{
			char destination[50], departureDate[20];
			printf("What is the destination of the offer you want to delete?\n");
			scanf("%s", destination);
			printf("What is the departure date of the offer you want to delete?\n");
			scanf("%s", departureDate);
			deleteAnOffer(destination, departureDate, offers, numberOfOffers);
		}
		if (optionFromMenu == 3)
		{
			char newType[20], destination[50], departureDate[20];
			float newPrice;
			printf("What is the destination of the offer you want to update?\n");
			scanf("%s", destination);
			printf("What is the departure date of the offer you want to update?\n");
			scanf("%s", departureDate);
			printf("What is the new type?");
			scanf("%s", newType);
			if ((strcmp(newType, "seaside") != 0) && (strcmp(newType, "mountain") != 0) && (strcmp(newType, "city") != 0))
			{
				printf("Please enter one of the types seaside,mountain or city\n");
			}
			else
			{
				printf("What is the new price?\n");
				scanf("%f", &newPrice);
				updateOffer(newType, destination, departureDate, newPrice, offers, numberOfOffers);
			}
		}
		if (optionFromMenu == 4)
		{
			char searchigString[50];
			printf("%s", "What is the string to search by?\n");
			scanf("%s", searchigString);
			diasplayOffers(searchigString, numberOfOffers,offers);
		}
		if (optionFromMenu == 0)
			break;
	}
	getchar();
	return 0;
}