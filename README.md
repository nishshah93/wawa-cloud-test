# wawa-cloud-test
Terraform code for hosting a Single static page on a webserver. 

I have followed the follwing design for simplification. Since the webpage needed to be hosted on the webserver, we can do this by having a launch template with auto scaling group in-place. We can have a ELB in front of it so that we can allow traffic to the private subnet where the instance is hosted. 

![staticwebsite](https://user-images.githubusercontent.com/87870511/126929957-e39051a6-fcea-4629-a329-d31ad1ef48ed.png)


**How to run it?**
- You need to setup your default aws profile that has access to all aws resources before you can run the start.sh
- You can run start.sh to setup, plan and run this terraform code.
- In the start.sh script it creates a s3 bucket where you can store your terraform state files. It also creates a dynamo table so that only one person can execute the terrafrom code, while its running it creates a lock and until the lock is released other person cannot apply his/her changes.
- Next it will execute terraform commands
- Once everything is created you can just use NLBs static ip to get to the webpage(hosted through apache on linux)
- and finally to destroy it all, just run "terraform destroy" command 

**What can be improved?**
- in current solution we can add ACM cert and do port 443. if we need more of routing then its better to use ALB. We can still use NLB in front of it to get the static IP
- Since this was just written to test, we can have a better solution where s3 is the origin and has all the files and served using cloudfront. We can use WAF in front of cloud front.
  ![s3_website](https://user-images.githubusercontent.com/87870511/126925011-99e2fdd6-e89c-4b0e-94df-dade268c2d27.png)


- If this was an MVC app, we can host this in ECS fargate with proper CI-CD pipelines in place. lets say we have a dev
  ![nish-test-dev](https://user-images.githubusercontent.com/87870511/126828709-9ad85175-ae9c-49a6-981b-effb79d38035.png)
