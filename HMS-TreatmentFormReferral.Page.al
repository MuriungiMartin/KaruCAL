#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68576 "HMS-Treatment Form Referral"
{
    PageType = ListPart;
    SourceTable = UnknownTable61415;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Date Referred";"Date Referred")
                {
                    ApplicationArea = Basic;
                }
                field("Hospital No.";"Hospital No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Hospital Name";"Hospital Name")
                {
                    ApplicationArea = Basic;
                }
                field("Contact person";"Contact person")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Referral Reason";"Referral Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Referral Remarks";"Referral Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Register Referral")
            {
                ApplicationArea = Basic;
                Caption = '&Register Referral';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Register Referral?',false)=false then begin exit end;

                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get("Treatment No.") then
                      begin
                        Referral.Init;
                          Referral."Treatment no.":="Treatment No.";
                          Referral."Hospital No.":="Hospital No.";
                          Referral."Patient No.":=TreatmentHeader."Patient No.";
                          Referral."Date Referred":="Date Referred";
                          Referral."Referral Reason":="Referral Reason";
                          Referral."Referral Remarks":="Referral Remarks";
                        Referral.Insert();
                      end;
                end;
            }
        }
    }

    var
        Referral: Record UnknownRecord61433;
        TreatmentHeader: Record UnknownRecord61407;
}

