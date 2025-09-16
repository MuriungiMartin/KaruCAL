#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5840 "Standard Cost Worksheet Names"
{
    Caption = 'Standard Cost Worksheet Names';
    PageType = List;
    SourceTable = "Standard Cost Worksheet Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the worksheet.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the worksheet.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Edit Worksheet';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    StdCostWksh."Standard Cost Worksheet Name" := Name;
                    Page.Run(Page::"Standard Cost Worksheet",StdCostWksh);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not StdCostWkshName.FindFirst then begin
          StdCostWkshName.Init;
          StdCostWkshName.Name := Text001;
          StdCostWkshName.Description := Text001;
          StdCostWkshName.Insert;
        end;
    end;

    var
        StdCostWkshName: Record "Standard Cost Worksheet Name";
        Text001: label 'Default';
        StdCostWksh: Record "Standard Cost Worksheet";
}

