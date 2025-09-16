#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 295 "Req. Wksh. Names"
{
    Caption = 'Req. Wksh. Names';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = "Requisition Wksh. Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the requisition worksheet you are creating.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a brief description of the requisition worksheet name you are creating.';
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
                    ReqJnlManagement.TemplateSelectionFromBatch(Rec);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SetRange("Worksheet Template Name");
    end;

    trigger OnOpenPage()
    begin
        ReqJnlManagement.OpenJnlBatch(Rec);
    end;

    var
        ReqJnlManagement: Codeunit ReqJnlManagement;

    local procedure DataCaption(): Text[250]
    var
        ReqWkshTmpl: Record "Req. Wksh. Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Worksheet Template Name") <> '' then
            if GetRangeMin("Worksheet Template Name") = GetRangemax("Worksheet Template Name") then
              if ReqWkshTmpl.Get(GetRangeMin("Worksheet Template Name")) then
                exit(ReqWkshTmpl.Name + ' ' + ReqWkshTmpl.Description);
    end;
}

