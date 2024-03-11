#pragma once
#include "offer.h"
#include "DynamicArray.h"
#include "Repository.h"
#include "Service.h"

typedef struct
{
	Service* service;
}Ui;
Ui* createUi(Service* service);
void destroyUi(Ui* ui);
void menu();
void StartUi(Ui* ui);