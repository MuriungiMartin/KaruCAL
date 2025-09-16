#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9088 "Service Item Line FactBox"
{
    Caption = 'Service Item Line Details';
    PageType = CardPart;
    SourceTable = "Service Item Line";

    layout
    {
        area(content)
        {
            field("Service Item No.";"Service Item No.")
            {
                ApplicationArea = Basic;
                Lookup = false;
                ToolTip = 'Specifies the service item number registered in the Service Item table.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(ComponentList;StrSubstNo('%1',ServInfoPaneMgt.CalcNoOfServItemComponents(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Component List';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.ShowServItemComponents(Rec);
                end;
            }
            field(Troubleshooting;StrSubstNo('%1',ServInfoPaneMgt.CalcNoOfTroubleshootings(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Troubleshooting';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.ShowTroubleshootings(Rec);
                end;
            }
            field(SkilledResources;StrSubstNo('%1',ServInfoPaneMgt.CalcNoOfSkilledResources(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Skilled Resources';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ServInfoPaneMgt.ShowSkilledResources(Rec);
                end;
            }
        }
    }

    actions
    {
    }

    var
        ServInfoPaneMgt: Codeunit "Service Info-Pane Management";

    local procedure ShowDetails()
    var
        ServiceItem: Record "Service Item";
    begin
        if ServiceItem.Get("Service Item No.") then
          Page.Run(Page::"Service Item Card",ServiceItem);
    end;
}

