# Azure Database for MySQL Terraform module

[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-mysql/badge)](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-mysql/badge)
[![Equinor Terraform Baseline](https://img.shields.io/badge/Equinor%20Terraform%20Baseline-1.0.0-blueviolet)](https://github.com/equinor/terraform-baseline)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

Terraform module which creates Azure Database for MySQL resources.

## Notes

### MySQL Client Password Limitation

The MySQL client has a limitation that prohibits entering a password longer than 79 characters. To work around this limitation, use either a configuration file or environment variables to connect.

#### Using a Configuration File
Create a .my.cnf file with the following content:

```
[client]
user="<username>"
password="<password>"
host="<domain name or IP>"
port="<port>"
```

Set the appropriate permissions:
```
chmod 600 .my.cnf
```

Then connect using:
```
mysql --defaults-file=.my.cnf
```

#### Using Environment Variables
Set the environment variables:
```
export MYSQL_PWD='<password>'
export MYSQL_HOST="<domain name or IP>"
export MYSQL_PORT="<port>"
```

Then connect using:
```
mysql -u <username>
```

## Development

1. Clone this repository:

    ```console
    git clone https://github.com/equinor/terraform-azurerm-mysql.git
    ```

1. Login to Azure:

    ```console
    az login
    ```

1. Set active subscription:

    ```console
    az account set -s <SUBSCRIPTION_NAME_OR_ID>
    ```

1. Set environment variables:

    ```console
    export TF_VAR_resource_group_name=<RESOURCE_GROUP_NAME>
    export TF_VAR_location=<LOCATION>
    ```

## Testing

1. Initialize working directory:

    ```console
    terraform init
    ```

1. Execute tests:

    ```console
    terraform test
    ```

    See [`terraform test` command documentation](https://developer.hashicorp.com/terraform/cli/commands/test) for options.

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
