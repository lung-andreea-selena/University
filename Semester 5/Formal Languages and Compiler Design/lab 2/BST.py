
class TreeNode:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None


class BinarySearchTree:
    def __init__(self):
        self.root = None

    def insert(self, key):
        self.root = self._insert_recursive(self.root, key)

    def _insert_recursive(self, root, key):
        if root is None:
            return TreeNode(key)
        if key < root.key:
            root.left = self._insert_recursive(root.left, key)
        else:
            root.right = self._insert_recursive(root.right, key)
        return root

    def get_index(self, key):
        return self._get_index_recursive(self.root, key, 0)

    def _get_index_recursive(self, root, key, index):
        if root is None:
            return None
        if key < root.key:
            return self._get_index_recursive(root.left, key, index)
        if key == root.key:
            return index + self._count_nodes(root.left)
        if key > root.key:
            return self._get_index_recursive(root.right, key, index + self._count_nodes(root.left) + 1)

    def _count_nodes(self, root):
        if root is None:
            return 0
        return 1 + self._count_nodes(root.left) + self._count_nodes(root.right)

    def inorder_traversal_print(self):
        return self._inorder_recursive_print_(self.root)

    def _inorder_recursive_print_(self, root):
        if root is not None:
            self._inorder_recursive_print_(root.left)
            print(str(self.get_index(root.key)) + " : " + str(root.key))
            self._inorder_recursive_print_(root.right)

    def get_element_from_index(self, index):
        return self._get_element_from_index_recursive(self.root, index, [0])

    def _get_element_from_index_recursive(self, root, index, current_index):
        if root is None:
            return None
        left_result = self._get_element_from_index_recursive(root.left, index, current_index)
        if left_result is not None:
            return left_result
        if current_index[0] == index:
            return root.key
        current_index[0] += 1
        return self._get_element_from_index_recursive(root.right, index, current_index)

