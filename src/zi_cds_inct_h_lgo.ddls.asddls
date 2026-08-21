@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'History table CDS'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CDS_INCT_H_LGO as select from zdt_inct_h_lgo

association to parent ZI_CDS_INCT_LGO as _toInct on $projection.inc_uuid = _toInct.inc_uuid

{
    key his_uuid,
    key inc_uuid,
    his_id,
    previous_status,
    new_status,
    text,
    local_created_by,
    local_created_at,
    local_last_changed_by,
    local_last_changed_at,
    last_changed_at,
    _toInct
}
