@EndUserText.label: 'Abstract Entity to change status'
define abstract entity ZI_CDS_CHANGE_STATUS_LGO
{
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CDS_STATUS_LGO', element: 'status_code' } }]
  new_status : zde_curr_status_lgo;
  text       : zde_text_lgo;
}
