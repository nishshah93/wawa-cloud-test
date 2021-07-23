# wawa-cloud-test
Terraform code for hosting a Single static page on a webserver. 

I have followed the follwing design for simplification. Since the webpage needed to be hosted on the webserver, we can do this by having a launch template with auto scaling group in-place. We can have a ELB in front of it so that we can allow traffic to the private subnet where the instance is hosted. 

![Blank diagram](https://user-images.githubusercontent.com/87870511/126824432-05f074f1-d1a2-4435-b314-8e91ccf38f9a.jpeg)



What Can be improved? 
- in current solution we can add ACM cert and do https. Interally from ALB to instance it can be http. We can also put WAF rules infront of ELB.
- Since this was just written to test, we can have a better solution where s3 is the origin and has all the files and served using cloudfront. We can use WAF in front of cloud front.

- If this was an MVC app, we can host this in ECS fargate with proper CI-CD pipelines in place. lets say we have a dev
  ![nish-test-dev](https://user-images.githubusercontent.com/87870511/126828709-9ad85175-ae9c-49a6-981b-effb79d38035.png)
