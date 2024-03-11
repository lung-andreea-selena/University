#include "ui.h"
#include "tests.h"

void start()
{
	tests();
	Ui ui{};
	ui.startUi();
}

int main()
{
	start();
	_CrtDumpMemoryLeaks();
	return 0;
}