#include "ui.h"
#include "tests.h"

using namespace std;

void start()
{
	testAll();
	Ui ui{};
	ui.startUi();
}

int main()
{
	start();
	return 0;
}