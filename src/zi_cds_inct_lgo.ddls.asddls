@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident table CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_CDS_INCT_LGO as select from zdt_inct_lgo

composition [0..*] of ZI_CDS_INCT_H_LGO as _toHistory

{
    key inc_uuid,
    incident_id,
    title,
    description,
    status,
    priority,
    creation_date,
    changed_date,
    local_created_by,
    local_created_at,
    local_last_changed_by,
    local_last_changed_at,
    last_changed_at,
    _toHistory
}
