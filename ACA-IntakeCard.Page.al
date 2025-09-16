#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68513 "ACA-Intake Card"
{
    PageType = Card;
    SourceTable = UnknownTable61383;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Current;Current)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrentOnPush;
                    end;
                }
                field("Reporting Date";"Reporting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Reporting End Date";"Reporting End Date")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        IntakeRec: Record UnknownRecord61383;

    local procedure CurrentOnPush()
    begin
           if Current=true then begin
           if Confirm('Do you really want to make '+Code+' as the current Intake?') then begin
           IntakeRec.Reset;
           if IntakeRec.Find('-') then begin
           repeat
           if IntakeRec.Code<>Code then begin
           IntakeRec.Current:=false;
           IntakeRec.Modify;
           end;
           until IntakeRec.Next=0;
           end;
           end;
          end;
    end;
}

