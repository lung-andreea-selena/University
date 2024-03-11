#include "offer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Offer* createOffer(char* type, char* destination, char* departureDate, int price)
{
	Offer* offer = malloc(sizeof(Offer));
	if (offer != NULL)
	{
		offer->type = malloc((strlen(type) + 1) * sizeof(char));
		strcpy(offer->type, type);

		offer->destination = malloc((strlen(destination) + 1) * sizeof(char));
		strcpy(offer->destination, destination);

		offer->departureDate = malloc((strlen(departureDate) + 1) * sizeof(char));
		strcpy(offer->departureDate, departureDate);

		offer->price = price;
	}
	
	return offer;
}

void destroyOffer(Offer* offer)
{
	free(offer->type);
	free(offer->destination);
	free(offer->departureDate);
	free(offer);
}

char* getType(Offer* offer)
{
	return offer->type;
}

void setType(Offer* offer, char* newType)
{
	strcpy(offer->type, newType);
}

char* getDestination(Offer* offer)
{
	return offer->destination;
}

char* getDepartureDate(Offer* offer)
{
	return offer->departureDate;
}

int getPrice(Offer* offer)
{
	return offer->price;
}

void setPrice(Offer* offer, int newPrice)
{
	offer->price = newPrice;
}

void assignValues(Offer* newOffer, Offer offer)
{
	strcpy(newOffer->type,offer.type);
	strcpy(newOffer->destination, offer.destination);
	newOffer->price = offer.price;
	strcpy(newOffer->departureDate, offer.departureDate);
}