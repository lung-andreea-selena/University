#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

typedef struct {
	int vectorArray[50], length;
}vector;

vector readAVectorOfNumbers(int numberOfElements)
{
	vector arrayOfNumbers;
	arrayOfNumbers.length = numberOfElements;
	for (int i = 0; i < numberOfElements; i++)
	{
		printf("Add an element: ");
		scanf("%d", &arrayOfNumbers.vectorArray[i]);
	}
	return arrayOfNumbers;
}

int isPrime(int positiveCheckedNumber)
{
	if (positiveCheckedNumber <= 1)
		return 0;
	if (positiveCheckedNumber != 2 & positiveCheckedNumber % 2 == 0)
		return 0;
	for (int divisor = 3; divisor * divisor < positiveCheckedNumber; divisor = divisor + 2)
	{
		if (positiveCheckedNumber % divisor == 0)
			return 0;
	}
	return 1;
}

void firstNPrimeNumbers(int numberOfPrimeNumbers)
{
	int checkingWhile = 0, contorUntilN = 0, positiveNumber = 1;
	while (checkingWhile == 0)
	{
		if (isPrime(positiveNumber) == 1)
		{
			contorUntilN++;
			printf("%d", positiveNumber);
			printf(" ");
		}
		if (contorUntilN == numberOfPrimeNumbers)
			checkingWhile = 1;
		positiveNumber++;
	}
}
int CheckIfRelativelyPrime(int firstNumber, int SecondNumber)
{
	while (SecondNumber > 0)
	{
		int remainder = firstNumber % SecondNumber;
		firstNumber = SecondNumber;
		SecondNumber = remainder;
	}
	if (firstNumber == 1)
		return 1;
	else return 0;

}

void longestContiguousSubsequenceWhereTwoConsecutiveAreRelativelyPrime(vector arrayOfNumbers, int* StartOfSubsequence, int* EndOfSubsequence)
{
	*StartOfSubsequence = 0;
	*EndOfSubsequence = 0;
	int maxLengthForStartAndEnd = 0;
	int temporaryLenght = 0;
	int i = 0, temporaryStart = 0, j=1;
	while (i< arrayOfNumbers.length-1)
	{
		if (CheckIfRelativelyPrime(arrayOfNumbers.vectorArray[i], arrayOfNumbers.vectorArray[j]) == 1)
		{
			temporaryLenght = j - temporaryStart;
			if (temporaryLenght >= maxLengthForStartAndEnd)
			{
				*StartOfSubsequence = temporaryStart;
				*EndOfSubsequence = j;
				maxLengthForStartAndEnd = temporaryLenght;
			}
		}
		else 
			temporaryStart = j;
		i = j;
		j++;
	}
}

int main()
{
	vector arrayOfNumbers;
	int numberOfElements = 0;
	int optionFromMenu = 1;
	while (1)
	{
		printf("1.Read a vector of numbers from the console \n");
		printf("2.Generate the first `n` prime numbers \n");
		printf("3.Find the longest contiguous subsequence such that any two consecutive elements are relatively prime \n");
		printf("0.Exit \n");
		printf("Select option: ");
		scanf("%d", &optionFromMenu);
		if (optionFromMenu == 1)
		{
			printf("The number of elements: ");
			scanf("%d", &numberOfElements);
			arrayOfNumbers =readAVectorOfNumbers(numberOfElements);
		}
		if (optionFromMenu == 2)
		{
			printf("The number of elements: ");
			int numberOfPrimeNumbers = 0;
			scanf("%d", &numberOfPrimeNumbers);
			firstNPrimeNumbers(numberOfPrimeNumbers);
			printf("\n");
		}
		if (optionFromMenu == 3)
		{
			int StartOfSubsequence, EndOfSubsequence;
			longestContiguousSubsequenceWhereTwoConsecutiveAreRelativelyPrime(arrayOfNumbers, &StartOfSubsequence, &EndOfSubsequence);
			printf("The longest contiguous subsequence such that any two consecutive elements are relatively prime: ");
			for (int i = StartOfSubsequence; i <= EndOfSubsequence; i++)
			{
				printf("%d", arrayOfNumbers.vectorArray[i]);
				printf(" ");
			}
			printf("\n");
		}
		if (optionFromMenu == 0)
			break;
	}
	getchar();
	return 0;
}