#!/bin/bash
exec ttyd --port 8080 --interface 0.0.0.0 -c myusername:mysecurepassword bash
