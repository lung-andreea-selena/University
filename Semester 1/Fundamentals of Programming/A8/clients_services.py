from src.domain.clients import Clients
from src.repository.clients_repo import ClientsRepo
import random


class ClientServices:
    def __init__(self, repo):
        self._repo = repo

    def add_client_function(self, client_id, name):
        """
        Creates an object type clients and adds it
        :param client_id: client id
        :param name: name
        :return: nothing
        """
        client = Clients(client_id, name)
        self._repo.add_client_repo(client)

    def remove_client_function(self, client_id):
        """
        Removes a client based on the client id
        :param client_id:
        :return: nothing
        """
        client = self._repo.get_client_by_id(client_id)
        self._repo.remove_client_repo(client)

    def update_client_function(self, client_id, name):
        """
        Updates the name of the client by client id
        :param client_id: client id
        :param name: name
        :return: nothing
        """
        self._repo.update_client_by_id(client_id, name)

    def search_client_by_id(self, sub_client_id):
        list_client_ids = []
        sub_client_id_str = str(sub_client_id)
        for index in range(0, self._repo.length_clients_repo()):
            client_id = self._repo.get_client_id_repo(index)
            client_id_str = str(client_id)
            if sub_client_id_str in client_id_str:
                list_client_ids.append(client_id)
        return list_client_ids

    def list_of_found_clients_id(self, list_client_ids):
        list_clients = []
        for client_id in list_client_ids:
            client = self._repo.get_client_by_id(client_id)
            list_clients.append(client)
        return list_clients

    def search_client_by_name(self, sub_name):
        list_client_names = []
        for index in range(0, self._repo.length_clients_repo()):
            name = self._repo.get_client_name_repo(index)
            if sub_name.lower() in name.lower():
                list_client_names.append(name)
        return list_client_names

    def list_of_found_clients_name(self, list_client_names):
        list_clients = []
        for name in list_client_names:
            client = self._repo.get_client_by_name(name)
            list_clients.append(client)
        return list_clients

    def check_client_existence_by_id_function(self, client_id):
        check = self._repo.check_client_existence_by_id(client_id)
        if check:  # this client id is already used and exists
            return True
        else:
            return False  # this client id does not exist and the id is not used

    def display_clients_function(self):
        return self._repo.get_list_clients()

    def generate_clients(self):
        if len(self._repo.get_list_clients()) == 0:
            client = Clients(random.randint(100000, 999999), 'Oltyan Octavian')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Lung Andreea')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Molnar Luiza')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Lung Georgiana')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Siviroveanu Vlada')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Ionascu Iulia')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Sas Denisa')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Rusu Antonia')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Maric Razvan')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Pallo Andrei')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Nemes Teodora')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Matisan Rares')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Galatan Rares')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Pop Julieta')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Oniciuc Ilinca')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Iancu Dariana')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Marka Ruben')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Miries Cristian')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Jorza Ionut')
            self._repo.add_client_repo(client)
            client = Clients(random.randint(100000, 999999), 'Marko Glass')
            self._repo.add_client_repo(client)
