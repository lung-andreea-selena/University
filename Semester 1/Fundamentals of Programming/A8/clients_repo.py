from src.domain.clients import Clients


class ClientsRepo:
    def __init__(self):
        self._repo = []

    def add_client_repo(self, client):
        self._repo.append(client)

    def remove_client_repo(self, client):
        self._repo.remove(client)

    def get_list_clients(self):
        return self._repo

    def length_clients_repo(self):
        return len(self._repo)

    def get_client_by_id(self, client_id):
        for c in self._repo:
            if c.getter_client_id() == client_id:
                return c

    def get_client_by_name(self, name):
        for c in self._repo:
            if c.getter_name() == name:
                return c

    def get_client_id_repo(self, index):
        client = self._repo[index]
        client_id = client.getter_client_id()
        return client_id

    def get_client_name_repo(self, index):
        client = self._repo[index]
        name = client.getter_name()
        return name

    def update_client_by_id(self, client_id, name):
        for c in self._repo:
            if c.getter_client_id() == client_id:
                c.setter_name(name)

    def check_client_existence_by_id(self, client_id):
        for c in self._repo:
            if c.getter_client_id() == client_id:
                return True
        return False
