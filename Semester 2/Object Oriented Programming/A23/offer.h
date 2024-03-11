#pragma once

typedef struct
{
	char* type;
	char* destination;
	char* departureDate;
	int price;
}Offer;

Offer* createOffer(char* type, char* destination, char* departureDate, int price);
void destroyOffer(Offer* offer);
char* getType(Offer* offer);
void setType(Offer* offer, char* newType);
char* getDestination(Offer* offer);
char* getDepartureDate(Offer* offer);
int getPrice(Offer* offer);
void setPrice(Offer* offer, int newPrice);
void assignValues(Offer* newOffer, Offer offer);