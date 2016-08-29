# Setting Up in AWS
Panda Sky interfaces with your AWS account to publish your site and direct browser requests to your domain.  This guide will take you through how to set all that up.

> **Note: If you don't have an Amazon Web Services (AWS) account currently, stop here, go [signup and get CLI access credentials](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html) and then come back here.**

## Registering Your Domain
If you already have a domain, see [Transfering Existing Domains](#transfering-existing-domains).

If you have not yet purchased your domain, we may do so easily with AWS.  [Access Route53][route53] within the AWS Console.  You may request a domain directly in the dashboard.  If the domain is available for purchase, you may add it to your cart and begin the registration process.

![registration interface in route53][route53-dashboard]
![registration cart in route53][route53-cart]

[ICANN][icann] is the governing body that acts as the Internet address's naming authority.  AWS interfaces with that organization on your behalf and handles all neccessary actions to cooridinate your claim to the domain.  Your AWS account is charged at the quoted rate per annum to maintain your claim.   

The registration process can take anywhere from a few minutes to a whole day, but you will eventually recieve an email at the address you specified in the registration.

![confirmation email recieved from Route53][route53-email]

Congrations! you are the proud owner of a domain and have the authority to specify where that name sends anyone in the world.  That is accomplished with the [Domain Name System][dns], which AWS provides through Route53.  AWS uses constructs called Hosted Zones to organize domain routing and the creation of subdomains.  That's why you automatically get a Hosted Zone setup for you with this domain's registration.  You should be able to see it within the Route53 Console.

## Transfering Existing Domains
If you are using a prexisting domain from another registrar, you will need to [transfer your registration to Route53][route53-transfer].  Enter the domain you wish to transfer and complete the forms.  

You should recieve a confirmation email, after which the domain is integrated with AWS.  A hosted zone will be created to organize DNS routing, and you should be able to see it within the Route53 Console. Your AWS account will be charged a small transfer fee and then at the quoted rate per annum to maintain your claim to the domain.

If you encounter diffculties setting up the transfer, please see [official AWS docs on domain transfer][domain-transfer].

## Requesting An SSL Certificate
Here is what you get when your site supports HTTPS:
  - Makes it difficult for malicious actors to spoof your domain
  - All traffic to and from your site is encrypted, protecting your vistor's privacy.

Panda Sky requires custom domains to use HTTPS, so you will need to generate an SSL certificate known to your AWS account.  Access the [AWS Certificate Manager][acm] and click "Request a certificate".  Generating and using an SSL cert adds no cost to using AWS platforms.

![AWS Certificate Manager Interface][acm-interface]

This interface lets you select which subdomains you wish to protect under the pending certificate.  

You currently get 10 slots per certificate.  You may specify subdomains individually or use the "wildcard" character, `*`, to specify any possibility.  Wildcards have the benefit of occupying only one slot.  However, the wildcard character is stop-sensitive, so apex and/or nested subdomains are not covered.  Multiple wildcards are disallowed.

<br>
### Example

> ***.panda-demo.com**
> <br>
> #### Protects
  - www.panda-demo.com
  - api.panda-demo.com
  - staging-www.panda-demo.com
>  
>
> #### Does **NOT** Protect
  - panda-demo.com  (Apex Domain)
  - staging.www.panda-demo.com (Nested Subdomain)

<br>

After you place the request to ACM, AWS sends a validation email to the addresses associated with the domain's owner(s).  

![validation email from acm][acm-email]

After you validate, the certificate is activated and available for use.  At this point, you are done setting things up in AWS, and you're ready to use it in your Panda Sky deployment.

[route53]: https://console.aws.amazon.com/route53/home
[icann]: https://en.wikipedia.org/wiki/ICANN
[dns]: https://en.wikipedia.org/wiki/Domain_Name_System
[route53-transfer]: https://console.aws.amazon.com/route53/home#DomainTransfer:
[domain-transfer]: http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-transfer-to-route-53.html
[acm]: https://console.aws.amazon.com/acm/home

[route53-dashboard]: /open-source/haiku9/img/route53-dashboard.png
[route53-cart]: /open-source/haiku9/img/route53-check.png
[route53-email]: /open-source/haiku9/img/route53-email.png
[acm-interface]: /open-source/haiku9/img/acm-request.png
[acm-email]: /open-source/haiku9/img/acm-email.png
