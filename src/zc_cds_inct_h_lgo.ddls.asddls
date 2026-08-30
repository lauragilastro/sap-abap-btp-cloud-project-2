@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption entity for history'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_CDS_INCT_H_LGO as projection on ZI_CDS_INCT_H_LGO

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
    _toInct: redirected to parent ZC_CDS_INCT_LGO
}
