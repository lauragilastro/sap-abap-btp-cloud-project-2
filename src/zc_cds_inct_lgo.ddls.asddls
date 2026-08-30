@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'consumption entity'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_CDS_INCT_LGO as projection on ZI_CDS_INCT_LGO

{
    key inc_uuid,
    incident_id,
    title,
    description,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CDS_STATUS_LGO', element: 'status_code' } }]
    status,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CDS_PRIORITY_LGO', element: 'priority_code' } }]
    priority,
    responsible,
    creation_date,
    changed_date,
    local_created_by,
    local_created_at,
    local_last_changed_by,
    local_last_changed_at,
    last_changed_at,
    _toHistory: redirected to composition child ZC_CDS_INCT_H_LGO,
    _toCdsstatus,
    _toCdspriority
}
