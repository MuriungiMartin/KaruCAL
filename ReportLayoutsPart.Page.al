#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9653 "Report Layouts Part"
{
    Caption = 'Report Layouts Part';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Custom Report Layout";
    SourceTableView = sorting("Report ID","Company Name",Type);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the report layout.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the file type of the report layout. The following table includes the types that are available:';
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the Microsoft Dynamics NAV company that the report layout applies to. You to create report layouts that can only be used on reports when they are run for a specific to a company. If the field is blank, then the layout will be available for use in all companies.';
                    Width = 10;
                }
            }
        }
    }

    actions
    {
    }
}

