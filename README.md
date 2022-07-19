<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_netsuite_source/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.0.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Netsuite Source dbt Package ([Docs](https://fivetran.github.io/dbt_netsuite_source/))
# 📣 What does this dbt package do?
- Materializes [Netsuite staging tables](https://fivetran.github.io/dbt_netsuite_source/#!/overview/netsuite_source/models/?g_v=1&g_e=seeds) which leverage data in the format described by [this ERD](https://fivetran.com/docs/applications/netsuite#schemainformation). These staging tables clean, test, and prepare your Netsuite data from [Fivetran's connector](https://fivetran.com/docs/applications/netsuite) for analysis by doing the following:
  - Name columns for consistency across all packages and for easier analysis
  - Adds freshness tests to source data
  - Adds column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
- Generates a comprehensive data dictionary of your netsuite data through the [dbt docs site](https://fivetran.github.io/dbt_netsuite_source/).
- These tables are designed to work simultaneously with our [Netsuite transformation package](https://github.com/fivetran/dbt_netsuite).

# 🎯 How do I use the dbt package?
## Step 1: Prerequisites
To use this dbt package, you must have At least either one Fivetran **Netsuite** (netsuite.com) or **Netsuite2** (netsuite2) connector syncing the respective tables to your destination:
### Netsuite.com
- accounts
- accounting_periods
- accounting_books
- consolidated_exchange_rates
- currencies
- customers
- classes
- departments
- expense_accounts
- income_accounts
- items
- locations
- partners
- transaction_lines
- transactions
- subsidiaries
- vendors
- vendor_types

### Netsuite2
- account
- accounttype
- accountingbooksubsidiary
- accountingperiodfiscalcalendar
- accountingperiod
- accountingbook
- consolidatedexchangerate
- currency
- customer
- classification
- department
- entity
- entityaddress
- item
- job
- location
- locationmainaddress
- transactionaccountingline
- transactionline
- transaction
- subsidiary
- vendor
- vendorcategory

### Database Compatibility
This package is compatible with either a **BigQuery**, **Snowflake**, **Redshift**, or **PostgreSQL** destination.
## Step 2: Install the package
Include the following netsuite_source package version in your `packages.yml` file.
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/netsuite_source
    version: [">=0.5.0", "<0.6.0"]
```

## Step 3: Define Netsuite.com or Netsuite2 Source
As of April 2022 Fivetran made available a new Netsuite connector which leverages the Netsuite2 endpoint opposed to the original Netsuite.com endpoint. This package is designed to run for either or, not both. By default the `netsuite_data_model` variable for this package is set to the original `netsuite` value which runs the netsuite.com version of the package. If you would like to run the package on Netsuite2 data, you may adjust the `netsuite_data_model` variable to run the `netsuite2` version of the package.
```yml
vars:
    netsuite_data_model: netsuite2 #netsuite by default
```

## Step 4: Define database and schema variables
By default, this package runs using your destination and the `netsuite` schema. If this is not where your Netsuite data is (for example, if your netsuite schema is named `netsuite_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    netsuite_database: your_destination_name
    netsuite_schema: your_schema_name 
```

## (Optional) Step 5: Additional configurations
### Passing Through Additional Fields
This package includes all source columns defined in the macros folder. To add additional columns to this package, do so by adding our pass-through column variables to your `dbt_project.yml` file:

```yml
vars:
    accounts_pass_through_columns: ['new_custom_field', 'we_can_account_for_that']
    classes_pass_through_columns: ['class_is_in_session', 'pass_through_additional_fields_here']
    departments_pass_through_columns: ['department_custom_fields']
    transactions_pass_through_columns: ['transactions_can_be_custom','pass_this_transaction_field_on']
    transaction_lines_pass_through_columns: ['transaction_lines_field']
    customers_pass_through_columns: ['customers_field']
    locations_pass_through_columns: ['this_new_location','lets_also_add_this_location_field']
    subsidiaries_pass_through_columns: ['subsidiaries_field']
    consolidated_exchange_rates_pass_through_columns: ['this_exchange_rate','that_exchange_rate']
```
### Change the build schema
By default, this package builds the Netsuite staging models within a schema titled (`<target_schema>` + `_netsuite_source`) in your destination. If this is not where you would like your netsuite staging data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    netsuite_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable:
> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_netsuite_source/blob/main/dbt_project.yml) variable declarations to see the expected names.
    
```yml
vars:
    # For all Netsuite source tables
    netsuite_<default_source_table_name>_identifier: your_table_name 

    # For all Netsuite2 source tables
    netsuite2_<default_source_table_name>_identifier: your_table_name 
```

## (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core™ setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
    
# 🔍 Does this package have dependencies?
This dbt package is dependent on the following dbt packages. Please be aware that these dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/fivetran_utils
      version: [">=0.3.0", "<0.4.0"]

    - package: dbt-labs/dbt_utils
      version: [">=0.8.0", "<0.9.0"]
```
          
# 🙌 How is this package maintained and can I contribute?
## Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend that you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/netsuite_source/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_netsuite_source/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

## Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions! 

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) to learn how to contribute to a dbt package!

# 🏪 Are there any resources available?
- If you have questions or want to reach out for help, please refer to the [GitHub Issue](https://github.com/fivetran/dbt_netsuite_source/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
- Have questions or want to just say hi? Book a time during our office hours [on Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com.
