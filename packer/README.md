# ascent-fortify-ami

## To run
### Set up your aws client
Install the aws-cli - https://docs.aws.amazon.com/cli/latest/userguide/installing.html for instructions

Once installed, run `aws configure`, supplying your access key, region, and secret access key when prompted

### Set up your settings.xml file
Create JSON settings.xml file containing AWS ID, key, region, and instance type in this directory.
```

    {
    "aws_access_key": "<your key value>",
    "aws_secret_key": "<your key value>",
    "aws_region": "us-west-1",
    "base_ami_id": "ami-0466e865"
    }
```

Run the build.sh script
```
./build.sh
```
