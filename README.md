# AtlasDemo

Goal is to create a simple maven web project in Github, use packer to build an image of the app with tomcat and then user terraform to deploy in Google Compute Engine using Atlas all the way.

Current Status:

Maven project committed in github

This is a demo / walkthrough of using Atlas and HashiCorp tools with Google Cloud Platform.

Clone this repo locally and then proceed to set up your Google Cloud Platform account and HashiCorp tools.
Google Cloud Platform Account and Auth

First, you will need to make sure you have a active Google Cloud Platform account. You can sign up for a free-trial account, but will still need to set up billing and have a credit card on file.

    Once you log into the Developers Console, make sure you have enabled billing and reviewed / accepted the terms of service.
    Next, make sure to create a new GCP Project and record the Project ID.
    Navigate to the Compute - Compute Engine page and ensure GCE is ready.
    Finally, navigate to APIs & auth - Credentials and under Service Accounts download the JSON account file. You will need to name this file pkey.json and save the file in both the packer/ directory and terraform/ directories.

Atlas

Visit the Atlas web site, create an account, and generate a new token. In your local environment, set a few environment variables:

export GOOGLE_PROJECT_ID=atlas-demo
export ATLAS_USERNAME=banuprakashurs
export ATLAS_TOKEN=<create a new token on atlas and paste it here>

export TF_VAR_GOOGLE_PROJECT_ID=${GOOGLE_PROJECT_ID}
export TF_VAR_ATLAS_USERNAME=${ATLAS_USERNAME}
export TF_VAR_ATLAS_TOKEN=${ATLAS_TOKEN}

Packer

Download and install Packer to build your GCE images configured with the atlasdemo app.

Create the Atlas artifact Google image for the atlasdemo app. This requires you to run,

packer push -name $ATLAS_USERNAME/atlasdemo atlasdemo.json

This will push the config up to Atlas, create a new build, and promptly fail to build the image. To fix this, navigate to your build in the Atlas web console and go to the Variables page. Make sure to set GOOGLE_PROJECT_ID and ATLAS_USERNAME. Now, you can fire off the build again by repeating your last shell command,

packer push -name $ATLAS_USERNAME/atlasdemo atlasdemo.json

You can watch the progress of the Atlas/Packer build on the Atlas web UI.

NOTE: You may need to edit the atlasdemo.json file to set the path to your Google Cloud Platform JSON account file.

You can watch the progress of the Atlas/Packer build on the Atlas web UI.

NOTE: You may need to edit the atlasdemo.json file to set the path to your Google Cloud Platform JSON account file.
Terraform

Now, you should have two Atlas artifacts created and Google images for your game, you can switch over to the terraform directory and create your infrastructure and start playing the game with a few friends.

terraform apply

This should do the following:

    Create a GCE instance named atlasdemo
    Create 2 GCE instances prefixed with atlasdemo- (0 and 1)
    Create a GCE load-balancer in front of both front-end instances
    Create a firewall rule to allow TCP port 80 (web) traffic to your front-ends

Once terraform finishes execution, you should see an output variable for the external public IP address of the GCE load-balancer. You can point your web browser to this IP to begin accessing atlasdemo page

NOTE: You may need to edit the main.tf file to set the path to your Google Cloud Platform JSON account file.
Tearing it down

Once you're done with the demo, to save costs, you may want to turn down all of your GCE resources. You can do that with,

terraform destroy

NOTE: The images you built are stored as atlas_artifacts and won't be destroyed. Because of the dependency chain, the GCE instances will not be deleted, so you will need to do that by hand.
Troubleshooting

    Auth errors: Make sure you have your Google Cloud Platform JSON account file saved as pkey.json locally to both the packer/ and terraform/ directories. Alternatively, you will need to edit the packer/terraform files to reference your JSON account file another way.

TODO

Use Consul forservice discovery, Vagrant to build Development images.
