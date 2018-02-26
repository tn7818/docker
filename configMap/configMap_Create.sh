#!/bin/bash
# Create UPAS DAS & MS User Profile  
kubectl create configmap linuxprofile --from-file=das=./dasLinuxProfile --from-file=ms=./msLinuxProfile
