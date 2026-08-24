@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Value Help'
define view entity ZI_CDS_STATUS_LGO as select from zdt_status_lgo
{
    key status_code,
    status_description
}
