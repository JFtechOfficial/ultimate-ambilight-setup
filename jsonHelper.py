import json
import sys

print(sys.argv)
with open(sys.argv[1], 'r+') as f:
     data = json.load(f)
     if (sys.argv[2] == '0'){
         data['args'][sys.argv[3]] = int(sys.argv[4])
         }
     if (sys.argv[2] == '1'){
         data['args'][sys.argv[3]][sys.argv[4]] = int(sys.argv[5])
         }
     if (sys.argv[2] == '2'){
         data['args'][sys.argv[3]][sys.argv[4]][sys.argv[5]] = int(sys.argv[6])
         }
     f.seek(0)
     f.truncate()
     json.dump(data, f)

