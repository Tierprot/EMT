'''<table>
    <thead>
        <tr>
            <th>
            </th>
            <th>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <th>
            </th>
            <th>
            </th>
        </tr>
    </tbody>
</table>
'''

CONSTANT_ORDER = ['Partner', 'Action', 'Pathway', 'Type of cancer', 'PMID', 'Interaction is described in']


def th_decorator(func):
    '''
    input:
        {
            "Partner": "gene_name",
            "Action": "action on gene",
            "PMID": "PMID",
            "Interaction is described in": "someDB",
            "Pathway": "interaction",
            "Type of cancer":"some cancer"
        }
    '''

    def func_wrapper(gene_data, headers_order=CONSTANT_ORDER):
        if type(gene_data)==dict:
            return ' '.join(['<td>'+func(gene_data[col_name])+'</td>' for col_name in CONSTANT_ORDER])
        else:
            return '<th>'+func(gene_data)+'</th>'
    return func_wrapper

def tr_decorate(func):
    def func_wrapper(data):
        table_row=''
        if type(data)==dict:
            for partner in data:
                row = func(data[partner])
                table_row+='<tr>'+row+'</tr>'
            return table_row
        else:
            for item in data:
                row = func(item)
                table_row+=row
            return '<tr>'+table_row+'</tr>'
    return func_wrapper



@tr_decorate
@th_decorator
def arrange_table(somedata):
    return somedata

partners = {
                "gene1":{
                    "Partner": "Partner1",
                    "Action": "action on partner1",
                    "PMID": "PMID1",
                    "Interaction is described in": "someDB",
                    "Pathway": "pathway1",
                    "Type of cancer":"some cancer1"
                },
                "gene2":{
                    "Partner": "Partner2",
                    "Action": "action on partner2",
                    "PMID": "PMID2",
                    "Interaction is described in": "someDB",
                    "Pathway": "pathway2",
                    "Type of cancer":"some cancer2"
                },
                "gene3":{
                    "Partner": "Partner3",
                    "Action": "action on partner3",
                    "PMID": "PMID3",
                    "Interaction is described in": "someDB",
                    "Pathway": "pathway3",
                    "Type of cancer":"some cancer3"
                }
            }

@tr_decorate
@th_decorator
def make_row(data):
    return data

def make_table(data, headers=CONSTANT_ORDER):
    header = '<thead>'+make_row(headers)+'</thead>'
    body = '<tbody>'+make_row(data)+'</tbody>'
    return '<table class="table table-striped table-hover">'+header+body+'</table>'

if __name__ == '__main__':
    print(make_table(partners))

