@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Incident table CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_CDS_INCT_LGO as select from zdt_inct_lgo

composition [0..*] of ZI_CDS_INCT_H_LGO as _toHistory

association to ZI_CDS_STATUS_LGO as _toCdsstatus on $projection.status = _toCdsstatus.status_code
association to ZI_CDS_PRIORITY_LGO as _toCdspriority on $projection.priority = _toCdspriority.priority_code

{
    key inc_uuid,
    incident_id,
    title,
    description,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CDS_STATUS_LGO', element: 'status_code' } }]
    status,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CDS_PRIORITY_LGO', element: 'priority_code' } }]
    priority,
    creation_date,
    changed_date,
    local_created_by,
    local_created_at,
    local_last_changed_by,
    local_last_changed_at,
    last_changed_at,
    _toHistory,
    _toCdsstatus,
    _toCdspriority
}
