# Verification Controller Helm Chart

This chart is for installing the verification controller, some key facts:

1. Install a mongo database with a PVC
   1. This will require a storage class to be specify in the values file
1. Variables will be defaulted, which will require modification and overrides

## Values Notes

The following sections will break down into the specific value groups that relate to the environment variables used to drive service behaviour.  All other settings are standard kubernetes helm settings and the relevant documentation should be referenced.  Values are saved in either a secrets object, config map or as a standard deployment variable.  If not explicitly mentioned it should be assumed to be in the deployment environment specification.

### `dbssl` Group

| Parameter               | Description                                      | Environment Variable Mapping                | Default |
| ----------------------- | ------------------------------------------------ | ------------------------------------------- | ------- |
| `enabled`               | If `true` will expect SSL settings for mongodb   | `VERI_MONGODB_SSL_ENABLED`                  | `false` |
| `sslKeyStore`           | The Key Storage name, stored in secrets object   | `VERI_MONGODB_SSL_KEYSTORE`                 | `""`    |
| `sslKeyStorePassword`   | The Key password, stored in secrets object       | `VERI_MONGODB_SSL_KEYSTORE_PASSWORD`        | `""`    |
| `sslTrustStore`         | The Trust Storage name, stored in secrets object | `VERI_MONGODB_SSL_TRUSTSTORE`               | `""`    |
| `sslTrustStorePassword` | The Trust password, stored in secrets object     | `VERI_MONGODB_SSL_TRUSTSTORE_PASSWORD`      | `""`    |
| `invalidHostAllowed`    | Used to configure hostname checking for mongo    | `VERI_MONGODB_SSL_INVALID_HOSTNAME_ALLOWED` | `true`  |

### `keycloak` Group

| Parameter        | Description                                                  | Environment Variable Mapping          | Default                    |
| ---------------- | ------------------------------------------------------------ | ------------------------------------- | -------------------------- |
| `host`           | Keycloak URL, typical format `http(s)://<host>{port}/{path}` | `VERI_ID_PROVIDER_HOST`               |                            |
| `port`           | Keycloak port, typically either `8080` or `8443`             | `VERI_ID_PROVIDER_PORT`               | `8080`                     |
| `realm`          | Accreditation realm in keycloak server                       | `VERI_ID_PROVIDER_REALM`              | `ssi-am-accreditation`     |
| `clientSecret`   | The `clientID` secret, stored in the secrets object          | `VERI_ID_PROVIDER_VERI_CLIENT_SECRET` |                            |
| `clientID`       | The keycloak client identifier                               | `VERI_ID_PROVIDER_VERI_CLIENT_ID`     | `accreditation-controller` |
| `sslTrustAll`    | Used to configure ssl trust between controller and keycloak  | `VERI_ID_PROVIDER_SSL_TRUST_ALL`      | `true`                     |
| `verifyHostname` | Used to configure keycloak host name verification            | `VERI_ID_PROVIDER_VERIFY_HOSTNAME`    | `false`                    |

### `agent` Group

| Parameter       | Description                                             | Environment Variable Mapping | Default                          |
| --------------- | ------------------------------------------------------- | ---------------------------- | -------------------------------- |
| `verkey`        | Agent verification key, stored i secrets object         | `VERI_AGENT_VERKEY`          |                                  |
| `webHookAPIKey` | Agent web-hook API Key, stored in secrets object        | `VERI_AGENT_WEBHOOK_API_KEY` |                                  |
| `APIKey`        | API Key for the aca-py issuer, stored in secrets object | `VERI_AGENT_API_KEY`         |                                  |
| `ariesAttachID` | Aries ID, stored in secrets object                      | `AGENT_ARIES_ATTACH_ID`      | `libindy-request-presentation-0` |
| `ariesType`     | Aries message type, stored in secrets object            | `AGENT_ARIES_MESSAGE_TYPE`   |                                  |
| `didcommURL`    | DID Comm URL, stored in configmap                       | `AGENT_DIDCOMM_URL`          | `didcomm://example.org?m=`       |
| `url`           | Issue aca-py agent url                                  | `VERI_AGENT_API_URL`         |                                  |
| `endpoint`      | Agent endpoint URL.                                     | `VERI_AGENT_ENDPOINT`        | `http://0.0.0.0:11000`           |
| `port`          | Port number for acapy agent, stored in config map       | `VERI_AGENT_PORT_ADMIN`      | `11080`                          |

### `ui` Group

| Parameter  | Description                                 | Environment Variable Mapping | Default                                     |
| ---------- | ------------------------------------------- | ---------------------------- | ------------------------------------------- |
| `host`     | Verification UI URL, stored in config map   | `VERI_UI_HOST`               | `http://<RELEASENAME>-ssi-verification-ui`  |
| `port`     | Port for UI Host, stored in config map      | `VERI_UI_PORT`               | `4300`                                      |
| `i18nPath` | Path for i18n translations                  | `ACCR_I18N_PATH`             | `4300`                                      |

### `info` Group

