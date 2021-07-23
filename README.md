# wawa-cloud-test
Terraform code for hosting a Single static page on a webserver. 

I have followed the follwing design for simplification. Since the webpage needed to be hosted on the webserver, we can do this by having a launch template with auto scaling group in-place. We can have a ELB in front of it so that we can allow traffic to the private subnet where the instance is hosted. 

![Blank diagram](https://user-images.githubusercontent.com/87870511/126824432-05f074f1-d1a2-4435-b314-8e91ccf38f9a.jpeg)

