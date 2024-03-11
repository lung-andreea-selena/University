#include "offer.h"
#include "DynamicArray.h"
#include "Repository.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Service.h"
#include "Ui.h"
#include "test.h"
#include "undoRedo.h"

int main()
{
	testAll();
	DynamicArray* dynamicArr = createDynamicArray(10);
	Repository* repo = createRepository(dynamicArr);
	UndoRepo* undo = createUndoRepo(10, repo);
	Service* service = createService(repo);
	Ui* ui = createUi(service);
	StartUi(ui);
}