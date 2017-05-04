Panda Sky needs your AWS credentials to allocate resources on your behalf.  If
you've installed the AWS CLI tool, they should be on your machine already. Panda Sky looks for them in their default location within the home
directory, `~/.aws/`.

If you do not have an AWS account, [this AWS tutorial][] walks you through the
process of setting one up.  You can either manually place your credentials into
the `~/.aws/` directory or follow the instructions to install the CLI to let it
do that for you automatically.

> **YOUR AWS CREDENTIALS SHOULD NEVER BE PLACED WITHIN YOUR PROJECT'S REPO NOR
DOES PANDA SKY ASK FOR THEM IN THE MAIN CONFIG FILE.**

[this AWS tutorial]: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
