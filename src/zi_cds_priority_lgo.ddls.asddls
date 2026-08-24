@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Priority Value Help'
define view entity ZI_CDS_PRIORITY_LGO as select from zdt_priority_lgo
{
    key priority_code,
    priority_description
}
