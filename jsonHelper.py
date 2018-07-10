import json
import sys

with open(sys.argv[1], 'r+') as f:
    data = json.load(f)
    if (len(sys.argv) == 4):
        data['args'][sys.argv[2]] = sys.argv[3]
        
    if (len(sys.argv) == 5):
        data['args'][sys.argv[2]][sys.argv[3]] = sys.argv[4]
        
    if (len(sys.argv) == 6):
        data['args'][sys.argv[2]][sys.argv[3]][sys.argv[4]] = sys.argv[5]
    
    f.seek(0)
    f.truncate()
    json.dump(data, f, indent=4)
