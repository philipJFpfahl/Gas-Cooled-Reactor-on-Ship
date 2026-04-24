## First terminal:
Run moose app

## Second terminal:

### Initialize with:
"""
curl -X POST http://127.0.0.1:6000/initialize \                                                                  -H "Content-Type: application/json" \
d '{        
    "host": "127.0.0.1",
    "user": "philip",
	 "name": "curl-client"
      }'
"""
### Advance one time step:
"""
curl http://127.0.0.1:6000/continue
"""

### Get some value:
curl -X POST http://127.0.0.1:6000/get/postprocessor \  
 -H "Content-Type: application/json" \
  -d '{"name": "power"
  }'

returns : { "value": 1 }

### set some value:

curl -X POST http://127.0.0.1:6000/set/controllable \
-H "Content-Type: application/json" \
-d '{
"name": "Postprocessor/rho_insertion/value",
"type": "Real",
"value": 2
}'
