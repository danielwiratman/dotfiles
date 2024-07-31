#!/bin/bash

ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
