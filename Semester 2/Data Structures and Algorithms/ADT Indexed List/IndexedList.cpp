#include <exception>

#include "IndexedList.h"
#include "ListIterator.h"

using namespace std;

IndexedList::DLLNode* IndexedList::getNode(int pos) const
{
    if (pos < 0 || pos >= this->count) {
        return nullptr;
    }
    DLLNode* node;
    if (pos <= this->count / 2) {
        node = this->head;
        for (int i = 0; i < pos; i++) {
            node = node->next;
        }
    }
    else {
        node = this->tail;
        for (int i = this->count - 1; i > pos; i--) {
            node = node->prev;
        }
    }
    return node;
}
//Best case: Theta(1);
// Worst case: Theta(size);
// Total: O(size)

IndexedList::IndexedList() {
    head = nullptr;
    tail = nullptr;
    count = 0;
}
// Theta(1)

int IndexedList::size() const {
	return this->count;
}
// Theta(1)


bool IndexedList::isEmpty() const {
    if (this->count == 0)
        return true;
    else
        return false;
}
//Theta(1)

TElem IndexedList::getElement(int pos) const {
    DLLNode* node = getNode(pos);
    if (node == nullptr)
        throw exception();
    return node->info;
}
//Best case: Theta(1);
// Worst case: Theta(size);
// Total: O(size)


TElem IndexedList::setElement(int pos, TElem e) {
    DLLNode* Node = getNode(pos);
    if (Node == nullptr)
        throw exception();
    else
    {
        TElem oldValue = Node->info;
        Node->info = e;
        return oldValue;
    }

}
//Best case: Theta(1);
// Worst case: Theta(size);
// Total: O(size)


void IndexedList::addToEnd(TElem e) {
    DLLNode* newNode = new DLLNode{ e, nullptr, tail };
    if (isEmpty()) {
        this->head = this->tail = newNode;
    }
    else {
        this->tail->next = newNode;
        this->tail = newNode;
    }
    this->count++;
}
// Theta(1)


void IndexedList::addToPosition(int pos, TElem e) {
    if (pos < 0 || pos > this->count)
        throw exception("Invalid position");
    if (pos == this->count)
    {
        addToEnd(e);
        return;
    }
    DLLNode* newNode = new DLLNode{ e,nullptr,nullptr };
    if (pos == 0) {
        newNode->next = this->head; // next pointer contains the current head
        this->head->prev = newNode; //sets the prev pointer of the current head to the new node
        this->head = newNode;;// now the head will be the new node
    }
    else
    {
        DLLNode* prevNode = getNode(pos - 1);
        DLLNode* nextNode = getNode(pos);
        prevNode->next = newNode;
        newNode->prev = prevNode;
        newNode->next = nextNode;
        nextNode->prev = newNode;
    }
    this->count++;
}
//Best case: Theta(1);
// Worst case: Theta(size);
// Total: O(size)

TElem IndexedList::remove(int pos) {
    if (isEmpty() || pos < 0 || pos >= size()) {
        throw std::exception("Invalid position!");
    }

    DLLNode* node = getNode(pos);
    if (node == nullptr) {
        throw std::exception("Node is null!");
    }

    TElem elem = node->info;

    // Update the links of the adjacent nodes
    if (node->prev != nullptr) {
        node->prev->next = node->next;
    }
    else {
        head = node->next;
    }
    if (node->next != nullptr) {
        node->next->prev = node->prev;
    }
    else {
        tail = node->prev;
    }

    // Delete the node and return the removed element
    delete node;
    count--;
    return elem;
}
//Best case: Theta(1);
// Worst case: Theta(size);
// Total: O(size)

int IndexedList::search(TElem e) const{
    DLLNode* current = this->head;
    int pos = 0;
    while (current != nullptr) {
        if (current->info == e) {
            return pos;
        }
        current = current->next;
        pos++;
    }
	return -1;
}
//Best case: Theta(1);
// Worst case: Theta(n);
// Total: O(n)

ListIterator IndexedList::iterator() const {
    return ListIterator(*this);        
}

IndexedList::~IndexedList() {
    while (this->head != nullptr) {
        DLLNode* node = this->head;
        this->head = this->head->next;
        delete node;
    }
    this->tail = nullptr;
    this->count = 0;
}
//theta(n)

void IndexedList::reverseBetween(int start, int end)
{
    if (start < 0 || end >= size() || start >= end) {
        throw exception("Invalid start or end position");
    }
    DLLNode* prevStartNode = getNode(start - 1);
    DLLNode* startNode = getNode(start);
    DLLNode* endNode = getNode(end);
    DLLNode* nextEndNode = endNode->next;
    DLLNode* current = startNode;
    DLLNode* prev = nullptr;
    while (current != nextEndNode) {
        DLLNode* next = current->next;
        current->next = prev;
        prev = current;
        current = next;
    }
    prevStartNode->next = endNode;
    startNode->next = nextEndNode;
    if (end == size() - 1) {
        tail = startNode;
    }
}
