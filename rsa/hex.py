""" convert hex string integer to int """
def convert(n: str) -> int:
    # get rid of ':', spaces and newlines
    hex = n.replace(":", '').replace('\n','').replace(' ','')
    return int(hex,16)



n = """    30:9a:62:af:a8:ec:f1:1e:ad:49:bd:53:46:67:3a:
    68:3a:17:32:08:e3:d9:07:f9:fb:84:68:36:89:5c:
    30:0f:d9:76:08:e3:29:cd:5e:7f:5c:60:5c:8c:48:
    6a:2e:92:60:2a:ea:74:97:0c:c8:98:8f:6e:70:62:
    38:18:ea:01"""

print(convert(n))