| Parameter      | Description                                 | Environment Variable Mapping | Default                   |
| -------------- | ------------------------------------------- | ---------------------------- | ------------------------- |
| `contactEmail` | Contact email address, stored in config map | `VERI_INFO_CONTACT_EMAIL`    |                           |
| `contactName`  | Contact name, stored in config map          | `VERI_INFO_CONTACT_NAME`     |                           |
| `contactURL`   | Contact URL, stored in config map           | `VERI_INFO_CONTACT_URL`      |                           |
| `description`  | Description, stored in config map           | `VERI_INFO_DESCRIPTION`      |                           |
| `title `       | Title, stored in config map                 | `VERI_INFO_TITLE`            | `Verification Controller` |

### `cors` Group

| Parameter | Description                                           | Environment Variable Mapping | Default |
| --------- | ----------------------------------------------------- | ---------------------------- | ------- |
| `hostA`   | Enable cors for this host (e.g. http(s)://url[:port]) | `VERI_ALLOWED_ORIGIN_HOST_A` |         |
| `hostB`   | Enable cors for this host (e.g. http(s)://url[:port]) | `VERI_ALLOWED_ORIGIN_HOST_B` |         |
| `hostC`   | Enable cors for this host (e.g. http(s)://url[:port]) | `VERI_ALLOWED_ORIGIN_HOST_C` |         |

### `employee` Group

| Parameter    | Description                                        | Environment Variable Mapping       | Default |
| ------------ | -------------------------------------------------- | ---------------------------------- | ------- |
| `name`       | Employee credential name for acapy agent and indy  | `EMPLOYEE_CREDENTIAL_NAME`         |         |
| `definition` | Employee credential for acapy agent and indy nodes | `EMPLOYEE_CREDENTIAL_DEFINITION`   |         |
| `schema`     | Employee db schema                                 | `EMPLOYEE_CREDENTIAL_SCHEMA`       |         |

### `basisid` Group

| Parameter        | Description                                       | Environment Variable Mapping          | Default |
| ---------------- | ------------------------------------------------- | ------------------------------------- | ------- |
| `devModeEnabled` | Development mode, only use for local docker usage | `VERI_BASIS_ID_VERIFICATION_DEV_MODE` | `false` |
| `definition`     | BasisId credential for acapy agent and indy nodes | `BDR_BASIS_ID_CREDENTIAL_DEFINITION`  |         |
| `schema`         | BasisId db schema                                 | `BDR_BASIS_ID_SCHEMA`                 |         |
| `name`           | BasisId credential name                           | `BDR_BASIS_ID_CREDENTIAL_NAME`        |         |

### `guest` Group

| Parameter            | Description                                        | Environment Variable Mapping           | Default                                                       |
| -------------------- | -------------------------------------------------- | -------------------------------------- | ------------------------------------------------------------- |
| `invitationRedirect` | Guest invitation redirect url, must include `{id}` | `VERI_EMAIL_GUEST_INVITATION_REDIRECT` | `http://<releasename>:8080/guest/invitation/redirect?id={id}` |
| `definition`         | Guest credential for acapy agent and indy nodes    | `GUEST_CREDENTIAL_DEFINITION`          |                                                               |
| `name`               | Guest credential for acapy agent and indy nodes    | `GUEST_CREDENTIAL_NAME`                |                                                               |
| `schema`             | Guest db schema                                    | `GUEST_CREDENTIAL_SCHEMA`              |                                                               |
| `checkoutDelay`      | Checkout delay in seconds                          | `VERI_CHECKOUT_DELAY_IN_SECONDS`       | `120`                                                         |

### `accreditation` Group

| Parameter        | Description                      | Environment Variable Mapping        | Default |
| ---------------- | -------------------------------- | ----------------------------------- | ------- |
| `webHookAPIKey`  | Web hook API key                 | `ACCR_AGENT_WEBHOOK_API_KEY`        |         |
| `url`            | Accreditation controller API URL | `ACCR_API_URL`                      |         |
| `sslTrustAll`    | SSL Trust all flag               | `VERI_ACCR_API_SSL_TRUST_ALL`       | `true`  |
| `verifyHostname` | Verify SSL hostname              | `VERI_ACCR_API_SSL_VERIFY_HOSTNAME` | `false` |
| `apiKey`         | Accreditation controller api key | `ACCR_API_KEY`                      |         |

### `email` Group

| Parameter | Description                      | Environment Variable Mapping | Default |
| --------- | -------------------------------- | ---------------------------- | ------- |
| `host`    | Email server host                | `VERI_EMAIL_SMTP_HOST`       |         |
| `port`    | Email server port                | `VERI_EMAIL_SMTP_PORT`       |         |
| `sender`  | Email sender address             | `VERI_EMAIL_SENDER`          |         |

### `swagger` Group

| Parameter | Description                                                                               | Environment Variable Mapping       | Default |
| --------- | ----------------------------------------------------------------------------------------- | ---------------------------------- | ------- |
| `host`    | Authorisation host for swagger ui page, must be format `"http(s)://host({port})/{path}/"` | `VERI_SWAGGER_UI_ID_PROVIDER_HOST` |         |

### `ssl` Group

| Parameter             | Description                            | Environment Variable Mapping            | Default |
| --------------------- | -------------------------------------- | --------------------------------------- | ------- |
| `enabled`             | Enables SSL for the controller service | `VERI_CONTROLLER_SSL_ENABLED`           | `false` |
| `sslKeyStore`         | SSL Keystore name                      | `VERI_CONTROLLER_SSL_KEYSTORE`          |         |
| `sslKeyStorePassword` | SSL Keystore password                  | `VERI_CONTROLLER_SSL_KEYSTORE_PASSWORD` |         |
| `sslKeyStoreType`     | SSL Keystore type                      | `VERI_CONTROLLER_SSL_KEYSTORE_TYPE`     |         |
| `sslKeyAlias`         | SSL Key alias                          | `VERI_CONTROLLER_SSL_KEY_ALIAS`         |         |

### `mongodb` Group

The full list of possible mongoDB helm values can be found at [Bitnami MongoDB Chart](https://github.com/bitnami/charts/tree/master/bitnami/mongodb/#installing-the-chart).  The key values, and there mappings, are detailed below.  By default the mongoDB chart is executed, unless the `enabled` variable is set to `false`, in which case all related values must point to a valid mongoDB database hosted elsewhere (e.g. cloud managed service).

| Parameter                  | Description                                                                              | Environment Variable Mapping  | Default                 |
| -------------------------- | ---------------------------------------------------------------------------------------- | ----------------------------- | ----------------------- |
| `enabled`                  | If `false` mongoDB chart is not executed                                                 | `VERI_CONTROLLER_SSL_ENABLED` | `false`                 |
| `host`                     | The host for mongoDB, if using chart leave blank                                         | `VERI_MONGODB_HOST`           | `<releasename>-mongodb` |
| `auth.rootUser`            | MongoDB Root username                                                                    | `VERO_MONGODB_USERNAME`       | `root`                  |
| `auth.rootPassword`        | MongoDB Root password, stored in secret                                                  | `VERI_MONGODB_PASSWORD`       |                         |
| `auth.username`            | MongoDB User, needed for chart creation. Not used by controller                          |                               | `mongouser`             |
| `auth.password`            | MongoDB password, needed for chart creation. Not used by controller, but must have value |                               |                         |
| `auth.database`            | MongoDB database, stored in configmap                                                    | `VERI_MONGODB_DB_NAME`        | `admin`                 |
| `auth.authDatabase`        | MongoDB authorisation database, stored in configmap                                      | `VERI_MONGODB_AUTH_DB_NAME`   | `admin`                 |
| `persistence.storageClass` | Kubernetes storage class for PVC                                                         |                               |                         |
| `persistence.size`         | PVC storage size to request                                                              |                               | `10Gi`                  |

### Defaulted Variables

These are typically expected to be left as defaults.  However, if they require being overridden then add the variables explicitly to the `overrides` value group, for example:

```yaml
overrides:
  VERI_MONGODB_PORT: 27018
```
Because of the dependancy on servivces such as keycloak, image build there are several variables which are not explicitly overwritten, or have values mappings.  The following is a list of those variables.

| Variable                             | Description                                                                               | Default                                                        |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `VERI_AGENT_NAME`                    | Use `overrides.VERI_AGENT_NAME` to override                                               | `Verification-Agent`                                           |
| `VERI_ID_PROVIDER_PERMISSIONS_PATH`  | This is a standard keycloak path, will only change for specific changes to authentication | `auth/realms/{realm}/protocol/openid-connect/token`            |
| `VERI_ID_PROVIDER_TOKEN_PATH`        | This is a keycloak path and will only be changed if the id provider is changed            | `auth/realms/{realm}/protocol/openid-connect/token/introspect` |
| `VERI_MONGODB_PORT`                  | Defaults to `27017`, override using `overrides.VERI_MONGODB_PORT`                         | `27017`                                                        |
| `SPRING_PROFILES_ACTIVE`             | This should nearly always be 'localdocker'                                                | `localdocker`                                                  |
| `VERI_JWT_USER_IDENTIFIER_ENTRY_NAME`| This will only change if keycloak is not used                                             | `preferred_username`                                           |
| `AGENT_API_KEY_HEADER_NAME`          | Use `overrides.AGENT_API_KEY_HEADER_NAME` to override                                     | `X-API-Key`                                                    |
| `ACCR_API_KEY_HEADER_NAME`           | Use `overrides.ACCR_API_KEY_HEADER_NAME` to override                                      | `X-API-Key`                                                    |
| `VERI_AGENT_PORT_ADMIN`              | Port number for acapy agent, exposed through the docker image                             | `11080`                                                        |

### `env` Group

This is a section in which custom variables can be inserted and added to the deployment resource.  It is intended to be used if the image has been rebuilt with additional variables, for example the source code has been downloaded and modified for a custom usage.  This allows the main helm chart to be used with the ability to support simple custom changes.  An example usage would be:

```yaml
env:
  MYCUSTOMVARIABLE: "hello"
```
