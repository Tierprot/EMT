class MeSHTree:
    class Node:
        def __init__(self, address, id, text):
            self.address = address
            self.id = id
            self.text = text
            self.Children = []

    def __init__(self):
        self.root = self.Node('0', 'root', 'root')

    def addNode(self, data):
        currNode = self.root
        address, id, text = data.strip().split('\t')

        if len(address)==1:
            address = list(address)
        else:
            address = address.split('.')

        for item in address:
            if not currNode.Children:
                break
            else:
                for child in currNode.Children:
                    if item in child.address:
                        currNode = child
                        break
        self.addChildren(currNode, address[-1], id, text)

    def addChildren(self, node, address, id, text):
        node.Children.append(self.Node(address, id, text))

    def getFirstChildren(self, address):
        address = address.split('.')
        currNode = self.root
        for item in address:
            for child in currNode.Children:
                if child.address == item:
                    currNode = child
        #address = '.'.join(address)
        # print('address ' + address + ' ' + currNode.id + ' ' + currNode.text)
        # print('amount of direct children: ', len(currNode.Children))
        # for item in currNode.Children:
        #     print(address + '.' + item.address + ' ' + item.id + ' ' + item.text)
        return len(currNode.Children)

    def getFirstChildrenList(self, address):
        address = address.split('.')
        currNode = self.root
        for item in address:
            for child in currNode.Children:
                if child.address == item:
                    currNode = child
        return currNode.Children

    def getLeafDistance(self, address):
        pass

    def getAllChildrenNodes(self, address):
        def recursiveGetChildrens(node):
            nodes = []
            for childNode in node.Children:
                nodes.append(childNode)
                nodes += recursiveGetChildrens(childNode)
            return(nodes)
        first_nodes = self.getFirstChildrenList(address)
        res = []
        for n in first_nodes:
            res += recursiveGetChildrens(n)
        return(res)

if __name__ == '__main__':
    MESH = MeSHTree()
    MESH.addNode('A01	D001829	Body Regions')
    MESH.addNode('A01.111	D059925	Anatomic Landmarks')
    MESH.addNode('A01.236	D001940	Breast')
    MESH.addNode('A01.236.249	D042361	Mammary Glands, Human')
    MESH.addNode('A01.236.500	D009558	Nipples')
    MESH.addNode('A01.378	D005121	Extremities')
    MESH.addNode('A01.378.100	D000672	Amputation Stumps')
    MESH.addNode('A01.378.610	D035002	Lower Extremity')
    MESH.addNode('A01.378.610.100	D002081	Buttocks')
    MESH.addNode('A01.378.610.250	D005528	Foot')
    print(MESH.getFirstChildren('A01.378.610'))