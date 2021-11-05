# Verification UI

This contains a chart to deploy the SSI Access Management Verification UI image.

Edit the values file to the values required.

1. The `ACCREDITATION_CONTROLLER_BASE_URL` should be set to the correct location of the accreditation controller service, with the correct route (e.g. `/api/v2`)
2. The `KEYCLOAK_URL` should be set to the correct host for keycloak and `/auth` must be appended

If ingress is enabled it is recommended that a `tls_secret` be set so `https` routes can be created.

## Values Notes

The following sections will break down into the specific value groups that relate to the environment variables used to drive service behaviour.  All other settings are standard kubernetes helm settings and the relevant documentation should be referenced.  Values are saved in either a secrets object, config map or as a standard deployment variable.  If not explicitly mentioned it should be assumed to be in the deployment environment specification.

### `keycloak` Group

| Parameter        | Description                                                | Variable Mapping     | Config File Mapping                   | Default               |
| ---------------- | ---------------------------------------------------------- | -------------------- | ------------------------------------- | --------------------- |
| `url`            | Keycloak URL, typical format `http(s)://<host>{port}/auth` | `KEYCLOAK_URL`       | `VERI_ID_PROVIDER_FRONTEND_URL`       |                       |
| `realm`          | Verification realm in keycloak server                      | `KEYCLOAK_REALM`     | `VERI_ID_PROVIDER_REALM `             | `ssi-am-verification` |
| `clientID`       | The keycloak client identifier                             | `KEYCLOAK_CLIENT_ID` | `VERI_ID_PROVIDER_VERI_UI_CLIENT_ID ` | `verification-ui`     |

### `verification` Group

| Parameter        | Description                                                                                                               | Environment Variable Mapping        | Default                                                         |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- | --------------------------------------------------------------- |
| `url`            | Verification controller URL, this is issued directly from the browser so a public url is expected, with `/api/v2` suffix | `VERIFICATION_CONTROLLER_BASE_URL` | `http://<releasename>-ssi-verification-controller:8080/api/v2` |
| `qrBaseURL`      | Verification URL, this is issued directly from the browser so a public url is expected, with `/api/v2` suffix | `QR_CODE_BASE_URL` | |

