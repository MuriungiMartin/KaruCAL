#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5993 "Troubleshooting Setup"
{
    Caption = 'Troubleshooting Setup';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Troubleshooting Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of troubleshooting issue.';
                    Visible = TypeVisible;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of an item, service item, or service item group code, based on the Type field.';
                    Visible = NoVisible;
                }
                field("Troubleshooting No.";"Troubleshooting No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the troubleshooting issue.';
                }
                field("Troubleshooting Description";"Troubleshooting Description")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies a description of the troubleshooting issue.';
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
        area(navigation)
        {
            group("T&roublesh.")
            {
                Caption = 'T&roublesh.';
                Image = Setup;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        Clear(Tblshtg);
                        if TblshtgHeader.Get("Troubleshooting No.") then
                          if "No." <> '' then begin
                            Tblshtg.SetCaption(Format(Type),"No.");
                            Tblshtg.SetRecord(TblshtgHeader);
                          end;

                        Tblshtg.Run;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        NoVisible := true;
        TypeVisible := true;
    end;

    trigger OnOpenPage()
    begin
        TypeVisible := GetFilter(Type) = '';
        NoVisible := GetFilter("No.") = '';

        if (GetFilter(Type) <> '') and (GetFilter("No.") <> '') then begin
          xRec.Validate(Type,GetRangeMin(Type));
          xRec.Validate("No.",GetRangeMin("No."));
        end;
    end;

    var
        TblshtgHeader: Record "Troubleshooting Header";
        Tblshtg: Page Troubleshooting;
        [InDataSet]
        TypeVisible: Boolean;
        [InDataSet]
        NoVisible: Boolean;
}

